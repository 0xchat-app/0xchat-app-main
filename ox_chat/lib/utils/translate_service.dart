import 'dart:convert';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/user_config_tool.dart';
import 'package:ox_network/network_manager.dart';
import 'package:ox_localizable/ox_localizable.dart';

/// Translation service for translating text messages
class TranslateService {
  static const String _defaultLibreTranslateUrl = 'http://localhost:5000/translate';

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

  /// Detect language of text
  Future<String?> _detectLanguage(String text, String baseUrl, String apiKey) async {
    try {
      // Build detect URL from base URL
      String finalDetectUrl;
      if (baseUrl.endsWith('/translate')) {
        finalDetectUrl = baseUrl.replaceAll('/translate', '/detect');
      } else if (baseUrl.endsWith('/')) {
        finalDetectUrl = '${baseUrl}detect';
      } else {
        finalDetectUrl = '$baseUrl/detect';
      }

      final requestData = {
        'q': text,
      };

      final headers = <String, String>{
        'Content-Type': 'application/json',
      };

      if (apiKey.isNotEmpty) {
        requestData['api_key'] = apiKey;
      }

      final response = await OXNetwork.instance.request(
        null,
        url: finalDetectUrl,
        data: requestData,
        header: headers,
        contentType: OXNetwork.CONTENT_TYPE_JSON,
        requestType: RequestType.POST,
        showLoading: false,
        showError: false,
      );

      if (response.code == 200 && response.data != null) {
        final responseData = response.data;
        if (responseData is List && responseData.isNotEmpty) {
          final detectedLang = responseData[0] as Map?;
          return detectedLang?['language'] as String?;
        } else if (responseData is Map) {
          return responseData['language'] as String?;
        } else if (responseData is String) {
          try {
            final jsonData = json.decode(responseData);
            if (jsonData is List && jsonData.isNotEmpty) {
              final detectedLang = jsonData[0] as Map?;
              return detectedLang?['language'] as String?;
            } else if (jsonData is Map) {
              return jsonData['language'] as String?;
            }
          } catch (_) {
            // If parsing fails, return null
          }
        }
      }

      return null;
    } catch (e) {
      print('Language detection error: $e');
      return null;
    }
  }

  /// Translate using LibreTranslate API
  /// Returns the original text if source and target languages are the same
  Future<String?> _translateWithLibreTranslate(
    String text,
    String baseUrl,
    String apiKey,
  ) async {
    try {
      // Get target language from current locale
      final targetLang = _getTargetLanguage();

      // Try to detect source language first
      String? detectedLang;
      try {
        detectedLang = await _detectLanguage(text, baseUrl, apiKey);
        // If detected language is the same as target language, return original text
        if (detectedLang != null && detectedLang == targetLang) {
          return text; // Return original text instead of null
        }
      } catch (e) {
        // If detection fails, continue with auto-detect
        print('Language detection failed, using auto-detect: $e');
      }

      // Use detected language or auto-detect
      final sourceLang = detectedLang ?? 'auto';

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

      print('Translation response code: ${response.code}');
      
      if (response.code == 200 && response.data != null) {
        final responseData = response.data;
        print('Translation response data type: ${responseData.runtimeType}');
        
        if (responseData is Map) {
          final translatedText = responseData['translatedText'] as String?;
          print('Translated text: $translatedText');
          // Check if translation is different from original
          if (translatedText != null && translatedText.trim() != text.trim()) {
            return translatedText;
          }
          // If translation is same as original, return original text
          print('Translation same as original, returning original text');
          return text;
        } else if (responseData is String) {
          // Try to parse as JSON
          try {
            final jsonData = json.decode(responseData);
            if (jsonData is Map) {
              final translatedText = jsonData['translatedText'] as String?;
              print('Translated text (from string): $translatedText');
              // Check if translation is different from original
              if (translatedText != null && translatedText.trim() != text.trim()) {
                return translatedText;
              }
              // If translation is same as original, return original text
              print('Translation same as original, returning original text');
              return text;
            }
          } catch (e) {
            print('JSON parsing error: $e');
            // If parsing fails, return null
          }
        }
      } else {
        print('Translation failed: code=${response.code}, data=${response.data}');
        // Provide specific error messages based on response code
        if (response.code == 502) {
          throw Exception(Localized.text('ox_chat.translate_service_initializing'));
        } else if (response.code == 503) {
          throw Exception(Localized.text('ox_chat.translate_service_unavailable'));
        } else if (response.code >= 400) {
          throw Exception(Localized.text('ox_chat.translate_service_error').replaceAll(r'${code}', response.code.toString()));
        } else {
          throw Exception(Localized.text('ox_chat.translate_network_error'));
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

