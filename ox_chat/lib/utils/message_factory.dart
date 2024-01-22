
import 'dart:convert';
import 'dart:math';

import 'package:chatcore/chat-core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:flutter_chat_types/src/message.dart' as UIMessage;
import 'package:flutter_chat_types/src/preview_data.dart';
import 'package:ox_common/business_interface/ox_chat/call_message_type.dart';
import 'package:ox_common/business_interface/ox_chat/custom_message_type.dart';
import 'package:ox_chat/model/message_content_model.dart';
import 'package:ox_chat/utils/custom_message_utils.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_localizable/ox_localizable.dart';

abstract class MessageFactory {
  types.Message? createMessage({
    required types.User author,
    required int timestamp,
    required String roomId,
    required String remoteId,
    required dynamic sourceKey,
    required MessageContentModel contentModel,
    required UIMessage.Status status,
    UIMessage.EncryptionType fileEncryptionType = UIMessage.EncryptionType.none,
    types.Message? repliedMessage,
    String? previewData,
    String? decryptKey,
    int? expiration,
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
    required UIMessage.Status status,
    UIMessage.EncryptionType fileEncryptionType = UIMessage.EncryptionType.none,
    types.Message? repliedMessage,
    String? previewData,
    String? decryptKey,
    int? expiration,
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
      previewData: previewData != null
          ? PreviewData.fromJson(jsonDecode(previewData))
          : null,
      expiration: expiration,
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
    required UIMessage.Status status,
    UIMessage.EncryptionType fileEncryptionType = UIMessage.EncryptionType.none,
    types.Message? repliedMessage,
    String? previewData,
    String? decryptKey,
    int? expiration,
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
      decryptKey: decryptKey,
      expiration: expiration,
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
    required UIMessage.Status status,
    UIMessage.EncryptionType fileEncryptionType = UIMessage.EncryptionType.none,
    types.Message? repliedMessage,
    String? previewData,
    String? decryptKey,
    int? expiration,
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
      decryptKey: decryptKey,
      expiration: expiration,
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
    required UIMessage.Status status,
    UIMessage.EncryptionType fileEncryptionType = UIMessage.EncryptionType.none,
    types.Message? repliedMessage,
    String? previewData,
    String? decryptKey,
    int? expiration,
  }) {
    final uri = contentModel.content;
    final snapshotUrl =
        '${uri}?spm=qipa250&x-oss-process=video/snapshot,t_7000,f_jpg,w_0,h_0,m_fast';
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
      decryptKey: decryptKey,
      expiration: expiration,
    );
  }
}

class CallMessageFactory implements MessageFactory {
  types.Message? createMessage({
    required types.User author,
    required int timestamp,
    required String roomId,
    required String remoteId,
    required dynamic sourceKey,
    required MessageContentModel contentModel,
    required UIMessage.Status status,
    UIMessage.EncryptionType fileEncryptionType = UIMessage.EncryptionType.none,
    types.Message? repliedMessage,
    String? previewData,
    String? decryptKey,
    int? expiration,
  }) {
    final contentString = contentModel.content;
    if (contentString == null) return null;

    var contentMap;
    try {
      contentMap = json.decode(contentString);
      if (contentMap is! Map) return null;
    } catch (_) {}

    final state = CallMessageState.values.cast<CallMessageState?>().firstWhere(
        (state) => state.toString() == contentMap['state'],
        orElse: () => null);
    var duration = contentMap['duration'];
    final media = CallMessageTypeEx.fromValue(contentMap['media']);
    if (state is! CallMessageState || duration is! int || media == null)
      return null;

    if (!state.shouldShowMessage) return null;

    duration = max(duration, 0);
    final isMe = OXUserInfoManager.sharedInstance.isCurrentUser(author.id);
    final durationText =
        Duration(milliseconds: duration).toString().substring(2, 7);
    return types.CustomMessage(
      author: author,
      createdAt: timestamp,
      id: remoteId,
      sourceKey: sourceKey,
      remoteId: remoteId,
      roomId: roomId,
      metadata: CustomMessageEx.callMetaData(
        text: state.messageText(isMe, durationText),
        type: media,
      ),
      type: types.MessageType.custom,
      expiration: expiration,
    );
  }
}

extension CallStateMessageEx on CallMessageState {
  bool get shouldShowMessage {
    switch (this) {
      case CallMessageState.cancel:
      case CallMessageState.reject:
      case CallMessageState.timeout:
      case CallMessageState.disconnect:
      case CallMessageState.inCalling:
        return true;
      default:
        return false;
    }
  }

  String messageText(bool isMe, String durationText) {
    switch (this) {
      case CallMessageState.cancel:
        return isMe
            ? Localized.text('ox_calling.str_call_canceled')
            : Localized.text('ox_calling.str_call_other_canceled');
      case CallMessageState.reject:
        return isMe
            ? Localized.text('ox_calling.str_call_other_rejected')
            : Localized.text('ox_calling.str_call_rejected');
      case CallMessageState.timeout:
        return isMe
            ? Localized.text('ox_calling.str_call_other_not_answered')
            : Localized.text('ox_calling.str_call_not_answered');
      case CallMessageState.disconnect:
        return Localized.text('ox_calling.str_call_duration')
            .replaceAll(r'${time}', durationText);
      case CallMessageState.inCalling:
        return Localized.text('ox_calling.str_call_busy');
      default:
        return '';
    }
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
    required UIMessage.Status status,
    UIMessage.EncryptionType fileEncryptionType = UIMessage.EncryptionType.none,
    types.Message? repliedMessage,
    String? previewData,
    String? decryptKey,
    int? expiration,
  }) {
    var text = contentModel.content ?? '';
    final key = text;
    if (key.isNotEmpty) {
      text = Localized.text(key, useOrigin: true);
      if (key == 'ox_chat.screen_record_hint_message' ||
          key == 'ox_chat.screenshot_hint_message') {
        final isMe = OXUserInfoManager.sharedInstance.isCurrentUser(author.id);
        final name = isMe
            ? Localized.text('ox_common.you')
            : (author.sourceObject?.getUserShowName() ?? '');
        text = text.replaceAll(r'${user}', name);
      }
    }
    return types.SystemMessage(
      author: author,
      createdAt: timestamp,
      id: remoteId,
      roomId: roomId,
      text: text,
      expiration: expiration,
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
    required UIMessage.Status status,
    UIMessage.EncryptionType fileEncryptionType = UIMessage.EncryptionType.none,
    types.Message? repliedMessage,
    String? previewData,
    String? decryptKey,
    int? expiration,
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
            roomId: roomId,
            id: remoteId,
            remoteId: remoteId,
            sourceKey: sourceKey,
            zapper: zapper,
            invoice: invoice,
            amount: amount,
            description: description,
            expiration: expiration,
          );
        case CustomMessageType.template:
          final title = content['title'];
          final contentStr = content['content'];
          final icon = content['icon'];
          final link = content['link'];
          return createTemplateMessage(
            author: author,
            timestamp: timestamp,
            roomId: roomId,
            id: remoteId,
            remoteId: remoteId,
            sourceKey: sourceKey,
            title: title,
            content: contentStr,
            icon: icon,
            link: link,
            expiration: expiration,
          );
        case CustomMessageType.note:
          final authorIcon = content['authorIcon'];
          final authorName = content['authorName'];
          final authorDNS = content['authorDNS'];
          final createTime = content['createTime'];
          final note = content['note'];
          final image = content['image'];
          final link = content['link'];
          return createNoteMessage(
            author: author,
            timestamp: timestamp,
            roomId: roomId,
            id: remoteId,
            remoteId: remoteId,
            sourceKey: sourceKey,
            authorIcon: authorIcon,
            authorName: authorName,
            authorDNS: authorDNS,
            createTime: createTime,
            note: note,
            image: image,
            link: link,
            expiration: expiration,
          );

        case CustomMessageType.ecash:
          final token = content['token'];
          return createEcashMessage(
            author: author,
            timestamp: timestamp,
            roomId: roomId,
            id: remoteId,
            remoteId: remoteId,
            sourceKey: sourceKey,
            token: token,
            expiration: expiration,
          );
        default:
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
    int? expiration,
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

  types.CustomMessage createTemplateMessage({
    required types.User author,
    required int timestamp,
    required String roomId,
    required String id,
    String? remoteId,
    dynamic sourceKey,
    required String title,
    required String content,
    required String icon,
    required String link,
    int? expiration,
  }) {
    return types.CustomMessage(
      author: author,
      createdAt: timestamp,
      id: id,
      sourceKey: sourceKey,
      remoteId: remoteId,
      roomId: roomId,
      metadata: CustomMessageEx.templateMetaData(
        title: title,
        content: content,
        icon: icon,
        link: link,
      ),
      type: types.MessageType.custom,
    );
  }

  types.CustomMessage createNoteMessage({
    required types.User author,
    required int timestamp,
    required String roomId,
    required String id,
    String? remoteId,
    dynamic sourceKey,
    required String authorIcon,
    required String authorName,
    required String authorDNS,
    required String createTime,
    required String note,
    required String image,
    required String link,
    int? expiration,
  }) {
    return types.CustomMessage(
      author: author,
      createdAt: timestamp,
      id: id,
      sourceKey: sourceKey,
      remoteId: remoteId,
      roomId: roomId,
      metadata: CustomMessageEx.noteMetaData(
        authorIcon: authorIcon,
        authorName: authorName,
        authorDNS: authorDNS,
        createTime: createTime,
        note: note,
        image: image,
        link: link,
      ),
      type: types.MessageType.custom,
    );
  }

  types.CustomMessage createEcashMessage({
    required types.User author,
    required int timestamp,
    required String roomId,
    required String id,
    String? remoteId,
    dynamic sourceKey,
    required String token,
    int? expiration,
  }) {
    return types.CustomMessage(
      author: author,
      createdAt: timestamp,
      id: id,
      sourceKey: sourceKey,
      remoteId: remoteId,
      roomId: roomId,
      metadata: CustomMessageEx.ecashMetaData(
        token: token,
      ),
      type: types.MessageType.custom,
    );
  }
}
