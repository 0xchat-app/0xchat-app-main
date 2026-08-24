
import 'dart:convert';

import 'package:cashu_dart/utils/tools.dart';

import '../../../utils/crypto_utils.dart';

enum ConditionType {

  p2pk('P2PK'),
  htlc('HTLC');

  const ConditionType(this.kind);
  final String kind;

  static ConditionType? fromValue(dynamic value) =>
      ConditionType.values.where(
            (element) => element.kind == value,
      ).firstOrNull;
}

typedef Nut10Data = (ConditionType kind, String nonce, String data, List<List<String>> tags);

abstract mixin class Nut10Secret {

  ConditionType get type;
  String nonce = CryptoUtils.randomPrivateKey().asBase64String();
  String get data;
  List<List<String>> get tags;

  String toSecretString() {
    final entry = [
      type.kind,
      {
        'nonce': nonce,
        'data': data,
        'tags': tags,
      }
    ];
    return jsonEncode(entry);
  }

  void refreshNonce() {
    nonce = CryptoUtils.randomPrivateKey().asBase64String();
  }

  static Nut10Data? dataFromSecretString(String secret) {
    try {
      final entry = jsonDecode(secret) as List;
      final kind = ConditionType.fromValue(entry.firstOrNull);
      if (kind == null) return null;

      final map = entry[1];
      final tagsRaw = map['tags'] ?? [];
      List<List<String>> tags = <List<String>>[];
      if (tagsRaw is List) {
        tags = tagsRaw.map(
                (list) => list.map((e) => e.toString()).cast<String>().toList()
        ).cast<List<String>>().toList();
      }
      return (kind, map['nonce'] as String, map['data'] as String, tags);
    } catch (_) {
      return null;
    }
  }
}