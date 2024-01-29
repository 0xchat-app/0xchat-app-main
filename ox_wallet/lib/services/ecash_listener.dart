import 'package:cashu_dart/cashu_dart.dart';
import 'package:flutter/material.dart';

class EcashListener with CashuListener {
  final ValueChanged<Receipt>? onInvoicePaidChanged;
  final ValueChanged<IMint>? onEcashBalanceChanged;
  final ValueChanged<List<IMint>>? onMintsChanged;

  EcashListener({this.onInvoicePaidChanged, this.onEcashBalanceChanged, this.onMintsChanged});

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

  @override
  void onMintListChanged(List<IMint> mints) {
    if (onMintsChanged != null) {
      onMintsChanged!(mints);
    }
  }
}
