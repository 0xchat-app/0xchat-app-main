
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:chatcore/chat-core.dart';
import 'package:flutter_chat_types/src/message.dart' as UIMessage;
import 'package:ox_chat/model/message_content_model.dart';
import 'package:ox_chat/utils/chat_log_utils.dart';
import 'package:ox_chat/utils/custom_message_utils.dart';
import 'package:ox_chat/utils/general_handler/chat_mention_handler.dart';
import 'package:ox_chat/utils/message_factory.dart';
import 'package:ox_common/business_interface/ox_chat/custom_message_type.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_localizable/ox_localizable.dart';

class OXValue<T> {
  OXValue(this.value);
  T value;
}

class ChatMessageDBToUIHelper {

  static String? sessionMessageTextBuilder(MessageDB message) {
    final type = MessageDB.stringtoMessageType(message.type ?? '');
    final decryptContent = message.decryptContent ?? '';
    if (type == MessageType.text && decryptContent.isNotEmpty) {
      final mentionDecoderText = ChatMentionMessageEx.tryDecoder(decryptContent);
      return mentionDecoderText;
    }
    return null;
  }

  static Future<types.User?> getUser(String messageSenderPubKey) async {
    final user = await Account.sharedInstance.getUserInfo(messageSenderPubKey);
    return user?.toMessageModel();
  }
}

extension MessageDBToUIEx on MessageDB {

  Future<types.Message?> toChatUIMessage({bool loadRepliedMessage = true, VoidCallback? isMentionMessageCallback}) async {

    // Msg id
    final messageId = this.messageId;

    // ContentModel
    final decryptContent = this.decryptContent;
    if (decryptContent == null) {
      ChatLogUtils.error(
        className: 'ChatDataCache',
        funcName: 'convertMessageDBToUIModel',
        message: 'message.decryptContent is null',
      );
      return null;
    }

    MessageContentModel contentModel = MessageContentModel();
    contentModel.mid = messageId;
    contentModel.contentType = MessageDB.stringtoMessageType(this.type ?? '');
    try {
      final decryptedContent = json.decode(decryptContent);
      if (decryptedContent is Map) {
        contentModel.content = decryptedContent['content'];
        contentModel.duration = decryptedContent['duration'];
      } else if (decryptedContent is String) {
        contentModel.content = decryptedContent.toString();
      }
    } catch (e) {}

    if (contentModel.content == null) {
      contentModel.content = decryptContent;
    }

    // Author
    final senderId = this.sender;
    if (senderId == null) {
      ChatLogUtils.error(
        className: 'ChatDataCache',
        funcName: 'convertMessageDBToUIModel',
        message: 'message.sender is null',
      );
      return null;
    }
    final author = await ChatMessageDBToUIHelper.getUser(senderId);
    if (author == null) {
      ChatLogUtils.error(
        className: 'ChatDataCache',
        funcName: 'convertMessageDBToUIModel',
        message: 'author is null',
      );
      return null;
    }

    // Status
    final senderIsMe = OXUserInfoManager.sharedInstance.isCurrentUser(senderId);
    final status = this.status; // 0 sending, 1 sent, 2 fail 3 recall
    UIMessage.Status msgStatus;
    switch (status) {
      case 0:
        msgStatus = UIMessage.Status.sending;
        break ;
      case 1:
      case 3:
        msgStatus = senderIsMe ? UIMessage.Status.sent : UIMessage.Status.delivered;
        break ;
      case 2:
        msgStatus = UIMessage.Status.error;
        break ;
      default :
        msgStatus = senderIsMe ? UIMessage.Status.sent : UIMessage.Status.delivered;
    }

    // MessageTime
    final createTime = this.createTime;
    final messageTimestamp = createTime != null ? createTime * 1000: null;
    if (messageTimestamp == null) {
      ChatLogUtils.error(
        className: 'ChatDataCache',
        funcName: 'convertMessageDBToUIModel',
        message: 'messageTimestamp is null',
      );
      return null;
    }

    // ChatId
    final chatId = getRoomId();
    if (chatId == null) {
      ChatLogUtils.error(
        className: 'ChatDataCache',
        funcName: 'convertMessageDBToUIModel',
        message: 'chatId is null',
      );
      return null;
    }

    // MessageType & mid & MessageId
    final mid = contentModel.mid;
    final messageType = contentModel.contentType;
    if (mid == null || mid.isEmpty) {
      ChatLogUtils.error(
        className: 'ChatDataCache',
        funcName: 'convertMessageDBToUIModel',
        message: 'messageType: $messageType, mid: $mid',
      );
      return null;
    }

    MessageFactory messageFactory;
    switch (messageType) {
      case MessageType.text:
        messageFactory = TextMessageFactory();
        final initialText = contentModel.content ?? '';
        final mentionDecodeText = ChatMentionMessageEx.tryDecoder(initialText);
        if (mentionDecodeText != null) {
          contentModel.content = mentionDecodeText;
          isMentionMessageCallback?.call();
        }
        break ;
      case MessageType.image:
      case MessageType.encryptedImage:
        messageFactory = ImageMessageFactory();
        break ;
      case MessageType.video:
      case MessageType.encryptedVideo:
        messageFactory = VideoMessageFactory();
        break ;
      case MessageType.audio:
      case MessageType.encryptedAudio:
        messageFactory = AudioMessageFactory();
        break ;
      case MessageType.system:
        messageFactory = SystemMessageFactory();
        break ;
      case MessageType.template:
        messageFactory = CustomMessageFactory();
        break ;
      default:
        ChatLogUtils.error(className: 'ChatDataCache', funcName: 'convertMessageDBToUIModel', message: 'unknown message type');
        return null;
    }

    UIMessage.EncryptionType fileEncryptionType;
    switch (messageType) {
      case MessageType.encryptedImage:
      case MessageType.encryptedVideo:
      case MessageType.encryptedAudio:
        fileEncryptionType = UIMessage.EncryptionType.encrypted;
        break ;
      default:
        fileEncryptionType = UIMessage.EncryptionType.none;
    }

    // repliedMessage
    types.Message? repliedMessage;
    if (replyId.isNotEmpty && loadRepliedMessage) {
      final result = await Messages.loadMessagesFromDB(where: 'messageId = ?', whereArgs: [replyId]);
      final messageList = result['messages'];
      if (messageList is List<MessageDB> && messageList.isNotEmpty) {
        final repliedMessageDB = messageList.first;
        repliedMessage = await repliedMessageDB.toChatUIMessage(loadRepliedMessage: false);
      }
    }

    return messageFactory.createMessage(
      author: author,
      timestamp: messageTimestamp,
      roomId: chatId,
      remoteId: messageId,
      sourceKey: originEvent,
      contentModel: contentModel,
      status: msgStatus,
      fileEncryptionType: fileEncryptionType,
      repliedMessage: repliedMessage,
    );
  }

  String? getRoomId() {
    String? chatId;
    final groupId = this.groupId ?? '';
    final senderId = this.sender ?? '';
    final receiverId = this.receiver ?? '';
    final currentUserPubKey = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey;
    if (groupId.isNotEmpty) {
      chatId = groupId;
    } else if (senderId.isNotEmpty && senderId != currentUserPubKey) {
      chatId = senderId;
    } else if (receiverId.isNotEmpty && receiverId != currentUserPubKey) {
      chatId = receiverId;
    }
    return chatId;
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

    final replyMessage = this;
    final authorName = author.getUserShowName();
    String? messageText;
    if (replyMessage is types.TextMessage) {
      messageText = replyMessage.text;
    } else if (replyMessage is types.ImageMessage) {
      messageText = Localized.text('ox_common.message_type_image');
    } else if (replyMessage is types.AudioMessage) {
      messageText = Localized.text('ox_common.message_type_audio');
    } else if (replyMessage is types.VideoMessage) {
      messageText = Localized.text('ox_common.message_type_video');
    } else if (replyMessage is types.CustomMessage) {
      final customType = replyMessage.customType;
      switch (customType) {
        case CustomMessageType.zaps:
          messageText = Localized.text('ox_common.message_type_zaps');
          break ;
        case CustomMessageType.zaps:
          messageText = Localized.text('ox_common.message_type_call');
          break ;
        default:
          break ;
      }
    }
    if (messageText == null) {
      messageText = '[unknown type]';
    }
    return '$authorName: $messageText';
  }
}
