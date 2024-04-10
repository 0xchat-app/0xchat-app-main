
import 'package:chatcore/chat-core.dart';

@reflector
class EcashSignatureRecord extends DBObject {
  EcashSignatureRecord({
    required this.messageId,
  });

  final String messageId;

  @override
  String toString() {
    return '${super.toString()}, messageId: $messageId';
  }

  static List<String?> primaryKey() {
    return ['messageId'];
  }

  @override
  Map<String, Object?> toMap() => {
    'messageId': messageId,
  };

  static EcashSignatureRecord fromMap(Map<String, Object?> map) {
    return EcashSignatureRecord(
      messageId: map['messageId'] as String,
    );
  }
}