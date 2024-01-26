import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

/// Title: encrypt_utils
/// Copyright: Copyright (c) 2023
///
/// @author john
/// @CheckItem Fill in by oneself
class EncryptUtils {

  static Encrypter? encrypter;

  // RSA encryption
  static Future<String> encrypt(String data) async {
    // The encrypted byte array is converted to base64 encoding and returned
    if(encrypter==null)return data;
    String base64Str = encrypter!.encrypt(data).base64;
    return base64Str;
  }

  // RSA decryption
  static Future<String> decrypt(String data) async {
    if(encrypter==null)return data;
    String resultStr = encrypter!.decrypt(Encrypted.fromBase64(data));
    return resultStr;
  }

  // md5 encryption
  static String generateMd5(String data) {
    return md5.convert(utf8.encode(data)).toString();
  }
  // SHA256 encryption
  static String sha256Base64(String secretKey, String data) {
    var key = utf8.encode(secretKey);
    var bytes = utf8.encode(data);
    var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
    var digest =base64Encode(hmacSha256.convert(bytes).bytes) ;
    return digest;
  }

}
