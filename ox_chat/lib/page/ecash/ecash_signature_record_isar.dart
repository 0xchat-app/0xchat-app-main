
import 'package:chatcore/chat-core.dart';
import 'package:isar/isar.dart';

part 'ecash_signature_record_isar.g.dart';

@collection
class EcashSignatureRecordISAR {

  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  final String messageId;

  EcashSignatureRecordISAR({
    required this.messageId,
  });

  @override
  String toString() {
    return '${super.toString()}, messageId: $messageId';
  }

  static EcashSignatureRecordISAR fromMap(Map<String, Object?> map) {
    return EcashSignatureRecordISAR(
      messageId: map['messageId'] as String,
    );
  }
}