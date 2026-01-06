import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:ox_common/upload/upload_exception.dart';
import 'string_util.dart';
import 'base64.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:mime/mime.dart';
import 'hash_util.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:chatcore/chat-core.dart';

// This uploader not complete.
class BolssomUploader {
  static var dio = Dio();

  static Future<String?> upload(String endPoint, String filePath, {
    String? fileName,
    Function(double progress)? onProgress,
  }) async {
    var uri = Uri.tryParse(endPoint);
    if (uri == null) {
      return null;
    }
    var uploadApiPath = Uri(
            scheme: uri.scheme,
            userInfo: uri.userInfo,
            host: uri.host,
            port: uri.port,
            path: "/upload")
        .toString();

    String? payload;
    MultipartFile? multipartFile;
    Uint8List? bytes;
    if (BASE64.check(filePath)) {
      bytes = BASE64.toData(filePath);
    } else {
      var file = File(filePath);
      bytes = file.readAsBytesSync();

      if (StringUtil.isBlank(fileName)) {
        fileName = filePath.split("/").last;
      }
    }

    if (bytes.isEmpty) {
      return null;
    }

    var fileSize = bytes.length;
    log("file size is ${bytes.length}");
    payload = HashUtil.sha256Bytes(bytes);
    multipartFile = MultipartFile.fromBytes(
      bytes,
      filename: fileName,
    );

    Map<String, String>? headers = {};
    if (StringUtil.isNotBlank(fileName)) {
      var mt = lookupMimeType(fileName!);
      if (StringUtil.isNotBlank(mt)) {
        headers["Content-Type"] = mt!;
      }
    }
    if (StringUtil.isBlank(headers["Content-Type"])) {
      if (multipartFile.contentType != null) {
        headers["Content-Type"] = multipartFile.contentType!.mimeType;
      } else {
        headers["Content-Type"] = "multipart/form-data";
      }
    }

    List<List<String>> tags = [];
    tags.add(["t", "upload"]);
    tags.add([
      "expiration",
      ((DateTime.now().millisecondsSinceEpoch ~/ 1000) + 60 * 10).toString()
    ]);
    tags.add(["size", "$fileSize"]);
    tags.add(["x", payload]);
    Event nip98Event = await Event.from(
        kind: 24242,
        tags: tags,
        content: "Upload $fileName",
        pubkey: Account.sharedInstance.currentPubkey,
        privkey: Account.sharedInstance.currentPrivkey);
    headers["Authorization"] =
        "Nostr ${base64Url.encode(utf8.encode(jsonEncode(nip98Event.toJson())))}";

    try {
      var response = await dio.put(
        uploadApiPath,
        // data: formData,
        data: Stream.fromIterable(bytes.map((e) => [e])),
        options: Options(
          headers: headers,
          validateStatus: (status) {
            return true;
          },
        ),
        onSendProgress: (count, total) {
          onProgress?.call(count / total);
        },
      );
      var body = response.data;
      log(jsonEncode(response.data));
      if (body is Map<String, dynamic> && body["url"] != null) {
        return body["url"];
      } else {
        throw UploadException('${uri.host} Bad Gateway');
      }
    } catch (e) {
      print("BolssomUploader.upload upload exception:");
      print(e);
      rethrow;
    }

    return null;
  }
}
