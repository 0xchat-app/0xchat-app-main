import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_chat/utils/chat_log_utils.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/string_utils.dart';

class ChatStrategyFactory {
  static ChatStrategy getStrategy(ChatSessionModel session) {
    switch (session.chatType) {
      case ChatType.chatGroup:
        return GroupChatStrategy(session);
      case ChatType.chatChannel:
        return ChannelChatStrategy(session);
      case ChatType.chatSecret:
        return SecretChatStrategy(session);
      case ChatType.chatSingle:
      case ChatType.chatStranger:
      case ChatType.chatSecretStranger:
        return PrivateChatStrategy(session);
      default:
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

  String get receiverId => session.chatId;

  String get receiverPubkey =>
      (session.receiver !=
              OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey
          ? session.receiver
          : session.sender) ??
      '';

  Future getSendMessageEvent({
    required MessageType messageType,
    required String contentString,
    required String replayId,
    String? decryptSecret,
  });

  Future doSendMessageAction({
    required MessageType messageType,
    required String contentString,
    required String replayId,
    String? decryptSecret,
    bool isLocal = false,
    Event? event,
  });
}

class ChannelChatStrategy extends ChatStrategy {
  final ChatSessionModel session;

  ChannelChatStrategy(this.session);

  @override
  String get receiverId => session.chatId.orDefault(session.groupId ?? '');

  @override
  Future getSendMessageEvent({
    required MessageType messageType,
    required String contentString,
    required String replayId,
    String? decryptSecret,
  }) async {
    return Channels.sharedInstance.getSendChannelMessageEvent(
      receiverId,
      messageType,
      contentString,
      replyMessage: replayId,
      decryptSecret: decryptSecret,
    );
  }

  @override
  Future doSendMessageAction({
    required MessageType messageType,
    required String contentString,
    required String replayId,
    String? decryptSecret,
    bool isLocal = false,
    Event? event,
  }) async {
    return Channels.sharedInstance.sendChannelMessage(
      receiverId,
      replyMessage: replayId,
      messageType,
      contentString,
      event: event,
      local: isLocal,
      decryptSecret: decryptSecret,
    );
  }
}

class GroupChatStrategy extends ChatStrategy {
  final ChatSessionModel session;

  GroupChatStrategy(this.session);

  @override
  String get receiverId => session.chatId.orDefault(session.groupId ?? '');

  @override
  Future getSendMessageEvent({
    required MessageType messageType,
    required String contentString,
    required String replayId,
    String? decryptSecret,
  }) async {
    return Groups.sharedInstance.getSendGroupMessageEvent(
      receiverId,
      messageType,
      contentString,
      replyMessage: replayId,
      decryptSecret: decryptSecret,
    );
  }

  @override
  Future doSendMessageAction({
    required MessageType messageType,
    required String contentString,
    required String replayId,
    String? decryptSecret,
    bool isLocal = false,
    Event? event,
  }) async {
    return Groups.sharedInstance.sendGroupMessage(
      receiverId,
      replyMessage: replayId,
      messageType,
      contentString,
      event: event,
      local: isLocal,
      decryptSecret: decryptSecret,
    );
  }
}

class PrivateChatStrategy extends ChatStrategy {
  final ChatSessionModel session;

  PrivateChatStrategy(this.session);

  @override
  Future getSendMessageEvent({
    required MessageType messageType,
    required String contentString,
    required String replayId,
    String? decryptSecret,
  }) async {
    return await Contacts.sharedInstance.getSendMessageEvent(
      receiverId,
      replayId,
      messageType,
      contentString,
      kind: session.messageKind,
      expiration: session.expiration,
      decryptSecret: decryptSecret,
    );
  }

  @override
  Future doSendMessageAction({
    required MessageType messageType,
    required String contentString,
    required String replayId,
    String? decryptSecret,
    bool isLocal = false,
    Event? event,
  }) async {
    return await Contacts.sharedInstance.sendPrivateMessage(
      receiverId,
      replayId,
      messageType,
      contentString,
      event: event,
      kind: session.messageKind,
      expiration: session.expiration,
      local: isLocal,
      decryptSecret: decryptSecret,
    );
  }
}

class SecretChatStrategy extends ChatStrategy {
  final ChatSessionModel session;

  SecretChatStrategy(this.session);

  @override
  Future getSendMessageEvent({
    required MessageType messageType,
    required String contentString,
    required String replayId,
    String? decryptSecret,
  }) async {
    return await Contacts.sharedInstance.getSendSecretMessageEvent(
      receiverId,
      receiverPubkey,
      replayId,
      messageType,
      contentString,
      session.expiration,
      decryptSecret: decryptSecret,
    );
  }

  @override
  Future doSendMessageAction({
    required MessageType messageType,
    required String contentString,
    required String replayId,
    String? decryptSecret,
    bool isLocal = false,
    Event? event,
  }) async {
    return Contacts.sharedInstance.sendSecretMessage(
      receiverId,
      receiverPubkey,
      replayId,
      messageType,
      contentString,
      event: event,
      local: isLocal,
      decryptSecret: decryptSecret,
    );
  }
}

extension MessageTypeEncryptEx on MessageType {
  bool get supportEncrypt {
    switch (this) {
      case MessageType.encryptedImage:
      case MessageType.encryptedVideo:
      case MessageType.encryptedAudio:
      case MessageType.encryptedFile:
        return true;
      default:
        return false;
    }
  }
}
