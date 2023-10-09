import 'dart:async';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/model/msg_notification_model.dart';
import 'package:ox_home/widgets/translucent_navigation_bar.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:rive/rive.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:ox_theme/ox_theme.dart';

class TabViewInfo {
  final String moduleName;
  final String modulePage;

  TabViewInfo({
    required this.moduleName,
    required this.modulePage,
  });
}

class HomeTabBarPage extends StatefulWidget {
  const HomeTabBarPage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeTabBarPage> createState() => _HomeTabBarPageState();
}

class _HomeTabBarPageState extends State<HomeTabBarPage> with OXUserInfoObserver, OXChatObserver, TickerProviderStateMixin, WidgetsBindingObserver {
  int selectedIndex = 0;
  bool isLogin = false;
  bool hasVibrator = false;
  Timer? _refreshMessagesTimer;
  final PageController _pageController = PageController();

  // State machine
  final riveFileNames = ['Home','Contact', 'Discover', 'Me'];
  final stateMachineNames = ['state_machine_home', 'state_machine_contact', 'state_machine_discover', 'state_machine_me'];
  final riveInputs = ['Press', 'Press', 'Press', 'Press'];
  late List<StateMachineController?> riveControllers = List<StateMachineController?>.filled(4, null);
  late List<Artboard?> riveArtboards = List<Artboard?>.filled(4, null);

  List<TranslucentNavigationBarItem> tabBarList = [];

  List<TabViewInfo> tabViewInfo = [
    TabViewInfo(
      moduleName: 'ox_chat',
      modulePage: 'chatSessionListPageWidget',
    ),
    TabViewInfo(
      moduleName: 'ox_chat',
      modulePage: 'contractsPageWidget',
    ),
    TabViewInfo(
      moduleName: 'ox_discovery',
      modulePage: 'discoveryPageWidget',
    ),
    TabViewInfo(
      moduleName: 'ox_usercenter',
      modulePage: 'userCenterPageWidget',
    ),
  ];

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    _refreshMessagesTimer?.cancel();
    _refreshMessagesTimer = null;
    OXUserInfoManager.sharedInstance.removeObserver(this);
    OXChatBinding.sharedInstance.removeObserver(this);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLogin = OXUserInfoManager.sharedInstance.isLogin;

    OXUserInfoManager.sharedInstance.addObserver(this);
    OXChatBinding.sharedInstance.addObserver(this);
    Localized.addLocaleChangedCallback(onLocaleChange);

    if (selectedIndex == 0) {
      prepareMessageTimer();
    } else {
      _refreshMessagesTimer?.cancel();
      _refreshMessagesTimer = null;
    }
    isHasVibrator();

    dataInit();
  }

  Future<void> _loadRiveFile(int index) async {
    String animPath = "packages/ox_home/assets/${ThemeManager.images(riveFileNames[index])}.riv";

    final data = await rootBundle.load(animPath);
    final file = RiveFile.import(data);
    final artboard = file.mainArtboard;

    StateMachineController? controller = StateMachineController.fromArtboard(artboard, stateMachineNames[index]);

    if (controller != null) {
      artboard.addController(controller);
      riveControllers[index] = controller;
      riveArtboards[index] = artboard;
    }
  }

  void dataInit() async {
    for (int i = 0; i < riveFileNames.length; i++) {
      await _loadRiveFile(i);
    }

    if (riveControllers[selectedIndex] != null) {
      final input = riveControllers[selectedIndex]!.findInput<bool>(riveInputs[selectedIndex]);
      if (input != null) input.value = true;
    }

    setState(() {
      tabBarList = [
        TranslucentNavigationBarItem(
            title: Localized.text('ox_home.${riveFileNames[0]}'),
            artboard: riveArtboards[0],
            animationController: riveControllers[0],
            unreadMsgCount: 0),
        TranslucentNavigationBarItem(
            title: Localized.text('ox_home.${riveFileNames[1]}'),
            artboard: riveArtboards[1],
            animationController: riveControllers[1],
            unreadMsgCount: 0),
        TranslucentNavigationBarItem(
            title: Localized.text('ox_home.${riveFileNames[2]}'),
            artboard: riveArtboards[2],
            animationController: riveControllers[2],
            unreadMsgCount: 0),
        TranslucentNavigationBarItem(
            title: Localized.text('ox_home.${riveFileNames[3]}'),
            artboard: riveArtboards[3],
            animationController: riveControllers[3],
            unreadMsgCount: OXChatBinding.sharedInstance.isZapBadge ? 1 : 0),
      ];
    });
    if (OXUserInfoManager.sharedInstance.isLogin) {
      fetchUnreadCount();
    }
  }

  @override
  Widget build(BuildContext context) {
    updateLocaleStatus();
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: TranslucentNavigationBar(
        onTap: (value) => _tabClick(value),
        selectedIndex: selectedIndex,
        tabBarList: tabBarList,
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: _containerView(context),
      ),
    );
  }

  List<Widget> _containerView(BuildContext context) {
    return tabViewInfo.map(
      (TabViewInfo tabModel) {
        return NotificationListener<MsgNotification>(
          onNotification: (notification) {
            if(notification.msgNum != null && notification.msgNum! < 1 && tabBarList.length > 0){
              tabBarList[0].unreadMsgCount = 0;
              setState(() {});
            }
            if(notification.noticeNum != null && notification.noticeNum! <1 && tabBarList.length > 0){
              tabBarList[3].unreadMsgCount = 0;
              setState(() {});
            }
            print('Received notification: ${notification.msgNum}');
            return true; // Returning true means we've handled the notification.
          },
          child: Container(
            constraints: const BoxConstraints.expand(
              width: double.infinity,
              height: double.infinity,
            ),
            child: OXModuleService.invoke(
              tabModel.moduleName,
              tabModel.modulePage,
              [context],
            ),
          ),
        );
      },
    ).toList();
  }

  @override
  void didPromptToneCallBack(MessageDB message, int type) {
    if(message.read || message.sender == OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey) return;
    if(type == ChatType.chatSecretStranger || type == ChatType.chatStranger){
      tabBarList[1].unreadMsgCount += 1;
    } else {
      tabBarList[0].unreadMsgCount += 1;
    }
    setState(() {});
  }

  @override
  void didLoginSuccess(UserDB? userInfo) {
    // TODO: implement didLoginSuccess
    setState(() {
      isLogin = true;
    });
    fetchUnreadCount();
  }

  @override
  void didLogout() {
    // TODO: implement didLogout
    setState(() {
      isLogin = false;
      tabBarList[0].unreadMsgCount = 0;
      tabBarList[1].unreadMsgCount = 0;
      tabBarList[3].unreadMsgCount = 0;
    });
  }

  @override
  void didSwitchUser(UserDB? userInfo) {
    // TODO: implement didSwitchUser
  }

  @override
  void didZapRecordsCallBack(ZapRecordsDB zapRecordsDB) {
    super.didZapRecordsCallBack(zapRecordsDB);
    setState(() {
      tabBarList[3].unreadMsgCount = 1;
    });
  }

  _showLoginPage(BuildContext context) {
    OXModuleService.pushPage(
      context,
      "ox_login",
      "LoginPage",
      {},
    );
  }

  fetchUnreadCount() {
    if (OXChatBinding.sharedInstance.unReadStrangerSessionCount > 0 && tabBarList.length > 0) {
      setState(() {
        tabBarList[1].unreadMsgCount = 1;
      });
    }
  }

  updateUnreadMsgCount(int count) {
    if(tabBarList.length > 0){
      setState(() {
        tabBarList[0].unreadMsgCount = count;
      });
    }
  }

  updateNewFriendRequestCount(int count) {
    if(tabBarList.length > 0){
      setState(() {
        tabBarList[1].unreadMsgCount = count;
      });
    }
  }

  isHasVibrator() async {
    hasVibrator = (await Vibrate.canVibrate);
  }

  void _tabClick(int value) {
    if (hasVibrator == true) {
      //Vibration feedback
      FeedbackType type = FeedbackType.impact;
      Vibrate.feedback(type);
    }
    if (!OXUserInfoManager.sharedInstance.isLogin && (value == 3)) {
      //jump login(value == 3 || value == 0)
      _showLoginPage(context);
      return;
    }
    if (value == 1 && OXChatBinding.sharedInstance.unReadStrangerSessionCount < 1) {
      tabBarList[1].unreadMsgCount = 0;
    }
    setState(() {
      selectedIndex = value;
      if (OXUserInfoManager.sharedInstance.isLogin) {
        fetchUnreadCount();
      }
      _refreshMessagesTimer?.cancel();
      _refreshMessagesTimer = null;
    });
    _pageController.animateToPage(
      selectedIndex,
      duration: const Duration(milliseconds: 1),
      curve: Curves.linear,
    );

    for (int i = 0; i < 4; i++) {
      final controller = riveControllers[i];
      final input = controller?.findInput<bool>(riveInputs[i]);
      if (input != null && input.value) {
        input.value = false;
      }
    }
    StateMachineController? animController = riveControllers[selectedIndex];

    final input = animController?.findInput<bool>(riveInputs[selectedIndex]);
    if (input != null) {
      input.value = true;
    }
  }

  void prepareMessageTimer() async {
    _refreshMessagesTimer?.cancel();
    _refreshMessagesTimer = null;
    _refreshMessagesTimer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      fetchUnreadCount();
    });
  }

  onLocaleChange() {
    if (mounted) setState(() {});
  }

  updateLocaleStatus() {
    for (int index = 0; index < tabBarList.length; index++) {
      tabBarList[index].title = Localized.text('ox_home.${riveFileNames[index]}');
    }
  }
}
