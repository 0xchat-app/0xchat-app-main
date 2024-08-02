
import 'package:chatcore/chat-core.dart';
import 'package:ox_chat/page/ecash/ecash_info_isar.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';


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

  static Future<void> migrateToISAR() async {
    List<EcashReceiptHistory> ecashReceiptHistorys = await DB.sharedInstance.objects<EcashReceiptHistory>();
    await Future.forEach(ecashReceiptHistorys, (ecashReceiptHistory) async {
      await DBISAR.sharedInstance.isar.writeTxn(() async {
        await DBISAR.sharedInstance.isar.ecashReceiptHistoryISARs
            .put(EcashReceiptHistoryISAR.fromMap(ecashReceiptHistory.toMap()));
      });
    });
  }
}