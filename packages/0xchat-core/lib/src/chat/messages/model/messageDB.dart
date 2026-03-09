import 'dart:convert';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';

@reflector
class MessageDB extends DBObject {
  String messageId; //event id
  String sender; // pubkey
  String receiver; // friend pubkey
  String groupId; // channel or group id
  String sessionId; // secret chat id
  int kind;
  String tags;
  String content; // content
  int createTime;
  bool read;
  String replyId;
  // additional,
  String decryptContent;
  String type;
  int? status; // 0 sending, 1 sent, 2 fail 3 recall

  List<String>? reportList; // hide message ids list, not save to DB

  String plaintEvent;

  /// add type
  int?
      chatType; // 0 private chat 1 group chat 2 channel chat 3 secret chat 4 relay group chat
  String? subType; // subtype of template/system type

  /// add previewData
  String? previewData;

  /// add disappearing time
  int? expiration;

  /// add decryptSecret
  String? decryptSecret;

  // actions
  List<String>? reactionEventIds;
  List<String>? zapEventIds;

  // innerEvent Id
  String giftWrappedId;

  MessageDB({
    this.messageId = '',
    this.sender = '',
    this.receiver = '',
    this.groupId = '',
    this.sessionId = '',
    this.kind = 0,
    this.tags = '',
    this.content = '',
    this.createTime = 0,
    this.read = false,
    this.replyId = '',
    this.decryptContent = '',
    this.type = 'text',
    this.status = 1,
    this.plaintEvent = '',
    this.chatType,
    this.subType,
    this.previewData,
    this.expiration,
    this.decryptSecret,
    this.reactionEventIds,
    this.zapEventIds,
    this.giftWrappedId = '',
  });

  @override
  Map<String, Object?> toMap() {
    return _messageInfoToMap(this);
  }

  Future<Event?> get originEvent async {
    try {
      return await Event.fromJson(jsonDecode(plaintEvent));
    } catch (_) {
      return null;
    }
  }

  static MessageDB fromMap(Map<String, Object?> map) {
    return _messageInfoFromMap(map);
  }

  static String? tableName() {
    return "MessageDB";
  }

  //primaryKey
  static List<String?> primaryKey() {
    return ['messageId'];
  }

  //'ALTER TABLE Company ADD description TEXT'
  static Map<String, String?> updateTable() {
    return {
      "2":
          '''alter table MessageDB add plaintEvent TEXT; alter table MessageDB add sessionId TEXT;''',
      "4":
          '''alter table MessageDB add chatType INT; alter table MessageDB add subType TEXT;''',
      "5":
          '''alter table MessageDB add previewData TEXT; alter table MessageDB add expiration INT; alter table MessageDB add decryptSecret TEXT;''',
      "6":
          '''alter table MessageDB add reactionEventIds TEXT; alter table MessageDB add zapEventIds TEXT;''',
      "8": '''alter table MessageDB add giftWrappedId TEXT;'''
    };
  }

  static Future<void> migrateToISAR() async {
    List<MessageDB> messages = await DB.sharedInstance.objects<MessageDB>();
    List<MessageDBISAR> messagesISAR = [];
    for (var message in messages) {
      messagesISAR.add(MessageDBISAR.fromMap(message.toMap()));
    }
    await DBISAR.sharedInstance.isar.writeTxn(() async {
      await DBISAR.sharedInstance.isar.messageDBISARs.putAll(messagesISAR);
    });
  }
}

Map<String, dynamic> _messageInfoToMap(MessageDB instance) => <String, dynamic>{
      'messageId': instance.messageId,
      'sender': instance.sender,
      'receiver': instance.receiver,
      'groupId': instance.groupId,
      'sessionId': instance.sessionId,
      'kind': instance.kind,
      'tags': instance.tags,
      'content': instance.content,
      'createTime': instance.createTime,
      'read': instance.read,
      'replyId': instance.replyId,
      'decryptContent': instance.decryptContent,
      'type': instance.type,
      'status': instance.status,
      'plaintEvent': instance.plaintEvent,
      'subType': instance.subType,
      'chatType': instance.chatType,
      'previewData': instance.previewData,
      'expiration': instance.expiration,
      'decryptSecret': instance.decryptSecret,
      'reactionEventIds': jsonEncode(instance.reactionEventIds),
      'zapEventIds': jsonEncode(instance.zapEventIds),
      'giftWrappedId': instance.giftWrappedId,
    };

MessageDB _messageInfoFromMap(Map<String, dynamic> map) {
  return MessageDB(
    messageId: map['messageId'].toString(),
    sender: map['sender'].toString(),
    receiver: map['receiver'].toString(),
    groupId: map['groupId'].toString(),
    sessionId: map['sessionId'].toString(),
    kind: map['kind'],
    tags: map['tags'].toString(),
    content: map['content'].toString(),
    createTime: map['createTime'],
    read: map['read'] is bool
        ? map['read']
        : map['read'] > 0
            ? true
            : false,
    replyId: map['replyId'].toString(),
    decryptContent: map['decryptContent'].toString(),
    type: map['type'],
    status: map['status'],
    plaintEvent: map['plaintEvent'].toString(),
    chatType: map['chatType'],
    subType: map['subType']?.toString(),
    previewData: map['previewData']?.toString(),
    expiration: map['expiration'],
    decryptSecret: map['decryptSecret']?.toString(),
    reactionEventIds:
        UserDBISAR.decodeStringList(map['reactionEventIds'].toString()),
    zapEventIds: UserDBISAR.decodeStringList(map['zapEventIds'].toString()),
    giftWrappedId: map['giftWrappedId'].toString(),
  );
}
