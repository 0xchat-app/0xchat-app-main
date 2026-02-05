
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:chatcore/chat-core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat/manager/chat_data_cache.dart';
import 'package:ox_chat/manager/chat_data_manager_models.dart';
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_chat/utils/chat_log_utils.dart';
import 'package:ox_chat/utils/chat_voice_helper.dart';
import 'package:ox_chat/utils/custom_message_utils.dart';
import 'package:ox_common/business_interface/ox_chat/custom_message_type.dart';
import 'package:ox_common/utils/list_extension.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_chat_observer.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/widgets/common_file_cache_manager.dart';

import 'chat_gallery_data_cache.dart';

// #region agent log
void _dataCtrlDebugLog(String location, String message, [Map<String, dynamic>? data]) {
  final now = DateTime.now();
  final ts = '${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}:${now.second.toString().padLeft(2,'0')}.${now.millisecond.toString().padLeft(3,'0')}';
  debugPrint('[DEBUG][$ts] $location: $message ${data != null ? data.toString() : ''}');
}
// #endregion

class MessageDataController with OXChatObserver {

  MessageDataController(this.chatTypeKey) {
    // #region agent log
    _dataCtrlDebugLog('MessageDataController:CTOR', 'constructor called, adding observer', {'observerCount': OXChatBinding.sharedInstance.observerCount});
    final t = DateTime.now().millisecondsSinceEpoch;
    // #endregion
    OXChatBinding.sharedInstance.addObserver(this);
    // #region agent log
    _dataCtrlDebugLog('MessageDataController:CTOR_DONE', 'observer added', {'durationMs': DateTime.now().millisecondsSinceEpoch - t, 'newObserverCount': OXChatBinding.sharedInstance.observerCount});
    // #endregion
  }

  ChatTypeKey chatTypeKey;

  ChatGalleryDataCache galleryCache = ChatGalleryDataCache();

  Set<String> _messageIdCache = {};
  List<types.Message> _messages = [];

  bool _hasMoreOldMessage = true;
  bool get canLoadMoreMessage {
    final coreChatType = chatTypeKey.coreChatType;
    if (coreChatType == 2 || coreChatType == 4) {
      return true;
    }
    return _hasMoreOldMessage;
  }

  bool _hasMoreNewMessage = false;
  bool get hasMoreNewMessage => _hasMoreNewMessage;

  ValueNotifier<List<types.Message>> messageValueNotifier = ValueNotifier([]);

  Completer? messageLoadingCompleter;
  bool get isMessageLoading => !(messageLoadingCompleter?.isCompleted ?? true);
  Future get messageLoading => messageLoadingCompleter?.future ?? Future.value();

  // Batch processing and debounce for UI updates
  Timer? _notifyUpdateTimer;
  bool _hasPendingUpdate = false;
  static const Duration _debounceDelay = const Duration(milliseconds: 100);
  static const Duration _batchDelay = const Duration(milliseconds: 300);
  int _consecutiveMessageCount = 0;
  DateTime? _lastMessageTime;
  static const int _batchThreshold = 5; // Trigger batch mode when receiving 5+ messages quickly

  bool _disposed = false;

  /// On Linux, incremented each time _performUpdate runs; used to cancel stale drip-feed callbacks.
  int _linuxDripGeneration = 0;

  void dispose() {
    _disposed = true;
    _notifyUpdateTimer?.cancel();
    _notifyUpdateTimer = null;
    if (messageLoadingCompleter != null && !messageLoadingCompleter!.isCompleted) {
      messageLoadingCompleter!.complete();
    }
    messageLoadingCompleter = null;
    removeMessageReactionsListener();
    OXChatBinding.sharedInstance.removeObserver(this);
  }

  @override
  void didPrivateMessageCallBack(MessageDBISAR message) async {
    _receiveMessageHandler(message);
  }

  @override
  void didChatMessageUpdateCallBack(MessageDBISAR message, String replacedMessageId) async {
    if (chatTypeKey != message.chatTypeKey) return ;

    var uiMessage = await message.toChatUIMessage(
      asyncUpdateHandler: (newMessage) => _asyncUpdateHandler(newMessage, message.messageId),
    );
    if (uiMessage == null) return ;

    if (uiMessage is types.AudioMessage && uiMessage.duration == null) {
      var uri = uiMessage.uri;
      String localPath = '';
      if (uri.isRemoteURL) {
        localPath = (await OXFileCacheManager.get(
          encryptKey: uiMessage.decryptKey,
          encryptNonce: uiMessage.decryptNonce,
        ).getFileFromCache(uri))?.file.path ?? '';
      } else {
        localPath = uri;
      }
      if (localPath.isNotEmpty) {
        final duration = await ChatVoiceMessageHelper.getAudioDuration(localPath);
        if (duration != null) {
          uiMessage = uiMessage.copyWith(
            duration: duration,
            audioFile: File(localPath),
          );
        }
      }
    }

    updateMessage(uiMessage, originMessageId: replacedMessageId);
  }

  @override
  void didSecretChatMessageCallBack(MessageDBISAR message) async {
    _receiveMessageHandler(message);
  }

  @override
  void didGroupMessageCallBack(MessageDBISAR message) async {
    _receiveMessageHandler(message);
  }

  @override
  void didChannalMessageCallBack(MessageDBISAR message) async {
    _receiveMessageHandler(message);
  }
  
  @override
  void didMessageActionsCallBack(MessageDBISAR message) async {
    ChatLogUtils.info(
      className: 'MessageDataController',
      funcName: 'didMessageActionsCallBack',
      message: 'begin',
    );

    final uiMessage = await message.toChatUIMessage();
    if (uiMessage != null) {
      updateMessage(uiMessage);
    } else {
      ChatLogUtils.error(
        className: 'MessageDataController',
        funcName: 'didMessageActionsCallBack',
        message: 'uiMessage is null, key: $chatTypeKey, message: $message',
      );
    }
  }

  @override
  void didMessageDeleteCallBack(List<MessageDBISAR> delMessages) async {
    for (var message in delMessages) {
      removeMessage(messageId: message.messageId);
    }
  }
}

extension MessageDataControllerInterface on MessageDataController {

  void addMessage(types.Message message, {
    bool needNotifyUpdate = true,
  }) {
    if (!_messageIdCache.add(message.id)) return ;

    _addMessageToList(_messages, message);
    _scheduleExpirationTask(message);
    
    // Update message count for batch detection
    if (needNotifyUpdate) {
      _updateMessageCount();
      _notifyUpdateMessages();
    }
  }

  void removeMessage({
    types.Message? message,
    String? messageId,
  }) {
    ChatLogUtils.info(
      className: 'MessageDataController',
      funcName: 'removeMessages',
      message: 'key: $chatTypeKey, message: $message, messageId: $messageId',
    );
    final isSuccess = _removeMessageFromList(
      _messages,
      message: message,
      messageId: messageId,
    );
    if (isSuccess) {
      _notifyUpdateMessages(immediate: false);
    }
  }

  void updateMessage(types.Message message, {
    types.Message? originMessage,
    String? originMessageId,
  }) {
    ChatLogUtils.info(
      className: 'MessageDataController',
      funcName: 'updateMessages',
      message: 'key: $chatTypeKey, message: $message',
    );
    final isSuccess = _updateMessageToList(
      _messages,
      message,
      originMessage: originMessage,
      originMessageId: originMessageId,
    );

    if (isSuccess) {
      _notifyUpdateMessages(immediate: false);
    }
  }

  types.Message? getMessage(String messageId) {
    final immutableMessages = [..._messages];
    return immutableMessages.where((msg) => msg.id == messageId).firstOrNull;
  }

  int getMessageIndex(String messageId) {
    final immutableMessages = [..._messages];
    return immutableMessages.indexWhere((msg) => msg.id == messageId || msg.remoteId == messageId);
  }

  Future<List<types.Message>> getLocalMessage({
    List<MessageType> messageTypes = const [],
    int? limit,
  }) async {
    final params = chatTypeKey.messageLoaderParams;
    List<MessageDBISAR> allMessage = (await Messages.loadMessagesFromDB(
      receiver: params.receiver,
      groupId: params.groupId,
      sessionId: params.sessionId,
      messageTypes: messageTypes,
      limit: limit,
    ))['messages'] ?? <MessageDBISAR>[];

    final uiMessages = await Future.wait(allMessage.map((msg) => msg.toChatUIMessage()));
    return uiMessages.whereNotNull().toList();
  }

  Future<List<types.Message>> getLocalMessageWithIds(List<String> messageIds) async {
    if (messageIds.isEmpty) return [];

    List<types.Message> result = [];
    if (messageIds.length == 1) {
      final message = await (await Messages.sharedInstance.loadMessageDBFromDB(messageIds.first))?.toChatUIMessage();
      if (message != null) {
        result.add(message);
      }
    } else {
      final messages = await Messages.sharedInstance.loadMessageDBFromDBWithMsgIds(messageIds);
      for (var message in messages) {
        final uiMessage = await message.toChatUIMessage();
        if (uiMessage != null) {
          result.add(uiMessage);
        }
      }
    }

    return result;
  }

  bool isInCurrentSession(MessageDBISAR msg) {
    return chatTypeKey == msg.chatTypeKey;
  }

  Future<List<types.Message>> loadMoreMessage({
    required int loadMsgCount,
    bool isLoadOlderData = true,
  }) async {
    // #region agent log
    _dataCtrlDebugLog('MessageDataController:LOAD_MORE_START', 'loadMoreMessage called', {'loadMsgCount': loadMsgCount});
    final loadMoreStart = DateTime.now().millisecondsSinceEpoch;
    // #endregion
    if (_disposed) return [];
    if (Platform.isLinux && kDebugMode) debugPrint('[LINUX_DIAG] loadMoreMessage: await messageLoading');
    await messageLoading;
    if (_disposed) return [];
    if (Platform.isLinux && kDebugMode) debugPrint('[LINUX_DIAG] loadMoreMessage: after messageLoading');
    final completer = Completer();
    this.messageLoadingCompleter = completer;

    final immutableMessages = [..._messages];
    final params = chatTypeKey.messageLoaderParams;
    int? until, since;
    if (isLoadOlderData) {
      var lastMessageDate = immutableMessages.lastOrNull?.createdAt;
      if (lastMessageDate != null) until = lastMessageDate ~/ 1000;
    } else {
      var firstMessageDate = immutableMessages.firstOrNull?.createdAt;
      if (firstMessageDate != null) since = firstMessageDate ~/ 1000;
    }

    // #region agent log
    _dataCtrlDebugLog('MessageDataController:DB_QUERY_START', 'calling loadMessagesFromDB');
    final dbStart = DateTime.now().millisecondsSinceEpoch;
    // #endregion
    if (Platform.isLinux && kDebugMode) debugPrint('[LINUX_DIAG] loadMoreMessage: before loadMessagesFromDB');
    final newMessages = (await Messages.loadMessagesFromDB(
      receiver: params.receiver,
      groupId: params.groupId,
      sessionId: params.sessionId,
      until: until,
      since: since,
      limit: loadMsgCount,
    ))['messages'] ?? <MessageDBISAR>[];
    // #region agent log
    _dataCtrlDebugLog('MessageDataController:DB_QUERY_DONE', 'loadMessagesFromDB returned', {'durationMs': DateTime.now().millisecondsSinceEpoch - dbStart, 'resultCount': newMessages.length});
    // #endregion
    if (_disposed) {
      completer.complete();
      return [];
    }
    if (Platform.isLinux && kDebugMode) debugPrint('[LINUX_DIAG] loadMoreMessage: after loadMessagesFromDB count=${newMessages.length}');

    if (newMessages is! List<MessageDBISAR>) {
      assert(false, 'result is not List<MessageDBISAR>');
      completer.complete();
      return [];
    }

    final result = <types.Message>[];
    var index = 0;
    // #region agent log
    _dataCtrlDebugLog('MessageDataController:LOOP_START', 'processing messages loop');
    final loopStart = DateTime.now().millisecondsSinceEpoch;
    // #endregion
    if (Platform.isLinux && kDebugMode) debugPrint('[LINUX_DIAG] loadMoreMessage: loop start');
    for (var newMsg in newMessages) {
      if (_disposed) {
        completer.complete();
        return result;
      }
      final uiMsg = await _addMessageWithMessageDB(newMsg, needNotifyUpdate: false);
      if (_disposed) {
        completer.complete();
        return result;
      }
      if (uiMsg != null) {
        result.add(uiMsg);
        _checkUIMessageInfo(uiMsg);
      }
      // Yield to GTK event loop on Linux every 5 messages to avoid "not responding"
      if (Platform.isLinux && ++index % 5 == 0) await Future.delayed(Duration.zero);
    }
    if (_disposed) {
      completer.complete();
      return result;
    }
    // #region agent log
    _dataCtrlDebugLog('MessageDataController:LOOP_DONE', 'processing loop finished', {'durationMs': DateTime.now().millisecondsSinceEpoch - loopStart, 'processedCount': result.length});
    // #endregion
    if (Platform.isLinux && kDebugMode) debugPrint('[LINUX_DIAG] loadMoreMessage: loop done');
    _notifyUpdateMessages(immediate: true);
    // #region agent log
    _dataCtrlDebugLog('MessageDataController:LOAD_MORE_DONE', 'loadMoreMessage finished', {'totalMs': DateTime.now().millisecondsSinceEpoch - loadMoreStart});
    // #endregion

    if (isLoadOlderData) {
      _hasMoreOldMessage = result.length >= loadMsgCount;
      if (!_hasMoreOldMessage) {
        // If no new messages are retrieved from the DB, attempt to fetch them from the relay.
        final coreChatType = chatTypeKey.coreChatType;
        int? fetchUntil;
        final lastMessageDate = result.lastOrNull?.createdAt;
        if (lastMessageDate != null) fetchUntil = lastMessageDate ~/ 1000;
        fetchUntil ??= until;
        if (coreChatType != null && fetchUntil != null) {
          Messages.recoverMessagesFromRelay(
            chatTypeKey.sessionId,
            coreChatType,
            until: fetchUntil,
            limit: loadMsgCount * 3,
          );
        }
      }
    } else {
      _hasMoreNewMessage = result.length >= loadMsgCount;
    }

    completer.complete();
    return result;
  }

  Future loadNearbyMessage({
    required String targetMessageId,
    required int beforeCount,
    required int afterCount,
  }) async {
    if (_disposed) return [];
    await messageLoading;
    if (_disposed) return [];
    final completer = Completer();
    this.messageLoadingCompleter = completer;

    final message = await Messages.sharedInstance.loadMessageDBFromDB(targetMessageId);
    if (message == null) return [];
    if (_disposed) {
      completer.complete();
      return [];
    }

    final loadParams = chatTypeKey.messageLoaderParams;
    List<MessageDBISAR> olderMessages = (await Messages.loadMessagesFromDB(
      receiver: loadParams.receiver,
      groupId: loadParams.groupId,
      sessionId: loadParams.sessionId,
      until: message.createTime,
      limit: beforeCount,
    ))['messages'] ?? <MessageDBISAR>[];
    if (_disposed) {
      completer.complete();
      return [];
    }
    List<MessageDBISAR> newerMessages = (await Messages.loadMessagesFromDB(
      receiver: loadParams.receiver,
      groupId: loadParams.groupId,
      sessionId: loadParams.sessionId,
      since: message.createTime,
      limit: afterCount,
    ))['messages'] ?? <MessageDBISAR>[];
    newerMessages = newerMessages.reversed.toList();

    final messages = [
      ...newerMessages,
      ...olderMessages,
    ].removeDuplicates((msg) => msg.messageId);

    final result = <types.Message>[];
    var nearbyIndex = 0;
    for (var newMsg in messages) {
      if (_disposed) {
        completer.complete();
        return result;
      }
      final uiMsg = await _addMessageWithMessageDB(newMsg, needNotifyUpdate: false);
      if (_disposed) {
        completer.complete();
        return result;
      }
      if (uiMsg != null) {
        result.add(uiMsg);
        _checkUIMessageInfo(uiMsg);
      }
      if (Platform.isLinux && ++nearbyIndex % 5 == 0) await Future.delayed(Duration.zero);
    }

    _notifyUpdateMessages(immediate: true);

    _hasMoreOldMessage = olderMessages.length >= beforeCount;
    _hasMoreNewMessage = newerMessages.length >= afterCount;

    completer.complete();
    return result;
  }

  Future insertFirstPageMessages({
    required int firstPageMessageCount,
    Future Function()? scrollAction,
  }) async {
    await messageLoading;
    final completer = Completer();
    this.messageLoadingCompleter = completer;

    final loadParams = chatTypeKey.messageLoaderParams;
    List<MessageDBISAR> firstPageMessage = (await Messages.loadMessagesFromDB(
      receiver: loadParams.receiver,
      groupId: loadParams.groupId,
      sessionId: loadParams.sessionId,
      limit: firstPageMessageCount,
    ))['messages'] ?? <MessageDBISAR>[];

    final insertedMessages = <types.Message>[];
    for (var newMsg in firstPageMessage) {
      final uiMsg = await _addMessageWithMessageDB(newMsg, needNotifyUpdate: false);
      if (uiMsg != null) {
        insertedMessages.add(uiMsg);
        _checkUIMessageInfo(uiMsg);
      }
    }

    _notifyUpdateMessages(immediate: true);

    await scrollAction?.call();

    _replaceMessages(insertedMessages);
    _notifyUpdateMessages(immediate: true);

    completer.complete();
  }

  Future replaceWithNearbyMessage({
    required String targetMessageId,
  }) async {
    _clearMessage();
    await loadNearbyMessage(
      targetMessageId: targetMessageId,
      beforeCount: 10,
      afterCount: 15,
    );
  }
}

extension MessageDataControllerPrivate on MessageDataController {

  void _notifyUpdateMessages({bool immediate = false}) {
    // Cancel existing timer if any
    _notifyUpdateTimer?.cancel();
    _notifyUpdateTimer = null;
    
    _hasPendingUpdate = true;
    
    // Determine delay based on whether we're in batch mode
    final delay = _isInBatchMode() && !immediate ? MessageDataController._batchDelay : MessageDataController._debounceDelay;
    
    _notifyUpdateTimer = Timer(delay, () {
      if (_hasPendingUpdate) {
        _performUpdate();
      }
    });
  }
  
  void _performUpdate() {
    if (Platform.isLinux && kDebugMode) debugPrint('[LINUX_DIAG] _performUpdate start');
    _notifyUpdateTimer?.cancel();
    _notifyUpdateTimer = null;
    _hasPendingUpdate = false;

    // Linux: use scheduleMicrotask for highest priority execution.
    // The frame scheduler can be blocked by network I/O callbacks flooding the event queue.
    // Microtasks run before event queue items, so this ensures UI updates happen promptly.
    if (Platform.isLinux) {
      final messagesToSet = [..._messages];
      _linuxDripGeneration += 1;
      final generation = _linuxDripGeneration;
      // Use scheduleMicrotask for immediate execution with highest priority
      scheduleMicrotask(() {
        if (_disposed || generation != _linuxDripGeneration) return;
        if (Platform.isLinux && kDebugMode) debugPrint('[LINUX_DIAG] _performUpdate microtask executing, msgCount=${messagesToSet.length}');
        messageValueNotifier.value = messagesToSet;
        updateMessageReactionsListener();
        // Force schedule a frame to ensure ValueListenableBuilder rebuilds promptly
        SchedulerBinding.instance.scheduleFrame();
      });
    } else {
      messageValueNotifier.value = [..._messages];
      updateMessageReactionsListener();
    }
    if (Platform.isLinux && kDebugMode) debugPrint('[LINUX_DIAG] _performUpdate done');
  }
  
  bool _isInBatchMode() {
    // Check if we're receiving messages rapidly (batch mode)
    final now = DateTime.now();
    if (_lastMessageTime != null) {
      final timeSinceLastMessage = now.difference(_lastMessageTime!);
      if (timeSinceLastMessage < const Duration(milliseconds: 500)) {
        // Messages arriving quickly, likely batch scenario
        return _consecutiveMessageCount >= MessageDataController._batchThreshold;
      } else {
        // Reset counter if too much time has passed
        _consecutiveMessageCount = 0;
      }
    }
    _lastMessageTime = now;
    return false;
  }
  
  void _updateMessageCount() {
    final now = DateTime.now();
    if (_lastMessageTime != null) {
      final timeSinceLastMessage = now.difference(_lastMessageTime!);
      if (timeSinceLastMessage < const Duration(milliseconds: 500)) {
        _consecutiveMessageCount++;
      } else {
        _consecutiveMessageCount = 1;
      }
    } else {
      _consecutiveMessageCount = 1;
    }
    _lastMessageTime = now;
  }

  Future _receiveMessageHandler(MessageDBISAR message) async {
    if (chatTypeKey != message.chatTypeKey) return ;

    final firstMessageTime = _messages.firstOrNull?.createdAt;
    if (_hasMoreNewMessage && firstMessageTime != null && message.createTime > (firstMessageTime ~/ 1000)) return ;

    final lastMessageTime = _messages.lastOrNull?.createdAt;
    if (_hasMoreOldMessage && lastMessageTime != null && message.createTime < (lastMessageTime ~/ 1000)) return ;

    // Use batch mode for rapid message reception
    final isBatchMode = _isInBatchMode();
    final uiMessage = await _addMessageWithMessageDB(message, needNotifyUpdate: !isBatchMode);
    if (uiMessage != null) {
      galleryCache.tryAddPreviewImage(message: uiMessage);
      // If in batch mode, update count but don't notify yet
      if (isBatchMode) {
        _updateMessageCount();
        _notifyUpdateMessages();
      }
    }
  }

  Future<types.Message?> _addMessageWithMessageDB(MessageDBISAR message, {
    bool needNotifyUpdate = true,
  }) async {
    try {
      var uiMsg = await message.toChatUIMessage(
        asyncUpdateHandler: (newMessage) => _asyncUpdateHandler(newMessage, message.messageId),
      );
      if (uiMsg == null) return null;

      if (message.messageId == ChatMessageHelper.logger?.messageId) {
        ChatMessageHelper.logger?.print('_addMessageWithMessageDB - key: $chatTypeKey');
        ChatMessageHelper.logger?.print('_addMessageWithMessageDB - message: $message');
      }
      addMessage(uiMsg, needNotifyUpdate: needNotifyUpdate);
      return uiMsg;
    } catch(e) {
      ChatLogUtils.error(
        className: 'MessageDataController',
        funcName: '_setupChatMessages',
        message: '_addMessageWithMessageDB: $e, messageId: ${message.messageId}, messageType: ${message.type}',
      );
    }
    return null;
  }

  void _clearMessage() {
    _messages = [];
    _messageIdCache.clear();
  }

  void _replaceMessages(List<types.Message> messages) {
    messages = messages.removeDuplicates((e) => e.id);

    _messages = [...messages];
    _messageIdCache.clear();
    _messageIdCache.addAll(messages.map((e) => e.remoteId).whereNotNull());
  }

  void _asyncUpdateHandler(MessageDBISAR newMessage, String originMessageId) async {
    final uiMessage = await newMessage.toChatUIMessage();
    if (uiMessage != null) {
      updateMessage(uiMessage, originMessageId: originMessageId);
    }
  }

  void _addMessageToList(List<types.Message> messageList, types.Message newMessage) {

    if (_updateMessageToList(messageList, newMessage)) return ;

    // If newMessage is the latest message
    if (messageList.length > 0) {
      final firstMsgTime = messageList.first.createdAt;
      final newMsgTime = newMessage.createdAt;
      if (firstMsgTime <= newMsgTime) {
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

  bool _removeMessageFromList(
      List<types.Message> messageList, {
        types.Message? message,
        String? messageId,
      }) {
    messageId ??= message?.id;
    if (messageId == null) return false;

    _messageIdCache.remove(messageId);

    final index = messageList.indexWhere((msg) => msg.id == messageId);
    if (index < 0 || index >= messageList.length) return false;

    messageList.removeAt(index);
    return true;
  }

  bool _updateMessageToList(List<types.Message> messageList, types.Message newMessage, {
    types.Message? originMessage,
    String? originMessageId,
  }) {
    originMessageId ??= originMessage?.id ?? newMessage.id;
    final index = messageList.indexWhere( (msg) => msg.id == originMessageId || msg.remoteId == originMessageId);
    if (index >= 0) {
      newMessage = newMessage.copyWith(id: messageList[index].id);
      messageList.replaceRange(index, index + 1, [newMessage]);
      // In certain cases (such as image or video message replacements),
      // message.id and message.remoteId are not the same value.
      // To prevent duplicate message addition caused by remote message callbacks,
      // both of these values need to be added to the cache.
      _messageIdCache.add(newMessage.id);
      if (newMessage.remoteId != null && newMessage.remoteId!.isNotEmpty) {
        _messageIdCache.add(newMessage.remoteId!);
      }
      return true;
    }
    return false;
  }

  void _scheduleExpirationTask(types.Message message) async {
    int? expiration = message.expiration;
    if(expiration == null || expiration == 0) return;
    DateTime time = DateTime.fromMillisecondsSinceEpoch(expiration * 1000);
    var duration = time.difference(DateTime.now());
    if (duration.isNegative) {
      return;
    }
    Timer(duration, () {
      removeMessage(message: message);
    });
  }

  Future _checkUIMessageInfo(types.Message message) async {
    if (message is types.CustomMessage) {
      final type = message.customType;
      switch (type) {
        case CustomMessageType.video:
          final snapshotPath = VideoMessageEx(message).snapshotPath;
          if (snapshotPath.isNotEmpty) {
            final file = File(snapshotPath);
            final isExists = file.existsSync();
            if (!isExists) {
              message.snapshotPath = '';
            }
          }
          break ;
        default:
          break ;
      }
    }
  }
}


extension MessageExtensionInfoEx on MessageDataController {

  Future offlineMessageFinishHandler() async {
    await ChatDataCache.shared.offlineMessageComplete;
    updateMessageReplyInfo();
  }

  Future updateMessageReplyInfo() async {
    final immutableMessages = [..._messages];
    for (var message in immutableMessages) {
      final repliedMessageId = message.repliedMessageId;
      if (repliedMessageId == null || message.repliedMessage != null) continue;

      final repliedMessage = await (await Messages.sharedInstance.loadMessageDBFromDB(
          repliedMessageId))?.toChatUIMessage();
      if (repliedMessage == null) continue;

      final newMsg = message.copyWith(repliedMessage: repliedMessage);
      updateMessage(newMsg);
    }
  }
}

extension ChatReactionsHandlerEx on MessageDataController {
  void updateMessageReactionsListener() {
    final coreChatType = chatTypeKey.coreChatType;
    if (coreChatType == null) return ;

    final actionSubscriptionId = _messages
        .map((e) => e.remoteId)
        .where((id) => id != null && id.isNotEmpty)
        .toList()
        .cast<String>()
        .removeDuplicates();
    Messages.sharedInstance.loadMessagesReactions(actionSubscriptionId, coreChatType);
  }

  void removeMessageReactionsListener() {
    Messages.sharedInstance.closeMessagesActionsRequests();
  }
}

extension CoreChatSessionEx on ChatTypeKey {
  /// Integer value for [MessageDBISAR.chatType].
  /// Returns `null` if the [chatType] does not match any known chat type.
  int? get coreChatType {
    final type = this.runtimeType;
    switch(type) {
      case PrivateChatKey:
        return 0;
      case GroupKey:
        return 1;
      case ChannelKey:
        return 2;
      case SecretChatKey:
        return 3;
      case RelayGroupKey:
        return 4;
      default:
        return null;
    }
  }
}

