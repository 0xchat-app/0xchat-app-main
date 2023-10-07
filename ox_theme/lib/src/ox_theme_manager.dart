
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:ox_cache_manager/ox_cache_manager.dart';

/*
* Usage
*  ThemeManager.colors('xxxxx')
*  ThemeManager.images('/lib/xxxx.png')
* */

enum ThemeStyle {
  light,
  dark
}

extension ThemeStyleExtension on ThemeStyle{

  String value(){

    switch(this){
      case ThemeStyle.light:
        return "light";
      case ThemeStyle.dark:
        return "dark";

    }

  }

}

const String _keyThemeStyle = "themeStyle";

class ThemeManager {

  List<Map<String, dynamic>> themeColors = [{},{}];
  late ThemeStyle themeStyle;
  Map<String, String> cache = {};
  List<VoidCallback> onThemeChangedCallbackList = [];
  //Default night mode
  final String defaultThemeStyle = ThemeStyle.dark.value();


  //Read color value
  static Color colors(String colorKey,{ThemeStyle? themeStyle,isCommonColor = false}) {

    if(themeStyle == null){
      themeStyle = themeManager.themeStyle;
    }

    Color? color;
    Map<dynamic, dynamic> _themeColors = themeManager.themeColors[themeStyle.index];
    // print("******  _themeColors --> ${_themeColors}");
    Map<String, String> _cache = themeManager.cache;
    //Normal color values should not be read from the cache, or it will get the color of the theme
    if (_cache[colorKey] != null && !isCommonColor){
      return Color(_hexFromString(_cache[colorKey]!));
    }
    bool found = true;
    Map<dynamic, dynamic> _values = _themeColors;
    List<String> _keyParts = colorKey.split('.');
    int _keyPartsLen = _keyParts.length;
    int index = 0;
    int lastIndex = _keyPartsLen - 1;

    while(index < _keyPartsLen && found){
      var value = _values[_keyParts[index]];
      if (value == null) {
        found = false;
        break;
      }
      // print("******  value1 --> ${value}");
      if (value is String && index == lastIndex){
        //If it is a normal color read, it should not be cached, otherwise it will cause the color value under the theme color to be modified
        if(!isCommonColor){
          _cache[colorKey] = value;
        }
        color = Color(_hexFromString(value));
        break;
      }
      _values = value;
      index++;
    }
    assert(color != null, '** $colorKey not found');

    return color!;
  }

  static int _hexToInt(String hex) {
    hex = hex.replaceAll('0x', '');
    int val = 0;
    int len = hex.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = hex.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw new FormatException("Invalid hexadecimal value");
      }
    }
    return val;
  }


  //Read picture
  static String images(String imageName) {
    String assetsName = imageName;
    String assetsPath = '';
    if (imageName.lastIndexOf('/') != -1) {
      assetsName = imageName.substring(imageName.lastIndexOf('/')+1);
      assetsPath = imageName.substring(0, imageName.lastIndexOf('/'));
    }
    String themePrex = themeManager.themeStyle.value();
    if (assetsPath.length > 0) {
      return assetsPath + '/' + themePrex.toLowerCase() + '/' + assetsName;
    }
    return themePrex.toLowerCase()+'/'+assetsName;
  }

  static Brightness brightness() {
    switch (themeManager.themeStyle) {
      case ThemeStyle.dark:
        return Brightness.dark;
      case ThemeStyle.light:
        return Brightness.light;
    }
    return Brightness.light;
  }

  static ThemeStyle getThemeStyleByIndex(int index) {
    if (index >= 0 && index < ThemeStyle.values.length && ThemeStyle.values.length > 0) {
      return ThemeStyle.values[index];
    }
    return ThemeStyle.light;
  }

  static ThemeStyle getThemeStyleByString(String themeStyle) {

    return themeStyle == ThemeStyle.light.value() ? ThemeStyle.light : ThemeStyle.dark;

  }



  static Future<Null> init() async {

    String currentStyle = await OXCacheManager.defaultOXCacheManager.getData(_keyThemeStyle, defaultValue: themeManager.defaultThemeStyle) as String;

    themeManager.themeStyle = getThemeStyleByString(currentStyle);
    try{
      String jsonContentLight = await rootBundle.loadString("assets/theme/theme_light.json");
      themeManager.themeColors[ThemeStyle.light.index] = json.decode(jsonContentLight);
    }catch(e){
      
    }
    try{
      String jsonContentDark = await rootBundle.loadString("assets/theme/theme_dark.json");
      themeManager.themeColors[ThemeStyle.dark.index] = json.decode(jsonContentDark);
    }catch(e){

    }

    themeManager.cache = {};

    return null;
  }

  static void changeTheme(ThemeStyle themeStyle){

    themeManager.themeStyle = themeStyle;

    OXCacheManager.defaultOXCacheManager.saveData(_keyThemeStyle, themeManager.themeStyle.value());

    themeManager.cache = {};
    themeManager.onThemeChangedCallbackList.forEach((fn) {
      fn();
    });

  }

  static Future<void> registerTheme(String moduleName,String assetPath) async{

    String lightPath = "packages/$assetPath/theme/theme_light.json";
    String darkPath = "packages/$assetPath/theme/theme_dark.json";

    try{
      String jsonContent = await rootBundle.loadString(lightPath);
      themeManager.themeColors[ThemeStyle.light.index][moduleName] = json.decode(jsonContent);
    }catch(e){

    }

    try{
      String jsonContent = await rootBundle.loadString(darkPath);
      themeManager.themeColors[ThemeStyle.dark.index][moduleName] = json.decode(jsonContent);
    }catch(e){

    }

  }

  static ThemeStyle getCurrentThemeStyle() {
    return themeManager.themeStyle;
  }

  static addOnThemeChangedCallback(VoidCallback callback) {
    if (!themeManager.onThemeChangedCallbackList.contains(callback)) {
      themeManager.onThemeChangedCallbackList.add(callback);
    }
  }

  static removeOnThemeChangedCallback(VoidCallback callback) {
    themeManager.onThemeChangedCallbackList.remove(callback);
  }

  static final ThemeManager _themeManager = new ThemeManager._internal();

  factory ThemeManager() {
    return _themeManager;
  }

  ThemeManager._internal();

  static int _hexFromString(String hexColor)
  {
    hexColor = hexColor.toUpperCase().replaceAll("#", '');
    hexColor = hexColor.replaceAll('0X', '');
    hexColor = hexColor.replaceAll('0x', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

ThemeManager themeManager = new ThemeManager();