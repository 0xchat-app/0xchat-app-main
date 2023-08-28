
import 'package:intl/intl.dart';

class ZapsRecordDetail {
  final String? invoice;
  final double? amount;
  final String? fromPubKey;
  final String? toPubKey;
  final String? zapsTime;
  final String? description;

  Map<String, String> get zapsRecordAttributes => <String, String>{
    'Zaps': '+$amount',
    'Invoice': invoice ?? '',
    'From': fromPubKey ?? '',
    'To': toPubKey ?? '',
    'Time': zapsTimeFormat,
  };

  String get zapsTimeFormat => DateFormat('yyyy/MM/dd HH:mm').format(DateTime.parse(zapsTime ?? ''));

  ZapsRecordDetail({
    this.invoice,
    this.amount,
    this.fromPubKey,
    this.toPubKey,
    this.zapsTime,
    this.description,
  });

  @override
  String toString() {
    return 'ZapsRecordDetail{invoice: $invoice, amount: $amount, fromPubkey: $fromPubKey, toPubkey: $toPubKey, zapsTime: $zapsTime, description: $description}';
  }
}