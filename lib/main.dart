import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:chatcore/chat-core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ox_calling/manager/call_manager.dart';
import 'package:ox_common/scheme/scheme_helper.dart';
import 'package:ox_common/utils/chat_prompt_tone.dart';
import 'package:ox_common/utils/error_utils.dart';
import 'package:ox_common/utils/font_size_notifier.dart';
import 'package:ox_common/utils/platform_utils.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/user_config_tool.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ox_common/event_bus.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/boot_config.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/ox_common.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_chat_project/multi_route_utils.dart';
import 'package:ox_theme/ox_theme.dart';

import 'app_initializer.dart';

const MethodChannel navigatorChannel = const MethodChannel('NativeNavigator');

void main() async {
  runZonedGuarded(() async {
    await AppInitializer.shared.initialize();
    runApp(
      ValueListenableBuilder<double>(
      valueListenable: textScaleFactorNotifier,
      builder: (context, scaleFactor, child) {
        return MainApp(window.defaultRouteName, scaleFactor: scaleFactor);
      },
    ),
    );
  }, (error, stackTrace) async {
    try {
      bool openDevLog = UserConfigTool.getSetting(StorageSettingKey.KEY_OPEN_DEV_LOG.name, defaultValue: false);
      if (openDevLog) {
        ErrorUtils.logErrorToFile(error.toString() + '\n' + stackTrace.toString());
      }
      print(error);
      print(stackTrace);
    } catch (e, stack) {
      if (kDebugMode) {
        print(e);
        print(stack);
      }
    }
  });
}

class MainApp extends StatefulWidget {
  final String routeName;
  final double scaleFactor;

  MainApp(this.routeName, {required this.scaleFactor});

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

  List<OXErrorInfo> initializeErrors = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    LogUtil.e("getCurrentLanguage : ${Localized.getCurrentLanguage()}");
    Localized.addLocaleChangedCallback(onLocaleChange);
    OXUserInfoManager.sharedInstance.addObserver(this);
    if (OXUserInfoManager.sharedInstance.isLogin) {
      notNetworInitWow();
    }
    BootConfig.instance.batchUpdateUserBadges();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      printMemoryUsage();
    });
    showErrorDialogIfNeeded();
    if(PlatformUtils.isDesktop){
      PlatformUtils.initWindowSize();
      Size windowSize = PlatformUtils.windowSize;
      int width = int.parse(windowSize.width.toString());
      int height = int.parse(windowSize.height.toString());
      Adapt.init(standardW: width, standardH: height);
    }
  }

  void showErrorDialogIfNeeded() async {
    await WidgetsBinding.instance.waitUntilFirstFrameRasterized;
    await Future.delayed(Duration(seconds: 5));
    final entries = [...AppInitializer.shared.initializeErrors];
    for (var entry in entries) {
      showDialog(
        context: OXNavigator.navigatorKey.currentContext!,
        builder: (context) {
          return AlertDialog(
            title: Text(entry.error.toString()),
            content: Text(entry.stack.toString()),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
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
              data: MediaQuery.of(context).copyWith(textScaleFactor: widget.scaleFactor),
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