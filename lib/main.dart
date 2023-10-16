import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ox_common/const/common_constant.dart';
import 'package:ox_common/utils/ox_call_keep_manager.dart';
import 'package:ox_common/utils/ox_server_manager.dart';
import 'package:ox_common/utils/scan_utils.dart';
import 'package:ox_home/ox_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ox_chat/ox_chat.dart';
import 'package:ox_common/event_bus.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/ox_relay_manager.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/boot_config.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/ox_common.dart';
import 'package:ox_discovery/ox_discovery.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_login/ox_login.dart';
import 'package:ox_push/google_push/firebase_message_manager.dart';
import 'package:ox_push/ox_push.dart';
import 'package:ox_calling/ox_calling.dart';
import 'package:ox_chat_project/multi_route_utils.dart';
import 'package:ox_theme/ox_theme.dart';
import 'package:ox_usercenter/ox_usercenter.dart';
import 'package:ox_chat_ui/ox_chat_ui.dart';
import 'package:path_provider/path_provider.dart';

import 'main.reflectable.dart';

const MethodChannel channel = const MethodChannel('com.oxchat.global/perferences');
const MethodChannel navigatorChannel = const MethodChannel('NativeNavigator');

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) =>
      true; // add your localhost detection logic here if you want
  }
}

void main() async {
  HttpOverrides.global = new MyHttpOverrides(); //ignore all ssl
  initializeReflectable();
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeManager.init();
  await Localized.init();
  await setupModules();

  OXRelayManager.sharedInstance.loadConnectRelay();
  OXServerManager.sharedInstance.loadConnectICEServer();
  await OXUserInfoManager.sharedInstance.initLocalData();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(ThemeManager.getCurrentThemeStyle().toOverlayStyle());

  getApplicationDocumentsDirectory().then((value) {
    LogUtil.log(content: '[App start] Application Documents Path: $value');
  });
  if (Platform.isIOS) {
    runApp(MainApp(window.defaultRouteName));
  } else {
    await FirebaseMessageManager.initFirebase();
    FirebaseMessageManager.instance.loadListener();
    runApp(MainApp(window.defaultRouteName));
  }
}

Future<void> setupModules() async {
  await OXCommon().setup();
  await OXLogin().setup();
  await OXUserCenter().setup();
  await OXPush().setup();
  await OXDiscovery().setup();
  await OXChat().setup();
  await OXChatUI().setup();
  await OxCalling().setup();
  await OxChatHome().setup();
}

class MainApp extends StatefulWidget {
  final String routeName;

  MainApp(this.routeName);

  @override
  State<StatefulWidget> createState() {
    return MainState();
  }
}

class MainState extends State<MainApp>
    with WidgetsBindingObserver, OXUserInfoObserver {
  late StreamSubscription wsSwitchStateListener;
  StreamSubscription? cacheTimeEventListener;
  Timer? _refreshDnsTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    LogUtil.e("getCurrentLanguage : ${Localized.getCurrentLanguage()}");
    ThemeManager.addOnThemeChangedCallback(onThemeStyleChange);
    Localized.addLocaleChangedCallback(onLocaleChange);
    OXUserInfoManager.sharedInstance.addObserver(this);
    if (OXUserInfoManager.sharedInstance.isLogin) {
      notNetworInitWow();
    }
    BootConfig.instance.batchUpdateUserBadges();
    getOpenAppSchemeInfo();
    OXCalllKeepManager.checkAndNavigationCallingPage();
  }

  void notNetworInitWow() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isGuestLogin', false);
  }


  @override
  void didChangeMetrics() {
    if (!Adapt.isInitialized) {
      Adapt.init(standardW: 375, standardH: 812);
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    OXUserInfoManager.sharedInstance.removeObserver(this);
    WidgetsBinding.instance.removeObserver(this);
    wsSwitchStateListener.cancel();
    _refreshDnsTimer?.cancel();
    _refreshDnsTimer = null;
  }

  onThemeStyleChange() {
    if (mounted) setState(() {});
    changeTheme(ThemeManager.getCurrentThemeStyle().index);
  }

  void changeTheme(int themeStyle) {
    print("******  changeTheme int $themeStyle");
    // channel.invokeMethod('changeTheme', {
    //   'themeStyle': themeStyle,
    // });
  }

  void getOpenAppSchemeInfo() async {
    String jumpInfo = await channel.invokeMethod(
      'getAppOpenURL',
    );
    LogUtil.e("doHandleJumpInfo jumpInfo : ${jumpInfo}");
    if (jumpInfo.isNotEmpty) {
      ScanUtils.analysis(OXNavigator.navigatorKey.currentContext!, jumpInfo.substring(CommonConstant.APP_SCHEME.length));
    }
  }

  onLocaleChange() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        navigatorKey: OXNavigator.navigatorKey,
        navigatorObservers: [MyObserver()],
        theme: ThemeData(
          brightness: ThemeManager.brightness(),
          fontFamily: 'Lato', //use regular for ios / thin for android
          // fontFamily: 'OX Font',
        ),
        debugShowCheckedModeBanner: false,
        home: WillPopScope(
            child: MultiRouteUtils.widgetForRoute(widget.routeName, context),
            onWillPop: () async {
              if (Platform.isAndroid) {
                OXCommon.backToDesktop();
              }
              return Future.value(false);
            }),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          CupertinoLocalizationsDelegate()
        ],
        supportedLocales: Localized.supportedLocales(),
        builder: (BuildContext context, Widget? child) {
          return OXLoading.init()(
            context,
            MediaQuery(
              ///Text size does not change with system Settings
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child!,
            ),
          );
        });
  }

  @override
  void didLoginSuccess(UserDB? userInfo) {
  }

  @override
  void didLogout() {}

  @override
  void didSwitchUser(UserDB? userInfo) {}

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    LogUtil.log(key: 'didChangeAppLifecycleState', content: state.toString());
    commonEventBus.fire(AppLifecycleStateEvent(state));
    switch (state) {
      case AppLifecycleState.resumed:
        if (OXUserInfoManager.sharedInstance.isLogin) {
          NotificationHelper.sharedInstance.setOnline();
          OXCalllKeepManager.checkAndNavigationCallingPage();
        }
        getOpenAppSchemeInfo();
        break;
      case AppLifecycleState.paused:
        if (OXUserInfoManager.sharedInstance.isLogin) {
          NotificationHelper.sharedInstance.setOffline();
        }
        break;
      default:
        break;
    }
  }
}

class MyObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    //call this when Navigator.push execute
    if (Platform.isIOS) {
      notifyNativeDidPush(route.navigator!.canPop());
    }
    OXNavigator.observer.forEach((obs) => obs.didPush(route, previousRoute));
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (Platform.isIOS) {
      notifyNativeDidPop(route.navigator!.canPop());
    }
    OXNavigator.observer.forEach((obs) => obs.didPop(route, previousRoute));
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    OXNavigator.observer.forEach((obs) => obs.didRemove(route, previousRoute));
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    OXNavigator.observer.forEach(
            (obs) => obs.didReplace(newRoute: newRoute, oldRoute: oldRoute));
  }

  @override
  void didStartUserGesture(Route route, Route? previousRoute) {
    OXNavigator.observer
        .forEach((obs) => obs.didStartUserGesture(route, previousRoute));
  }

  @override
  void didStopUserGesture() {
    OXNavigator.observer.forEach((obs) => obs.didStopUserGesture());
  }

  void notifyNativeDidPush(bool canPop) async {
    if (Platform.isIOS) {
      await navigatorChannel.invokeMethod("didPush", {"canPop": canPop});
    }
  }

  void notifyNativeDidPop(bool canPop) async {
    if (Platform.isIOS) {
      await navigatorChannel.invokeMethod("didPop", {"canPop": canPop});
    }
  }
}

extension ThemeStyleOverlayEx on ThemeStyle {
  SystemUiOverlayStyle toOverlayStyle() =>
    SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: systemNavigationBarIconBrightness,
        systemNavigationBarColor: systemNavigationBarColor,
        statusBarIconBrightness: statusBarIconBrightness,
        statusBarBrightness: statusBarBrightness,
        statusBarColor: statusBarColor,
    );

  Brightness get systemNavigationBarIconBrightness =>
      this == ThemeStyle.dark ? Brightness.light : Brightness.dark;

  Color get systemNavigationBarColor =>
      this == ThemeStyle.dark ? ThemeColor.dark02 : ThemeColor.white01;

  Brightness get statusBarIconBrightness =>
      this == ThemeStyle.dark ? Brightness.light : Brightness.dark;

  Brightness get statusBarBrightness =>
      this == ThemeStyle.dark ? Brightness.light : Brightness.dark;

  Color get statusBarColor =>
      this == ThemeStyle.dark ? ThemeColor.dark01 : Colors.transparent;
}