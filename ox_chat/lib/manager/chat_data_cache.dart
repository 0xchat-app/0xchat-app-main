
import 'dart:async';

import 'package:uuid/uuid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat/manager/chat_data_manager_models.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_chat/manager/chat_user_cache.dart';
import 'package:ox_chat/utils/chat_log_utils.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';

class ChatDataCache with OXChatObserver {

  static final ChatDataCache shared = ChatDataCache._internal();

  ChatDataCache._internal() {
    OXChatBinding.sharedInstance.addObserver(this);
    initTimer();
  }

  Completer<Map<ChatTypeKey, List<types.Message>>> _privateChatMessageMap = Completer();

  Completer<Map<ChannelKey, List<types.Message>>> _channelMessageMap = Completer();

  Map<ChatTypeKey, ValueChanged<List<types.Message>>> _valueChangedCallback = {};

  Set<String> messageIdCache = {};

  late Timer syncUserInfoTimer;
  Map<String, List<types.Message>> unknownMessageMap = {};
  List<String> unknownUserPubkeyCache = [];

  setup() async {
    messageIdCache.clear();
    unknownUserPubkeyCache.clear();
    if (_privateChatMessageMap.isCompleted) {
      _privateChatMessageMap = Completer();
    }
    if (_channelMessageMap.isCompleted) {
      _channelMessageMap = Completer();
    }
    await _setupPrivateChatMessages();
    await _setupChannelMessages();
  }

  initTimer() {
    syncUserInfoTimer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      _updateUnknownUserInfo();
    });
  }

  Future<List<types.Message>> getSessionMessage(ChatSessionModel session) async {
    if (session.chatType == ChatType.chatSingle || session.chatType == ChatType.chatSecret || session.chatType == ChatType.chatStranger
    || session.chatType == ChatType.chatSecretStranger) {
      return await _getPrivateChatMessage(session);
    } else if (session.chatType == ChatType.chatChannel) {
      return await _getChannelMessage(session);
    }
    ChatLogUtils.error(className: 'ChatDataCache', funcName: 'getSessionMessage', message: 'unknown chatType');
    return Future.value([]);
  }

  Future<List<types.Message>> _getPrivateChatMessage(ChatSessionModel session) async {
    final privateChatKey = _getChatTypeKey(session);
    if (privateChatKey == null) {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: 'getPrivateChatMessage', message: 'privateChatKey is null');
      return [];
    }
    final messageMap = await _privateChatMessageMap.future;
    return messageMap[privateChatKey] ?? [];
  }

  Future<List<types.Message>> _getChannelMessage(ChatSessionModel session) async {
    final channelKey = _getChatTypeKey(session);
    if (channelKey == null) {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: 'getChannelMessage', message: 'channelKey is null');
      return [];
    }
    Map<ChannelKey, List<types.Message>> messageMap = await _channelMessageMap.future;
    return messageMap[channelKey] ?? [];
  }

  @override
  void didPrivateMessageCallBack(MessageDB message) {
    receivePrivateMessageHandler(message);
  }

  @override
  void didStrangerPrivateMessageCallBack(MessageDB message) {
    receivePrivateMessageHandler(message);
  }

  Future receivePrivateMessageHandler(MessageDB message) async {
    ChatLogUtils.info(
      className: 'ChatDataCache',
      funcName: 'didFriendMessageCallBack',
      message: 'begin',
    );

    final senderId = message.sender;
    final receiverId = message.receiver;
    if (senderId == null || receiverId == null) {
      ChatLogUtils.error(
        className: 'ChatDataCache',
        funcName: 'receivePrivateMessageHandler',
        message: 'senderId($senderId) or receiverId($receiverId) is null',
      );
      return ;
    }
    final key = PrivateChatKey(senderId, receiverId);

    types.Message? msg = await message.toChatUIMessage();
    if (msg == null) {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: 'receivePrivateMessageHandler', message: 'message is null');
      return ;
    }

    await _addPrivateChatMessages(key, msg);
  }

  @override
  void didSecretChatMessageCallBack(MessageDB message) async {
    ChatLogUtils.info(
      className: 'ChatDataCache',
      funcName: 'didFriendMessageCallBack',
      message: 'begin',
    );

    final sessionId = message.sessionId;
    if (sessionId == null) {
      ChatLogUtils.error(
        className: 'ChatDataCache',
        funcName: 'didSecretChatMessageCallBack',
        message: 'sessionId($sessionId) is null',
      );
      return ;
    }
    final key = SecretChatKey(sessionId);

    types.Message? msg = await message.toChatUIMessage();
    if (msg == null) {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: 'didSecretChatMessageCallBack', message: 'message is null');
      return ;
    }

    await _addPrivateChatMessages(key, msg);
  }

  @override
  void didChannalMessageCallBack(MessageDB message) async {
    final groupId = message.groupId;
    if (groupId == null) {
      ChatLogUtils.error(
        className: 'ChatDataCache',
        funcName: 'didChannalMessageCallBack',
        message: 'groupId is null',
      );
      return ;
    }
    ChannelKey key = ChannelKey(groupId);

    types.Message? msg = await message.toChatUIMessage();
    if (msg == null) {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: 'didChannalMessageCallBack', message: 'message is null');
      return ;
    }

    await _addChannelMessages(key, msg);
  }

  @override
  void didSecretChatAcceptCallBack(SecretSessionDB ssDB) async {
    final toPubkey = ssDB.toPubkey ?? '';
    final sessionModel = OXChatBinding.sharedInstance.sessionMap[ssDB.sessionId];
    if (sessionModel == null || toPubkey.isEmpty) {
      ChatLogUtils.error(
        className: 'ChatDataCache',
        funcName: 'didSecretChatAcceptCallBack',
        message: 'sessionModel: $sessionModel, toPubkey: $toPubkey',
      );
      return ;
    }
    final toUser = await ChatUserCache.shared.getUserDB(toPubkey);
    final userName = toUser.getUserShowName();
    addSystemMessage('$userName joined Secret Chat', sessionModel);
  }

  Future addSystemMessage(String text, ChatSessionModel session) async {

    // author
    UserDB? userDB = OXUserInfoManager.sharedInstance.currentUserInfo;
    if (userDB == null) {
      return ;
    }
    final author = types.User(
      id: userDB.pubKey,
      sourceObject: userDB,
    );

    // create time
    int tempCreateTime = DateTime.now().millisecondsSinceEpoch;
    // id
    String message_id = const Uuid().v4();

    final message = types.SystemMessage(
      author: author,
      createdAt: tempCreateTime,
      id: message_id,
      roomId: session.chatId,
      text: text,
    );

    addNewMessage(session, message);
  }
}

extension ChatDataCacheMessageOptionEx on ChatDataCache {

  Future<void> addNewMessage(ChatSessionModel session, types.Message message) async {
    final key = _getChatTypeKey(session);
    if (key == null) {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: 'addNewMessage', message: 'ChatTypeKey is null');
      return ;
    }

    ChatLogUtils.info(className: 'ChatDataCache', funcName: 'addNewMessage', message: 'session: ${session.chatId}, key: $key');
    if (key is PrivateChatKey || key is SecretChatKey) {
      await _addPrivateChatMessages(key, message);
    } else if (key is ChannelKey) {
      await _addChannelMessages(key, message);
    } else {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: 'addNewMessage', message: 'unknown chatType');
    }
  }

  Future<void> deleteMessage(ChatSessionModel session, types.Message message) async {
    final key = _getChatTypeKey(session);
    if (key == null) {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: 'deleteMessage', message: 'ChatTypeKey is null');
      return ;
    }

    ChatLogUtils.info(className: 'ChatDataCache', funcName: 'deleteMessage', message: 'session: ${session.chatId}, key: $key');
    if (key is PrivateChatKey || key is SecretChatKey) {
      await _removePrivateChatMessages(key, message);
      await notifyPrivateChatObserverValueChanged(key);
    } else if (key is ChannelKey) {
      await _removeChannelMessages(key, message);
      await notifyChannelObserverValueChanged(key);
    } else {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: 'deleteMessage', message: 'unknown chatType');
    }
  }

  Future<void> resendMessage(ChatSessionModel session, types.Message message) async {
    final key = _getChatTypeKey(session);
    if (key == null) {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: 'resendMessage', message: 'ChatTypeKey is null');
      return ;
    }

    ChatLogUtils.info(className: 'ChatDataCache', funcName: 'resendMessage', message: 'session: ${session.chatId}, key: $key');
    if (key is PrivateChatKey || key is SecretChatKey) {
      await _removePrivateChatMessages(key, message);
      await _addPrivateChatMessages(key, message);
      await notifyPrivateChatObserverValueChanged(key);
    } else if (key is ChannelKey) {
      await _removeChannelMessages(key, message);
      await _addChannelMessages(key, message);
      await notifyChannelObserverValueChanged(key);
    } else {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: 'resendMessage', message: 'unknown chatType');
    }
  }

  Future<void> updateMessage(ChatSessionModel session, types.Message message) async {
    final key = _getChatTypeKey(session);
    if (key == null) {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: 'updateMessage', message: 'ChatTypeKey is null');
      return ;
    }

    if (key is PrivateChatKey || key is SecretChatKey) {
      await _updatePrivateChatMessages(key, message);
      await notifyPrivateChatObserverValueChanged(key);
    } else if (key is ChannelKey) {
      await _updateChannelMessages(key, message);
      await notifyChannelObserverValueChanged(key);
    } else {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: 'addNewMessage', message: 'unknown chatType');
    }
  }
}

extension ChatDataCacheObserverEx on ChatDataCache {
  void addObserver(ChatSessionModel session, ValueChanged<List<types.Message>> valueChangedCallback) {
    final key = _getChatTypeKey(session);
    if (key != null) {
      _valueChangedCallback[key] = valueChangedCallback;
    } else {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: 'addObserver', message: 'chatTypeKey is null');
    }
  }

  void removeObserver(ChatSessionModel session) {
    final key = _getChatTypeKey(session);
    if (key != null) {
      _valueChangedCallback.remove(key);
    } else {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: 'removeObserver', message: 'chatTypeKey is null');
    }
  }

  Future<void> notifyAllObserverValueChanged() async {
    final valueChangedCallback = _valueChangedCallback;
    valueChangedCallback.forEach((key, callback) async {
      List<types.Message> messages = [];
      if (key is PrivateChatKey || key is SecretChatKey) {
        messages = (await _privateChatMessageMap.future)[key] ?? [];
      } else if (key is ChannelKey) {
        messages = (await _channelMessageMap.future)[key] ?? [];
      }
      callback(messages);
    });
  }

  Future<void> notifyPrivateChatObserverValueChanged(ChatTypeKey key) async {
    final callback = _valueChangedCallback[key];
    ChatLogUtils.info(className: 'ChatDataCache', funcName: 'notifyPrivateChatObserverValueChanged', message: 'callback: $callback');
    if (callback != null) {
      final messages = (await _privateChatMessageMap.future)[key] ?? [];
      callback(messages);
    }
  }

  Future<void> notifyChannelObserverValueChanged(ChannelKey key) async {
    final callback = _valueChangedCallback[key];
    ChatLogUtils.info(className: 'ChatDataCache', funcName: 'notifyChannelObserverValueChanged', message: 'key: $key, callback: $callback');
    if (callback != null) {
      final messages = (await _channelMessageMap.future)[key] ?? [];
      callback(messages);
    }
  }
}

extension ChatDataCacheSessionEx on ChatDataCache {
  Future<List<ChatSessionModel>> _privateChatSessionList() async {
    final List<ChatSessionModel> sessionList = await DB.sharedInstance.objects<ChatSessionModel>(
      orderBy: "createTime desc",
    );
    return sessionList.where((session) => (session.chatType == ChatType.chatSingle || session.chatType == ChatType.chatSecret || session.chatType == ChatType.chatSecretStranger || session.chatType == ChatType.chatStranger)).toList();
  }

  Future<List<ChatSessionModel>> _channelSessionList() async {
    final List<ChatSessionModel> sessionList = await DB.sharedInstance.objects<ChatSessionModel>(
      orderBy: "createTime desc",
    );
    return sessionList.where((session) => session.chatType == ChatType.chatChannel).toList();
  }

  ChatTypeKey? _convertSessionToPrivateChatKey(ChatSessionModel session) {
    final senderId = session.sender;
    final receiverId = session.receiver;
    if (senderId == null || receiverId == null) {
      ChatLogUtils.error(
        className: 'ChatDataCache',
        funcName: '_convertSessionToPrivateChatKey',
        message: 'senderId:$senderId, receiverId: $receiverId',
      );
      return null;
    }
    return PrivateChatKey(senderId, receiverId);
  }

  ChannelKey? _convertSessionToChannelKey(ChatSessionModel session) {
    final groupId = session.groupId;
    if (groupId == null) {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: '_convertSessionToChannelKey', message: 'groupId is null');
      return null;
    }
    return ChannelKey(groupId);
  }

  ChatTypeKey? _convertSessionToSecretChatKey(ChatSessionModel session) {
    final sessionId = session.chatId;
    if (sessionId == null) {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: '_convertSessionToSecretChatKey', message: 'session is null');
      return null;
    }
    return SecretChatKey(sessionId);
  }

  Future setSessionAllMessageIsRead(ChatSessionModel session) async {
    final chatTypeKey = _getChatTypeKey(session);
    if (chatTypeKey == null) return ;
    await Messages.updateMessagesReadStatus(
      chatTypeKey.getSQLFilter(),
      chatTypeKey.getSQLFilterArgs(),
      true,
    );
  }
}

extension ChatDataCachePrivateChatEx on ChatDataCache {

  Future<void> _setupPrivateChatMessages() async {
    List<ChatSessionModel> sessionList = await _privateChatSessionList();
    Map<ChatTypeKey, List<types.Message>> privateChatMessagesMap = {};
    await Future.forEach(sessionList, (session) async {
      final key = _getChatTypeKey(session);
      if (key == null) {
        ChatLogUtils.error(className: 'ChatDataCache', funcName: '_setupPrivateChatMessages', message: 'privateChatKey is null');
        return ;
      }

      final messageList = await _loadPrivateChatMessages(key);

      messageIdCache.addAll(messageList.map((e) => e.id));

      privateChatMessagesMap[key] = messageList;

      tryAddUnknownPubkey(messageList);
    });

    _privateChatMessageMap.complete(privateChatMessagesMap);

    ChatLogUtils.info(className: 'ChatDataCache', funcName: '_setupPrivateChatMessages', message: 'setup complete, session length: ${privateChatMessagesMap.keys.length}');
  }

  Future<List<types.Message>> _loadPrivateChatMessages(
      ChatTypeKey key) async {
    final Map<dynamic, dynamic> tempMap = await Messages.loadMessagesFromDB(
      where: key.getSQLFilter(),
      whereArgs: key.getSQLFilterArgs(),
      orderBy: "createTime desc",
    );
    List<MessageDB> messages = tempMap['messages'];
    List<types.Message?> convertedMessages = [];
    await Future.forEach(messages, (msg) async {
      var uiMsg = await msg.toChatUIMessage();
      if (uiMsg?.status == types.Status.sending) {
        uiMsg = uiMsg?.copyWith(
          status: types.Status.error,
        );
      }
      convertedMessages.add(uiMsg);
    });
    return convertedMessages.where((message) => message != null).cast<
        types.Message>().toList();
  }

  Future<void> _addPrivateChatMessages(ChatTypeKey key, types.Message message) async {

    ChatLogUtils.info(
      className: 'ChatDataCache',
      funcName: '_addPrivateChatMessages',
      message: 'begin',
    );

    final messageMap = await _privateChatMessageMap.future;

    if (!messageIdCache.add(message.id)) return ;

    _privateChatMessageMap = Completer();

    List<types.Message> messageList = _addMessageToList(messageMap[key], message);
    messageMap[key] = messageList;

    _privateChatMessageMap.complete(messageMap);

    await notifyPrivateChatObserverValueChanged(key);

    tryAddUnknownPubkey([message]);
  }

  Future _removePrivateChatMessages(ChatTypeKey key, types.Message message) async {

    final messageMap = await _privateChatMessageMap.future;
    _privateChatMessageMap = Completer();

    List<types.Message> messageList = _removeMessageFromList(messageMap[key], message);
    messageMap[key] = messageList;

    _privateChatMessageMap.complete(messageMap);
  }

  Future<void> _updatePrivateChatMessages(ChatTypeKey key, types.Message message) async {

    final messageMap = await _privateChatMessageMap.future;
    _privateChatMessageMap = Completer();

    List<types.Message> messageList = _updateMessageToList(messageMap[key], message);
    messageMap[key] = messageList;

    _privateChatMessageMap.complete(messageMap);
  }
}

extension ChatDataCacheChannelEx on ChatDataCache {

  Future<void> _setupChannelMessages() async {
    List<ChatSessionModel> sessionList = await _channelSessionList();
    Map<ChannelKey, List<types.Message>> channelMessagesMap = {};
    await Future.forEach(sessionList, (session) async {
      ChannelKey? key = _convertSessionToChannelKey(session);
      if (key == null) {
        ChatLogUtils.error(className: 'ChatDataCache', funcName: '_setupChannelMessages', message: 'ChannelKey is null');
        return;
      }

      final messageList = await _loadChannelMessages(key);

      messageIdCache.addAll(messageList.map((e) => e.id));

      channelMessagesMap[key] = messageList;

      tryAddUnknownPubkey(messageList);
    });

    _channelMessageMap.complete(channelMessagesMap);

    ChatLogUtils.info(className: 'ChatDataCache', funcName: '_setupChannelMessages', message: 'setup complete, session length: ${channelMessagesMap.keys.length}');
  }

  Future<List<types.Message>> _loadChannelMessages(ChannelKey key) async {
    final Map<dynamic, dynamic> tempMap= await Messages.loadMessagesFromDB(
      where: key.getSQLFilter(),
      whereArgs: key.getSQLFilterArgs(),
      orderBy: "createTime desc",
    );
    List<MessageDB> messages = tempMap['messages'];
    List<types.Message?> convertedMessages = [];
    await Future.forEach(messages, (msg) async {
      var uiMsg = await msg.toChatUIMessage();
      if (uiMsg?.status == types.Status.sending) {
        uiMsg = uiMsg?.copyWith(
          status: types.Status.error,
        );
      }
      convertedMessages.add(uiMsg);
    });
    return convertedMessages.where((message) => message != null).cast<types.Message>().toList();
  }

  Future<void> _addChannelMessages(ChannelKey key, types.Message message) async {

    ChatLogUtils.info(
      className: 'ChatDataCache',
      funcName: '_addChannelMessages',
      message: 'begin',
    );

    Map<ChannelKey, List<types.Message>> messageMap = await _channelMessageMap.future;

    if (!messageIdCache.add(message.id)) return ;

    _channelMessageMap = Completer();

    List<types.Message> messageList = _addMessageToList(messageMap[key], message);
    messageMap[key] = messageList;

    _channelMessageMap.complete(messageMap);

    await notifyChannelObserverValueChanged(key);

    tryAddUnknownPubkey([message]);
  }

  Future _removeChannelMessages(ChannelKey key, types.Message message) async {

    Map<ChannelKey, List<types.Message>> messageMap = await _channelMessageMap.future;
    _channelMessageMap = Completer();

    List<types.Message> messageList = _removeMessageFromList(messageMap[key], message);
    messageMap[key] = messageList;

    _channelMessageMap.complete(messageMap);
  }

  Future<void> _updateChannelMessages(ChannelKey key, types.Message message) async {

    Map<ChannelKey, List<types.Message>> messageMap = await _channelMessageMap.future;
    _channelMessageMap = Completer();

    List<types.Message> messageList = _updateMessageToList(messageMap[key], message);
    messageMap[key] = messageList;

    _channelMessageMap.complete(messageMap);
  }
}

extension ChatDataCacheGeneralMethodEx on ChatDataCache {

  ChatTypeKey? _getChatTypeKey(ChatSessionModel session) {
    final chatType = session.chatType;
    switch (chatType) {
      case ChatType.chatSingle:
      case ChatType.chatStranger:
        return _convertSessionToPrivateChatKey(session);
      case ChatType.chatChannel:
        return _convertSessionToChannelKey(session);
      case ChatType.chatSecret:
      case ChatType.chatSecretStranger:
        return _convertSessionToSecretChatKey(session);
      default:
        ChatLogUtils.error(className: 'ChatDataCache', funcName: '_getChatTypeKey', message: 'unknown chatType');
        return null;
    }
  }

  List<types.Message> _addMessageToList(List<types.Message>? messageList, types.Message newMessage) {

    if (messageList == null) {
      List<types.Message> newMessageList = [];
      newMessageList.add(newMessage);
      return newMessageList;
    }

    // If newMessage is the latest message
    if (messageList.length > 0) {
      final firstMsgTime = messageList.first.createdAt;
      final newMsgTime = newMessage.createdAt;
      if (firstMsgTime < newMsgTime) {
        messageList.insert(0, newMessage);
        return messageList;
      }
    }

    // Add message and sort the message list
    messageList.insert(0, newMessage);
    messageList.sort((msg1, msg2) {
      final msg1CreatedTime = msg1.createdAt;
      final msg2CreatedTime = msg2.createdAt;
      return msg2CreatedTime.compareTo(msg1CreatedTime);
    });

    return messageList;
  }

  List<types.Message> _removeMessageFromList(List<types.Message>? messageList, types.Message message) {

    messageIdCache.remove(message.id);

    if (messageList == null) {
      return [];
    }

    final index = messageList.indexWhere((msg) => msg.id == message.id);
    if (index >= 0 && index < messageList.length) {
      messageList.removeAt(index);
    }

    return messageList;
  }

  List<types.Message> _updateMessageToList(List<types.Message>? messageList, types.Message newMessage) {

    if (messageList == null) {
      return [];
    }

    final index = messageList.indexWhere((msg) => msg.id == newMessage.id);
    if (index >= 0) {
      messageList.replaceRange(index, index + 1, [newMessage]);
    }

    return messageList;
  }
}

extension ChatDataCacheSyncUserInfoEx on ChatDataCache {

  Future tryAddUnknownPubkey(List<types.Message> messages) async {
    messages.forEach((msg) {

      final pubkey = msg.author.id;
      final userUpdateTime = msg.author.updatedAt ?? 0;

      if (userUpdateTime != 0) return ;
      if (pubkey.isEmpty || unknownUserPubkeyCache.contains(pubkey)) return ;

      final messageList = unknownMessageMap[pubkey] ?? [];
      messageList.add(msg);
      unknownMessageMap[pubkey] = messageList;

      ChatLogUtils.info(
        className: 'ChatDataCache',
        funcName: 'tryAddUnknownPubkey',
        message: 'pubkey: $pubkey, message length:${messageList.length}',
      );
    });
  }
  
  Future _updateUnknownUserInfo() async {

    Map<String, List<types.Message>> messageMap = Map<String, List<types.Message>>.from(this.unknownMessageMap);
    if (messageMap.keys.length == 0) return ;

    final userMap = await Account.syncProfilesFromRelay(messageMap.keys.toList());

    unknownUserPubkeyCache.addAll(userMap.keys);
    userMap.forEach((key, value) {
      this.unknownMessageMap.remove(key);
    });

    ChatLogUtils.info(
      className: 'ChatDataCache',
      funcName: '_updateUnknownUserInfo',
      message: 'userMap: $userMap',
    );

    userMap.forEach((pubkey, user) {
      ChatUserCache.shared.updateUserInfo(user);
      ChatLogUtils.info(
        className: 'ChatDataCache',
        funcName: '_updateUnknownUserInfo',
        message: 'User has been updated, user: $pubkey, name:${user.name}',
      );
    });

    notifyAllObserverValueChanged();
  }
}