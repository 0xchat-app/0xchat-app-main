import 'package:flutter/foundation.dart';

class LogUtil {
  static void v(message) => _print('V', message);

  static void d(message) => _print('D', message);

  static void i(message) => _print('I', message);

  static void w(message) => _print('W', message);

  static void e(message) => _print('E', message, true);

  static void _print(String level, message, [force = false]) =>
      log(content: '[$level] $message', force: force);

  static void log({
    String? key = 'OX Pro',
    required String content,
    bool force = false,
  }) {
    if (kDebugMode || force) {
      try {
        print('$key: $content');
      } catch (e) {
        print('$key: $e');
      }
    }
  }
}