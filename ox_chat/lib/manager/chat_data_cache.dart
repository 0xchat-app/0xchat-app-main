
import 'dart:async';
import 'dart:convert';

import 'package:ox_common/utils/ox_chat_observer.dart';
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

  Map<ChatTypeKey, List<types.Message>> _chatMessageMap = Map();

  Map<ChatTypeKey, ValueChanged<List<types.Message>>> _valueChangedCallback = {};

  Set<String> messageIdCache = {};

  Completer setupCompleter = Completer();

  setup() async {
    if (setupCompleter.isCompleted) {
      setupCompleter = Completer();
    }

    messageIdCache.clear();
    _chatMessageMap = Map();

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

  Future receivePrivateMessageHandler(MessageDB message) async {
    ChatLogUtils.info(
      className: 'ChatDataCache',
      funcName: 'didFriendMessageCallBack',
      message: 'begin',
    );
    final senderId = message.sender;
    final receiverId = message.receiver;
    final key = PrivateChatKey(senderId, receiverId);

    types.Message? msg = await message.toChatUIMessage();

    if (msg == null) {
      ChatLogUtils.info(className: 'ChatDataCache', funcName: 'receivePrivateMessageHandler', message: 'message is null');
      return ;
    }

    await _addChatMessages(key, msg);

    // OXChatBinding.sharedInstance.updateChatSession(senderId, expiration: message.expiration);
  }

  @override
  void didSecretChatMessageCallBack(MessageDB message) async {
    ChatLogUtils.info(
      className: 'ChatDataCache',
      funcName: 'didFriendMessageCallBack',
      message: 'begin',
    );

    final sessionId = message.sessionId;
    final key = SecretChatKey(sessionId);

    types.Message? msg = await message.toChatUIMessage();
    if (msg == null) {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: 'didSecretChatMessageCallBack', message: 'message is null');
      return ;
    }

    await _addChatMessages(key, msg);
  }

  @override
  void didGroupMessageCallBack(MessageDB message) async {
    final groupId = message.groupId;
    final key = GroupKey(groupId);

    types.Message? msg = await message.toChatUIMessage(
      isMentionMessageCallback: () {
        OXChatBinding.sharedInstance.updateChatSession(groupId, isMentioned: true);
      },
    );
    if (msg == null) {
      ChatLogUtils.error(
        className: 'ChatDataCache',
        funcName: 'didGroupMessageCallBack',
        message: 'message is null',
      );
      return ;
    }

    await _addChatMessages(key, msg);
  }

  @override
  void didChannalMessageCallBack(MessageDB message) async {
    final channelId = message.groupId;
    ChannelKey key = ChannelKey(channelId);

    types.Message? msg = await message.toChatUIMessage(
      isMentionMessageCallback: () {
        OXChatBinding.sharedInstance.updateChatSession(channelId, isMentioned: true);
      },
    );
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

    sendSystemMessage(session, message, !isSendToRemote);
  }

  Future sendSystemMessage(ChatSessionModel session, types.SystemMessage message, bool isLocal) async {

    final sessionId = session.chatId;
    final receiverPubkey = session.receiver != OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey
        ? session.receiver
        : session.sender;

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
      null,
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

    final chatKey = _getChatTypeKey(session);
    if (chatKey == null) {
      return;
    }

    Contacts.sharedInstance
        .sendSecretMessage(
      sessionId,
      receiverPubkey,
      '',
      type,
      contentString,
      event: event,
      local: isLocal,
    ).then((event) {
      sendFinish.value = true;
      final updatedMessage = sendMsg.copyWith(
        remoteId: event.eventId,
        status: event.status ? types.Status.sent : types.Status.error,
      );
      ChatDataCache.shared.updateMessage(chatKey: chatKey, message: updatedMessage);
    });

    // If the message is not sent within a short period of time, change the status to the sending state
    _setMessageSendingStatusIfNeeded(sendFinish, sendMsg, chatKey);
  }

  void _updateMessageStatus(types.Message message, types.Status status, ChatTypeKey key) {
    final updatedMessage = message.copyWith(
      status: status,
    );
    updateMessage(chatKey: key, message: updatedMessage);
  }

  void _setMessageSendingStatusIfNeeded(OXValue<bool> sendFinish, types.Message message, ChatTypeKey key) {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!sendFinish.value) {
        _updateMessageStatus(message, types.Status.sending, key);
      }
    });
  }
}

extension ChatDataCacheExpiration on ChatDataCache {
  Future<void> scheduleExpirationTask(ChatTypeKey key, types.Message message) async {
    int? expiration = message.expiration;
    if(expiration == null || expiration == 0) return;
    DateTime time = DateTime.fromMillisecondsSinceEpoch(expiration * 1000);
    var duration = time.difference(DateTime.now());
    if (duration.isNegative) {
      return;
    }
    Timer(duration, () async {
      await _removeChatMessages(key, message);
      await notifyChatObserverValueChanged(key);
    });
  }
}

extension ChatDataCacheMessageOptionEx on ChatDataCache {

  Future<void> addNewMessage({
      ChatTypeKey? key,
      ChatSessionModel? session,
      required types.Message message,
  }) async {
    if (session != null) {
      key ??= _getChatTypeKey(session);
    }
    if (key == null) {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: 'addNewMessage', message: 'ChatTypeKey is null');
      return ;
    }

    ChatLogUtils.info(className: 'ChatDataCache', funcName: 'addNewMessage', message: 'session: ${session?.chatId}, key: $key');
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

  Future<void> resendMessage(ChatTypeKey key, types.Message message) async {
    await _removeChatMessages(key, message);
    await _addChatMessages(key, message);
    await notifyChatObserverValueChanged(key);
  }

  Future<void> updateMessage({
    ChatTypeKey? chatKey,
    ChatSessionModel? session,
    required types.Message message,
    types.Message? originMessage,
  }) async {
    if (session != null) {
      chatKey ??= _getChatTypeKey(session);
    }
    if (chatKey == null) {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: 'updateMessage', message: 'ChatTypeKey is null');
      return ;
    }

    if(message is types.TextMessage && message.previewData != null){
        await MessageDB.savePreviewData(message.id, jsonEncode(message.previewData?.toJson()));
    }

    await _updateChatMessages(chatKey, message, originMessage: originMessage);
    await notifyChatObserverValueChanged(chatKey);
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
    if (callback != null) {
      final msgList = await _getSessionMessage(key);
      callback(msgList);
    }
  }
}

extension ChatDataCacheSessionEx on ChatDataCache {

  ChatTypeKey? _convertSessionToPrivateChatKey(ChatSessionModel session) {
    return PrivateChatKey(session.sender, session.receiver);
  }

  GroupKey? _convertSessionToGroupKey(ChatSessionModel session) {
    final groupId = session.groupId;
    if (groupId == null) {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: '_convertSessionToGroupKey', message: 'groupId is null');
      return null;
    }
    return GroupKey(groupId);
  }

  ChannelKey? _convertSessionToChannelKey(ChatSessionModel session) {
    final channelId = session.groupId;
    if (channelId == null) {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: '_convertSessionToChannelKey', message: 'channelId is null');
      return null;
    }
    return ChannelKey(channelId);
  }

  ChatTypeKey? _convertSessionToSecretChatKey(ChatSessionModel session) {
    return SecretChatKey(session.chatId);
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

    final result = (await Messages.loadMessagesFromDB(
      orderBy: "createTime desc",
    ))['messages'];
    if (result is! List<MessageDB>) {
      ChatLogUtils.error(
        className: 'ChatDataCache',
        funcName: '_setupChatMessages',
        message: 'result is not List<MessageDB>',
      );
      return ;
    }

    List<MessageDB> allMessage = result;
    List<String> expiredMessages = [];
    int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await Future.forEach(allMessage, (message) async {
      if(message.expiration != null && message.expiration! < currentTime){
        expiredMessages.add(message.messageId);
        return;
      }
      final key = _getChatTypeKeyWithMessage(message);
      if (key == null) return ;
      await _distributeMessageToChatKey(key, message);
    });
    Messages.deleteMessagesFromDB(messageIds: expiredMessages);
  }

  Future _distributeMessageToChatKey(ChatTypeKey key, MessageDB message) async {
    try {
      var uiMsg = await message.toChatUIMessage();
      if (uiMsg == null) return ;
      if (uiMsg.status == types.Status.sending) {
        uiMsg = uiMsg.copyWith(
          status: types.Status.error,
        );
      }
      await _addChatMessages(key, uiMsg, waitSetup: false);
    } catch(e) {
      ChatLogUtils.error(
        className: 'ChatDataCache',
        funcName: '_setupChatMessages',
        message: 'MessageDB to cache error: $e, messageId: ${message.messageId}, messageType: ${message.type}',
      );
    }
  }

  FutureOr<List<types.Message>> _getSessionMessage(ChatTypeKey key, { bool waitSetup = true }) async {
    if (waitSetup) {
      await setupCompleter;
    }
    final msgList = _chatMessageMap[key];
    if (msgList == null) {
      List<types.Message> emptyList = [];
      _chatMessageMap[key] = emptyList;
      return emptyList;
    }
    return msgList;
  }

  Future<void> _addChatMessages(ChatTypeKey key, types.Message message, { bool waitSetup = true }) async {

    final msgList = await _getSessionMessage(key, waitSetup: waitSetup);

    if (!messageIdCache.add(message.id)) return ;

    _addMessageToList(msgList, message);
    scheduleExpirationTask(key, message);
    await notifyChatObserverValueChanged(key);
  }

  Future _removeChatMessages(ChatTypeKey key, types.Message message) async {
    final messageList = await _getSessionMessage(key);
    _removeMessageFromList(messageList, message);
  }

  Future<void> _updateChatMessages(ChatTypeKey key, types.Message message, {types.Message? originMessage}) async {
    final messageList = await _getSessionMessage(key);
    _updateMessageToList(messageList, message, originMessage: originMessage);
  }
}

extension ChatDataCacheGeneralMethodEx on ChatDataCache {

  ChatTypeKey? _getChatTypeKey(ChatSessionModel session) {
    final chatType = session.chatType;
    switch (chatType) {
      case ChatType.chatSingle:
      case ChatType.chatStranger:
        return _convertSessionToPrivateChatKey(session);
      case ChatType.chatGroup:
        return _convertSessionToGroupKey(session);
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

  ChatTypeKey? _getChatTypeKeyWithMessage(MessageDB message) {

    final type = message.chatType;
    if (type == 3 || message.sessionId.isNotEmpty) {
      return SecretChatKey(message.sessionId);
    }

    if (type == 1) {
      return GroupKey(message.groupId);
    }

    if (type == 2 || message.groupId.isNotEmpty) {
      return ChannelKey(message.groupId);
    }

    if (type == 0 || message.sender.isNotEmpty && message.receiver.isNotEmpty) {
      return PrivateChatKey(message.sender, message.receiver);
    }

    ChatLogUtils.error(
      className: 'ChatDataCache',
      funcName: '_getChatTypeKeyWithMessage',
      message: 'result is null: messageId: ${message.messageId}, messageType: ${message.type}',
    );

    return null;
  }

  void _addMessageToList(List<types.Message> messageList, types.Message newMessage) {

    if (_updateMessageToList(messageList, newMessage)) return ;

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

  bool _updateMessageToList(List<types.Message> messageList, types.Message newMessage, {types.Message? originMessage}) {
    final index = messageList.indexWhere((msg) {
      if (originMessage != null) {
        return msg.id == originMessage.id;
      } else {
        return msg.id == newMessage.id;
      }
    });
    if (index >= 0) {
      messageList.replaceRange(index, index + 1, [newMessage]);
      return true;
    }
    return false;
  }

  bool isContainMessage(ChatSessionModel session, MessageDB message) {
    final sessionId = message.sessionId;
    final groupId = message.groupId;
    final senderId = message.sender;
    final receiverId = message.receiver;
    if (sessionId.isNotEmpty) {
      // Secret Chat
      return sessionId == session.chatId;
    } else if (groupId.isNotEmpty) {
      // Channel & Group
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