
import 'package:bolt11_decoder/bolt11_decoder.dart';
import 'package:isar/isar.dart';

import '../core/nuts/nut_00.dart';

part 'history_entry_isar.g.dart';

enum IHistoryType {
  unknown(0),
  eCash(1),
  lnInvoice(2),
  multiMintSwap(3),
  swapForP2PK(4);

  final int value;

  const IHistoryType(this.value);

  static IHistoryType fromValue(dynamic value) =>
      IHistoryType.values.where(
            (element) => element.value == value,
      ).firstOrNull ?? IHistoryType.unknown;
}

@collection
class IHistoryEntryIsar {

  IHistoryEntryIsar({
    required this.amount,
    required this.typeRaw,
    required this.timestamp,
    required this.value,
    required this.mints,
    this.fee,
    this.isSpent,
  }) : memo = parseMemoFromValue(value, IHistoryType.fromValue(typeRaw));

  Id id = Isar.autoIncrement;

  final double amount;

  final int typeRaw;

  @ignore
  IHistoryType get type => IHistoryType.fromValue(typeRaw);

  final double timestamp;

  /// [Receipt.paymentKey] (Lightning invoice) or encoded Cashu token
  final String value;

  /// mints involved
  final List<String> mints;

  final int? fee;

  /// Whether the token is spent
  bool? isSpent;

  String memo;

  static String parseMemoFromValue(String value, IHistoryType type) {
    switch (type) {
      case IHistoryType.eCash:
        return Nut0.decodedToken(value)?.memo ?? '';
      case IHistoryType.lnInvoice:
        try {
          final req = Bolt11PaymentRequest(value);
          for (final tag in req.tags) {
            if (tag.type == 'description' && tag.data is String?) {
              return tag.data == 'enuts' ? 'Cashu deposit' : tag.data;
            }
          }
          return '';
        } catch (_) {
          return '';
        }
      default: return '';
    }
  }
}

/// Extension on [IHistoryEntry] to handle functionalities related to Lightning Network invoices.
///
/// This extension is particularly useful when the `type` of [IHistoryEntry] is [IHistoryType.lnInvoice].
extension LnHistoryEntryIsarEx on IHistoryEntryIsar {
  String? get paymentHash {
    if (type != IHistoryType.lnInvoice) return null;
    try {
      final req = Bolt11PaymentRequest(value);
      for (final tag in req.tags) {
        if (tag.type == 'payment_hash' && tag.data is String?) {
          return tag.data;
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}