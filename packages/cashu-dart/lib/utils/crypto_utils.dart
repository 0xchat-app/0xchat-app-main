
import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';
import './tools.dart';

class CryptoUtils {
  static final Uint8List domainSeparator = Uint8List.fromList("Secp256k1_HashToCurve_Cashu_".codeUnits);
  static Uint8List randomPrivateKey() {
    var random = FortunaRandom();
    var randomSeed = Random.secure();
    List<int> seeds = List<int>.generate(32, (_) => randomSeed.nextInt(256));
    random.seed(KeyParameter(Uint8List.fromList(seeds)));

    return random.nextBytes(32);
  }

  static ECPoint getG() {
    return ECCurve_secp256k1().G;
  }
}

extension CryptoUtilsStringEx on String {
  ECPoint pointFromHex() {
    final handler = ECCurve_secp256k1();
    return handler.curve.decodePoint(hexToBytes())!;
  }

  ECPoint hashToCurve() {
    const maxAttempt = 65536;
    Uint8List msgToHash = Uint8List.fromList([...CryptoUtils.domainSeparator, ...asBytes()]);

    var digest = SHA256Digest();
    Uint8List msgHash = digest.process(msgToHash);

    for (int counter = 0; counter < maxAttempt; counter++) {
      Uint8List counterBytes = Uint8List(4)
        ..buffer.asByteData().setUint32(0, counter, Endian.little);
      Uint8List bytesToHash = Uint8List.fromList([...msgHash, ...counterBytes]);

      Uint8List hash = digest.process(bytesToHash);

      try {
        String pointXHex = '02${hash.asHex()}';
        ECPoint point = pointXHex.pointFromHex();
        return point;
      } catch (_) {
        continue;
      }
    }

    throw Exception('Failed to find a valid point after $maxAttempt attempts');
  }
}

extension CryptoUtilsECPointEx on ECPoint {
  String ecPointToHex([bool compressed = true]) {
    return getEncoded(compressed).map(
          (byte) => byte.toRadixString(16).padLeft(2, '0'),
    ).join();
  }
}