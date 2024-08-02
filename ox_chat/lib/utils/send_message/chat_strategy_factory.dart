import 'package:chatcore/chat-core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_chat/manager/chat_data_cache.dart';
import 'package:ox_chat/utils/chat_log_utils.dart';
import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/string_utils.dart';

class ChatStrategyFactory {
  static ChatStrategy getStrategy(ChatSessionModelISAR session) {
    var s = OXChatBinding.sharedInstance.sessionMap[session.chatId];
    if(s != null) session = s;
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
      case ChatType.chatRelayGroup:
        return RelayGroupChatStrategy(session);
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
  ChatSessionModelISAR get session;

  String get receiverId => session.chatId;

  String get receiverPubkey => session.getOtherPubkey;

  Future getSendMessageEvent({
    required MessageType messageType,
    required String contentString,
    required String replayId,
    String? decryptSecret,
    String? source,
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
  final ChatSessionModelISAR session;

  ChannelChatStrategy(this.session);

  @override
  String get receiverId => session.chatId.orDefault(session.groupId ?? '');

  @override
  Future getSendMessageEvent({
    required MessageType messageType,
    required String contentString,
    required String replayId,
    String? decryptSecret,
    String? source,
  }) async {
    return Channels.sharedInstance.getSendChannelMessageEvent(
      receiverId,
      messageType,
      contentString,
      replyMessage: replayId,
      decryptSecret: decryptSecret,
      source: source,
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
  final ChatSessionModelISAR session;

  GroupChatStrategy(this.session);

  @override
  String get receiverId => session.chatId.orDefault(session.groupId ?? '');

  @override
  Future getSendMessageEvent({
    required MessageType messageType,
    required String contentString,
    required String replayId,
    String? decryptSecret,
    String? source,
  }) async {
    return Groups.sharedInstance.getSendPrivateGroupMessageEvent(
      receiverId,
      messageType,
      contentString,
      replyMessage: replayId,
      decryptSecret: decryptSecret,
      source: source,
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
    return Groups.sharedInstance.sendPrivateGroupMessage(
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
  final ChatSessionModelISAR session;

  PrivateChatStrategy(this.session);

  @override
  Future getSendMessageEvent({
    required MessageType messageType,
    required String contentString,
    required String replayId,
    String? decryptSecret,
    String? source,
  }) async {
    return await Contacts.sharedInstance.getSendMessageEvent(
      receiverId,
      replayId,
      messageType,
      contentString,
      kind: session.messageKind,
      expiration: session.expiration,
      decryptSecret: decryptSecret,
      source: source,
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
  final ChatSessionModelISAR session;

  SecretChatStrategy(this.session);

  @override
  Future getSendMessageEvent({
    required MessageType messageType,
    required String contentString,
    required String replayId,
    String? decryptSecret,
    String? source,
  }) async {
    return await Contacts.sharedInstance.getSendSecretMessageEvent(
      receiverId,
      receiverPubkey,
      replayId,
      messageType,
      contentString,
      session.expiration,
      decryptSecret: decryptSecret,
      source: source,
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

class RelayGroupChatStrategy extends ChatStrategy {
  final ChatSessionModelISAR session;

  RelayGroupChatStrategy(this.session);

  @override
  String get receiverId => session.chatId.orDefault(session.groupId ?? '');

  @override
  Future getSendMessageEvent({
    required MessageType messageType,
    required String contentString,
    required String replayId,
    String? decryptSecret,
    String? source,
  }) async {
    List<String> previous = [];
    final List<types.Message> uiMsgList = await ChatDataCache.shared.getSessionMessage(session);
    for (types.Message message in uiMsgList) {
      final messageId = message.remoteId;
      if (messageId != null && messageId.isNotEmpty) {
        previous.add(messageId.substring(0, 8));
      }
      if (previous.length ==3){
        break;
      }
    }
    return RelayGroup.sharedInstance.getSendGroupMessageEvent(
      receiverId,
      messageType,
      contentString,
      previous,
      rootEvent: replayId,
      decryptSecret: decryptSecret,
      source: source,
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
    List<String> previous = [];
    final List<types.Message> uiMsgList = await ChatDataCache.shared.getSessionMessage(session);
    for (types.Message message in uiMsgList) {
      final messageId = message.remoteId;
      if (messageId != null && messageId.isNotEmpty) {
        previous.add(messageId.substring(0, 8));
      }
      if (previous.length ==3){
        break;
      }
    }
    return RelayGroup.sharedInstance.sendGroupMessage(
      receiverId,
      messageType,
      contentString,
      previous,
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
