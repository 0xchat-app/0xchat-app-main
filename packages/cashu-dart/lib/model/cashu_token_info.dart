
import '../core/nuts/v1/nut_10.dart';
import '../core/nuts/v1/nut_11.dart';

class CashuTokenInfo {
  CashuTokenInfo({
    required this.amount,
    required this.unit,
    required this.memo,
    this.conditionInfo,
  });

  final int amount;
  final String unit;
  final String memo;
  final Nut10Secret? conditionInfo;

  P2PKSecret? get p2pkInfo {
    return conditionInfo is P2PKSecret ? conditionInfo as P2PKSecret : null;
  }

  @override
  String toString() {
    return '${super.toString()}, amount: $amount, unit: $unit, memo: $memo, p2pkInfo: $p2pkInfo';
  }
}