import 'dart:io';
import 'dart:typed_data';

import 'package:chatcore/chat-core.dart';
import 'package:encrypt/encrypt.dart';
import 'package:ox_common/log_util.dart';

class AesEncryptUtils{
  static String _getUploadFileKey(){
    return "nostr@chat*yuele";
  }

  static void encryptFile(File sourceFile, File encryptedFile, String pubkey) {
    final sourceBytes = sourceFile.readAsBytesSync();
    Uint8List? uint8list = Contacts.sharedInstance.getFriendSharedSecret(pubkey);
    final encrypter = Encrypter(AES(Key(uint8list!)));
    final iv = IV.fromLength(16);
    final encryptedBytes = encrypter.encryptBytes(sourceBytes, iv: iv);
    encryptedFile.writeAsBytesSync(encryptedBytes.bytes);
  }

  static void decryptFile(File encryptedFile, File decryptedFile, String pubkey) {
    final encryptedBytes = encryptedFile.readAsBytesSync();
    Uint8List? uint8list = Contacts.sharedInstance.getFriendSharedSecret(pubkey);
    final decrypter = Encrypter(AES(Key(uint8list!)));
    final encrypted = Encrypted(encryptedBytes);
    final iv = IV.fromLength(16);
    final decryptedBytes = decrypter.decryptBytes(encrypted, iv: iv);

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






