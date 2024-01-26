import 'package:ox_common/const/common_constant.dart';

///Title: relay_model
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/5/5 15:57

class RelayModel {
  String relayName;
  bool canDelete;
  bool isSelected; //Has this Relay been selected to establish a connection?
  bool isAddedCommend; //Only used in the UI of UI Commend Relay, Not for other use
  /// connecting = 0;
  /// open = 1;
  /// closing = 2;
  /// closed = 3;
  int connectStatus;
  int createTime;

  String get identify => identifyWithAddress(relayName);

  static String identifyWithAddress(String address) {
    return address.replaceFirst(RegExp(r'/+$'), '');
  }

  RelayModel({
    this.relayName = '',
    this.canDelete = false,
    this.isSelected = false,
    this.isAddedCommend = false,
    this.connectStatus = 0,
    this.createTime = 0,
  });

  @override
  String toString() {
    return 'RelayModel{relayName: $relayName, canDelete: $canDelete, isSelected: $isSelected, isAddedCommend: $isAddedCommend, connectStatus: $connectStatus, createTime: $createTime}';
  }

  static List<RelayModel> checkDefaultRelays(List<String> relayAddressList) {
    List<RelayModel> commendRelayList = [];
    bool containsOxChatRelay = relayAddressList.contains(CommonConstant.oxChatRelay);
    if (!containsOxChatRelay)
      commendRelayList.add(RelayModel(
        relayName: CommonConstant.oxChatRelay,
        canDelete: true,
        connectStatus: 3,
        isSelected: true,
        isAddedCommend: containsOxChatRelay ? true : false,
        createTime: DateTime.now().millisecondsSinceEpoch,
      ));
    bool containsYabume = relayAddressList.contains(''
        'wss://yabu.me');
    if (!containsYabume)
      commendRelayList.add(RelayModel(
        canDelete: true,
        connectStatus: 3,
        isSelected: false,
        isAddedCommend: containsYabume ? true : false,
        relayName: 'wss://yabu.me',
      ));
    bool containsSiamstr = relayAddressList.contains(''
        'wss://relay.siamstr.com');
    if (!containsSiamstr)
      commendRelayList.add(RelayModel(
        canDelete: true,
        connectStatus: 3,
        isSelected: false,
        isAddedCommend: containsSiamstr ? true : false,
        relayName: 'wss://relay.siamstr.com',
      ));
    bool containsDamusIo = relayAddressList.contains('wss://relay.damus.io');
    if (!containsDamusIo)
      commendRelayList.add(RelayModel(
        canDelete: true,
        connectStatus: 3,
        isSelected: false,
        isAddedCommend: containsDamusIo ? true : false,
        relayName: 'wss://relay.damus.io',
      ));
    bool containsNostrBand = relayAddressList.contains(''
        'wss://relay.nostr.band');
    if (!containsNostrBand)
      commendRelayList.add(RelayModel(
        canDelete: true,
        connectStatus: 3,
        isSelected: false,
        isAddedCommend: containsNostrBand ? true : false,
        relayName: 'wss://relay.nostr.band',
      ));
    bool containsNoslol = relayAddressList.contains(''
        'wss://nos.lol');
    if (!containsNoslol)
      commendRelayList.add(RelayModel(
        canDelete: true,
        connectStatus: 3,
        isSelected: false,
        isAddedCommend: containsNoslol ? true : false,
        relayName: 'wss://nos.lol',
      ));
    bool containsNostrwine = relayAddressList.contains(''
        'wss://nostr.wine');
    if (!containsNostrwine)
      commendRelayList.add(RelayModel(
        canDelete: true,
        connectStatus: 3,
        isSelected: false,
        isAddedCommend: containsNostrwine ? true : false,
        relayName: 'wss://nostr.wine',
      ));
    bool containsCoinfundit = relayAddressList.contains(''
        'wss://nostr.coinfundit.com');
    if (!containsCoinfundit)
      commendRelayList.add(RelayModel(
        canDelete: true,
        connectStatus: 3,
        isSelected: false,
        isAddedCommend: containsCoinfundit ? true : false,
        relayName: 'wss://nostr.coinfundit.com',
      ));
    bool containsNostrland = relayAddressList.contains(''
        'wss://eden.nostr.land');
    if (!containsNostrland)
      commendRelayList.add(RelayModel(
        canDelete: true,
        connectStatus: 3,
        isSelected: false,
        isAddedCommend: containsNostrland ? true : false,
        relayName: 'wss://eden.nostr.land',
      ));
    return commendRelayList;
  }
}

RelayModel relayModelFomJson(Map<String, dynamic> map) {
  return RelayModel(
    relayName: map['relayName'].toString(),
    canDelete: map['canDelete'] == 1,
    isSelected: map['isSelected'] == 1,
    isAddedCommend: map['isAddedCommend'] == 1,
    createTime: map['createTime'],
  );
}

Map<String, dynamic> relayModelToMap(RelayModel instance) => <String, dynamic>{
      'relayName': instance.relayName,
      'canDelete': instance.canDelete == true ? 1 : 0,
      'isSelected': instance.isSelected == true ? 1 : 0,
      'isAddedCommend': instance.isAddedCommend == true ? 1 : 0,
      'createTime': instance.createTime,
    };

class RelayConnectStatus {
  static final int connecting = 0;
  static final int open = 1;
  static final int closing = 2;
  static final int closed = 3;
}
