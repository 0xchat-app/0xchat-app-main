import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/foundation.dart';

class HashUtil {
  static String md5(String source) {
    var content = Utf8Encoder().convert(source);
    var digest = crypto.md5.convert(content);
    // digest.toString()
    return hex.encode(digest.bytes);
  }

  static String md5Bytes(List<int> content) {
    var digest = crypto.md5.convert(content);
    return hex.encode(digest.bytes);
  }

  static String sha1Bytes(List<int> content) {
    var digest = crypto.sha1.convert(content);
    return hex.encode(digest.bytes);
  }

  static String sha256Bytes(List<int> content) {
    var digest = crypto.sha256.convert(content);
    return hex.encode(digest.bytes);
  }

  /// [sha256Bytes] off the UI isolate for anything big enough to matter:
  /// hashing a video of tens of MB synchronously froze the UI.
  static Future<String> sha256BytesAsync(List<int> content) {
    if (content.length < 1024 * 1024) return Future.value(sha256Bytes(content));
    return compute(sha256Bytes, content);
  }
}
