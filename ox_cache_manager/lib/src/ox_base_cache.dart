import 'dart:async';


abstract class OXBaseCache {

    Future<bool> saveData(String key,dynamic data,{int timeOut = 60 * 60 *24 * 7 * 10000}) async {
        throw UnimplementedError('saveData() has not been implemented.');
    }

    Future<bool> saveForeverData(String key, dynamic data) async {
        throw UnimplementedError('saveData() has not been implemented.');
    }

    Future<dynamic> getData(String key, {String defaultValue=""}) async {
        throw UnimplementedError('getData() has not been implemented.');
    }

    Future<dynamic> getForeverData(String key, {dynamic defaultValue}) async {

    }

    Future<bool> removeData(String key) async {
        throw UnimplementedError('removeData() has not been implemented.');
    }

    Future<bool> clearData() async {
        throw UnimplementedError('clearData() has not been implemented.');
    }

    Future<double> cacheSize() async {
        throw UnimplementedError('cacheSize() has not been implemented.');
    }
}