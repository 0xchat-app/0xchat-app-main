
import 'package:cashu_dart/utils/tools.dart';
import 'package:isar/isar.dart';

part 'invoice_isar.g.dart';

abstract class Receipt {
  String get mintURL;

  String get amount;

  String get paymentKey;

  String get redemptionKey;

  String get request;

  /// Expiry timestamp in seconds, 0 means never expires
  int get expiry;

  bool get isExpired;
}

@Collection(ignore: {'paymentKey', 'redemptionKey', 'isExpired'})
class IInvoiceIsar implements Receipt {
  IInvoiceIsar({
    required this.quote,
    required this.request,
    required this.paid,
    required this.amount,
    required this.expiry,
    required this.mintURL
  });

  Id id = Isar.autoIncrement;

  @Index(composite: [CompositeIndex('mintURL')], unique: true)
  final String quote;

  @override
  final String request;

  bool paid;

  @override
  final String amount;

  @override
  /// Expiry timestamp in seconds, 0 means never expires
  final int expiry;

  @override
  final String mintURL;

  static int get expiryMax => DateTime.now().add(const Duration(days: 30)).millisecondsSinceEpoch ~/ 1000;

  static IInvoiceIsar? fromServerMap(Map json, String mintURL, String amount) {
    final quote = Tools.getValueAs<String>(json, 'quote', '');
    final request = Tools.getValueAs<String>(json, 'request', '');
    final paid = Tools.getValueAs<bool>(json, 'paid', false);
    final expiryInterval = Tools.getValueAs<int>(json, 'expiry', 0);

    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    var expiry = 0;
    if (expiryInterval > now && expiryInterval < expiryMax) {
      expiry = expiryInterval;
    } else if (expiryInterval < const Duration(days: 30).inSeconds) {
      expiry = now + expiryInterval;
    }
    if (quote.isEmpty || request.isEmpty) return null;
    return IInvoiceIsar(
      quote: quote,
      request: request,
      paid: paid,
      amount: amount,
      expiry: expiry,
      mintURL: mintURL,
    );
  }

  @override
  String toString() {
    return '${super.toString()}, quote: $quote, request: $request, paid: $paid, expiry: $expiry';
  }

  @override
  String get paymentKey => quote;

  @override
  String get redemptionKey => quote;

  @override
  bool get isExpired {
    // Error expiry data
    if (expiry > expiryMax) return true;
    return expiry != 0 && expiry < DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }
}