import 'token/converter/converter.dart';
import 'token/proof_isar.dart';
import 'token/token_model.dart';
import '../../utils/tools.dart';

class Nut0 {

  static List<String> get uriPrefixes => Converter.uriPrefixes;

  static bool isCashuToken(String token) {
    return Converter.isCashuToken(token);
  }

  static String encodedToken(Token token, [bool useV4Token = true]) {
    return Converter.encodedToken(token, useV4Token);
  }

  static Token? decodedToken(String token) {
    return Converter.decodedToken(token);
  }
}

class BlindedMessage {
  BlindedMessage({
    required this.id,
    required this.amount,
    required this.B_,
  });

  final String id;
  final num amount;
  final String B_;

  factory BlindedMessage.fromServerMap(Map json) {
    return BlindedMessage(
      id: Tools.getValueAs(json, 'id', ''),
      amount: Tools.getValueAs(json, 'amount', 0),
      B_: Tools.getValueAs(json, 'B_', ''),
    );
  }

  @override
  String toString() {
    return '${super.toString()}, id: $id, amount: $amount, B_: $B_';
  }
}

class BlindedSignature {
  BlindedSignature({
    required this.id,
    required this.amount,
    required this.C_,
    this.dleq,
  });

  final String id;
  final String amount;
  final String C_;
  final Map? dleq;

  factory BlindedSignature.fromServerMap(Map json) {
    final amount = json['amount'] as num;
    return BlindedSignature(
      id: Tools.getValueAs<String>(json, 'id', ''),
      amount: BigInt.from(amount).toString(),
      C_: Tools.getValueAs<String>(json, 'C_', ''),
      dleq: Tools.getValueAs<Map?>(json, 'dleq', null),
    );
  }

  @override
  String toString() {
    return '${super.toString()}, id: $id, amount: $amount, C_: $C_, dleq: $dleq';
  }
}

extension ProofListEx on List<ProofIsar> {
  int get totalAmount => fold(0, (pre, proof) => pre + proof.amountNum);
}
