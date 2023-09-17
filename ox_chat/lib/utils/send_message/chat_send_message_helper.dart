
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat/manager/chat_data_cache.dart';
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_chat/utils/chat_log_utils.dart';
import 'package:ox_chat/utils/send_message/chat_strategy_factory.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';

class ChatSendMessageHelper {

  static String getEncryptedKey(ChatSessionModel session) => ChatStrategyFactory.getStrategy(session).encryptedKey;

  static Future<String?> sendMessage(ChatSessionModel session, types.Message message) async {

    // prepare data
    var sendFinish = OXValue(false);
    final type = message.dbMessageType(encrypt: message.fileEncryptionType != types.EncryptionType.none);
    final contentString = message.contentString(message.content);
    final replayId = message.repliedMessage?.id ?? '';

    // create chat sender strategy
    final senderStrategy = ChatStrategyFactory.getStrategy(session);

    // prepare send event
    var event = message.sourceKey;
    if (event == null) {
      event = await senderStrategy.getSendMessageEvent(
        messageType: type,
        contentString: contentString,
        replayId: replayId,
      );
    }
    if (event == null) {
      return 'send message fail';
    }

    final sendMsg = message.copyWith(
      id: event.id,
      sourceKey: event,
    );

    ChatLogUtils.info(
      className: 'ChatSendMessageHelper',
      funcName: 'sendMessage',
      message: 'content: ${sendMsg.content}, type: ${sendMsg.type}',
    );

    OXChatBinding.sharedInstance.changeChatSessionType(session, true);

    senderStrategy.doSendMessageAction(
      messageType: type,
      contentString: contentString,
      replayId: replayId,
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
    _setMessageSendingStatusIfNeeded(session, sendFinish, sendMsg);

    return null;
  }


  static void updateMessageStatus(ChatSessionModel session, types.Message message, types.Status status) {
    final updatedMessage = message.copyWith(
      status: status,
    );
    ChatDataCache.shared.updateMessage(session, updatedMessage);
  }

  static void _setMessageSendingStatusIfNeeded(ChatSessionModel session, OXValue<bool> sendFinish, types.Message message) {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!sendFinish.value) {
        updateMessageStatus(session, message, types.Status.sending);
      }
    });
  }
}