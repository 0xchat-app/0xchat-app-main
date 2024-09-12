import 'dart:async';
import 'dart:convert';

import 'package:nostr_core_dart/nostr.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_chat/model/constant.dart';
import 'package:ox_chat/utils/chat_log_utils.dart';
import 'package:ox_chat/utils/send_message/chat_strategy_factory.dart';
import 'package:ox_common/model/chat_session_model_isar.dart';

typedef MessageContentCreator = FutureOr<String?> Function(
    types.Message message);

class ChatSendMessageHelper {
  static Future<String?> sendMessage({
    required ChatSessionModelISAR session,
    required types.Message message,
    ChatSendingType sendingType = ChatSendingType.remote,
    MessageContentCreator? contentEncoder,
    MessageContentCreator? sourceCreator,
    String? replaceMessageId,
    Future Function(OKEvent event, types.Message)? sendEventHandler,
    Function(types.Message)? sendActionFinishHandler,
  }) async {
    // prepare data
    final type = message.dbMessageType(
      encrypt: message.decryptKey != null,
    );
    final contentString = (await contentEncoder?.call(message)) ??
        message.contentString(message.content);
    final replayId = message.repliedMessage?.id ?? '';

    types.Message sendMsg = message;

    if (sendingType == ChatSendingType.remote || sendingType == ChatSendingType.store) {
      // create chat sender strategy
      final senderStrategy = ChatStrategyFactory.getStrategy(session);
      // for test
      // senderStrategy.session.expiration = currentUnixTimestampSeconds() + 5;
      // prepare send event
      Event? event;
      var plaintEvent = message.sourceKey;
      if (plaintEvent != null && plaintEvent is String) {
        try {
          event = await Event.fromJson(jsonDecode(plaintEvent));
        } catch (e) {
          final errorMsg = 'send message error: $e';
          ChatLogUtils.error(
            className: 'ChatSendMessageHelper',
            funcName: 'sendMessage',
            message: 'resend error, plaintEvent: $plaintEvent, errorMsg: $errorMsg',
          );
          return errorMsg;
        }
      }

      if (event == null) {
        event = await senderStrategy.getSendMessageEvent(
          messageType: type,
          contentString: contentString,
          replayId: replayId,
          decryptSecret: message.decryptKey,
          source: await sourceCreator?.call(message),
        );
      }
      if (event == null) {
        return 'send message fail';
      }

      final sourceKey = jsonEncode(event);
      final remoteId = event.innerEvent?.id ?? event.id;
      sendMsg = message.copyWith(
        id: replaceMessageId ?? remoteId,
        remoteId: remoteId,
        sourceKey: sourceKey,
        expiration: senderStrategy.session.expiration == null
            ? null
            : senderStrategy.session.expiration! +
                currentUnixTimestampSeconds(),
      );

      ChatLogUtils.info(
        className: 'ChatSendMessageHelper',
        funcName: 'sendMessage',
        message: 'content: ${sendMsg.content}, '
            'type: ${sendMsg.type}, '
            'messageKind: ${senderStrategy.session.messageKind}, '
            'expiration: ${senderStrategy.session.expiration}',
      );

      final sendResultEvent = senderStrategy.doSendMessageAction(
        messageType: type,
        contentString: contentString,
        replayId: replayId,
        decryptSecret: message.decryptKey,
        event: event,
        isLocal: sendingType != ChatSendingType.remote,
        replaceMessageId: replaceMessageId,
      );

      final isWaitForSend = sendingType != ChatSendingType.remote;
      if (isWaitForSend) {
        sendEventHandler?.call(await sendResultEvent, sendMsg);
      } else {
        sendResultEvent.then((event) => sendEventHandler?.call(event, sendMsg));
      }
    }

    sendActionFinishHandler?.call(sendMsg);

    return null;
  }
}
