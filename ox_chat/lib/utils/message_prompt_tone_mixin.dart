
import 'package:flutter/material.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_chat/manager/chat_data_cache.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/utils/chat_prompt_tone.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';

mixin MessagePromptToneMixin<T extends StatefulWidget> on State<T> {

  @protected
  ChatSessionModel get session;

  @override
  void initState() {
    super.initState();
    PromptToneManager.sharedInstance.isCurrencyChatPage = isInCurrentSession;
    OXChatBinding.sharedInstance.msgIsReaded = isInCurrentSession;
  }

  @override
  void dispose() {
    PromptToneManager.sharedInstance.isCurrencyChatPage = null;
    OXChatBinding.sharedInstance.msgIsReaded = null;
    super.dispose();
  }

  bool isInCurrentSession(MessageDBISAR msg) {
    return ChatDataCache.shared.isContainMessage(session, msg);
  }
}