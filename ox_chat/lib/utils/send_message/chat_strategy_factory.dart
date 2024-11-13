import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_chat/manager/chat_data_manager_models.dart';
import 'package:ox_chat/utils/chat_log_utils.dart';
import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/string_utils.dart';

class ChatStrategyFactory {
  static ChatStrategy getStrategy(ChatSessionModelISAR session) {
    var s = OXChatBinding.sharedInstance.sessionMap[session.chatId];
    if (s != null) session = s;
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
    required String replyId,
    EncryptedFile? encryptedFile,
    String? source,
  });

  Future<OKEvent> doSendMessageAction({
    required MessageType messageType,
    required String contentString,
    required String replyId,
    EncryptedFile? encryptedFile,
    bool isLocal = false,
    Event? event,
    String? replaceMessageId,
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
    required String replyId,
    EncryptedFile? encryptedFile,
    String? source,
  }) async {
    return Channels.sharedInstance.getSendChannelMessageEvent(
      receiverId,
      messageType,
      contentString,
      replyMessage: replyId,
      source: source,
    );
  }

  @override
  Future<OKEvent> doSendMessageAction({
    required MessageType messageType,
    required String contentString,
    required String replyId,
    EncryptedFile? encryptedFile,
    bool isLocal = false,
    Event? event,
    String? replaceMessageId,
  }) async {
    return Channels.sharedInstance.sendChannelMessage(
      receiverId,
      replyMessage: replyId,
      messageType,
      contentString,
      event: event,
      local: isLocal,
      replaceMessageId: replaceMessageId,
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
    required String replyId,
    EncryptedFile? encryptedFile,
    String? source,
  }) async {
    return Groups.sharedInstance.getSendPrivateGroupMessageEvent(
      receiverId,
      messageType,
      contentString,
      replyMessage: replyId,
      encryptedFile: encryptedFile,
      source: source,
    );
  }

  @override
  Future<OKEvent> doSendMessageAction({
    required MessageType messageType,
    required String contentString,
    required String replyId,
    EncryptedFile? encryptedFile,
    bool isLocal = false,
    Event? event,
    String? replaceMessageId,
  }) async {
    return Groups.sharedInstance.sendPrivateGroupMessage(
      receiverId,
      replyMessage: replyId,
      messageType,
      contentString,
      event: event,
      local: isLocal,
      encryptedFile: encryptedFile,
      replaceMessageId: replaceMessageId,
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
    required String replyId,
    EncryptedFile? encryptedFile,
    String? source,
  }) async {
    return await Contacts.sharedInstance.getSendMessageEvent(
      receiverId,
      replyId,
      messageType,
      contentString,
      kind: session.messageKind,
      expiration: session.expiration,
      encryptedFile: encryptedFile,
      source: source,
    );
  }

  @override
  Future<OKEvent> doSendMessageAction({
    required MessageType messageType,
    required String contentString,
    required String replyId,
    EncryptedFile? encryptedFile,
    bool isLocal = false,
    Event? event,
    String? replaceMessageId,
  }) async {
    return await Contacts.sharedInstance.sendPrivateMessage(
      receiverId,
      replyId,
      messageType,
      contentString,
      event: event,
      kind: session.messageKind,
      expiration: session.expiration,
      local: isLocal,
      encryptedFile: encryptedFile,
      replaceMessageId: replaceMessageId,
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
    required String replyId,
    EncryptedFile? encryptedFile,
    String? source,
  }) async {
    return await Contacts.sharedInstance.getSendSecretMessageEvent(
      receiverId,
      receiverPubkey,
      replyId,
      messageType,
      contentString,
      session.expiration,
      encryptedFile: encryptedFile,
      source: source,
    );
  }

  @override
  Future<OKEvent> doSendMessageAction({
    required MessageType messageType,
    required String contentString,
    required String replyId,
    EncryptedFile? encryptedFile,
    bool isLocal = false,
    Event? event,
    String? replaceMessageId,
  }) async {
    return Contacts.sharedInstance.sendSecretMessage(
      receiverId,
      receiverPubkey,
      replyId,
      messageType,
      contentString,
      event: event,
      local: isLocal,
      encryptedFile: encryptedFile,
      replaceMessageId: replaceMessageId,
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
    required String replyId,
    EncryptedFile? encryptedFile,
    String? source,
  }) async {
    List<String> previous = await createPrevious();
    return RelayGroup.sharedInstance.getSendGroupMessageEvent(
      receiverId,
      messageType,
      contentString,
      previous,
      rootEvent: replyId,
      source: source,
    );
  }

  @override
  Future<OKEvent> doSendMessageAction({
    required MessageType messageType,
    required String contentString,
    required String replyId,
    EncryptedFile? encryptedFile,
    bool isLocal = false,
    Event? event,
    String? replaceMessageId,
  }) async {
    List<String> previous = await createPrevious();
    return RelayGroup.sharedInstance.sendGroupMessage(
      receiverId,
      messageType,
      contentString,
      previous,
      event: event,
      local: isLocal,
      rootEvent: replyId,
      replaceMessageId: replaceMessageId,
    );
  }

  Future<List<String>> createPrevious() async {
    List<String> previous = [];
    final allMessages = await _getAllLocalMessage();
    for (var message in allMessages) {
      final messageId = message.messageId;
      if (messageId.isNotEmpty) {
        previous.add(messageId.substring(0, 8));
      }
      if (previous.length == 3) {
        break;
      }
    }
    return previous;
  }

  Future<List<MessageDBISAR>> _getAllLocalMessage() async {
    final params = session.chatTypeKey?.messageLoaderParams;
    if (params == null) return [];
    return (await Messages.loadMessagesFromDB(
          receiver: params.receiver,
          groupId: params.groupId,
          sessionId: params.sessionId,
        ))['messages'] ??
        <MessageDBISAR>[];
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
