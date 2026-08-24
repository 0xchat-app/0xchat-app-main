
import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../../../utils/network/http_client.dart';
import '../define.dart';

class Nut1 {
  static Future<CashuResponse<List<MintKeysPayload>>> requestKeys({required String mintURL, String? keysetId}) async {
    var endpoint = nutURLJoin(mintURL, 'keys', version: '');
    if (keysetId != null) {
      keysetId = Uri.encodeComponent(keysetId);
      endpoint = '$endpoint/$keysetId';
    }
    return HTTPClient.get(
      endpoint,
      modelBuilder: (json) {
        if (json is! Map) return null;
        final keys = json.map((key, value) => MapEntry(key.toString(), value.toString()));
        return [MintKeysPayload(keysetId ?? keys.deriveKeysetId(), 'sat', keys)];
      },
    );
  }
}

extension _MintKeysEx on MintKeys {
  String deriveKeysetId() {
    final keys = entries.toList()..sort((a, b) {
      final aNum = BigInt.tryParse(a.key) ?? BigInt.zero;
      final bNum = BigInt.tryParse(b.key) ?? BigInt.zero;
      return aNum.compareTo(bNum);
    });
    final pubkeysConcat = keys.map((entry) => entry.value).join('');

    var bytes = utf8.encode(pubkeysConcat);
    var hash = sha256.convert(bytes);

    return base64.encode(hash.bytes).substring(0, 12);
  }
}