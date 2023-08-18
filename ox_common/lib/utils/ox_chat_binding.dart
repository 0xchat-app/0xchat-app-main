import 'dart:async';
import 'dart:collection';
import 'package:nostr_core_dart/nostr.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/model/friend_request_history_model.dart';
import 'package:ox_common/model/stranger_session_model.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'dart:convert';

///Title: ox_chat_binding
///Description: TODO(Fill in by oOXChatObserverneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/5/17 14:45

abstract class OXChatObserver {
  void didFriendRequestCallBack() {}

  void didFriendMessageCallBack(MessageDB message) {}

  void didFriendAcceptCallBack(Alias? alias) {}

  void didFriendRemoveCallBack(Alias alias) {}

  void didContactUpdatedCallBack() {}

  void didCreateChannel(ChannelDB? channelDB) {}

  void didDeleteChannel(ChannelDB? channelDB) {}

  void didChannalMessageCallBack(MessageDB message) {}

  void didChannelsUpdatedCallBack() {}

  void didSessionUpdate() {}
}

class OXChatBinding {
  static final OXChatBinding sharedInstance = OXChatBinding._internal();

  OXChatBinding._internal();

  HashMap<String, ChatSessionModel> sessionMap = HashMap();
  HashMap<String, StrangerSessionModel> strangerSessionMap = HashMap();
  int unReadStrangerSessionCount = 0;

  factory OXChatBinding() {
    return sharedInstance;
  }

  final List<OXChatObserver> _observers = <OXChatObserver>[];

  Future<void> initLocalSession() async {
    final List<ChatSessionModel> sessionList = await DB.sharedInstance.objects<ChatSessionModel>(
      orderBy: "createTime desc",
    );
    sessionList.forEach((e) {
      if(sessionMap[e.chatId!] == null || (sessionMap[e.chatId!] != null && (sessionMap[e.chatId!]!.createTime ?? 0) < (e.createTime ?? 0))) {
        sessionMap[e.chatId!] = e;
      }
    });
    sessionUpdate();
  }

  Future<void> initLocalStrangerSession() async {
    List<StrangerSessionModel> strangerSessionList = await DB.sharedInstance.objects<StrangerSessionModel>(orderBy: "createTime desc",);
 
    strangerSessionList.forEach((e) {
      if(strangerSessionMap[e.chatId!] == null || (strangerSessionMap[e.chatId!] != null && (strangerSessionMap[e.chatId!]!.createTime ?? 0) < (e.createTime ?? 0))) {
        strangerSessionMap[e.chatId!] = e;
      }
      LogUtil.e('Michael: initLocalStrangerSession :  strangerSessionList[element.pubKey!].unreadCount = ${strangerSessionMap[e.chatId!]!.unreadCount}');
    });
    noticeFriendRequest();
  }

  void clearSession() {
    sessionMap.clear();
    LogUtil.e('Michael: logout clearSession');
  }

  void clearStrangerSessionCache() {
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
        if (showContent == null)
          showContent = decryptContent ?? '';
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

  Future<int> updateChatSession(String chatId, {String? chatName, String? pic, int? unreadCount, bool alwaysTop = false}) async {
    int changeCount = 0;
    ChatSessionModel? sessionModel = sessionMap[chatId];
    if (sessionModel != null) {
      bool isChange = false;
      if (chatName != null && chatName.isNotEmpty && sessionModel.chatName != chatName) {
        sessionModel.chatName = chatName;
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
      if(isChange) {
        final int count = await DB.sharedInstance.insert<ChatSessionModel>(sessionModel);
        if (count > 0) {
          sessionUpdate();
          changeCount = count;
        }
      }
    }
    return changeCount;
  }

  Future<void> syncChatSessionTable(MessageDB messageDB) async {
    int changeCount = 0;
    LogUtil.e('Michael: messageDB.read =${messageDB.read}');
    if (messageDB.read != null && messageDB.read!) {
      return;
    }
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
      LogUtil.e('Michael: single chat messageDB.messageId =${messageDB.messageId}');
      String chatId = '';
      if (messageDB.sender != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey! &&
          messageDB.receiver == OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey!) {
        chatId = messageDB.sender!;
      } else if (messageDB.sender == OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey! &&
          messageDB.receiver != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey!) {
        chatId = messageDB.receiver!;
      } else {
        chatId = messageDB.sender!;
      }
      sessionModel.chatId = chatId;
      sessionModel.chatType = ChatType.chatSingle;
      final UserDB? friendUserDB = Contacts.sharedInstance.allContacts[chatId];
      if (friendUserDB != null) {
        sessionModel.chatName = friendUserDB.nickName != null && friendUserDB.nickName!.isNotEmpty ? friendUserDB.nickName! : (friendUserDB.name ?? '');
        sessionModel.avatar = friendUserDB.picture;
        if (sessionMap[chatId] != null) {
          if (messageDB.sender != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey!) {
            sessionModel.unreadCount = sessionMap[chatId]!.unreadCount! + 1;
          }
          LogUtil.e('Michael: messageDB.createTime =${messageDB.createTime}');
          LogUtil.e('Michael: sessionMap[chatId]!.createTime! =${sessionMap[chatId]!.createTime}');
          if (messageDB.createTime! >= sessionMap[chatId]!.createTime!) {
            sessionMap[chatId] = sessionModel;
            final int count = await DB.sharedInstance.insert<ChatSessionModel>(sessionModel);
            if (count > 0) {
              changeCount = count;
            }
          } else {
            // old message don't update
          }
        } else {
          if (messageDB.sender != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey!) {
            sessionModel.unreadCount = 1;
          }
          sessionMap[chatId] = sessionModel;
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
          sessionModel.unreadCount = sessionMap[messageDB.groupId]!.unreadCount! + 1;
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
            sessionModel.unreadCount = 1;
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
  }

  Future<int> deleteSession(ChatSessionModel chatSessionModel) async {
    sessionMap.remove(chatSessionModel.chatId);
    int changeCount = 0;
    final int count = await DB.sharedInstance.delete<ChatSessionModel>(where: "chatId = ?", whereArgs: [chatSessionModel.chatId]);
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

  void friendAcceptCallBack(Alias? alias) {
    for (OXChatObserver observer in _observers) {
      observer.didFriendAcceptCallBack(alias);
    }
  }

  void friendRemoveCallBack(Alias alias) {
    for (OXChatObserver observer in _observers) {
      observer.didFriendRemoveCallBack(alias);
    }
  }

  void friendMessageCallBack(MessageDB message) async {
    OXChatBinding.sharedInstance.syncChatSessionTable(message);
    for (OXChatObserver observer in _observers) {
      observer.didFriendMessageCallBack(message);
    }
  }

  void secretChatRequestCallBack(SecretSessionDB alias) async {
    Map usersMap = await Account.syncProfilesFromRelay([alias.toPubkey]);
    UserDB? user = usersMap[alias.toPubkey];
    if (user == null) {
      user = UserDB(pubKey: alias.toPubkey);
    }
    user.aliasPubkey = alias.toAliasPubkey;
    UserDB? friendUserDB = Contacts.sharedInstance.allContacts[user.pubKey];
    FriendRequestHistoryModel? friendRequestHistoryModel = strangerSessionMap[user.pubKey];
    if (friendRequestHistoryModel == null) {
      friendRequestHistoryModel = FriendRequestHistoryModel(
        pubKey: user.pubKey,
        name: user.name,
        picture: user.picture,
        isRead: friendUserDB == null ? 0 : 1,
        status: friendUserDB == null ? 0 : 1,
        sourceType: 0,
        requestTime: alias.createTime * 1000,
        aliasPubkey: user.aliasPubkey,
      );
    } else {
      if(strangerSessionMap[user.pubKey!]!.requestTime > alias.createTime * 1000){
        //Don't update if new callback time is less than original request time.
        return;
      }
      friendRequestHistoryModel.name = user.name;
      friendRequestHistoryModel.picture = user.picture;
      friendRequestHistoryModel.isRead = friendUserDB == null ? 0 : 1;
      friendRequestHistoryModel.status = friendUserDB == null ? 0 : 1;
      friendRequestHistoryModel.sourceType = 0;
      friendRequestHistoryModel.requestTime = alias.createTime * 1000;
      friendRequestHistoryModel.aliasPubkey = user.aliasPubkey;
    }
    strangerSessionMap[user.pubKey!] = friendRequestHistoryModel;
    historyList = strangerSessionMap.values.toList();
    unReadFriendRequestCount = historyList.where((item) => item.isRead == 0 ).length;

    final int count = await FriendRequestHistoryModel.saveFriendRequestToDB(friendRequestHistoryModel);
    noticeFriendRequest();
  }

  void updateFriendRequestHistory(FriendRequestHistoryModel friendRequestHistoryModel) async {
    final int count = await FriendRequestHistoryModel.saveFriendRequestToDB(friendRequestHistoryModel);
    unReadFriendRequestCount = historyList.where((item) => item.isRead == 0).length;
    noticeFriendRequest();
  }

  void setAllFriendRequestAsRead() async {
    await Future.forEach(historyList, (element) async {
      element.isRead = 1;
      await FriendRequestHistoryModel.saveFriendRequestToDB(element);
    });
    unReadFriendRequestCount = historyList.where((item) => item.isRead == 0).length;
    noticeFriendRequest();
  }

  void noticeFriendRequest(){
    for (OXChatObserver observer in _observers) {
      observer.didFriendRequestCallBack();
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
}
