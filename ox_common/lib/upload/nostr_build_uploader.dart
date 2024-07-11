import 'package:dio/dio.dart';
import 'base64.dart';

class NostrBuildUploader {
  static var dio = Dio();

  static final String UPLOAD_ACTION = "https://nostr.build/api/v2/upload/files";

  static Future<String?> upload(String filePath, {String? fileName}) async {
    MultipartFile? multipartFile;
    if (BASE64.check(filePath)) {
      var bytes = BASE64.toData(filePath);
      multipartFile = MultipartFile.fromBytes(
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
    try{
      var response = await dio.post(UPLOAD_ACTION, data: formData);
      var body = response.data;
      if (body is Map<String, dynamic> && body["status"] == "success") {
        return body["data"][0]["url"];
      }
    }catch(e){
      rethrow;
    }

    return null;
  }
}
