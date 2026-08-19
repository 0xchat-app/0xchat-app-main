
import 'dart:convert';

import 'package:cashu_dart/utils/tools.dart';
import 'package:cbor/cbor.dart';

import '../../../../utils/log_util.dart';
import '../token_model.dart';
import 'converter_factory.dart';

class ConverterB extends ConverterFactory {
  @override
  final tokenVersion = 'B';

  @override
  String? tryParseTokenJsonStrWithRaw(String token) {
    final versionPrefix = this.versionPrefix;
    if (token.startsWith(versionPrefix)) {
      final result = token.substring(versionPrefix.length);
      if (result.isNotEmpty) return result;
    }
    return null;
  }

  @override
  String encodedToken(Token token) {
    final json = token.toV4Json();
    final cborValue = CborValue(json);
    final base64String = base64.encode(cbor.encode(cborValue));
    String base64URL = base64String.base64urlFromBase64();
    return versionPrefix + base64URL;
  }

  @override
  Token? decodedToken(String token) {
    Map? obj;
    try {
      obj = token.decodeBase64ToMapByCBOR<Map>();
    } catch (e) {
      LogUtils.e(() => '[Cashu - handleTokens] $e');
    }

    if (obj == null) return null;

    return Token.fromV4Json(obj);
  }
}