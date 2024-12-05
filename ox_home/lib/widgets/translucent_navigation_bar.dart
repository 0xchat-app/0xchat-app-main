library dot_navigation_bar;

export 'translucent_navigation_bar_item.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:ox_common/business_interface/ox_chat/interface.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_chat_observer.dart';
import 'package:ox_common/utils/ox_moment_manager.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/platform_utils.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/took_kit.dart';
import 'package:ox_common/utils/user_config_tool.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_home/model/home_tabbar_type.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:ox_theme/ox_theme.dart';
import 'package:rive/rive.dart' as river;
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'translucent_navigation_bar_item.dart';
import 'package:flutter/src/painting/gradient.dart' as gradient;

import 'package:chatcore/chat-core.dart';
import 'package:flutter/services.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/model/msg_notification_model.dart';
import 'package:ox_home/widgets/translucent_navigation_bar.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';


class TranslucentNavigationBar extends StatefulWidget {
  /// Height of the appbar
  final double height;

  /// Border radius of the appbar
  final double borderRadius;

  /// Blur extent of the appbar
  final double blur;

  /// Padding on the top and bottom of AppBar
  final double? verticalPadding;

  /// Padding on the left and right sides of AppBar
  final double? horizontalPadding;

  /// Returns the index of the tab that was tapped.
  final Function(int,int)? onTap;

  final Function(int,int)? handleDoubleTap;

  /// Main icon background color in middle of appbar
  final Color mainIconBackgroundColor;

  /// Main icon  color in middle of appbar
  final Color mainIconColor;

  /// Main icon function on tap
  final Function()? onMainIconTap;

  const TranslucentNavigationBar({
    super.key,
    this.mainIconBackgroundColor = Colors.blue,
    this.mainIconColor = Colors.white,
    required this.onTap,
    this.onMainIconTap,
    this.handleDoubleTap,
    this.height = 72.0,
    this.borderRadius = 24.0,
    this.blur = 2, // You use 5 for black and 1 for white
    this.verticalPadding,
    this.horizontalPadding,
  });

  @override
  State<TranslucentNavigationBar> createState() => TranslucentNavigationBarState();
}

class TranslucentNavigationBarState extends State<TranslucentNavigationBar> with OXUserInfoObserver, OXChatObserver, OXMomentObserver, TickerProviderStateMixin, WidgetsBindingObserver {
  bool isLogin = false;
  Timer? _refreshMessagesTimer;
  int selectedIndex = 1;
  double middleIndex = (4 / 2).floorToDouble();

  final List<TranslucentNavigationBarItem> _itemList = [];

  bool get isDark => ThemeManager.getCurrentThemeStyle() == ThemeStyle.dark;
  late List<HomeTabBarType> _typeList;
  // State machine
  List<String> riveInputs = [];
  List<river.StateMachineController?> riveControllers = [];
  List<river.Artboard?> riveArtboards = [];
  final Map<HomeTabBarType, int> _unreadMap = {};

  List<GlobalKey> _navItemKeyList = [];
  List<TabbarMenuModel> _userCacheList = [];
  TabbarMenuModel? _currentUser;

  late AnimationController _animationController;
  late Animation<double> _animation;

  late double _horizontalPadding;
  late double _verticalPadding;
  double _dialogItemWidth = 180.px;

  void updateOffset(double offset) {
    _animationController.value = offset;
  }

  bool getAnimStatus() {
    return _animationController.isAnimating;
  }

  void executeAnim({bool isReverse = false, double fromValue = 0}) {
    if (isReverse) {
      _animationController.reverse(from: fromValue);
    } else {
      _animationController.forward(from: fromValue);
    }
  }

  @override
  void initState() {
    super.initState();
    isLogin = OXUserInfoManager.sharedInstance.isLogin;
    OXUserInfoManager.sharedInstance.addObserver(this);
    OXChatBinding.sharedInstance.addObserver(this);
    OXMomentManager.sharedInstance.addObserver(this);
    ThemeManager.addOnThemeChangedCallback(onThemeStyleChange);
    _horizontalPadding = widget.horizontalPadding ?? 20.px;
    _verticalPadding = widget.verticalPadding ?? 24.px;
    if (OXUserInfoManager.sharedInstance.momentPosition == 1) {
      _typeList = [HomeTabBarType.home, HomeTabBarType.contact, HomeTabBarType.discover, HomeTabBarType.me];
    } else {
      _typeList = [HomeTabBarType.contact, HomeTabBarType.home, HomeTabBarType.me];
    }
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _animation = Tween<double>(begin: 0.0, end: 72 + 24.px).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    prepareMessageTimer();
    dataInit();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    clearRefreshMessagesTimer();
    OXUserInfoManager.sharedInstance.removeObserver(this);
    OXChatBinding.sharedInstance.removeObserver(this);
    OXMomentManager.sharedInstance.removeObserver(this);
    _animationController.dispose();
    super.dispose();
  }

  onThemeStyleChange() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadLocalInfo() async {
    UserDBISAR? currentUser = OXUserInfoManager.sharedInstance.currentUserInfo;
    if (currentUser != null) {
      //update user list
      await UserConfigTool.saveUser(currentUser);
    }
    Map<String, MultipleUserModel> currentUserMap = await UserConfigTool.getAllUser();
    _userCacheList = currentUserMap.values.map((e) {
      return TabbarMenuModel(type: MenuItemType.userType, name: e.name, picture: e.picture, dns: e.dns, pubKey: e.pubKey);
    }).toList();
    if (_userCacheList.isNotEmpty) {
      _userCacheList.insert(0, TabbarMenuModel(type: MenuItemType.addUserType, name: Localized.text('ox_usercenter.str_add_account')));
    }
    final int currentIndex = _userCacheList.indexWhere((user) => user.pubKey == (currentUser?.pubKey ?? ''));
    if (currentIndex != -1) {
      _currentUser = _userCacheList.removeAt(currentIndex);
    }
  }

  _showLoginPage(BuildContext context) {
    OXModuleService.pushPage(
      context,
      "ox_login",
      "LoginPage",
      {},
    );
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: _verticalPadding,
              horizontal: _horizontalPadding,
            ),
            height: widget.height,
            // width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(widget.height),
              boxShadow: const [
                BoxShadow(
                  // color: Color(0x7FE3E3E3), // Daytime pattern
                  color: Color(0x33141414), // Dark mode
                  offset: Offset(
                    3.0,
                    1.0,
                  ),
                  blurRadius: 20.0,
                  spreadRadius: 1.0,
                  // blurStyle: BlurStyle.solid
                ),
              ],
            ),
            child: createTabContainer(_itemList, middleIndex),
          ),);
      },
    );

  }

  Widget createTabContainer(
      List<TranslucentNavigationBarItem> updatedItems, double middleIndex) {
    return GlassmorphicContainer(
      borderRadius: widget.borderRadius,
      blur: widget.blur,
      alignment: Alignment.bottomCenter,
      border: 0.5,
      linearGradient: gradient.LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            // Daytime pattern
            isDark ? const Color(0xB2444444) : const Color(0xB2FFFFFF),
            isDark ? const Color(0xB2444444) : const Color(0xB2FFFFFF),
          ],
          stops: const [
            0.1,
            1,
          ]),
      borderGradient: gradient.LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          isDark ?  const Color(0x0c595959) :  const Color(0x66F5F5F5),
          isDark ?  const Color(0x0c595959) : const Color(0x66F5F5F5),
          isDark ?  const Color(0x0c595959) : const Color(0x66F5F5F5),
          isDark ?  const Color(0x0c595959) : const Color(0x66F5F5F5),
        ],
      ),
      height: widget.height,
      width: PlatformUtils.listWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (final item in updatedItems)
            GestureDetector(
              onLongPress: () {
                _tabbarItemOnLongPress(item);
              },
              onTap: () {
                _tabBarItemOnTap(item);
              },
              onDoubleTap: updatedItems.indexOf(item) == selectedIndex ? () {
                widget.handleDoubleTap?.call(updatedItems.indexOf(item),selectedIndex);
              } : null,
              behavior: HitTestBehavior.translucent,
              child: _tabbarItemWidget(item, _navItemKeyList[updatedItems.indexOf(item)]),
            ),
        ],
      ),
    );
  }

  void _tabbarItemOnLongPress(TranslucentNavigationBarItem item){
    int index = _itemList.indexOf(item);
    TookKit.vibrateEffect();
    _showPopupDialog(context, index);
  }

  void _tabBarItemOnTap(TranslucentNavigationBarItem item) {
    int draftIndex = selectedIndex;
    int index = _itemList.indexOf(item);
    if (selectedIndex != index) {
      TookKit.vibrateEffect();
    }
    if (!OXUserInfoManager.sharedInstance.isLogin && (index == 2)) {
      _showLoginPage(context);
      return;
    }
    if (draftIndex == index) return;
    setState(() {
      selectedIndex = index;
      if (OXUserInfoManager.sharedInstance.isLogin) {
        fetchUnreadCount();
      }
    });
    clearRefreshMessagesTimer();

    widget.onTap!.call(index,draftIndex);

    for (int i = 0; i < _typeList.length; i++) {
      final controller = riveControllers[i];
      final input = controller?.findInput<bool>(riveInputs[i]);
      if (input != null && input.value) {
        input.value = false;
      }
    }
    final input = riveControllers[index]?.findInput<bool>(riveInputs[index]);
    if (input != null) {
      input.value = true;
    }
  }

  Widget _tabbarItemWidget(
      TranslucentNavigationBarItem item, GlobalKey tabbarKey) {
    return Container(
      key: tabbarKey,
      padding: EdgeInsets.symmetric(horizontal: 15.px),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: widget.height,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    bottom: Adapt.px(2),
                  ),
                  width: Adapt.px(24),
                  child: Stack(
                    children: [_getMyTabBarIcon(item)],
                  ),
                ),
                _getTabBarTitle(item),
              ],
            ),
          ),
          Positioned(
            bottom: Adapt.px(6),
            child: _promptWidget(item),
          ),
        ],
      ),
    );
  }

  Widget _promptWidget(TranslucentNavigationBarItem item) {
    if (item.unreadMsgCount > 0) {
      return _iconContainer('unread_dot');
    }
    return Container();
  }

  Widget _iconContainer(String iconName) {
    return Container(
      color: Colors.transparent,
      width: Adapt.px(6),
      height: Adapt.px(6),
      child: Image(
        image: AssetImage("assets/images/$iconName.png"),
      ),
    );
  }

  Widget _getMyTabBarIcon(TranslucentNavigationBarItem item) {
    if(item.artboard != null){
      return  SizedBox(
        width: Adapt.px(24),
        height: Adapt.px(24),
        child: river.Rive(artboard: item.artboard!),
      );
    }
    return const SizedBox();

  }

  Widget _getTabBarTitle(TranslucentNavigationBarItem item) {
    final title = item.title?.call();
    if (title == null || title.isEmpty) return const SizedBox();
    return Text(
      title,
      style: TextStyle(
          fontSize: Adapt.px(10), fontWeight: FontWeight.w600,color: _itemList.indexOf(item) == selectedIndex ? ThemeColor.gradientMainStart : ThemeColor.color100),
    );
  }

  Future<void> _loadRiveFile(int index) async {
    String animPath = "packages/ox_home/assets/${ThemeManager.images(_typeList[index].riveFileNames)}.riv";

    final data = await rootBundle.load(animPath);
    final file = river.RiveFile.import(data);
    final artboard = file.mainArtboard;

    river.StateMachineController? controller = river.StateMachineController.fromArtboard(artboard, _typeList[index].stateMachineNames);
    if (controller != null) {
      artboard.addController(controller);
      riveControllers[index] = controller;
      riveArtboards[index] = artboard;
    }
  }

  @override
  void didPromptToneCallBack(MessageDBISAR message, int type) {
    if (_itemList.isEmpty) return;
    if(type == ChatType.chatSecretStranger || type == ChatType.chatStranger){
      _itemList.elementAt(_typeList.indexOf(HomeTabBarType.home)).unreadMsgCount += 1;
    } else {
      // _tabBarList[0].unreadMsgCount += 1;
    }
    setState(() {});
  }

  @override
  void didLoginSuccess(UserDBISAR? userInfo) {
    setState(() {
      isLogin = true;
      fetchUnreadCount();
      if (_itemList.isNotEmpty) {
        _tabBarItemOnTap(_itemList.elementAt(_typeList.indexOf(HomeTabBarType.home)));
        for (var element in _itemList) {
          element.unreadMsgCount = 0;
        }
      }
    });
  }

  @override
  void didLogout() {
    setState(() {
      isLogin = false;
      if (_itemList.isNotEmpty) {
        _tabBarItemOnTap(_itemList.elementAt(_typeList.indexOf(HomeTabBarType.home)));
        for (var element in _itemList) {
          element.unreadMsgCount = 0;
        }
      }
    });
  }

  @override
  void didSwitchUser(UserDBISAR? userInfo) {
    setState(() {
      if (_itemList.isNotEmpty) {
        _tabBarItemOnTap(_itemList.elementAt(_typeList.indexOf(HomeTabBarType.home)));
        for (var element in _itemList) {
          element.unreadMsgCount = 0;
        }
      }
    });
  }

  @override
  void didZapRecordsCallBack(ZapRecordsDBISAR zapRecordsDB) {
    super.didZapRecordsCallBack(zapRecordsDB);
    if (_itemList.isEmpty || !mounted) return;
    setState(() {
      _itemList.elementAt(_typeList.indexOf(HomeTabBarType.me)).unreadMsgCount = 1;
    });
  }

  @override
  void didMoveToTabBarCallBack() {
    _typeList = [HomeTabBarType.home, HomeTabBarType.contact, HomeTabBarType.discover, HomeTabBarType.me];
    dataInit();
  }

  @override
  void didMoveToTopCallBack() {
    _typeList = [HomeTabBarType.contact, HomeTabBarType.home, HomeTabBarType.me];
    dataInit();
  }

  @override
  void didDeleteMomentsCallBack() {
    _typeList = [HomeTabBarType.contact, HomeTabBarType.home, HomeTabBarType.me];
    dataInit();
  }

  Future<void> dataInit() async {
    List<int> tempList = [];
    riveControllers = List<river.StateMachineController?>.filled(_typeList.length, null);
    riveArtboards = List<river.Artboard?>.filled(_typeList.length, null);
    riveInputs.clear();
    _navItemKeyList.clear();
    _itemList.clear();
    _navItemKeyList.clear();
    for(int i = 0; i < _typeList.length; i++){
      tempList.add(i);
      riveInputs.add('Press');
      HomeTabBarType homeTabBarType = _typeList[i];
      if (_unreadMap[homeTabBarType] == null) {
        _unreadMap[homeTabBarType] = 0;
      }
      _navItemKeyList.add(GlobalKey());
    }
    await Future.forEach(tempList, (element) async {
      await _loadRiveFile(element);
    });
    int homeIndex = _typeList.indexOf(HomeTabBarType.home);
    selectedIndex = homeIndex;
    for (int i = 0; i < _typeList.length; i++) {
      final controller = riveControllers[i];
      final input = controller?.findInput<bool>(riveInputs[i]);
      if (input != null && input.value) {
        input.value = false;
      }
    }
    if (riveControllers[homeIndex] != null) {
      final input = riveControllers[homeIndex]!.findInput<bool>(riveInputs[homeIndex]);
      if (input != null) input.value = true;
    }
    for(int i = 0; i < _typeList.length; i++){
      _itemList.add(TranslucentNavigationBarItem(
          title: () => Localized.text('ox_home.${_typeList[i].riveFileNames}'),
          artboard: riveArtboards[i],
          animationController: riveControllers[i],
          unreadMsgCount: _typeList[i] == HomeTabBarType.me ? (UserConfigTool.getSetting(StorageSettingKey.KEY_ZAP_BADGE.name, defaultValue: false) ? 1 : 0) : _unreadMap[_typeList[i]] ?? 0)
      );
    }

    setState(() {
      if (OXUserInfoManager.sharedInstance.isLogin) {
        fetchUnreadCount();
      }
    });
  }

  fetchUnreadCount() {
    // if (_tabBarList.isEmpty) return;
    // if (OXChatBinding.sharedInstance.unReadStrangerSessionCount > 0) {
    //   // _tabBarList[0].unreadMsgCount = 1;
    // } else {
    //   _tabBarList[0].unreadMsgCount = 0;
    // }
  }

  void prepareMessageTimer() async {
    clearRefreshMessagesTimer();
    _refreshMessagesTimer = Timer.periodic(const Duration(milliseconds: 3 * 1000), (timer) {
      fetchUnreadCount();
      if (mounted) setState(() {});
    });
  }

  void clearRefreshMessagesTimer(){
    _refreshMessagesTimer?.cancel();
    _refreshMessagesTimer = null;
  }

  bool updateNotificationListener(MsgNotification notification){
    if (notification.msgNum != null) {
      if (_itemList.isNotEmpty) {
        _itemList[_typeList.indexOf(HomeTabBarType.home)].unreadMsgCount = notification.msgNum! > 0 ? 1 : 0;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {});
        });
      } else {
        _unreadMap[HomeTabBarType.home] = notification.msgNum! > 0 ? 1 : 0;
      }
    } else if (notification.noticeNum != null) {
      if (_itemList.isNotEmpty) {
        _itemList[_typeList.indexOf(HomeTabBarType.me)].unreadMsgCount = notification.noticeNum! > 0 ? 1 : 0;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {});
        });
      } else {
        _unreadMap[HomeTabBarType.me] = notification.msgNum! > 0 ? 1 : 0;
      }
    }
    return true; //
  }

  void _showPopupDialog(BuildContext context, int index) async {
    if (_typeList.elementAt(index) == HomeTabBarType.me) {
      await _loadLocalInfo();
    }
    final RenderBox renderBox =
        _navItemKeyList[index].currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    List<TabbarMenuModel> menuList = _getMenuList(index);
    if (menuList.isEmpty) return;
    double leftPosition = _calculateDialogPosition(context, index, position, renderBox);
    double screenHeight = MediaQuery.of(context).size.height;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (context, animation, secondaryAnimation) {
        return StatefulBuilder(builder: (context, setState){
          return Stack(
            children: [
              Positioned(
                top: position.dy,
                left: position.dx,
                child: Material(
                  color: Colors.transparent,
                  child: _tabbarItemWidget(_itemList.elementAt(index), GlobalKey()),
                ),
              ),
              Positioned(
                bottom: screenHeight - position.dy + 4.px + (_typeList.elementAt(index) == HomeTabBarType.me ? 46.px : 0),
                left: leftPosition,
                child: Container(
                  width: _dialogItemWidth,
                  height: menuList.length * 44.px,
                  constraints: BoxConstraints(maxHeight: screenHeight/2),
                  decoration: BoxDecoration(
                    color: ThemeColor.color180,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.px),
                        topRight: Radius.circular(16.px),
                        bottomLeft: Radius.circular(_typeList.elementAt(index) == HomeTabBarType.me ? 0 : 16.px),
                        bottomRight: Radius.circular(_typeList.elementAt(index) == HomeTabBarType.me ? 0 : 16.px)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8.px,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: menuList.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, menuIndex) {
                      TabbarMenuModel? model;
                      if (menuList.isNotEmpty && menuIndex > -1) {
                        model = menuList[menuIndex];
                      }
                      return _menuItemView(index, model);
                    },
                  ),

                ),
              ),
              Visibility(
                visible: _typeList.elementAt(index) == HomeTabBarType.me,
                child: Positioned(
                  bottom: screenHeight - position.dy + 4.px,
                  left: leftPosition,
                  child: Container(
                    width: _dialogItemWidth,
                    height: 46.px,
                    constraints: BoxConstraints(maxHeight: screenHeight/2),
                    decoration: BoxDecoration(
                      color: ThemeColor.color180,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16.px),
                          bottomRight: Radius.circular(16.px)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8.px,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(height: 2.px, color: ThemeColor.color200),
                      _menuItemView(_typeList.indexOf(HomeTabBarType.me), _currentUser),
                    ],
                  ),),
                ),
              ),
            ],
          );
        });
      },
    );
  }

  Widget _menuItemView(int index, TabbarMenuModel? model){
    String showName = model?.name ?? '';
    String showPicture = model?.picture ?? '';
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (model != null) {
          _menuOnTap(context, model);
        }
      },
      child: Container(
        height: 44.px,
        padding: EdgeInsets.symmetric(horizontal: 16.px),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              showName,
              style: TextStyle(
                fontSize: 16.px,
                color: ThemeColor.color100,
                fontWeight: FontWeight.w500,
              ),
            ),
            _typeList.elementAt(index) == HomeTabBarType.me
                ? (showName ==
                Localized.text(
                    'ox_usercenter.str_add_account')
                ? CommonImage(
              iconName: 'add_circle_icon.png',
              size: 24.px,
              package: 'ox_common',
              useTheme: true,
            )
                : OXUserAvatar(
                imageUrl: showPicture, size: 24.px))
                : CommonImage(
                iconName: model?.picture ?? '',
                size: model != null && (model.type == MenuItemType.addContact || model.type == MenuItemType.addGroup) ? 18.px : 24.px,
                color: ThemeColor.color100,
                package: model?.iconPackage).setPadding(EdgeInsets.only(right: model != null && (model.type == MenuItemType.addContact || model.type == MenuItemType.addGroup) ? 6.px : 0)),
          ],
        ),
      ),
    );
  }

  double _calculateDialogPosition(BuildContext context, int index, Offset position, RenderBox renderBox) {
    final size = renderBox.size;
    final currentWidth = size.width;
    double dialogOffset;
    switch (index) {
      case 0:
        dialogOffset = position.dx - 40;
        break;
      case 1:
        dialogOffset = position.dx - 40;
        break;
      case 2:
        dialogOffset = position.dx - 86;
        break;
      default:
        dialogOffset = position.dx;
    }
    return dialogOffset;
  }

  List<TabbarMenuModel> _getMenuList(int index) {
    HomeTabBarType tabBarType = _typeList.elementAt(index);
    List<TabbarMenuModel> list = [];
    switch(tabBarType){
      case HomeTabBarType.contact:
        list.add(TabbarMenuModel(type: MenuItemType.addContact, name: Localized.text('ox_common.str_add_friend'), picture: 'icon_new_friend.png', iconPackage: 'ox_common'));
        list.add(TabbarMenuModel(type: MenuItemType.addGroup, name: Localized.text('ox_chat.str_new_group'), picture: 'icon_new_group.png', iconPackage: 'ox_common'));
        break;
      case HomeTabBarType.home:
        int unReadCount = OXChatBinding.sharedInstance.getAllSessionUnReadCount();
        if (unReadCount > 0) {
          list.add(TabbarMenuModel(type: MenuItemType.markToRead, name: Localized.text('ox_chat.str_all_chats_mark_as_read'), picture: 'icon_chat_mark_as_read.png', iconPackage: 'ox_chat'));
        }
        break;
      case HomeTabBarType.me:
        list = _userCacheList.toList();
        break;
      case HomeTabBarType.discover:
        list.add(TabbarMenuModel(type: MenuItemType.moveToTop, name: Localized.text('ox_chat.str_move_to_top'), picture: 'icon_moments_movetop.png', iconPackage: 'ox_chat'));
        list.add(TabbarMenuModel(type: MenuItemType.deleteMoments, name: Localized.text('ox_chat.delete'), picture: 'icon_chat_delete.png', iconPackage: 'ox_chat'));
        break;
    }

    return list;
  }

  void _menuOnTap(BuildContext context, TabbarMenuModel model) async {
    OXNavigator.pop(context);
    switch(model.type){
      case MenuItemType.userType:
        String pubKey = model.pubKey ?? '';
        if (pubKey.isEmpty) {
          CommonToast.instance.show(context, 'PubKey is empty, try other.');
          return;
        }
        if (pubKey == OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey) return;
        await OXLoading.show();
        await OXUserInfoManager.sharedInstance.switchAccount(pubKey);
        await OXLoading.dismiss();
        break;
      case MenuItemType.addUserType:
        OXModuleService.pushPage(context, 'ox_login', 'LoginPage', {});
        break;
      case MenuItemType.markToRead:
        OXChatBinding.sharedInstance.setAllSessionToReaded();
        break;
      case MenuItemType.addContact:
        OXChatInterface.addContact(context);
        break;
      case MenuItemType.addGroup:
        OXChatInterface.addGroup(context);
        break;
      case MenuItemType.moveToTop:
        OXUserInfoManager.sharedInstance.momentPosition = 0;
        OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.APP_MOMENT_POSITION, 0);
        OXMomentManager.sharedInstance.moveToTopCallBack();
        break;
      case MenuItemType.deleteMoments:
        OXUserInfoManager.sharedInstance.momentPosition = 2;
        OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.APP_MOMENT_POSITION, 2);
        OXMomentManager.sharedInstance.moveToTopCallBack();
        break;
    }
  }
}

class TabbarMenuModel extends MultipleUserModel{
  final MenuItemType type;
  final String iconPackage;

  TabbarMenuModel({this.type = MenuItemType.userType, this.iconPackage = '', super.pubKey = '', super.name = '', super.picture = '', super.dns = ''});
}

enum MenuItemType{
  userType,
  addUserType,
  markToRead,
  addContact,
  addGroup,
  moveToTop,
  deleteMoments,
}