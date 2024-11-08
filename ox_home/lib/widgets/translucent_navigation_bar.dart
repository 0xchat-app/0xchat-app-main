library dot_navigation_bar;

export 'translucent_navigation_bar_item.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:ox_common/business_interface/ox_chat/interface.dart';
import 'package:ox_common/mixin/common_navigator_observer_mixin.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_chat_observer.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/took_kit.dart';
import 'package:ox_common/utils/user_config_tool.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:ox_theme/ox_theme.dart';
import 'package:rive/rive.dart' as river;
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'translucent_navigation_bar_item.dart';
import 'package:flutter/src/painting/gradient.dart' as gradient;
import 'package:flutter_vibrate/flutter_vibrate.dart';

import 'package:chatcore/chat-core.dart';
import 'package:flutter/services.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/model/msg_notification_model.dart';
import 'package:ox_home/widgets/translucent_navigation_bar.dart';
import 'package:ox_localizable/ox_localizable.dart';


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

class TranslucentNavigationBarState extends State<TranslucentNavigationBar> with OXUserInfoObserver, OXChatObserver, TickerProviderStateMixin, WidgetsBindingObserver {
  bool isLogin = false;
  Timer? _refreshMessagesTimer;
  int selectedIndex = 1;
  double middleIndex = (4 / 2).floorToDouble();

  List<TranslucentNavigationBarItem> _tabBarList = [];

  bool hasVibrator = false;

  bool get isDark => ThemeManager.getCurrentThemeStyle() == ThemeStyle.dark;

  // State machine
  final riveFileNames = ['Contact', 'Home', 'Me'];
  final stateMachineNames = ['state_machine_contact', 'state_machine_home', 'state_machine_me'];
  final riveInputs = ['Press', 'Press', 'Press'];
  late List<river.StateMachineController?> riveControllers = List<river.StateMachineController?>.filled(3, null);
  late List<river.Artboard?> riveArtboards = List<river.Artboard?>.filled(3, null);
  late List<int> _unreadList = [0, 0 ,0];

  final List<GlobalKey> _navItemKeyList = [GlobalKey(), GlobalKey(), GlobalKey()];
  List<TabbarMenuModel> _userCacheList = [];
  TabbarMenuModel? _currentUser;

  late AnimationController _animationController;
  late Animation<double> _animation;
  double navOffset = 0.0;

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

  isHasVibrator() async {
    hasVibrator = (await Vibrate.canVibrate);
  }

  @override
  void initState() {
    super.initState();
    isLogin = OXUserInfoManager.sharedInstance.isLogin;
    OXUserInfoManager.sharedInstance.addObserver(this);
    OXChatBinding.sharedInstance.addObserver(this);
    ThemeManager.addOnThemeChangedCallback(onThemeStyleChange);
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _animation = Tween<double>(begin: 0.0, end: 72 + 24.px).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    prepareMessageTimer();
    dataInit();
    isHasVibrator();

  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    clearRefreshMessagesTimer();
    OXUserInfoManager.sharedInstance.removeObserver(this);
    OXChatBinding.sharedInstance.removeObserver(this);
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
              vertical: widget.verticalPadding ?? 24.px,
              horizontal: widget.horizontalPadding ?? 20.px,
            ),
            height: widget.height,
            width: double.infinity,
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
            child: createTabContainer(_tabBarList, middleIndex),
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
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (final item in _tabBarList)
            GestureDetector(
              onLongPress: () {
                _tabbarItemOnLongPress(item);
              },
              onTap: () {
                _tabBarItemOnTap(item);
              },
              onDoubleTap: _tabBarList.indexOf(item) == selectedIndex ? () {
                widget.handleDoubleTap?.call(_tabBarList.indexOf(item),selectedIndex);
              } : null,
              child: _tabbarItemWidget(item, _navItemKeyList[_tabBarList.indexOf(item)]),
            ),
        ],
      ),
    );
  }

  void _tabbarItemOnLongPress(TranslucentNavigationBarItem item){
    int index = _tabBarList.indexOf(item);
    if (hasVibrator == true && OXUserInfoManager.sharedInstance.canVibrate) {
      TookKit.vibrateEffect();
    }
    _showPopupDialog(context, index);
  }

  void _tabBarItemOnTap(TranslucentNavigationBarItem item) {
    int draftIndex = selectedIndex;
    int index = _tabBarList.indexOf(item);
    if (selectedIndex != index && hasVibrator == true && OXUserInfoManager.sharedInstance.canVibrate) {
      TookKit.vibrateEffect();
    }
    if (!OXUserInfoManager.sharedInstance.isLogin && (index == 2)) {
      _showLoginPage(context);
      return;
    }

    setState(() {
      selectedIndex = index;
      if (OXUserInfoManager.sharedInstance.isLogin) {
        fetchUnreadCount();
      }
    });
    clearRefreshMessagesTimer();

    widget.onTap!.call(index,draftIndex);

    for (int i = 0; i < 3; i++) {
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

  Widget _tabbarItemWidget(TranslucentNavigationBarItem item, GlobalKey tabbarKey) {
    return Stack(
      key: tabbarKey,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: Adapt.px(70),
          height: widget.height,
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
        Positioned(bottom: Adapt.px(6),child: _promptWidget(item),),
      ],
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
          fontSize: Adapt.px(10), fontWeight: FontWeight.w600,color: _tabBarList.indexOf(item) == selectedIndex ? ThemeColor.gradientMainStart : ThemeColor.color100),
    );
  }

  Future<void> _loadRiveFile(int index) async {
    String animPath = "packages/ox_home/assets/${ThemeManager.images(riveFileNames[index])}.riv";

    final data = await rootBundle.load(animPath);
    final file = river.RiveFile.import(data);
    final artboard = file.mainArtboard;

    river.StateMachineController? controller = river.StateMachineController.fromArtboard(artboard, stateMachineNames[index]);

    if (controller != null) {
      artboard.addController(controller);
      riveControllers[index] = controller;
      riveArtboards[index] = artboard;
    }
  }

  @override
  void didPromptToneCallBack(MessageDBISAR message, int type) {
    if (_tabBarList.isEmpty) return;
    if(type == ChatType.chatSecretStranger || type == ChatType.chatStranger){
      _tabBarList[1].unreadMsgCount += 1;
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
      if (_tabBarList.isNotEmpty) {
        _tabBarItemOnTap(_tabBarList.elementAt(1));
        for (var element in _tabBarList) {
          element.unreadMsgCount = 0;
        }
      }
    });
  }

  @override
  void didLogout() {
    setState(() {
      isLogin = false;
      if (_tabBarList.isNotEmpty) {
        for (var element in _tabBarList) {
          element.unreadMsgCount = 0;
        }
      }
    });
  }

  @override
  void didSwitchUser(UserDBISAR? userInfo) {
    setState(() {
      if (_tabBarList.isNotEmpty) {
        for (var element in _tabBarList) {
          element.unreadMsgCount = 0;
        }
      }
    });
  }

  @override
  void didZapRecordsCallBack(ZapRecordsDBISAR zapRecordsDB) {
    super.didZapRecordsCallBack(zapRecordsDB);
    if (_tabBarList.isEmpty || !mounted) return;
    setState(() {
      _tabBarList[2].unreadMsgCount = 1;
    });
  }

  void dataInit() async {
    List<int> tempList = [0, 1, 2];
    await Future.forEach(tempList, (element) async {
      await _loadRiveFile(element);
    });
    if (riveControllers[1] != null) {
      final input = riveControllers[1]!.findInput<bool>(riveInputs[1]);
      if (input != null) input.value = true;
    }

    setState(() {
      _tabBarList = [
        TranslucentNavigationBarItem(
            title: () => Localized.text('ox_home.${riveFileNames[0]}'),
            artboard: riveArtboards[0],
            animationController: riveControllers[0],
            unreadMsgCount: _unreadList.elementAt(0)),
        TranslucentNavigationBarItem(
            title: () => Localized.text('ox_home.${riveFileNames[1]}'),
            artboard: riveArtboards[1],
            animationController: riveControllers[1],
            unreadMsgCount: _unreadList.elementAt(1)),
        TranslucentNavigationBarItem(
            title: () => Localized.text('ox_home.${riveFileNames[2]}'),
            artboard: riveArtboards[2],
            animationController: riveControllers[2],
            unreadMsgCount: UserConfigTool.getSetting(StorageSettingKey.KEY_ZAP_BADGE.name, defaultValue: false) ? 1 : 0),
      ];
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

  bool updateNotificationListener(MsgNotification notification, bool buildFrameCompleted){
    if (notification.msgNum != null) {
      if (_tabBarList.isNotEmpty) {
        _tabBarList[1].unreadMsgCount = notification.msgNum! > 0 ? 1 : 0;
        if (buildFrameCompleted) {
          setState(() {});
        }
      } else {
        _unreadList[1] = notification.msgNum! > 0 ? 1 : 0;
      }
    } else if (notification.noticeNum != null) {
      if (_tabBarList.isNotEmpty) {
        _tabBarList[2].unreadMsgCount = notification.noticeNum! > 0 ? 1 : 0;
        if (buildFrameCompleted) {setState(() {});}
      } else {
        _unreadList[2] = notification.msgNum! > 0 ? 1 : 0;
      }
    }
    print('Received notification: ${notification.msgNum}');
    return true; //
  }

  void _showPopupDialog(BuildContext context, int index) async {
    if (index == 2) {
      await _loadLocalInfo();
    }
    final RenderBox renderBox =
        _navItemKeyList[index].currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    List<TabbarMenuModel> menuList = _getMenuList(index);
    if (menuList.isEmpty) return;
    double leftPosition = _calculateDialogPosition(context, index, position);
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
                  child: _tabbarItemWidget(_tabBarList.elementAt(index), GlobalKey()),
                ),
              ),
              Positioned(
                bottom: Adapt.screenH - position.dy + 4.px + (index == 2 ? 46.px : 0),
                left: leftPosition,
                child: Container(
                  width: 180.px,
                  height: menuList.length * 44.px,
                  constraints: BoxConstraints(maxHeight: Adapt.screenH/2),
                  decoration: BoxDecoration(
                    color: ThemeColor.color180,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.px),
                        topRight: Radius.circular(16.px),
                        bottomLeft: Radius.circular(index == 2 ? 0 : 16.px),
                        bottomRight: Radius.circular(index == 2 ? 0 : 16.px)),
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
                visible: index == 2,
                child: Positioned(
                  bottom: Adapt.screenH - position.dy + 4.px,
                  left: _calculateDialogPosition(context, index, position),
                  child: Container(
                    width: 180.px,
                    height: 46.px,
                    constraints: BoxConstraints(maxHeight: Adapt.screenH/2),
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
                      _menuItemView(2, _currentUser),
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
            index == 2
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

  double _calculateDialogPosition(BuildContext context, int index, Offset position) {
    final screenWidth = MediaQuery.of(context).size.width;
    final navBarItemWidth = (screenWidth - 40.px) / 3;
    double dialogOffset;

    switch (index) {
      case 0:
        dialogOffset = 20.px;
        break;
      case 1:
        dialogOffset = position.dx + (navBarItemWidth / 2) - (180.px / 2) - 20.px;
        break;
      case 2:
        dialogOffset = screenWidth - 180.px - 20.px ;
        break;
      default:
        dialogOffset = position.dx;
    }
    return dialogOffset;
  }

  List<TabbarMenuModel> _getMenuList(int index) {
    List<TabbarMenuModel> list = [];
    switch(index){
      case 0:
        list.add(TabbarMenuModel(type: MenuItemType.addContact, name: Localized.text('ox_common.str_add_friend'), picture: 'icon_new_friend.png', iconPackage: 'ox_common'));
        list.add(TabbarMenuModel(type: MenuItemType.addGroup, name: Localized.text('ox_chat.str_new_group'), picture: 'icon_new_group.png', iconPackage: 'ox_common'));
        break;
      case 1:
        int unReadCount = OXChatBinding.sharedInstance.getAllSessionUnReadCount();
        if (unReadCount > 0) {
          list.add(TabbarMenuModel(type: MenuItemType.markToRead, name: Localized.text('ox_chat.str_all_chats_mark_as_read'), picture: 'icon_chat_mark_as_read.png', iconPackage: 'ox_chat'));
        }
        break;
      case 2:
        list = _userCacheList.toList();
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
}