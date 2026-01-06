
import 'dart:async';

import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';

class ChatDraftManager {

  static final ChatDraftManager shared = ChatDraftManager._internal();

  ChatDraftManager._internal();

  final localKey = 'ChatDraftManagerTempDraft';

  /// key: chatId; value: draft
  Map<String, String> tempDraft = {};

  Completer setupCompleter = Completer();

  Future setup() async {
    await _tryUpdateLastTempDraft();
    if (!setupCompleter.isCompleted) setupCompleter.complete();
  }

  Future _tryUpdateLastTempDraft() async {
    final jsonMap = await OXCacheManager.defaultOXCacheManager.getData(localKey, defaultValue: {}) as Map;
    for (var chatId in jsonMap.keys) {
      if (chatId is! String || chatId.isEmpty || chatId == 'chatId') continue ;
      
      final draft = jsonMap[chatId];
      if (draft is String && draft.isNotEmpty) {
        tempDraft[chatId] = draft;
        await updateSessionDraft(chatId);
      }
    }
  }

  Future updateTempDraft(String chatId, String text) async {
    if (chatId.isEmpty) return ;

    await setupCompleter.future;

    tempDraft[chatId] = text;
    OXCacheManager.defaultOXCacheManager.saveData(localKey, tempDraft);
  }

  Future _clearTempDraft(String chatId) async {
    tempDraft.remove(chatId);
    await OXCacheManager.defaultOXCacheManager.saveData(localKey, tempDraft);
  }

  Future updateSessionDraft(String chatId) async {
    if (chatId.isEmpty) return ;

    final draft = tempDraft[chatId];
    await OXChatBinding.sharedInstance.updateChatSession(chatId, draft: draft);

    await _clearTempDraft(chatId);
  }
}