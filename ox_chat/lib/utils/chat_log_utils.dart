
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
}