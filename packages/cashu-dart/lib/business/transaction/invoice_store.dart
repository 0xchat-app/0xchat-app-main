
import 'package:cashu_dart/model/lightning_invoice_isar.dart';
import 'package:cashu_dart/utils/database/db_isar.dart';

import '../../model/invoice_isar.dart';

class InvoiceStore {
  static Future<bool> addInvoice(Receipt invoice) async {
    if (invoice is IInvoiceIsar) {
      await CashuIsarDB.put(invoice);
    } else if (invoice is LightningInvoiceIsar) {
      await CashuIsarDB.put(invoice);
    }
    return true;
  }

  static Future<List<Receipt>> getAllInvoice() async {
    return [
      ... await CashuIsarDB.getAll<IInvoiceIsar>(),
      ... await CashuIsarDB.getAll<LightningInvoiceIsar>()
    ];
  }

  static Future<bool> deleteInvoice(List<Receipt> delInvoices) async {
    if (delInvoices.isEmpty) return true;

    final invoiceIds = <int>[];
    final lightningInvoiceIds = <int>[];
    for (var invoice in delInvoices) {
      if (invoice is IInvoiceIsar) {
        invoiceIds.add(invoice.id);
      } else if (invoice is LightningInvoiceIsar) {
        lightningInvoiceIds.add(invoice.id);
      }
    }

    int deleted = 0;

    deleted += await CashuIsarDB.delete<IInvoiceIsar>((collection) =>
        collection.deleteAll(invoiceIds));
    deleted += await CashuIsarDB.delete<LightningInvoiceIsar>((collection) =>
        collection.deleteAll(lightningInvoiceIds));

    return deleted == delInvoices.length;
  }
}