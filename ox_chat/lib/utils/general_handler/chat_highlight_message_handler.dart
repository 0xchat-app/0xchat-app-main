
import 'dart:async';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:ox_common/utils/list_extension.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_chat_observer.dart';

import 'message_data_controller.dart';

class ChatHighlightMessageHandler with OXChatObserver {
  ChatHighlightMessageHandler(this.chatId);

  String chatId;

  int unreadMessageCount = 0;
  late MessageDataController dataController;

  Completer _initializeCmp = Completer();
  Future get initializeComplete => _initializeCmp.future;

  types.Message? _unreadLastMessage;
  types.Message? get unreadLastMessage => _unreadLastMessage;

  List<types.Message> _mentionMessages = [];
  List<types.Message> get mentionMessages => _mentionMessages;

  List<types.Message> _reactionMessages = [];
  List<types.Message> get reactionMessages => _reactionMessages;

  Function()? dataHasChanged;

  Future initialize(ChatSessionModelISAR session) async {
    OXChatBinding.sharedInstance.addObserver(this);
    await Future.wait([
      initializeUnreadMessage(session),
      initializeMentionMessage(session),
      initializeReactionMessage(session),
    ]);
    OXChatBinding.sharedInstance.removeReactionMessage(session.chatId, false);
    OXChatBinding.sharedInstance.removeMentionMessage(session.chatId, false);
    if (!_initializeCmp.isCompleted) _initializeCmp.complete();
  }

  void dispose() {
    OXChatBinding.sharedInstance.removeObserver(this);
  }

  @override
  void didSessionInfoUpdate(List<ChatSessionModelISAR> updatedSession) async {
    final session = updatedSession.where((e) => e.chatId == chatId).firstOrNull;
    if (session == null) return;

    await Future.wait([
      initializeMentionMessage(session),
      initializeReactionMessage(session),
    ]);

    OXChatBinding.sharedInstance.removeReactionMessage(session.chatId, false);
    OXChatBinding.sharedInstance.removeMentionMessage(session.chatId, false);

    dataHasChanged?.call();
  }

  Future initializeUnreadMessage(ChatSessionModelISAR session) async {
    if (unreadMessageCount == 0) return null;

    final messages = await dataController.getLocalMessage(
      limit: unreadMessageCount,
    );
    _unreadLastMessage = messages.lastOrNull;
  }

  Future initializeMentionMessage(ChatSessionModelISAR session) async {
    final newMessage = await dataController.getLocalMessageWithIds(session.mentionMessageIds);
    _mentionMessages = [...newMessage, ..._mentionMessages]
        .removeDuplicates((msg) => msg.remoteId)
      ..sort((msg1, msg2) {
      final msg1CreatedTime = msg1.createdAt;
      final msg2CreatedTime = msg2.createdAt;
      return msg2CreatedTime.compareTo(msg1CreatedTime);
    });
  }

  Future initializeReactionMessage(ChatSessionModelISAR session) async {
    final newMessage = await dataController.getLocalMessageWithIds(session.reactionMessageIds);
    _reactionMessages = [...newMessage, ..._reactionMessages]
        .removeDuplicates((msg) => msg.remoteId)
      ..sort((msg1, msg2) {
      final msg1CreatedTime = msg1.createdAt;
      final msg2CreatedTime = msg2.createdAt;
      return msg2CreatedTime.compareTo(msg1CreatedTime);
    });
  }

  Future tryRemoveMessageHighlightState(String messageId) async {
    await initializeComplete;
    var hasRemove = false;
    if ((await unreadLastMessage)?.id == messageId) {
      _unreadLastMessage = null;
      unreadMessageCount = 0;
      hasRemove = true;
    }
    mentionMessages.removeWhere((e) {
      final match = e.id == messageId;
      if (match) {
        hasRemove = true;
      }
      return match;
    });
    reactionMessages.removeWhere((e) {
      final match = e.id == messageId;
      if (match) {
        hasRemove = true;
      }
      return match;
    });

    if (hasRemove) {
      dataHasChanged?.call();
    }
  }
}