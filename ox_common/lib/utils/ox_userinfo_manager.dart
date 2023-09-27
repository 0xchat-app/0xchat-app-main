import 'dart:convert';

import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/const/common_constant.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_relay_manager.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_module_service/ox_module_service.dart';

abstract class OXUserInfoObserver {
  void didLoginSuccess(UserDB? userInfo);

  void didSwitchUser(UserDB? userInfo);

  void didLogout();

  void didUpdateUserInfo() {}
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

  UserDB? currentUserInfo;

  bool _initAllCompleted = false;

  Future initDB(String pubkey) async {
    DB.sharedInstance.deleteDBIfNeedMirgration = false;
    await DB.sharedInstance.open(pubkey + ".db", version: CommonConstant.dbVersion);
  }

  Future initLocalData() async {
    ///account auto-login
    final String? localPriv = await OXCacheManager.defaultOXCacheManager.getForeverData('PrivKey');
    final String? localPubKey = await OXCacheManager.defaultOXCacheManager.getForeverData('pubKey');
    final String? localDefaultPw = await OXCacheManager.defaultOXCacheManager.getForeverData('defaultPw');
    if (localPriv != null && localPriv.isNotEmpty) {
      OXCacheManager.defaultOXCacheManager.saveForeverData('PrivKey', null);
      OXCacheManager.defaultOXCacheManager.removeData('PrivKey');
      String? privKey = UserDB.decodePrivkey(localPriv);
      if (privKey == null || privKey.isEmpty) {
        LogUtil.e('Oxchat : Auto-login failed, please log in again.');
        return;
      }
      String pubkey = Account.getPublicKey(privKey);
      await initDB(pubkey);
      final UserDB? tempUserDB = await Account.sharedInstance.loginWithPriKey(privKey);
      if (tempUserDB != null) {
        currentUserInfo = Account.sharedInstance.me;
        _initDatas();
        await OXCacheManager.defaultOXCacheManager.saveForeverData('pubKey', tempUserDB.pubKey);
        await OXCacheManager.defaultOXCacheManager.saveForeverData('defaultPw', tempUserDB.defaultPassword);
      }
    } else if (localPubKey != null && localPubKey.isNotEmpty && localDefaultPw != null && localDefaultPw.isNotEmpty) {
      await initDB(localPubKey);
      final UserDB? tempUserDB = await Account.sharedInstance.loginWithPubKeyAndPassword(localPubKey, localDefaultPw);
      if (tempUserDB != null) {
        currentUserInfo = tempUserDB;
        _initDatas();
      }
    } else {
      return;
    }
  }

  void addObserver(OXUserInfoObserver observer) => _observers.add(observer);

  bool removeObserver(OXUserInfoObserver observer) => _observers.remove(observer);

  Future<void> loginSuccess(UserDB userDB) async {
    currentUserInfo = Account.sharedInstance.me;
    OXCacheManager.defaultOXCacheManager.saveForeverData('pubKey', userDB.pubKey);
    OXCacheManager.defaultOXCacheManager.saveForeverData('defaultPw', userDB.defaultPassword);
    LogUtil.e('Michael: data loginSuccess friends =${Contacts.sharedInstance.allContacts.values.toList().toString()}');
    _initDatas();
    for (OXUserInfoObserver observer in _observers) {
      observer.didLoginSuccess(currentUserInfo);
    }
  }

  void addChatCallBack() async {
    Contacts.sharedInstance.secretChatRequestCallBack = (SecretSessionDB ssDB) async {
      LogUtil.e("Michael: init secretChatRequestCallBack ssDB.sessionId =${ssDB.sessionId}");
      OXChatBinding.sharedInstance.secretChatRequestCallBack(ssDB);
    };
    Contacts.sharedInstance.secretChatAcceptCallBack = (SecretSessionDB ssDB) {
      LogUtil.e("Michael: init secretChatAcceptCallBack ssDB.sessionId =${ssDB.sessionId}");
      OXChatBinding.sharedInstance.secretChatAcceptCallBack(ssDB);
    };
    Contacts.sharedInstance.secretChatRejectCallBack = (SecretSessionDB ssDB) {
      LogUtil.e("Michael: init secretChatRejectCallBack ssDB.sessionId =${ssDB.sessionId}");
      OXChatBinding.sharedInstance.secretChatRejectCallBack(ssDB);
    };
    Contacts.sharedInstance.secretChatUpdateCallBack = (SecretSessionDB ssDB) {
      LogUtil.e("Michael: init secretChatUpdateCallBack ssDB.sessionId =${ssDB.sessionId}");
      OXChatBinding.sharedInstance.secretChatUpdateCallBack(ssDB);
    };
    Contacts.sharedInstance.secretChatCloseCallBack = (SecretSessionDB ssDB) {
      LogUtil.e("Michael: init secretChatCloseCallBack");
      OXChatBinding.sharedInstance.secretChatCloseCallBack(ssDB);
    };
    Contacts.sharedInstance.secretChatMessageCallBack = (MessageDB message) {
      LogUtil.e("Michael: init secretChatMessageCallBack message.id =${message.messageId}");
      OXChatBinding.sharedInstance.secretChatMessageCallBack(message);
    };
    Contacts.sharedInstance.privateChatMessageCallBack = (MessageDB message) {
      LogUtil.e("Michael: init privateChatMessageCallBack message.id =${message.messageId}");
      OXChatBinding.sharedInstance.privateChatMessageCallBack(message);
    };
    Contacts.sharedInstance.contactUpdatedCallBack = () {
      LogUtil.e("Michael: init contactUpdatedCallBack");
      OXChatBinding.sharedInstance.contactUpdatedCallBack();
      Iterable<UserDB> tempList =  Contacts.sharedInstance.allContacts.values;
      tempList.forEach ((userDB) {
        OXChatBinding.sharedInstance.changeChatSessionTypeAll(userDB.pubKey, true);
      });

    };
    Channels.sharedInstance.channelMessageCallBack = (MessageDB messageDB) async {
      LogUtil.e('Michael: init  channelMessageCallBack');
      OXChatBinding.sharedInstance.channalMessageCallBack(messageDB);
    };

    Channels.sharedInstance.myChannelsUpdatedCallBack = () async {
      LogUtil.e('Michael: init  myChannelsUpdatedCallBack');
      OXChatBinding.sharedInstance.channelsUpdatedCallBack();
      _initMessage();
    };

    Zaps.sharedInstance.zapRecordsCallBack = (ZapRecordsDB zapRecordsDB) {
      OXChatBinding.sharedInstance.zapRecordsCallBack(zapRecordsDB);
    };
  }

  void updateUserInfo(UserDB userDB) {}

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
    LogUtil.e('Michael: data logout friends =${Contacts.sharedInstance.allContacts.values.toList().toString()}');
    OXCacheManager.defaultOXCacheManager.saveForeverData('pubKey', null);
    OXCacheManager.defaultOXCacheManager.saveForeverData('defaultPw', null);
    currentUserInfo = null;
    _initAllCompleted = false;
    OXChatBinding.sharedInstance.clearSession();
    for (OXUserInfoObserver observer in _observers) {
      observer.didLogout();
    }
  }

  bool isCurrentUser(String userID) {
    return userID == currentUserInfo?.pubKey;
  }

  Future<bool> setNotification() async {
    bool updateNotificatin = false;
    if (!isLogin || !_initAllCompleted) return updateNotificatin;
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

    OKEvent okEvent = await NotificationHelper.sharedInstance.setNotification(deviceId, kinds, OXRelayManager.sharedInstance.relayAddressList);
    updateNotificatin = okEvent.status;

    return updateNotificatin;
  }

  Future<bool> checkDNS() async {
    String pubKey = currentUserInfo?.pubKey ?? '';
    String dnsStr = currentUserInfo?.dns ?? '';
    if(dnsStr.isEmpty || dnsStr == 'null') {
      return false;
    }
    List<String> relayAddressList = OXRelayManager.sharedInstance.relayAddressList;
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
    addChatCallBack();
    initDataActions.forEach((fn) {
      fn();
    });
    Relays.sharedInstance.init().then((value) {
      Contacts.sharedInstance.initContacts(Contacts.sharedInstance.contactUpdatedCallBack);
      Channels.sharedInstance.init(callBack: Channels.sharedInstance.myChannelsUpdatedCallBack);
    });
    Account.sharedInstance.syncRelaysMetadataFromRelay(currentUserInfo!.pubKey!).then((value) {
      //List<String> relays
      OXRelayManager.sharedInstance.addRelaysSuccess(value);
    });
    LogUtil.e('Michael: data await Friends Channels init friends =${Contacts.sharedInstance.allContacts.values.toList().toString()}');
    OXChatBinding.sharedInstance.isZapBadge = await OXCacheManager.defaultOXCacheManager.getData('${currentUserInfo!.pubKey}.zap_badge',defaultValue: false);
  }

  void _initMessage() {
    _initAllCompleted = true;
    Messages.sharedInstance.init();
    NotificationHelper.sharedInstance.init(CommonConstant.serverPubkey);
    setNotification();
    OXModuleService.invoke(
      'ox_calling',
      'initRTC',
      [],
    );
  }
}
