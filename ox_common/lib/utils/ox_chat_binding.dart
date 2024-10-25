import 'dart:async';
import 'dart:collection';

import 'package:chatcore/chat-core.dart';
import 'package:isar/isar.dart';
import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/utils/ox_chat_observer.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_localizable/ox_localizable.dart';


///Title: ox_chat_binding
///Description: TODO(Fill in by OXChat)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/5/17 14:45

class OXChatBinding {
  static final OXChatBinding sharedInstance = OXChatBinding._internal();

  OXChatBinding._internal();

  HashMap<String, ChatSessionModelISAR> sessionMap = HashMap();
  List<ChatSessionModelISAR> get sessionList{
    return sessionMap.values.where((session) => session.chatType != ChatType.chatStranger && session.chatType != ChatType.chatSecretStranger).toList();
  }
  List<ChatSessionModelISAR> get strangerSessionList{
    return sessionMap.values.where((session) => session.chatType == ChatType.chatStranger || session.chatType == ChatType.chatSecretStranger).toList();
  }
  int unReadStrangerSessionCount = 0;

  bool isZapBadge = false;

  factory OXChatBinding() {
    return sharedInstance;
  }

  final List<OXChatObserver> _observers = <OXChatObserver>[];

  String? Function(MessageDBISAR messageDB)? sessionMessageTextBuilder;
  bool Function(MessageDBISAR messageDB)? msgIsReaded;

  Future<void> initLocalSession() async {
    final isar = DBISAR.sharedInstance.isar;
    final List<ChatSessionModelISAR> sessionList = await isar.chatSessionModelISARs.where().sortByCreateTimeDesc().findAll();
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
      (int previousValue, ChatSessionModelISAR session) {
        if (session.chatType == ChatType.chatStranger || session.chatType == ChatType.chatSecretStranger) {
          return previousValue + session.unreadCount;
        } else {
          return previousValue;
        }
      },
    );
  }

  String showContentByMsgType(MessageDBISAR messageDB) {
    return sessionMessageTextBuilder?.call(messageDB) ?? '';
  }

  Future<int> updateChatSession(String chatId, {
    String? chatName,
    String? content,
    String? pic,
    int? unreadCount,
    bool alwaysTop = false,
    String? draft,
    String? replyMessageId,
    int? messageKind,
    bool? isMentioned,
    int? expiration
  }) async {
    int changeCount = 0;
    ChatSessionModelISAR? sessionModel = sessionMap[chatId];
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
      if (replyMessageId != null && sessionModel.replyMessageId != replyMessageId) {
        sessionModel.replyMessageId = replyMessageId;
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
        await ChatSessionModelISAR.saveChatSessionModelToDB(sessionModel);
        sessionUpdate();
        changeCount = 1;
      }
    }
    return changeCount;
  }

  ChatSessionModelISAR? syncChatSessionTable(MessageDBISAR messageDB, {int? chatType}) {
    final userdb = OXUserInfoManager.sharedInstance.currentUserInfo;
    if ( userdb == null || userdb.pubKey.isEmpty) {
      return null;
    }
    updateMessageDB(messageDB);
    String showContent = showContentByMsgType(messageDB);
    ChatSessionModelISAR sessionModel = ChatSessionModelISAR(
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

  void _syncGroupChat(ChatSessionModelISAR sessionModel, MessageDBISAR messageDB) {
    sessionModel.chatId = messageDB.groupId;
    if (messageDB.chatType == 4) {
      sessionModel.chatType = ChatType.chatRelayGroup;
    } else {
      sessionModel.chatType = messageDB.chatType ?? ChatType.chatChannel;
    }
    ChatSessionModelISAR? tempModel = sessionMap[messageDB.groupId];
    if (tempModel != null) {
      if (messageDB.createTime >= tempModel.createTime) {
        tempModel.content = sessionModel.content;
        tempModel.createTime = sessionModel.createTime;
        tempModel.messageType = sessionModel.messageType;
      }
      if (!messageDB.read && messageDB.sender != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey) {
        tempModel.unreadCount = tempModel.unreadCount += 1;
        noticePromptToneCallBack(messageDB, tempModel.chatType);
      }
      sessionMap[messageDB.groupId] = tempModel;
      ChatSessionModelISAR.saveChatSessionModelToDB(tempModel);
    } else {
      if (messageDB.chatType == null || messageDB.chatType == ChatType.chatChannel) {
        ChannelDBISAR? channelDB = Channels.sharedInstance.myChannels[messageDB.groupId]?.value;
        if (channelDB == null) return;
        sessionModel.avatar = channelDB.picture ?? '';
        sessionModel.chatName = channelDB.name ?? messageDB.groupId;
      } else if (messageDB.chatType == null || messageDB.chatType == ChatType.chatRelayGroup) {
        RelayGroupDBISAR? relayGroupDB = RelayGroup.sharedInstance.myGroups[messageDB.groupId]?.value;
        if (relayGroupDB == null) return;
        sessionModel.avatar = relayGroupDB.picture ?? '';
        sessionModel.chatName = relayGroupDB.name ?? messageDB.groupId;
      } else {
        GroupDBISAR? groupDBDB = Groups.sharedInstance.myGroups[messageDB.groupId]?.value;
        if (groupDBDB == null) return;
        sessionModel.avatar = groupDBDB.picture ?? '';
        sessionModel.chatName = groupDBDB.name;
      }
      if (!messageDB.read && messageDB.sender != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey) {
        sessionModel.unreadCount = 1;
        noticePromptToneCallBack(messageDB, sessionModel.chatType);
      }
      sessionMap[messageDB.groupId] = sessionModel;
      ChatSessionModelISAR.saveChatSessionModelToDB(sessionModel);
    }
  }

  void _syncSingleChat(ChatSessionModelISAR sessionModel, MessageDBISAR messageDB, {int? chatType}) {
    Map<String, String> tempMap = getChatIdAndOtherPubkey(messageDB);
    String chatId = tempMap['ChatId'] ?? '';
    String otherUserPubkey = tempMap['otherUserPubkey'] ?? '';
    UserDBISAR? userDB;
    sessionModel.chatId = chatId;
    ChatSessionModelISAR? tempModel = sessionMap[chatId];
    if (tempModel != null) {
      if (messageDB.createTime >= tempModel.createTime) {
        tempModel.content = sessionModel.content;
        tempModel.createTime = sessionModel.createTime;
        tempModel.messageType = sessionModel.messageType;
      }
      if (messageDB.sender != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey) {
        if (!messageDB.read) {
          tempModel.unreadCount = tempModel.unreadCount += 1;
          if (tempModel.chatType == ChatType.chatStranger || tempModel.chatType == ChatType.chatSecretStranger) {
            unReadStrangerSessionCount += 1;
          }
          noticePromptToneCallBack(messageDB, tempModel.chatType);
        }
      } else {
        tempModel.chatType = tempModel.chatType == ChatType.chatSecretStranger ? ChatType.chatSecret
            : (tempModel.chatType == ChatType.chatStranger ? ChatType.chatSingle : tempModel.chatType);
      }
      sessionMap[chatId] = tempModel;
      ChatSessionModelISAR.saveChatSessionModelToDB(tempModel);
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
      ChatSessionModelISAR.saveChatSessionModelToDB(sessionModel);
    }
  }

  void deleteMessageHandler(MessageDBISAR delMessage, String newSessionSubtitle) {
    Map<String, String> tempMap = getChatIdAndOtherPubkey(delMessage);
    String chatId = tempMap['ChatId'] ?? '';
    if (chatId.isEmpty) return ;
    _updateSessionSubtitle(chatId, newSessionSubtitle);
  }

  void _updateSessionSubtitle(String chatId, String subtitle) {
    final session = sessionMap[chatId];
    if (session == null) return ;

    session.content = subtitle;
    ChatSessionModelISAR.saveChatSessionModelToDB(session);
  }

  Map<String, String> getChatIdAndOtherPubkey(MessageDBISAR messageDB) {
    String chatId = '';
    String otherUserPubkey = '';
    if (messageDB.sessionId.isEmpty) {
      chatId = otherUserPubkey = messageDB.sender != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey ? messageDB.sender : messageDB.receiver;
    } else {
      chatId = messageDB.sessionId;
      SecretSessionDBISAR? ssDB = Contacts.sharedInstance.secretSessionMap[messageDB.sessionId];
      otherUserPubkey = ssDB?.toPubkey ?? '';
    }
    return {'ChatId': chatId, 'otherUserPubkey': otherUserPubkey};
  }

  Future<int> deleteSession(List<String> chatIds, {bool isStranger = false}) async {
    chatIds.forEach((chatId) {
      ChatSessionModelISAR? sessionModelISAR = sessionMap[chatId];
      if(sessionModelISAR != null){
        switch(sessionModelISAR.chatType){
          case ChatType.chatSecret:
            Contacts.sharedInstance.close(sessionModelISAR.chatId);
            Messages.deleteSecretChatMessagesFromDB(sessionModelISAR.chatId);
            break;
          case ChatType.chatSingle:
            Messages.deleteSingleChatMessagesFromDB(sessionModelISAR.sender, sessionModelISAR.receiver);
            Messages.deleteSingleChatMessagesFromDB(sessionModelISAR.receiver, sessionModelISAR.sender);
            break;
          case ChatType.chatChannel:
          case ChatType.chatGroup:
          case ChatType.chatRelayGroup:
            Messages.deleteGroupMessagesFromDB(sessionModelISAR.groupId);
            break;
        }
      }
      sessionMap.remove(chatId);
    });
    if(isStranger) {
      _updateUnReadStrangerSessionCount();
    }
    int changeCount = 0;
    final isar = DBISAR.sharedInstance.isar;
    await isar.writeTxn(() async {
      final int count = await isar.chatSessionModelISARs.filter().anyOf(chatIds, (q, chatId) => q.chatIdEqualTo(chatId)).deleteAll();
      if (count > 0) {
        changeCount = 1;
        OXChatBinding.sharedInstance.sessionUpdate();
      }
    });
    return changeCount;
  }

  void addObserver(OXChatObserver observer) => _observers.add(observer);

  bool removeObserver(OXChatObserver observer) => _observers.remove(observer);

  void createChannelSuccess(ChannelDBISAR channelDB) {
    for (OXChatObserver observer in _observers) {
      observer.didCreateChannel(channelDB);
    }
  }

  void deleteChannel(ChannelDBISAR channelDB) {
    for (OXChatObserver observer in _observers) {
      observer.didDeleteChannel(channelDB);
    }
  }

  void contactUpdatedCallBack() {
    for (OXChatObserver observer in _observers) {
      observer.didContactUpdatedCallBack();
    }
  }

  Future<ChatSessionModelISAR?> getChatSession(String sender, String receiver, String decryptContent) async {
    final userdb = OXUserInfoManager.sharedInstance.currentUserInfo;
    if ( userdb == null || userdb.pubKey.isEmpty) {
      return null;
    }
    String chatId = sender == userdb.pubKey ? receiver : sender;
    ChatSessionModelISAR? chatSessionModel = sessionMap[chatId];
    if (chatSessionModel == null) {
      UserDBISAR? userDB = Contacts.sharedInstance.allContacts[chatId];
      if (userDB == null) {
        userDB = await Account.sharedInstance.getUserInfo(chatId);
      }
      int tempCreateTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      chatSessionModel = syncChatSessionTable(
        MessageDBISAR(
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

  Future<ChatSessionModelISAR?> localCreateSecretChat(SecretSessionDBISAR ssDB) async {
    final toPubkey = ssDB.toPubkey;
    final myPubkey = ssDB.myPubkey;
    if (toPubkey == null || toPubkey.isEmpty) return null;
    if (myPubkey == null || myPubkey.isEmpty) return null;
    UserDBISAR? userDB = Contacts.sharedInstance.allContacts[toPubkey];
    if (userDB == null) {
      userDB = await Account.sharedInstance.getUserInfo(toPubkey);
    }
    final ChatSessionModelISAR? chatSessionModel = syncChatSessionTable(
      MessageDBISAR(
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

  void secretChatRequestCallBack(SecretSessionDBISAR ssDB) async {
    final toPubkey = ssDB.toPubkey;
    final myPubkey = ssDB.myPubkey;
    if (toPubkey == null || toPubkey.isEmpty) return;
    if (myPubkey == null || myPubkey.isEmpty) return;
    UserDBISAR? user = await Account.sharedInstance.getUserInfo(toPubkey);
    if (user == null) {
      user = UserDBISAR(pubKey: ssDB.toPubkey!);
    }
    syncChatSessionTable(MessageDBISAR(
      decryptContent: Localized.text('ox_common.secret_chat_received_tips'),
      createTime: ssDB.lastUpdateTime,
      sender: toPubkey,
      receiver: myPubkey,
      sessionId: ssDB.sessionId,
    ));
  }

  void secretChatAcceptCallBack(SecretSessionDBISAR ssDB) async {
    String toPubkey = ssDB.toPubkey ?? '';
    if (toPubkey.isEmpty) return;
    UserDBISAR? user = await Account.sharedInstance.getUserInfo(toPubkey);
    if (user == null) {
      user = UserDBISAR(pubKey: toPubkey);
    }
    await updateChatSession(ssDB.sessionId, content: 'secret_chat_accepted_tips'.commonLocalized({r"${name}": user.name ?? ''}));
    for (OXChatObserver observer in _observers) {
      observer.didSecretChatAcceptCallBack(ssDB);
    }
  }

  void secretChatRejectCallBack(SecretSessionDBISAR ssDB) async {
    String toPubkey = ssDB.toPubkey ?? '';
    if (toPubkey.isEmpty) return;
    UserDBISAR? user = await Account.sharedInstance.getUserInfo(toPubkey);
    if (user == null) {
      user = UserDBISAR(pubKey: toPubkey);
    }
    await updateChatSession(ssDB.sessionId, content: 'secret_chat_rejected_tips'.commonLocalized({r"${name}": user.name ?? ''}));
    for (OXChatObserver observer in _observers) {
      observer.didSecretChatRejectCallBack(ssDB);
    }
  }

  void secretChatUpdateCallBack(SecretSessionDBISAR ssDB) {
    for (OXChatObserver observer in _observers) {
      observer.didSecretChatUpdateCallBack(ssDB);
    }
  }

  void secretChatCloseCallBack(SecretSessionDBISAR ssDB) {
    for (OXChatObserver observer in _observers) {
      observer.didSecretChatCloseCallBack(ssDB);
    }
  }

  void privateChatMessageCallBack(MessageDBISAR message) async {
    syncChatSessionTable(message);
    for (OXChatObserver observer in _observers) {
      observer.didPrivateMessageCallBack(message);
    }
  }

  void chatMessageUpdateCallBack(MessageDBISAR message, String replacedMessageId) async {
    for (OXChatObserver observer in _observers) {
      observer.didChatMessageUpdateCallBack(message, replacedMessageId);
    }
  }

  void secretChatMessageCallBack(MessageDBISAR message) async {
    syncChatSessionTable(message);
    for (OXChatObserver observer in _observers) {
      observer.didSecretChatMessageCallBack(message);
    }
  }

  void channalMessageCallBack(MessageDBISAR messageDB) async {
    syncChatSessionTable(messageDB);
    for (OXChatObserver observer in _observers) {
      observer.didChannalMessageCallBack(messageDB);
    }
  }

  void groupMessageCallBack(MessageDBISAR messageDB) async {
    syncChatSessionTable(messageDB);
    for (OXChatObserver observer in _observers) {
      observer.didGroupMessageCallBack(messageDB);
    }
  }

  void messageDeleteCallback(List<MessageDBISAR> delMessages) {
    for (OXChatObserver observer in _observers) {
      observer.didMessageDeleteCallBack(delMessages);
    }
  }

  void relayGroupJoinReqCallBack(JoinRequestDBISAR joinRequestDB) async {
    for (OXChatObserver observer in _observers) {
      observer.didRelayGroupJoinReqCallBack(joinRequestDB);
    }
  }

  void relayGroupModerationCallBack(ModerationDBISAR moderationDB) async {
    for (OXChatObserver observer in _observers) {
      observer.didRelayGroupModerationCallBack(moderationDB);
    }
  }

  void messageActionsCallBack(MessageDBISAR messageDB) async {
    for (OXChatObserver observer in _observers) {
      observer.didMessageActionsCallBack(messageDB);
    }
  }

  void updateMessageDB(MessageDBISAR messageDB) async {
    if (msgIsReaded != null && msgIsReaded!(messageDB) && !messageDB.read){
      messageDB.read = true;
      Messages.saveMessageToDB(messageDB);
    }
  }

  Future<int> changeChatSessionType(ChatSessionModelISAR csModel, bool isBecomeContact) async {
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
    await ChatSessionModelISAR.saveChatSessionModelToDB(csModel);
    _updateUnReadStrangerSessionCount();
    sessionUpdate();
    return 1;
  }

  Future<void> changeChatSessionTypeAll(String pubkey, bool isBecomeContact) async {
    //strangerSession to chatSession
    bool isChange = false;
    List<ChatSessionModelISAR> list = OXChatBinding.sharedInstance.sessionMap.values.toList();
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

  Future<void> updateChatSessionDB(ChatSessionModelISAR csModel, int tempChatType) async {
    csModel.chatType = tempChatType;
    sessionMap[csModel.chatId] = csModel;
    ChatSessionModelISAR.saveChatSessionModelToDB(csModel);
  }

  Future<void> syncSessionTypesByContact() async {
    //strangerSession to chatSession
    bool isChange = false;
    List<ChatSessionModelISAR> list = OXChatBinding.sharedInstance.sessionMap.values.toList();
    for (ChatSessionModelISAR csModel in list) {
      if(csModel.chatType == ChatType.chatChannel || csModel.chatType == ChatType.chatGroup){
        continue;
      }
      isChange = true;
      int? tempChatType = csModel.chatType;
      if (csModel.chatType == ChatType.chatSecretStranger) {
        UserDBISAR? senderUserDB = Contacts.sharedInstance.allContacts[csModel.sender];
        UserDBISAR? receiverUserDB = Contacts.sharedInstance.allContacts[csModel.receiver];
        if (senderUserDB != null || receiverUserDB != null) {
          tempChatType = ChatType.chatSecret;
          await updateChatSessionDB(csModel, tempChatType);
        }
      } else if (csModel.chatType == ChatType.chatStranger) {
        UserDBISAR? chatIdUserDB = Contacts.sharedInstance.allContacts[csModel.chatId];
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

  void relayGroupsUpdatedCallBack() {
    for (OXChatObserver observer in _observers) {
      observer.didRelayGroupsUpdatedCallBack();
    }
  }

  void sessionUpdate() {
    for (OXChatObserver observer in _observers) {
      observer.didSessionUpdate();
    }
  }

  void noticePromptToneCallBack(MessageDBISAR message, int type) async {
    print('noticePromptToneCallBack');
    for (OXChatObserver observer in _observers) {
      observer.didPromptToneCallBack(message, type);
    }
  }

  void zapRecordsCallBack(ZapRecordsDBISAR zapRecordsDB) {
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

  void offlineGroupMessageFinishCallBack() {
    for (OXChatObserver observer in _observers) {
      observer.didOfflineGroupMessageFinishCallBack();
    }
  }
}
