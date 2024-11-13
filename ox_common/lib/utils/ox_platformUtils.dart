import 'dart:io';

class OXPlatformUtils {

  static bool get isMobile => Platform.isAndroid || Platform.isIOS;

  static bool get isDesktop => Platform.isMacOS || Platform.isWindows || Platform.isLinux;

}