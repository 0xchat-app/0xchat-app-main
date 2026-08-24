
import '../../../utils/network/http_client.dart';
import '../../../utils/tools.dart';
import '../nut_00.dart';
import '../token/proof_isar.dart';

class Nut6 {
  /// Ask mint to perform a split operation
  /// [splitPayload] data needed for performing a token split
  /// Returns split tokens
  static Future<CashuResponse<List<BlindedSignature>>> split({
    required String mintURL,
    required List<ProofIsar> proofs,
    required List<BlindedMessage> outputs,
  }) async {
    return HTTPClient.post(
      '$mintURL/split',
      params: {
        'proofs': proofs.map((e) {
          return {
            'id': e.keysetId,
            'amount': num.tryParse(e.amount) ?? 0,
            'secret': e.secret,
            'C': e.C,
          };
        }).toList(),
        'outputs': outputs.map((e) {
          return {
            'amount': e.amount,
            'B_': e.B_,
          };
        }).toList(),
      },
      modelBuilder: (json) {
        if (json is! Map) return null;
        final promises = Tools.getValueAs<List>(json, 'promises', []);
        return promises.map((e) {
          if (e is! Map) return null;
          return BlindedSignature.fromServerMap(e);
        }).where((e) => e != null).toList().cast();
      },
    );
  }

}