import 'package:flutter/foundation.dart';

class LogUtil {
  static void v(message) => _print('V', message);

  static void d(message) => _print('D', message);

  static void i(message) => _print('I', message);

  static void w(message) => _print('W', message);

  static void e(message) => _print('E', message);

  static void _print(String level, message) =>
      log(content: '[$level] $message');

  /// Release builds never print: log lines routinely carry tokens, receipts
  /// and message content, and device logs are readable over adb/Console.
  static void log({
    String? key = 'OX Pro',
    required String content,
  }) {
    if (kDebugMode) {
      try {
        print('$key: $content');
      } catch (e) {
        print('$key: $e');
      }
    }
  }
}