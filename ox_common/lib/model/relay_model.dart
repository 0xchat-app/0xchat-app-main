
///Title: relay_model
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/5/5 15:57

class RelayModel{
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
    if (address.endsWith('/')) {
      return address.substring(0, address.length - 1);
    }
    return address;
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

class RelayConnectStatus{
  static final int connecting = 0;
  static final int open = 1;
  static final int closing = 2;
  static final int closed = 3;
}