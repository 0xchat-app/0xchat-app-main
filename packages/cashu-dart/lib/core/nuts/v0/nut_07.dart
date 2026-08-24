
import '../../../utils/network/http_client.dart';
import '../../../utils/tools.dart';
import '../define.dart';
import '../token/proof_isar.dart';

extension TokenStateEx on TokenState {
  static TokenState fromState(bool spendable, bool pending) {
    if (!spendable) return TokenState.burned;
    if (!pending) {
      return TokenState.live;
    } else {
      return TokenState.inFlight;
    }
  }
}

class Nut7 {
  static Future<CashuResponse<List<TokenState>>> requestTokenState({
    required String mintURL,
    required List<ProofIsar> proofs,
  }) async {
    return HTTPClient.post(
      nutURLJoin(mintURL, 'check', version: ''),
      params: {
        'proofs': proofs.map((e) {
          return {
            'secret': e.secret,
          };
        }).toList(),
      },
      modelBuilder: (json) {
        if (json is! Map) return null;
        final spendableList = Tools.getValueAs<List>(json, 'spendable', []);
        final pendingList = Tools.getValueAs<List>(json, 'pending', []);
        if (spendableList.length != proofs.length ||
            pendingList.length != proofs.length) return null;

        final result = <TokenState>[];
        for (var i = 0; i < proofs.length; ++i) {
          final spendable = spendableList[i];
          final pending = pendingList[i];
          if (spendable is! bool || pending is! bool) return null;
          result.add(TokenStateEx.fromState(spendable, pending));
        }
        return result;
      },
    );
  }
}