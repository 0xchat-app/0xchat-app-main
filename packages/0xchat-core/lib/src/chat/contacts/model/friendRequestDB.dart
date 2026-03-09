import 'dart:convert';
import 'package:chatcore/chat-core.dart';

@reflector
class FriendRequestDB extends DBObject {
  String? friendPubkey;
  String? friendAliasPubkey;
  String? myAliasPubkey;
  String? myAliasPrivkey;
  bool? isFriend;

  /// 0: default value
  /// 1: reqeust by friend
  /// 2: accept by friend
  /// 3: reject by friend
  /// 4: delete by friend
  /// 5: reqeust by me
  /// 6: accept by me
  /// 7: reject by me
  /// 8: delete by me
  int? status;

  /// [[time1, content1], [time2, content2],...]
  List<List<String>>? requestContent;
  int? lastUpdateTime;

  FriendRequestDB({
    this.friendPubkey = '',
    this.friendAliasPubkey = '',
    this.myAliasPubkey = '',
    this.myAliasPrivkey = '',
    this.isFriend = false,
    this.status = 0,
    this.requestContent,
    this.lastUpdateTime = 0
  });

  @override
  Map<String, Object?> toMap() {
    return _friendRequestInfoToMap(this);
  }

  static FriendRequestDB fromMap(Map<String, Object?> map) {
    return _friendRequestInfoFromMap(map);
  }

  static String? tableName() {
    return "FriendRequest";
  }

  //primaryKey
  static List<String?> primaryKey() {
    return ['friendPubkey'];
  }

  static List<List<String>>? decodeRequestList(String request) {
    try {
      List<List<dynamic>> result = jsonDecode(request);
      return result
          .map((innerList) => innerList.map((item) => item.toString()).toList())
          .toList();
    } catch (e) {
      return null;
    }
  }
}

Map<String, dynamic> _friendRequestInfoToMap(FriendRequestDB instance) =>
    <String, dynamic>{
      'friendPubkey': instance.friendPubkey,
      'friendAliasPubkey': instance.friendAliasPubkey,
      'myAliasPubkey': instance.myAliasPubkey,
      'myAliasPrivkey': instance.myAliasPrivkey,
      'isFriend': instance.isFriend,
      'status': instance.status,
      'requestContent': jsonEncode(instance.requestContent ?? []),
      'lastUpdateTime': instance.lastUpdateTime,
    };

FriendRequestDB _friendRequestInfoFromMap(Map<String, dynamic> map) {
  return FriendRequestDB(
    friendPubkey: map['friendPubkey'].toString(),
    friendAliasPubkey: map['friendAliasPubkey'],
    myAliasPubkey: map['myAliasPubkey'].toString(),
    myAliasPrivkey: map['myAliasPrivkey'].toString(),
    isFriend: map['isFriend'] > 0 ? true : false,
    status: map['status'],
    requestContent:
        FriendRequestDB.decodeRequestList(map['requestContent'].toString()),
    lastUpdateTime: map['lastUpdateTime'],
  );
}
