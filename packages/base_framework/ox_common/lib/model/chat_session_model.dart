import 'package:chatcore/chat-core.dart';
import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';

///Title: chat_session_model
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/5/18 10:01

@reflector
class ChatSessionModel extends DBObject {
  String chatId;
  String? chatName;

  // pubkey
  String sender;

  // receiver pubkey
  String receiver;

  // channel or group id
  String? groupId;
  String? content;
  int unreadCount;

  //last message timestamp
  int createTime;

  // 0 Chat  1 Normal Group  2 Channel Group  3 Secret Chat 4 Stranger Chat  5 Stranger secret Chat 7 Relay Group Chat
  int chatType;

  //text, image, video, audio, file, template
  String? messageType;

  String? avatar;

  bool alwaysTop;

  String? draft;

  bool isMentioned;

  int? messageKind;

  // added @v5
  int? expiration;


  ChatSessionModel({
    this.chatId = '',
    this.chatName,
    this.sender = '',
    this.receiver = '',
    this.groupId,
    this.content,
    this.unreadCount = 0,
    this.createTime = 0,
    this.chatType = 0,
    this.messageType = 'text',
    this.avatar,
    this.alwaysTop = false,
    this.draft,
    this.isMentioned = false,
    this.messageKind,
    this.expiration
  });

  String get getOtherPubkey {
    return this.sender != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey ? this.sender : this.receiver;
  }

  static List<String?> primaryKey() {
    return ['chatId'];
  }

  // static List<String?> ignoreKey() {
  //   return ['messageKind'];
  // }

  static Map<String, String?> updateTable() {
    return {
      '2': '''alter table ChatSessionModel add draft TEXT;''',
      '3': '''alter table ChatSessionModel add isMentioned INT DEFAULT 0;''',
      "5": '''alter table ChatSessionModel add expiration INT; alter table ChatSessionModel add messageKind INT;''',
    };
  }

  @override
  Map<String, Object?> toMap() {
    return _chatSessionModelToMap(this);
  }

  static ChatSessionModel fromMap(Map<String, Object?> map) {
    return _chatSessionModelFromMap(map);
  }

  @override
  String toString() {
    return 'ChatSessionModel{chatId: $chatId, chatName: $chatName, sender: $sender, receiver: $receiver, groupId: $groupId, content: $content, unreadCount: $unreadCount, createTime: $createTime, chatType: $chatType, messageType: $messageType, avatar: $avatar, alwaysTop: $alwaysTop, draft: $draft, messageKind: $messageKind, expiration: $expiration}';
  }

  bool get hasMultipleUsers => {ChatType.chatGroup, ChatType.chatChannel, ChatType.chatRelayGroup}.contains(chatType);

  static ChatSessionModel getDefaultSession(int type, String receiverPubkey, String sender, {String secretSessionId = ''}) {
    String chatId = '';
    String receiver = '';
    switch (type) {
      case ChatType.chatSingle:
      case ChatType.chatStranger:
        chatId = receiverPubkey;
        receiver = receiverPubkey;
        break;
      case ChatType.chatGroup:
      case ChatType.chatChannel:
      case ChatType.chatRelayGroup:
        chatId = receiverPubkey;
        break;
      case ChatType.chatSecret:
      case ChatType.chatSecretStranger:
        chatId = secretSessionId;
        receiver = receiverPubkey;
        break;
    }
    return ChatSessionModel(
      chatId: chatId,
      receiver: receiver,
      chatType: type,
      sender: sender,
    );
  }

  static Future<void> migrateToISAR() async {
    List<ChatSessionModel> chatSessionModels = await DB.sharedInstance.objects<ChatSessionModel>();
    List<ChatSessionModelISAR> chatSessionModelsISAR = [];
    for(var chatSessionModel in chatSessionModels){
      chatSessionModelsISAR.add(ChatSessionModelISAR.fromMap(chatSessionModel.toMap()));
    }
    await DBISAR.sharedInstance.isar.writeTxn(() async {
      await DBISAR.sharedInstance.isar.chatSessionModelISARs
          .putAll(chatSessionModelsISAR);
    });
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
    draft: map['draft'],
    isMentioned: map['isMentioned'] == 1,
    messageKind: map['messageKind'],
    expiration: map['expiration'],
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
      'draft': instance.draft,
      'isMentioned': instance.isMentioned == true ? 1 : 0,
      'messageKind': instance.messageKind,
      'expiration': instance.expiration
    };
