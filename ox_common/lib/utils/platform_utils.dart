import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';


enum DeviceType { mobile, desktop, web }

class PlatformUtils {
  static DeviceType getDeviceType() {
    if (kIsWeb) {
      return DeviceType.web;
    } else if (Platform.isAndroid || Platform.isIOS) {
      return DeviceType.mobile;
    } else if (Platform.isWindows ||
        Platform.isMacOS ||
        Platform.isLinux) {
      return DeviceType.desktop;
    } else {
      return DeviceType.mobile;
    }
  }

  static bool get isMobile => getDeviceType() == DeviceType.mobile;

  static bool get isDesktop => getDeviceType() == DeviceType.desktop;

  static bool get isWeb => kIsWeb;

  static Size windowSize = Size(650,800);

  static void initWindowSize (){
    doWhenWindowReady(() {
      final win = appWindow;
      final initialSize = PlatformUtils.windowSize;
      win.minSize = initialSize;
      win.size = initialSize;
      win.alignment = Alignment.center;
      win.title = 'oxchat';
      win.show();
    });
  }
}