
import 'package:isar/isar.dart';

part 'ecash_info_isar.g.dart';

@collection
class EcashReceiptHistoryISAR {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  final String tokenMD5;
  final bool isMe;
  final int? timestamp;

  EcashReceiptHistoryISAR({
    required this.tokenMD5,
    required this.isMe,
    this.timestamp,
  });

  @override
  String toString() {
    return '${super.toString()}, tokenMD5: $tokenMD5, isMe: $isMe';
  }

  static EcashReceiptHistoryISAR fromMap(Map<String, Object?> map) {
    return EcashReceiptHistoryISAR(
      tokenMD5: map['tokenMD5'] as String,
      isMe: map['isMe'] == 1,
      timestamp: map['timestamp'] as int?,
    );
  }
}