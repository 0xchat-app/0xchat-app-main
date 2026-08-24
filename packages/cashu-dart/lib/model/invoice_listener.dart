
import 'invoice_isar.dart';
import 'mint_model_isar.dart';

abstract mixin class CashuListener {
  void handleInvoicePaid(Receipt receipt) { }
  void handleBalanceChanged(IMintIsar mint) { }
  void handleMintListChanged(List<IMintIsar> mints) { }
  void handlePaymentCompleted(String paymentKey) { }
  void handleHistoryChanged() { }
}