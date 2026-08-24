import 'dart:typed_data';
import 'package:nostr_core_dart/nostr.dart';

void main() {
  String user1 = "877069ebb03f3936910880847c27ec9c0e693b57e68d53b7b5038f86984bcba8";
  Uint8List privateKey = hexToBytes(user1);
  String password = "a1B89002";

  Uint8List encryptedPrivateKey = encryptPrivateKey(privateKey, password);
  print('Encrypted Private Key: ${bytesToHex(encryptedPrivateKey)}');

  Uint8List decryptedPrivateKey = decryptPrivateKey(encryptedPrivateKey, password);
  print('Decrypted Private Key: ${bytesToHex(decryptedPrivateKey)}');
}
