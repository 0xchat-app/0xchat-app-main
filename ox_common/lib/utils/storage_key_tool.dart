///Title: storage_key_tool
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author George
///CreateTime: 2021/4/21 2:02 PM
class StorageKeyTool {
  // static const String KEY_NOTIFICATION_SWITCH = "KEY_NOTIFICATION_SWITCH"; //save message notification value
  // static const String KEY_PUSH_TOKEN = "KEY_PUSH_TOKEN"; //save push token value
  static const String KEY_PUBKEY = "pubKey";
  static const String KEY_PUBKEY_LIST = "KEY_PUBKEY_LIST";
  static const String KEY_IS_LOGIN_AMBER = "KEY_IS_LOGIN_AMBER";

  // static const String KEY_PASSCODE = "KEY_PASSCODE";//verify code
  // static const String KEY_FACEID = "KEY_FACEID";
  // static const String KEY_FINGERPRINT = "KEY_FINGERPRINT";
  // static const String KEY_CHAT_RUN_STATUS = "KEY_CHAT_RUN_STATUS";
  // static const String KEY_CHAT_MSG_DELETE_TIME_TYPE = "KEY_CHAT_MSG_DELETE_TIME_TYPE";
  // static const String KEY_CHAT_MSG_DELETE_TIME = "KEY_CHAT_MSG_DELETE_TIME";
  // static const String KEY_IS_ORIGINAL_PASSPHRASE = "KEY_IS_ORIGINAL_PASSPHRASE";

  // static const String KEY_CHAT_IMPORT_DB = "KEY_CHAT_IMPORT_DB";
  // static const String KEY_IS_CHANGE_DEFAULT_DB_PW = "KEY_IS_CHANGE_DEFAULT_DB_PW";
  // static const String KEY_IS_AGREE_USE_GIPHY = "KEY_IS_AGREE_USE_GIPHY";
  // static const String KEY_DISTRIBUTOR_NAME  = "KEY_DISTRIBUTOR_NAME"; // current Distributor
  // static const String KEY_SAVE_LOG_TIME  = "KEY_SAVE_LOG_TIME";
  // static const String KEY_DEFAULT_ZAP_AMOUNT = 'defaultZapAmount';
  // static const String KEY_OPEN_DEV_LOG = 'KEY_OPEN_DEV_LOG';


  static const String APP_DOMAIN_NAME = "APP_DOMAIN_NAME"; //当前domain


}

enum StorageSettingKey {
  KEY_NOTIFICATION_SWITCH(1000, 'KEY_NOTIFICATION_SWITCH'), //save message notification value
  KEY_PUSH_TOKEN(1001, 'KEY_PUSH_TOKEN'),//save push token value
  KEY_PASSCODE(1002, 'KEY_PASSCODE'),//verify code
  KEY_FACEID(1003, 'KEY_FACEID'),
  KEY_FINGERPRINT(1004, 'KEY_FINGERPRINT'),
  KEY_CHAT_RUN_STATUS(1005, 'KEY_CHAT_RUN_STATUS'),
  KEY_CHAT_MSG_DELETE_TIME_TYPE(1006, 'KEY_CHAT_MSG_DELETE_TIME_TYPE'),
  KEY_CHAT_MSG_DELETE_TIME(1007, 'KEY_CHAT_MSG_DELETE_TIME'),
  KEY_IS_ORIGINAL_PASSPHRASE(1008, 'KEY_IS_ORIGINAL_PASSPHRASE'),
  KEY_CHAT_IMPORT_DB(1009, 'KEY_CHAT_IMPORT_DB'),
  KEY_IS_CHANGE_DEFAULT_DB_PW(1010, 'KEY_IS_CHANGE_DEFAULT_DB_PW'),
  KEY_IS_AGREE_USE_GIPHY(1011, 'KEY_IS_AGREE_USE_GIPHY'),
  KEY_DISTRIBUTOR_NAME(1012, 'KEY_DISTRIBUTOR_NAME'),// current Distributor
  KEY_SAVE_LOG_TIME(1013, 'KEY_SAVE_LOG_TIME'),
  KEY_DEFAULT_ZAP_AMOUNT(1014, 'KEY_DEFAULT_ZAP_AMOUNT'),
  KEY_DEFAULT_ZAP_DESCRIPTION(1015, 'KEY_DEFAULT_ZAP_DESCRIPTION'),
  KEY_ZAP_BADGE(1016, 'KEY_ZAP_BADGE'),
  KEY_OPEN_DEV_LOG(1017, 'KEY_OPEN_DEV_LOG'),
  KEY_LANGUAGE_INDEX(1018, 'KEY_LANGUAGE_INDEX'),
  KEY_THEME_INDEX(1019, 'KEY_THEME_INDEX'),
  KEY_OPEN_P2P(1020, 'KEY_OPEN_P2P');

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
