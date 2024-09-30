import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ox_calling/manager/call_manager.dart';
import 'package:ox_common/scheme/scheme_helper.dart';
import 'package:ox_common/utils/chat_prompt_tone.dart';
import 'package:ox_common/utils/error_utils.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/user_config_tool.dart';
import 'package:ox_home/ox_home.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ox_chat/ox_chat.dart';
import 'package:ox_common/event_bus.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/boot_config.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/ox_common.dart';
import 'package:ox_discovery/ox_discovery.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_login/ox_login.dart';
import 'package:ox_push/push_lib.dart';
import 'package:ox_calling/ox_calling.dart';
import 'package:ox_chat_project/multi_route_utils.dart';
import 'package:ox_theme/ox_theme.dart';
import 'package:ox_usercenter/ox_usercenter.dart';
import 'package:ox_chat_ui/ox_chat_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ox_wallet/ox_wallet.dart';

import 'main.reflectable.dart';

const MethodChannel navigatorChannel = const MethodChannel('NativeNavigator');

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context)
      ..findProxy = (Uri uri) {
        ProxySettings? settings = Config.sharedInstance.proxySettings;
        if (settings == null) {
          return 'DIRECT';
        }
        if (settings.turnOnProxy) {
          bool onionURI = uri.host.contains(".onion");
          switch (settings.onionHostOption) {
            case EOnionHostOption.no:
              return onionURI ? '' : 'PROXY ${settings.socksProxyHost}:${settings.socksProxyPort}';
            case EOnionHostOption.whenAvailable:
              return !onionURI ? 'DIRECT' : 'PROXY ${settings.socksProxyHost}:${settings.socksProxyPort}';
            case EOnionHostOption.required:
              return !onionURI ? '' : 'PROXY ${settings.socksProxyHost}:${settings.socksProxyPort}';
            default:
              break;
          }
        }
        return "DIRECT";
      }
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      }; // add your localhost detection logic here if you want;
    return client;
  }
}

void main() async {
  runZonedGuarded(() async{
    WidgetsFlutterBinding.ensureInitialized();
    HttpOverrides.global = new MyHttpOverrides(); //ignore all ssl
    initializeReflectable();
    await ThemeManager.init();
    await Localized.init();
    await setupModules();
    await OXUserInfoManager.sharedInstance.initLocalData();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setSystemUIOverlayStyle(ThemeManager.getCurrentThemeStyle().toOverlayStyle());
    FlutterError.onError = (FlutterErrorDetails details) async {
      bool openDevLog = UserConfigTool.getSetting(StorageSettingKey.KEY_OPEN_DEV_LOG.name, defaultValue: false);
      if (openDevLog) {
        FlutterError.presentError(details);
        ErrorUtils.logErrorToFile(details.toString() + '\n' + details.stack.toString());
      }
    };
    getApplicationDocumentsDirectory().then((value) {
      LogUtil.d('[App start] Application Documents Path: $value');
    });
    runApp(MainApp(window.defaultRouteName));
  }, (error, stackTrace) async {
    bool openDevLog = UserConfigTool.getSetting(StorageSettingKey.KEY_OPEN_DEV_LOG.name, defaultValue: false);
    if (openDevLog) {
      ErrorUtils.logErrorToFile(error.toString() + '\n' + stackTrace.toString());
    }
    print(error);
    print(stackTrace);
  });
}

Future<void> setupModules() async {
  final setupAction = [
    OXCommon().setup(),
    OXLogin().setup(),
    OXUserCenter().setup(),
    OXPush().setup(),
    OXDiscovery().setup(),
    OXChat().setup(),
    OXChatUI().setup(),
    OxCalling().setup(),
    OxChatHome().setup(),
    OXWallet().setup(),
  ];
  await Future.wait(setupAction);
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
  int lastUserInteractionTime = 0;
  Timer? timer;

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
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      printMemoryUsage();
    });
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
    timer?.cancel();
    timer = null;
    super.dispose();
    OXUserInfoManager.sharedInstance.removeObserver(this);
    WidgetsBinding.instance.removeObserver(this);
    wsSwitchStateListener.cancel();
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

  onLocaleChange() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        key: UniqueKey(),
        navigatorKey: OXNavigator.navigatorKey,
        navigatorObservers: [OXNavigator.routeObserver],
        theme: ThemeData(
          useMaterial3: false,
          brightness: ThemeManager.brightness(),
          scaffoldBackgroundColor: ThemeColor.color190,
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
            },
        ),
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
        },
    );
  }

  @override
  void didLoginSuccess(UserDBISAR? userInfo) {
  }

  @override
  void didLogout() {}

  @override
  void didSwitchUser(UserDBISAR? userInfo) {}

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    LogUtil.log(key: 'didChangeAppLifecycleState', content: state.toString());
    commonEventBus.fire(AppLifecycleStateEvent(state));
    switch (state) {
      case AppLifecycleState.resumed:
        PromptToneManager.sharedInstance.isAppPaused = false;
        if (OXUserInfoManager.sharedInstance.isLogin) NotificationHelper.sharedInstance.setOnline();
        SchemeHelper.tryHandlerForOpenAppScheme();
        OXUserInfoManager.sharedInstance.resetHeartBeat();
        if (lastUserInteractionTime != 0 && DateTime.now().millisecondsSinceEpoch - lastUserInteractionTime > const Duration(minutes: 5).inMilliseconds) {
          lastUserInteractionTime = 0;
          showPasswordDialog();
        }
        break;
      case AppLifecycleState.paused:
        PromptToneManager.sharedInstance.isAppPaused = true;
        if (OXUserInfoManager.sharedInstance.isLogin) NotificationHelper.sharedInstance.setOffline();
        lastUserInteractionTime = DateTime.now().millisecondsSinceEpoch;
        if (CallManager.instance.getInCallIng && CallManager.instance.isAudioVoice){
          OXCommon.channelPreferences.invokeMethod('startVoiceCallService', {'notice_voice_title': CallManager.instance.otherName, 'notice_voice_content': Localized.text('ox_calling.str_voice_call_in_use')});
        }
        break;
      default:
        break;
    }
  }

  void showPasswordDialog() async {
    String localPasscode = UserConfigTool.getSetting(StorageSettingKey.KEY_PASSCODE.name, defaultValue: '');
    if (localPasscode.isNotEmpty && OXNavigator.navigatorKey.currentContext != null)
      OXModuleService.pushPage(OXNavigator.navigatorKey.currentContext!, 'ox_usercenter', 'VerifyPasscodePage', {});
  }

  void printMemoryUsage() {
    final memoryUsage = ProcessInfo.currentRss;
    print('Current RSS memory usage: ${memoryUsage / (1024 * 1024)} MB');
    print('Max RSS memory usage: ${ProcessInfo.maxRss / (1024 * 1024)} MB');
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
        systemNavigationBarColor: Colors.transparent,
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
      this == ThemeStyle.dark ? ThemeColor.color200 : Colors.transparent;
}