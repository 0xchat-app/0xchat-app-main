import 'package:shared_preferences/shared_preferences.dart';
import 'ox_base_cache.dart';
import 'dart:convert' as convert;

class OXSimpleCache extends OXBaseCache {
  String simplePath = "ox_super_simplecache";
  String foreverPath = "#forever#";

  // 7-day default TTL in milliseconds
  static const int _defaultTimeOutMs = 60 * 60 * 24 * 7 * 1000;
  // Hard maximum: 90 days in milliseconds
  static const int _maxTimeOutMs = 60 * 60 * 24 * 90 * 1000;

  OXSimpleCache(this.simplePath);

  Future<bool> saveData(String key, dynamic data,
      {int timeOut = _defaultTimeOutMs}) async {
    final prefs = await SharedPreferences.getInstance();
    // Clamp to 90-day maximum to prevent unbounded cache growth
    final cappedTimeOut = timeOut.clamp(0, _maxTimeOutMs);
    int time = DateTime
        .now()
        .millisecondsSinceEpoch;
    time += cappedTimeOut; // The default storage is 7 days, max 90 days
    if (data == null) {
      prefs.setString(simplePath + '$key', '#$time#');
    } else {
        String value = convert.jsonEncode(data);
      prefs.setString(simplePath + '$key', '#$time#$value');
    }
    return true;
  }

  Future<bool> saveListData(String key, List<String> datas) async {
    final prefs = await SharedPreferences.getInstance();
    if (datas.isNotEmpty) {
      prefs.setStringList(simplePath + '$key', datas);
    }
    return true;
  }

  Future<List<String>> getListData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? values = prefs.getStringList(simplePath + '$key');
    return values??[];
  }

  Future<bool> saveForeverData(String key, dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    // Cap "forever" data at 90 days to prevent unbounded SharedPreferences growth
    final int expires = DateTime.now().millisecondsSinceEpoch + _maxTimeOutMs;
    if (data == null) {
      prefs.setString('$foreverPath$key', '#$expires#');
    } else {
      String value = convert.jsonEncode(data);
      prefs.setString('$foreverPath$key', '#$expires#$value');
    }
    return true;
  }

  Future<dynamic> getForeverData(String key, {dynamic defaultValue}) async {
    final prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString('$foreverPath$key');
    if (value == null || value.isEmpty) return defaultValue;
    // New format: #expiry_ms#json  (written by saveForeverData since v2)
    if (value.startsWith('#')) {
      final RegExp regExp = RegExp(r'^#[0-9]+#');
      final String? timeOutStr = regExp.stringMatch(value);
      if (timeOutStr != null) {
        final int timeNow = DateTime.now().millisecondsSinceEpoch;
        final int expiry = int.parse(timeOutStr.substring(1, timeOutStr.length - 1));
        if (timeNow > expiry) {
          prefs.remove('$foreverPath$key');
          return defaultValue;
        }
        final String content = value.substring(timeOutStr.length);
        return content.isEmpty ? null : convert.jsonDecode(content);
      }
    }
    // Legacy format: plain JSON without TTL — return as-is for backward compatibility
    return convert.jsonDecode(value);
  }

  Future<dynamic> getData(String key, {dynamic defaultValue = ""}) async {
    final prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(simplePath + '$key');
    if (value != null && value.isNotEmpty) {
      RegExp regExp = new RegExp(r'^#?[0-9]+#?');
      String? timeOutStr = regExp.stringMatch(value);
      if (timeOutStr != null && timeOutStr.isNotEmpty) {
        int timeNow = DateTime.now().millisecondsSinceEpoch;
        int timeOut = int.parse(timeOutStr.substring(1, timeOutStr.length - 1));
        if (timeNow > timeOut) {
          prefs.remove(simplePath + '$key');
          return defaultValue;
        } else {
          return convert.jsonDecode(value.substring(timeOutStr.length));
        }
      }
    }
    return defaultValue;
  }

  Future<bool> removeData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(simplePath + '$key');
  }

  Future<bool> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    List<Future<bool>> clearList = [];
    for (String key in prefs.getKeys()) {
      if (key.startsWith(simplePath)) {
        clearList.add(prefs.remove(key));
      }
    }
    bool result = true;
    await Future.wait(clearList).then((value) => {
          value.forEach((element) {
            result &= element;
          })
        });
    return result;
  }

  Future<double> cacheSize() async {
    return 0;
  }

  Future removeTimeOutCache() async {
    final prefs = await SharedPreferences.getInstance();
    final RegExp regExp = RegExp(r'^#[0-9]+#');
    final int timeNow = DateTime.now().millisecondsSinceEpoch;
    for (String key in List.of(prefs.getKeys())) {
      final bool isSimple = key.startsWith(simplePath);
      final bool isForever = key.startsWith(foreverPath);
      if (!isSimple && !isForever) continue;
      String? value = prefs.getString(key);
      if (value == null) continue;
      // Check for TTL prefix (#expiry_ms#)
      final String? timeOutStr = regExp.stringMatch(value);
      if (timeOutStr != null && timeOutStr.isNotEmpty) {
        final int expiry = int.parse(timeOutStr.substring(1, timeOutStr.length - 1));
        if (timeNow > expiry) {
          prefs.remove(key);
        }
      }
    }
  }
}
