
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_chat/widget/reply_message_widget.dart';

class ChatReplyHandler {

  final ValueNotifier<String?> replyMessageNotifier = ValueNotifier<String?>(null);

  types.Message? replyMessage;
  FocusNode? focusNode;

  void focusNodeSetter(FocusNode node) {
    focusNode = node;
  }

  void updateReplyMessage(types.Message? message) {
    if (replyMessage == message) return ;
    replyMessage = message;
    replyMessageNotifier.value = message?.replyDisplayContent;
  }

  void quoteMenuItemPressHandler(BuildContext context, types.Message message) {
    focusNode?.requestFocus();
    updateReplyMessage(message);
  }

  Widget buildReplyMessageWidget() =>
      ReplyMessageWidget(replyMessageNotifier, deleteCallback: () => updateReplyMessage(null),);
}