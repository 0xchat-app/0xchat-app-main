
import '../../../utils/network/http_client.dart';
import '../../../utils/tools.dart';
import '../define.dart';
import '../nut_00.dart';

typedef RestorePayload = (
  BlindedMessage blindedMessages,
  BlindedSignature signatures,
);

class Nut9 {
  static Future<CashuResponse<List<RestorePayload>>> requestRestoreSignatures({
    required String mintURL,
    required List<BlindedMessage> blindedMessages,
  }) async {
    return HTTPClient.post<List<RestorePayload>>(
      nutURLJoin(mintURL, 'restore'),
      params: {
        'outputs': blindedMessages.map((e) {
          return {
            'id': e.id,
            'amount': e.amount,
            'B_': e.B_,
          };
        }).toList(),
      },
      modelBuilder: (json) {
        if (json is! Map) return null;

        final blindedMessages = Tools.getValueAs<List>(json, 'outputs', [])
            .map((e) => BlindedMessage.fromServerMap(e))
            .toList();
        final signatures = Tools.getValueAs<List>(json, 'signatures', [])
            .map((e) => BlindedSignature.fromServerMap(e))
            .toList();
        if (blindedMessages.length != signatures.length) return null;

        List<RestorePayload> list = <RestorePayload>[];
        for (var i = 0; i < blindedMessages.length; i++) {
          list.add((blindedMessages[i], signatures[i],));
        }
        return list;
      },
    );
  }
}