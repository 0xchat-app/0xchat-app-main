
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
import 'package:ox_common/utils/custom_uri_helper.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_localizable/ox_localizable.dart';

import 'chat_data_cache.dart';

class OXValue<T> {
  OXValue(this.value);
  T value;
}

class ChatMessageDBToUIHelper {

  static String? sessionMessageTextBuilder(MessageDB message) {
    final type = MessageDB.stringtoMessageType(message.type);
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
            if (userDB is UserDB) {
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

extension MessageDBToUIEx on MessageDB {

  String get unknownMessageText => '[This message is not supported by the current client version, please update to view]';

  Future<types.Message?> toChatUIMessage({bool loadRepliedMessage = true, VoidCallback? isMentionMessageCallback}) async {

    MessageCheckLogger? logger;
    // logger = MessageCheckLogger('9c2d9fb78c95079c33f4d6e67556cd6edfd86b206930f97e0578987214864db2');
    // if (this.messageId != logger.messageId) return null;

    // Msg id
    final messageId = this.messageId;

    logger?.printMessage = '1';
    ChatLogUtils.debug(className: 'MessageDBToUIEx', funcName: 'toChatUIMessage', logger: logger);

    // ContentModel
    final contentModel = getContentModel();

    // Author
    final author = await getAuthor();
    if (author == null) return null;

    logger?.printMessage = '2';
    ChatLogUtils.debug(className: 'MessageDBToUIEx', funcName: 'toChatUIMessage', logger: logger);

    // Status
    final msgStatus = getStatus();

    // MessageTime
    final messageTimestamp = this.createTime * 1000;

    // ChatId
    final chatId = getRoomId();
    if (chatId == null) return null;

    logger?.printMessage = '3';
    ChatLogUtils.debug(className: 'MessageDBToUIEx', funcName: 'toChatUIMessage', logger: logger);

    logger?.printMessage = '4 ${contentModel.contentType}';
    ChatLogUtils.debug(className: 'MessageDBToUIEx', funcName: 'toChatUIMessage', logger: logger);

    // Message UI Model Creator
    MessageFactory messageFactory = await getMessageFactory(
      contentModel,
      isMentionMessageCallback,
    );

    logger?.printMessage = '5';
    ChatLogUtils.debug(className: 'MessageDBToUIEx', funcName: 'toChatUIMessage', logger: logger);

    // Encryption type
    final fileEncryptionType = getEncryptionType(contentModel);

    // RepliedMessage
    final repliedMessage = await getRepliedMessage(loadRepliedMessage);

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
      previewData: this.previewData,
      decryptKey: this.decryptSecret,
      expiration: this.expiration,
    );

    logger?.printMessage = '6 $result';
    ChatLogUtils.debug(className: 'MessageDBToUIEx', funcName: 'toChatUIMessage', logger: logger);

    return result;
  }

  MessageContentModel getContentModel() {
    final contentModel = MessageContentModel();
    contentModel.mid = messageId;
    contentModel.contentType = MessageDB.stringtoMessageType(this.type);
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
    final author = await ChatMessageDBToUIHelper.getUser(sender);
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
      case 1:
      case 3:
        return senderIsMe ? UIMessage.Status.sent : UIMessage.Status.delivered;
      case 2:
        return UIMessage.Status.error;
      default :
        return senderIsMe ? UIMessage.Status.sent : UIMessage.Status.delivered;
    }
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


  Future<types.Message?> getRepliedMessage(bool loadRepliedMessage) async {
    if (replyId.isNotEmpty && loadRepliedMessage) {
      final result = await Messages.loadMessagesFromDB(where: 'messageId = ?', whereArgs: [replyId]);
      final messageList = result['messages'];
      if (messageList is List<MessageDB> && messageList.isNotEmpty) {
        final repliedMessageDB = messageList.first;
        return await repliedMessageDB.toChatUIMessage(loadRepliedMessage: false);
      }
    }
    return null;
  }

  Future<MessageFactory> getMessageFactory(
    MessageContentModel contentModel,
    [VoidCallback? isMentionMessageCallback = null]
  ) async {
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
          contentModel.content = ChatNostrSchemeHandle.blankToMessageContent();
          ChatNostrSchemeHandle.tryDecodeNostrScheme(initialText).then((nostrSchemeContent) async {
            if(nostrSchemeContent != null) {
              parseTo(type: MessageType.template, decryptContent: nostrSchemeContent);
              await DB.sharedInstance.update(this);
              final key = ChatDataCacheGeneralMethodEx.getChatTypeKeyWithMessage(this);
              final uiMessage = await this.toChatUIMessage();
              if(uiMessage != null){
                ChatDataCache.shared.updateMessage(chatKey: key, message: uiMessage);
              }
            }
          });
          return CustomMessageFactory();
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
            await DB.sharedInstance.update(this);
            return CustomMessageFactory();
          }
        } else if (Cashu.isCashuToken(initialText)) {
          // Ecash Msg
          parseTo(type: MessageType.template, decryptContent: jsonEncode(CustomMessageEx.ecashV2MetaData(tokenList: [initialText])));
          contentModel.content = this.decryptContent;
          await DB.sharedInstance.update(this);
          return CustomMessageFactory();
        }

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
    this.type = MessageDB.messageTypeToString(type);
    this.decryptContent = decryptContent;
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
      return msg.customContentString;
    }
    return jsonEncode(map);
  }
}

extension UserDBToUIEx on UserDB {
  types.User toMessageModel() {
    types.User _user = types.User(
      id: pubKey,
      updatedAt: lastUpdatedTime,
      sourceObject: this,
    );
    return _user;
  }

  String getUserShowName() {
    final nickName = (this.nickName ?? '').trim();
    final name = (this.name ?? '').trim();
    if (nickName.isNotEmpty) return nickName;
    if (name.isNotEmpty) return name;
    return 'unknown';
  }

  updateWith(UserDB user) {
    name = user.name;
    picture = user.picture;
    about = user.about;
    lnurl = user.lnurl;
    gender = user.gender;
    area = user.area;
    dns = user.dns;
  }
}


extension UIMessageEx on types.Message {
  String get replyDisplayContent {
    final author = this.author.sourceObject;
    if (author == null) {
      return '';
    }
    final authorName = author.getUserShowName();
    final previewText = ChatMessageDBToUIHelper.getMessagePreviewText(
      this.content,
      this.dbMessageType(),
      this.author.id,
    );
    return '$authorName: $previewText';
  }
}
