
import 'package:intl/intl.dart';

class ZapsRecordDetail {
  final String invoice;
  final int amount;
  final String fromPubKey;
  final String toPubKey;
  final String zapsTime;
  final String description;
  final bool isConfirmed;

  Map<String, String> get zapsRecordAttributes => <String, String>{
    'Zaps': '+$amount',
    'Invoice': invoice,
    'From': fromPubKey,
    'To': toPubKey,
    'Time': zapsTimeFormat,
  };

  String get zapsTimeFormat => DateFormat('yyyy/MM/dd HH:mm').format(DateTime.fromMillisecondsSinceEpoch(int.tryParse(zapsTime) ?? 0));

  ZapsRecordDetail({
    this.invoice = '',
    this.amount = 0,
    this.fromPubKey = '',
    this.toPubKey = '',
    this.zapsTime = '',
    this.description = '',
    this.isConfirmed = false,
  });

  @override
  String toString() {
    return 'ZapsRecordDetail{invoice: $invoice, amount: $amount, fromPubkey: $fromPubKey, toPubkey: $toPubKey, zapsTime: $zapsTime, description: $description}';
  }
}