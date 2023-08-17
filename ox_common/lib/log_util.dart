import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LogUtil{
  static void v(message) => _print('V', message);

  static void d(message) => _print('D', message);

  static void i(message) => _print('I', message);

  static void w(message) => _print('W', message);

  static void e(message) => _print('E', message);

  static void _print(String level, message) => debugPrint('[$level] $message');

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