import '../token_model.dart';
import 'converter_A.dart';
import 'converter_B.dart';
import 'converter_factory.dart';

class Converter {
  static List<ConverterFactory> get _converters => [
    ConverterA(),
    ConverterB(),
  ];

  static List<String> get uriPrefixes =>
    _converters.map((c) => c.versionPrefix).toList();

  static bool isCashuToken(String token) {
    final converters = [..._converters];
    for (var converterTmp in converters) {
      final result = converterTmp.tryParseTokenJsonStrWithRaw(token);
      if (result != null) {
        return true;
      }
    }
    return false;
  }

  static String encodedToken(Token token, [bool useV4Token = true]) {
    if (useV4Token) {
      return ConverterB().encodedToken(token);
    } else {
      return ConverterA().encodedToken(token);
    }
  }

  static Token? decodedToken(String token) {
    if (token.isEmpty) return null;
    
    final converters = [..._converters];

    ConverterFactory? converter;
    String? tokenJsonStr;
    for (var converterTmp in converters) {
      final result = converterTmp.tryParseTokenJsonStrWithRaw(token);
      if (result != null) {
        converter = converterTmp;
        tokenJsonStr = result;
        break;
      }
    }

    if (converter == null || tokenJsonStr == null) return null;

    return converter.decodedToken(tokenJsonStr);
  }
}

