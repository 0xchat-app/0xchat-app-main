import 'dart:io';
import 'package:flutter/foundation.dart';

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
}