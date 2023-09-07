import 'dart:async';
import 'dart:collection';
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/business_interface/ox_chat/custom_message_type.dart';
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

  void didSecretChatAcceptCallBack(SecretSessionDB ssDB) {}

  void didSecretChatRejectCallBack(SecretSessionDB ssDB) {}

  void didSecretChatCloseCallBack(SecretSessionDB ssDB) {}

  void didSecretChatUpdateCallBack(SecretSessionDB ssDB) {}

  void didContactUpdatedCallBack() {}

  void didCreateChannel(ChannelDB? channelDB) {}

  void didDeleteChannel(ChannelDB? channelDB) {}

  void didChannalMessageCallBack(MessageDB message) {}

  void didChannelsUpdatedCallBack() {}

  void didSessionUpdate() {}

  void didSecretChatMessageCallBack(MessageDB message) {}

  void didPromptToneCallBack(MessageDB message, int type) {}
}

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

  factory OXChatBinding() {
    return sharedInstance;
  }

  final List<OXChatObserver> _observers = <OXChatObserver>[];

  Future<void> initLocalSession() async {
    final List<ChatSessionModel> sessionList = await DB.sharedInstance.objects<ChatSessionModel>(
      orderBy: "createTime desc",
    );
    bool isRefreshSession = false;
    sessionList.forEach((e) {
      if (sessionMap[e.chatId!] == null || (sessionMap[e.chatId!] != null && (sessionMap[e.chatId!]!.createTime ?? 0) < (e.createTime ?? 0))) {
        sessionMap[e.chatId!] = e;
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
    LogUtil.e('Michael: logout clearSession');
  }

  void _updateUnReadStrangerSessionCount(){
    unReadStrangerSessionCount = sessionMap.values.fold(
      0, (int previousValue, ChatSessionModel session) {
        if (session.chatType == 4 || session.chatType == 5) {
          return previousValue + session.unreadCount;
        } else {
          return previousValue;
        }
      },
    );
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
      case MessageType.system:
        return messageDB.decryptContent ?? '';
      case MessageType.template:
        final decryptContent = messageDB.decryptContent;
        if (decryptContent != null && decryptContent.isNotEmpty) {
          try {
            final decryptedContent = json.decode(decryptContent);
            if (decryptedContent is Map) {
              final type = CustomMessageTypeEx.fromValue(decryptedContent['type']);
              switch (type) {
                case CustomMessageType.zaps:
                  return '[zaps]';
                default:
                  break ;
              }
            }
          } catch (_) { }
        }

        return '[template]';
      default:
        return '[unknown]';
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
      if (messageKind != null && sessionModel.messageKind != messageKind) {
        sessionModel.messageKind = messageKind;
        isChange = true;
      }
      if (isChange) {
        final int count = await DB.sharedInstance.insert<ChatSessionModel>(sessionModel);
        if (count > 0) {
          if (sessionModel.chatType == ChatType.chatStranger || sessionModel.chatType == ChatType.chatSecretStranger) {
            _updateUnReadStrangerSessionCount();
          }
          sessionUpdate();
          changeCount = count;
        }
      }
    }
    return changeCount;
  }

  Future<ChatSessionModel> syncChatSessionTable(MessageDB messageDB) async {
    String secretSessionId = messageDB.sessionId ?? '';
    int changeCount = 0;
    String showContent = showContentByMsgType(messageDB);
    ChatSessionModel sessionModel = ChatSessionModel(
      content: showContent,
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
      if (secretSessionId.isEmpty) {
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
      UserDB? userDB;
      if (sessionMap[chatId] != null) {
        sessionModel.chatType = sessionMap[chatId]!.chatType;
        LogUtil.e('Michael: syncChatSessionTable sessionMap[chatId] != null sessionModel.chatType =${sessionModel.chatType}--showContent=${showContent}--${chatId}');
        if (messageDB.sender != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey!) {
          if (messageDB.read != null && !messageDB.read!) {
            sessionModel.unreadCount = sessionMap[chatId]!.unreadCount! + 1;
            if (sessionModel.chatType == ChatType.chatStranger || sessionModel.chatType == ChatType.chatSecretStranger) {
              _updateUnReadStrangerSessionCount();
            }
            noticePromptToneCallBack(messageDB, sessionModel.chatType!);
          }
        }
        if (sessionMap[chatId] != null && messageDB.createTime! >= sessionMap[chatId]!.createTime!) {
          sessionMap[chatId] = sessionModel;
          final int count = await DB.sharedInstance.insert<ChatSessionModel>(sessionModel);
          if (count > 0) {
            changeCount = count;
          }
        } else {
          // old message don't update
        }
      } else {
        userDB = Contacts.sharedInstance.allContacts[otherUserPubkey];
        if (userDB == null) {
          if (otherUserPubkey != null) {
            userDB = await Account.sharedInstance.getUserInfo(otherUserPubkey);
          }
          if (secretSessionId.isEmpty) {
            sessionModel.chatType = ChatType.chatStranger;
          } else {
            sessionModel.chatType = ChatType.chatSecretStranger;
          }
        } else {
          if (secretSessionId.isEmpty) {
            sessionModel.chatType = ChatType.chatSingle;
          } else {
            sessionModel.chatType = ChatType.chatSecret;
          }
        }
        if (messageDB.sender != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey!) {
          if (messageDB.read != null && !messageDB.read!) {
            sessionModel.unreadCount = 1;
            if (sessionModel.chatType == ChatType.chatStranger || sessionModel.chatType == ChatType.chatSecretStranger) {
              _updateUnReadStrangerSessionCount();
            }
            noticePromptToneCallBack(messageDB, sessionModel.chatType!);
          }
        }
        LogUtil.e('Michael: syncChatSessionTable sessionMap[chatId] == null sessionModel.chatType =${sessionModel.chatType}---showContent=${showContent}--${chatId}');
        sessionMap[chatId] = sessionModel;
        final int count = await DB.sharedInstance.insert<ChatSessionModel>(sessionModel);
        if (count > 0) {
          changeCount = count;
        }
      }
    } else if (messageDB.groupId != null) {
      //group chat
      sessionModel.chatId = messageDB.groupId;
      if (sessionMap[messageDB.groupId] != null) {
        if (messageDB.createTime! >= sessionMap[messageDB.groupId!]!.createTime!) {
          ChannelDB? channelDB = Channels.sharedInstance.channels[messageDB.groupId!];
          if (channelDB != null) {
            //is channel
            sessionModel.avatar = channelDB.picture;
            sessionModel.chatName = channelDB.name;
            sessionModel.chatType = ChatType.chatChannel;
            sessionMap[messageDB.groupId!] = sessionModel;
            if (messageDB.sender != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey!) {
              if (messageDB.read != null && !messageDB.read!) {
                sessionModel.unreadCount = sessionMap[messageDB.groupId]!.unreadCount! + 1;
                noticePromptToneCallBack(messageDB, sessionModel.chatType!);
              }
            }
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
        if (channelDB != null) {
          sessionModel.avatar = channelDB.picture;
          sessionModel.chatName = channelDB.name;
          sessionModel.chatType = ChatType.chatChannel;
          if (messageDB.sender != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey!) {
            if (messageDB.read != null && !messageDB.read!) {
              sessionModel.unreadCount = 1;
              noticePromptToneCallBack(messageDB, sessionModel.chatType!);
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
      sessionUpdate();
    }
    return sessionModel;
  }

  Future<int> deleteSession(ChatSessionModel sessionModel, {bool isStranger = false}) async {
    sessionMap.remove(sessionModel.chatId);
    if(isStranger) {
      _updateUnReadStrangerSessionCount();
    }
    int changeCount = 0;
    final int count = await DB.sharedInstance.delete<ChatSessionModel>(where: "chatId = ?", whereArgs: [sessionModel.chatId]);
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

  Future<ChatSessionModel?> localCreateSecretChat(SecretSessionDB ssDB) async {
    if (ssDB.toPubkey == null || ssDB.toPubkey!.isEmpty) return null;
    UserDB? userDB = Contacts.sharedInstance.allContacts[ssDB.toPubkey!];
    if (userDB == null) {
      userDB = await Account.sharedInstance.getUserInfo(ssDB.toPubkey!);
    }
    final ChatSessionModel chatSessionModel = await syncChatSessionTable(
      MessageDB(
        decryptContent: 'You invited ${userDB?.name ??''} to join a secret chat',
        createTime: ssDB.lastUpdateTime,
        sender: ssDB.toPubkey,
        receiver: ssDB.myPubkey,
        sessionId: ssDB.sessionId,
      ),
    );
    return chatSessionModel;
  }

  void secretChatRequestCallBack(SecretSessionDB ssDB) async {
    if (ssDB.toPubkey == null || ssDB.toPubkey!.isEmpty) return;
    UserDB? user = await Account.sharedInstance.getUserInfo(ssDB.toPubkey!);
    if (user == null) {
      user = UserDB(pubKey: ssDB.toPubkey!);
    }
    syncChatSessionTable(MessageDB(
      decryptContent: 'You have received a secret chat request',
      createTime: ssDB.lastUpdateTime,
      sender: ssDB.toPubkey,
      receiver: ssDB.myPubkey,
      sessionId: ssDB.sessionId,
    ));
  }

  void secretChatAcceptCallBack(SecretSessionDB ssDB) async {
    UserDB? user = await Account.sharedInstance.getUserInfo(ssDB.toPubkey!);
    if (user == null) {
      user = UserDB(pubKey: ssDB.toPubkey!);
    }
    await updateChatSession(ssDB.sessionId!, content: "${user.name} has accepted your secret chat request.");
    for (OXChatObserver observer in _observers) {
      observer.didSecretChatAcceptCallBack(ssDB);
    }
  }

  void secretChatRejectCallBack(SecretSessionDB ssDB) async {
    UserDB? user = await Account.sharedInstance.getUserInfo(ssDB.toPubkey!);
    if (user == null) {
      user = UserDB(pubKey: ssDB.toPubkey!);
    }
    await updateChatSession(ssDB.sessionId, content: "${user.name} has rejected your secret chat request");
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
    sessionMap[csModel.chatId!] = csModel;
    final int count = await DB.sharedInstance.insert<ChatSessionModel>(csModel);
    _updateUnReadStrangerSessionCount();
    sessionUpdate();
    return count;
  }

  void changeChatSessionTypeAll(String pubkey, bool isBecomeContact) async {
    //strangerSession to chatSession
    bool isChange = false;
    List<ChatSessionModel> list = OXChatBinding.sharedInstance.sessionMap.values.toList();
    for (ChatSessionModel csModel in list) {
      if(csModel.chatType == ChatType.chatChannel || csModel.chatType == ChatType.chatGroup){
        continue;
      }
      if (csModel.sender == pubkey || csModel.receiver == pubkey) {
        isChange = true;
        int? tempChatType;
        if(isBecomeContact){
          tempChatType = (csModel.chatType == ChatType.chatSecretStranger ? ChatType.chatSecret : ChatType.chatSingle);
          csModel.chatType = tempChatType;
        } else {
          tempChatType = (csModel.chatType == ChatType.chatSecret ? ChatType.chatSecretStranger : ChatType.chatStranger);
          csModel.chatType = tempChatType;
        }
        sessionMap[csModel.chatId!] = csModel;
        final int count = await DB.sharedInstance.insert<ChatSessionModel>(csModel);
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

  void noticePromptToneCallBack(MessageDB message, int type) async {
    print('noticePromptToneCallBack');
    for (OXChatObserver observer in _observers) {
      observer.didPromptToneCallBack(message, type);
    }
  }
}
