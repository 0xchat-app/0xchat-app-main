import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ox_cache_manager/ox_cache_manager.dart';

/*
*  Usage
*  Localized.text('key')
* */
enum LocaleType {
    ar,//Arabic
    az,//Azerbaijani
    bg,//Bulgarian
    ca,//Catalan
    cs,//Czech
    da,//danish
    de,//German
    el,//Greek
    es,//Spanish
    et,//estonian
    fa,//Farsi
    fr,//French
    hi,//Hindi
    hu,//Hungarian
    id,//Indonesian
    it,//Italian
    ja,//Japanese
    ko,//Korean
    lv,//Latvian
    nl,//Dutch
    pl,//Polish
    pt,//Portuguese
    ru,//Russian
    sv,//Swedish
    th,//Thai
    tr,//Turkish
    uk,//Ukrainian
    vi,//Vietnamese
    zh_tw,//Traditional Chinese
    en,//English
    zh,//Simplified Chinese
}

extension LocaleTypeExtension on LocaleType{

    String value(){
        switch(this){
            case LocaleType.en:
                return "en";
            case LocaleType.zh:
                return "zh";
            case LocaleType.ru:
                return "ru";
            case LocaleType.fr:
                return "fr";
            case LocaleType.de:
                return "de";
            case LocaleType.es:
                return "es";
            case LocaleType.ja:
                return "ja";
            case LocaleType.ko:
                return "ko";
            case LocaleType.pt:
                return "pt";
            case LocaleType.vi:
                return "vi";
            case LocaleType.ar:
                return "ar";
            case LocaleType.th:
                return "th";
            case LocaleType.zh_tw:
                return "zh_tw";
            case LocaleType.it:
                return 'it';
            case LocaleType.tr:
                return 'tr';
            case LocaleType.sv:
                return 'sv';
            case LocaleType.hu:
                return 'hu';
            case LocaleType.nl:
                return 'nl';
            case LocaleType.pl:
                return 'pl';
            case LocaleType.el:
                return 'el';
            case LocaleType.cs:
                return 'cs';
            case LocaleType.lv:
                return 'lv';
            case LocaleType.az:
                return 'az';
            case LocaleType.uk:
                return 'uk';
            case LocaleType.bg:
                return 'bg';
            case LocaleType.id:
                return 'id';
            case LocaleType.et:
                return 'et';
            case LocaleType.hi:
                return 'hi';
            case LocaleType.da:
                return 'da';
            case LocaleType.ca:
                return 'ca';
            case LocaleType.fa:
                return 'fa';
        }
    }


    int symbol(){

        switch(this){
            case LocaleType.en:
                return 1;
            case LocaleType.zh:
                return 2;
            case LocaleType.ru:
                return 3;
            case LocaleType.fr:
                return 4;
            case LocaleType.de:
                return 5;
            case LocaleType.es:
                return 6;
            case LocaleType.ja:
                return 7;
            case LocaleType.ko:
                return 8;
            case LocaleType.pt:
                return 9;
            case LocaleType.vi:
                return 10;
            case LocaleType.ar:
                return 11;
            case LocaleType.th:
                return 12;
            case LocaleType.zh_tw:
                return 13;
            case LocaleType.it:
                return 14;
            case LocaleType.tr:
                return 15;
            case LocaleType.sv:
                return 16;
            case LocaleType.hu:
                return 17;
            case LocaleType.nl:
                return 18;
            case LocaleType.pl:
                return 19;
            case LocaleType.el:
                return 20;
            case LocaleType.cs:
                return 21;
            case LocaleType.lv:
                return 22;
            case LocaleType.az:
                return 23;
            case LocaleType.uk:
                return 24;
            case LocaleType.bg:
                return 25;
            case LocaleType.id:
                return 26;
            case LocaleType.et:
                return 27;
            case LocaleType.hi:
                return 28;
            case LocaleType.da:
                return 29;
            case LocaleType.ca:
                return 30;
            case LocaleType.fa:
                return 31;
        }
    }

    String get nativeLocalString {
        switch(this){
            case LocaleType.en:
                return "en";
            case LocaleType.zh:
                return "zh-Hans";
            case LocaleType.ru:
                return "ru";
            case LocaleType.fr:
                return "fr";
            case LocaleType.de:
                return "de";
            case LocaleType.es:
                return "es";
            case LocaleType.ja:
                return "ja";
            case LocaleType.ko:
                return "ko";
            case LocaleType.pt:
                return "pt";
            case LocaleType.vi:
                return "vi";
            case LocaleType.ar:
                return "ar";
            case LocaleType.th:
                return "th";
            case LocaleType.zh_tw:
                return "zh-TW";
            case LocaleType.it:
                return 'it';
            case LocaleType.tr:
                return 'tr';
            case LocaleType.sv:
                return 'sv';
            case LocaleType.hu:
                return 'hu';
            case LocaleType.nl:
                return 'nl';
            case LocaleType.pl:
                return 'pl';
            case LocaleType.el:
                return 'el';
            case LocaleType.cs:
                return 'cs';
            case LocaleType.lv:
                return 'lv';
            case LocaleType.az:
                return 'az';
            case LocaleType.uk:
                return 'uk';
            case LocaleType.bg:
                return 'bg';
            case LocaleType.id:
                return 'id';
            case LocaleType.et:
                return 'et';
            case LocaleType.hi:
                return 'hi';
            case LocaleType.da:
                return 'da';
            case LocaleType.ca:
                return 'ca';
            case LocaleType.fa:
                return 'fa';
        }
    }

    String get languageText {
        switch (this) {
            case LocaleType.en:
                return 'English';
            case LocaleType.zh:
                return '简体中文';
            case LocaleType.ru:
                return 'русский';
            case LocaleType.fr:
                return 'Français';
            case LocaleType.de:
                return 'Deutsch';
            case LocaleType.es:
                return 'Español';
            case LocaleType.ja:
                return '日本語';
            case LocaleType.ko:
                return '한국어';
            case LocaleType.pt:
                return 'Português';
            case LocaleType.vi:
                return 'Tiếng việt';
            case LocaleType.ar:
                return 'عربي';
            case LocaleType.th:
                return 'ภาษาไทย';
            case LocaleType.zh_tw:
                return '繁體中文(中國台灣)';
            case LocaleType.it:
                return 'Italiano';
            case LocaleType.tr:
                return 'Türkçe';
            case LocaleType.sv:
                return 'Svenska';
            case LocaleType.hu:
                return 'Magyar';
            case LocaleType.nl:
                return 'Nederlands';
            case LocaleType.pl:
                return 'Polski';
            case LocaleType.el:
                return 'Ελληνικά';
            case LocaleType.cs:
                return 'čeština';
            case LocaleType.lv:
                return 'latviski';
            case LocaleType.az:
                return 'Azərbaycan';
            case LocaleType.uk:
                return 'украї́нська мо́ва';
            case LocaleType.bg:
                return 'български';
            case LocaleType.id:
                return 'Bahasa Indonesia';
            case LocaleType.et:
                return 'Eesti keel';
            case LocaleType.hi:
                return 'தமிழ்';
            case LocaleType.da:
                return 'Dansk';
            case LocaleType.ca:
                return 'Català';
            case LocaleType.fa:
                return 'فارسی';
        }
    }
}

const String chinaLanguageType = 'cn';

const String _keyLanguages = "userLanguage";

get localized => Localized.localized;

class Localized {

    static Localized localized = new Localized();

    LocaleType localeType = LocaleType.en;
    Map<dynamic, dynamic> localizedValues = {};
    Map<dynamic, dynamic> defaultLocalizedValues = {};
    Map<String, String> cache = {};
    Map<String, String> moduleAssetPaths = {};
    String _defaultLanguage = ui.window.locale.languageCode;

    static Iterable<Locale> supportedLocales() => LocaleType.values.map<Locale>((lang) => new Locale(lang.value(), ''));

    List<VoidCallback> _onLocaleChangedCallbackList = <VoidCallback>[];


    static LocaleType getCurrentLanguage() {
        return localized.localeType;
    }

    static String commonText(String key){

        return text('ox_common.$key');
    }

    static String text(String key,{ bool useOrigin = false }) {
        String? string;
        Map<dynamic, dynamic> _localizedValues = localized.localizedValues;
        Map<dynamic, dynamic> _defaultLocalizedValues = localized.defaultLocalizedValues;
        
        Map<String, String> _cache = localized.cache;
        {
          // if (_cache[key] != null) {
          //   return _cache[key]!;
          // }
          bool found = true;
          Map<dynamic, dynamic> _values = _localizedValues;
          List<String> _keyParts = key.split('.');
          int _keyPartsLen = _keyParts.length;
          int index = 0;
          int lastIndex = _keyPartsLen - 1;
          while (index < _keyPartsLen && found) {
            var value = _values[_keyParts[index]];
            if (value == null) {
              found = false;
              break;
            }
            if (value is String && index == lastIndex) {
              string = value;
              _cache[key] = string;
              break;
            }
            _values = value;
            index++;
          }
        }

        if (string != null) return string;

        //If the corresponding translation key is not found in the translation JSON, the default translation JSON (en) will be used
        {
            // if (_cache[key] != null){
            //     return _cache[key]!;
            // }
            bool found = true;
            Map<dynamic,dynamic>_defaultValues = _defaultLocalizedValues;
            List<String> _keyParts = key.split('.');
            int _keyPartsLen = _keyParts.length;
            int index = 0;
            int lastIndex = _keyPartsLen - 1;
            while(index < _keyPartsLen && found){
                var value = _defaultValues[_keyParts[index]];
                if (value == null) {
                    found = false;
                    break;
                }
                if (value is String && index == lastIndex){
                    string = value;
                    _cache[key] = string;
                    break;
                }
                _defaultValues = value;
                index++;
            }
        }

        if (string != null) return string;

        string = useOrigin ? key : "** EN $key not found EN";

        return string;
    }

    static Future<Null> init() async {

        String lan = await OXCacheManager.defaultOXCacheManager.getData(_keyLanguages, defaultValue: localized._defaultLanguage) as String;
        // if(lan == LocaleType.zh.value()){
        //     localized.localeType = LocaleType.zh;
        // }else{
        //     localized.localeType = LocaleType.en;
        // }
        localized.localeType = getLocaleTypeByString(lan);
        String language = localized.localeType.value();
        String? jsonContent = await _readAsset("assets/locale/i18n_$language.json");
        String? defaultJsonContent;
        if(localized.localeType == LocaleType.en){
            defaultJsonContent = jsonContent;
        }else{
            defaultJsonContent = await rootBundle.loadString("assets/locale/i18n_en.json");  //Default to reading English configuration.
        }
        if(jsonContent != null){
            localized.localizedValues = json.decode(jsonContent);
        }
        if(defaultJsonContent != null){
            localized.defaultLocalizedValues = json.decode(defaultJsonContent);
        }
        localized.cache = {};


        return null;
    }


    static Future<void> registerLocale(String moduleName,String assetPath) async{
        if (moduleName == 'ox_push') {
            return;
        }

        localized.moduleAssetPaths[moduleName] = assetPath;

        String language = localized.localeType.value();
        String localePath = "packages/$assetPath/locale/i18n_$language.json";

        String? jsonContent = await _readAsset(localePath);
        String? defaultJsonContent;
        if(localized.localeType == LocaleType.en){
            defaultJsonContent = jsonContent;
        }else{
            defaultJsonContent = await _readAsset("packages/$assetPath/locale/i18n_en.json");
        }

        if(jsonContent != null){
            localized.localizedValues[moduleName] = json.decode(jsonContent);
        }
        if(defaultJsonContent != null){
            localized.defaultLocalizedValues[moduleName] = json.decode(defaultJsonContent);
        }



    }


    static Future<String?> _readAsset(String path) async{

        try{
            return await rootBundle.loadString(path);
        }catch(e){
            print(e.toString());
            return null;
        }

    }

    static Future<void> changeLocale(LocaleType localeType) async{

        OXCacheManager.defaultOXCacheManager.saveData(_keyLanguages, localeType.value());

        localized.localeType = localeType;
        localized.cache = {};

        String language = localeType.value();

        String? jsonContent = await _readAsset("assets/locale/i18n_$language.json");
        if(jsonContent != null){
            localized.localizedValues = json.decode(jsonContent);
        }

        Future.forEach(localized.moduleAssetPaths.keys, (element) async{
            String moduleName = element.toString();
            String assetPath = localized.moduleAssetPaths[moduleName]!;
            String localePath = "packages/$assetPath/locale/i18n_$language.json";

            String? jsonContent = await _readAsset(localePath);

            if(jsonContent != null){
                localized.localizedValues[moduleName] = json.decode(jsonContent);
            }


        }).then((value){
        }).whenComplete((){
            localized._onLocaleChangedCallbackList.forEach((VoidCallback callback) {
                callback();
            });

        });

    }

    static LocaleType getLocaleTypeByString(String lan){

        for(int i = 0; i <= LocaleType.values.length -1; i++){
            if(LocaleType.values[i].value() == lan){
                return LocaleType.values[i];
            }
        }

        return LocaleType.en;

    }

    static addLocaleChangedCallback(VoidCallback callback) {
      localized._onLocaleChangedCallbackList.add(callback);
    }

    static removeLocaleChangedCallback(VoidCallback callback) {
      localized._onLocaleChangedCallbackList.remove(callback);
    }

    static final Localized _localized = new Localized._internal();

    factory Localized() {
        return _localized;
    }

    Localized._internal();
}