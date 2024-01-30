
import 'package:cashu_dart/cashu_dart.dart';

class EcashPackageInfo {
  EcashPackageInfo({
    required this.token,
    required this.amount,
    this.unit = 'sats',
    this.redeemHistory
  });

  final String token;
  final int amount;
  final String unit;
  EcashHistory? redeemHistory;

  @override
  String toString() {
    return '${super.toString()}, amount: $amount, redeemHistory: $redeemHistory';
  }
}

class EcashHistory {
  EcashHistory({
    required this.isMe,
    this.timestamp,
  });

  final bool isMe;
  final int? timestamp;

  @override
  String toString() {
    return '${super.toString()}, isMe: $isMe';
  }
}

class EcashPackageInfoHelper {
  static Future<List<EcashPackageInfo>?> createInfoFromTokens(List<String> tokenList) async {
    final infoList = <EcashPackageInfo>[];
    final receiveHistory = (await Cashu.getHistory(value: tokenList)).where((history) => history.amount > 0);
    for (final token in tokenList) {
      bool received = false;

      receiveHistory.forEach((history) {
        if (history.value == token) {
          received = true;
          infoList.add(EcashPackageInfo(
            token: token,
            amount: history.amount.toInt(),
            redeemHistory: EcashHistory(
              isMe: true,
              timestamp: history.timestamp.toInt(),
            ),
          ));
        }
      });

      if (!received) {
        final spendable = await Cashu.isEcashTokenSpendableFromToken(token);
        final info = Cashu.infoOfToken(token);
        if (spendable == null || info == null) {
          return null;
        } else {
          final (_, amount) = info;
          infoList.add(EcashPackageInfo(
            token: token,
            amount: amount,
            redeemHistory: spendable ? EcashHistory(
              isMe: false,
            ) : null,
          ));
        }
      }
    }
    return infoList;
  }
}