
import 'package:bolt11_decoder/bolt11_decoder.dart';
import 'package:decimal/decimal.dart';

extension Bolt11PaymentRequestEx on Bolt11PaymentRequest {
  int get satsAmount {
    return (amount * Decimal.fromInt(100000000)).toDouble().toInt();
  }
}