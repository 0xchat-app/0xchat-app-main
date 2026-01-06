import 'dart:async';
import 'package:ox_cache_manager/ox_cache_manager.dart';

enum OXCacheType {
  Simple, //iOS  UserDefault && SharedPreferences
  File //
}

class OXCacheManager {


  String filepath;
  String simplePath;
  late OXSimpleCache _simpleCache;
  late OXFileCache _fileCache;

  OXCacheManager(
      {this.filepath = "ox_super_filecache",
      this.simplePath = "ox_super_simplecache"}) {
    _simpleCache = OXSimpleCache(this.simplePath);
    _fileCache = OXFileCache(this.filepath);
  }

  static OXCacheManager defaultOXCacheManager = new OXCacheManager(
      filepath: "ox_super_filecache", simplePath: "ox_super_simplecache");

  Future<bool> saveData(String key, dynamic data,
      {OXCacheType cacheType = OXCacheType.Simple}) async {
    switch (cacheType) {
      case OXCacheType.Simple:
        return await _simpleCache.saveData(key, data);
        break;
      case OXCacheType.File:
        return await _fileCache.saveData(key, data);
        break;
    }
  }

  Future<bool> saveListData(String key, List<String> datas) async {
    return await _simpleCache.saveListData(key, datas);
  }
  
   Future<List<String>> getListData(String key) async {
    return await _simpleCache.getListData(key);
  }

  Future<bool> saveForeverData(String key, dynamic data,
      {OXCacheType cacheType = OXCacheType.Simple}) async {
    switch (cacheType) {
      case OXCacheType.Simple:
        return await _simpleCache.saveForeverData(key, data);
      case OXCacheType.File:
        return await _fileCache.saveForeverData(key, data);
    }
  }

  Future<dynamic> getForeverData(String key,
      {OXCacheType cacheType = OXCacheType.Simple,
      dynamic defaultValue}) async {
    switch (cacheType) {
      case OXCacheType.Simple:
        return _simpleCache.getForeverData(key, defaultValue: defaultValue);
      case OXCacheType.File:
        return await _fileCache.getForeverData(key, defaultValue: defaultValue);
    }
  }

  Future<dynamic> getData(String key,
      {OXCacheType cacheType = OXCacheType.Simple,
      dynamic defaultValue = ""}) async {
    switch (cacheType) {
      case OXCacheType.Simple:
        return _simpleCache.getData(key, defaultValue: defaultValue);
      case OXCacheType.File:
        return await _fileCache.getData(key, defaultValue: defaultValue);
    }
  }

  Future<bool> removeData(String key,
      {OXCacheType cacheType = OXCacheType.Simple}) async {
    switch (cacheType) {
      case OXCacheType.Simple:
        return _simpleCache.removeData(key);
      case OXCacheType.File:
        return await _fileCache.removeData(key);
    }
  }

  clearData() async {
    //Clear all caches
    await _simpleCache.clearData();
    await _fileCache.clearData();
  }

  Future<double> cacheSize() async {
    double totalSize = await _fileCache.cacheSize();
    return totalSize;
  }
}
