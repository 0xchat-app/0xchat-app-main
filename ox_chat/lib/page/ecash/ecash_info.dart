
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';

typedef EcashPackageSignee = (UserDBISAR user, String flag);
class EcashPackage {
  EcashPackage({
    required this.messageId,
    required this.totalAmount,
    required this.tokenInfoList,
    required this.memo,
    required this.senderPubKey,
    this.receiver = const [],
    this.signees = const [],
    this.validityDate = '',
  });
  final String messageId;
  final int totalAmount;
  final List<EcashTokenInfo> tokenInfoList;
  final String memo;
  final String senderPubKey;
  final List<UserDBISAR> receiver;
  final List<EcashPackageSignee> signees;
  final String validityDate;

  // bool get isRedeemed => false;
  bool get isRedeemed => tokenInfoList.every((e) => e.redeemHistory != null)
      || tokenInfoList.any((e) => e.redeemHistory?.isMe == true);

  bool get isAllReceive => tokenInfoList
      .every((info) => info.redeemHistory != null);

  bool get isForOtherUser => receiver.isNotEmpty
      && !receiver.contains(OXUserInfoManager.sharedInstance.currentUserInfo);

  bool get isFinishSignature =>
      signees.every((signee) => signee.$2.isNotEmpty);

  bool get nextSignatureIsMe {
    for (var (signee, signature) in signees) {
      if (signature.isNotEmpty) continue;
      return signee == OXUserInfoManager.sharedInstance.currentUserInfo;
    }
    return false;
  }
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
    required this.tokenMD5,
    required this.isMe,
    this.timestamp,
  });

  final String tokenMD5;
  final bool isMe;
  final int? timestamp;

  @override
  String toString() {
    return '${super.toString()}, tokenMD5: $tokenMD5, isMe: $isMe';
  }

  static List<String?> primaryKey() {
    return ['tokenMD5'];
  }

  @override
  Map<String, Object?> toMap() => {
    'tokenMD5': tokenMD5,
    'isMe': isMe,
    'timestamp': timestamp,
  };

  static EcashReceiptHistory fromMap(Map<String, Object?> map) {
    return EcashReceiptHistory(
      tokenMD5: map['tokenMD5'] as String,
      isMe: map['isMe'] == 1,
      timestamp: map['timestamp'] as int?,
    );
  }
}