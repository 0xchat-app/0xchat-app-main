import 'package:cashu_dart/cashu_dart.dart';
import 'package:flutter/material.dart';

class EcashListener implements CashuListener {
  final ValueChanged<Receipt>? onInvoicePaidChanged;
  final ValueChanged<IMint>? onEcashBalanceChanged;

  EcashListener({this.onInvoicePaidChanged, this.onEcashBalanceChanged});

  @override
  void onInvoicePaid(Receipt receipt) {
    if (onInvoicePaidChanged != null) {
      onInvoicePaidChanged!(receipt);
    }
  }

  @override
  void onBalanceChanged(IMint mint) {
    if (onEcashBalanceChanged != null) {
      onEcashBalanceChanged!(mint);
    }
  }
}
