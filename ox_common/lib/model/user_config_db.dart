import 'dart:convert';
import 'package:chatcore/chat-core.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/storage_key_tool.dart';

///Title: user_config_model
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/12/18 19:11
@reflector
class UserConfigDB extends DBObject {
  String pubKey;

  String notificationSettings; //await OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.KEY_NOTIFICATION_SWITCH, jsonStringList);

  int languageIndex;

  int themeIndex;

  UserConfigDB({
    this.pubKey = '',
    this.notificationSettings = '',
    this.languageIndex = 0,
    this.themeIndex = 0,
  });

  static String? tableName() {
    return "UserConfigDB";
  }

  static List<String?> primaryKey() {
    return ['pubKey'];
  }

  @override
  Map<String, Object?> toMap() {
    return _userConfigToMap(this);
  }

  static UserConfigDB fromMap(Map<String, Object?> map) {
    return _userConfigFromMap(map);
  }
}

extension UserConfigTool on UserConfigDB {
  static Future<void> clearUserConfigFromDB() async {
    await DB.sharedInstance.delete<UserConfigDB>();
  }

  static Future<UserConfigDB?> getUserConfigFromDB() async {
    List<UserConfigDB> userConfigDBList = await DB.sharedInstance.objects<UserConfigDB>();
    UserConfigDB? userConfigDB;
    if (userConfigDBList.isNotEmpty) {
      userConfigDB = userConfigDBList[0];
    } else {
      UserDB? tempDB = OXUserInfoManager.sharedInstance.currentUserInfo;
      if (tempDB != null ){
        userConfigDB = UserConfigDB(pubKey: tempDB.pubKey);
        await UserConfigTool.updateUserConfigDB(userConfigDB);
      }
    }
    return userConfigDB;
  }

  static Future<void> updateUserConfigDB(UserConfigDB configDB) async {
    await DB.sharedInstance.insert<UserConfigDB>(configDB);
  }
}

UserConfigDB _userConfigFromMap(Map<String, dynamic> map) {
  return UserConfigDB(
    pubKey: map['pubKey'].toString(),
    notificationSettings: map['notificationSettings'].toString(),
    languageIndex: map['languageIndex'] ?? 0,
    themeIndex: map['themeIndex'] ?? 0,
  );
}

Map<String, dynamic> _userConfigToMap(UserConfigDB instance) => <String, dynamic>{
      'pubKey': instance.pubKey,
      'notificationSettings': instance.notificationSettings,
      'languageIndex': instance.languageIndex,
      'themeIndex': instance.themeIndex,
    };
