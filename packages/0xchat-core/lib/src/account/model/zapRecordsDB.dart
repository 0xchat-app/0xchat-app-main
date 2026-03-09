import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';

@reflector
class ZapRecordsDB extends DBObject {
  String bolt11;
  int paidAt;
  String zapper;
  String preimage;
  String description;
  String recipient;
  String sender;
  String eventId;
  String content;

  ZapRecordsDB(
      {this.bolt11 = '',
      this.paidAt = 0,
      this.zapper = '',
      this.preimage = '',
      this.description = '',
      this.recipient = '',
      this.sender = '',
      this.eventId = '',
      this.content = ''});

  @override
  //Map
  Map<String, Object?> toMap() {
    return _zapRecordsDBInfoToMap(this);
  }

  static ZapRecordsDB fromMap(Map<String, Object?> map) {
    return _zapRecordsDBInfoFromMap(map);
  }

  //primaryKey
  static List<String?> primaryKey() {
    return ['bolt11'];
  }

  static ZapRecordsDB zapReceiptToZapRecordsDB(ZapReceipt zapReceipt) {
    return ZapRecordsDB(
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

  static Future<void> migrateToISAR() async {
    List<ZapRecordsDB> zapRecords =
        await DB.sharedInstance.objects<ZapRecordsDB>();
    List<ZapRecordsDBISAR> zapRecordsISAR = [];
    for (var zapRecord in zapRecords) {
      zapRecordsISAR.add(ZapRecordsDBISAR.fromMap(zapRecord.toMap()));
    }
    await DBISAR.sharedInstance.isar.writeTxn(() async {
      await DBISAR.sharedInstance.isar.zapRecordsDBISARs.putAll(zapRecordsISAR);
    });
  }
}

ZapRecordsDB _zapRecordsDBInfoFromMap(Map<String, dynamic> map) {
  return ZapRecordsDB(
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

Map<String, dynamic> _zapRecordsDBInfoToMap(ZapRecordsDB instance) =>
    <String, dynamic>{
      'bolt11': instance.bolt11,
      'paidAt': instance.paidAt,
      'zapper': instance.zapper,
      'preimage': instance.preimage,
      'description': instance.description,
      'recipient': instance.recipient,
      'sender': instance.sender,
      'eventId': instance.eventId,
      'content': instance.content,
    };
