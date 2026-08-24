
import '../utils/database/db.dart';
import '../utils/database/db_object.dart';
import '../utils/tools.dart';
import 'invoice_isar.dart';

@reflector
class IInvoice extends DBObject implements Receipt {
  IInvoice({
    required this.quote,
    required this.request,
    required this.paid,
    required this.amount,
    required this.expiry,
    required this.mintURL
  });

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

  static IInvoice? fromServerMap(Map json, String mintURL, String amount) {
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
    return IInvoice(
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
  Map<String, Object?> toMap() => {
    'quote': quote,
    'request': request,
    'paid': paid,
    'amount': amount,
    'expiry': expiry,
    'mintURL': mintURL,
  };

  static IInvoice fromMap(Map<String, Object?> map) {
    return IInvoice(
      quote: Tools.getValueAs(map, 'quote', ''),
      request: Tools.getValueAs(map, 'request', ''),
      paid: Tools.getValueAs(map, 'paid', false),
      amount: Tools.getValueAs(map, 'amount', ''),
      expiry: Tools.getValueAs(map, 'expiry', 0),
      mintURL: Tools.getValueAs(map, 'mintURL', ''),
    );
  }

  static String? tableName() {
    return "IInvoice";
  }

  //primaryKey
  static List<String?> primaryKey() {
    return ['mintURL', 'quote'];
  }

  static List<String?> ignoreKey() {
    return [];
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