import 'package:shared_preferences/shared_preferences.dart';
import 'ox_base_cache.dart';
import 'dart:convert' as convert;

class OXSimpleCache extends OXBaseCache {
  String simplePath = "ox_super_simplecache";
  String foreverPath = "#forever#";

  OXSimpleCache(this.simplePath);

  Future<bool> saveData(String key, dynamic data,
      {int timeOut = 60 * 60 * 24 * 7 * 10000}) async {
    final prefs = await SharedPreferences.getInstance();
    if (data == null) {
      prefs.remove(key);
    } else {
        String value = convert.jsonEncode(data);
      int time = DateTime
          .now()
          .millisecondsSinceEpoch;
      time += timeOut; // The default storage is 7 days
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
    if (data == null) {
      prefs.remove(key);
    } else {
      String value = convert.jsonEncode(data);
      prefs.setString('$foreverPath$key', value);
    }
    return true;
  }

  Future<dynamic> getForeverData(String key, {dynamic defaultValue}) async {
    final prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString('$foreverPath$key');
    if (value != null && value.isNotEmpty) {
      return convert.jsonDecode(value);
    }
    return defaultValue;
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
    for (String key in prefs.getKeys()) {
      String? value = prefs.getString(simplePath + '$key');
      if (value == null) {
        return;
      }
      RegExp regExp = new RegExp(r'^#?[0-9]+#?');
      String? timeOutStr = regExp.stringMatch(value);
      //There is a timeout setting
      if (timeOutStr != null && timeOutStr.isNotEmpty) {
        int timeNow = DateTime.now().millisecondsSinceEpoch;
        int timeOut = int.parse(timeOutStr.substring(1, timeOutStr.length - 1));
        if (timeNow > timeOut) {
          prefs.remove(simplePath + '$key');
        }
      }
    }
  }
}
