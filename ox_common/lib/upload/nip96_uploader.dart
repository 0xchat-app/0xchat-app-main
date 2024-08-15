import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:mime/mime.dart';
import 'hash_util.dart';
import 'string_util.dart';
import 'base64.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:chatcore/chat-core.dart';
import 'nip96_info_loader.dart';
import 'package:http_parser/http_parser.dart';

class NIP96Uploader {
  static var dio = Dio();

  static Future<String?> upload(String serverUrl, String filePath, {
    String? fileName,
    Function(double progress)? onProgress,
  }) async {
    var sa = await NIP96InfoLoader.getInstance().getServerAdaptation(serverUrl);
    if (sa == null || StringUtil.isBlank(sa.apiUrl)) {
      return null;
    }
    // log(jsonEncode(sa.toJson()));

    bool isNip98Required = false;
    if (sa.plans != null &&
        sa.plans != null &&
        sa.plans!.free != null &&
        sa.plans!.free!.isNip98Required != null) {
      isNip98Required = sa.plans!.free!.isNip98Required!;
    }

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

    // log("file size is ${bytes.length}");

    payload = HashUtil.sha256Bytes(bytes);
    final mimeType = lookupMimeType(filePath) ?? 'application/octet-stream';
    multipartFile = MultipartFile.fromBytes(
      bytes,
      filename: fileName,
      contentType: MediaType.parse(mimeType)
    );

    Map<String, String>? headers = {};
    if (StringUtil.isBlank(headers["Content-Type"])) {
        headers["Content-Type"] = "multipart/form-data";
      }

    if (isNip98Required) {
      List<List<String>> tags = [];
      tags.add(["u", sa.apiUrl ?? '']);
      tags.add(["method", "POST"]);
      if (StringUtil.isNotBlank(payload)) {
        tags.add(["payload", payload]);
      }

      Event nip98Event = await Event.from(
          kind: 27235,
          tags: tags,
          content: "",
          pubkey: Account.sharedInstance.currentPubkey,
          privkey: Account.sharedInstance.currentPrivkey);

      headers["Authorization"] =
          "Nostr ${base64Url.encode(utf8.encode(jsonEncode(nip98Event.toJson())))}";
    }

    var formData = FormData.fromMap({"file": multipartFile});
    try {
      var response = await dio.post(sa.apiUrl!,
        data: formData,
        options: Options(
          headers: headers,
        ),
        onSendProgress: (count, total) {
          onProgress?.call(count / total);
        },
      );
      var body = response.data;
      // log(jsonEncode(response.data));
      if (body is Map<String, dynamic> &&
          body["status"] == "success" &&
          body["nip94_event"] != null) {
        var nip94Event = body["nip94_event"];
        if (nip94Event["tags"] != null) {
          for (var tag in nip94Event["tags"]) {
            if (tag is List && tag.length > 1) {
              var k = tag[0];
              var v = tag[1];

              if (k == "url") {
                return v;
              }
            }
          }
        }
      }
    } catch (e) {
      print("nostr.build nip96 upload exception:");
      print(e);
      rethrow;
    }

    return null;
  }
}
