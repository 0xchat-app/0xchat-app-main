library dot_navigation_bar;

import 'dart:async';

import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/painting/gradient.dart' as gradient;
import 'package:glassmorphism/glassmorphism.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/model/msg_notification_model.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_chat_observer.dart';
import 'package:ox_common/utils/ox_moment_manager.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/platform_utils.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/took_kit.dart';
import 'package:ox_common/utils/user_config_tool.dart';
import 'package:ox_home/model/home_tabbar_type.dart';
import 'package:ox_home/model/tab_bar_menu_model.dart';
import 'package:ox_home/widgets/tab_bar_longpress_dialog.dart';
import 'package:ox_home/widgets/translucent_navigation_bar.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:ox_theme/ox_theme.dart';
import 'package:rive/rive.dart' as river;

import 'translucent_navigation_bar_item.dart';

export 'translucent_navigation_bar_item.dart';



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
  bool _isLogin = false;
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
    _isLogin = OXUserInfoManager.sharedInstance.isLogin;
    OXUserInfoManager.sharedInstance.addObserver(this);
    OXChatBinding.sharedInstance.addObserver(this);
    OXMomentManager.sharedInstance.addObserver(this);
    ThemeManager.addOnThemeChangedCallback(onThemeStyleChange);
    _horizontalPadding = widget.horizontalPadding ?? 20.px;
    _verticalPadding = widget.verticalPadding ?? 24.px;
    // Always show 4 tabs: home, contact, discover, me
    _typeList = [HomeTabBarType.home, HomeTabBarType.contact, HomeTabBarType.discover, HomeTabBarType.me];
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
          for (int index = 0; index < updatedItems.length; index ++)
            GestureDetector(
              onLongPress: () {
                _tabbarItemOnLongPress(index);
              },
              onTap: () {
                _tabBarItemOnTap(index);
              },
              onDoubleTap: index == selectedIndex ? () {
                widget.handleDoubleTap?.call(index, selectedIndex);
              } : null,
              behavior: HitTestBehavior.translucent,
              child: _tabbarItemWidget(_itemList.elementAt(index), _navItemKeyList[index]),
            ),
        ],
      ),
    );
  }

  void _tabbarItemOnLongPress(int index) async {
    TookKit.vibrateEffect();
    if (!_isLogin && _typeList.elementAt(index) != HomeTabBarType.discover) return;
    if (_typeList.elementAt(index) == HomeTabBarType.me) {
      await _loadLocalInfo();
    }
    TabBarLongPressDialog dialog = TabBarLongPressDialog(currentUser: _currentUser, userCacheList: _userCacheList, typeList: _typeList, horizontalPadding: _horizontalPadding);
    dialog.showPopupDialog(context, index, _navItemKeyList, _tabbarItemWidget(_itemList.elementAt(index), GlobalKey()));
  }

  void _tabBarItemOnTap(int index) {
    int draftIndex = selectedIndex;
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
                  margin: EdgeInsets.only(
                    bottom: Adapt.px(2),
                  ),
                  width: Adapt.px(24),
                  child: _getMyTabBarIcon(item)
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
      _isLogin = true;
      fetchUnreadCount();
      if (_itemList.isNotEmpty) {
        _tabBarItemOnTap(_typeList.indexOf(HomeTabBarType.home));
        for (var element in _itemList) {
          element.unreadMsgCount = 0;
        }
      }
    });
  }

  @override
  void didLogout() {
    setState(() {
      _isLogin = false;
      if (_itemList.isNotEmpty) {
        _tabBarItemOnTap(_typeList.indexOf(HomeTabBarType.home));
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
        _tabBarItemOnTap(_typeList.indexOf(HomeTabBarType.home));
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
    // Always show 4 tabs: home, contact, discover, me
    _typeList = [HomeTabBarType.home, HomeTabBarType.contact, HomeTabBarType.discover, HomeTabBarType.me];
    dataInit();
  }

  @override
  void didDeleteMomentsCallBack() {
    // Always show 4 tabs: home, contact, discover, me
    _typeList = [HomeTabBarType.home, HomeTabBarType.contact, HomeTabBarType.discover, HomeTabBarType.me];
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
      if (!_unreadMap.containsKey(homeTabBarType)) {
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

}