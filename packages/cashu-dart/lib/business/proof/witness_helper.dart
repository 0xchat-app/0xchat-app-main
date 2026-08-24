
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