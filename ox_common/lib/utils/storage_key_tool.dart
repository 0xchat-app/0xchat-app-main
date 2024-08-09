///Title: storage_key_tool
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author George
///CreateTime: 2021/4/21 2:02 PM
class StorageKeyTool {
  static const String KEY_PUBKEY = "pubKey";
  static const String KEY_PUBKEY_LIST = "KEY_PUBKEY_LIST";
  static const String KEY_IS_LOGIN_AMBER = "KEY_IS_LOGIN_AMBER";


  static const String APP_DOMAIN_NAME = "APP_DOMAIN_NAME"; //当前domain


}

enum StorageSettingKey {
  KEY_NOTIFICATION_LIST(1000, 'KEY_NOTIFICATION_LIST'), //save message notification value
  KEY_PUSH_TOKEN(1001, 'KEY_PUSH_TOKEN'),//save push token value
  KEY_PASSCODE(1002, 'KEY_PASSCODE'),//verify code
  KEY_FACEID(1003, 'KEY_FACEID'),
  KEY_FINGERPRINT(1004, 'KEY_FINGERPRINT'),
  KEY_CHAT_RUN_STATUS(1005, 'KEY_CHAT_RUN_STATUS'),
  KEY_CHAT_MSG_DELETE_TIME_TYPE(1006, 'KEY_CHAT_MSG_DELETE_TIME_TYPE'),
  KEY_CHAT_MSG_DELETE_TIME(1007, 'KEY_CHAT_MSG_DELETE_TIME'),
  KEY_CHAT_IMPORT_DB(1008, 'KEY_CHAT_IMPORT_DB'),
  KEY_IS_AGREE_USE_GIPHY(1009, 'KEY_IS_AGREE_USE_GIPHY'),
  KEY_DISTRIBUTOR_NAME(1010, 'KEY_DISTRIBUTOR_NAME'),// current Distributor
  KEY_SAVE_LOG_TIME(1011, 'KEY_SAVE_LOG_TIME'),
  KEY_DEFAULT_ZAP_AMOUNT(1012, 'KEY_DEFAULT_ZAP_AMOUNT'),
  KEY_DEFAULT_ZAP_DESCRIPTION(1013, 'KEY_DEFAULT_ZAP_DESCRIPTION'),
  KEY_ZAP_BADGE(1014, 'KEY_ZAP_BADGE'),
  KEY_OPEN_DEV_LOG(1015, 'KEY_OPEN_DEV_LOG'),
  KEY_THEME_INDEX(1016, 'KEY_THEME_INDEX'),
  KEY_OPEN_P2P(1017, 'KEY_OPEN_P2P');

  final int keyIndex;
  final String name;
  const StorageSettingKey(this.keyIndex, this.name);

  static StorageSettingKey fromString(String name) {
    return StorageSettingKey.values.firstWhere((element) => element.name == name,
        orElse: () => throw ArgumentError('Invalid permission name: $name'));
  }

  static StorageSettingKey fromKeyIndex(int keyIndex) {
    return StorageSettingKey.values.firstWhere((element) => element.keyIndex == keyIndex,
        orElse: () => throw ArgumentError('Invalid permission name: $keyIndex'));
  }

}
