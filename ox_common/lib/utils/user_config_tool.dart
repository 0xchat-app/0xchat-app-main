import 'dart:convert';

import 'package:chatcore/chat-core.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/const/common_constant.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:package_info_plus/package_info_plus.dart';

///Title: user_config_tool
///Description: TODO(about multiple user)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/12/18 19:11
class UserConfigTool{
  static dynamic getSetting(String key, {dynamic defaultValue}) {
    return OXUserInfoManager.sharedInstance.settingsMap[key] ?? defaultValue;
  }

  static Future<void> saveSetting(String key, dynamic value) async {
    OXUserInfoManager.sharedInstance.settingsMap[key] = value;
    Map<String, dynamic> settingsMap = Map.from(OXUserInfoManager.sharedInstance.settingsMap);
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
    if (settings != null && settings.isNotEmpty){
      Map<String, dynamic> loadedSettings = json.decode(settings);
      if (loadedSettings.isNotEmpty) {
        OXUserInfoManager.sharedInstance.settingsMap = loadedSettings;
      }
    }
  }

  static Future<void> compatibleOldSettings(UserDBISAR userDB) async {
    List<StorageSettingKey> settingKeyList = StorageSettingKey.values;
    String? settings = userDB.settings;
    if (settings == null){
      Map<String, dynamic> settingsMap = {};
      await Future.forEach(settingKeyList, (e) async {
        final eValue = await OXCacheManager.defaultOXCacheManager.getForeverData(e.name);
        settingsMap[e.name] = eValue;
      });
      if (settingsMap.isNotEmpty) {
        OXUserInfoManager.sharedInstance.settingsMap = settingsMap;
        defaultNotificationValue();
        UserDBISAR? currentUser = Account.sharedInstance.me;
        if (currentUser != null) {
          String jsonString = json.encode(settingsMap);
          currentUser.settings = jsonString;
          Account.sharedInstance.syncMe();
        }
      }
    }
  }

  static void defaultNotificationValue() async {
    String? jsonString = OXUserInfoManager.sharedInstance.settingsMap[StorageSettingKey.KEY_NOTIFICATION_LIST.name];
    if (jsonString == null || jsonString.isEmpty){
      Map<String, Map<String, dynamic>> notificationMap = {};
      notificationMap[CommonConstant.NOTIFICATION_PUSH_NOTIFICATIONS.toString()] = { 'id': CommonConstant.NOTIFICATION_PUSH_NOTIFICATIONS, 'isSelected': true};
      notificationMap[CommonConstant.NOTIFICATION_PRIVATE_MESSAGES.toString()] = { 'id': CommonConstant.NOTIFICATION_PRIVATE_MESSAGES, 'isSelected': true};
      notificationMap[CommonConstant.NOTIFICATION_CHANNELS.toString()] = { 'id': CommonConstant.NOTIFICATION_CHANNELS, 'isSelected': true};
      notificationMap[CommonConstant.NOTIFICATION_ZAPS.toString()] = { 'id': CommonConstant.NOTIFICATION_ZAPS, 'isSelected': true};
      notificationMap[CommonConstant.NOTIFICATION_SOUND.toString()] = { 'id': CommonConstant.NOTIFICATION_SOUND, 'isSelected': true};
      notificationMap[CommonConstant.NOTIFICATION_VIBRATE.toString()] = { 'id': CommonConstant.NOTIFICATION_VIBRATE, 'isSelected': true};
      notificationMap[CommonConstant.NOTIFICATION_REACTIONS.toString()] = { 'id': CommonConstant.NOTIFICATION_REACTIONS, 'isSelected': true};
      notificationMap[CommonConstant.NOTIFICATION_REPLIES.toString()] = { 'id': CommonConstant.NOTIFICATION_REPLIES, 'isSelected': true};
      notificationMap[CommonConstant.NOTIFICATION_GROUPS.toString()] = { 'id': CommonConstant.NOTIFICATION_GROUPS, 'isSelected': true};
      OXUserInfoManager.sharedInstance.settingsMap[StorageSettingKey.KEY_NOTIFICATION_LIST.name] = json.encode(notificationMap);
    }
  }

  static Future<Map<String, MultipleUserModel>> getAllUser() async {
    String? jsonString = await OXCacheManager.defaultOXCacheManager.getForeverData(StorageKeyTool.KEY_PUBKEY_LIST, defaultValue: '');

    if (jsonString == null || jsonString.isEmpty) {
      return {};
    }

    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    LogUtil.e('Michael:---getAllUser---userMapJson =${jsonMap}');
    return jsonMap.map((key, value) => MapEntry(key, MultipleUserModel.fromJson(value)));
  }

  static Future<void> saveUser(UserDBISAR userDB) async {
    Map<String, MultipleUserModel> currentUserMap = await getAllUser();
    MultipleUserModel? userModel = currentUserMap[userDB.pubKey];
    String tempName = userDB.name ?? '';
    String saveName = tempName.isEmpty ? (userModel == null || userModel.name.isEmpty ? userDB.shortEncodedPubkey : userModel.name) : tempName;
    String tempDns = userDB.dns ?? '';
    String saveDns = tempDns.isEmpty ? (userModel == null || userModel.dns.isEmpty ? '' : userModel.dns) : tempDns;
    String? tempPic = userDB.picture ?? '';
    String savePic = tempPic.isEmpty ? (userModel == null || userModel.picture.isEmpty ? '' : userModel.picture) : tempPic;
    currentUserMap[userDB.pubKey] = MultipleUserModel(
      pubKey: userDB.pubKey,
      name: saveName,
      dns: saveDns,
      picture: savePic,
    );
    String userMapJson = json.encode(currentUserMap);
    LogUtil.e('saveUser: userMapJson =${userMapJson}');
    bool insertResult = await OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.KEY_PUBKEY_LIST, userMapJson);

  }

  static Future<void> deleteUser(Map<String, MultipleUserModel> currentUserMap, String pubkey) async {
    currentUserMap.remove(pubkey);
    String userMapJson = json.encode(currentUserMap);
    bool insertResult = await OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.KEY_PUBKEY_LIST, userMapJson);
  }

  static Future<void> compatibleOld(UserDBISAR userDB) async {
    String? jsonString = await OXCacheManager.defaultOXCacheManager.getForeverData(StorageKeyTool.KEY_PUBKEY_LIST, defaultValue: '');
    if (jsonString == null || jsonString.isEmpty) {
      saveUser(userDB);
      compatibleOldSettings(userDB);
    }
  }

  static migrateSharedPreferencesData() async {
    bool migrationCompleted = await OXCacheManager.defaultOXCacheManager.getForeverData('migration_completed') ?? false;
    if(!migrationCompleted) {
      String? pubKey = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey;
      if (pubKey == null) return;
      OXUserInfoManager.sharedInstance.settingsMap[StorageSettingKey.KEY_IS_SHOW_WALLET_SELECTOR.name] =
      await OXCacheManager.defaultOXCacheManager.getForeverData('$pubKey.isShowWalletSelector', defaultValue: true);

      OXUserInfoManager.sharedInstance.settingsMap[StorageSettingKey.KEY_DEFAULT_WALLET.name] =
      await OXCacheManager.defaultOXCacheManager.getForeverData('$pubKey.defaultWallet');

      OXUserInfoManager.sharedInstance.settingsMap[StorageSettingKey.KEY_DEFAULT_ZAP_AMOUNT.name] =
      await OXCacheManager.defaultOXCacheManager.getForeverData('${pubKey}_defaultZapAmount');

      OXUserInfoManager.sharedInstance.settingsMap[StorageSettingKey.KEY_DEFAULT_ZAP_DESCRIPTION.name] =
      await OXCacheManager.defaultOXCacheManager.getForeverData('${pubKey}_${StorageSettingKey.KEY_DEFAULT_ZAP_DESCRIPTION.name}');

      OXUserInfoManager.sharedInstance.settingsMap[StorageSettingKey.KEY_ICE_SERVER.name] =
      await OXCacheManager.defaultOXCacheManager.getForeverData(StorageSettingKey.KEY_ICE_SERVER.name);

      OXUserInfoManager.sharedInstance.settingsMap[StorageSettingKey.KEY_FILE_STORAGE_SERVER.name] =
      await OXCacheManager.defaultOXCacheManager.getForeverData(StorageSettingKey.KEY_FILE_STORAGE_SERVER.name);

      OXUserInfoManager.sharedInstance.settingsMap[StorageSettingKey.KEY_FILE_STORAGE_SERVER_INDEX.name] =
      await OXCacheManager.defaultOXCacheManager.getForeverData(StorageSettingKey.KEY_FILE_STORAGE_SERVER_INDEX.name);

      await OXCacheManager.defaultOXCacheManager.saveForeverData('migration_completed', true);
    }
  }
}

class MultipleUserModel{
  String pubKey;
  String name;
  String picture;
  String dns;

  MultipleUserModel({this.pubKey = '', this.name = '', this.picture = '', this.dns = ''});

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
