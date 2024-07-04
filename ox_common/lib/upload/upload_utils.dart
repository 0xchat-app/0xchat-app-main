import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/model/file_storage_server_model.dart';
import 'package:ox_common/upload/file_type.dart';
import 'package:ox_common/upload/minio_uploader.dart';
import 'package:ox_common/upload/uploader.dart';
import 'package:ox_common/utils/aes_encrypt_utils.dart';
import 'package:ox_common/utils/file_utils.dart';
import 'package:ox_common/utils/ox_server_manager.dart';
import 'package:ox_common/utils/uplod_aliyun_utils.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:path_provider/path_provider.dart';

class UploadUtils {

  static Future<String> uploadFile({
    BuildContext? context,
    params,
    String? encryptedKey,
    required File file,
    required String filename,
    required FileType fileType,
    bool showLoading = true,
  }) async {
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
    FileStorageServer fileStorageServer = OXServerManager.sharedInstance.selectedFileStorageServer;
    String url = '';
    if(_showLoading) OXLoading.show();
    try {
      if (fileStorageServer.protocol == FileStorageProtocol.nip96 || fileStorageServer.protocol == FileStorageProtocol.blossom) {
        final imageServices = fileStorageServer.name;
        url = await Uploader.upload(file.path, imageServices, fileName: filename,imageServiceAddr: fileStorageServer.url) ?? '';
      }

      if(fileStorageServer.protocol == FileStorageProtocol.minio) {
        MinioServer minioServer = fileStorageServer as MinioServer;
        MinioUploader.init(
          url: minioServer.url,
          accessKey: minioServer.accessKey,
          secretKey: minioServer.secretKey,
          bucketName: minioServer.bucketName,
          useSSL: minioServer.useSSL,
          port: minioServer.port,
        );
        url = await MinioUploader.instance.uploadFile(file: file, filename: filename, fileType: fileType);
      }

      if (fileStorageServer.protocol == FileStorageProtocol.oss) {
        url = await UplodAliyun.uploadFileToAliyun(
          context: context,
          file: file,
          filename: filename,
          fileType: convertFileTypeToUploadAliyunType(fileType),
          encryptedKey: encryptedKey,
          showLoading: showLoading,
        );
      }
      if(_showLoading) OXLoading.dismiss();
    } catch (e,s) {
      if (_showLoading) OXLoading.dismiss();
      LogUtil.e('Upload Failed: $e\r\n$s');
    }
    return url;
  }

  static UplodAliyunType convertFileTypeToUploadAliyunType(FileType fileType) {
    switch (fileType) {
      case FileType.image:
        return UplodAliyunType.imageType;
      case FileType.voice:
        return UplodAliyunType.voiceType;
      case FileType.video:
        return UplodAliyunType.videoType;
      case FileType.text:
        return UplodAliyunType.logType;
    }
  }
}