
import 'package:flutter/material.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_chat/manager/chat_data_cache.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/utils/chat_prompt_tone.dart';

mixin MessagePromptToneMixin<T extends StatefulWidget> on State<T> {

  @protected
  ChatSessionModel get session;

  @override
  void initState() {
    super.initState();
    PromptToneManager.sharedInstance.isCurrencyChatPage = isInCurrentSession;
  }

  @override
  void dispose() {
    PromptToneManager.sharedInstance.isCurrencyChatPage = null;
    super.dispose();
  }

  bool isInCurrentSession(MessageDB msg) {
    return ChatDataCache.shared.isContainMessage(session, msg);
  }
}