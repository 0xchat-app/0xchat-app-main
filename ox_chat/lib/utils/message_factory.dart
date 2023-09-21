
import 'dart:convert';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_types/src/message.dart';
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_common/business_interface/ox_chat/call_message_type.dart';
import 'package:ox_common/business_interface/ox_chat/custom_message_type.dart';
import 'package:ox_chat/model/message_content_model.dart';
import 'package:ox_chat/utils/custom_message_utils.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_localizable/ox_localizable.dart';

import 'general_handler/chat_mention_handler.dart';

abstract class MessageFactory {
  types.Message? createMessage({
    required types.User author,
    required int timestamp,
    required String roomId,
    required String remoteId,
    required dynamic sourceKey,
    required MessageContentModel contentModel,
    required Status status,
    EncryptionType fileEncryptionType = EncryptionType.none,
    types.Message? repliedMessage,
  });
}

class TextMessageFactory implements MessageFactory {
  types.Message? createMessage({
    required types.User author,
    required int timestamp,
    required String roomId,
    required String remoteId,
    required dynamic sourceKey,
    required MessageContentModel contentModel,
    required Status status,
    EncryptionType fileEncryptionType = EncryptionType.none,
    types.Message? repliedMessage,
  }) {
    final text = contentModel.content ?? '';
    return types.TextMessage(
      author: author,
      createdAt: timestamp,
      id: remoteId,
      sourceKey: sourceKey,
      roomId: roomId,
      remoteId: remoteId,
      text: text,
      status: status,
      repliedMessage: repliedMessage,
    );
  }
}

class ImageMessageFactory implements MessageFactory {
  types.Message? createMessage({
    required types.User author,
    required int timestamp,
    required String roomId,
    required String remoteId,
    required dynamic sourceKey,
    required MessageContentModel contentModel,
    required Status status,
    EncryptionType fileEncryptionType = EncryptionType.none,
    types.Message? repliedMessage,
  }) {
    final uri = contentModel.content;
    if (uri == null) {
      return null;
    }
    return types.ImageMessage(
      name: '',
      size: 60,
      uri: uri,
      author: author,
      createdAt: timestamp,
      id: remoteId,
      sourceKey: sourceKey,
      roomId: roomId,
      remoteId: remoteId,
      status: status,
      fileEncryptionType: fileEncryptionType,
    );
  }
}

class AudioMessageFactory implements MessageFactory {
  types.Message? createMessage({
    required types.User author,
    required int timestamp,
    required String roomId,
    required String remoteId,
    required dynamic sourceKey,
    required MessageContentModel contentModel,
    required Status status,
    EncryptionType fileEncryptionType = EncryptionType.none,
    types.Message? repliedMessage,
  }) {
    final uri = contentModel.content;
    if (uri == null) {
      return null;
    }
    return types.AudioMessage(
      duration: null,
      name: '${contentModel.mid}.mp3',
      size: 60,
      uri: uri,
      author: author,
      createdAt: timestamp,
      id: remoteId,
      sourceKey: sourceKey,
      roomId: roomId,
      remoteId: remoteId,
      status: status,
      fileEncryptionType: fileEncryptionType,
    );
  }
}

class VideoMessageFactory implements MessageFactory {
  types.Message? createMessage({
    required types.User author,
    required int timestamp,
    required String roomId,
    required String remoteId,
    required dynamic sourceKey,
    required MessageContentModel contentModel,
    required Status status,
    EncryptionType fileEncryptionType = EncryptionType.none,
    types.Message? repliedMessage,
  }) {
    final uri = contentModel.content;
    final snapshotUrl = '${uri}?spm=qipa250&x-oss-process=video/snapshot,t_7000,f_jpg,w_0,h_0,m_fast';
    if (uri == null) {
      return null;
    }
    return types.VideoMessage(
      name: '${contentModel.mid}.mp4',
      size: 60,
      uri: snapshotUrl,
      metadata: {
        "videoUrl": uri,
      },
      author: author,
      createdAt: timestamp,
      id: remoteId,
      sourceKey: sourceKey,
      roomId: roomId,
      remoteId: remoteId,
      status: status,
      fileEncryptionType: fileEncryptionType,
    );
  }
}

class SystemMessageFactory implements MessageFactory {
  types.Message? createMessage({
    required types.User author,
    required int timestamp,
    required String roomId,
    required String remoteId,
    required dynamic sourceKey,
    required MessageContentModel contentModel,
    required Status status,
    EncryptionType fileEncryptionType = EncryptionType.none,
    types.Message? repliedMessage,
  }) {
    var text = contentModel.content ?? '';
    final key = text;
    if (key.isNotEmpty) {
      text = Localized.text(key, useOrigin: true);
      if (key == 'ox_chat.screen_record_hint_message' || key == 'ox_chat.screenshot_hint_message') {
        final isMe = OXUserInfoManager.sharedInstance.isCurrentUser(author.id);
        final name = isMe ? Localized.text('ox_common.you') : (author.sourceObject?.getUserShowName() ?? '');
        text = text.replaceAll(r'${user}', name);
      }
    }
    return types.SystemMessage(
      author: author,
      createdAt: timestamp,
      id: remoteId,
      roomId: roomId,
      text: text,
    );
  }
}

class CustomMessageFactory implements MessageFactory {
  types.Message? createMessage({
    required types.User author,
    required int timestamp,
    required String roomId,
    required String remoteId,
    required dynamic sourceKey,
    required MessageContentModel contentModel,
    required Status status,
    EncryptionType fileEncryptionType = EncryptionType.none,
    types.Message? repliedMessage,
  }) {
    final contentString = contentModel.content;
    if (contentString == null) return null;

    try {
      final contentMap = json.decode(contentString);
      if (contentMap is! Map) return null;

      final type = CustomMessageTypeEx.fromValue(contentMap['type']);
      final content = contentMap['content'];
      if (type == null || content is! Map) return null;

      switch (type) {
        case CustomMessageType.zaps:
          final zapper = content['zapper'];
          final invoice = content['invoice'];
          final amount = content['amount'];
          final description = content['description'];
          return createZapsMessage(
            author: author,
            timestamp: timestamp,
            id: remoteId,
            roomId: roomId,
            remoteId: remoteId,
            sourceKey: sourceKey,
            zapper: zapper,
            invoice: invoice,
            amount: amount,
            description: description,
          );
        case CustomMessageType.call:
          final text = content['text'];
          final type = CallMessageTypeEx.fromValue(content['type']);
          if (type == null) return null;
          return createCallMessage(
            author: author,
            timestamp: timestamp,
            id: remoteId,
            roomId: roomId,
            remoteId: remoteId,
            sourceKey: sourceKey,
            text: text,
            type: type,
          );
        default :
          return null;
      }
    } catch (e) {
      return null;
    }
  }

  types.CustomMessage createZapsMessage({
    required types.User author,
    required int timestamp,
    required String roomId,
    required String id,
    String? remoteId,
    dynamic sourceKey,
    required String zapper,
    required String invoice,
    required String amount,
    required String description,
  }) {
    return types.CustomMessage(
      author: author,
      createdAt: timestamp,
      id: id,
      sourceKey: sourceKey,
      remoteId: remoteId,
      roomId: roomId,
      metadata: CustomMessageEx.zapsMetaData(
        zapper: zapper,
        invoice: invoice,
        amount: amount,
        description: description,
      ),
      type: types.MessageType.custom,
    );
  }

  types.CustomMessage createCallMessage({
    required types.User author,
    required int timestamp,
    required String roomId,
    required String id,
    String? remoteId,
    dynamic sourceKey,
    required String text,
    required CallMessageType type,
  }) {
    return types.CustomMessage(
      author: author,
      createdAt: timestamp,
      id: id,
      sourceKey: sourceKey,
      remoteId: remoteId,
      roomId: roomId,
      metadata: CustomMessageEx.callMetaData(
        text: text,
        type: type,
      ),
      type: types.MessageType.custom,
    );
  }
}