import 'package:dio/dio.dart';
import 'base64.dart';

class NostrfilesDevUploader {
  static var dio = Dio();

  static final String UPLOAD_ACTION = "https://nostrfiles.dev/upload_image";

  static Future<String?> upload(String filePath, {String? fileName}) async {
    MultipartFile? multipartFile;
    if (BASE64.check(filePath)) {
      var bytes = BASE64.toData(filePath);
      multipartFile = await MultipartFile.fromBytes(
        bytes,
        filename: fileName,
      );
    } else {
      multipartFile = await MultipartFile.fromFile(
        filePath,
        filename: fileName,
      );
    }

    var formData = FormData.fromMap({"file": multipartFile});
    var response = await dio.post(
      UPLOAD_ACTION,
      data: formData,
    );

    var body = response.data;
    if (body is Map<String, dynamic>) {
      return body["url"] as String;
    }

    return null;
  }
}
