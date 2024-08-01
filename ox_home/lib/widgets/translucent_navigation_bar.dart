library dot_navigation_bar;

export 'translucent_navigation_bar_item.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_chat_observer.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
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
  final double verticalPadding;

  /// Padding on the left and right sides of AppBar
  final double horizontalPadding;

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
  this.verticalPadding = 25.0,
  this.horizontalPadding = 20.0,
  });

  @override
  State<TranslucentNavigationBar> createState() => TranslucentNavigationBarState();
}

class TranslucentNavigationBarState extends State<TranslucentNavigationBar> with OXUserInfoObserver, OXChatObserver, TickerProviderStateMixin, WidgetsBindingObserver {
  bool isLogin = false;
  Timer? _refreshMessagesTimer;
  int selectedIndex = 0;
  double middleIndex = (4 / 2).floorToDouble();

  List<TranslucentNavigationBarItem> tabBarList = [];

  bool hasVibrator = false;

  bool get isDark => ThemeManager.getCurrentThemeStyle() == ThemeStyle.dark;

  // State machine
  final riveFileNames = ['Home','Contact', 'Discover', 'Me'];
  final stateMachineNames = ['state_machine_home', 'state_machine_contact', 'state_machine_discover', 'state_machine_me'];
  final riveInputs = ['Press', 'Press', 'Press', 'Press'];
  late List<river.StateMachineController?> riveControllers = List<river.StateMachineController?>.filled(4, null);
  late List<river.Artboard?> riveArtboards = List<river.Artboard?>.filled(4, null);

  isHasVibrator() async {
    hasVibrator = (await Vibrate.canVibrate);
  }

  @override
  void initState() {
    super.initState();
    isLogin = OXUserInfoManager.sharedInstance.isLogin;
    OXUserInfoManager.sharedInstance.addObserver(this);
    OXChatBinding.sharedInstance.addObserver(this);
    prepareMessageTimer();
    dataInit();
    isHasVibrator();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    clearRefreshMessagesTimer();
    OXUserInfoManager.sharedInstance.removeObserver(this);
    OXChatBinding.sharedInstance.removeObserver(this);
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
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: widget.verticalPadding,
        horizontal: widget.horizontalPadding,
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
      child: createTabContainer(tabBarList, middleIndex),
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
         //    Color(isDark ? 0xB2444444 : 0xB2FFFFFF),
          ],
          stops: const [
            0.1,
            1,
          ]),
      borderGradient: gradient.LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          //Lighting Mode

          // Colors.white.withOpacity(0.1),
          // Colors.white.withOpacity(0.1),
          // Colors.white.withOpacity(0.1),
          // Colors.white.withOpacity(0.1),

          // Color(0x66F5F5F5),
          // Color(0x66F5F5F5),
          // Color(0x66F5F5F5),
          // Color(0x66F5F5F5),

          isDark ?  const Color(0x0c595959) :  const Color(0x66F5F5F5),
          isDark ?  const Color(0x0c595959) : const Color(0x66F5F5F5),
          isDark ?  const Color(0x0c595959) : const Color(0x66F5F5F5),
          isDark ?  const Color(0x0c595959) : const Color(0x66F5F5F5),
          // Dark mode
          // Color(0x0c595959),
          // Color(0x0c595959),
          // Color(0x0c595959),
          // Color(0x0c595959),
        ],
      ),
      height: widget.height,
      width: double.infinity,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (final item in tabBarList)
              GestureDetector(
                onTap: () {
                  int draftIndex = selectedIndex;
                  int index = tabBarList.indexOf(item);
                  if (selectedIndex != index && hasVibrator == true && OXUserInfoManager.sharedInstance.canVibrate) {
                    //Vibration feedback
                    FeedbackType type = FeedbackType.impact;
                    Vibrate.feedback(type);
                  }
                  if (!OXUserInfoManager.sharedInstance.isLogin && (index == 3)) {
                    //jump login(value == 3 || value == 0)
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

                  for (int i = 0; i < 4; i++) {
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
                },
                onDoubleTap: tabBarList.indexOf(item) == 2 && selectedIndex == 2 ? () {
                  widget.handleDoubleTap?.call(tabBarList.indexOf(item),selectedIndex);
                } : null,
                child: Stack(
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
                ),
              ),
          ],
        ),
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
    return Container();

  }

  Widget _getTabBarTitle(TranslucentNavigationBarItem item) {
    final title = item.title?.call();
    if (title == null || title.isEmpty) return Container();
    return Text(
      title,
      style: TextStyle(
          fontSize: Adapt.px(10), fontWeight: FontWeight.w600,color: tabBarList.indexOf(item) == selectedIndex ? ThemeColor.gradientMainStart : ThemeColor.color100),
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
    if (tabBarList.isEmpty) return;
    if(type == ChatType.chatSecretStranger || type == ChatType.chatStranger){
      tabBarList[1].unreadMsgCount += 1;
    } else {
      tabBarList[0].unreadMsgCount += 1;
    }
    setState(() {});
  }

  @override
  void didLoginSuccess(UserDBISAR? userInfo) {
    // TODO: implement didLoginSuccess
    setState(() {
      isLogin = true;
      fetchUnreadCount();
    });
  }

  @override
  void didLogout() {
    // TODO: implement didLogout
    setState(() {
      isLogin = false;
      if (tabBarList.isNotEmpty) {
        tabBarList[0].unreadMsgCount = 0;
        tabBarList[1].unreadMsgCount = 0;
        tabBarList[3].unreadMsgCount = 0;
      }
    });
  }

  @override
  void didSwitchUser(UserDBISAR? userInfo) {
    // TODO: implement didSwitchUser
  }

  @override
  void didZapRecordsCallBack(ZapRecordsDBISAR zapRecordsDB) {
    super.didZapRecordsCallBack(zapRecordsDB);
    if (tabBarList.isEmpty || !mounted) return;
    setState(() {
      tabBarList[3].unreadMsgCount = 1;
    });
  }

  void dataInit() async {
    for (int i = 0; i < riveFileNames.length; i++) {
      await _loadRiveFile(i);
    }

    if (riveControllers[0] != null) {
      final input = riveControllers[0]!.findInput<bool>(riveInputs[0]);
      if (input != null) input.value = true;
    }

    setState(() {
      tabBarList = [
        TranslucentNavigationBarItem(
            title: () => Localized.text('ox_home.${riveFileNames[0]}'),
            artboard: riveArtboards[0],
            animationController: riveControllers[0],
            unreadMsgCount: 0),
        TranslucentNavigationBarItem(
            title: () => Localized.text('ox_home.${riveFileNames[1]}'),
            artboard: riveArtboards[1],
            animationController: riveControllers[1],
            unreadMsgCount: 0),
        TranslucentNavigationBarItem(
            title: () => Localized.text('ox_home.${riveFileNames[2]}'),
            artboard: riveArtboards[2],
            animationController: riveControllers[2],
            unreadMsgCount: 0),
        TranslucentNavigationBarItem(
            title: () => Localized.text('ox_home.${riveFileNames[3]}'),
            artboard: riveArtboards[3],
            animationController: riveControllers[3],
            unreadMsgCount: OXChatBinding.sharedInstance.isZapBadge ? 1 : 0),
      ];
      if (OXUserInfoManager.sharedInstance.isLogin) {
        fetchUnreadCount();
      }
    });
  }

  fetchUnreadCount() {
    if (tabBarList.isEmpty) return;
    if (OXChatBinding.sharedInstance.unReadStrangerSessionCount > 0) {
      tabBarList[1].unreadMsgCount = 1;
    } else {
      tabBarList[1].unreadMsgCount = 0;
    }
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
    if(notification.msgNum != null && notification.msgNum! < 1 && tabBarList.isNotEmpty){
      tabBarList[0].unreadMsgCount = 0;
      setState(() {});
    }
    if(notification.noticeNum != null && notification.noticeNum! <1 && tabBarList.isNotEmpty){
      tabBarList[3].unreadMsgCount = 0;
      setState(() {});
    }
    print('Received notification: ${notification.msgNum}');
    return true; //
  }
}
