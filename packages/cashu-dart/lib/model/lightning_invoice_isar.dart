
import 'package:bolt11_decoder/bolt11_decoder.dart';
import 'package:cashu_dart/utils/tools.dart';
import 'package:isar/isar.dart';

import 'invoice_isar.dart';

part 'lightning_invoice_isar.g.dart';

@Collection(ignore: {'paymentKey', 'redemptionKey', 'isExpired', 'request', 'expiry'})
class LightningInvoiceIsar implements Receipt {
  LightningInvoiceIsar({
    required this.pr,
    required this.hash,
    required this.amount,
    required this.mintURL
  });

  Id id = Isar.autoIncrement;

  final String pr;

  @Index(composite: [CompositeIndex('mintURL')], unique: true)
  final String hash;

  @override
  final String amount;

  @override
  final String mintURL;

  static LightningInvoiceIsar? fromServerMap(Map json, String mintURL, String amount) {
    final pr = Tools.getValueAs<String>(json, 'pr', '');
    final hash = Tools.getValueAs<String>(json, 'hash', '');
    if (pr.isEmpty || hash.isEmpty) return null;
    return LightningInvoiceIsar(
      pr: pr,
      hash: hash,
      amount: amount,
      mintURL: mintURL,
    );
  }

  @override
  String toString() {
    return '${super.toString()}, pr: $pr, hash: $hash, mintURL: $mintURL';
  }

  @override
  String get paymentKey => pr;

  @override
  String get redemptionKey => hash;

  @override
  bool get isExpired {
    try {
      final req = Bolt11PaymentRequest(pr);
      for (final tag in req.tags) {
        if (tag.type == 'expiry' && tag.data is int) {
          final expiry = req.timestamp + tag.data;
          return expiry < DateTime.now().millisecondsSinceEpoch ~/ 1000;
        }
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  @override
  String get request => pr;

  @override
  int get expiry => 0;
}