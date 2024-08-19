
import 'package:flutter/foundation.dart';
import 'package:ox_common/log_util.dart';

class ChatLogUtils {

  static const showInfoLog = false;
  // static get showInfoLog => kDebugMode;

  static error({String module = 'Chat', required String className, required String funcName, required String message}) {
    LogUtil.e('[Module - $module][$className - $funcName] $message');
  }

  static info({String module = 'Chat', required String className, required String funcName, required String message}) {
    if (showInfoLog)
      LogUtil.i('[${DateTime.now()}][Module - $module][$className - $funcName] $message');
  }
}

class MessageCheckLogger {
  MessageCheckLogger(this.messageId);

  final messageId;

  void print(String message) {
    LogUtil.i('[Module - Chat][MessageCheckLogger - print] $message');
  }
}