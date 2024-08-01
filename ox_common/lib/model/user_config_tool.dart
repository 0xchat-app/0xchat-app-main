import 'dart:convert';

import 'package:chatcore/chat-core.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/storage_key_tool.dart';

///Title: user_config_tool
///Description: TODO(about multiple user)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/12/18 19:11
class UserConfigTool{

  static Future<void> saveSettingToDB() async {
    List<StorageSettingKey> settingKeyList = StorageSettingKey.values;
    Map<String, dynamic> settingsMap = {};
    await Future.forEach(settingKeyList, (e) async {
      final eValue = await OXCacheManager.defaultOXCacheManager.getForeverData(e.name);
      settingsMap[e.name] = eValue;
    });
    if (settingsMap.isNotEmpty) {
      UserDBISAR? currentUser = Account.sharedInstance.me;
      if (currentUser != null) {
        String jsonString = json.encode(settingsMap);
        currentUser.settings = jsonString;
        Account.sharedInstance.syncMe();
      }
    }
  }

  static Future<void> updateSettingFromDB(String? settings) async {
    LogUtil.e('Michael:---settings---updateSettingFromDB--settins =${settings}');
    if (settings == null) return;
    List<StorageSettingKey> settingKeyList = StorageSettingKey.values;
    UserDBISAR? currentUser = OXUserInfoManager.sharedInstance.currentUserInfo;
    if (currentUser != null){
      String? settings = currentUser.settings;
      if (settings != null && settings.isNotEmpty){
        Map<String, dynamic> loadedSettings = json.decode(settings);
        LogUtil.e('Michael:---settings---updateSettingFromDB--loadedSettings =${loadedSettings}');
        await Future.forEach(settingKeyList, (e) async {
          await OXCacheManager.defaultOXCacheManager.saveForeverData(e.name, loadedSettings[e.name]);
        });
      }
    }
  }

  static Future<Map<String, MultipleUserModel>> getAllUser() async {
    String? jsonString = await OXCacheManager.defaultOXCacheManager.getData(StorageKeyTool.KEY_PUBKEY_LIST, defaultValue: '');

    if (jsonString == null || jsonString.isEmpty) {
      return {};
    }

    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    LogUtil.e('Michael:---getAllUser---userMapJson =${jsonMap}');
    return jsonMap.map((key, value) => MapEntry(key, MultipleUserModel.fromJson(value)));
  }

  static Future<void> saveUser(UserDBISAR userDB) async {
    LogUtil.e('Michael:---saveUser--userDB =${userDB.toString()}');
    LogUtil.e('Michael:---saveUser------${StackTrace.current}');
    Map<String, MultipleUserModel> currentUserMap = await getAllUser();
    currentUserMap[userDB.pubKey] = MultipleUserModel(
      pubKey: userDB.pubKey,
      name: userDB.name,
      dns: userDB.dns,
      picture: userDB.picture,
    );
    String userMapJson = json.encode(currentUserMap);
    bool insertResult = await OXCacheManager.defaultOXCacheManager.saveData(StorageKeyTool.KEY_PUBKEY_LIST, userMapJson);

  }

  static Future<void> deleteUser(Map<String, MultipleUserModel> currentUserMap, String pubkey) async {
    currentUserMap.remove(pubkey);
    String userMapJson = json.encode(currentUserMap);
    LogUtil.e('Michael:---saveUser--userMapJson =${userMapJson}');
    bool insertResult = await OXCacheManager.defaultOXCacheManager.saveData(StorageKeyTool.KEY_PUBKEY_LIST, userMapJson);
    LogUtil.e('Michael:---saveUser--insertResult =${insertResult}');
  }
}

class MultipleUserModel{
  String? pubKey;
  String? name;
  String? picture;
  String? dns;

  MultipleUserModel({this.pubKey, this.name, this.picture, this.dns});

  factory MultipleUserModel.fromJson(Map<String, dynamic> json) {
    return MultipleUserModel(
      pubKey: json['pubKey'],
      name: json['name'] ?? '',
      picture: json['picture'] ?? '',
      dns: json['dns'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pubKey': pubKey,
      'name': name,
      'picture': picture,
      'dns': dns,
    };
  }
}
