
import '../../../utils/network/http_client.dart';
import '../../../utils/tools.dart';
import '../define.dart';
import '../nut_00.dart';
import '../token/proof_isar.dart';

class MeltQuotePayload {
  MeltQuotePayload(this.quote, this.amount, this.fee, this.paid, this.expiry);
  final String quote;
  final String amount;
  final String fee;
  final bool paid;
  final int? expiry;

  static MeltQuotePayload? fromServerMap(Map json) {
    final quote = Tools.getValueAs<String>(json, 'quote', '');
    final amount = Tools.getValueAs<int>(json, 'amount', 0).toString();
    final fee = Tools.getValueAs<int>(json, 'fee_reserve', 0).toString();
    final paid = Tools.getValueAs<bool>(json, 'paid', false);
    final expiry = Tools.getValueAs<int?>(json, 'expiry', null);
    if (quote.isEmpty) return null;
    return MeltQuotePayload(quote, amount, fee, paid, expiry);
  }
}

class Nut5 {
  static Future<CashuResponse<MeltQuotePayload>> requestMeltQuote({
    required String mintURL,
    required String request,
    String method = 'bolt11',
    String unit = 'sat',
  }) async {
    return HTTPClient.post(
      nutURLJoin(mintURL, 'melt/quote/$method'),
      params: {
        'request': request.toString(),
        'unit': unit,
      },
      modelBuilder: (json) {
        if (json is! Map) return null;
        return MeltQuotePayload.fromServerMap(json);
      },
    );
  }

  static Future<CashuResponse<MeltQuotePayload>> checkMintQuoteState({
    required String mintURL,
    required String quoteID,
    String method = 'bolt11',
  }) async {
    return HTTPClient.get(
      nutURLJoin(mintURL, 'melt/quote/$method/$quoteID'),
      modelBuilder: (json) {
        if (json is! Map) return null;
        return MeltQuotePayload.fromServerMap(json);
      },
    );
  }

  @Deprecated('Use Nut8.payingTheQuote instead.')
  static Future<CashuResponse<(bool paid, String paymentPreimage)>> meltToken({
    required String mintURL,
    required String quote,
    required List<ProofIsar> inputs,
    required List<BlindedMessage> outputs,
    String method = 'bolt11',
  }) async {
    return HTTPClient.post(
      nutURLJoin(mintURL, 'melt/quote/$method'),
      params: {
        'quote': quote,
        'inputs': inputs.map((e) => e.toJson()).toList(),
      },
      modelBuilder: (json) {
        if (json is! Map) return null;
        final paid = Tools.getValueAs<bool>(json, 'paid', false);
        final preimage = Tools.getValueAs<String>(json, 'preimage', '');
        return (paid, preimage);
      },
    );
  }
}