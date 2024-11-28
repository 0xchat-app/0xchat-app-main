
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:cashu_dart/cashu_dart.dart';
import 'package:chatcore/chat-core.dart';
import 'package:flutter_chat_types/src/message.dart' as UIMessage;
import 'package:ox_chat/model/message_content_model.dart';
import 'package:ox_chat/utils/chat_log_utils.dart';
import 'package:ox_chat/utils/custom_message_utils.dart';
import 'package:ox_chat/utils/general_handler/chat_mention_handler.dart';
import 'package:ox_chat/utils/general_handler/chat_nostr_scheme_handler.dart';
import 'package:ox_chat/utils/message_factory.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_common/business_interface/ox_chat/call_message_type.dart';
import 'package:ox_common/business_interface/ox_chat/custom_message_type.dart';
import 'package:ox_common/business_interface/ox_chat/utils.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/web_url_helper.dart';
import 'package:ox_localizable/ox_localizable.dart';

class OXValue<T> {
  OXValue(this.value);
  T value;
}

class ChatMessageHelper {

  static String get unknownMessageText =>
      '[This message is not supported by the current client version, please update to view]';

  static MessageCheckLogger? logger; // = MessageCheckLogger('9c2d9fb78c95079c33f4d6e67556cd6edfd86b206930f97e0578987214864db2');

  static String? sessionMessageTextBuilder(MessageDBISAR message) {
    final type = MessageDBISAR.stringtoMessageType(message.type);
    final decryptContent = message.decryptContent;
    return getMessagePreviewText(decryptContent, type, message.sender);
  }

  static String getMessagePreviewText(
    String contentText,
    MessageType type,
    String senderId,
  ) {
    final unknownText = Localized.text('ox_common.message_type_unknown');
    switch (type) {
      case MessageType.text:
        final mentionDecoderText = ChatMentionMessageEx.tryDecoder(contentText);
        if (mentionDecoderText != null) return mentionDecoderText;

        String? showContent;
        if (contentText.isNotEmpty) {
          try {
            final decryptedContent = json.decode(contentText);
            if (decryptedContent is Map) {
              showContent = decryptedContent['content'] as String;
            } else {
              showContent = decryptedContent.toString();
            }
          } catch (_) { }
        }
        if (showContent == null) {
          showContent = contentText;
        }
        return showContent;
      case MessageType.image:
      case MessageType.encryptedImage:
        return Localized.text('ox_common.message_type_image');
      case MessageType.video:
      case MessageType.encryptedVideo:
        return Localized.text('ox_common.message_type_video');
      case MessageType.audio:
      case MessageType.encryptedAudio:
        return Localized.text('ox_common.message_type_audio');
      case MessageType.file:
      case MessageType.encryptedFile:
        return Localized.text('ox_common.message_type_file');
      case MessageType.system:
        final key = contentText;
        var text = '';
        if (key.isNotEmpty) {
          text = Localized.text(key, useOrigin: true);
          if (key == 'ox_chat.screen_record_hint_message' ||
              key == 'ox_chat.screenshot_hint_message') {
            final sender = senderId;
            var senderName = '';
            final isMe = OXUserInfoManager.sharedInstance.isCurrentUser(sender);
            final userDB = Account.sharedInstance.getUserInfo(sender);
            if (userDB is UserDBISAR) {
              senderName = userDB.name ?? '';
            }
            final name = isMe
                ? Localized.text('ox_common.you')
                : senderName;
            text = text.replaceAll(r'${user}', name);
          }
        }
        return text;
      case MessageType.call:
        var contentMap;
        try {
          contentMap = json.decode(contentText);
        } catch (_) { }

        final type = CallMessageTypeEx.fromValue(contentMap['media']);
        if (type == null) break ;

        switch (type) {
          case CallMessageType.audio: return '[${'str_voice_call'.localized()}]';
          case CallMessageType.video: return '[${'str_video_call'.localized()}]';
        }
      case MessageType.template:
        if (contentText.isEmpty) break ;

        Map metaMap = {};
        try {
          metaMap = json.decode(contentText);
        } catch (_) { }

        final type = CustomMessageTypeEx.fromValue(metaMap[CustomMessageEx.metaTypeKey]);
        final content = metaMap[CustomMessageEx.metaContentKey];
        if (type == null) break;

        switch (type) {
          case CustomMessageType.zaps:
            return Localized.text('ox_common.message_type_zaps');
          case CustomMessageType.template:
            if (content is Map) {
              final title = content['title'] ?? '';
              return Localized.text('ox_common.message_type_template') + title;
            }
            break ;
          case CustomMessageType.ecash:
          case CustomMessageType.ecashV2:
            var memo = '';
            try {
              memo = EcashMessageEx.getDescriptionWithMetadata(json.decode(contentText));
            } catch (_) { }
            return '[Cashu Ecash] $memo';
          case CustomMessageType.imageSending:
            return Localized.text('ox_common.message_type_image');
          case CustomMessageType.video:
            return Localized.text('ox_common.message_type_video');
          case CustomMessageType.note:
            final sourceScheme = NoteMessageEx.getSourceSchemeWithMetadata(metaMap);
            if (sourceScheme != null && sourceScheme.isNotEmpty) return sourceScheme;
            return Localized.text('ox_common.message_type_template');
          case CustomMessageType.call:
            return CallMessageEx.getDescriptionWithMetadata(metaMap) ?? unknownText;
        }
        break ;
    }

    return unknownText;
  }

  static Future<types.User?> _getUser(String userPubkey) async {
    final user = await Account.sharedInstance.getUserInfo(userPubkey);
    if (user == null) {
      ChatLogUtils.error(
        className: 'ChatMessageHelper',
        funcName: '_getUser',
        message: 'user is null',
      );
    }
    return user?.toMessageModel();
  }

  static String _getContentString(decryptContent) {
    try {
      final decryptedContent = json.decode(decryptContent);
      if (decryptedContent is Map) {
        return decryptedContent['content'];
      } else if (decryptedContent is String) {
        return decryptedContent;
      }
    } catch (e) {}
    return decryptContent;
  }

  static Future<(String content, MessageType messageType)> _parseWithContent({
    required String content,
    required MessageType messageType,
    required String? decryptSecret,
    required String? decryptNonce,
    Function(String content, MessageType messageType)? asyncParseCallback,
    VoidCallback? isMentionMessageCallback = null,
    MessageCheckLogger? logger,
  }) async {
    switch (messageType) {
      case MessageType.text:
        final initialText = content;
        final mentionDecodeText = ChatMentionMessageEx.tryDecoder(initialText, mentionsCallback: (mentions) {
          if (mentions.isEmpty) return ;
          final hasCurrentUser = mentions.any((mention) => OXUserInfoManager.sharedInstance.isCurrentUser(mention.pubkey));
          if (hasCurrentUser) {
            isMentionMessageCallback?.call();
          }
        });

        if (mentionDecodeText != null) {
          // Mention Msg
          return (mentionDecodeText, MessageType.text);
        } else if (ChatNostrSchemeHandle.getNostrScheme(initialText) != null) {
          // Template Msg
          ChatNostrSchemeHandle.tryDecodeNostrScheme(initialText).then((nostrSchemeContent) async {
            logger?.print('step async - initialText: $initialText, nostrSchemeContent: ${nostrSchemeContent}');
            if (nostrSchemeContent != null) {
              asyncParseCallback?.call(nostrSchemeContent, MessageType.template);
            }
          });
        } else if(Zaps.isLightningInvoice(initialText)) {
          // Zaps Msg
          Map<String, String> req = Zaps.decodeInvoice(initialText);
          final amount = req['amount'] ?? '';
          if (amount.isNotEmpty) {
            Map<String, dynamic> map = CustomMessageEx.zapsMetaData(
                zapper: '',
                invoice: initialText,
                amount: amount,
                description: 'Best wishes'
            );
            return (jsonEncode(map), MessageType.template);
          }
        } else if (Cashu.isCashuToken(initialText)) {
          // Ecash Msg
          final newContent = jsonEncode(CustomMessageEx.ecashV2MetaData(tokenList: [initialText]));
          return (newContent, MessageType.template);
        }

        MessageDBISAR.identifyUrl(content).then((value) {
          if (messageType == value) return ;
          asyncParseCallback?.call(content, value);
        });

        return (content, messageType);
      case MessageType.image:
      case MessageType.encryptedImage:
        final meta = CustomMessageEx.imageSendingMetaData(
          url: content,
          encryptedKey: decryptSecret,
          encryptedNonce: decryptNonce
        );
        try {
          final jsonString = jsonEncode(meta);
          return (jsonString, MessageType.template);
        } catch (_) { }
        return (content, messageType);
      case MessageType.video:
      case MessageType.encryptedVideo:
        final url = content;
        final meta = CustomMessageEx.videoMetaData(
          fileId: '',
          url: url,
          encryptedKey: decryptSecret,
          encryptedNonce: decryptNonce,
        );
        try {
          final jsonString = jsonEncode(meta);
          return (jsonString, MessageType.template);
        } catch (_) { }
        return (content, messageType);
      case MessageType.audio:
      case MessageType.encryptedAudio:
        return (content, messageType);
      case MessageType.call:
        return (content, messageType);
      case MessageType.system:
        return (content, messageType);
      case MessageType.template:
        final customInfo = CustomMessageFactory.parseFromContentString(content);
        if (customInfo != null) {
          return (content, messageType);
        }
      default:
        ChatLogUtils.error(
          className: 'MessageDBToUIEx',
          funcName: 'convertMessageDBToUIModel',
          message: 'unknown message type',
        );
    }

    return (unknownMessageText, MessageType.text);
  }

  static MessageFactory _getMessageFactory(MessageType messageType) {
    switch (messageType) {
      case MessageType.text:
        return TextMessageFactory();
      case MessageType.image:
      case MessageType.encryptedImage:
        return ImageMessageFactory();
      case MessageType.video:
      case MessageType.encryptedVideo:
        return VideoMessageFactory();
      case MessageType.audio:
      case MessageType.encryptedAudio:
        return AudioMessageFactory();
      case MessageType.call:
        return CallMessageFactory();
      case MessageType.system:
        return SystemMessageFactory();
      case MessageType.template:
        return CustomMessageFactory();
      default:
        return TextMessageFactory();
    }
  }

  static types.EncryptionType _getEncryptionType(MessageType messageType) {
    switch (messageType) {
      case MessageType.encryptedImage:
      case MessageType.encryptedVideo:
      case MessageType.encryptedAudio:
        return UIMessage.EncryptionType.encrypted;
      default:
        return UIMessage.EncryptionType.none;
    }
  }

  static Future<types.Message?> _getRepliedMessage({
    String? replyId,
  }) async {
    if (replyId != null && replyId.isNotEmpty) {
      final repliedMessageDB = await Messages.sharedInstance.loadMessageDBFromDB(replyId);
      if (repliedMessageDB != null) {
        return await repliedMessageDB.toChatUIMessage(loadRepliedMessage: false);
      }
    }
    return null;
  }

  static Future<List<types.Reaction>> _getReactionInfo(List<String> reactionIds) async {
    final reactions = <types.Reaction>[];

    // key: content, value: Reaction model
    final reactionModelMap = <String, types.Reaction>{};
    // key: content, value: authorPubkeys
    final reactionAuthorMap = <String, Set<String>>{};

    for (final reactionId in reactionIds) {
      final note = await Moment.sharedInstance.loadNoteWithNoteId(reactionId, reload: false);
      if (note == null || note.content.isEmpty) continue ;

      final emojiURL = note.emojiURL ?? '';
      final content = emojiURL.isNotEmpty ? emojiURL : note.content;
      final reaction = reactionModelMap.putIfAbsent(
          content, () => types.Reaction(content: content));
      final reactionAuthorSet = reactionAuthorMap.putIfAbsent(
          content, () => Set());

      if (reactionAuthorSet.add(note.author)) {
        reaction.authors.add(note.author);
        if (!reactions.contains(reaction)) {
          reactions.add(reaction);
        }
      }
    }

    return reactions;
  }

  static Future<List<types.ZapsInfo>> _getZapsInfo(List<String> zapEventIds) async {
    if (zapEventIds.isEmpty) return [];

    final zaps = <types.ZapsInfo>[];
    for (final zapId in zapEventIds) {
      final zapReceipt = await Zaps.getZapReceiptFromLocal(zapId);
      if (zapReceipt.isEmpty) continue ;

      final zapDB = zapReceipt.first;

      UserDBISAR? user = await Account.sharedInstance.getUserInfo(zapDB.sender);
      if(user == null) continue;

      int amount = ZapRecordsDBISAR.getZapAmount(zapDB.bolt11);
      types.ZapsInfo info = types.ZapsInfo(author: user, amount: amount.toString(), unit: 'sats');
      zaps.add(info);
    }
    return zaps;
  }

  static Future<types.Message?> createUIMessage({
    String? messageId,
    String? remoteId,
    required String authorPubkey,
    required String contentString,
    required MessageType type,
    required int createTime, // timestamp(ms)
    required String chatId,
    UIMessage.Status? msgStatus,
    String? replyId,
    String? previewData,
    dynamic sourceKey,
    String? decryptSecret,
    String? decryptNonce,
    int? expiration,
    List<String> reactionIds = const [],
    List<String> zapsInfoIds = const [],
    Function(String content, MessageType messageType)? asyncParseCallback,
    VoidCallback? isMentionMessageCallback,
  }) async {
    // Logger
    MessageCheckLogger? logger;
    if ((remoteId ?? messageId) == ChatMessageHelper.logger?.messageId) {
      logger = ChatMessageHelper.logger;
    }

    if (messageId == null && remoteId == null) return null;

    final author = await _getUser(authorPubkey);
    if (author == null) return null;

    final contentRaw = _getContentString(contentString);
    final (content, messageType) = await _parseWithContent(
      content: contentRaw,
      messageType: type,
      decryptSecret: decryptSecret,
      decryptNonce: decryptNonce,
      asyncParseCallback: asyncParseCallback,
      isMentionMessageCallback: isMentionMessageCallback,
      logger: logger,
    );

    final fileEncryptionType = _getEncryptionType(messageType);

    final repliedMessage = await _getRepliedMessage(
      replyId: replyId,
    );

    final reactions = await _getReactionInfo(reactionIds);
    final zapsInfoList = await _getZapsInfo(zapsInfoIds);

    final messageFactory = await _getMessageFactory(messageType);
    final uiMessage = messageFactory.createMessage(
      author: author,
      timestamp: createTime,
      roomId: chatId,
      messageId: messageId,
      remoteId: remoteId,
      sourceKey: sourceKey,
      content: content,
      status: msgStatus,
      fileEncryptionType: fileEncryptionType,
      repliedMessage: repliedMessage,
      repliedMessageId: replyId,
      previewData: previewData,
      decryptKey: decryptSecret,
      decryptNonce: decryptNonce,
      expiration: expiration,
      reactions: reactions,
      zapsInfoList: zapsInfoList,
    );

    logger?.print(
      'ChatMessageHelper - createUIMessage'
      'messageId: $messageId'
      'remoteId $remoteId'
      'authorPubkey: $authorPubkey'
      'decryptContent: $contentString'
      'type: $type'
      'createTime: $createTime'
      'chatId: $chatId'
      'msgStatus: $msgStatus'
      'replyId: $replyId'
      'previewData: $previewData'
      'sourceKey: $sourceKey'
      'decryptSecret: $decryptSecret'
          'decryptNonce: $decryptNonce'
          'expiration: $expiration'
      'reactionIds: $reactionIds'
      'zapsInfoIds: $zapsInfoIds'
    );
    logger?.print('ChatMessageHelper - createUIMessage: $uiMessage');

    return uiMessage;
  }

  static Future updateMessageWithMessageId({
    required String messageId,
    PreviewData? previewData,
  }) async {
    final messageDB = await Messages.sharedInstance.loadMessageDBFromDB(messageId);
    if (messageDB == null) return ;

    if (previewData != null) {
      try {
        messageDB.previewData = jsonEncode(previewData.toJson());
      } catch (e) {
        ChatLogUtils.error(
          className: 'ChatMessageHelper',
          funcName: 'updateMessageWithMessageId',
          message: 'PreviewData encode error: $e',
        );
      }
    }

    await Messages.saveMessageToDB(messageDB);
  }
}

extension MessageDBToUIEx on MessageDBISAR {

  Future<types.Message?> toChatUIMessage({
    bool loadRepliedMessage = true,
    VoidCallback? isMentionMessageCallback,
    Function(MessageDBISAR newMessage)? asyncUpdateHandler,
  }) async {
    // Status
    final msgStatus = getStatus();

    // ChatId
    final chatId = getRoomId();
    if (chatId == null) return null;

    // Async callback
    final asyncParseCallback = (String content, MessageType messageType) async {
      parseTo(type: messageType, decryptContent: content);
      await Messages.saveMessageToDB(this);
      asyncUpdateHandler?.call(this);
    };
    return ChatMessageHelper.createUIMessage(
      messageId: messageId,
      remoteId: messageId,
      authorPubkey: sender,
      contentString: decryptContent,
      type: MessageDBISAR.stringtoMessageType(this.type),
      createTime: createTime * 1000,
      chatId: chatId,
      msgStatus: msgStatus,
      replyId: replyId,
      previewData: previewData,
      sourceKey: plaintEvent,
      decryptSecret: decryptSecret,
      decryptNonce: decryptNonce,
      expiration: expiration,
      reactionIds: reactionEventIds ?? [],
      zapsInfoIds: zapEventIds ?? [],
      asyncParseCallback: asyncParseCallback,
      isMentionMessageCallback: isMentionMessageCallback,
    );
  }

  MessageContentModel getContentModel() {
    final contentModel = MessageContentModel();
    contentModel.mid = messageId;
    contentModel.contentType = MessageDBISAR.stringtoMessageType(this.type);
    try {
      final decryptedContent = json.decode(decryptContent);
      if (decryptedContent is Map) {
        contentModel.content = decryptedContent['content'];
        contentModel.duration = decryptedContent['duration'];
      } else if (decryptedContent is String) {
        contentModel.content = decryptedContent;
      }
    } catch (e) {}

    if (contentModel.content == null) {
      contentModel.content = decryptContent;
    }

    return contentModel;
  }

  UIMessage.Status getStatus() {
    final senderIsMe = OXUserInfoManager.sharedInstance.isCurrentUser(sender);
    final status = this.status; // 0 sending, 1 sent, 2 fail 3 recall
    switch (status) {
      case 0:
        return UIMessage.Status.sending;
      case 2:
        return UIMessage.Status.error;
      default :
        break;
    }

    if (kind == 4) {
      return UIMessage.Status.warning;
    }

    return senderIsMe ? UIMessage.Status.sent : UIMessage.Status.delivered;
  }

  String? getRoomId() {
    String? chatId;
    final groupId = this.groupId;
    final senderId = this.sender;
    final receiverId = this.receiver;
    final currentUserPubKey = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey;
    if (groupId.isNotEmpty) {
      chatId = groupId;
    } else if (senderId.isNotEmpty && senderId == receiverId) {
      chatId = senderId;
    } else if (senderId.isNotEmpty && senderId != currentUserPubKey) {
      chatId = senderId;
    } else if (receiverId.isNotEmpty && receiverId != currentUserPubKey) {
      chatId = receiverId;
    }
    if (chatId == null) {
      ChatLogUtils.error(
        className: 'MessageDBToUIEx',
        funcName: 'convertMessageDBToUIModel',
        message: 'chatId is null',
      );
    }
    return chatId;
  }

  void parseTo({
    required MessageType type,
    required String decryptContent
  }) {
    this.type = MessageDBISAR.messageTypeToString(type);
    this.decryptContent = decryptContent;
  }

  String get messagePreviewText {
    final type = MessageDBISAR.stringtoMessageType(this.type);
    return ChatMessageHelper.getMessagePreviewText(decryptContent, type, sender);
  }
}

extension MessageUIToDBEx on types.Message {
  MessageType get dbMessageType {
    switch (type) {
      case types.MessageType.text:
        return MessageType.text;
      case types.MessageType.image:
        return isEncrypted ? MessageType.encryptedImage : MessageType.image;
      case types.MessageType.audio:
        return isEncrypted ? MessageType.encryptedAudio: MessageType.audio;
      case types.MessageType.video:
        return MessageType.video;
      case types.MessageType.file:
        return MessageType.file;
      case types.MessageType.custom:
        final msg = this;
        if (msg.isImageMessage) {
          return isEncrypted ? MessageType.encryptedImage : MessageType.image;
        } else if (msg.isVideoMessage) {
          return isEncrypted ? MessageType.encryptedVideo : MessageType.video;
        }
        return MessageType.template;
      case types.MessageType.system:
        return MessageType.system;
      default:
        return MessageType.text;
    }
  }

  String contentString() {
    final msg = this;

    Map map = {
      'content': content,
    };
    if (msg is types.TextMessage ||
        msg is types.ImageMessage ||
        msg is types.AudioMessage ||
        msg is types.VideoMessage ||
        msg is types.SystemMessage
    ) {
      return content;
    } else if (msg is types.CustomMessage) {
      if (msg.isImageMessage) {
        return ImageSendingMessageEx(msg).url;
      } else if (msg.isVideoMessage) {
        return VideoMessageEx(msg).url;
      }
      return msg.customContentString;
    }
    return jsonEncode(map);
  }
}

extension UserDBToUIEx on UserDBISAR {
  types.User toMessageModel() {
    types.User _user = types.User(
      id: pubKey,
      updatedAt: lastUpdatedTime,
      sourceObject: this,
    );
    return _user;
  }
}


extension UIMessageEx on types.Message {
  bool get isEncrypted => decryptKey != null;

  String get replyDisplayContent {
    final author = this.author.sourceObject;
    if (author == null) {
      return '';
    }
    final authorName = author.getUserShowName();
    return '$authorName: $messagePreviewText';
  }

  String get messagePreviewText {
    return ChatMessageHelper.getMessagePreviewText(
      this.content,
      this.dbMessageType,
      this.author.id,
    );
  }

  bool get isImageSendingMessage {
    final msg = this;
    return msg is types.CustomMessage
        && msg.customType == CustomMessageType.imageSending
        && ImageSendingMessageEx(msg).url.isEmpty;
  }

  bool get isImageMessage {
    final msg = this;
    return msg is types.CustomMessage
        && msg.customType == CustomMessageType.imageSending
        && ImageSendingMessageEx(msg).url.isNotEmpty;
  }

  bool get isVideoSendingMessage {
    final msg = this;
    return msg is types.CustomMessage
        && msg.customType == CustomMessageType.video
        && ImageSendingMessageEx(msg).url.isEmpty;
  }

  bool get isVideoMessage {
    final msg = this;
    return msg is types.CustomMessage
        && msg.customType == CustomMessageType.video
        && ImageSendingMessageEx(msg).url.isNotEmpty;
  }

  bool get isEcashMessage {
    final msg = this;
    return msg is types.CustomMessage
        && msg.customType == CustomMessageType.ecashV2;
  }

  bool get isSingleEcashMessage {
    if (!isEcashMessage) return false;

    final msg = this as types.CustomMessage;
    return EcashV2MessageEx(msg).tokenList.length == 1;
  }
}