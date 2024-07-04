import 'dart:io';
import 'package:minio/io.dart';
import 'package:minio/minio.dart';
import 'package:ox_common/upload/file_type.dart';

class MinioUploader {

  static MinioUploader? _instance;

  late Minio _minio;
  late String bucketName;

  factory MinioUploader() => _instance!;

  MinioUploader._internal();

  static MinioUploader get instance {
    _instance ??= MinioUploader._internal();
    return _instance!;
  }

  static MinioUploader init({
    required String url,
    required String accessKey,
    required String secretKey,
    required String bucketName,
    int? port,
    bool? useSSL,
  }) {
    _instance = MinioUploader._internal();
    final uri = Uri.parse(url);
    String endPoint = uri.hasScheme ? url.replaceFirst('${uri.scheme}://', '') : url ;
    final useSSL = uri.scheme == 'https';
    final port = uri.port == 0 ? null : uri.port;
    _instance!._minio = Minio(
      endPoint: endPoint,
      accessKey: accessKey,
      secretKey: secretKey,
      useSSL: useSSL,
      port: port,
    );
    _instance!.bucketName = bucketName;
    return _instance!;
  }

  Future<String> uploadFile({required File file, required String filename, required FileType fileType}) async {
    final fileFolder = getFileFolders(fileType);
    final objectName = '$fileFolder$filename';
    await _minio.fPutObject(bucketName, objectName, file.path);
    int expires = 7 * 24 * 60 * 60;
    return await _minio.presignedGetObject(bucketName, objectName, expires: expires);
  }

  Future<bool> bucketExists() async {
    return await _minio.bucketExists(bucketName);
  }

  static String getFileFolders(FileType fileType) {
    switch (fileType) {
      case FileType.image:
        return 'images/';
      case FileType.video:
        return 'video/';
      case FileType.voice:
        return 'voice/';
      case FileType.text:
        return 'text/';
    }
  }
}
