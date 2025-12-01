import 'dart:convert';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/user_config_tool.dart';
import 'package:ox_network/network_manager.dart';
import 'package:ox_localizable/ox_localizable.dart';

/// Translation service for translating text messages
class TranslateService {
  static const String _defaultLibreTranslateUrl = 'https://libretranslate.com/translate';

  /// Translate text using the configured translation service
  Future<String?> translate(String text) async {
    if (text.isEmpty) {
      return null;
    }

    // Get translation settings
    final serviceIndex = UserConfigTool.getSetting(
      StorageSettingKey.KEY_TRANSLATE_SERVICE.name,
      defaultValue: 0,
    ) as int;

    final url = UserConfigTool.getSetting(
      StorageSettingKey.KEY_TRANSLATE_URL.name,
      defaultValue: '',
    ) as String;

    final apiKey = UserConfigTool.getSetting(
      StorageSettingKey.KEY_TRANSLATE_API_KEY.name,
      defaultValue: '',
    ) as String;

    // Use LibreTranslate by default
    if (serviceIndex == 0) {
      return _translateWithLibreTranslate(
        text,
        url.isNotEmpty ? url : _defaultLibreTranslateUrl,
        apiKey,
      );
    }

    return null;
  }

  /// Translate using LibreTranslate API
  Future<String?> _translateWithLibreTranslate(
    String text,
    String baseUrl,
    String apiKey,
  ) async {
    try {
      // Detect source language (auto-detect)
      final sourceLang = 'auto';
      // Get target language from current locale
      final targetLang = _getTargetLanguage();

      final translateUrl = baseUrl.endsWith('/translate')
          ? baseUrl
          : '$baseUrl/translate';

      final requestData = {
        'q': text,
        'source': sourceLang,
        'target': targetLang,
        'format': 'text',
      };

      final headers = <String, String>{
        'Content-Type': 'application/json',
      };

      if (apiKey.isNotEmpty) {
        requestData['api_key'] = apiKey;
      }

      final response = await OXNetwork.instance.request(
        null,
        url: translateUrl,
        data: requestData,
        header: headers,
        contentType: OXNetwork.CONTENT_TYPE_JSON,
        requestType: RequestType.POST,
        showLoading: false,
        showError: false,
      );

      if (response.code == 200 && response.data != null) {
        final responseData = response.data;
        if (responseData is Map) {
          final translatedText = responseData['translatedText'] as String?;
          return translatedText;
        } else if (responseData is String) {
          // Try to parse as JSON
          try {
            final jsonData = json.decode(responseData);
            if (jsonData is Map) {
              final translatedText = jsonData['translatedText'] as String?;
              return translatedText;
            }
          } catch (_) {
            // If parsing fails, return null
          }
        }
      }

      return null;
    } catch (e) {
      print('Translation error: $e');
      return null;
    }
  }

  /// Get target language code from current locale
  String _getTargetLanguage() {
    final currentLocale = Localized.getCurrentLanguage();
    // Map locale to language code
    switch (currentLocale) {
      case LocaleType.zh:
      case LocaleType.zh_tw:
        return 'zh';
      case LocaleType.en:
        return 'en';
      case LocaleType.es:
        return 'es';
      case LocaleType.fr:
        return 'fr';
      case LocaleType.de:
        return 'de';
      case LocaleType.ja:
        return 'ja';
      case LocaleType.ko:
        return 'ko';
      case LocaleType.ru:
        return 'ru';
      case LocaleType.pt:
        return 'pt';
      case LocaleType.it:
        return 'it';
      case LocaleType.ar:
        return 'ar';
      case LocaleType.tr:
        return 'tr';
      case LocaleType.pl:
        return 'pl';
      case LocaleType.nl:
        return 'nl';
      case LocaleType.sv:
        return 'sv';
      case LocaleType.da:
        return 'da';
      case LocaleType.cs:
        return 'cs';
      case LocaleType.hu:
        return 'hu';
      case LocaleType.th:
        return 'th';
      case LocaleType.vi:
        return 'vi';
      case LocaleType.id:
        return 'id';
      case LocaleType.uk:
        return 'uk';
      case LocaleType.el:
        return 'el';
      case LocaleType.hi:
        return 'hi';
      case LocaleType.fa:
        return 'fa';
      case LocaleType.ur:
        return 'ur';
      case LocaleType.bg:
        return 'bg';
      case LocaleType.ca:
        return 'ca';
      case LocaleType.az:
        return 'az';
      case LocaleType.et:
        return 'et';
      case LocaleType.lv:
        return 'lv';
      default:
        return 'en'; // Default to English
    }
  }
}

