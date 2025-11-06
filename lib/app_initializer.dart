import 'dart:io';
import 'dart:async';

import 'package:chatcore/chat-core.dart' hide ProxySettings;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ox_calling/ox_calling.dart';
import 'package:ox_chat/ox_chat.dart';
import 'package:ox_chat_ui/ox_chat_ui.dart';
import 'package:ox_common/desktop/window_manager.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/ox_common.dart';
import 'package:ox_common/utils/error_utils.dart';
import 'package:ox_common/utils/font_size_notifier.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_discovery/ox_discovery.dart';
import 'package:ox_home/ox_home.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_login/ox_login.dart';
import 'package:ox_push/push_lib.dart';
import 'package:ox_theme/ox_theme.dart';
import 'package:ox_usercenter/ox_usercenter.dart';
import 'package:ox_wallet/ox_wallet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dart_ping_ios/dart_ping_ios.dart';

import 'http_overrides.dart';
import 'main.reflectable.dart';

class OXErrorInfo {
  OXErrorInfo(this.error, this.stack);
  Object error;
  StackTrace stack;
}

class AppInitializer {
  static final AppInitializer shared = AppInitializer();
  List<OXErrorInfo> initializeErrors = [];

  OXWindowManager windowManager = OXWindowManager();

  Future initialize() async {
    await _safeHandle(() async {
      try {
        WidgetsFlutterBinding.ensureInitialized();
        await windowManager.initWindow();
        HttpOverrides.global = OXHttpOverrides(); //ignore all ssl
        initializeReflectable();
        // await RustLib.init(); // MLS RustLib initialization temporarily disabled
        await ThemeManager.init();
        await Localized.init();
        await _setupModules();
        await OXUserInfoManager.sharedInstance.initLocalData();
        
        // Initialize Tor network manager
        Future.microtask(() async {
          try {
            await TorNetworkHelper.initialize();
            await TorNetworkHelper.start();
            LogUtil.d('[App start] Tor network manager initialized');
          } catch (e) {
            LogUtil.e('[App start] Failed to initialize Tor network manager: $e');
          }
        });
        
        SystemChrome.setSystemUIOverlayStyle(ThemeManager.getCurrentThemeStyle().toOverlayStyle());
        ThemeManager.addOnThemeChangedCallback(onThemeStyleChange);
        double fontSize = await OXCacheManager.defaultOXCacheManager.getForeverData(StorageKeyTool.APP_FONT_SIZE, defaultValue: 1.0);
        textScaleFactorNotifier.value = fontSize;
        DartPingIOS.register();
        FlutterError.onError = (FlutterErrorDetails details) async {
          bool openDevLog = UserConfigTool.getSetting(StorageSettingKey.KEY_OPEN_DEV_LOG.name,
              defaultValue: false);
          if (openDevLog) {
            FlutterError.presentError(details);
            ErrorUtils.logErrorToFile(details.toString() + '\n' + details.stack.toString());
          }
        };
        improveErrorWidget();
        if (kDebugMode) {
          getApplicationDocumentsDirectory().then((value) {
            LogUtil.d('[App start] Application Documents Path: $value');
          });
        }
      } catch (error, stack) {
        initializeErrors.add(OXErrorInfo(error, stack));
      }
    });
  }

  onThemeStyleChange() async {
    print("******  changeTheme int ${ThemeManager.getCurrentThemeStyle().name}");
    SystemChrome.setSystemUIOverlayStyle(ThemeManager.getCurrentThemeStyle().toOverlayStyle());
  }

  Future<void> _setupModules() async {
    await Future.wait([
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
    ]);
  }

  Future _safeHandle(Function fn) async {
    try {
      await fn();
    } catch (e, stack) {
      if (kDebugMode) {
        print(e);
        print(stack);
        rethrow;
      }
    }
  }

  void improveErrorWidget() {
    final originErrorWidgetBuilder = ErrorWidget.builder;
    ErrorWidget.builder = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      if (kDebugMode) {
        return ConstrainedBox(
          constraints: BoxConstraints.loose(Size.square(300)),
          child: originErrorWidgetBuilder(details),
        );
      } else {
        return SizedBox();
      }
    };
  }
}

extension ThemeStyleOverlayEx on ThemeStyle {
  SystemUiOverlayStyle toOverlayStyle() => SystemUiOverlayStyle(
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

  Color get statusBarColor => Colors.transparent;
}