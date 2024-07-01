import 'package:minio/minio.dart';

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
    required String endPoint,
    required String accessKey,
    required String secretKey,
    required String bucketName,
    int? port,
    bool? useSSL,
  }) {
    var instance = MinioUploader.instance;
    instance._minio = Minio(
      endPoint: endPoint,
      accessKey: accessKey,
      secretKey: secretKey,
      port: port,
      useSSL: useSSL ?? true,
    );
    bucketName = bucketName;
    return instance;
  }

  // static Future<String> uploadFile() {
  //
  // }

}
