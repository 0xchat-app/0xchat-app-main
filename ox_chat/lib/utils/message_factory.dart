
import 'dart:convert';
import 'dart:math';

import 'package:chatcore/chat-core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_types/src/message.dart' as UIMessage;
import 'package:ox_common/business_interface/ox_chat/call_message_type.dart';
import 'package:ox_common/business_interface/ox_chat/custom_message_type.dart';
import 'package:ox_chat/model/message_content_model.dart';
import 'package:ox_chat/utils/custom_message_utils.dart';
import 'package:ox_common/business_interface/ox_chat/utils.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/web_url_helper.dart';
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
    String? repliedMessageId,
    String? previewData,
    String? decryptKey,
    int? expiration,
    List<types.Reaction> reactions = const [],
    List<types.ZapsInfo> zapsInfoList = const [],
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
    String? repliedMessageId,
    String? previewData,
    String? decryptKey,
    int? expiration,
    List<types.Reaction> reactions = const [],
    List<types.ZapsInfo> zapsInfoList = const [],
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
      repliedMessageId: repliedMessageId,
      previewData: previewData != null
          ? PreviewData.fromJson(jsonDecode(previewData))
          : null,
      expiration: expiration,
      reactions: reactions,
      zapsInfoList: zapsInfoList,
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
    String? repliedMessageId,
    String? previewData,
    String? decryptKey,
    int? expiration,
    List<types.Reaction> reactions = const [],
    List<types.ZapsInfo> zapsInfoList = const [],
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
      repliedMessage: repliedMessage,
      repliedMessageId: repliedMessageId,
      fileEncryptionType: fileEncryptionType,
      decryptKey: decryptKey,
      expiration: expiration,
      reactions: reactions,
      zapsInfoList: zapsInfoList,
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
    String? repliedMessageId,
    String? previewData,
    String? decryptKey,
    int? expiration,
    List<types.Reaction> reactions = const [],
    List<types.ZapsInfo> zapsInfoList = const [],
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
      repliedMessage: repliedMessage,
      repliedMessageId: repliedMessageId,
      fileEncryptionType: fileEncryptionType,
      decryptKey: decryptKey,
      expiration: expiration,
      reactions: reactions,
      zapsInfoList: zapsInfoList,
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
    String? repliedMessageId,
    String? previewData,
    String? decryptKey,
    int? expiration,
    List<types.Reaction> reactions = const [],
    List<types.ZapsInfo> zapsInfoList = const [],
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
      repliedMessage: repliedMessage,
      repliedMessageId: repliedMessageId,
      fileEncryptionType: fileEncryptionType,
      decryptKey: decryptKey,
      expiration: expiration,
      reactions: reactions,
      zapsInfoList: zapsInfoList,
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
    String? repliedMessageId,
    String? previewData,
    String? decryptKey,
    int? expiration,
    List<types.Reaction> reactions = const [],
    List<types.ZapsInfo> zapsInfoList = const [],
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
      repliedMessage: repliedMessage,
      repliedMessageId: repliedMessageId,
      metadata: CustomMessageEx.callMetaData(
        text: state.messageText(isMe, durationText),
        type: media,
      ),
      type: types.MessageType.custom,
      expiration: expiration,
      reactions: reactions,
      zapsInfoList: zapsInfoList,
      viewWithoutBubble: false,
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
    String? repliedMessageId,
    String? previewData,
    String? decryptKey,
    int? expiration,
    List<types.Reaction> reactions = const [],
    List<types.ZapsInfo> zapsInfoList = const [],
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
      repliedMessage: repliedMessage,
      repliedMessageId: repliedMessageId,
      text: text,
      expiration: expiration,
      reactions: reactions,
      zapsInfoList: zapsInfoList,
    );
  }
}

class CustomMessageFactory implements MessageFactory {

  static ({CustomMessageType type, Map content})? parseFromContentString(String contentString) {

    try {
      final contentMap = json.decode(contentString);
      if (contentMap is! Map) return null;

      final type = CustomMessageTypeEx.fromValue(contentMap['type']);
      final content = contentMap['content'];
      if (type == null || content is! Map) return null;

      return (type: type, content: content);
    } catch (_) {
      return null;
    }
  }

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
    String? repliedMessageId,
    String? previewData,
    String? decryptKey,
    int? expiration,
    List<types.Reaction> reactions = const [],
    List<types.ZapsInfo> zapsInfoList = const [],
  }) {
    final contentString = contentModel.content;
    if (contentString == null) return null;

    final info = CustomMessageFactory.parseFromContentString(contentString);
    if (info == null) return null;

    final type = info.type;
    final content = info.content;

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
          reactions: reactions,
          zapsInfoList: zapsInfoList,
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
      reactions: reactions,
      zapsInfoList: zapsInfoList,
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
          reactions: reactions,
          zapsInfoList: zapsInfoList,
        );

      case CustomMessageType.ecash:
        try {
          final tokenList = (content[EcashMessageEx.metaTokenListKey] as List)
              .map((e) => e.toString())
              .toList();
          final isOpened = content[EcashMessageEx.metaIsOpenedKey] ?? '';
          return createEcashMessage(
            author: author,
            timestamp: timestamp,
            roomId: roomId,
            id: remoteId,
            remoteId: remoteId,
            sourceKey: sourceKey,
            tokenList: tokenList,
            isOpened: isOpened,
            expiration: expiration,
            reactions: reactions,
            zapsInfoList: zapsInfoList,
          );
        } catch (e) {
          print(e);
          return null;
        }

      case CustomMessageType.ecashV2:
        try {
          final tokenListRaw = content[EcashV2MessageEx.metaTokenListKey];
          List<String> tokenList = [];
          if (tokenListRaw is List) {
            tokenList = tokenListRaw
                .map((e) => e.toString())
                .toList();
          }

          final receiverPubkeysRaw = content[EcashV2MessageEx.metaReceiverPubkeysKey];
          List<String> receiverPubkeys = [];
          if (receiverPubkeysRaw is List) {
            receiverPubkeys = receiverPubkeysRaw
                .map((e) => e.toString())
                .toList();
          }
          return createEcashMessage(
            author: author,
            timestamp: timestamp,
            roomId: roomId,
            id: remoteId,
            remoteId: remoteId,
            sourceKey: sourceKey,
            tokenList: tokenList,
            receiverPubkeys: receiverPubkeys,
            signees: EcashV2MessageEx.getSigneesWithContentMap(content),
            validityDate: content[EcashV2MessageEx.metaValidityDateKey] ?? '',
            isOpened: content[EcashV2MessageEx.metaIsOpenedKey] ?? '',
            expiration: expiration,
            reactions: reactions,
            zapsInfoList: zapsInfoList,
          );
        } catch (e, stack) {
          print(e);
          print(stack);
          return null;
        }

      case CustomMessageType.imageSending:
        final path = content[ImageSendingMessageEx.metaPathKey];
        final url = content[ImageSendingMessageEx.metaURLKey];
        final width = content[ImageSendingMessageEx.metaWidthKey];
        final height = content[ImageSendingMessageEx.metaHeightKey];
        final encryptedKey = content[ImageSendingMessageEx.metaEncryptedKey];
        return createImageSendingMessage(
          author: author,
          timestamp: timestamp,
          roomId: roomId,
          id: remoteId,
          remoteId: remoteId,
          sourceKey: sourceKey,
          expiration: expiration,
          reactions: reactions,
          zapsInfoList: zapsInfoList,
          path: path,
          url: url,
          width: width,
          height: height,
          encryptedKey: encryptedKey,
        );

      default:
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
    int? expiration,
    List<types.Reaction> reactions = const [],
    List<types.ZapsInfo> zapsInfoList = const [],
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
      expiration: expiration,
      reactions: reactions,
      zapsInfoList: zapsInfoList,
      viewWithoutBubble: true,
    );
  }

  types.CustomMessage createTemplateMessage({
    required types.User author,
    required int timestamp,
    required String roomId,
    required String id,
    String? remoteId,
    dynamic sourceKey,
    int? expiration,
    List<types.Reaction> reactions = const [],
    List<types.ZapsInfo> zapsInfoList = const [],
    required String title,
    required String content,
    required String icon,
    required String link,
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
      expiration: expiration,
      reactions: reactions,
      zapsInfoList: zapsInfoList,
      viewWithoutBubble: true,
    );
  }

  types.CustomMessage createNoteMessage({
    required types.User author,
    required int timestamp,
    required String roomId,
    required String id,
    String? remoteId,
    dynamic sourceKey,
    int? expiration,
    List<types.Reaction> reactions = const [],
    List<types.ZapsInfo> zapsInfoList = const [],
    required String authorIcon,
    required String authorName,
    required String authorDNS,
    required String createTime,
    required String note,
    required String image,
    required String link,
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
      expiration: expiration,
      reactions: reactions,
      zapsInfoList: zapsInfoList,
      viewWithoutBubble: true,
    );
  }

  types.CustomMessage createEcashMessage({
    required types.User author,
    required int timestamp,
    required String roomId,
    required String id,
    String? remoteId,
    dynamic sourceKey,
    int? expiration,
    List<types.Reaction> reactions = const [],
    List<types.ZapsInfo> zapsInfoList = const [],
    required List<String> tokenList,
    List<String> receiverPubkeys = const [],
    List<EcashSignee> signees = const [],
    String validityDate = '',
    String isOpened = '',
  }) {
    return types.CustomMessage(
      author: author,
      createdAt: timestamp,
      id: id,
      sourceKey: sourceKey,
      remoteId: remoteId,
      roomId: roomId,
      metadata: CustomMessageEx.ecashV2MetaData(
        tokenList: tokenList,
        receiverPubkeys: receiverPubkeys,
        signees: signees,
        validityDate: validityDate,
        isOpened: isOpened,
      ),
      type: types.MessageType.custom,
      expiration: expiration,
      reactions: reactions,
      zapsInfoList: zapsInfoList,
      viewWithoutBubble: true,
    );
  }

  types.CustomMessage createImageSendingMessage({
    required types.User author,
    required int timestamp,
    required String roomId,
    required String id,
    String? remoteId,
    dynamic sourceKey,
    int? expiration,
    List<types.Reaction> reactions = const [],
    List<types.ZapsInfo> zapsInfoList = const [],
    required String path,
    required String url,
    required int? width,
    required int? height,
    required String? encryptedKey,
  }) {
    return types.CustomMessage(
      author: author,
      createdAt: timestamp,
      id: id,
      sourceKey: sourceKey,
      remoteId: remoteId,
      roomId: roomId,
      metadata: CustomMessageEx.imageSendingMetaData(
        path: path,
        url: url,
        width: width,
        height: height,
        encryptedKey: encryptedKey,
      ),
      type: types.MessageType.custom,
      decryptKey: encryptedKey,
      expiration: expiration,
      reactions: reactions,
      zapsInfoList: zapsInfoList,
      viewWithoutBubble: true,
    );
  }
}
