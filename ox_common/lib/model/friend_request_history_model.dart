
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/log_util.dart';

///Title: friend_request_history_model
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/5/25 14:36

@reflector
class FriendRequestHistoryModel extends DBObject {
  String? pubKey;
  String? name;
  String? picture;

  ///Whether the friend request information has been read: 0 unread; 1 read
  int isRead;

  ///status   0 Not added; 1 Agree; 2 Reject; 3 Expired
  int status = 0;

  ///Friend source type
  int sourceType;

  ///Request time, timestamp
  int requestTime;

  String? aliasPubkey;

  /// profile badges
  String? badges;

  FriendRequestHistoryModel({
    this.pubKey,
    this.name,
    this.picture,
    this.isRead = 0,
    this.status = 0,
    this.sourceType = 0,
    this.requestTime = 0,
    this.aliasPubkey = '',
    this.badges,
  });

  static List<String?> primaryKey() {
    return ['pubKey'];
  }

  @override
  Map<String, Object?> toMap() {
    return _friendReqHistoryModelToMap(this);
  }

  static FriendRequestHistoryModel fromMap(Map<String, Object?> map) {
    return _friendReqHistoryModelFromMap(map);
  }

  static Future<int> saveFriendRequestToDB(FriendRequestHistoryModel model) async {
    final int count = await DB.sharedInstance.insert<FriendRequestHistoryModel>(model);
    LogUtil.e('Michael: saveFriendRequestToDB count =${count}');
    return count;
  }
}

Map<String, dynamic> _friendReqHistoryModelToMap(FriendRequestHistoryModel instance) {
  return <String, dynamic>{
    'pubKey': instance.pubKey,
    'name': instance.name,
    'picture': instance.picture,
    'isRead': instance.isRead,
    'status': instance.status,
    'sourceType': instance.sourceType,
    'requestTime': instance.requestTime,
    'aliasPubkey': instance.aliasPubkey,
    'badges': instance.badges,
  };
}

FriendRequestHistoryModel _friendReqHistoryModelFromMap(Map<String, dynamic> map) {
  return FriendRequestHistoryModel(
    pubKey: map['pubKey'],
    name: map['name'],
    picture: map['picture'],
    isRead: map['isRead'],
    status: map['status'],
    sourceType: map['sourceType'],
    requestTime: map['requestTime'],
    aliasPubkey: map['aliasPubkey'],
    badges: map['badges'],
  );
}
