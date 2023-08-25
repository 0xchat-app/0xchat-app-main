
import 'dart:convert';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_types/src/message.dart';
import 'package:ox_chat/model/message_content_model.dart';
import 'package:ox_chat/utils/custom_message_utils.dart';

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
  }) {
    final mid = contentModel.mid;
    if (mid == null) {
      return null;
    }
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
  }) {
    final mid = contentModel.mid;
    final uri = contentModel.content;
    if (mid == null || uri == null) {
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
  }) {
    final mid = contentModel.mid;
    final uri = contentModel.content;
    if (mid == null || uri == null) {
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
  }) {
    final mid = contentModel.mid;
    final uri = contentModel.content;
    final snapshotUrl = '${uri}?spm=qipa250&x-oss-process=video/snapshot,t_7000,f_jpg,w_0,h_0,m_fast';
    if (mid == null || uri == null) {
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
}