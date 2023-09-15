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
    en,//English
    zh,//Simplified Chinese
    ru,//Russian
    fr,//French
    de,//German
    es,//Spanish
    ja,//Japanese
    ko,//Korean
    pt,//Portuguese
    vi,//Vietnamese
    ar,//Arabic
    th,//Thai
    zh_tw,//Traditional Chinese
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
                return "zh-HK";
        }
    }
}

const String chinaLanguageType = 'cn';

const String _keyLanguages = "userLanguage";

class Localized {

    late LocaleType localeType;
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

    static String text(String key) {
        String string = '** $key not found';
        Map<dynamic, dynamic> _localizedValues = localized.localizedValues;
        Map<dynamic, dynamic> _defaultLocalizedValues = localized.defaultLocalizedValues;
        
        Map<String, String> _cache = localized.cache;
        if (_localizedValues != null) {
            if (_cache[key] != null){
                return _cache[key]!;
            }
            bool found = true;
            Map<dynamic, dynamic> _values = _localizedValues;
            List<String> _keyParts = key.split('.');
            int _keyPartsLen = _keyParts.length;
            int index = 0;
            int lastIndex = _keyPartsLen - 1;
            while(index < _keyPartsLen && found){
                var value = _values[_keyParts[index]];
                if (value == null) {
                    found = false;
                    break;
                }
                if (value is String && index == lastIndex){
                    string = value;
                    _cache[key] = string;
                    break;
                }
                _values = value;
                index++;
            }
        }
        if(string == ("** $key not found")){  //If the corresponding translation key is not found in the translation JSON, the default translation JSON (en) will be used
            if (_localizedValues != null) {
                if (_cache[key] != null){
                    return _cache[key]!;
                }
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
            if(string == ("** $key not found")){
                string = "** EN $key not found EN";   //Default English configuration missing.
                print('resourse：'+string);
            }else{
                print('resourse：'+"** $key not found-Transformation en："+string);
            }
        }
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

            print("共有:${localized._onLocaleChangedCallbackList.length}监听");
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

        return LocaleType.zh;

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

Localized localized = new Localized();