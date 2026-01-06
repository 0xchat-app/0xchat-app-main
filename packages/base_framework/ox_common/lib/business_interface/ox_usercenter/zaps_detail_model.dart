
import 'package:intl/intl.dart';
import 'package:ox_localizable/ox_localizable.dart';

class ZapsRecordDetail {
  final String invoice;
  final int amount;
  final String fromPubKey;
  final String toPubKey;
  final String zapsTime;
  final String description;
  final bool isConfirmed;

  Map<String, dynamic> get zapsRecordAttributes => <String, dynamic>{
    Localized.text('ox_usercenter.zaps'): '+$amount',
    Localized.text('ox_usercenter.zap_status'): isConfirmed,
    Localized.text('ox_usercenter.zap_invoice'): invoice,
    Localized.text('ox_usercenter.zap_from'): fromPubKey,
    Localized.text('ox_usercenter.zap_to'): toPubKey,
    Localized.text('ox_usercenter.zap_time'): zapsTimeFormat,
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