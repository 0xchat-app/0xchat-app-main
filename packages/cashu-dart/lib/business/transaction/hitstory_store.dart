
import '../../model/history_entry_isar.dart';
import '../../model/invoice_isar.dart';
import '../../utils/database/db_isar.dart';
import '../wallet/cashu_manager.dart';

class HistoryStore {

  /// add history entry
  static Future<bool> _add(IHistoryEntryIsar entry) async {
    await CashuIsarDB.put(entry);
    return true;
  }

  /// get history entries
  static Future<List<IHistoryEntryIsar>> getHistory({
    List<String> values = const [],
  }) async {
    return CashuIsarDB.query<IHistoryEntryIsar>().filter()
        .optional(values.isNotEmpty,
            (q) => q.anyOf(values, (q, value) => q.valueEqualTo(value)))
        .sortByTimestampDesc()
        .findAll();
  }

  /// update history entries
  static Future<bool> updateHistoryEntry(IHistoryEntryIsar newEntry) async {
    return _add(newEntry);
  }

  static Future<IHistoryEntryIsar> addToHistory({
    required num amount,
    required IHistoryType type,
    required String value,
    required List<String> mints,
    num? fee,
    bool? isSpent,
  }) async {
    final item = IHistoryEntryIsar(
      amount: amount.toDouble(),
      typeRaw: type.value,
      value: value,
      mints: mints,
      timestamp: DateTime.now().millisecondsSinceEpoch.toDouble(),
      fee: fee?.toInt(),
      isSpent: isSpent,
    );
    await _add(item);
    CashuManager.shared.notifyListenerForHistoryChanged();
    return item;
  }

  static Future<bool> deleteHistory(List<IHistoryEntryIsar> entries) async {
    if (entries.isEmpty) return true;

    final deleted = await CashuIsarDB.delete<IHistoryEntryIsar>((collection) =>
        collection.where()
            .anyOf(entries,
                (q, entry) => q.idEqualTo(entry.id))
            .deleteAll()
    );
    return deleted == entries.length;
  }

  static Future<bool> hasReceiptRedeemHistory(Receipt receipt) async {
    final history = await CashuIsarDB.query<IHistoryEntryIsar>()
        .filter()
        .valueEqualTo(receipt.paymentKey)
        .amountGreaterThan(0)
        .findFirst();
    return history != null;
  }
}