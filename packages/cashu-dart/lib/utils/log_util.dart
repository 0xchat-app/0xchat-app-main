import 'package:flutter/foundation.dart';

typedef LogCreator = String Function();

class LogUtils {
  static void v(LogCreator fn) => _print('V', fn);

  static void d(LogCreator fn) => _print('D', fn);

  static void i(LogCreator fn) => _print('I', fn);

  static void w(LogCreator fn) => _print('W', fn);

  static void e(LogCreator fn) => _print('E', fn);

  static void _print(String level, LogCreator fn) {
    if (kDebugMode) {
      try {
        final message = fn.call();
        print('[$level] $message');
      } catch (e) {
        print('$e');
      }
    }
  }
}
