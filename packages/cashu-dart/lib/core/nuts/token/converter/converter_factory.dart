
import '../token_model.dart';

abstract class ConverterFactory {
  static const tokenPrefix = 'cashu';

  String get tokenVersion;
  String get versionPrefix => '$tokenPrefix$tokenVersion';

  String? tryParseTokenJsonStrWithRaw(String token);

  String encodedToken(Token token);

  Token? decodedToken(String token);
}