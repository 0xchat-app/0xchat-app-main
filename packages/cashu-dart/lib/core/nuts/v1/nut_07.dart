

import '../../../utils/network/http_client.dart';
import '../../../utils/tools.dart';
import '../define.dart';
import '../token/proof_isar.dart';

extension TokenStateEx on TokenState {
  static TokenState? fromState(String stateStr) {
    switch (stateStr) {
      case 'UNSPENT': return TokenState.live;
      case 'PENDING': return TokenState.inFlight;
      case 'SPENT': return TokenState.burned;
      default: return null;
    }
  }
}

class Nut7 {
  static Future<CashuResponse<List<TokenState>>> requestTokenState({
    required String mintURL,
    required List<ProofIsar> proofs,
  }) async {
    final proofList = [...proofs];
    return HTTPClient.post(
      nutURLJoin(mintURL, 'checkstate'),
      params: {
        'Ys': proofList.map((e) {
          return e.Y;
        }).toList(),
      },
      modelBuilder: (json) {
        if (json is! Map) return null;
        final states = Tools.getValueAs<List>(json, 'states', []);
        if (states.length != proofList.length) return null;

        final result = <TokenState>[];
        for (var i = 0; i < proofList.length; ++i) {
          final proof = proofList[i];
          final stateEntry = states[i];
          if (stateEntry is! Map) return null;

          final Y = stateEntry['Y'];
          final state = TokenStateEx.fromState(stateEntry['state']);

          if (proof.Y == Y && state != null) {
            result.add(state);
          }
        }

        if (result.length != proofList.length) return null;

        return result;
      },
    );
  }
}