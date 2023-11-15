
import 'package:flutter/foundation.dart';
import 'package:ox_common/log_util.dart';

class ChatLogUtils {

  static const showInfoLog = kDebugMode;

  static error({String module = 'Chat', required String className, required String funcName, required String message}) {
    LogUtil.e('[Module - $module][$className - $funcName] $message');
  }

  static info({String module = 'Chat', required String className, required String funcName, required String message}) {
    if (showInfoLog)
      LogUtil.i('[Module - $module][$className - $funcName] $message');
  }

  static debug({String module = 'Chat', required String className, required String funcName, MessageCheckLogger? logger}) {
    if (logger == null) return ;
    LogUtil.i('[Module - $module][$className - $funcName] ${logger.log}');
  }
}

class MessageCheckLogger {
  MessageCheckLogger(this.messageId);

  final messageId;

  String printMessage = '';

  String get log => 'message check $printMessage';
}