import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:nostr_core_dart/nostr.dart';

Future<void> main() async {
  var sender = Keychain.generate();
  print(sender.private);
  var receiver = Keychain.generate();
  print(receiver.public);
  Event event =
      await Nip44.encode(receiver.public, "SDKFS.哈哈", "", sender.private);
  print(event.content);

  EDMessage edMessage =
      await Nip44.decode(event, receiver.public, receiver.private);
  print(edMessage.content);

  var priv = 'fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364139';
  var pubkey =
      '0000000000000000000000000000000000000000000000000000000000000002';
  var sharedkey = Nip44.shareSecret(priv, pubkey);
  print(bytesToHex(sharedkey));

  ///  "nonce": "f481750e13dfa90b722b7cce0db39d80b0db2e895cc3001a",
  ///       "plaintext": "a",
  var nonce = 'f481750e13dfa90b722b7cce0db39d80b0db2e895cc3001a';
  var plaintext = 'a';
  String test = await testencrypt(sharedkey, hexToBytes(nonce), plaintext);
  print(test);
}

Future<String> testencrypt(
    List<int> secretKey, List<int> nonce, String content) async {
  final algorithm = Xchacha20(macAlgorithm: MacAlgorithm.empty);
// Generate a random 96-bit nonce.
  final uintInputText = utf8.encode(content);
// Encrypt
  final secretBox = await algorithm.encrypt(
    uintInputText,
    secretKey: SecretKey(secretKey),
    nonce: nonce,
  );

  List<int> result = [];
  result.add(1);
  result.addAll(nonce);
  result.addAll(secretBox.cipherText);

  return base64Encode(result);
}
