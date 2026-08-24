import 'dart:typed_data';
import 'package:kepler/kepler.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:bip340/bip340.dart' as bip340;


void main() {

  String user1 = "877069ebb03f3936910880847c27ec9c0e693b57e68d53b7b5038f86984bcba8";
  String user2 = "cf7cf1e69fe90f81cf0e7bfe952ac14295cc291046386b336fe0bd7ce1c65559";

  String user1Public = bip340.getPublicKey(user1);
  String user2Public = bip340.getPublicKey(user2);
  print(user1Public);
  print(user2Public);

  final secretIV = Kepler.byteSecret(user1, '02$user2Public');
  Uint8List tweak = Uint8List.fromList(secretIV[0]);

  Uint8List derivedPrivateKey = tweakAdd(hexToBytes(user1), tweak);
  String derivedKey = bytesToHex(derivedPrivateKey);
  print('Derived Private Key: $derivedKey');

  String derivedPubKey = bip340.getPublicKey(derivedKey);
  print('Derived Public Key: $derivedPubKey');
}




