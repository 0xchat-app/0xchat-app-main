
import 'dart:async';
import 'dart:convert';

import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:ox_common/utils/ox_chat_observer.dart';
import 'package:ox_common/utils/user_config_tool.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:chatcore/chat-core.dart';
import 'package:ox_chat/manager/chat_data_manager_models.dart';
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_chat/utils/chat_log_utils.dart';
import 'package:ox_common/business_interface/ox_chat/utils.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/storage_key_tool.dart';

class ChatDataCache with OXChatObserver {

  static final ChatDataCache shared = ChatDataCache._internal();

  ChatDataCache._internal() {
    OXChatBinding.sharedInstance.addObserver(this);
  }

  Map<ChatTypeKey, List<types.Message>> _chatMessageMap = Map();
  List<types.Message> get allMessage => _chatMessageMap.values.expand((list) => list).toList();

  Map<ChatTypeKey, ValueChanged<List<types.Message>>> _valueChangedCallback = {};

  Set<String> messageIdCache = {};

  Completer setupCompleter = Completer();

  Completer offlinePrivateMessageFlag = Completer();
  Completer offlineSecretMessageFlag = Completer();
  Completer offlineChannelMessageFlag = Completer();
  Completer offlineGroupMessageFlag = Completer();

  setup() async {

    ChatLogUtils.info(
      className: 'ChatDataCache',
      funcName: 'setup',
      message: 'start',
    );

    final setupCompleter = Completer();
    this.setupCompleter = setupCompleter;
    setupAllCompleter();

    messageIdCache.clear();
    _chatMessageMap = Map();

    // await _setupChatMessages();
    offlineMessageFinishHandler();

    ChatLogUtils.info(
      className: 'ChatDataCache',
      funcName: 'setup',
      message: 'finish',
    );
    if (!setupCompleter.isCompleted) {
      setupCompleter.complete();
    }
  }

  void setupAllCompleter() {
    offlinePrivateMessageFlag = Completer();
    offlineSecretMessageFlag = Completer();
    offlineChannelMessageFlag = Completer();
    offlineGroupMessageFlag = Completer();
  }

  Future<List<types.Message>> getSessionMessage({
    required ChatSessionModelISAR session,
  }) async {
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

  Future<List<types.Message>> loadSessionMessage({
    required ChatSessionModelISAR session,
    required int loadMsgCount,
  }) async {
    final key = _getChatTypeKey(session);
    if (key == null) {
      ChatLogUtils.error(
        className: 'ChatDataCache',
        funcName: 'getSessionMessage',
        message: 'ChatKey is null',
      );
      return [];
    }

    final currentMessageList = [...await getSessionMessage(session: session)];
    final params = key.messageLoaderParams;
    var lastMessageDate = currentMessageList.lastOrNull?.createdAt;
    if (lastMessageDate != null) lastMessageDate ~/= 1000;
    final newMessages = (await Messages.loadMessagesFromDB(
      receiver: params.receiver,
      groupId: params.groupId,
      sessionId: params.sessionId,
      until: lastMessageDate,
      limit: loadMsgCount,
    ))['messages'];

    if (newMessages is! List<MessageDBISAR>) {
      ChatLogUtils.error(
        className: 'ChatDataCache',
        funcName: 'loadSessionMessage',
        message: 'result is not List<MessageDBISAR>',
      );
      return [];
    }

    final result = <types.Message>[];
    for (var newMsg in newMessages) {
      final uiMsg = await _distributeMessageToChatKey(key, newMsg);
      if (uiMsg != null) {
        result.add(uiMsg);
      }
    }
    notifyChatObserverValueChanged(key);
    return result;
  }

  void cleanSessionMessage(ChatSessionModelISAR session) {
    final key = _getChatTypeKey(session);
    if (key == null) {
      ChatLogUtils.error(
        className: 'ChatDataCache',
        funcName: 'cleanSessionMessage',
        message: 'ChatKey is null',
      );
      return ;
    }

    _chatMessageMap.remove(key);
    messageIdCache.clear();
  }

  @override
  void didPrivateMessageCallBack(MessageDBISAR message) {
    receivePrivateMessageHandler(message);
  }

  @override
  void didPrivateChatMessageUpdateCallBack(MessageDBISAR message, String replacedMessageId) async {
  }

  void updateSessionExpiration(String sessionId, MessageDBISAR message){
    final myPubkey = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey;
    if(message.receiver != myPubkey) return;

    ChatSessionModelISAR? sessionModel = OXChatBinding.sharedInstance.sessionMap[sessionId];

    if(sessionModel != null && message.createTime >= sessionModel.createTime){
      int expiration = 0;
      if(message.expiration != null && message.expiration! > message.createTime) {
        expiration = message.expiration! - message.createTime;
      }
      OXChatBinding.sharedInstance.updateChatSession(sessionId, expiration: expiration);
    }
  }

  Future receivePrivateMessageHandler(MessageDBISAR message) async {
    ChatLogUtils.info(
      className: 'ChatDataCache',
      funcName: 'didFriendMessageCallBack',
      message: 'begin',
    );
    final senderId = message.sender;
    final receiverId = message.receiver;
    final key = PrivateChatKey(senderId, receiverId);
    if (!isContainObserver(key)) return ;

    types.Message? msg = await message.toChatUIMessage();

    if (msg == null) {
      ChatLogUtils.info(
        className: 'ChatDataCache',
        funcName: 'receivePrivateMessageHandler',
        message: 'message is null',
      );
      return ;
    }

    await _addChatMessages(key, msg);

    updateSessionExpiration(senderId, message);
  }

  @override
  void didSecretChatMessageCallBack(MessageDBISAR message) async {
    ChatLogUtils.info(
      className: 'ChatDataCache',
      funcName: 'didFriendMessageCallBack',
      message: 'begin',
    );

    final sessionId = message.sessionId;
    final key = SecretChatKey(sessionId);
    if (!isContainObserver(key)) return ;

    types.Message? msg = await message.toChatUIMessage();
    if (msg == null) {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: 'didSecretChatMessageCallBack', message: 'message is null');
      return ;
    }

    await _addChatMessages(key, msg);

    updateSessionExpiration(sessionId, message);
  }

  @override
  void didGroupMessageCallBack(MessageDBISAR message) async {
    final groupId = message.groupId;
    final key = message.chatType != null && message.chatType == 4
        ? RelayGroupKey(groupId)
        : GroupKey(groupId);
    if (!isContainObserver(key)) return ;

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
  void didChannalMessageCallBack(MessageDBISAR message) async {
    final channelId = message.groupId;
    ChannelKey key = ChannelKey(channelId);
    if (!isContainObserver(key)) return ;

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
  void didSecretChatAcceptCallBack(SecretSessionDBISAR ssDB) async {
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

  @override
  void didMessageActionsCallBack(MessageDBISAR message) async {
    ChatLogUtils.info(
      className: 'ChatDataCache',
      funcName: 'didMessageActionsCallBack',
      message: 'begin',
    );
    final key = ChatDataCacheGeneralMethodEx.getChatTypeKeyWithMessage(message);
    if (key == null || !isContainObserver(key)) return ;

    final uiMessage = await message.toChatUIMessage();
    if (uiMessage != null) {
      await updateMessage(chatKey: key, message: uiMessage);
    } else {
      ChatLogUtils.error(
        className: 'ChatDataCache',
        funcName: 'didMessageActionsCallBack',
        message: 'key: $key, uiMessage: $uiMessage',
      );
    }
  }

  @override
  void didMessageDeleteCallBack(List<MessageDBISAR> delMessages) async {
    for (var message in delMessages) {
      final chatType = ChatDataCacheGeneralMethodEx.getChatTypeKeyWithMessage(message);
      if (chatType == null) {
        ChatLogUtils.error(
          className: 'ChatDataCache',
          funcName: 'didMessageDeleteCallBack',
          message: 'chatType is null',
        );
        continue;
      }

      if (isContainObserver(chatType))  {
        await _removeChatMessages(chatType, messageId: message.messageId);
      }

      types.Message? lastMessage;
      try {
        lastMessage = (await _getSessionMessage(chatType))
            .firstWhere((element) => element.type != types.MessageType.system);
      } catch (_) {}
      OXChatBinding.sharedInstance.deleteMessageHandler(message, lastMessage?.messagePreviewText ?? '');
    }
  }

  @override
  void didOfflinePrivateMessageFinishCallBack() {
    if (!offlinePrivateMessageFlag.isCompleted) {
      offlinePrivateMessageFlag.complete();
    }
  }

  @override
  void didOfflineSecretMessageFinishCallBack() {
    if (!offlineSecretMessageFlag.isCompleted) {
      offlineSecretMessageFlag.complete();
    }
  }

  @override
  void didOfflineChannelMessageFinishCallBack() {
    if (!offlineChannelMessageFlag.isCompleted) {
      offlineChannelMessageFlag.complete();
    }
  }

  @override
  void didOfflineGroupMessageFinishCallBack() {
    if (!offlineGroupMessageFlag.isCompleted) {
      offlineGroupMessageFlag.complete();
    }
  }

  didOfflineMessageFinishCallBack() {
    updateMessageReplyInfo();
  }

  Future addSystemMessage(String text, ChatSessionModelISAR session, { bool isSendToRemote = true}) async {
    // author
    UserDBISAR? userDB = OXUserInfoManager.sharedInstance.currentUserInfo;
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

  Future sendSystemMessage(ChatSessionModelISAR session, types.SystemMessage message, bool isLocal) async {

    final sessionId = session.chatId;
    final receiverPubkey = session.getOtherPubkey;

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
      await _removeChatMessages(key, message: message);
    });
  }
}

extension ChatDataCacheMessageOptionEx on ChatDataCache {

  Future<types.Message?> getMessage(
      ChatTypeKey? chatKey,
      ChatSessionModelISAR? session,
      String messageId) async {
    if (session != null) {
      chatKey ??= _getChatTypeKey(session);
    }
    if (chatKey == null) {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: 'getMessage', message: 'ChatTypeKey is null');
      return null;
    }
    return await _getChatMessages(chatKey, messageId);
  }

  Future<void> addNewMessage({
      ChatTypeKey? key,
      ChatSessionModelISAR? session,
      required types.Message message,
  }) async {
    if (session != null) {
      key ??= _getChatTypeKey(session);
    }
    if (key == null) {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: 'addNewMessage', message: 'ChatTypeKey is null');
      return ;
    }

    await _addChatMessages(key, message);
  }

  Future<void> deleteMessage(ChatSessionModelISAR session, types.Message message) async {
    final key = _getChatTypeKey(session);
    if (key == null) {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: 'deleteMessage', message: 'ChatTypeKey is null');
      return ;
    }

    ChatLogUtils.info(className: 'ChatDataCache', funcName: 'deleteMessage', message: 'session: ${session.chatId}, key: $key');
    await _removeChatMessages(key, message: message);
  }

  Future<void> resendMessage(ChatTypeKey key, types.Message message) async {
    await _removeChatMessages(key, message: message);
    await _addChatMessages(key, message);
  }

  Future<void> updateMessage({
    ChatTypeKey? chatKey,
    ChatSessionModelISAR? session,
    required types.Message message,
    types.Message? originMessage,
    String? originMessageId,
  }) async {
    if (session != null) {
      chatKey ??= _getChatTypeKey(session);
    }

    if (chatKey == null) {
      final msgId = message.remoteId;
      if (msgId != null && msgId.isNotEmpty) {
        final messageDB = await Messages.sharedInstance.loadMessageDBFromDB(msgId);
        if (messageDB != null) {
          chatKey = ChatDataCacheGeneralMethodEx.getChatTypeKeyWithMessage(messageDB);
        }
      }
    }

    if (chatKey == null) {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: 'updateMessage', message: 'ChatTypeKey is null');
      return ;
    }

    if(message is types.TextMessage && message.previewData != null){
        await MessageDBISAR.savePreviewData(message.id, jsonEncode(message.previewData?.toJson()));
    }

    await _updateChatMessages(chatKey, message, originMessage: originMessage, originMessageId: originMessageId,);
    await notifyChatObserverValueChanged(chatKey);
  }
}

extension ChatDataCacheObserverEx on ChatDataCache {
  void addObserver(ChatSessionModelISAR session, ValueChanged<List<types.Message>> valueChangedCallback) {
    final key = _getChatTypeKey(session);
    if (key != null) {
      _valueChangedCallback[key] = valueChangedCallback;
    } else {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: 'addObserver', message: 'chatTypeKey is null');
    }
  }

  void removeObserver(ChatSessionModelISAR session) {
    final key = _getChatTypeKey(session);
    if (key != null) {
      _valueChangedCallback.remove(key);
    } else {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: 'removeObserver', message: 'chatTypeKey is null');
    }
  }

  bool isContainObserver(ChatTypeKey key) =>
      _valueChangedCallback[key] != null;

  Future<void> notifyAllObserverValueChanged() async {
    final valueChangedCallback = _valueChangedCallback;
    valueChangedCallback.forEach((key, callback) async {
      callback(await _getSessionMessage(key));
    });
  }

  Future<void> notifyChatObserverValueChanged(ChatTypeKey key, { bool waitSetup = true }) async {
    final callback = _valueChangedCallback[key];
    if (callback != null) {
      final msgList = await _getSessionMessage(key, waitSetup: waitSetup);
      callback(msgList);
    }
  }
}

extension ChatDataCacheSessionEx on ChatDataCache {

  ChatTypeKey? _convertSessionToPrivateChatKey(ChatSessionModelISAR session) {
    return PrivateChatKey(session.sender, session.receiver);
  }

  GroupKey? _convertSessionToGroupKey(ChatSessionModelISAR session) {
    final groupId = session.groupId;
    if (groupId == null) {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: '_convertSessionToGroupKey', message: 'groupId is null');
      return null;
    }
    return GroupKey(groupId);
  }

  ChannelKey? _convertSessionToChannelKey(ChatSessionModelISAR session) {
    final channelId = session.groupId;
    if (channelId == null) {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: '_convertSessionToChannelKey', message: 'channelId is null');
      return null;
    }
    return ChannelKey(channelId);
  }

  ChatTypeKey? _convertSessionToSecretChatKey(ChatSessionModelISAR session) {
    return SecretChatKey(session.chatId);
  }

  RelayGroupKey? _convertSessionToRelayGroupKey(ChatSessionModelISAR session) {
    final groupId = session.groupId;
    if (groupId == null) {
      ChatLogUtils.error(className: 'ChatDataCache', funcName: '_convertSessionToRelayGroupKey', message: 'groupId is null');
      return null;
    }
    return RelayGroupKey(groupId);
  }

  Future setSessionAllMessageIsRead(ChatSessionModelISAR session) async {
    final chatTypeKey = _getChatTypeKey(session);
    if (chatTypeKey == null) return ;
    //TODO: updateMessagesReadStatus
    // await Messages.updateMessagesReadStatus(
    //   chatTypeKey.getSQLFilter(),
    //   chatTypeKey.getSQLFilterArgs(),
    //   true,
    // );
  }
}

extension ChatDataCacheEx on ChatDataCache {

  Future<void> _setupChatMessages() async {

    final result = (await Messages.loadMessagesFromDB())['messages'];
    if (result is! List<MessageDBISAR>) {
      ChatLogUtils.error(
        className: 'ChatDataCache',
        funcName: '_setupChatMessages',
        message: 'result is not List<MessageDBISAR>',
      );
      return ;
    }

    List<MessageDBISAR> allMessage = result;
    int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    int msgDeletePeriod = UserConfigTool.getSetting(StorageSettingKey.KEY_CHAT_MSG_DELETE_TIME.name, defaultValue: 0);

    final distributeBegin = DateTime.now();
    ChatLogUtils.info(
      className: 'ChatDataCache',
      funcName: '_setupChatMessages',
      message: 'begin',
    );

    await Future.forEach(allMessage, (message) async {
      if(msgDeletePeriod > 0 && message.createTime + msgDeletePeriod < currentTime){
        Messages.deleteMessagesFromDB(messageIds: [message.messageId]);
        return;
      }
      if(message.expiration != null && message.expiration! < currentTime){
        Messages.deleteMessagesFromDB(messageIds: [message.messageId]);
        return;
      }
      final key = ChatDataCacheGeneralMethodEx.getChatTypeKeyWithMessage(message);
      if (key == null) return ;
      await _distributeMessageToChatKey(key, message)
          .timeout(Duration(milliseconds: 300), onTimeout: () {
        ChatLogUtils.error(
          className: 'ChatDataCache',
          funcName: '_distributeMessageToChatKey',
          message: 'method time out',
        );
      });
    });

    ChatLogUtils.info(
      className: 'ChatDataCache',
      funcName: '_setupChatMessages',
      message: 'use time: ${DateTime.now().difference(distributeBegin)}, '
          'message length: ${allMessage.length}',
    );
  }

  Future<types.Message?> _distributeMessageToChatKey(
    ChatTypeKey key,
    MessageDBISAR message,
  ) async {
    try {
      var uiMsg = await message.toChatUIMessage();
      if (uiMsg == null) return null;
      if (_isErrorStatusMessage(uiMsg)) {
        uiMsg = uiMsg.copyWith(
          status: types.Status.error,
        );
      }

      if (message.messageId == MessageDBToUIEx.logger?.messageId) {
        MessageDBToUIEx.logger?.print('distribute - key: $key');
        MessageDBToUIEx.logger?.print('distribute - message: $message');
      }
      await _addChatMessages(key, uiMsg, waitSetup: false, notify: false);
      return uiMsg;
    } catch(e) {
      ChatLogUtils.error(
        className: 'ChatDataCache',
        funcName: '_setupChatMessages',
        message: 'MessageDB to cache error: $e, messageId: ${message.messageId}, messageType: ${message.type}',
      );
    }
    return null;
  }

  bool _isErrorStatusMessage(types.Message message) {
    if (message.status == types.Status.sending) return true;
    if (message.isImageSendingMessage) return true;
    return false;
  }

  FutureOr<List<types.Message>> _getSessionMessage(ChatTypeKey key, { bool waitSetup = true }) async {
    if (waitSetup) {
      await setupCompleter.future;
    }
    final msgList = _chatMessageMap[key];
    if (msgList == null) {
      List<types.Message> emptyList = [];
      _chatMessageMap[key] = emptyList;
      return emptyList;
    }
    return msgList;
  }

  Future<void> _addChatMessages(ChatTypeKey key, types.Message message, {
    bool waitSetup = true,
    bool notify = true,
  }) async {
    if (waitSetup) {
      ChatLogUtils.info(
        className: 'ChatDataCache',
        funcName: '_addChatMessages',
        message: 'key: $key, message: $message',
      );
    }

    final msgList = await _getSessionMessage(key, waitSetup: waitSetup);

    if (!messageIdCache.add(message.id)) return ;

    _addMessageToList(msgList, message);
    scheduleExpirationTask(key, message);
    if (notify) {
      await notifyChatObserverValueChanged(key, waitSetup: waitSetup);
    }
  }

  Future _removeChatMessages(
    ChatTypeKey key, {
    types.Message? message,
    String? messageId,
  }) async {
    ChatLogUtils.info(
      className: 'ChatDataCache',
      funcName: '_removeChatMessages',
      message: 'key: $key, message: $message, messageId: $messageId',
    );
    final messageList = await _getSessionMessage(key);
    _removeMessageFromList(messageList, message: message, messageId: messageId);
    await notifyChatObserverValueChanged(key);
  }

  Future<void> _updateChatMessages(ChatTypeKey key, types.Message message, {
    types.Message? originMessage,
    String? originMessageId,
  }) async {
    ChatLogUtils.info(
      className: 'ChatDataCache',
      funcName: '_updateChatMessages',
      message: 'key: $key, message: $message',
    );
    final messageList = await _getSessionMessage(key);
    _updateMessageToList(messageList, message, originMessage: originMessage, originMessageId: originMessageId);
  }

  Future<types.Message?> _getChatMessages(ChatTypeKey key, String messageId) async {
    final messageList = await _getSessionMessage(key);
    return _getMessageFromList(messageList, messageId);
  }
}

extension MessageExtensionInfoEx on ChatDataCache {

  void offlineMessageFinishHandler() async {
    await Future.wait([
      offlinePrivateMessageFlag.future,
      offlineSecretMessageFlag.future,
      offlineChannelMessageFlag.future,
      offlineGroupMessageFlag.future,
    ]);
    await setupCompleter.future;
    updateMessageReplyInfo();
  }

  Future updateMessageReplyInfo() async {
    final chatKeys = [..._chatMessageMap.keys];
    for (var chatKey in chatKeys) {
      final sessionMessage = [...(_chatMessageMap[chatKey] ?? [])];
      for (var message in sessionMessage) {
        final repliedMessageId = message.repliedMessageId;
        if (repliedMessageId == null || message.repliedMessage != null) continue ;

        final repliedMessage = await (await Messages.sharedInstance.loadMessageDBFromDB(repliedMessageId))?.toChatUIMessage();
        if (repliedMessage == null) continue ;

        final newMsg = message.copyWith(repliedMessage: repliedMessage);
        updateMessage(chatKey: chatKey, message: newMsg);
      }
    }
  }
}

extension ChatDataCacheGeneralMethodEx on ChatDataCache {

  ChatTypeKey? _getChatTypeKey(ChatSessionModelISAR session) {
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
      case ChatType.chatRelayGroup:
        return _convertSessionToRelayGroupKey(session);
      default:
        ChatLogUtils.error(className: 'ChatDataCache', funcName: '_getChatTypeKey', message: 'unknown chatType');
        return null;
    }
  }

  static ChatTypeKey? getChatTypeKeyWithMessage(MessageDBISAR message) {

    final type = message.chatType;
    if (type == 3 || message.sessionId.isNotEmpty) {
      return SecretChatKey(message.sessionId);
    }

    if (type == 1) {
      return GroupKey(message.groupId);
    }
    if (type == 4) {
      return RelayGroupKey(message.groupId);
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

  void _removeMessageFromList(
    List<types.Message> messageList, {
    types.Message? message,
    String? messageId,
  }) {
    messageId ??= message?.id;
    if (messageId == null) return ;

    messageIdCache.remove(messageId);

    final index = messageList.indexWhere((msg) => msg.id == messageId);
    if (index >= 0 && index < messageList.length) {
      messageList.removeAt(index);
    }
  }

  bool _updateMessageToList(List<types.Message> messageList, types.Message newMessage, {
    types.Message? originMessage,
    String? originMessageId,
  }) {
    originMessageId ??= originMessage?.id;
    final index = messageList.indexWhere((msg) {
      if (originMessageId != null) {
        return msg.id == originMessageId;
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

  types.Message? _getMessageFromList(List<types.Message> messageList, String messageId){
    return messageList.where((msg) => msg.id == messageId).firstOrNull;
  }

  bool isContainMessage(ChatSessionModelISAR session, MessageDBISAR message) {
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