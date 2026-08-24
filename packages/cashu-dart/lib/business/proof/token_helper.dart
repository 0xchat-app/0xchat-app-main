import '../../core/mint_actions.dart';
import '../../core/nuts/define.dart';
import '../../core/nuts/nut_00.dart';
import '../wallet/cashu_manager.dart';

class TokenHelper {
  static Future<bool?> isTokenSpendable(String ecashToken) async {
    final token = Nut0.decodedToken(ecashToken);
    if (token == null) return null;

    final tokenEntry = token.entries;
    for (final entry in tokenEntry) {
      final mint = await CashuManager.shared.getMint(entry.mint);
      if (mint == null) continue ;

      final response = await mint.tokenCheckAction(mintURL: mint.mintURL, proofs: entry.proofs);
      if (!response.isSuccess) return null;
      if (response.data.any((state) => state != TokenState.live)) {
        return false;
      }
    }

    return true;
  }
}