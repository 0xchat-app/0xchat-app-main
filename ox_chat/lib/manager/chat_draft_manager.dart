
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';

class ChatDraftManager {

  static final ChatDraftManager shared = ChatDraftManager._internal();

  ChatDraftManager._internal();

  final localKey = 'ChatDraftManagerTempDraft';

  String chatId = '';

  String tempDraft = '';

  Future tryUpdateLastTempDraft() async {
    final jsonMap = await OXCacheManager.defaultOXCacheManager.getData(localKey, defaultValue: '') as Map;
    this.chatId = jsonMap['chatId'] ?? '';
    this.tempDraft = jsonMap['draft'] ?? '';
    if (chatId.isNotEmpty && tempDraft.isNotEmpty) {
      updateSession();
    }
  }

  void updateTempDraft(String chatId, String text) {
    if (tempDraft == text) return ;
    this.chatId = chatId;
    tempDraft = text;
    final jsonMap = {'chatId': chatId, 'draft': text};
    OXCacheManager.defaultOXCacheManager.saveData(localKey, jsonMap);
  }

  Future clearTempDraft() async {
    chatId = '';
    tempDraft = '';
    await OXCacheManager.defaultOXCacheManager.saveData(localKey, '');
  }

  Future updateSession() async {
    if (chatId.isEmpty) return ;
    OXChatBinding.sharedInstance.updateChatSession(chatId, draft: tempDraft);
    clearTempDraft();
  }
}