import 'package:path_provider/path_provider.dart';
import 'ox_base_cache.dart';
import 'dart:convert' as convert;
import 'dart:io';

class OXFileCache extends OXBaseCache {
  String oxFilePath = 'ox_super_filecache';
  String foreverPath = "#forever#";

  OXFileCache(this.oxFilePath);

  Future<bool> saveData(String key, dynamic data, {int timeOut = 0}) async {
    String fileFullName = key;
    String contents = convert.jsonEncode(data);
    File file = await _getFile(fileFullName);
    await file.writeAsString(contents).then((vale) {
      return true;
    });
    return false;
  }

  Future<bool> saveForeverData(String key, dynamic data) async {
    String fileFullName = key;
    String contents = convert.jsonEncode(data);
    File file = await _getFile(fileFullName, isForever: true);
    await file.writeAsString(contents).then((vale) {
      return true;
    });
    return false;
  }

  Future<dynamic> getForeverData(String key, {dynamic defaultValue}) async {
    String fileFullName = key;
    File file = await _getFile(fileFullName, isForever: true);
    bool isExists = await file.exists();
    if (!isExists) return defaultValue;
    String data = await file.readAsString();
    dynamic result = convert.jsonDecode(data);
    return result;
  }

  Future<dynamic> getData(String key, {dynamic defaultValue = ""}) async {
    String fileFullName = key;
    File file = await _getFile(fileFullName);
    bool isExists = await file.exists();
    if (!isExists) return defaultValue;
    String data = await file.readAsString();
    dynamic result = convert.jsonDecode(data);
    return result;
  }

  Future<bool> removeData(String key) async {
    String fileFullName = key;
    File file = await _getFile(fileFullName);
    bool isExists = await file.exists();
    if (!isExists) return true;
    await file.delete();
    return true;
  }

  Future<bool> clearData() async {
    final directory = await _getCacheDir();
    directory.delete(recursive: true);
    return true;
  }

  Future<double> cacheSize() async {
    final directory = await _getCacheDir();
    double totalLength = 0;
    await directory.list(recursive: true).forEach((element) {
      if (element is File) {
        var data = element.readAsBytesSync();
        totalLength = totalLength + data.length;
      }
    });
    return totalLength;
  }

  Future<File> _getFile(String fileName, {isForever = false}) async {
    final directory =
        isForever ? await _getCacheDir() : await _getForeverCacheDir();
    final filePath = directory.path;
    return new File(filePath + '/' + fileName);
  }

  Future<Directory> _getCacheDir() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = directory.path + '/{$oxFilePath}';
    Directory dir = new Directory(filePath);
    bool isExists = await dir.exists();
    if (isExists) return dir;
    return await dir.create();
  }

  Future<Directory> _getForeverCacheDir() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = directory.path + '/{$foreverPath}';
    Directory dir = new Directory(filePath);
    bool isExists = await dir.exists();
    if (isExists) return dir;
    return await dir.create();
  }
}
