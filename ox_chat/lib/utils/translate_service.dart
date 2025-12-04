import 'dart:async';
import 'dart:convert';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/user_config_tool.dart';
import 'package:ox_network/network_manager.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/widgets/common_toast.dart';

/// Translation service for translating text messages
class TranslateService {
  /// Pre-download common language models in the background
  /// This should be called during app startup to avoid waiting for downloads when users first use translation
  static Future<void> preloadCommonLanguageModels() async {
    // Only preload if Google ML Kit is the selected service (default)
    final serviceIndex = UserConfigTool.getSetting(
      StorageSettingKey.KEY_TRANSLATE_SERVICE.name,
      defaultValue: 0,
    ) as int;
    
    if (serviceIndex != 0) {
      // Only preload for Google ML Kit
      return;
    }
    
    // Common languages: English, Chinese, Japanese, Portuguese, Spanish
    final commonLanguages = ['en', 'zh', 'ja', 'pt', 'es'];
    
    final modelManager = OnDeviceTranslatorModelManager();
    
    // Download models in parallel, but don't wait for all to complete
    // This allows app to start quickly while models download in background
    Future.microtask(() async {
      for (final langCode in commonLanguages) {
        try {
          // Map language code to TranslateLanguage enum
          TranslateLanguage? translateLang;
          switch (langCode) {
            case 'zh':
              translateLang = TranslateLanguage.chinese;
              break;
            case 'en':
              translateLang = TranslateLanguage.english;
              break;
            case 'es':
              translateLang = TranslateLanguage.spanish;
              break;
            case 'pt':
              translateLang = TranslateLanguage.portuguese;
              break;
            case 'ja':
              translateLang = TranslateLanguage.japanese;
              break;
            default:
              continue;
          }
          
          // Check if model is already downloaded
          final isDownloaded = await modelManager.isModelDownloaded(translateLang.bcpCode);
          if (isDownloaded) {
            continue;
          }
          
          // Download with timeout, but don't throw errors
          await modelManager.downloadModel(translateLang.bcpCode)
              .timeout(
                const Duration(seconds: 120),
                onTimeout: () {
                  return false;
                },
              );
        } catch (e) {
          // Don't throw - just continue with other languages
        }
      }
    });
  }

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

    // Use Google ML Kit by default (serviceIndex == 0)
    if (serviceIndex == 0) {
      return _translateWithGoogleMLKit(text);
    }
    
    // Use LibreTranslate (serviceIndex == 1)
    if (serviceIndex == 1) {
      if (url.isEmpty) {
        throw Exception(Localized.text('ox_chat.translate_not_configured_content'));
      }
      return _translateWithLibreTranslate(
        text,
        url,
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
      return null;
    }
  }

  /// Translate using Google ML Kit (offline translation)
  Future<String?> _translateWithGoogleMLKit(String text) async {
    try {
      // Get target language from current locale
      final targetLang = _getMLKitTargetLanguage();
      
      // Map language codes to TranslateLanguage enum values
      TranslateLanguage getTranslateLanguage(String langCode) {
        switch (langCode) {
          case 'zh':
            return TranslateLanguage.chinese;
          case 'en':
            return TranslateLanguage.english;
          case 'es':
            return TranslateLanguage.spanish;
          case 'fr':
            return TranslateLanguage.french;
          case 'de':
            return TranslateLanguage.german;
          case 'ja':
            return TranslateLanguage.japanese;
          case 'ko':
            return TranslateLanguage.korean;
          case 'ru':
            return TranslateLanguage.russian;
          case 'pt':
            return TranslateLanguage.portuguese;
          case 'it':
            return TranslateLanguage.italian;
          case 'ar':
            return TranslateLanguage.arabic;
          case 'tr':
            return TranslateLanguage.turkish;
          case 'pl':
            return TranslateLanguage.polish;
          case 'nl':
            return TranslateLanguage.dutch;
          case 'sv':
            return TranslateLanguage.swedish;
          case 'da':
            return TranslateLanguage.danish;
          case 'cs':
            return TranslateLanguage.czech;
          case 'hu':
            return TranslateLanguage.hungarian;
          case 'th':
            return TranslateLanguage.thai;
          case 'vi':
            return TranslateLanguage.vietnamese;
          case 'id':
            return TranslateLanguage.indonesian;
          case 'uk':
            return TranslateLanguage.ukrainian;
          case 'el':
            return TranslateLanguage.greek;
          case 'hi':
            return TranslateLanguage.hindi;
          case 'fa':
            return TranslateLanguage.persian;
          case 'ur':
            return TranslateLanguage.urdu;
          case 'bg':
            return TranslateLanguage.bulgarian;
          case 'ca':
            return TranslateLanguage.catalan;
          case 'az':
            return TranslateLanguage.english; // Azerbaijani not available, use English
          case 'et':
            return TranslateLanguage.estonian;
          case 'lv':
            return TranslateLanguage.latvian;
          case 'gl':
            // Galician not directly supported, use Spanish as fallback (closely related)
            LogUtil.w('[TranslateService] Galician (gl) not supported, using Spanish (es) as fallback');
            return TranslateLanguage.spanish;
          default:
            LogUtil.w('[TranslateService] Language "$langCode" not supported, using English as fallback');
            return TranslateLanguage.english;
        }
      }
      
      final targetLangCode = getTranslateLanguage(targetLang);
      
      // Step 1: Detect the actual language of the text
      String? detectedSourceLang;
      LanguageIdentifier? languageIdentifier;
      try {
        languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);
        detectedSourceLang = await languageIdentifier.identifyLanguage(text)
            .timeout(
              const Duration(seconds: 5),
              onTimeout: () {
                return 'und'; // undetermined
              },
            );
        languageIdentifier.close();
      } catch (e) {
        languageIdentifier?.close();
        // If detection fails, treat as English
        detectedSourceLang = 'en';
      }
      
      // Step 2: Use detected language or fallback to English
      String sourceLangToUse;
      if (detectedSourceLang == 'und' || detectedSourceLang.isEmpty) {
        // If language is undetermined, treat as English
        sourceLangToUse = 'en';
      } else {
        sourceLangToUse = detectedSourceLang;
      }
      
      // Step 3: Get the actual TranslateLanguage enum for source language
      // This may map to a different language if the detected language is not supported
      final sourceLangCode = getTranslateLanguage(sourceLangToUse);
      final actualSourceLang = sourceLangCode.bcpCode;
      
      // If source and target are the same, no translation needed
      if (actualSourceLang == targetLangCode.bcpCode) {
        return text;
      }
      
      // Download target language model first
      final modelManager = OnDeviceTranslatorModelManager();
      final isTargetModelDownloaded = await modelManager.isModelDownloaded(targetLangCode.bcpCode);
      
      if (!isTargetModelDownloaded) {
        // Show toast to inform user that language pack is downloading
        final context = OXNavigator.navigatorKey.currentContext;
        if (context != null) {
          CommonToast.instance.show(
            context,
            Localized.text('ox_chat.translate_downloading_model'),
          );
        }
        
        try {
          // Download model - add timeout to prevent hanging
          // According to API, downloadModel returns a Future<bool>
          final downloadResult = await modelManager.downloadModel(targetLangCode.bcpCode)
              .timeout(
                const Duration(seconds: 300), // 5 minutes timeout for model download
                onTimeout: () {
                  LogUtil.e('[TranslateService] Target model download timeout after 300 seconds');
                  return false;
                },
              );
          if (!downloadResult) {
            throw Exception('Failed to download translation model for $targetLang');
          }
        } catch (e) {
          LogUtil.e('[TranslateService] Error downloading target model: $e');
          if (e is TimeoutException) {
            throw Exception('Translation model download timeout. Please check your network connection.');
          }
          throw Exception('Failed to download translation model for $targetLang: $e');
        }
      }
      
      // Step 4: Download source language model if needed
      // Check if source language model is downloaded
      final isSourceModelDownloaded = await modelManager.isModelDownloaded(actualSourceLang);
      
      if (!isSourceModelDownloaded) {
        // Show toast to inform user that language pack is downloading
        final context = OXNavigator.navigatorKey.currentContext;
        if (context != null) {
          CommonToast.instance.show(
            context,
            Localized.text('ox_chat.translate_downloading_model'),
          );
        }
        
        try {
          final downloadResult = await modelManager.downloadModel(actualSourceLang)
              .timeout(
                const Duration(seconds: 300), // 5 minutes timeout for model download
                onTimeout: () {
                  LogUtil.e('[TranslateService] Source model download timeout after 300 seconds');
                  return false;
                },
              );
          if (!downloadResult) {
            throw Exception('Failed to download source language model for $sourceLangToUse');
          }
        } catch (e) {
          LogUtil.e('[TranslateService] Error downloading source model: $e');
          if (e is TimeoutException) {
            throw Exception('Translation model download timeout. Please check your network connection.');
          }
          throw Exception('Failed to download source language model for $sourceLangToUse: $e');
        }
      }
      
      // Step 5: Create translator and translate
      final translator = OnDeviceTranslator(
        sourceLanguage: sourceLangCode,
        targetLanguage: targetLangCode,
      );
      
      try {
        final translatedText = await translator.translateText(text)
            .timeout(
              const Duration(seconds: 10),
              onTimeout: () {
                throw TimeoutException('Translation timeout');
              },
            );
        
        // Check if translation is meaningful
        if (translatedText.trim() != text.trim() && 
            translatedText.trim().isNotEmpty &&
            translatedText.length > text.length * 0.5) {
          return translatedText;
        } else {
          // Text might already be in target language
          return null;
        }
      } finally {
        await translator.close();
      }
    } catch (e) {
      LogUtil.e('[TranslateService] Google ML Kit translation error: $e');
      throw Exception('Translation failed: ${e.toString()}');
    }
  }

  /// Get ML Kit target language code from current locale
  String _getMLKitTargetLanguage() {
    final currentLocale = Localized.getCurrentLanguage();
    // Map locale to ML Kit language code
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

      if (response.code == 200 && response.data != null) {
        final responseData = response.data;
        
        if (responseData is Map) {
          final translatedText = responseData['translatedText'] as String?;
          // Check if translation is different from original
          if (translatedText != null && translatedText.trim() != text.trim()) {
            return translatedText;
          }
          // If translation is same as original, return original text
          return text;
        } else if (responseData is String) {
          // Try to parse as JSON
          try {
            final jsonData = json.decode(responseData);
            if (jsonData is Map) {
              final translatedText = jsonData['translatedText'] as String?;
              // Check if translation is different from original
              if (translatedText != null && translatedText.trim() != text.trim()) {
                return translatedText;
              }
              // If translation is same as original, return original text
              return text;
            }
          } catch (e) {
            // If parsing fails, return null
          }
        }
      } else {
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
    }
  }
}

