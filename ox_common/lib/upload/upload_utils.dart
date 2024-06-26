import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/upload/uploader.dart';
import 'package:ox_common/utils/aes_encrypt_utils.dart';
import 'package:ox_common/utils/file_utils.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:path_provider/path_provider.dart';

class UploadUtils {

  static Future<String> uploadFile(
      {BuildContext? context,
      params,
      String? encryptedKey,
      required File file,
      required String filename,
      bool showLoading = true}) async {

    File? encryptedFile;
    if(encryptedKey != null) {
      String directoryPath = '';
      if (Platform.isAndroid) {
        Directory? externalStorageDirectory = await getExternalStorageDirectory();
        if (externalStorageDirectory == null) {
          CommonToast.instance.show(context, 'Storage function abnormal');
          return Future.value('');
        }
        directoryPath = externalStorageDirectory.path;
      } else if (Platform.isIOS) {
        Directory temporaryDirectory = await getTemporaryDirectory();
        directoryPath = temporaryDirectory.path;
      }
      encryptedFile = FileUtils.createFolderAndFile(directoryPath + "/encrytedfile", filename);
      AesEncryptUtils.encryptFile(file, encryptedFile, encryptedKey);
      file = encryptedFile;
    }
    final _showLoading = showLoading && (context != null);
    print('---------begin upload....');
    String? url = await Uploader.upload(file.path, 'nosto.re', fileName: filename);
    print('--------- upload done: $url');
    if (_showLoading) OXLoading.dismiss();
    return '';
  }
}