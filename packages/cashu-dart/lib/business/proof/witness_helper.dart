
import 'dart:convert';

import 'package:cashu_dart/cashu_dart.dart';

import '../../core/nuts/token/proof_isar.dart';
import '../../core/nuts/v1/nut_14.dart';
import '../../utils/log_util.dart';
import '../wallet/cashu_manager.dart';

class WitnessHelper {
  static Future addP2PKWitnessToProof({
    required ProofIsar proof,
    required P2PKSecret secret,
    P2PKWitnessParam? param,
  }) async {
    final pubkeyList = param?.pubkeyList ?? [];
    final defaultKey = CashuManager.shared.defaultSignPubkey?.call() ?? '';
    final immutablePubkeyList = {
      ...pubkeyList,
      if (defaultKey.isNotEmpty)
        defaultKey
    };
    // NUT-11: a witness signature is only meaningful when it comes from a key
    // that is actually part of this P2PK lock. Signing with a key that is not
    // in the lock (e.g. the account key for a proof locked to someone else)
    // turns the signer into an oracle that produces valid witnesses for
    // arbitrary third-party locks, which lets funds move out of proofs the user
    // does not own. Mirror the membership check the HTLC path already performs.
    final authorizedKeys = _p2pkAuthorizedSignKeys(secret);
    try {
      final witnessRaw = proof.witness;
      Map witness = {};
      if (witnessRaw.isNotEmpty) {
        witness = jsonDecode(witnessRaw) as Map;
      }
      var originSign = witness['signatures'];
      if (originSign is! List) {
        originSign = [];
      }
      final signatures = [...originSign.map((e) => e.toString()).toList().cast<String>()];
      for (var pubkey in immutablePubkeyList) {
        if (!authorizedKeys.contains(_normalizeP2PKPubkey(pubkey))) {
          LogUtils.i(() => '[WitnessHelper - addP2PKWitnessToProof] '
              'skip signing: key is not part of the P2PK lock');
          continue;
        }
        final sign = await CashuManager.shared.signFn?.call(pubkey, proof.secret);
        if (sign != null && sign.isNotEmpty) signatures.add(sign);
      }

      if (signatures.isNotEmpty) {
        witness['signatures'] = signatures;
      }

      if (witness.isNotEmpty) {
        proof.witness = jsonEncode(witness);
      }
    } catch (e, stack) {
      LogUtils.e(() => '[WitnessHelper - addP2PKWitnessToProof] $e');
      LogUtils.e(() => '[WitnessHelper - addP2PKWitnessToProof] $stack');
    }
  }

  /// The set of keys that are allowed to produce a witness for [secret],
  /// normalised to the bare x-only form (see [_normalizeP2PKPubkey]).
  ///
  /// Before the locktime expires these are the receive keys (the primary data
  /// key plus the `pubkeys` tag). After the locktime expires the refund keys
  /// take over when present; if no refund keys are set the proof is spendable
  /// without a signature (NUT-11), so no key needs to sign.
  static Set<String> _p2pkAuthorizedSignKeys(P2PKSecret secret) {
    final receiveKeys = <String>{
      if (secret.data.isNotEmpty) _normalizeP2PKPubkey(secret.data),
      ...secret.receivePubKeys.map(_normalizeP2PKPubkey),
    };
    final refundKeys = secret.refundPubKeys
        .where((e) => e.isNotEmpty)
        .map(_normalizeP2PKPubkey)
        .toSet();

    final lockTime = secret.lockTime;
    final locktimeExpired = lockTime != null && lockTime.isBefore(DateTime.now());
    if (locktimeExpired) {
      // Past the locktime only the refund keys (if any) may claim the proof.
      return refundKeys;
    }
    return receiveKeys;
  }

  /// Cashu P2PK locking keys are compressed secp256k1 points (`02`/`03` + 64
  /// hex), while the account signing key is handled in its bare x-only form.
  /// Strip the parity prefix so the two representations compare equal.
  static String _normalizeP2PKPubkey(String key) {
    var normalized = key.toLowerCase();
    if (normalized.length == 66 &&
        (normalized.startsWith('02') || normalized.startsWith('03'))) {
      normalized = normalized.substring(2);
    }
    return normalized;
  }

  static Future addHTLCWitnessToProof({
    required ProofIsar proof,
    required HTLCSecret secret,
    HTLCWitnessParam? param,
  }) async {

    var pubkey = param?.pubkey ?? '';
    if (pubkey.isEmpty) {
      pubkey = CashuManager.shared.defaultSignPubkey?.call() ?? '';
    }

    final preimage = param?.preimage ?? '';
    if (preimage.isEmpty) return ;

    try {
      final witness = HTLCWitness(preimage: preimage);

      // Signature
      if (secret.receivePubKeys.contains(pubkey) || secret.refundPubKeys.contains(pubkey)) {
        final sign = await CashuManager.shared.signFn?.call(pubkey, proof.secret);
        if (sign != null && sign.isNotEmpty) witness.signature = sign;
      }

      proof.witness = jsonEncode(witness.toJson());
    } catch (e, stack) {
      LogUtils.e(() => '[WitnessHelper - addHTLCWitnessToProof] $e');
      LogUtils.e(() => '[WitnessHelper - addHTLCWitnessToProof] $stack');
    }
  }
}

abstract class WitnessParam {}

class P2PKWitnessParam extends WitnessParam {
  P2PKWitnessParam({
    this.pubkeyList = const [],
  });
  final List<String> pubkeyList;
}

class HTLCWitnessParam extends WitnessParam {
  HTLCWitnessParam({
    this.preimage = '',
    this.pubkey = '',
  });
  final String preimage;
  final String pubkey;
}