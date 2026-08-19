import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;

const String STANDARD_DERIVATION_PATH = "m/129372'/0'";

enum DerivationType {
  secret(0),
  blinding_factor(1);

  const DerivationType(this.value);
  final int value;
  
  static DerivationType? fromValue(dynamic value) {
    return DerivationType.values.where((element) => element.value == value).firstOrNull;
  }
}

class Nut13 {
  static String generateMnemonic() {
    return bip39.generateMnemonic();
  }

  static Uint8List mnemonicToSeed(String mnemonic) {
    return bip39.mnemonicToSeed(mnemonic);
  }

  static Uint8List deriveSecret(Uint8List seed, String keysetId, int counter) {
    return derive(seed, keysetId, counter, DerivationType.secret.value);
  }

  static Uint8List deriveBlindingFactor(
      Uint8List seed, String keysetId, int counter) {
    return derive(seed, keysetId, counter, DerivationType.blinding_factor.value);
  }

  static Uint8List derive(Uint8List seed, String keysetId, int counter,
      int secretOrBlinding) {
    var hdkey = bip32.BIP32.fromSeed(seed);
    var keysetIdInt = getKeysetIdInt(keysetId);
    var derivationPath =
        "${STANDARD_DERIVATION_PATH}/${keysetIdInt}'/${counter}'/${secretOrBlinding}";
    print(derivationPath);
    var derived = hdkey.derivePath(derivationPath);
    var privateKey = derived.privateKey;
    if (privateKey == null) {
      throw Exception('Could not derive private key');
    }
    return privateKey;
  }

  static int getKeysetIdInt(String keysetId) {
    int keysetIdInt;
    // RegExp regex = RegExp(r'/^[a-fA-F0-9]+$/');

    int mod = pow(2, 31).toInt() - 1;

    // if (regex.hasMatch(keysetId)) {
      keysetIdInt = int.parse(keysetId, radix: 16) % mod;
    // } else {
    //   //legacy keyset compatibility
    //   keysetIdInt =
    //       int.parse(toHexString(base64.decoder.convert(keysetId)), radix: 16) %
    //           mod;
    // }
    return keysetIdInt;
  }
}

String toHexString(Uint8List bytes) => bytes.fold<String>(
    '', (str, byte) => str + byte.toRadixString(16).padLeft(2, '0'));

Uint8List hexToUint8List(String hex) {
  if (hex.length % 2 != 0) {
    throw 'Odd number of hex digits';
  }
  var l = hex.length ~/ 2;
  var result = Uint8List(l);
  for (var i = 0; i < l; ++i) {
    var x = int.parse(hex.substring(2 * i, 2 * (i + 1)), radix: 16);
    if (x.isNaN) {
      throw 'Expected hex string';
    }
    result[i] = x;
  }
  return result;
}
