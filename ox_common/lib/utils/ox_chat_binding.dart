import 'dart:async';
import 'dart:collection';
import 'package:nostr_core_dart/nostr.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'dart:convert';

///Title: ox_chat_binding
///Description: TODO(Fill in by OXChat)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/5/17 14:45

abstract class OXChatObserver {
  void didSecretChatRequestCallBack() {}

  void didPrivateMessageCallBack(MessageDB message) {}

  void didStrangerPrivateMessageCallBack(MessageDB message) {}

  void didSecretChatAcceptCallBack(SecretSessionDB ssDB) {}

  void didSecretChatRejectCallBack(SecretSessionDB ssDB) {}

  void didSecretChatCloseCallBack(SecretSessionDB ssDB) {}

  void didContactUpdatedCallBack() {}

  void didCreateChannel(ChannelDB? channelDB) {}

  void didDeleteChannel(ChannelDB? channelDB) {}

  void didChannalMessageCallBack(MessageDB message) {}

  void didChannelsUpdatedCallBack() {}

  void didSessionUpdate() {}

  void didSecretChatMessageCallBack(MessageDB message) {}

  void didStrangerSessionUpdate() {}
}

class OXChatBinding {
  static final OXChatBinding sharedInstance = OXChatBinding._internal();

  OXChatBinding._internal();

  HashMap<String, ChatSessionModel> sessionMap = HashMap();
  HashMap<String, ChatSessionModel> strangerSessionMap = HashMap();
  int unReadStrangerSessionCount = 0;

  factory OXChatBinding() {
    return sharedInstance;
  }

  final List<OXChatObserver> _observers = <OXChatObserver>[];

  Future<void> initLocalSession() async {
    final List<ChatSessionModel> sessionList = await DB.sharedInstance.objects<ChatSessionModel>(
      orderBy: "createTime desc",
    );
    bool isRefreshSession = false;
    bool isRefreshStrangerSession = false;
    sessionList.forEach((e) {
      if (e.chatType == ChatType.chatStranger || e.chatType == ChatType.chatSecretStranger) {
        if (strangerSessionMap[e.chatId!] == null ||
            (strangerSessionMap[e.chatId!] != null && (strangerSessionMap[e.chatId!]!.createTime ?? 0) < (e.createTime ?? 0))) {
          strangerSessionMap[e.chatId!] = e;
          isRefreshStrangerSession = true;
        }
      } else {
        if (sessionMap[e.chatId!] == null || (sessionMap[e.chatId!] != null && (sessionMap[e.chatId!]!.createTime ?? 0) < (e.createTime ?? 0))) {
          sessionMap[e.chatId!] = e;
          isRefreshSession = true;
        }
      }
    });
    if (isRefreshSession) {
      sessionUpdate();
    }
    if (isRefreshStrangerSession) {
      strangerSessionUpdate();
    }
  }

  void clearSession() {
    sessionMap.clear();
    strangerSessionMap.clear();
    unReadStrangerSessionCount = 0;
    LogUtil.e('Michael: logout clearSession');
  }

  String showContentByMsgType(MessageDB messageDB) {
    switch (MessageDB.stringtoMessageType(messageDB.type!)) {
      case MessageType.text:
        String? showContent;
        final decryptContent = messageDB.decryptContent;
        if (decryptContent != null && decryptContent.isNotEmpty) {
          try {
            final decryptedContent = json.decode(decryptContent);
            if (decryptedContent is Map) {
              showContent = decryptedContent['content'] as String;
            } else {
              showContent = decryptedContent.toString();
            }
          } catch (e) {
            LogUtil.e('Michael：MessageType.text =${e.toString()}');
          }
        }
        if (showContent == null) showContent = decryptContent ?? '';
        return showContent;
      case MessageType.image:
      case MessageType.encryptedImage:
        return '[image]';
      case MessageType.video:
      case MessageType.encryptedVideo:
        return '[video]';
      case MessageType.audio:
      case MessageType.encryptedAudio:
        return '[audio]';
      case MessageType.file:
      case MessageType.encryptedFile:
        return '[file]';
      case MessageType.template:
        return 'template';
      default:
        return 'unknown';
    }
  }

  Future<int> updateChatSession(String chatId, {String? chatName, String? content, String? pic, int? unreadCount, bool alwaysTop = false}) async {
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
        isChange = true;
      }
      if (alwaysTop != sessionModel.alwaysTop) {
        sessionModel.alwaysTop = alwaysTop;
        isChange = true;
      }
      if (isChange) {
        final int count = await DB.sharedInstance.insert<ChatSessionModel>(sessionModel);
        if (count > 0) {
          if (sessionModel.chatType == ChatType.chatSingle || sessionModel.chatType == ChatType.chatChannel || sessionModel.chatType == ChatType.chatSecret) {
            sessionUpdate();
          } else {
            strangerSessionUpdate();
          }
          changeCount = count;
        }
      }
    }
    return changeCount;
  }

  Future<ChatSessionModel> syncChatSessionTable(MessageDB messageDB, {String? secretSessionId}) async {
    int changeCount = 0;
    ChatSessionModel sessionModel = ChatSessionModel(
      content: showContentByMsgType(messageDB),
      createTime: messageDB.createTime,
      messageType: messageDB.type!,
      receiver: messageDB.receiver,
      sender: messageDB.sender,
      groupId: messageDB.groupId,
    );
    if (messageDB.receiver != null && messageDB.receiver!.isNotEmpty) {
      //single chat
      String chatId = '';
      String? otherUserPubkey;
      if (secretSessionId == null) {
        if (messageDB.sender != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey! &&
            messageDB.receiver == OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey!) {
          chatId = messageDB.sender!;
          otherUserPubkey = messageDB.sender;
        } else if (messageDB.sender == OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey! &&
            messageDB.receiver != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey!) {
          chatId = messageDB.receiver!;
          otherUserPubkey = messageDB.receiver;
        } else {
          chatId = messageDB.sender!;
          otherUserPubkey = messageDB.sender;
        }
      } else {
        chatId = secretSessionId;
        SecretSessionDB? ssDB = Contacts.sharedInstance.secretSessionMap[secretSessionId];
        if (ssDB != null) {
          otherUserPubkey = ssDB.toPubkey;
        }
      }
      sessionModel.chatId = chatId;
      UserDB? userDB = Contacts.sharedInstance.allContacts[otherUserPubkey];
      if (userDB == null) {
        if (otherUserPubkey != null) {
          userDB = await Account.getUserFromDB(pubkey: otherUserPubkey);
        }
        if (secretSessionId == null) {
          sessionModel.chatType = ChatType.chatStranger;
        } else {
          sessionModel.chatType = ChatType.chatSecretStranger;
        }
      } else {
        if (secretSessionId == null) {
          sessionModel.chatType = ChatType.chatSingle;
        } else {
          sessionModel.chatType = ChatType.chatSecret;
        }
      }
      if (userDB != null) {
        sessionModel.chatName = userDB.nickName != null && userDB.nickName!.isNotEmpty ? userDB.nickName! : (userDB.name ?? '');
        sessionModel.avatar = userDB.picture;
        if (sessionMap[chatId] != null || strangerSessionMap[chatId] != null) {
          if (messageDB.sender != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey!) {
            if (messageDB.read != null && !messageDB.read!) {
              if (sessionMap[chatId] != null) {
                sessionModel.unreadCount = sessionMap[chatId]!.unreadCount! + 1;
              } else {
                sessionModel.unreadCount = strangerSessionMap[chatId]!.unreadCount! + 1;
              }
            }
          }
          if ((sessionMap[chatId] != null && messageDB.createTime! >= sessionMap[chatId]!.createTime!)
              || (strangerSessionMap[chatId] != null && messageDB.createTime! >= strangerSessionMap[chatId]!.createTime!)) {
            if (sessionModel.chatType == ChatType.chatSingle || sessionModel.chatType == ChatType.chatSecret) {
              sessionMap[chatId] = sessionModel;
            } else {
              strangerSessionMap[chatId] = sessionModel;
            }
            final int count = await DB.sharedInstance.insert<ChatSessionModel>(sessionModel);
            if (count > 0) {
              changeCount = count;
            }
          } else {
            // old message don't update
          }
        } else {
          if (messageDB.sender != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey!) {
            if (messageDB.read != null && !messageDB.read!) {
              sessionModel.unreadCount = 1;
            }
          }
          if (sessionModel.chatType == ChatType.chatSingle || sessionModel.chatType == ChatType.chatSecret) {
            sessionMap[chatId] = sessionModel;
          } else {
            strangerSessionMap[chatId] = sessionModel;
          }
          final int count = await DB.sharedInstance.insert<ChatSessionModel>(sessionModel);
          if (count > 0) {
            changeCount = count;
          }
        }
      }
    } else if (messageDB.groupId != null) {
      //group chat
      sessionModel.chatId = messageDB.groupId;
      LogUtil.e('Michael: group chat messageDB.groupId =${messageDB.groupId}');
      if (sessionMap[messageDB.groupId] != null) {
        if (messageDB.sender != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey!) {
          if (messageDB.read != null && !messageDB.read!) {
            sessionModel.unreadCount = sessionMap[messageDB.groupId]!.unreadCount! + 1;
          }
        }
        LogUtil.e('Michael: group messageDB.createTime =${messageDB.createTime}');
        LogUtil.e('Michael: group sessionMap[chatId]!.createTime! =${sessionMap[sessionModel.chatId]!.createTime}');
        if (messageDB.createTime! >= sessionMap[messageDB.groupId!]!.createTime!) {
          ChannelDB? channelDB = Channels.sharedInstance.channels[messageDB.groupId!];
          LogUtil.e('Michael: group chat channelDB =${channelDB}');
          if (channelDB != null) {
            //is channel
            sessionModel.avatar = channelDB.picture;
            sessionModel.chatName = channelDB.name;
            sessionModel.chatType = ChatType.chatChannel;
            sessionMap[messageDB.groupId!] = sessionModel;
            final int count = await DB.sharedInstance.insert<ChatSessionModel>(sessionModel);
            if (count > 0) {
              changeCount = count;
            }
          } else {
            // is group or other chat
          }
        } else {
          // old message don't update
        }
      } else {
        ChannelDB? channelDB = Channels.sharedInstance.channels[messageDB.groupId!];
        LogUtil.e('Michael: group sessionMap[groupId] is null, syncChatSessionTable channelDB =${channelDB}');
        if (channelDB != null) {
          sessionModel.avatar = channelDB.picture;
          sessionModel.chatName = channelDB.name;
          sessionModel.chatType = ChatType.chatChannel;
          if (messageDB.sender != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey!) {
            if (messageDB.read != null && !messageDB.read!) {
              sessionModel.unreadCount = 1;
            }
          }
          sessionMap[messageDB.groupId!] = sessionModel;
          final int count = await DB.sharedInstance.insert<ChatSessionModel>(sessionModel);
          if (count > 0) {
            changeCount = count;
          }
        } else {
          // group's pic or other chat's pic
        }
      }
    }
    if (changeCount > 0) {
      if (sessionModel.chatType == ChatType.chatSingle || sessionModel.chatType == ChatType.chatChannel || sessionModel.chatType == ChatType.chatSecret) {
        sessionUpdate();
      } else {
        strangerSessionUpdate();
      }
    }
    return sessionModel;
  }

  Future<int> deleteSession(ChatSessionModel sessionModel, {bool isStranger = false}) async {
    if (isStranger) {
      strangerSessionMap.remove(sessionModel.chatId);
    } else {
      sessionMap.remove(sessionModel.chatId);
    }
    int changeCount = 0;
    final int count = await DB.sharedInstance.delete<ChatSessionModel>(where: "chatId = ?", whereArgs: [sessionModel.chatId]);
    if (count > 0) {
      changeCount = count;
    }
    return changeCount;
  }

  Future<int> updateSession(ChatSessionModel chatSessionModel) async {
    int changeCount = 0;
    final int count = await DB.sharedInstance.update<ChatSessionModel>(chatSessionModel);
    if (count > 0) {
      changeCount = count;
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

  Future<ChatSessionModel?> localCreateSecretChat(SecretSessionDB ssDB) async {
    if (ssDB.toPubkey == null || ssDB.toPubkey!.isEmpty) return null;
    UserDB? userDB = Contacts.sharedInstance.allContacts[ssDB.toPubkey!];
    if (userDB == null) {
      userDB = await Account.getUserFromDB(pubkey: ssDB.toPubkey!);
    }
    final ChatSessionModel chatSessionModel = await syncChatSessionTable(
      MessageDB(
        decryptContent: 'You invited ${userDB?.name ??''} to join a secret chat',
        createTime: ssDB.lastUpdateTime,
        sender: ssDB.toPubkey,
        receiver: ssDB.myPubkey,
      ),
      secretSessionId: ssDB.sessionId,
    );
    return chatSessionModel;
  }

  void secretChatRequestCallBack(SecretSessionDB ssDB) async {
    if (ssDB.toPubkey == null || ssDB.toPubkey!.isEmpty) return;
    Map usersMap = await Account.syncProfilesFromRelay([ssDB.toPubkey!]);
    UserDB? user = usersMap[ssDB.toPubkey];
    if (user == null) {
      user = UserDB(pubKey: ssDB.toPubkey!);
    }
    syncChatSessionTable(MessageDB(
      decryptContent: 'You have received a secret chat request',
      createTime: ssDB.lastUpdateTime,
      sender: ssDB.toPubkey,
      receiver: ssDB.myPubkey,
    ), secretSessionId: ssDB.sessionId);
  }

  void secretChatAcceptCallBack(SecretSessionDB ssDB) async {
    Map usersMap = await Account.syncProfilesFromRelay([ssDB.toPubkey!]);
    UserDB? user = usersMap[ssDB.toPubkey];
    if (user == null) {
      user = UserDB(pubKey: ssDB.toPubkey!);
    }
    await updateChatSession(ssDB.sessionId!, content: "Prompt: [${user.name}] has accepted your secret chat request.");
    for (OXChatObserver observer in _observers) {
      observer.didSecretChatAcceptCallBack(ssDB);
    }
  }

  void secretChatRejectCallBack(SecretSessionDB ssDB) async {
    Map usersMap = await Account.syncProfilesFromRelay([ssDB.toPubkey!]);
    UserDB? user = usersMap[ssDB.toPubkey];
    if (user == null) {
      user = UserDB(pubKey: ssDB.toPubkey!);
    }
    await updateChatSession(ssDB.sessionId, content: "Prompt: [${user.name}] has rejected your secret chat request");
    for (OXChatObserver observer in _observers) {
      observer.didSecretChatRejectCallBack(ssDB);
    }
  }

  void secretChatUpdateCallBack(SecretSessionDB ssDB) {
    for (OXChatObserver observer in _observers) {
      observer.didSecretChatCloseCallBack(ssDB);
    }
  }

  void secretChatCloseCallBack(SecretSessionDB ssDB) {
    for (OXChatObserver observer in _observers) {
      observer.didSecretChatCloseCallBack(ssDB);
    }
  }

  void privateChatMessageCallBack(MessageDB message, {String? secretSessionId}) async {
    syncChatSessionTable(message, secretSessionId: secretSessionId);
    for (OXChatObserver observer in _observers) {
      observer.didPrivateMessageCallBack(message);
    }
  }

  void secretChatMessageCallBack(MessageDB message, {String? secretSessionId}) async {
    syncChatSessionTable(message, secretSessionId: secretSessionId);
    for (OXChatObserver observer in _observers) {
      observer.didSecretChatMessageCallBack(message);
    }
  }

  void changeChatSessionTypeAll(String pubkey, bool isBecomeContact) async {
    //strangerSession to chatSession
    bool isChange = false;
    List<ChatSessionModel> list = isBecomeContact ? OXChatBinding.sharedInstance.strangerSessionMap.values.toList() : OXChatBinding.sharedInstance.sessionMap.values.toList();
    for (ChatSessionModel csModel in list) {
      if (csModel.sender == pubkey || csModel.receiver == pubkey) {
        isChange = true;
        int? tempChatType;
        if(isBecomeContact){
          tempChatType = (csModel.chatType == ChatType.chatSecretStranger ? ChatType.chatSecret : ChatType.chatSingle);
          csModel.chatType = tempChatType;
          strangerSessionMap.remove(csModel.chatId);
          sessionMap[csModel.chatId!] = csModel;
        } else {
          tempChatType = (csModel.chatType == ChatType.chatSecret ? ChatType.chatSecretStranger : ChatType.chatStranger);
          csModel.chatType = tempChatType;
          sessionMap.remove(csModel.chatId);
          strangerSessionMap[csModel.chatId!] = csModel;
        }
        final int count = await DB.sharedInstance.insert<ChatSessionModel>(csModel);
      }
    }
    if (isChange) {
      strangerSessionUpdate();
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

  void channalMessageCallBack(MessageDB messageDB) async {
    OXChatBinding.sharedInstance.syncChatSessionTable(messageDB);
    for (OXChatObserver observer in _observers) {
      observer.didChannalMessageCallBack(messageDB);
    }
  }

  void sessionUpdate() {
    for (OXChatObserver observer in _observers) {
      observer.didSessionUpdate();
    }
  }

  void strangerSessionUpdate() {
    for (OXChatObserver observer in _observers) {
      observer.didStrangerSessionUpdate();
    }
  }

  void syncChatSessionForSendMsg({
    required int createTime,
    required String content,
    required MessageType type,
    String decryptContent = '',
    String receiver = '',
    String groupId = '',
  }) async {
    final sender = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey;
    if (sender == null) {
      LogUtil.e('oxchat_binding syncChatSessionForSendMsg  :   sender is null');
      return;
    }

    final time = (createTime / 1000).round();

    final messageDB = MessageDB(
      sender: sender,
      receiver: receiver,
      groupId: groupId,
      createTime: time,
      content: content,
      decryptContent: decryptContent,
      read: true,
      type: MessageDB.messageTypeToString(type),
    );

    OXChatBinding.sharedInstance.syncChatSessionTable(messageDB);
  }
}
