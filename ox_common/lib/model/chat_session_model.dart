import 'package:chatcore/chat-core.dart';

///Title: chat_session_model
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/5/18 10:01

@reflector
class ChatSessionModel extends DBObject {
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

  // 0 Chat  1 Normal Group  2 Channel Group  3 Secret Chat 4 Stranger Chat  5 Stranger secret Chat
  int? chatType;

  //text, image, video, audio, file, template
  String? messageType;

  String? avatar;

  bool alwaysTop;

  ChatSessionModel({
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
    return _chatSessionModelToMap(this);
  }

  static ChatSessionModel fromMap(Map<String, Object?> map) {
    return _chatSessionModelFromMap(map);
  }
}

ChatSessionModel _chatSessionModelFromMap(Map<String, dynamic> map) {
  return ChatSessionModel(
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

Map<String, dynamic> _chatSessionModelToMap(ChatSessionModel instance) => <String, dynamic>{
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

