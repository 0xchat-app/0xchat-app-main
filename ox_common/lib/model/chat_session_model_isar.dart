import 'package:chatcore/chat-core.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:isar/isar.dart';

part 'chat_session_model_isar.g.dart';

@collection
class ChatSessionModelISAR {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
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


  ChatSessionModelISAR({
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

  @ignore
  String get getOtherPubkey {
    return this.sender != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey ? this.sender : this.receiver;
  }

  static ChatSessionModelISAR fromMap(Map<String, Object?> map) {
    return _chatSessionModelFromMap(map);
  }

  @override
  String toString() {
    return 'ChatSessionModel{chatId: $chatId, chatName: $chatName, sender: $sender, receiver: $receiver, groupId: $groupId, content: $content, unreadCount: $unreadCount, createTime: $createTime, chatType: $chatType, messageType: $messageType, avatar: $avatar, alwaysTop: $alwaysTop, draft: $draft, messageKind: $messageKind, expiration: $expiration}';
  }

  @ignore
  bool get hasMultipleUsers => {ChatType.chatGroup, ChatType.chatChannel, ChatType.chatRelayGroup}.contains(chatType);

  static ChatSessionModelISAR getDefaultSession(int type, String receiverPubkey, String sender, {String secretSessionId = ''}) {
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
    return ChatSessionModelISAR(
      chatId: chatId,
      receiver: receiver,
      chatType: type,
      sender: sender,
    );
  }

  static Future<void> saveChatSessionModelToDB(ChatSessionModelISAR chatSessionModel) async {
    final isar = DBISAR.sharedInstance.isar;
    await isar.writeTxn(() async {
      await isar.chatSessionModelISARs.put(chatSessionModel);
    });
  }
}

ChatSessionModelISAR _chatSessionModelFromMap(Map<String, dynamic> map) {
  return ChatSessionModelISAR(
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
