
import 'dart:convert';
import 'package:isar/isar.dart';

import '../core/nuts/nut_00.dart';

part 'unblinding_data_isar.g.dart';

enum ProofBlindingAction {
  unknown(0),
  minting(1),
  melt(2),
  multiMintSwap(3),
  swapForP2PK(4);

  final int value;

  const ProofBlindingAction(this.value);

  static ProofBlindingAction fromValue(dynamic value) =>
      ProofBlindingAction.values.where(
            (element) => element.value == value,
      ).firstOrNull ?? ProofBlindingAction.unknown;

  String get text {
    switch (this) {
      case ProofBlindingAction.unknown: return 'unknown';
      case ProofBlindingAction.minting: return 'Minting';
      case ProofBlindingAction.melt: return 'Melt';
      case ProofBlindingAction.multiMintSwap: return 'Swap';
      case ProofBlindingAction.swapForP2PK: return 'SwapForP2PK';
    }
  }
}

@collection
class UnblindingDataIsar {
  UnblindingDataIsar({
    required this.mintURL,
    required this.unit,
    required this.actionTypeRaw,
    required this.actionValue,
    required this.keysetId,
    required this.amount,
    required this.C_,
    required this.dleqPlainText,
    required this.r,
    required this.secret,
  }) {
    try {
      dleq = json.decode(dleqPlainText);
    } catch (_) {}
  }

  factory UnblindingDataIsar.fromSignature({
    required BlindedSignature signature,
    required String mintURL,
    required ProofBlindingAction action,
    required String actionValue,
    required String unit,
    required String r,
    required String secret,
  }) {
    var dleqPlainText = '';
    try {
      dleqPlainText = json.encode(signature.dleq);
    } catch (_) {}
    return UnblindingDataIsar(
      mintURL: mintURL,
      unit: unit,
      actionTypeRaw: action.value,
      actionValue: actionValue,
      keysetId: signature.id,
      amount: signature.amount,
      C_: signature.C_,
      dleqPlainText: dleqPlainText,
      r: r,
      secret: secret,
    );
  }

  Id id = Isar.autoIncrement;

  final String mintURL;
  final String unit;

  final int actionTypeRaw;
  @Ignore()
  ProofBlindingAction get actionType => ProofBlindingAction.fromValue(actionTypeRaw);

  final String actionValue;

  // BlindedSignature
  final String keysetId;
  final String amount;
  final String C_;

  final String dleqPlainText;
  @Ignore()
  Map? dleq;

  @Ignore()
  BlindedSignature get signature => BlindedSignature(
    id: keysetId,
    amount: amount,
    C_: C_,
    dleq: dleq,
  );

  // Unbinding
  final String r;

  @Index(composite: [CompositeIndex('keysetId')], unique: true)
  final String secret;

  @override
  String toString() {
    return '${super.toString()}, id: $keysetId, amount: $amount, secret: $secret';
  }
}