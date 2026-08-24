
import '../../../utils/network/http_client.dart';
import '../../../utils/tools.dart';
import '../define.dart';
import '../nut_00.dart';
import '../token/proof_isar.dart';

class Nut8 {
  static Future<CashuResponse<MeltResponse>> payingTheQuote({
    required String mintURL,
    required String quote,
    required List<ProofIsar> inputs,
    required List<BlindedMessage> outputs,
    String method = 'bolt11',
  }) async {
    return HTTPClient.post(
      nutURLJoin(mintURL, 'melt/$method'),
      params: {
        'quote': quote,
        'inputs': inputs.map((e) {
          return {
            'id': e.keysetId,
            'amount': num.tryParse(e.amount) ?? 0,
            'secret': e.secret,
            'C': e.C,
          };
        }).toList(),
        'outputs': outputs.map((e) {
          return {
            'id': e.id,
            'amount': e.amount,
            'B_': e.B_,
          };
        }).toList(),
      },
      modelBuilder: (json) {
        if (json is! Map) return null;
        final paid = Tools.getValueAs<bool>(json, 'paid', false);
        final preimage = Tools.getValueAs<String>(json, 'payment_preimage', '');
        final change = Tools.getValueAs<List>(json, 'change', []).map((map) {
          if (map is! Map) return null;
          return BlindedSignature.fromServerMap(map);
        }).where((e) => e != null).cast<BlindedSignature>().toList();
        return (paid, preimage, change);
      },
    );
  }
}