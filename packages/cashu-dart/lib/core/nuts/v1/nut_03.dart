
import '../../../utils/network/http_client.dart';
import '../../../utils/tools.dart';
import '../define.dart';
import '../nut_00.dart';
import '../token/proof_isar.dart';

class Nut3 {
  static Future<CashuResponse<List<BlindedSignature>>> swap({
    required String mintURL,
    required List<ProofIsar> proofs,
    required List<BlindedMessage> outputs,
  }) async {
    return HTTPClient.post(
      nutURLJoin(mintURL, 'swap'),
      params: {
        'inputs': proofs.map((e) => e.toJson()).toList(),
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
        final signatures = Tools.getValueAs<List>(json, 'signatures', []);
        return signatures.map((e) {
          if (e is! Map) return null;
          return BlindedSignature.fromServerMap(e);
        }).where((e) => e != null).toList().cast();
      },
    );
  }
}