import 'dart:convert';

import 'package:cashu_dart/business/wallet/cashu_manager.dart';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/const/common_constant.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/utils/ox_server_manager.dart';
import 'package:ox_common/utils/user_config_tool.dart';
import 'package:ox_common/utils/app_initialization_manager.dart';
import 'package:ox_common/utils/cashu_helper.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_moment_manager.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

abstract mixin class OXUserInfoObserver {
  void didLoginSuccess(UserDBISAR? userInfo);

  void didSwitchUser(UserDBISAR? userInfo);

  void didLogout();

  void didUpdateUserInfo() {}
}

enum _ContactType {
  contacts,
  channels,
  // groups
  relayGroups,
}

class OXUserInfoManager {

  static final OXUserInfoManager sharedInstance = OXUserInfoManager._internal();

  OXUserInfoManager._internal();

  factory OXUserInfoManager() {
    return sharedInstance;
  }

  final List<OXUserInfoObserver> _observers = <OXUserInfoObserver>[];

  final List<VoidCallback> initDataActions = [];

  bool get isLogin => (currentUserInfo != null);

  UserDBISAR? currentUserInfo;

  Map<String, dynamic> settingsMap = {};

  var _contactFinishFlags = {
    _ContactType.contacts: false,
    _ContactType.channels: false,
    _ContactType.relayGroups: false,
  };

  bool get isFetchContactFinish => _contactFinishFlags.values.every((v) => v);

  bool canVibrate = true;
  bool canSound = true;
  bool signatureVerifyFailed = false;

  Future initDB(String pubkey) async {
    if(pubkey.isEmpty) return;
    await logout();
    await ThreadPoolManager.sharedInstance.initialize();
    AppInitializationManager.shared.shouldShowInitializationLoading = true;
    String dbpath = pubkey + ".db2";
    bool exists = await databaseExists(dbpath);
    if (exists) {
      String? dbpw = await OXCacheManager.defaultOXCacheManager.getForeverData('dbpw+$pubkey');
      await DB.sharedInstance.open(dbpath, version: CommonConstant.dbVersion, password: dbpw);
      await DBISAR.sharedInstance.open(pubkey);
      await DB.sharedInstance.migrateToISAR();
      debugPrint("delete Table");
      await deleteDatabase(dbpath);
    }
    else{
      await DBISAR.sharedInstance.open(pubkey);
    }
    {
      final cashuDBPwd = await CashuHelper.getDBPassword(pubkey);
      await CashuManager.shared.setup(pubkey, dbPassword: cashuDBPwd, defaultMint: []);
    }
  }

  Future initLocalData() async {
    ///account auto-login
    final String? localPubKey = await OXCacheManager.defaultOXCacheManager.getForeverData(StorageKeyTool.KEY_PUBKEY);
    if (localPubKey != null) {
      await UserConfigTool.compatibleOldAmberStatus(localPubKey);
      final bool? localIsLoginAmber = await OXCacheManager.defaultOXCacheManager.getForeverData('${localPubKey}${StorageKeyTool.KEY_IS_LOGIN_AMBER}');
      if (localPubKey.isNotEmpty && localIsLoginAmber != null && localIsLoginAmber) {
        bool isInstalled = await CoreMethodChannel.isInstalledAmber();
        if (isInstalled) {
          String? signature = await ExternalSignerTool.getPubKey();
          if (signature == null) {
            signatureVerifyFailed = true;
            return;
          }
          String decodeSignature = UserDB.decodePubkey(signature) ?? '';
          if (decodeSignature.isNotEmpty) {
            await initDB(localPubKey);
            UserDBISAR? tempUserDB = await Account.sharedInstance.loginWithPubKey(localPubKey);
            if (tempUserDB != null) {
              UserConfigTool.compatibleOld(tempUserDB);
              currentUserInfo = tempUserDB;
              _initDatas();
              _initFeedback();
              return;
            }
          } else {
            signatureVerifyFailed = true;
            return;
          }
        }
      } else if (localPubKey.isNotEmpty) {
        await initDB(localPubKey);
        final UserDBISAR? tempUserDB = await Account.sharedInstance.loginWithPubKeyAndPassword(localPubKey);
        LogUtil.e('initLocalData: userDB =${tempUserDB?.pubKey ?? 'userDB is null'}');
        if (tempUserDB != null) {
          UserConfigTool.compatibleOld(tempUserDB);
          currentUserInfo = tempUserDB;
          _initDatas();
          _initFeedback();
          return;
        }
      }
    }
    AppInitializationManager.shared.shouldShowInitializationLoading = false;
  }

  void addObserver(OXUserInfoObserver observer) => _observers.add(observer);

  bool removeObserver(OXUserInfoObserver observer) => _observers.remove(observer);

  Future<void> loginSuccess(UserDBISAR userDB, {bool isAmber = false}) async {
    currentUserInfo = Account.sharedInstance.me;
    OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.KEY_PUBKEY, userDB.pubKey);
    OXCacheManager.defaultOXCacheManager.saveForeverData('${userDB.pubKey}${StorageKeyTool.KEY_IS_LOGIN_AMBER}', isAmber);
    UserConfigTool.saveUser(userDB);
    UserConfigTool.defaultNotificationValue();
    _initDatas();
    for (OXUserInfoObserver observer in _observers) {
      observer.didLoginSuccess(currentUserInfo);
    }
  }

  void addChatCallBack() async {
    Contacts.sharedInstance.secretChatRequestCallBack = (SecretSessionDBISAR ssDB) async {
      LogUtil.d("Michael: init secretChatRequestCallBack ssDB.sessionId =${ssDB.sessionId}");
      OXChatBinding.sharedInstance.secretChatRequestCallBack(ssDB);
    };
    Contacts.sharedInstance.secretChatAcceptCallBack = (SecretSessionDBISAR ssDB) {
      LogUtil.d("Michael: init secretChatAcceptCallBack ssDB.sessionId =${ssDB.sessionId}");
      OXChatBinding.sharedInstance.secretChatAcceptCallBack(ssDB);
    };
    Contacts.sharedInstance.secretChatRejectCallBack = (SecretSessionDBISAR ssDB) {
      LogUtil.d("Michael: init secretChatRejectCallBack ssDB.sessionId =${ssDB.sessionId}");
      OXChatBinding.sharedInstance.secretChatRejectCallBack(ssDB);
    };
    Contacts.sharedInstance.secretChatUpdateCallBack = (SecretSessionDBISAR ssDB) {
      LogUtil.d("Michael: init secretChatUpdateCallBack ssDB.sessionId =${ssDB.sessionId}");
      OXChatBinding.sharedInstance.secretChatUpdateCallBack(ssDB);
    };
    Contacts.sharedInstance.secretChatCloseCallBack = (SecretSessionDBISAR ssDB) {
      LogUtil.d("Michael: init secretChatCloseCallBack");
      OXChatBinding.sharedInstance.secretChatCloseCallBack(ssDB);
    };
    Contacts.sharedInstance.secretChatMessageCallBack = (MessageDBISAR message) {
      LogUtil.d("Michael: init secretChatMessageCallBack message.id =${message.messageId}");
      OXChatBinding.sharedInstance.secretChatMessageCallBack(message);
    };
    Contacts.sharedInstance.privateChatMessageCallBack = (MessageDBISAR message) {
      LogUtil.d("Michael: init privateChatMessageCallBack message.id =${message.messageId}");
      OXChatBinding.sharedInstance.privateChatMessageCallBack(message);
    };
    Contacts.sharedInstance.privateChatMessageUpdateCallBack = (MessageDBISAR message, String replacedMessageId) {
      LogUtil.d("Michael: init privateChatMessageUpdateCallBack message.id =${message.messageId}");
      OXChatBinding.sharedInstance.privateChatMessageUpdateCallBack(message, replacedMessageId);
    };
    Channels.sharedInstance.channelMessageCallBack = (MessageDBISAR messageDB) async {
      LogUtil.d('Michael: init  channelMessageCallBack');
      OXChatBinding.sharedInstance.channalMessageCallBack(messageDB);
    };
    Groups.sharedInstance.groupMessageCallBack = (MessageDBISAR messageDB) async {
      LogUtil.d('Michael: init  groupMessageCallBack');
      OXChatBinding.sharedInstance.groupMessageCallBack(messageDB);
    };
    Messages.sharedInstance.deleteCallBack = (List<MessageDBISAR> delMessages) {
      OXChatBinding.sharedInstance.messageDeleteCallback(delMessages);
    };
    RelayGroup.sharedInstance.groupMessageCallBack = (MessageDBISAR messageDB) async {
      LogUtil.d('Michael: init  relayGroupMessageCallBack');
      OXChatBinding.sharedInstance.groupMessageCallBack(messageDB);
    };
    RelayGroup.sharedInstance.joinRequestCallBack = (JoinRequestDBISAR joinRequestDB) async {
      LogUtil.d('Michael: init  relayGroupJoinReqCallBack');
      OXChatBinding.sharedInstance.relayGroupJoinReqCallBack(joinRequestDB);
    };
    RelayGroup.sharedInstance.offlineGroupMessageFinishCallBack = () async {
      LogUtil.d('Michael: init  offlineGroupMessageFinishCallBack');
      OXChatBinding.sharedInstance.offlineGroupMessageFinishCallBack();
    };
    Contacts.sharedInstance.contactUpdatedCallBack = () {
      LogUtil.d("Michael: init contactUpdatedCallBack");
      _fetchFinishHandler(_ContactType.contacts);
      OXChatBinding.sharedInstance.contactUpdatedCallBack();
      OXChatBinding.sharedInstance.syncSessionTypesByContact();
    };
    Channels.sharedInstance.myChannelsUpdatedCallBack = () async {
      LogUtil.d('Michael: init myChannelsUpdatedCallBack');
      _fetchFinishHandler(_ContactType.channels);
      OXChatBinding.sharedInstance.channelsUpdatedCallBack();
    };
    Groups.sharedInstance.myGroupsUpdatedCallBack = () async {
      LogUtil.d('Michael: init  myGroupsUpdatedCallBack');
      OXChatBinding.sharedInstance.groupsUpdatedCallBack();
    };
    RelayGroup.sharedInstance.myGroupsUpdatedCallBack = () async {
      LogUtil.d('Michael: init RelayGroup myGroupsUpdatedCallBack');
      _fetchFinishHandler(_ContactType.relayGroups);
      OXChatBinding.sharedInstance.relayGroupsUpdatedCallBack();
    };
    RelayGroup.sharedInstance.moderationCallBack = (ModerationDBISAR moderationDB) async {
      OXChatBinding.sharedInstance.relayGroupsUpdatedCallBack();
    };
    Contacts.sharedInstance.offlinePrivateMessageFinishCallBack = () {
      LogUtil.d('Michael: init  offlinePrivateMessageFinishCallBack');
      OXChatBinding.sharedInstance.offlinePrivateMessageFinishCallBack();
    };
    Contacts.sharedInstance.offlineSecretMessageFinishCallBack = () {
      LogUtil.d('Michael: init  offlineSecretMessageFinishCallBack');
      OXChatBinding.sharedInstance.offlineSecretMessageFinishCallBack();
    };
    Channels.sharedInstance.offlineChannelMessageFinishCallBack = () {
      LogUtil.d('Michael: init  offlineChannelMessageFinishCallBack');
      OXChatBinding.sharedInstance.offlineChannelMessageFinishCallBack();
    };

    Zaps.sharedInstance.zapRecordsCallBack = (ZapRecordsDBISAR zapRecordsDB) {
      OXChatBinding.sharedInstance.zapRecordsCallBack(zapRecordsDB);
    };
    Moment.sharedInstance.newNotesCallBack = (List<NoteDBISAR> notes) {
      OXMomentManager.sharedInstance.newNotesCallBackCallBack(notes);
    };

    Moment.sharedInstance.newNotificationCallBack = (List<NotificationDBISAR> notifications) {
      OXMomentManager.sharedInstance.newNotificationCallBack(notifications);
    };

    Moment.sharedInstance.myZapNotificationCallBack = (List<NotificationDBISAR> notifications) {
      OXMomentManager.sharedInstance.myZapNotificationCallBack(notifications);
    };

    RelayGroup.sharedInstance.noteCallBack = (NoteDBISAR notes) {
      OXMomentManager.sharedInstance.groupsNoteCallBack(notes);
    };

    Messages.sharedInstance.actionsCallBack = (MessageDBISAR message) {
      OXChatBinding.sharedInstance.messageActionsCallBack(message);
    };
  }

  void updateUserInfo(UserDBISAR userDB) {}

  void updateSuccess() {
    for (OXUserInfoObserver observer in _observers) {
      observer.didUpdateUserInfo();
    }
  }

  Future<void> switchAccount(String selectedPubKey) async {
    await logout();
    await OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.KEY_PUBKEY, selectedPubKey);
    await OXUserInfoManager.sharedInstance.initLocalData();
    for (OXUserInfoObserver observer in _observers) {
      observer.didSwitchUser(currentUserInfo);
    }
  }

  Future<UserDBISAR?> handleSwitchFailures(UserDBISAR? userDB, String currentUserPubKey) async {
    if (userDB == null && currentUserPubKey.isNotEmpty) {
      //In the case of failing to add a new account while already logged in, implement the logic to re-login to the current account.
      await OXUserInfoManager.sharedInstance.initDB(currentUserPubKey);
      userDB = await Account.sharedInstance.loginWithPubKeyAndPassword(currentUserPubKey);
    }
    return userDB;
  }

  Future logout() async {
    if (OXUserInfoManager.sharedInstance.currentUserInfo == null) {
      return;
    }
    await Account.sharedInstance.logout();
    resetData();
  }

  Future<void> resetData() async {
    signatureVerifyFailed = false;
    OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.KEY_PUBKEY, null);
    currentUserInfo = null;
    _contactFinishFlags = {
      _ContactType.contacts: false,
      _ContactType.channels: false,
      // _ContactType.groups: false,
      _ContactType.relayGroups: false,
    };
    OXChatBinding.sharedInstance.clearSession();
    AppInitializationManager.shared.reset();
    for (OXUserInfoObserver observer in _observers) {
      observer.didLogout();
    }
  }

  bool isCurrentUser(String userID) {
    return userID == currentUserInfo?.pubKey;
  }

  Future<bool> setNotification() async {
    bool updateNotificatin = false;
    if (!isLogin) return updateNotificatin;
    String deviceId = await OXCacheManager.defaultOXCacheManager.getForeverData(StorageSettingKey.KEY_PUSH_TOKEN.name, defaultValue: '');
    String jsonString = UserConfigTool.getSetting(StorageSettingKey.KEY_NOTIFICATION_LIST.name, defaultValue: '{}');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    ///4、 44 private chat;  1059 secret chat & audio video call; 42  channel message; 9735 zap; 9、10 relay group; 1、6 reply&repost; 7 like
    List<int> kinds = [4, 44, 1059, 42, 9735, 9, 10, 1, 6, 7];
    for (var entry in jsonMap.entries) {
      var value = entry.value;
      if (value is Map<String, dynamic>) {
        if (value['id'] == CommonConstant.NOTIFICATION_PUSH_NOTIFICATIONS && !value['isSelected']){
          kinds = [];
          break;
        }
        if (value['id'] == CommonConstant.NOTIFICATION_PRIVATE_MESSAGES && !value['isSelected']) {
          kinds.remove(4);
          kinds.remove(44);
          kinds.remove(1059);
        }
        if (value['id'] == CommonConstant.NOTIFICATION_CHANNELS && !value['isSelected']) {
          kinds.remove(42);
        }
        if (value['id'] == CommonConstant.NOTIFICATION_ZAPS && !value['isSelected']) {
          kinds.remove(9735);
        }
        if (value['id'] == CommonConstant.NOTIFICATION_REACTIONS && !value['isSelected']) {
          kinds.remove(7);
        }
        if (value['id'] == CommonConstant.NOTIFICATION_REPLIES && !value['isSelected']) {
          kinds.remove(1);
          kinds.remove(6);
        }
        if (value['id'] == CommonConstant.NOTIFICATION_GROUPS && !value['isSelected']) {
          kinds.remove(9);
          kinds.remove(10);
        }
      }
    }
    List<String> relayAddressList = await Account.sharedInstance.getMyGeneralRelayList().map((e) => e.url).toList();
    OKEvent okEvent = await NotificationHelper.sharedInstance.setNotification(deviceId, kinds, relayAddressList);
    updateNotificatin = okEvent.status;

    return updateNotificatin;
  }

  Future<bool> checkDNS({required UserDBISAR userDB}) async {
    String pubKey = userDB.pubKey;
    String dnsStr = userDB.dns ?? '';
    if(dnsStr.isEmpty || dnsStr == 'null') {
      return false;
    }
    List<String> relayAddressList = await Account.sharedInstance.getUserGeneralRelayList(pubKey);
    List<String> temp = dnsStr.split('@');
    String name = temp[0];
    String domain = temp[1];
    DNS dns = DNS(name, domain, pubKey, relayAddressList);
    try {
      return await Account.checkDNS(dns);
    } catch (error, stack) {
      LogUtil.e("check dns error:$error\r\n$stack");
      return false;
    }
  }

  void _initDatas() async {
    UserConfigTool.updateSettingFromDB(currentUserInfo?.settings);
    await OXCacheManager.defaultOXCacheManager.saveForeverData(StorageSettingKey.KEY_CHAT_RUN_STATUS.name, true);
    OXServerManager.sharedInstance.loadConnectICEServer();
    addChatCallBack();
    initDataActions.forEach((fn) {
      fn();
    });
    await UserConfigTool.migrateSharedPreferencesData();
    await EventCache.sharedInstance.loadAllEventsFromDB();
    Relays.sharedInstance.init().then((value) {
      Contacts.sharedInstance.initContacts(Contacts.sharedInstance.contactUpdatedCallBack);
      Channels.sharedInstance.init(callBack: Channels.sharedInstance.myChannelsUpdatedCallBack);
      Groups.sharedInstance.init(callBack: Groups.sharedInstance.myGroupsUpdatedCallBack);
      RelayGroup.sharedInstance.init(callBack: RelayGroup.sharedInstance.myGroupsUpdatedCallBack);
      Moment.sharedInstance.init();
      BadgesHelper.sharedInstance.init();
      Zaps.sharedInstance.init();
      _initMessage();
    });

    LogUtil.e('Michael: data await Friends Channels init friends =${Contacts.sharedInstance.allContacts.values.toList().toString()}');
  }

  void _initMessage() {
    Messages.sharedInstance.init();
    NotificationHelper.sharedInstance.init(CommonConstant.serverPubkey);
    OXModuleService.invoke(
      'ox_calling',
      'initRTC',
      [],
    );
  }

  void _fetchFinishHandler(_ContactType type) {
    if (_contactFinishFlags[type] ?? false) return;
    _contactFinishFlags[type] = true;
    if (isFetchContactFinish) setNotification();
  }

  Future<void> _initFeedback() async {
    canVibrate = await _fetchFeedback(CommonConstant.NOTIFICATION_VIBRATE);
    canSound = await _fetchFeedback(CommonConstant.NOTIFICATION_SOUND);
  }

  Future<bool> _fetchFeedback(int feedback) async {
    String jsonString = UserConfigTool.getSetting(StorageSettingKey.KEY_NOTIFICATION_LIST.name, defaultValue: '');
    if (jsonString.isEmpty) return true;
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    for (var entry in jsonMap.entries) {
      var value = entry.value;
      if (value is Map<String, dynamic>) {
        if(jsonMap['id'] == feedback){
          return jsonMap['isSelected'];
        }
      }
    }
    return true;
  }

  void resetHeartBeat(){//eg: backForeground
    if (isLogin) {
      Connect.sharedInstance.startHeartBeat();
      Account.sharedInstance.startHeartBeat();
      NotificationHelper.sharedInstance.startHeartBeat();
    }
  }
}
