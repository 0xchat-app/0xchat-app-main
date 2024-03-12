import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/uplod_aliyun_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

///Title: error_utils
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/3/5 20:19
class ErrorUtils{
  static Future<void> logErrorToFile(String error) async {
    final directory = await getApplicationDocumentsDirectory();
    int lastTime = await OXCacheManager.defaultOXCacheManager.getForeverData(StorageKeyTool.KEY_SAVE_LOG_TIME, defaultValue: 0);
    int fileNameTime = DateTime.now().millisecondsSinceEpoch;
    if (lastTime + 24 * 3600 * 1000 > fileNameTime) {
      fileNameTime = lastTime;
    } else {
      await OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.KEY_SAVE_LOG_TIME, fileNameTime);
    }
    final path = directory.path + '/'+'0xchat_log_${fileNameTime}.txt';
    final file = File(path);
    await file.writeAsString('\n$error\n', mode: FileMode.append);
    LogUtil.e('John: ErrorUtils--path =${path}');
  }


  static Future<void> sendLogs(BuildContext context, File logFile) async {
    if (await logFile.exists()) {
      String fileName = logFile.path.substring(logFile.path.lastIndexOf('/') + 1);
      final String url = await UplodAliyun.uploadFileToAliyun(
        fileType: UplodAliyunType.logType,
        file: logFile,
        filename: fileName,
      );
      LogUtil.e('John: sendLogs----url =${url}');
    }
  }
}