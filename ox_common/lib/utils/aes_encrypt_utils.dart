import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:nostr_core_dart/nostr.dart';

class AesEncryptUtils{
  static String _getUploadFileKey(){
    return "nostr@chat*yuele";
  }

  static void encryptFile(File sourceFile, File encryptedFile, String key) {
    final sourceBytes = sourceFile.readAsBytesSync();
    final uint8list = hexToBytes(key);
    final encrypter = Encrypter(AES(Key(uint8list)));
    final iv = IV.fromLength(16);
    final encryptedBytes = encrypter.encryptBytes(sourceBytes, iv: iv);
    encryptedFile.writeAsBytesSync(encryptedBytes.bytes);
  }

  static void decryptFile(File encryptedFile, File decryptedFile, String key, {Function(List<int>)? bytesCallback}) {
    final encryptedBytes = encryptedFile.readAsBytesSync();
    final uint8list = hexToBytes(key);
    final decrypter = Encrypter(AES(Key(uint8list)));
    final encrypted = Encrypted(encryptedBytes);
    final iv = IV.fromLength(16);
    final decryptedBytes = decrypter.decryptBytes(encrypted, iv: iv);
    bytesCallback?.call(decryptedBytes);
    decryptedFile.writeAsBytesSync(decryptedBytes);
  }

  static String aes128Decrypt(String encryptText, { String? keyStr}) {
    if(keyStr == null){
      keyStr = _getUploadFileKey();
    }
    final key = Key.fromUtf8(keyStr);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key, mode: AESMode.ecb));
    final encrypted = Encrypted.fromBase64(encryptText);
    // final encrypted = encrypter.encrypt(plainText, iv: iv);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  }

}






