import 'dart:convert';

import 'package:chatcore/chat-core.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/const/common_constant.dart';
import 'package:ox_common/model/relay_model.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';

abstract mixin class OXRelayObserver {
  void didAddRelay(RelayModel? relayModel) {}

  void didDeleteRelay(RelayModel? relayModel) {}

  void didRelayStatusChange(String relay, int status) {}
}

class OXRelayManager {
  static final OXRelayManager sharedInstance = OXRelayManager._internal();

  Map<String, RelayModel> relayMap = {};
  int connectedCount = 0;

  OXRelayManager._internal();

  factory OXRelayManager() {
    return sharedInstance;
  }

  final List<OXRelayObserver> _observers = <OXRelayObserver>[];

  void addObserver(OXRelayObserver observer) => _observers.add(observer);

  bool removeObserver(OXRelayObserver observer) => _observers.remove(observer);

  List<String> get relayAddressList => relayMap.keys.toList();
  List<RelayModel> get relayModelList => relayMap.values.toList();

  void loadConnectRelay() async {
    List<RelayModel> list = await getRelayList();
    relayMap = {};
    var defaultRelays = await OXCacheManager.defaultOXCacheManager.getForeverData(StorageKeyTool.KEY_RELAY, defaultValue: null);
    if (list.length > 0) {
      for (RelayModel model in list) {
        relayMap[model.relayName] = model;
      }
      if (relayMap[CommonConstant.oxChatRelay] != null && relayMap[CommonConstant.oxChatRelay]!.canDelete == false){
        relayMap[CommonConstant.oxChatRelay]!.canDelete = true;
      }
      Connect.sharedInstance.connectRelays(relayAddressList);
    } else if(defaultRelays == null){
      RelayModel defaultModel1 = RelayModel(
        relayName: CommonConstant.oxChatRelay,
        canDelete: true,
        connectStatus: 0,
        isSelected: true,
        createTime: DateTime.now().millisecondsSinceEpoch,
      );
      String defaultRelayName2 = 'wss://relay.damus.io';
      String defaultRelayName3 = 'wss://relay.nostr.band';
      RelayModel defaultModel2 = RelayModel(
        relayName: defaultRelayName2,
        canDelete: true,
        connectStatus: 0,
        isSelected: true,
        createTime: DateTime.now().millisecondsSinceEpoch,
      );
      RelayModel defaultModel3 = RelayModel(
        relayName: defaultRelayName3,
        canDelete: true,
        connectStatus: 0,
        isSelected: true,
        createTime: DateTime.now().millisecondsSinceEpoch,
      );
      relayMap[CommonConstant.oxChatRelay] = defaultModel1;
      relayMap[defaultRelayName2] = defaultModel2;
      relayMap[defaultRelayName3] = defaultModel3;
      Connect.sharedInstance.connectRelays([CommonConstant.oxChatRelay, defaultRelayName2, defaultRelayName3]);
      await saveRelayList(relayModelList);
    }
    connectedCount = relayAddressList.where((item) => Connect.sharedInstance.webSockets[item]?.connectStatus != null && Connect.sharedInstance.webSockets[item]?.connectStatus == RelayConnectStatus.open ).length;
    connectStatusUpdate();
  }

  void connectStatusUpdate() async {
    Connect.sharedInstance.connectStatusCallBack = (String relay, int status) {
      changeRelayStatus(relay, status);
    };
  }

  void changeRelayStatus(String relay, int status) {
    connectedCount = relayAddressList.where((item) => Connect.sharedInstance.webSockets[item]?.connectStatus != null && Connect.sharedInstance.webSockets[item]?.connectStatus == RelayConnectStatus.open ).length;
    for (OXRelayObserver observer in _observers) {
      observer.didRelayStatusChange(relay, status);
    }
  }

  Future<void> addRelaySuccess(RelayModel relayModel) async {
    relayMap[relayModel.relayName] = relayModel;
    await saveRelayList(relayModelList);
    Connect.sharedInstance.connect(relayModel.relayName);
    if (OXUserInfoManager.sharedInstance.currentUserInfo != null) {
      Account.sharedInstance.updateRelaysMetadata(relayAddressList);
    }
    for (OXRelayObserver observer in _observers) {
      observer.didAddRelay(relayModel);
    }
  }

  Future<void> addRelaysSuccess(List<String> relays) async {
    if(relays.isNotEmpty) relayMap.clear();
    for (String relay in relays) {
      relay = relay.replaceFirst(RegExp(r'/+$'), '');
      RelayModel relayModel = RelayModel(
        relayName: relay,
        canDelete: true,
        connectStatus: 0,
        createTime: DateTime.now().millisecondsSinceEpoch,
      );
      relayMap[relay] = relayModel;
      for (OXRelayObserver observer in _observers) {
        observer.didAddRelay(relayModel);
      }
    }
    await saveRelayList(relayModelList);
    Connect.sharedInstance.connectRelays(relays);
  }

  Future<void> deleteRelay(RelayModel relayModel) async {
    relayMap.remove(relayModel.relayName);
    await saveRelayList(relayModelList);
    await Connect.sharedInstance.closeConnect(relayModel.relayName);
    if (OXUserInfoManager.sharedInstance.currentUserInfo != null) {
      Account.sharedInstance.updateRelaysMetadata(relayAddressList);
    }
    for (OXRelayObserver observer in _observers) {
      observer.didDeleteRelay(relayModel);
    }
  }

  Future<void> saveRelayList(List<RelayModel> objectList) async {
    List<String> jsonStringList = objectList.map((obj) => json.encode(relayModelToMap(obj))).toList();
    await OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.KEY_RELAY, jsonStringList);
  }

  Future<List<RelayModel>> getRelayList() async {
    Set<String> uniqueSet = Set<String>();
    List<dynamic> dynamicList = await OXCacheManager.defaultOXCacheManager.getForeverData(StorageKeyTool.KEY_RELAY, defaultValue: []);
    List<String> jsonStringList = dynamicList.cast<String>();
    List<RelayModel> objectList = jsonStringList.map((jsonString) {
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      final model = relayModelFomJson(jsonMap);
      if (uniqueSet.add(model.identify)) {
        return model;
      } else {
        return null;
      }
    }).where((s) => s != null).cast<RelayModel>().toList();

    return objectList;
  }
}
