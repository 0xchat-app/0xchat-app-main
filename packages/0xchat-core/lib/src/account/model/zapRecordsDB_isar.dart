import 'package:isar/isar.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:chatcore/chat-core.dart';

part 'zapRecordsDB_isar.g.dart';

@collection
class ZapRecordsDBISAR {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String bolt11;

  int paidAt;
  String zapper;
  String preimage;
  String description;
  String recipient;
  String sender;
  String eventId;
  String content;

  bool findEvent;

  ZapRecordsDBISAR(
      {this.bolt11 = '',
      this.paidAt = 0,
      this.zapper = '',
      this.preimage = '',
      this.description = '',
      this.recipient = '',
      this.sender = '',
      this.eventId = '',
      this.content = '',
      this.findEvent = false});

  static ZapRecordsDBISAR fromMap(Map<String, Object?> map) {
    return _zapRecordsDBInfoFromMap(map);
  }

  static ZapRecordsDBISAR zapReceiptToZapRecordsDB(ZapReceipt zapReceipt) {
    return ZapRecordsDBISAR(
        bolt11: zapReceipt.bolt11,
        paidAt: zapReceipt.paidAt,
        zapper: zapReceipt.zapper,
        preimage: zapReceipt.preimage,
        description: zapReceipt.description,
        recipient: zapReceipt.recipient,
        sender: zapReceipt.sender ?? '',
        eventId: zapReceipt.eventId ?? '',
        content: zapReceipt.content ?? '');
  }

  static int getZapAmount(String bolt11) {
    return Zaps.getPaymentRequestAmount(bolt11);
  }
}

ZapRecordsDBISAR _zapRecordsDBInfoFromMap(Map<String, dynamic> map) {
  return ZapRecordsDBISAR(
      bolt11: map['bolt11'].toString(),
      paidAt: map['paidAt'],
      zapper: map['zapper'].toString(),
      preimage: map['preimage'].toString(),
      description: map['description'].toString(),
      recipient: map['recipient'].toString(),
      sender: map['sender'].toString(),
      eventId: map['eventId'].toString(),
      content: map['content'].toString());
}
