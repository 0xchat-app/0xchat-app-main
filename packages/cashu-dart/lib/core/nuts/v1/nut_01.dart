
import '../../../utils/network/http_client.dart';
import '../../../utils/tools.dart';
import '../define.dart';

class Nut1 {
  static Future<CashuResponse<List<MintKeysPayload>>> requestKeys({required String mintURL, String? keysetId}) async {
    var endpoint = nutURLJoin(mintURL, 'keys');
    if (keysetId != null) {
      keysetId = Uri.encodeComponent(keysetId);
      endpoint = '$endpoint/$keysetId';
    }
    return HTTPClient.get(
      endpoint,
      modelBuilder: (json) {
        if (json is! Map) return null;
        final keysets = Tools.getValueAs(json, 'keysets', []);
        return keysets.map((e) => MintKeysPayload.fromServerMap(e))
            .where((element) => element != null)
            .cast<MintKeysPayload>()
            .toList();
      },
    );
  }
}