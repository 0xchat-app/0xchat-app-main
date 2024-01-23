import 'dart:async';
import 'dart:collection';
import 'package:chatcore/chat-core.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/business_interface/ox_chat/custom_message_type.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/utils/ox_chat_observer.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'dart:convert';

import 'package:ox_localizable/ox_localizable.dart';

///Title: ox_chat_binding
///Description: TODO(Fill in by OXChat)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/5/17 14:45

class OXChatBinding {
  static final OXChatBinding sharedInstance = OXChatBinding._internal();

  OXChatBinding._internal();

  HashMap<String, ChatSessionModel> sessionMap = HashMap();
  List<ChatSessionModel> get sessionList{
    return sessionMap.values.where((session) => session.chatType != ChatType.chatStranger && session.chatType != ChatType.chatSecretStranger).toList();
  }
  List<ChatSessionModel> get strangerSessionList{
    return sessionMap.values.where((session) => session.chatType == ChatType.chatStranger || session.chatType == ChatType.chatSecretStranger).toList();
  }
  int unReadStrangerSessionCount = 0;

  bool isZapBadge = false;

  factory OXChatBinding() {
    return sharedInstance;
  }

  final List<OXChatObserver> _observers = <OXChatObserver>[];

  String? Function(MessageDB messageDB)? sessionMessageTextBuilder;
  bool Function(MessageDB messageDB)? msgIsReaded;

  Future<void> initLocalSession() async {
    final List<ChatSessionModel> sessionList = await DB.sharedInstance.objects<ChatSessionModel>(
      orderBy: "createTime desc",
    );
    bool isRefreshSession = false;
    sessionList.forEach((e) {
      if (sessionMap[e.chatId] == null || (sessionMap[e.chatId] != null && sessionMap[e.chatId]!.createTime < e.createTime)) {
        sessionMap[e.chatId] = e;
        isRefreshSession = true;
      }
    });
    if (isRefreshSession) {
      sessionUpdate();
    }
  }

  void clearSession() {
    sessionMap.clear();
    unReadStrangerSessionCount = 0;
  }

  void _updateUnReadStrangerSessionCount(){
    unReadStrangerSessionCount = sessionMap.values.fold(
      0,
      (int previousValue, ChatSessionModel session) {
        if (session.chatType == ChatType.chatStranger || session.chatType == ChatType.chatSecretStranger) {
          return previousValue + session.unreadCount;
        } else {
          return previousValue;
        }
      },
    );
  }

  String showContentByMsgType(MessageDB messageDB) {

    final text = sessionMessageTextBuilder?.call(messageDB);
    if (text != null) return text;

    switch (MessageDB.stringtoMessageType(messageDB.type)) {
      case MessageType.text:
        String? showContent;
        final decryptContent = messageDB.decryptContent;
        if (decryptContent.isNotEmpty) {
          try {
            final decryptedContent = json.decode(decryptContent);
            if (decryptedContent is Map) {
              showContent = decryptedContent['content'] as String;
            } else {
              showContent = decryptedContent.toString();
            }
          } catch (e) {
            LogUtil.e('showContentByMsgType：MessageType.text =${e.toString()}');
          }
        }
        if (showContent == null) showContent = decryptContent ?? '';
        return showContent;
      case MessageType.image:
      case MessageType.encryptedImage:
        return Localized.text('ox_common.message_type_image');
      case MessageType.video:
      case MessageType.encryptedVideo:
        return Localized.text('ox_common.message_type_video');
      case MessageType.audio:
      case MessageType.encryptedAudio:
        return Localized.text('ox_common.message_type_audio');
      case MessageType.file:
      case MessageType.encryptedFile:
        return Localized.text('ox_common.message_type_file');
      case MessageType.system:
        return messageDB.decryptContent ?? '';
      case MessageType.call:
        return Localized.text('ox_common.message_type_call');
      case MessageType.template:
        final decryptContent = messageDB.decryptContent;
        if (decryptContent.isNotEmpty) {
          try {
            final decryptedContent = json.decode(decryptContent);
            if (decryptedContent is Map) {
              final type = CustomMessageTypeEx.fromValue(decryptedContent['type']);
              final content = decryptedContent['content'];
              switch (type) {
                case CustomMessageType.zaps:
                  return Localized.text('ox_common.message_type_zaps');
                case CustomMessageType.template:
                  if (content is Map) {
                    final title = content['title'] ?? '';
                    return Localized.text('ox_common.message_type_template') + title;
                  }
                  break ;
                case CustomMessageType.ecash:
                  return '[Ecash]';
                default:
                  break ;
              }
            }
          } catch (_) { }
        }

        return Localized.text('ox_common.message_type_template');
      default:
        return Localized.text('ox_common.message_type_unknown');
    }
  }

  Future<int> updateChatSession(String chatId, {
    String? chatName,
    String? content,
    String? pic,
    int? unreadCount,
    bool alwaysTop = false,
    String? draft,
    int? messageKind,
    bool? isMentioned,
    int? expiration
  }) async {
    int changeCount = 0;
    ChatSessionModel? sessionModel = sessionMap[chatId];
    if (sessionModel != null) {
      bool isChange = false;
      if (chatName != null && chatName.isNotEmpty && sessionModel.chatName != chatName) {
        sessionModel.chatName = chatName;
        isChange = true;
      }
      if (content != null && content.isNotEmpty && sessionModel.content != content) {
        sessionModel.content = content;
        isChange = true;
      }
      if (pic != null && pic.isNotEmpty && sessionModel.avatar != pic) {
        sessionModel.avatar = pic;
        isChange = true;
      }
      if (unreadCount != null) {
        sessionModel.unreadCount = unreadCount;
        if (sessionModel.chatType == ChatType.chatStranger || sessionModel.chatType == ChatType.chatSecretStranger) {
          _updateUnReadStrangerSessionCount();
        }
        isChange = true;
      }
      if (alwaysTop != sessionModel.alwaysTop) {
        sessionModel.alwaysTop = alwaysTop;
        isChange = true;
      }
      if (draft != null && sessionModel.draft != draft) {
        sessionModel.draft = draft;
        isChange = true;
      }
      if (isMentioned != null && sessionModel.isMentioned != isMentioned) {
        sessionModel.isMentioned = isMentioned;
        isChange = true;
      }
      if (messageKind != null && sessionModel.messageKind != messageKind) {
        sessionModel.messageKind = messageKind;
        isChange = true;
      }
      if (expiration != null && sessionModel.expiration != expiration && !(expiration == 0 && sessionModel.expiration == null)) {
        if(expiration == 0) expiration = null;
        sessionModel.expiration = expiration;
        isChange = true;
      }
      if (isChange) {
        final int count = await DB.sharedInstance.insert<ChatSessionModel>(sessionModel);
        if (count > 0) {
          sessionUpdate();
          changeCount = count;
        }
      }
    }
    return changeCount;
  }

  ChatSessionModel? syncChatSessionTable(MessageDB messageDB, {int? chatType}) {
    final userdb = OXUserInfoManager.sharedInstance.currentUserInfo;
    if ( userdb == null || userdb!.pubKey.isEmpty) {
      return null;
    }
    updateMessageDB(messageDB);
    String showContent = showContentByMsgType(messageDB);
    ChatSessionModel sessionModel = ChatSessionModel(
      content: showContent,
      createTime: messageDB.createTime,
      messageType: messageDB.type,
      receiver: messageDB.receiver,
      sender: messageDB.sender,
      groupId: messageDB.groupId,
    );
    if (messageDB.receiver.isNotEmpty) {
      //single chat
      _syncSingleChat(sessionModel, messageDB, chatType: chatType);
    } else if (messageDB.groupId.isNotEmpty) {
      //group chat
      _syncGroupChat(sessionModel, messageDB);
    }
    sessionUpdate();
    return sessionModel;
  }

  void _syncGroupChat(ChatSessionModel sessionModel, MessageDB messageDB) {
    sessionModel.chatId = messageDB.groupId;
    sessionModel.chatType = messageDB.chatType ?? ChatType.chatChannel;
    ChatSessionModel? tempModel = sessionMap[messageDB.groupId];
    if (tempModel != null) {
      if (!messageDB.read && messageDB.sender != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey) {
        sessionModel.unreadCount = tempModel.unreadCount += 1;
        noticePromptToneCallBack(messageDB, tempModel.chatType!);
      }
      if (messageDB.createTime >= tempModel.createTime) tempModel = sessionModel;
      sessionMap[messageDB.groupId] = tempModel;
      DB.sharedInstance.insert<ChatSessionModel>(tempModel);
    } else {
      if (messageDB.chatType == null || messageDB.chatType == ChatType.chatChannel) {
        ChannelDB? channelDB = Channels.sharedInstance.channels[messageDB.groupId];
        sessionModel.avatar = channelDB?.picture ?? '';
        sessionModel.chatName = channelDB?.name ?? messageDB.groupId;
      } else {
        GroupDB? groupDBDB = Groups.sharedInstance.groups[messageDB.groupId];
        sessionModel.avatar = groupDBDB?.picture ?? '';
        sessionModel.chatName = groupDBDB?.name ?? messageDB.groupId;
      }
      if (!messageDB.read && messageDB.sender != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey) {
        sessionModel.unreadCount = 1;
        noticePromptToneCallBack(messageDB, sessionModel.chatType!);
      }
      sessionMap[messageDB.groupId] = sessionModel;
      DB.sharedInstance.insert<ChatSessionModel>(sessionModel);
    }
  }

  void _syncSingleChat(ChatSessionModel sessionModel, MessageDB messageDB, {int? chatType}) {
    Map<String, String> tempMap = getChatIdAndOtherPubkey(messageDB);
    String chatId = tempMap['ChatId'] ?? '';
    String otherUserPubkey = tempMap['otherUserPubkey'] ?? '';
    UserDB? userDB;
    sessionModel.chatId = chatId;
    ChatSessionModel? tempModel = sessionMap[chatId];
    if (tempModel != null) {
      sessionModel.chatType = tempModel.chatType;
      if (messageDB.sender != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey) {
        if (!messageDB.read) {
          sessionModel.unreadCount = tempModel.unreadCount += 1;
          if (tempModel.chatType == ChatType.chatStranger || tempModel.chatType == ChatType.chatSecretStranger) {
            unReadStrangerSessionCount += 1;
          }
          noticePromptToneCallBack(messageDB, tempModel.chatType);
        }
      } else {
        sessionModel.chatType = sessionModel.chatType == ChatType.chatSecretStranger ? ChatType.chatSecret
            : (sessionModel.chatType == ChatType.chatStranger ? ChatType.chatSingle : sessionModel.chatType);
      }
      if (messageDB.createTime >= tempModel.createTime){
        sessionModel.expiration = tempModel.expiration;
        sessionModel.messageKind = tempModel.messageKind;
        tempModel = sessionModel;
      }
      sessionMap[chatId] = tempModel;
      DB.sharedInstance.insert<ChatSessionModel>(tempModel);
    } else {
      userDB = Contacts.sharedInstance.allContacts[otherUserPubkey];
      if (userDB == null) {
        sessionModel.chatType = messageDB.sessionId.isEmpty ? ChatType.chatStranger : ChatType.chatSecretStranger;
      } else {
        sessionModel.chatType = messageDB.sessionId.isEmpty ? ChatType.chatSingle : ChatType.chatSecret;
      }
      if (chatType != null) {
        sessionModel.chatType = chatType;
      }
      if (!messageDB.read && messageDB.sender != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey) {
        sessionModel.unreadCount = 1;
        if (sessionModel.chatType == ChatType.chatStranger || sessionModel.chatType == ChatType.chatSecretStranger) {
          unReadStrangerSessionCount += 1;
        }
        noticePromptToneCallBack(messageDB, sessionModel.chatType);
      }
      sessionMap[chatId] = sessionModel;
      DB.sharedInstance.insert<ChatSessionModel>(sessionModel);
    }
  }

  Map<String, String> getChatIdAndOtherPubkey(MessageDB messageDB) {
    String chatId = '';
    String otherUserPubkey = '';
    if (messageDB.sessionId.isEmpty) {
      chatId = otherUserPubkey = messageDB.sender != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey ? messageDB.sender : messageDB.receiver;
    } else {
      chatId = messageDB.sessionId;
      SecretSessionDB? ssDB = Contacts.sharedInstance.secretSessionMap[messageDB.sessionId];
      otherUserPubkey = ssDB?.toPubkey ?? '';
    }
    return {'ChatId': chatId, 'otherUserPubkey': otherUserPubkey};
  }

  Future<int> deleteSession(String chatId, {bool isStranger = false}) async {
    sessionMap.remove(chatId);
    if(isStranger) {
      _updateUnReadStrangerSessionCount();
    }
    int changeCount = 0;
    final int count = await DB.sharedInstance.delete<ChatSessionModel>(where: "chatId = ?", whereArgs: [chatId]);
    if (count > 0) {
      changeCount = count;
      OXChatBinding.sharedInstance.sessionUpdate();
    }
    return changeCount;
  }

  void addObserver(OXChatObserver observer) => _observers.add(observer);

  bool removeObserver(OXChatObserver observer) => _observers.remove(observer);

  void createChannelSuccess(ChannelDB channelDB) {
    for (OXChatObserver observer in _observers) {
      observer.didCreateChannel(channelDB);
    }
  }

  void deleteChannel(ChannelDB channelDB) {
    for (OXChatObserver observer in _observers) {
      observer.didDeleteChannel(channelDB);
    }
  }

  void contactUpdatedCallBack() {
    for (OXChatObserver observer in _observers) {
      observer.didContactUpdatedCallBack();
    }
  }

  Future<ChatSessionModel?> getChatSession(String sender, String receiver, String decryptContent) async {
    final userdb = OXUserInfoManager.sharedInstance.currentUserInfo;
    if ( userdb == null || userdb!.pubKey.isEmpty) {
      return null;
    }
    String chatId = sender == userdb!.pubKey ? receiver : sender;
    ChatSessionModel? chatSessionModel = sessionMap[chatId];
    if (chatSessionModel == null) {
      UserDB? userDB = Contacts.sharedInstance.allContacts[chatId];
      if (userDB == null) {
        userDB = await Account.sharedInstance.getUserInfo(chatId);
      }
      int tempCreateTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      chatSessionModel = syncChatSessionTable(
        MessageDB(
          decryptContent: decryptContent,
          content: decryptContent,
          createTime: tempCreateTime,
          sender: sender,
          receiver: receiver,
        ),
        chatType: ChatType.chatSingle,
      );
    }
    return chatSessionModel;
  }

  Future<ChatSessionModel?> localCreateSecretChat(SecretSessionDB ssDB) async {
    final toPubkey = ssDB.toPubkey;
    final myPubkey = ssDB.myPubkey;
    if (toPubkey == null || toPubkey.isEmpty) return null;
    if (myPubkey == null || myPubkey.isEmpty) return null;
    UserDB? userDB = Contacts.sharedInstance.allContacts[toPubkey];
    if (userDB == null) {
      userDB = await Account.sharedInstance.getUserInfo(toPubkey);
    }
    final ChatSessionModel? chatSessionModel = syncChatSessionTable(
      MessageDB(
        decryptContent: 'secret_chat_invited_tips'.commonLocalized({r"${name}": userDB?.name ?? ''}),
        createTime: ssDB.lastUpdateTime,
        sender: toPubkey,
        receiver: myPubkey,
        sessionId: ssDB.sessionId,
      ),
      chatType: ChatType.chatSecret,
    );
    return chatSessionModel;
  }

  void secretChatRequestCallBack(SecretSessionDB ssDB) async {
    final toPubkey = ssDB.toPubkey;
    final myPubkey = ssDB.myPubkey;
    if (toPubkey == null || toPubkey.isEmpty) return;
    if (myPubkey == null || myPubkey.isEmpty) return;
    UserDB? user = await Account.sharedInstance.getUserInfo(toPubkey);
    if (user == null) {
      user = UserDB(pubKey: ssDB.toPubkey!);
    }
    syncChatSessionTable(MessageDB(
      decryptContent: Localized.text('ox_common.secret_chat_received_tips'),
      createTime: ssDB.lastUpdateTime,
      sender: toPubkey,
      receiver: myPubkey,
      sessionId: ssDB.sessionId,
    ));
  }

  void secretChatAcceptCallBack(SecretSessionDB ssDB) async {
    String toPubkey = ssDB.toPubkey ?? '';
    if (toPubkey.isEmpty) return;
    UserDB? user = await Account.sharedInstance.getUserInfo(toPubkey);
    if (user == null) {
      user = UserDB(pubKey: toPubkey);
    }
    await updateChatSession(ssDB.sessionId, content: 'secret_chat_accepted_tips'.commonLocalized({r"${name}": user.name ?? ''}));
    for (OXChatObserver observer in _observers) {
      observer.didSecretChatAcceptCallBack(ssDB);
    }
  }

  void secretChatRejectCallBack(SecretSessionDB ssDB) async {
    String toPubkey = ssDB.toPubkey ?? '';
    if (toPubkey.isEmpty) return;
    UserDB? user = await Account.sharedInstance.getUserInfo(toPubkey);
    if (user == null) {
      user = UserDB(pubKey: toPubkey);
    }
    await updateChatSession(ssDB.sessionId, content: 'secret_chat_rejected_tips'.commonLocalized({r"${name}": user.name ?? ''}));
    for (OXChatObserver observer in _observers) {
      observer.didSecretChatRejectCallBack(ssDB);
    }
  }

  void secretChatUpdateCallBack(SecretSessionDB ssDB) {
    for (OXChatObserver observer in _observers) {
      observer.didSecretChatUpdateCallBack(ssDB);
    }
  }

  void secretChatCloseCallBack(SecretSessionDB ssDB) {
    for (OXChatObserver observer in _observers) {
      observer.didSecretChatCloseCallBack(ssDB);
    }
  }

  void privateChatMessageCallBack(MessageDB message) async {
    syncChatSessionTable(message);
    for (OXChatObserver observer in _observers) {
      observer.didPrivateMessageCallBack(message);
    }
  }

  void secretChatMessageCallBack(MessageDB message) async {
    syncChatSessionTable(message);
    for (OXChatObserver observer in _observers) {
      observer.didSecretChatMessageCallBack(message);
    }
  }

  void channalMessageCallBack(MessageDB messageDB) async {
    syncChatSessionTable(messageDB);
    for (OXChatObserver observer in _observers) {
      observer.didChannalMessageCallBack(messageDB);
    }
  }

  void groupMessageCallBack(MessageDB messageDB) async {
    syncChatSessionTable(messageDB);
    for (OXChatObserver observer in _observers) {
      observer.didGroupMessageCallBack(messageDB);
    }
  }

  void updateMessageDB(MessageDB messageDB) async {
    if (msgIsReaded != null && msgIsReaded!(messageDB) && !messageDB.read){
      messageDB.read = true;
      Messages.updateMessageReadStatus(messageDB);
    }
  }

  Future<int> changeChatSessionType(ChatSessionModel csModel, bool isBecomeContact) async {
    //strangerSession to chatSession
    int? tempChatType = csModel.chatType;
    if(isBecomeContact){
      if (csModel.chatType == ChatType.chatSecretStranger) {
        tempChatType = ChatType.chatSecret;
      } else if (csModel.chatType == ChatType.chatStranger){
        tempChatType = ChatType.chatSingle;
      }
      csModel.chatType = tempChatType;
    } else {
      if (csModel.chatType == ChatType.chatSecret) {
        tempChatType = ChatType.chatSecretStranger;
      } else if (csModel.chatType == ChatType.chatSingle){
        tempChatType = ChatType.chatStranger;
      }
      csModel.chatType = tempChatType;
    }
    sessionMap[csModel.chatId] = csModel;
    final int count = await DB.sharedInstance.insert<ChatSessionModel>(csModel);
    _updateUnReadStrangerSessionCount();
    sessionUpdate();
    return count;
  }

  Future<void> changeChatSessionTypeAll(String pubkey, bool isBecomeContact) async {
    //strangerSession to chatSession
    bool isChange = false;
    List<ChatSessionModel> list = OXChatBinding.sharedInstance.sessionMap.values.toList();
    await Future.forEach(list, (csModel) async {
      if(csModel.chatType == ChatType.chatChannel || csModel.chatType == ChatType.chatGroup){
        return;
      }
      isChange = true;
      int? tempChatType = csModel.chatType;
      if (isBecomeContact) {
        if (csModel.chatType == ChatType.chatSecretStranger && (csModel.sender == pubkey || csModel.receiver == pubkey)) {
          tempChatType = ChatType.chatSecret;
          await updateChatSessionDB(csModel, tempChatType);
        } else if (csModel.chatType == ChatType.chatStranger && csModel.chatId == pubkey) {
          tempChatType = ChatType.chatSingle;
          await updateChatSessionDB(csModel, tempChatType);
        }
      } else {
        if (csModel.chatType == ChatType.chatSecret && (csModel.sender == pubkey || csModel.receiver == pubkey)) {
          tempChatType = ChatType.chatSecretStranger;
          await updateChatSessionDB(csModel, tempChatType);
        } else if (csModel.chatType == ChatType.chatSingle && csModel.chatId == pubkey) {
          tempChatType = ChatType.chatStranger;
          await updateChatSessionDB(csModel, tempChatType);
        }
      }
    });
    if (isChange) {
      _updateUnReadStrangerSessionCount();
      sessionUpdate();
    }
  }

  Future<void> updateChatSessionDB(ChatSessionModel csModel, int tempChatType) async {
    csModel.chatType = tempChatType;
    sessionMap[csModel.chatId] = csModel;
    DB.sharedInstance.insert<ChatSessionModel>(csModel);
  }

  Future<void> syncSessionTypesByContact() async {
    //strangerSession to chatSession
    bool isChange = false;
    List<ChatSessionModel> list = OXChatBinding.sharedInstance.sessionMap.values.toList();
    for (ChatSessionModel csModel in list) {
      if(csModel.chatType == ChatType.chatChannel || csModel.chatType == ChatType.chatGroup){
        continue;
      }
      isChange = true;
      int? tempChatType = csModel.chatType;
      if (csModel.chatType == ChatType.chatSecretStranger) {
        UserDB? senderUserDB = Contacts.sharedInstance.allContacts[csModel.sender];
        UserDB? receiverUserDB = Contacts.sharedInstance.allContacts[csModel.receiver];
        if (senderUserDB != null || receiverUserDB != null) {
          tempChatType = ChatType.chatSecret;
          await updateChatSessionDB(csModel, tempChatType);
        }
      } else if (csModel.chatType == ChatType.chatStranger) {
        UserDB? chatIdUserDB = Contacts.sharedInstance.allContacts[csModel.chatId];
        if (chatIdUserDB != null) {
          tempChatType = ChatType.chatSingle;
          await updateChatSessionDB(csModel, tempChatType);
        }
      }
    }
    if (isChange) {
      _updateUnReadStrangerSessionCount();
      sessionUpdate();
    }
  }

  void noticeFriendRequest() {
    for (OXChatObserver observer in _observers) {
      observer.didSecretChatRequestCallBack();
    }
  }

  void channelsUpdatedCallBack() {
    for (OXChatObserver observer in _observers) {
      observer.didChannelsUpdatedCallBack();
    }
  }

  void groupsUpdatedCallBack() {
    for (OXChatObserver observer in _observers) {
      observer.didGroupsUpdatedCallBack();
    }
  }

  void sessionUpdate() {
    for (OXChatObserver observer in _observers) {
      observer.didSessionUpdate();
    }
  }

  void noticePromptToneCallBack(MessageDB message, int type) async {
    print('noticePromptToneCallBack');
    for (OXChatObserver observer in _observers) {
      observer.didPromptToneCallBack(message, type);
    }
  }

  void zapRecordsCallBack(ZapRecordsDB zapRecordsDB) {
    for (OXChatObserver observer in _observers) {
      observer.didZapRecordsCallBack(zapRecordsDB);
    }
  }

  void offlinePrivateMessageFinishCallBack() {
    for (OXChatObserver observer in _observers) {
      observer.didOfflinePrivateMessageFinishCallBack();
    }
  }

  void offlineSecretMessageFinishCallBack() {
    for (OXChatObserver observer in _observers) {
      observer.didOfflineSecretMessageFinishCallBack();
    }
  }

  void offlineChannelMessageFinishCallBack() {
    for (OXChatObserver observer in _observers) {
      observer.didOfflineChannelMessageFinishCallBack();
    }
  }
}
