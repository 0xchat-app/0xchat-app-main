import 'package:flutter/foundation.dart';

class LogUtils {
  static bool isEnable = true;

  static void v(f) => _print('V', f);

  static void d(f) => _print('D', f);

  static void i(f) => _print('I', f);

  static void w(f) => _print('W', f);

  static void e(f) => _print('E', f);

  static void _print(String level, Function f) {
    if (!isEnable) return;

    if (kDebugMode) {
      try {
        final message = f.call();
        print('[$level] $message');
      } catch (e) {
        print('$e');
      }
    }
  }
}
