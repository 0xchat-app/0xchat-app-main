
import 'dart:async';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat/utils/custom_message_utils.dart';
import 'package:ox_chat_ui/ox_chat_ui.dart';
import 'package:ox_common/business_interface/ox_chat/custom_message_type.dart';

class ChatGalleryDataCache {

  List<PreviewImage> gallery = [];
  Set<String> messageIdCache = {};

  Completer _initializeCompleter = Completer();

  Future get initializeComplete => _initializeCompleter.future;

  Future initializePreviewImages(List<types.Message> messages) async {

    for (var message in messages) {
      await tryAddPreviewImage(
        message: message,
        isInsertToFirst: false,
        isWaitInitialize: false,
      );
    }

    _initializeCompleter.complete();
  }

  Future tryAddPreviewImage({
    required types.Message message,
    bool isInsertToFirst = true,
    bool isWaitInitialize = true,
  }) async {

    if (isWaitInitialize) {
      await initializeComplete;
    }

    String imageURL = '';
    if (message is types.ImageMessage) {
      imageURL = message.uri;
    } else if (message is types.CustomMessage && message.customType == CustomMessageType.imageSending) {
      final url = ImageSendingMessageEx(message).url;
      final path = ImageSendingMessageEx(message).path;
      if (url.isNotEmpty) {
        imageURL = url;
      } else if (path.isNotEmpty) {
        imageURL = path;
      }
    }

    if (imageURL.isEmpty) return ;
    if (!messageIdCache.add(message.id)) return ;

    final model = PreviewImage(
      id: message.id,
      uri: imageURL,
      decryptSecret: message.decryptKey,
      decryptNonce: message.decryptNonce,
    );
    if (isInsertToFirst) {
      gallery.insert(0, model);
    } else {
      gallery.add(model);
    }
  }
}