
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_types/src/message.dart';
import 'package:ox_chat/model/message_content_model.dart';

abstract class MessageFactory {
  types.Message? createMessage({
    required types.User author,
    required int timestamp,
    required String roomId,
    required String remoteId,
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
      roomId: roomId,
      remoteId: remoteId,
      status: status,
      fileEncryptionType: fileEncryptionType,
    );
  }
}