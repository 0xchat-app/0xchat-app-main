
import 'dart:convert';

import 'package:cashu_dart/utils/tools.dart';

import '../../../../utils/log_util.dart';
import '../token_model.dart';
import 'converter_factory.dart';

class ConverterA extends ConverterFactory {
  @override
  final tokenVersion = 'A';

  final List<String> _uriPrefixes = ['cashuA'];

  @override
  String? tryParseTokenJsonStrWithRaw(String token) {
    List<String> uriPrefixes = _uriPrefixes;
    for (var prefix in uriPrefixes) {
      if (token.startsWith(prefix)) {
        final result = token.substring(prefix.length);
        if (result.isNotEmpty) return result;
      }
    }
    return null;
  }

  @override
  String encodedToken(Token token) {
    String json = jsonEncode(token.toJson());
    String base64Encoded = base64.encode(utf8.encode(json)).base64urlFromBase64();
    return versionPrefix + base64Encoded;
  }

  @override
  Token? decodedToken(String token) {
    dynamic obj;
    try {
      obj = token.decodeBase64ToMapByJson<Map>();
    } catch (e) {
      LogUtils.e(() => '[Cashu - handleTokens] $e');
    }

    if (obj == null) return null;

    // check if v3
    if (obj is Map && obj.containsKey('token')) {
      return Token.fromJson(obj);
    }

    // if v2 token return v3 format
    if (obj is Map && obj.containsKey('proofs')) {
      final proofs = obj['proofs'];
      final mints = obj['mints'];
      if (proofs is List && mints is List) {
        return Token(
          entries: proofs.map((e) => TokenEntry.fromJson(e)).toList(),
          memo: mints.firstOrNull?['url'] ?? '',
        );
      }
    }

    // check if v1
    if (obj is List) {
      return Token(
        entries: obj.map((e) => TokenEntry.fromJson(e)).toList(),
      );
    }

    return null;
  }
}