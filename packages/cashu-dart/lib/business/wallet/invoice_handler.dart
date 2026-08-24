
import 'dart:async';

import 'package:cashu_dart/business/wallet/cashu_manager.dart';
import 'package:cashu_dart/cashu_dart.dart';

import '../../utils/task_scheduler.dart';
import '../transaction/hitstory_store.dart';
import '../transaction/invoice_store.dart';
import '../transaction/transaction_helper.dart';

class InvoiceHandler {

  final _invoices = <Receipt>[];
  final _pendingInvoices = <Receipt>{};
  Function(Receipt invoice)? invoiceOnPaidCallback;

  TaskScheduler? invoiceChecker;

  Future<void> initialize() async {
    _invoices.addAll(await InvoiceStore.getAllInvoice());
    invoiceChecker = TaskScheduler(task: _periodicCheck)..start();
    Future.delayed(const Duration(seconds: 10), () => invoiceChecker?.initComplete());
  }

  void dispose() {
    _invoices.clear();
    invoiceChecker?.dispose();
  }

  void addInvoice(Receipt invoice) {
    if (_invoiceExists(invoice)) return ;
    _invoices.add(invoice);
    checkInvoice(invoice);
  }

  void startHighFrequencyDetection() {
    invoiceChecker?.enableFixedInterval(const Duration(seconds: 5));
  }

  void stopHighFrequencyDetection() {
    invoiceChecker?.disableFixedInterval();
  }

  Future _periodicCheck() async {
    final invoices = [..._invoices].reversed;
    for (var invoice in invoices) {
      await checkInvoice(invoice);
    }
  }

  Future<bool> checkInvoice(Receipt invoice, [bool force = false]) async {

    if (!force) {
      if (_pendingInvoices.contains(invoice)) return false;
      _pendingInvoices.add(invoice);
    }

    try {
      bool paid = true;
      // if (invoice is IInvoice) {
      //   final response = await v1.Nut5.requestMeltQuote(
      //     mintURL: invoice.mintURL,
      //     request: invoice.request,
      //   );
      //   if (response.isSuccess) {
      //     final quoteInfo = response.data;
      //     invoice.paid = quoteInfo.paid;
      //     await InvoiceStore.addInvoice(invoice);
      //     paid = quoteInfo.paid;
      //   }
      // }

      if (paid) {
        final response = await _exchangeCash(invoice);
        if (response.isSuccess) {
          deleteInvoice(invoice);
          if (response.data.isNotEmpty) {
            await HistoryStore.addToHistory(
              amount: int.tryParse(invoice.amount) ?? 0,
              type: IHistoryType.lnInvoice,
              value: invoice.request,
              mints: [invoice.mintURL],
              fee: 0,
            );
            invoiceOnPaidCallback?.call(invoice);
          }
          CashuManager.shared.updateMintBalance();
          return true;
        } else if (response.code == ResponseCode.invoiceNotPaidError && invoice.isExpired) {
          deleteInvoice(invoice);
        }
      }

    } catch (e) {
      // Handle exceptions
    } finally {
      _pendingInvoices.remove(invoice);
    }

    return false;
  }

  Future<CashuResponse<List<ProofIsar>>> _exchangeCash(Receipt invoice) async {
    final amount = int.tryParse(invoice.amount);
    if (amount == null) return CashuResponse.fromErrorMsg('Amount is null.');

    final mint = await CashuManager.shared.getMint(invoice.mintURL);
    if (mint == null) return CashuResponse.fromErrorMsg('Mint is null.');

    return TransactionHelper.requestTokensFromMint(
      mint: mint,
      quoteID: invoice.redemptionKey,
      amount: amount,
      invoice: invoice.request,
    );
  }

  Future<bool> deleteInvoice(Receipt invoice) {
    _invoices.remove(invoice);
    return InvoiceStore.deleteInvoice([invoice]);
  }

  bool _invoiceExists(Receipt invoice) {
    return _invoices.any((element) => element.redemptionKey == invoice.redemptionKey);
  }
}
