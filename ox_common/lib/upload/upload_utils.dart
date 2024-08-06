import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:minio/minio.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/model/file_storage_server_model.dart';
import 'package:ox_common/upload/file_type.dart';
import 'package:ox_common/upload/minio_uploader.dart';
import 'package:ox_common/upload/upload_exception.dart';
import 'package:ox_common/upload/uploader.dart';
import 'package:ox_common/utils/aes_encrypt_utils.dart';
import 'package:ox_common/utils/file_utils.dart';
import 'package:ox_common/utils/ox_server_manager.dart';
import 'package:ox_common/utils/uplod_aliyun_utils.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart';
import 'package:dio/dio.dart';

class UploadUtils {

  static Future<UploadResult> uploadFile({
    BuildContext? context,
    params,
    String? encryptedKey,
    required File file,
    required String filename,
    required FileType fileType,
    bool showLoading = true,
    Function(double progress)? onProgress,
  }) async {
    File? encryptedFile;
    if(encryptedKey != null) {
      String directoryPath = '';
      if (Platform.isAndroid) {
        Directory? externalStorageDirectory = await getExternalStorageDirectory();
        if (externalStorageDirectory == null) {
          return UploadResult.error('Storage function abnormal');
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
      final protocol = fileStorageServer.protocol;
      switch (protocol) {
        case  FileStorageProtocol.nip96:
        case  FileStorageProtocol.blossom:
          final imageServices = fileStorageServer.name;
          url = await Uploader.upload(
              file.path,
              imageServices,
              fileName: filename,
              imageServiceAddr: fileStorageServer.url,
              onProgress: onProgress,
          ) ?? '';
          break;
        case FileStorageProtocol.minio:
          MinioServer minioServer = fileStorageServer as MinioServer;
          MinioUploader.init(
            url: minioServer.url,
            accessKey: minioServer.accessKey,
            secretKey: minioServer.secretKey,
            bucketName: minioServer.bucketName,
            useSSL: minioServer.useSSL,
            port: minioServer.port,
          );
          url = await MinioUploader.instance.uploadFile(
            file: file,
            filename: filename,
            fileType: fileType,
            onProgress: onProgress,
          );
          break;
        case FileStorageProtocol.oss:
          url = await UplodAliyun.uploadFileToAliyun(
            context: context,
            file: file,
            filename: filename,
            fileType: convertFileTypeToUploadAliyunType(fileType),
            showLoading: showLoading,
            onProgress: onProgress,
          );
          break;
      }
      if(_showLoading) OXLoading.dismiss();
    } catch (e,s) {
      if (_showLoading) OXLoading.dismiss();
      return UploadExceptionHandler.handleException(e,s);
    }
    return UploadResult.success(url);
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

class UploadResult {
  final bool isSuccess;
  final String url;
  final String? errorMsg;

  UploadResult({required this.isSuccess, required this.url, this.errorMsg});

  factory UploadResult.success(String url) {
    return UploadResult(isSuccess: true, url: url);
  }

  factory UploadResult.error(String errorMsg) {
    return UploadResult(isSuccess: false, url: '', errorMsg: errorMsg);
  }

  @override
  String toString() {
    return '${super.toString()}, url: $url, isSuccess: $isSuccess, errorMsg: $errorMsg';
  }
}

class UploadExceptionHandler {
  static const errorMessage = 'Unable to connect to the file storage server.';

  static UploadResult handleException(dynamic e,[dynamic s]) {
    LogUtil.e('Upload File Exception Handler: $e\r\n$s');
    if (e is ClientException) {
      return UploadResult.error(e.message);
    } else if (e is MinioError) {
      return UploadResult.error(e.message ?? errorMessage);
    } else if (e is DioException) {
      if(e.type == DioExceptionType.badResponse) {
        String errorMsg = '';
        dynamic data = e.response?.data;
        if(data != null){
          if(data is Map) {
            errorMsg = data['message'];
          }
          if(data is String) {
            errorMsg = data;
          }
        }
        return UploadResult.error(errorMsg);
      }
      return UploadResult.error(parseError(e));
    } else if (e is UploadException) {
      return UploadResult.error(e.message);
    } else {
      return UploadResult.error(errorMessage);
    }
  }

  static String parseError(dynamic e) {
    String errorMsg = e.message ?? errorMessage;
    if (e.error is SocketException) {
      SocketException socketException = e.error as SocketException;
      errorMsg = socketException.message;
    }
    if (e.error is HttpException) {
      HttpException httpException = e.error as HttpException;
      errorMsg = httpException.message;
    }
    return errorMsg;
  }
}

class UploadManager {
  static final UploadManager shared = UploadManager._internal();
  UploadManager._internal() { }

  Map<String, StreamController<double>> uploadStreamMap = {};

  Future<void> uploadImage({
    required FileType fileType,
    required String filePath,
    required String messageId,
    required uploadId,
    String? encryptedKey,
  }) async {
    if (uploadStreamMap.containsKey(uploadId)) return ;
    
    final streamController = StreamController<double>();
    uploadStreamMap[uploadId] = streamController;

    final file = File(filePath);
    
    UploadUtils.uploadFile(
      file: file,
      filename: 'test.heic',
      fileType: FileType.image,
      onProgress: (progress) {
        streamController.add(progress);
      }
    ).then((result) {
      streamController.close();
      if (!result.isSuccess) {
        uploadStreamMap.remove(uploadId);
      }
    });
  }

  Stream<double> getUploadProgress(String uploadId) {
    final controller = uploadStreamMap[uploadId];
    if (controller == null) {
      return Stream.value(0.0);
    }
    return controller.stream;
  }
}