
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
import 'package:ox_common/business_interface/ox_chat/custom_message_type.dart';
import 'package:ox_common/business_interface/ox_chat/utils.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_localizable/ox_localizable.dart';

import 'chat_data_cache.dart';

class OXValue<T> {
  OXValue(this.value);
  T value;
}

class ChatMessageHelper {

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
        return Localized.text('ox_common.message_type_call');
      case MessageType.template:
        if (contentText.isNotEmpty) {
          try {
            final decryptedContent = json.decode(contentText);
            if (decryptedContent is Map) {
              final type = CustomMessageTypeEx.fromValue(decryptedContent['type']);
              final content = decryptedContent['content'];
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
                default:
                  break ;
              }
            }
          } catch (_) { }
        }
        return Localized.text('ox_common.message_type_unknown');
      default:
        return Localized.text('ox_common.message_type_unknown');
    }
  }

  static Future<types.User?> getUser(String messageSenderPubKey) async {
    final user = await Account.sharedInstance.getUserInfo(messageSenderPubKey);
    return user?.toMessageModel();
  }
}

extension MessageDBToUIEx on MessageDBISAR {

  String get unknownMessageText => '[This message is not supported by the current client version, please update to view]';

  static MessageCheckLogger? logger; // = MessageCheckLogger('9c2d9fb78c95079c33f4d6e67556cd6edfd86b206930f97e0578987214864db2');

  Future<types.Message?> toChatUIMessage({bool loadRepliedMessage = true, VoidCallback? isMentionMessageCallback}) async {

    MessageCheckLogger? logger;

    if (this.messageId == MessageDBToUIEx.logger?.messageId) {
      logger = MessageDBToUIEx.logger;
    }

    // Msg id
    final messageId = this.messageId;

    logger?.print('step1 - messageId: $messageId');

    // ContentModel
    final contentModel = getContentModel();

    // Author
    final author = await getAuthor();
    if (author == null) return null;

    logger?.print('step2 - author: $author');

    // Status
    final msgStatus = getStatus();

    // MessageTime
    final messageTimestamp = this.createTime * 1000;

    // ChatId
    final chatId = getRoomId();
    if (chatId == null) return null;

    logger?.print('step3 - chatId: $chatId');

    logger?.print('step4 - contentType: ${contentModel.contentType}');

    // Message UI Model Creator
    MessageFactory messageFactory = getMessageFactory(
      contentModel,
      isMentionMessageCallback,
      logger,
    );

    logger?.print('step5 - messageFactory: $messageFactory');

    // Encryption type
    final fileEncryptionType = getEncryptionType(contentModel);


    // Reaction
    final reactions = await getReactionInfo();

    // Zaps
    final zapsInfoList = await getZapsInfo();

    // RepliedMessage
    final repliedMessage = await getRepliedMessage(loadRepliedMessage);
    logger?.print('step6 - replied message: $repliedMessage');

    // Execute create
    final result = messageFactory.createMessage(
      author: author,
      timestamp: messageTimestamp,
      roomId: chatId,
      remoteId: messageId,
      sourceKey: plaintEvent,
      contentModel: contentModel,
      status: msgStatus,
      fileEncryptionType: fileEncryptionType,
      repliedMessage: repliedMessage,
      repliedMessageId: this.replyId,
      previewData: this.previewData,
      decryptKey: this.decryptSecret,
      expiration: this.expiration,
      reactions: reactions,
      zapsInfoList: zapsInfoList,
    );

    logger?.print('step7 - message UIModel: $result');

    return result;
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

  Future<types.User?> getAuthor() async {
    final author = await ChatMessageHelper.getUser(sender);
    if (author == null) {
      ChatLogUtils.error(
        className: 'MessageDBToUIEx',
        funcName: 'getAuthor',
        message: 'author is null',
      );
    }
    return author;
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

  types.EncryptionType getEncryptionType(MessageContentModel contentModel) {
    switch (contentModel.contentType) {
      case MessageType.encryptedImage:
      case MessageType.encryptedVideo:
      case MessageType.encryptedAudio:
        return UIMessage.EncryptionType.encrypted;
      default:
        return UIMessage.EncryptionType.none;
    }
  }

  Future<List<types.Reaction>> getReactionInfo() async {
    final reactionIds = [...(this.reactionEventIds ?? [])];
    final reactions = <types.Reaction>[];

    // key: content, value: Reaction model
    final reactionModelMap = <String, types.Reaction>{};
    // key: content, value: authorPubkeys
    final reactionAuthorMap = <String, Set<String>>{};

    for (final reactionId in reactionIds) {
      final note = await Moment.sharedInstance.loadNoteWithNoteId(reactionId, reload: false);
      if (note == null || note.content.isEmpty) continue ;

      final content = note.content;
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

  Future<List<types.ZapsInfo>> getZapsInfo() async {
    final zapEventIds = [...(this.zapEventIds ?? [])];
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

  Future<types.Message?> getRepliedMessage(bool loadRepliedMessage) async {
    if (replyId.isNotEmpty && loadRepliedMessage) {
      final repliedMessageDB = await Messages.sharedInstance.loadMessageDBFromDB(replyId);
      if (repliedMessageDB != null) {
        return await repliedMessageDB.toChatUIMessage(loadRepliedMessage: false);
      }
    }
    return null;
  }

  MessageFactory getMessageFactory(
    MessageContentModel contentModel,
    [
      VoidCallback? isMentionMessageCallback = null,
      MessageCheckLogger? logger,
    ]
  ) {
    final messageType = contentModel.contentType;
    switch (messageType) {
      case MessageType.text:
        final initialText = contentModel.content ?? '';

        final mentionDecodeText = ChatMentionMessageEx.tryDecoder(initialText, mentionsCallback: (mentions) {
          if (mentions.isEmpty) return ;
          final hasCurrentUser = mentions.any((mention) => OXUserInfoManager.sharedInstance.isCurrentUser(mention.pubkey));
          if (hasCurrentUser) {
            isMentionMessageCallback?.call();
          }
        });

        if (mentionDecodeText != null) {
          // Mention Msg
          contentModel.content = mentionDecodeText;
        } else if (ChatNostrSchemeHandle.getNostrScheme(initialText) != null) {
          // Template Msg
          ChatNostrSchemeHandle.tryDecodeNostrScheme(initialText).then((nostrSchemeContent) async {
            logger?.print('step async - initialText: $initialText, nostrSchemeContent: ${nostrSchemeContent}');
            if(nostrSchemeContent != null) {
              parseTo(type: MessageType.template, decryptContent: nostrSchemeContent);
              await Messages.saveMessageToDB(this);
              final key = ChatDataCacheGeneralMethodEx.getChatTypeKeyWithMessage(this);
              final uiMessage = await this.toChatUIMessage();
              if(uiMessage != null){
                ChatDataCache.shared.updateMessage(chatKey: key, message: uiMessage);
              }
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
            parseTo(type: MessageType.template, decryptContent: jsonEncode(map));
            contentModel.content = this.decryptContent;
            logger?.print('step async - initialText: $initialText, decryptContent: ${decryptContent}');
            Messages.saveMessageToDB(this);
            return CustomMessageFactory();
          }
        } else if (Cashu.isCashuToken(initialText)) {
          // Ecash Msg
          parseTo(type: MessageType.template, decryptContent: jsonEncode(CustomMessageEx.ecashV2MetaData(tokenList: [initialText])));
          contentModel.content = this.decryptContent;
          logger?.print('step async - initialText: $initialText, decryptContent: ${decryptContent}');
          Messages.saveMessageToDB(this);
          return CustomMessageFactory();
        }

        return TextMessageFactory();
      case MessageType.image:
      case MessageType.encryptedImage:
        final meta = CustomMessageEx.imageSendingMetaData(
          url: contentModel.content ?? '',
          encryptedKey: decryptSecret,
        );
        try {
          contentModel.content = jsonEncode(meta);
          return CustomMessageFactory();
        } catch (_) { }
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
        final customInfo = CustomMessageFactory.parseFromContentString(contentModel.content ?? '');
        if (customInfo != null) {
          return CustomMessageFactory();
        }
      default:
        ChatLogUtils.error(
          className: 'MessageDBToUIEx',
          funcName: 'convertMessageDBToUIModel',
          message: 'unknown message type',
        );
    }

    parseTo(type: MessageType.text, decryptContent: unknownMessageText);
    contentModel.content = unknownMessageText;
    return TextMessageFactory();
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
  MessageType dbMessageType({bool encrypt = false}) {
    switch (type) {
      case types.MessageType.text:
        return MessageType.text;
      case types.MessageType.image:
        return encrypt ? MessageType.encryptedImage : MessageType.image;
      case types.MessageType.audio:
        return MessageType.audio;
      case types.MessageType.video:
        return MessageType.video;
      case types.MessageType.file:
        return MessageType.file;
      case types.MessageType.custom:
        final msg = this;
        if (msg.isImageMessage) {
          return encrypt ? MessageType.encryptedImage : MessageType.image;
        }
        return MessageType.template;
      case types.MessageType.system:
        return MessageType.system;
      default:
        return MessageType.text;
    }
  }

  String contentString(String content) {
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
      this.dbMessageType(),
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
}

extension UIImageMessageEx on types.ImageMessage {
  types.Message asCustomImageMessage() {
    return CustomMessageFactory().createImageSendingMessage(
      author: author,
      timestamp: this.createdAt,
      roomId: roomId ?? '',
      id: id,
      path: '',
      url: uri,
      width: width?.toInt(),
      height: height?.toInt(),
      encryptedKey: decryptKey,
      remoteId: remoteId,
      sourceKey: sourceKey,
      expiration: expiration,
      reactions: reactions,
      zapsInfoList: zapsInfoList,
    );
  }
}