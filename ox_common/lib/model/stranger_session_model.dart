import 'package:chatcore/chat-core.dart';

///Title: stranger_session_model
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/8/18 17:26

@reflector
class StrangerSessionModel extends DBObject {
  String? chatId;
  String? chatName;

  // pubkey
  String? sender;

  // receiver pubkey
  String? receiver;

  // channel or group id
  String? groupId;
  String? content;
  int unreadCount;

  //last message timestamp
  int? createTime;

  // 0 Chat  1 Normal Group  2 Channel Group
  int? chatType;

  //text, image, video, audio, file, template
  String? messageType;

  String? avatar;

  bool alwaysTop;

  StrangerSessionModel({
    this.chatId,
    this.chatName,
    this.sender,
    this.receiver,
    this.groupId,
    this.content,
    this.unreadCount = 0,
    this.createTime,
    this.chatType,
    this.messageType,
    this.avatar,
    this.alwaysTop = false,
  });

  static List<String?> primaryKey() {
    return ['chatId'];
  }

  @override
  Map<String, Object?> toMap() {
    return _strangerSessionModelToMap(this);
  }

  static StrangerSessionModel fromMap(Map<String, Object?> map) {
    return _strangerSessionModelFromMap(map);
  }
}

StrangerSessionModel _strangerSessionModelFromMap(Map<String, dynamic> map) {
  return StrangerSessionModel(
    chatId: map['chatId'],
    chatName: map['chatName'],
    sender: map['sender'],
    receiver: map['receiver'],
    groupId: map['groupId'],
    content: map['content'],
    unreadCount: map['unreadCount'],
    createTime: map['createTime'],
    chatType: map['chatType'],
    messageType: map['messageType'],
    avatar: map['avatar'],
    alwaysTop: map['alwaysTop'] == 1,
  );
}

Map<String, dynamic> _strangerSessionModelToMap(StrangerSessionModel instance) => <String, dynamic>{
      'chatId': instance.chatId,
      'chatName': instance.chatName,
      'sender': instance.sender,
      'receiver': instance.receiver,
      'groupId': instance.groupId,
      'content': instance.content,
      'unreadCount': instance.unreadCount,
      'createTime': instance.createTime,
      'chatType': instance.chatType,
      'messageType': instance.messageType,
      'avatar': instance.avatar,
      'alwaysTop': instance.alwaysTop == true ? 1 : 0,
    };

