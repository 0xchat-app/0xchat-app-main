

import '../../../model/mint_info_isar.dart';
import '../../../utils/network/http_client.dart';
import '../define.dart';

class Nut9 {
  static Future<CashuResponse<MintInfoIsar>> requestMintInfo({
    required String mintURL,
  }) async {
    return HTTPClient.get(
      nutURLJoin(mintURL, 'info', version: ''),
      modelBuilder: (json) {
        if (json is! Map) return null;
        return MintInfoIsar.fromServerMap(json, mintURL);
      },
    );
  }
}