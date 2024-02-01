
import 'package:chatcore/chat-core.dart';

class EcashPackage {
  EcashPackage({
    required this.messageId,
    required this.totalAmount,
    required this.tokenInfoList,
    required this.memo,
    required this.senderPubKey,
  });
  final String messageId;
  final int totalAmount;
  final List<EcashTokenInfo> tokenInfoList;
  final String memo;
  final String senderPubKey;

  bool get isRedeemed => tokenInfoList.every((e) => e.redeemHistory != null)
      || tokenInfoList.any((e) => e.redeemHistory?.isMe == true)
  ;
}

class EcashTokenInfo {
  EcashTokenInfo({
    required this.token,
    required this.amount,
    this.unit = 'sats',
    this.redeemHistory,
  });

  final String token;
  final int amount;
  final String unit;
  EcashReceiptHistory? redeemHistory;

  @override
  String toString() {
    return '${super.toString()}, amount: $amount, redeemHistory: $redeemHistory';
  }
}

@reflector
class EcashReceiptHistory extends DBObject {
  EcashReceiptHistory({
    required this.token,
    required this.isMe,
    this.timestamp,
  });

  final String token;
  final bool isMe;
  final int? timestamp;

  @override
  String toString() {
    return '${super.toString()}, token: $token, isMe: $isMe';
  }

  static List<String?> primaryKey() {
    return ['token'];
  }

  @override
  Map<String, Object?> toMap() => {
    'token': token,
    'isMe': isMe,
    'timestamp': timestamp,
  };

  static EcashReceiptHistory fromMap(Map<String, Object?> map) {
    return EcashReceiptHistory(
      token: map['token'] as String,
      isMe: map['isMe'] == 1,
      timestamp: map['timestamp'] as int?,
    );
  }
}