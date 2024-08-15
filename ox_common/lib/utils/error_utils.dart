import 'dart:async';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/utils/user_config_tool.dart';
import 'package:ox_common/upload/file_type.dart';
import 'package:ox_common/upload/upload_utils.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/uplod_aliyun_utils.dart';
import 'package:ox_common/business_interface/ox_chat/interface.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'dart:io';

///Title: error_utils
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/3/5 20:19
class ErrorUtils{
  static Future<void> logErrorToFile(String error) async {
    final directory = await getApplicationDocumentsDirectory();
    int lastTime = UserConfigTool.getSetting(StorageSettingKey.KEY_SAVE_LOG_TIME.name, defaultValue: 0) as int;
    int fileNameTime = DateTime.now().millisecondsSinceEpoch;
    if (lastTime + 24 * 3600 * 1000 > fileNameTime) {
      fileNameTime = lastTime;
    } else {
      UserConfigTool.saveSetting(StorageSettingKey.KEY_SAVE_LOG_TIME.name, fileNameTime);
    }
    final path = directory.path + '/'+'0xchat_log_${fileNameTime}.txt';
    final file = File(path);
    List<String> errorLogs = [];
    if (await file.exists()) {
      final existingContent = await file.readAsString();
      errorLogs = existingContent.split('\n').where((line) => line.isNotEmpty).toList();
    }
    errorLogs.add(error);
    if (errorLogs.length > 20) {
      errorLogs = errorLogs.sublist(errorLogs.length - 20);
    }
    await file.writeAsString(errorLogs.join('\n') + '\n');
    LogUtil.e('John: ErrorUtils--path =${path}');
  }


  static Future<void> sendLogs(BuildContext context, File logFile) async {
    if (await logFile.exists()) {
      String createEncryptKey = bytesToHex(MessageDBISAR.getRandomSecret());
      String fileName = logFile.path.substring(logFile.path.lastIndexOf('/') + 1);
      try {
        UploadResult result = await UploadUtils.uploadFile(
          fileType: FileType.text,
          file: logFile,
          filename: fileName,
          encryptedKey: createEncryptKey,
        );
        if (result.isSuccess && result.url.isNotEmpty) {
          OXChatInterface.sendEncryptedFileMessage(
            context,
            url: result.url,
            receiverPubkey: '7adb520c3ac7cb6dc8253508df0ce1d975da49fefda9b5c956744a049d230ace',
            key: createEncryptKey,
            title: 'Log File',
            subtitle: fileName,
          );
          CommonToast.instance.show(context, Localized.text('ox_chat.sent_successfully'));
        }
      } catch (e) {
        UploadResult result = UploadExceptionHandler.handleException(e);
        CommonToast.instance.show(context, result.errorMsg ?? e.toString());
      }

    }
  }
}