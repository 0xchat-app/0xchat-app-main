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
    Uint8List? bytes;
    if (BASE64.check(filePath)) {
      bytes = BASE64.toData(filePath);
    } else {
      var file = File(filePath);
      bytes = await file.readAsBytes();

      if (StringUtil.isBlank(fileName)) {
        fileName = filePath.split("/").last;
      }
    }

    if (bytes.isEmpty) {
      return null;
    }

    var fileSize = bytes.length;
    log("file size is $fileSize");
    payload = HashUtil.sha256Bytes(bytes);

    Map<String, String>? headers = {};
    if (StringUtil.isNotBlank(fileName)) {
      var mt = lookupMimeType(fileName!);
      if (StringUtil.isNotBlank(mt)) {
        headers["Content-Type"] = mt!;
      }
    }
    if (StringUtil.isBlank(headers["Content-Type"])) {
      headers["Content-Type"] = lookupMimeType(fileName ?? '') ?? "application/octet-stream";
    }
    // Must set Content-Length so Dio's onSendProgress receives the real total
    // (without it, total == -1 and count/total is negative → progress stuck at 0).
    headers["Content-Length"] = "$fileSize";

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
        // Send bytes as a single chunk so Dio can correctly count sent bytes
        // against Content-Length and fire onSendProgress with real 0→1 progress.
        data: Stream.value(bytes),
        options: Options(
          headers: headers,
          validateStatus: (status) {
            return true;
          },
        ),
        onSendProgress: (count, total) {
          if (total > 0) onProgress?.call(count / total);
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
