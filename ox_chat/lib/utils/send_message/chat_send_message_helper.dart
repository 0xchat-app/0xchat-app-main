
import 'dart:async';
import 'dart:convert';

import 'package:nostr_core_dart/nostr.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat/manager/chat_data_cache.dart';
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_chat/utils/chat_log_utils.dart';
import 'package:ox_chat/utils/send_message/chat_strategy_factory.dart';
import 'package:ox_common/model/chat_session_model.dart';

typedef MessageContentEncoder = FutureOr<String?> Function(types.Message message);

class ChatSendMessageHelper {

  static Future<String?> sendMessage({
    required ChatSessionModel session,
    required types.Message message,
    bool isLocal = false,
    MessageContentEncoder? contentEncoder,
  }) async {

    // prepare data
    var sendFinish = OXValue(false);
    final type = message.dbMessageType(encrypt: message.fileEncryptionType != types.EncryptionType.none);
    final contentString = (await contentEncoder?.call(message)) ?? message.contentString(message.content);
    final replayId = message.repliedMessage?.id ?? '';

    // create chat sender strategy
    final senderStrategy = ChatStrategyFactory.getStrategy(session);
    // for test
    // senderStrategy.session.expiration = currentUnixTimestampSeconds() + 5;
    // prepare send event
    Event? event;
    var plaintEvent = message.sourceKey;
    if (plaintEvent != null && plaintEvent is String) {
      try {
        event = Event.fromJson(jsonDecode(plaintEvent));
      } catch (_) {
        return 'send message error';
      }
    }

    if (event == null) {
      event = await senderStrategy.getSendMessageEvent(
        messageType: type,
        contentString: contentString,
        replayId: replayId,
        decryptSecret: message.decryptKey,
      );
    }
    if (event == null) {
      return 'send message fail';
    }

    final sourceKey = jsonEncode(event);
    final sendMsg = message.copyWith(
      id: event.id,
      sourceKey: sourceKey,
      expiration: senderStrategy.session.expiration,
    );

    ChatLogUtils.info(
      className: 'ChatSendMessageHelper',
      funcName: 'sendMessage',
      message: 'content: ${sendMsg.content}, type: ${sendMsg.type}, messageKind: ${senderStrategy.session.messageKind}, expiration: ${senderStrategy.session.expiration}',
    );

    ChatDataCache.shared.addNewMessage(session: session, message: sendMsg);

    senderStrategy.doSendMessageAction(
      messageType: type,
      contentString: contentString,
      replayId: replayId,
      decryptSecret: message.decryptKey,
      event: event,
      isLocal: isLocal,
    ).then((event) {
      sendFinish.value = true;
      final updatedMessage = sendMsg.copyWith(
        remoteId: event.eventId,
        status: event.status ? types.Status.sent : types.Status.error,
      );
      ChatDataCache.shared.updateMessage(session:session, message: updatedMessage);
    });

    // If the message is not sent within a short period of time, change the status to the sending state
    _setMessageSendingStatusIfNeeded(session, sendFinish, sendMsg);

    return null;
  }


  static void updateMessageStatus(ChatSessionModel session, types.Message message, types.Status status) {
    final updatedMessage = message.copyWith(
      status: status,
    );
    ChatDataCache.shared.updateMessage(session: session, message: updatedMessage);
  }

  static void _setMessageSendingStatusIfNeeded(ChatSessionModel session, OXValue<bool> sendFinish, types.Message message) {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!sendFinish.value) {
        updateMessageStatus(session, message, types.Status.sending);
      }
    });
  }
}