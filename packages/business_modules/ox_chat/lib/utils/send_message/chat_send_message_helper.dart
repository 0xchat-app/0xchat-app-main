import 'dart:async';
import 'dart:convert';

import 'package:nostr_core_dart/nostr.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_chat/model/constant.dart';
import 'package:ox_chat/utils/chat_log_utils.dart';
import 'package:ox_chat/utils/send_message/chat_strategy_factory.dart';
import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:chatcore/chat-core.dart';

typedef MessageContentCreator = FutureOr<String?> Function(types.Message message);

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
    final type = message.dbMessageType;
    final contentString = (await contentEncoder?.call(message)) ?? message.contentString();
    final replyId = message.repliedMessage?.id ?? '';
    EncryptedFile? encryptedFile = _createEncryptedFileIfNeeded(message);

    types.Message sendMsg = message;

    if (sendingType == ChatSendingType.remote || sendingType == ChatSendingType.store) {
      // create chat sender strategy
      final senderStrategy = ChatStrategyFactory.getStrategy(session);
      // for test
      // senderStrategy.session.expiration = currentUnixTimestampSeconds() + 5;
      // prepare send event
      Event? event = await senderStrategy.getSendMessageEvent(
        messageType: type,
        contentString: contentString,
        replyId: replyId,
        encryptedFile: encryptedFile,
        source: await sourceCreator?.call(message),
      );

      if (event == null) {
        return 'send message fail';
      }

      final sourceKey = jsonEncode(event);
      final remoteId = event.innerEvent?.id ?? event.id;
      sendMsg = sendMsg.copyWith(
        id: remoteId,
        remoteId: remoteId,
        sourceKey: sourceKey,
        expiration: senderStrategy.session.expiration == null
            ? null
            : senderStrategy.session.expiration! + currentUnixTimestampSeconds(),
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
        replyId: replyId,
        encryptedFile: encryptedFile,
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

  static EncryptedFile? _createEncryptedFileIfNeeded(types.Message message) {
    if (!message.isEncrypted) return null;
    MessageType type = message.dbMessageType;
    if (message.isImageSendingMessage || message.isImageMessage) {
      type = MessageType.encryptedImage;
    } else if (message.isVideoSendingMessage || message.isVideoMessage) {
      type = MessageType.encryptedVideo;
    } else if (message is types.AudioMessage) {
      type = MessageType.encryptedAudio;
    }
    return EncryptedFile(
      message.content,
      MessageDBISAR.tpyeStringToMimeType(type),
      'aes-gcm',
      message.decryptKey!,
      message.decryptNonce!,
    );
  }
}
