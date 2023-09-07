
import 'dart:async';

import 'package:ox_chat/utils/chat_general_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:chatcore/chat-core.dart';
import 'package:ox_chat/manager/chat_data_manager_models.dart';
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_chat/utils/chat_log_utils.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';

class ChatDataCache with OXChatObserver {

  static final ChatDataCache shared = ChatDataCache._internal();

  ChatDataCache._internal() {
    OXChatBinding.sharedInstance.addObserver(this);
  }

  Map<ChatTypeKey, FutureOr<List<types.Message>>> _chatMessageMap = Map();

  Map<ChatTypeKey, ValueChanged<List<types.Message>>> _valueChangedCallback = {};

  Set<String> messageIdCache = {};

  Completer setupCompleter = Completer();

  setup() async {
    if (setupCompleter.isCompleted) {
      setupCompleter = Completer();
    }

    messageIdCache.clear();

    await _setupChatMessages();

    if (!setupCompleter.isCompleted) {
      setupCompleter.complete();
    }
  }

  Future<List<types.Message>> getSessionMessage(ChatSessionModel session) async {
    final key = _getChatTypeKey(session);
    if (key == null) {
      ChatLogUtils.error(
        className: 'ChatDataCache',
        funcName: 'getSessionMessage',
        message: 'ChatKey is null',
      );
      return [];
    }
    return _getSessionMessage(key);
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

    await _addChatMessages(key, msg);

    final myPubkey = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey;
    if (receiverId == myPubkey) {
      OXChatBinding.sharedInstance.updateChatSession(senderId, messageKind: message.kind);
    }
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

    await _addChatMessages(key, msg);
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
      ChatLogUtils.error(
        className: 'ChatDataCache',
        funcName: 'didChannalMessageCallBack',
        message: 'message is null',
      );
      return ;
    }

    await _addChatMessages(key, msg);
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
    final toUser = await Account.sharedInstance.getUserInfo(toPubkey);
    final userName = toUser?.getUserShowName() ?? '';
    addSystemMessage('$userName joined Secret Chat', sessionModel);
  }

  Future addSystemMessage(String text, ChatSessionModel session, { bool isSendToRemote = true}) async {

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

    if (isSendToRemote) {
      sendSystemMessage(session, message);
    } else {
      addNewMessage(session, message);
    }
  }

  Future sendSystemMessage(ChatSessionModel session, types.SystemMessage message) async {

    final sessionId = session.chatId ?? '';
    final receiverPubkey = (session.receiver != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey
        ? session.receiver
        : session.sender) ??
        '';

    // send message
    var sendFinish = OXValue(false);
    final type = message.dbMessageType(encrypt: message.fileEncryptionType != types.EncryptionType.none);
    final contentString = message.contentString(message.content);

    final event = await Contacts.sharedInstance.getSendSecretMessageEvent(
      sessionId,
      receiverPubkey,
      '',
      type,
      contentString,
    );

    if (event == null) {
      return;
    }

    final sendMsg = message.copyWith(
      id: event.id,
    );

    ChatLogUtils.info(
      className: 'ChatDataCache',
      funcName: 'sendSystemMessage',
      message: 'sessionId: $sessionId, receiverPubkey: $receiverPubkey, contentString: $contentString, type: ${sendMsg.type}',
    );

    Contacts.sharedInstance
        .sendSecretMessage(
      sessionId,
      receiverPubkey,
      '',
      type,
      contentString,
      event: event,
    ).then((event) {
      sendFinish.value = true;
      final updatedMessage = sendMsg.copyWith(
        remoteId: event.eventId,
        status: event.status ? types.Status.sent : types.Status.error,
      );
      ChatDataCache.shared.updateMessage(session, updatedMessage);
    });

    // If the message is not sent within a short period of time, change the status to the sending state
    _setMessageSendingStatusIfNeeded(sendFinish, sendMsg, session);
  }

  void _updateMessageStatus(types.Message message, types.Status status, ChatSessionModel session) {
    final updatedMessage = message.copyWith(
      status: status,
    );
    updateMessage(session, updatedMessage);
  }

  void _setMessageSendingStatusIfNeeded(OXValue<bool> sendFinish, types.Message message, ChatSessionModel session) {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!sendFinish.value) {
        _updateMessageStatus(message, types.Status.sending, session);
      }
    });
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
    await _addChatMessages(key, message);
  }

  Future<void> deleteMessage(ChatSessionModel session, types.Message message) async {
    final key = _getChatTypeKey(session);
    if (key == null) {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: 'deleteMessage', message: 'ChatTypeKey is null');
      return ;
    }

    ChatLogUtils.info(className: 'ChatDataCache', funcName: 'deleteMessage', message: 'session: ${session.chatId}, key: $key');
    await _removeChatMessages(key, message);
    await notifyChatObserverValueChanged(key);
  }

  Future<void> resendMessage(ChatSessionModel session, types.Message message) async {
    final key = _getChatTypeKey(session);
    if (key == null) {
      ChatLogUtils.error(
        className: 'ChatDataCache',
        funcName: 'resendMessage',
        message: 'ChatTypeKey is null',
      );
      return ;
    }

    ChatLogUtils.info(
      className: 'ChatDataCache',
      funcName: 'resendMessage',
      message: 'session: ${session.chatId}, key: $key',
    );

    await _removeChatMessages(key, message);
    await _addChatMessages(key, message);
    await notifyChatObserverValueChanged(key);

  }

  Future<void> updateMessage(ChatSessionModel session, types.Message message) async {
    final key = _getChatTypeKey(session);
    if (key == null) {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: 'updateMessage', message: 'ChatTypeKey is null');
      return ;
    }

    await _updatePrivateChatMessages(key, message);
    await notifyChatObserverValueChanged(key);
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
      callback(await _getSessionMessage(key));
    });
  }

  Future<void> notifyChatObserverValueChanged(ChatTypeKey key) async {
    final callback = _valueChangedCallback[key];
    ChatLogUtils.info(className: 'ChatDataCache', funcName: 'notifyChatObserverValueChanged', message: 'callback: $callback');
    if (callback != null) {
      final msgList = await _getSessionMessage(key);
      callback(msgList);
    }
  }
}

extension ChatDataCacheSessionEx on ChatDataCache {
  Future<List<ChatSessionModel>> _chatSessionList() async {
    final List<ChatSessionModel> sessionList = await DB.sharedInstance.objects<ChatSessionModel>(
      orderBy: "createTime desc",
    );
    return sessionList;
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

extension ChatDataCacheEx on ChatDataCache {

  Future<void> _setupChatMessages() async {
    List<ChatSessionModel> sessionList = await _chatSessionList();
    Map<ChatTypeKey, List<types.Message>> privateChatMessagesMap = {};
    // Add Session message(Future)
    await Future.forEach(sessionList, (session) async {
      final key = _getChatTypeKey(session);
      if (key == null) {
        ChatLogUtils.error(
          className: 'ChatDataCache',
          funcName: '_setupChatMessages',
          message: 'privateChatKey is null',
        );
        return ;
      }

      // Create completer
      final completer = Completer<List<types.Message>>();
      _chatMessageMap[key] = completer.future;
      _loadChatMessages(key, session).then((msgList) {
        messageIdCache.addAll(msgList.map((e) => e.id));
        _chatMessageMap[key] = msgList;
        // Finish completer
        completer.complete(msgList);
      });
    });

    ChatLogUtils.info(
      className: 'ChatDataCache',
      funcName: '_setupChatMessages',
      message: 'setup complete, session length: ${privateChatMessagesMap.keys.length}',
    );
  }

  FutureOr<List<types.Message>> _getSessionMessage(ChatTypeKey key) async {
    await setupCompleter;
    final msgList = _chatMessageMap[key];
    if (msgList == null) {
      List<types.Message> emptyList = [];
      _chatMessageMap[key] = emptyList;
      return emptyList;
    }
    return msgList;
  }

  Future<List<types.Message>> _loadChatMessages(
      ChatTypeKey key, ChatSessionModel session) async {
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

    // try add message kind
    if (key is! ChannelKey) {
      try {
        final minePubkey = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey;
        final lastMessage = messages.firstWhere((element) => element.sender != minePubkey);
        OXChatBinding.sharedInstance.updateChatSession(session.chatId ?? '', messageKind: lastMessage.kind);
      } catch (e) { }

    }
    return convertedMessages.where((message) => message != null).cast<
        types.Message>().toList();
  }

  Future<void> _addChatMessages(ChatTypeKey key, types.Message message) async {

    ChatLogUtils.info(
      className: 'ChatDataCache',
      funcName: '_addChatMessages',
      message: 'begin',
    );

    final msgList = await _getSessionMessage(key);

    if (!messageIdCache.add(message.id)) return ;

    _addMessageToList(msgList, message);

    await notifyChatObserverValueChanged(key);
  }

  Future _removeChatMessages(ChatTypeKey key, types.Message message) async {
    final messageList = await _getSessionMessage(key);
    _removeMessageFromList(messageList, message);
  }

  Future<void> _updatePrivateChatMessages(ChatTypeKey key, types.Message message) async {
    final messageList = await _getSessionMessage(key);
    _updateMessageToList(messageList, message);
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

  void _addMessageToList(List<types.Message> messageList, types.Message newMessage) {
    // If newMessage is the latest message
    if (messageList.length > 0) {
      final firstMsgTime = messageList.first.createdAt;
      final newMsgTime = newMessage.createdAt;
      if (firstMsgTime < newMsgTime) {
        messageList.insert(0, newMessage);
        return ;
      }
    }

    // Add message and sort the message list
    messageList.insert(0, newMessage);
    messageList.sort((msg1, msg2) {
      final msg1CreatedTime = msg1.createdAt;
      final msg2CreatedTime = msg2.createdAt;
      return msg2CreatedTime.compareTo(msg1CreatedTime);
    });
  }

  void _removeMessageFromList(List<types.Message> messageList, types.Message message) {
    messageIdCache.remove(message.id);

    final index = messageList.indexWhere((msg) => msg.id == message.id);
    if (index >= 0 && index < messageList.length) {
      messageList.removeAt(index);
    }
  }

  void _updateMessageToList(List<types.Message> messageList, types.Message newMessage) {
    final index = messageList.indexWhere((msg) => msg.id == newMessage.id);
    if (index >= 0) {
      messageList.replaceRange(index, index + 1, [newMessage]);
    }
  }

  bool isContainMessage(ChatSessionModel session, MessageDB message) {
    final sessionId = message.sessionId ?? '';
    final groupId = message.groupId ?? '';
    final senderId = message.sender ?? '';
    final receiverId = message.receiver ?? '';
    if (sessionId.isNotEmpty) {
      // Secret Chat
      return sessionId == session.chatId;
    } else if (groupId.isNotEmpty) {
      // Channel
      return groupId == session.groupId;
    } else if (senderId.isNotEmpty && receiverId.isNotEmpty) {
      // Private
      final key = _convertSessionToPrivateChatKey(session);
      return key == PrivateChatKey(senderId, receiverId);
    } else {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: 'isContainMessage', message: 'unknown message type');
      return false;
    }
  }
}