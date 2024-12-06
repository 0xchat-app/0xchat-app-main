import 'package:cashu_dart/cashu_dart.dart';
import 'package:flutter/material.dart';

class EcashListener with CashuListener {
  final ValueChanged<Receipt>? onInvoicePaidChanged;
  final ValueChanged<IMintIsar>? onEcashBalanceChanged;
  final ValueChanged<List<IMintIsar>>? onMintsChanged;
  final VoidCallback? onHistoryChanged;

  EcashListener({
    this.onInvoicePaidChanged,
    this.onEcashBalanceChanged,
    this.onMintsChanged,
    this.onHistoryChanged,
  });

  @override
  void handleInvoicePaid(Receipt receipt) {
    if (onInvoicePaidChanged != null) {
      onInvoicePaidChanged!(receipt);
    }
  }

  @override
  void handleBalanceChanged(IMintIsar mint) {
    if (onEcashBalanceChanged != null) {
      onEcashBalanceChanged!(mint);
    }
  }

  @override
  void handleMintListChanged(List<IMintIsar> mints) {
    if (onMintsChanged != null) {
      onMintsChanged!(mints);
    }
  }

  @override
  void handleHistoryChanged() {
    if (onHistoryChanged != null) {
      onHistoryChanged!();
    }
  }
}
