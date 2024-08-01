import 'dart:convert';

import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/const/common_constant.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/model/user_config_db.dart';
import 'package:ox_common/utils/app_initialization_manager.dart';
import 'package:ox_common/utils/cashu_helper.dart';
import 'package:ox_common/utils/ox_moment_manager.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:cashu_dart/business/wallet/cashu_manager.dart';

abstract mixin class OXUserInfoObserver {
  void didLoginSuccess(UserDBISAR? userInfo);

  void didSwitchUser(UserDBISAR? userInfo);

  void didLogout();

  void didUpdateUserInfo() {}
}

enum _ContactType {
  contacts,
  channels,
  groups,
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

  var _contactFinishFlags = {
    _ContactType.contacts: false,
    _ContactType.channels: false,
    _ContactType.groups: false,
    _ContactType.relayGroups: false,
  };

  bool get isFetchContactFinish => _contactFinishFlags.values.every((v) => v);

  bool canVibrate = true;
  bool canSound = true;
  int defaultZapAmount = 0;
  bool signatureVerifyFailed = false;

  Future initDB(String pubkey) async {
    await ThreadPoolManager.sharedInstance.initialize();
    AppInitializationManager.shared.shouldShowInitializationLoading = true;
    DB.sharedInstance.deleteDBIfNeedMirgration = false;
    String? dbpw = await OXCacheManager.defaultOXCacheManager.getForeverData('dbpw+$pubkey');
    if(dbpw == null || dbpw.isEmpty){
      dbpw = generateStrongPassword(16);
      await DB.sharedInstance.open(pubkey + ".db", version: CommonConstant.dbVersion, pubkey: pubkey);
      await DB.sharedInstance.cipherMigrate(pubkey + ".db2", CommonConstant.dbVersion, dbpw);
      await OXCacheManager.defaultOXCacheManager.saveForeverData('dbpw+$pubkey', dbpw);
    }
    else{
      LogUtil.d('[DB init] dbpw: $dbpw');
      await DB.sharedInstance.open(pubkey + ".db2", version: CommonConstant.dbVersion, password: dbpw, pubkey: pubkey);
    }

    {
      final cashuDBPwd = await CashuHelper.getDBPassword(pubkey);
      await CashuManager.shared.setup(pubkey, dbPassword: cashuDBPwd, defaultMint: []);
    }
  }

  Future initLocalData() async {
    ///account auto-login
    final String? localPriv = await OXCacheManager.defaultOXCacheManager.getForeverData('PrivKey');
    final String? localPubKey = await OXCacheManager.defaultOXCacheManager.getForeverData(StorageKeyTool.KEY_PUBKEY);
    final bool? localIsLoginAmber = await OXCacheManager.defaultOXCacheManager.getForeverData(StorageKeyTool.KEY_IS_LOGIN_AMBER);
    if (localPriv != null && localPriv.isNotEmpty) {
      OXCacheManager.defaultOXCacheManager.saveForeverData('PrivKey', null);
      OXCacheManager.defaultOXCacheManager.removeData('PrivKey');
      String? privKey = UserDBISAR.decodePrivkey(localPriv);
      if (privKey == null || privKey.isEmpty) {
        LogUtil.e('Oxchat : Auto-login failed, please log in again.');
        return;
      }
      String pubkey = Account.getPublicKey(privKey);
      await initDB(pubkey);
      final UserDBISAR? tempUserDB = await Account.sharedInstance.loginWithPriKey(privKey);
      if (tempUserDB != null) {
        currentUserInfo = Account.sharedInstance.me;
        _initDatas();
        await OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.KEY_PUBKEY, tempUserDB.pubKey);
      }
    } else if (localPubKey != null && localPubKey.isNotEmpty && localIsLoginAmber != null && localIsLoginAmber) {
      bool isInstalled = await CoreMethodChannel.isAppInstalled('com.greenart7c3.nostrsigner');
      if (isInstalled) {
        String? signature = await ExternalSignerTool.getPubKey();
        if (signature == null) {
          signatureVerifyFailed = true;
          return;
        }
        String decodeSignature = UserDBISAR.decodePubkey(signature) ?? '';
        if (decodeSignature == localPubKey) {
          await initDB(localPubKey);
          UserDBISAR? tempUserDB = await Account.sharedInstance.loginWithPubKey(localPubKey);
          if (tempUserDB != null) {
            currentUserInfo = tempUserDB;
            _initDatas();
            _initFeedback();
          }
        } else {
          signatureVerifyFailed = true;
        }
      }
    } else if (localPubKey != null && localPubKey.isNotEmpty) {
      await initDB(localPubKey);
      final UserDBISAR? tempUserDB = await Account.sharedInstance.loginWithPubKeyAndPassword(localPubKey);
      LogUtil.e('Michael: initLocalData tempUserDB =${tempUserDB?.pubKey ?? 'tempUserDB == null'}');
      if (tempUserDB != null) {
        currentUserInfo = tempUserDB;
        _initDatas();
        _initFeedback();
      }
    } else {
      AppInitializationManager.shared.shouldShowInitializationLoading = false;
      return;
    }
  }

  void addObserver(OXUserInfoObserver observer) => _observers.add(observer);

  bool removeObserver(OXUserInfoObserver observer) => _observers.remove(observer);

  Future<void> loginSuccess(UserDBISAR userDB) async {
    currentUserInfo = Account.sharedInstance.me;
    OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.KEY_PUBKEY, userDB.pubKey);
    UserConfigTool.updateUserConfigDB(UserConfigDB(pubKey: userDB.pubKey));
    _initDatas();
    for (OXUserInfoObserver observer in _observers) {
      observer.didLoginSuccess(currentUserInfo);
    }
  }

  void addChatCallBack() async {
    Contacts.sharedInstance.secretChatRequestCallBack = (SecretSessionDB ssDB) async {
      LogUtil.d("Michael: init secretChatRequestCallBack ssDB.sessionId =${ssDB.sessionId}");
      OXChatBinding.sharedInstance.secretChatRequestCallBack(ssDB);
    };
    Contacts.sharedInstance.secretChatAcceptCallBack = (SecretSessionDB ssDB) {
      LogUtil.d("Michael: init secretChatAcceptCallBack ssDB.sessionId =${ssDB.sessionId}");
      OXChatBinding.sharedInstance.secretChatAcceptCallBack(ssDB);
    };
    Contacts.sharedInstance.secretChatRejectCallBack = (SecretSessionDB ssDB) {
      LogUtil.d("Michael: init secretChatRejectCallBack ssDB.sessionId =${ssDB.sessionId}");
      OXChatBinding.sharedInstance.secretChatRejectCallBack(ssDB);
    };
    Contacts.sharedInstance.secretChatUpdateCallBack = (SecretSessionDB ssDB) {
      LogUtil.d("Michael: init secretChatUpdateCallBack ssDB.sessionId =${ssDB.sessionId}");
      OXChatBinding.sharedInstance.secretChatUpdateCallBack(ssDB);
    };
    Contacts.sharedInstance.secretChatCloseCallBack = (SecretSessionDB ssDB) {
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
    Channels.sharedInstance.channelMessageCallBack = (MessageDBISAR messageDB) async {
      LogUtil.d('Michael: init  channelMessageCallBack');
      OXChatBinding.sharedInstance.channalMessageCallBack(messageDB);
    };
    Groups.sharedInstance.groupMessageCallBack = (MessageDBISAR messageDB) async {
      LogUtil.d('Michael: init  groupMessageCallBack');
      OXChatBinding.sharedInstance.groupMessageCallBack(messageDB);
    };
    RelayGroup.sharedInstance.groupMessageCallBack = (MessageDBISAR messageDB) async {
      LogUtil.d('Michael: init  relayGroupMessageCallBack');
      OXChatBinding.sharedInstance.groupMessageCallBack(messageDB);
    };
    RelayGroup.sharedInstance.joinRequestCallBack = (JoinRequestDB joinRequestDB) async {
      LogUtil.d('Michael: init  relayGroupJoinReqCallBack');
      OXChatBinding.sharedInstance.relayGroupJoinReqCallBack(joinRequestDB);
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
      _fetchFinishHandler(_ContactType.groups);
      OXChatBinding.sharedInstance.groupsUpdatedCallBack();
    };
    RelayGroup.sharedInstance.myGroupsUpdatedCallBack = () async {
      LogUtil.d('Michael: init RelayGroup myGroupsUpdatedCallBack');
      _fetchFinishHandler(_ContactType.relayGroups);
      OXChatBinding.sharedInstance.relayGroupsUpdatedCallBack();
    };
    RelayGroup.sharedInstance.moderationCallBack = (ModerationDB moderationDB) async {
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
    Moment.sharedInstance.newNotesCallBack = (List<NoteDB> notes) {
      OXMomentManager.sharedInstance.newNotesCallBackCallBack(notes);
    };

    Moment.sharedInstance.newNotificationCallBack = (List<NotificationDB> notifications) {
      OXMomentManager.sharedInstance.newNotificationCallBack(notifications);
    };

    Moment.sharedInstance.myZapNotificationCallBack = (List<NotificationDB> notifications) {
      OXMomentManager.sharedInstance.myZapNotificationCallBack(notifications);
    };

    RelayGroup.sharedInstance.noteCallBack = (NoteDB notes) {
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

  Future logout() async {
    if (OXUserInfoManager.sharedInstance.currentUserInfo == null) {
      return;
    }
    Account.sharedInstance.logout();
    UserConfigTool.clearUserConfigFromDB();
    resetData();
  }

  void resetData() async {
    signatureVerifyFailed = false;
    OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.KEY_PUBKEY, null);
    OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.KEY_IS_LOGIN_AMBER, false);
    OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.KEY_PASSCODE, '');
    OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.KEY_OPEN_DEV_LOG, false);
    currentUserInfo = null;
    _contactFinishFlags = {
      _ContactType.contacts: false,
      _ContactType.channels: false,
      _ContactType.groups: false,
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
    String deviceId = await OXCacheManager.defaultOXCacheManager.getForeverData(StorageKeyTool.KEY_PUSH_TOKEN, defaultValue: '');
    List<dynamic> dynamicList = await OXCacheManager.defaultOXCacheManager.getForeverData(StorageKeyTool.KEY_NOTIFICATION_SWITCH, defaultValue: []);
    List<String> jsonStringList = dynamicList.cast<String>();

    ///4, 44 private chat,  1059 secret chat & audio video call, 42  channel message, 9735
    List<int> kinds = [4, 44, 1059, 42, 9735];
    for (String jsonString in jsonStringList) {
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      if (jsonMap['id'] == 0 && !jsonMap['isSelected']) {
        kinds = [];
        break;
      }
      if (jsonMap['id'] == 1 && !jsonMap['isSelected']) {
        kinds.remove(4);
        kinds.remove(44);
        kinds.remove(1059);
      }
      if (jsonMap['id'] == 2 && !jsonMap['isSelected']) {
        kinds.remove(42);
      }
      if (jsonMap['id'] == 3 && !jsonMap['isSelected']) {
        kinds.remove(9735);
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
    await OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.KEY_CHAT_RUN_STATUS, true);
    addChatCallBack();
    initDataActions.forEach((fn) {
      fn();
    });
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
    OXChatBinding.sharedInstance.isZapBadge = await OXCacheManager.defaultOXCacheManager.getData('${currentUserInfo!.pubKey}.zap_badge',defaultValue: false);
    defaultZapAmount = await OXCacheManager.defaultOXCacheManager.getForeverData('${currentUserInfo!.pubKey}_${StorageKeyTool.KEY_DEFAULT_ZAP_AMOUNT}',defaultValue: 21);
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
    _contactFinishFlags[type] = true;
    setNotification();
  }

  Future<void> _initFeedback() async {
    canVibrate = await _fetchFeedback(CommonConstant.NOTIFICATION_VIBRATE);
    canSound = await _fetchFeedback(CommonConstant.NOTIFICATION_SOUND);
  }

  Future<bool> _fetchFeedback(int feedback) async {
    List<dynamic> dynamicList = await OXCacheManager.defaultOXCacheManager.getForeverData(StorageKeyTool.KEY_NOTIFICATION_SWITCH, defaultValue: []);
    if (dynamicList.isNotEmpty) {
      List<String> jsonStringList = dynamicList.cast<String>();
      for (var jsonString in jsonStringList) {
        Map<String, dynamic> jsonMap = json.decode(jsonString);
        if(jsonMap['id'] == feedback){
          return jsonMap['isSelected'];
        }
      }
    }
    return true;
  }

  void resetHeartBeat(){//eg: backForeground
    if (isLogin) {
      DB.sharedInstance.startHeartBeat();
      Connect.sharedInstance.startHeartBeat();
      Account.sharedInstance.startHeartBeat();
      NotificationHelper.sharedInstance.startHeartBeat();
    }
  }
}
