
import 'dart:typed_data';
import 'package:cashu_dart/utils/crypto_utils.dart';
import 'package:cashu_dart/utils/tools.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/pointycastle.dart';
import '../../../utils/log_util.dart';
import '../DHKE.dart';
import '../nut_00.dart';
import '../token/proof_isar.dart';

class Nut12 {
  static bool? verifyBlindSignature({
    required BlindedSignature signature,
    required String B_,
    required String publicKey,
  }) {
    final dleq = signature.dleq;
    if (dleq == null || dleq.isEmpty) return null;

    final eHex = dleq['e'];
    final sHex = dleq['s'];
    if (eHex is! String || eHex.isEmpty ||
        sHex is! String || sHex.isEmpty) return null;

    final C_Hex = signature.C_;

    return DLEQ.verify(
      AHex: publicKey,
      B_Hex: B_,
      C_Hex: C_Hex,
      eHex: eHex,
      sHex: sHex,
    );
  }

  static bool? verifyProof({
    required ProofIsar proof,
    required String publicKey,
  }) {
    // Check if DLEQ proof exists
    final dleq = proof.dleq;
    if (dleq == null || dleq.isEmpty) return null;

    final eHex = dleq['e'];
    final sHex = dleq['s'];
    final rHex = dleq['r'];
    if (eHex is! String || eHex.isEmpty ||
        sHex is! String || sHex.isEmpty ||
        rHex is! String || rHex.isEmpty) return null;

    // Get blinding factor r from DLEQ proof
    final rScalar = rHex.asBigInt(radix: 16);

    // Get B' by DHKE.blindMessage
    final (B_Hex, _) = DHKE.blindMessage(proof.secret, rScalar);

    // Calculate C' = C + r*A (blinded signature)
    final CPoint = proof.C.pointFromHex();
    final rA = publicKey.pointFromHex() * rScalar;
    final C_ = CPoint + rA;
    if (C_ == null) return false;

    // LogUtils.d(() => '[DLEQ - verify] secret: ${proof.secret}');
    // LogUtils.d(() => '[DLEQ - verify] e: $eHex');
    // LogUtils.d(() => '[DLEQ - verify] s: $sHex');
    // LogUtils.d(() => '[DLEQ - verify] r: $rHex');
    // LogUtils.d(() => '[DLEQ - verify] B\': $B_Hex');
    // LogUtils.d(() => '[DLEQ - verify] C\': ${C_.ecPointToHex()}');
    // Verify DLEQ proof
    return DLEQ.verify(
      AHex: publicKey,
      B_Hex: B_Hex,
      C_Hex: C_.ecPointToHex(),
      eHex: eHex,
      sHex: sHex,
    );
  }
}

class DLEQ {
  static bool verify({
    required String AHex,
    required String B_Hex,
    required String C_Hex,
    required String eHex,
    required String sHex,
  }) {

    // Convert e and s to scalars
    final eScalar = eHex.asBigInt(radix: 16);
    final sScalar = sHex.asBigInt(radix: 16);

    // Parse the public key
    final APoint = AHex.pointFromHex();

    // B' and C' are part of the signature
    final B_Point = B_Hex.pointFromHex(); // B'
    final C_Point = C_Hex.pointFromHex(); // C'

    // a = e * A
    final a = APoint * eScalar;
    if (a == null) return false;

    // R1 = s * G - a
    final sG = CryptoUtils.getG() * sScalar;
    if (sG == null) return false;
    final r1 = sG - a;
    if (r1 == null) return false;

    // b = s * B'
    final b = B_Point * sScalar;
    if (b == null) return false;

    // c = e * C'
    final c = C_Point * eScalar;
    if (c == null) return false;

    // R2 = b - c
    final r2 = b - c;
    if (r2 == null) return false;

    // Hash(R1, R2, A, C')
    final hashEHex = hashE([
      r1,
      r2,
      APoint,
      C_Point,
    ]).asHex();
    // LogUtils.d(() => '[DLEQ - verify] r1: ${r1.ecPointToHex()}');
    // LogUtils.d(() => '[DLEQ - verify] r2: ${r2.ecPointToHex()}');
    // LogUtils.d(() => '[DLEQ - verify] A: ${APoint.ecPointToHex()}');
    // LogUtils.d(() => '[DLEQ - verify] C\': ${C_Point.ecPointToHex()}');

    // Compare e with hashE
    if (eHex.toLowerCase() != hashEHex.toLowerCase()) {
      LogUtils.d(() => '[DLEQ - verify] hashEHex: $hashEHex');
      LogUtils.d(() => '[DLEQ - verify] expect  : $eHex');
      return false;
    }

    return true;
  }

  static Uint8List hashE(List<ECPoint> publicKeys) {
    final concat = publicKeys.map((pk) => pk.ecPointToHex(false)).join();
    return SHA256Digest().process(concat.asBytes());
  }
}