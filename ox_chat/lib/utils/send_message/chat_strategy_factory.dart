
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_chat/utils/chat_log_utils.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';

class ChatStrategyFactory {
  static ChatStrategy getStrategy(ChatSessionModel session) {
    switch (session.chatType) {
      case ChatType.chatChannel:
        return ChannelChatStrategy(session);
      case ChatType.chatSecret:
        return SecretChatStrategy(session);
      case ChatType.chatSingle:
      case ChatType.chatStranger:
      case ChatType.chatSecretStranger:
        return PrivateChatStrategy(session);
      default :
        ChatLogUtils.error(
          className: 'ChatSendMessageHelper',
          funcName: 'sendMessage',
          message: 'Unknown session type: ${session.chatType}',
        );
        return PrivateChatStrategy(session);
    }
  }
}

abstract class ChatStrategy {

  ChatSessionModel get session;

  String get receiverId => session.chatId ?? '';

  String get receiverPubkey =>
      (session.receiver != OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey
          ? session.receiver
          : session.sender) ?? '';

  String get encryptedKey;

  Future getSendMessageEvent({
    required MessageType messageType,
    required String contentString,
    required String replayId,
  });

  Future doSendMessageAction({
    required MessageType messageType,
    required String contentString,
    required String replayId,
    Event? event,
  });

}

class ChannelChatStrategy extends ChatStrategy {

  final ChatSessionModel session;

  ChannelChatStrategy(this.session);

  @override
  String get encryptedKey => '';
  
  @override
  Future getSendMessageEvent({
    required MessageType messageType,
    required String contentString,
    required String replayId,
  }) async {
    return Channels.sharedInstance.getSendChannelMessageEvent(
      receiverId,
      messageType,
      contentString,
      replyMessage: replayId,
    );
  }
  
  @override
  Future doSendMessageAction({
    required MessageType messageType,
    required String contentString,
    required String replayId,
    Event? event,
  }) async {
    return Channels.sharedInstance.sendChannelMessage(
      receiverId,
      replyMessage: replayId,
      messageType,
      contentString,
      event: event,
    );
  }
}

class PrivateChatStrategy extends ChatStrategy {

  final ChatSessionModel session;

  PrivateChatStrategy(this.session);

  @override
  String get encryptedKey {
    final receiverPubkey = this.receiverPubkey;
    if (receiverPubkey.isEmpty) {
      return session.chatId ?? '';
    }
    return receiverPubkey;
  }

  @override
  Future getSendMessageEvent({
    required MessageType messageType,
    required String contentString,
    required String replayId,
  }) async {
    final messageKind = session.messageKind;
    if (messageKind != null) {
      return await Contacts.sharedInstance.getSendMessageEvent(receiverId, replayId, messageType, contentString, kind: messageKind);
    } else {
      return await Contacts.sharedInstance.getSendMessageEvent(receiverId, replayId, messageType, contentString);
    }
  }
  
  @override
  Future doSendMessageAction({
    required MessageType messageType,
    required String contentString,
    required String replayId,
    Event? event,
  }) async {
    return await Contacts.sharedInstance.sendPrivateMessage(
      receiverId,
      replayId,
      messageType,
      contentString,
      event: event,
    );
  }
}

class SecretChatStrategy extends ChatStrategy {

  final ChatSessionModel session;

  SecretChatStrategy(this.session);

  @override
  String get encryptedKey {
    final receiverPubkey = this.receiverPubkey;
    if (receiverPubkey.isEmpty) {
      return session.chatId ?? '';
    }
    return receiverPubkey;
  }

  @override
  Future getSendMessageEvent({
    required MessageType messageType,
    required String contentString,
    required String replayId,
  }) async {
    return await Contacts.sharedInstance.getSendSecretMessageEvent(
      receiverId,
      receiverPubkey,
      replayId,
      messageType,
      contentString,
    );
  }
  
  @override
  Future doSendMessageAction({
    required MessageType messageType,
    required String contentString,
    required String replayId,
    Event? event,
  }) async {
    return Contacts.sharedInstance
        .sendSecretMessage(
      receiverId,
      receiverPubkey,
      replayId,
      messageType,
      contentString,
      event: event,
    );
  }
}