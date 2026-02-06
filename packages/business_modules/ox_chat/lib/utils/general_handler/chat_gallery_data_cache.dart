
import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat/utils/custom_message_utils.dart';
import 'package:ox_chat_ui/ox_chat_ui.dart';
import 'package:ox_common/business_interface/ox_chat/custom_message_type.dart';

class ChatGalleryDataCache {

  List<PreviewImage> gallery = [];
  Set<String> messageIdCache = {};
  /// Cap gallery list to avoid unbounded growth (e.g. Linux long sessions).
  static const int kGalleryMaxCount = 500;

  Completer _initializeCompleter = Completer();

  Future get initializeComplete => _initializeCompleter.future;

  Future initializePreviewImages(List<types.Message> messages) async {

    var index = 0;
    for (var message in messages) {
      await tryAddPreviewImage(
        message: message,
        isInsertToFirst: false,
        isWaitInitialize: false,
      );
      // Yield to GTK event loop on Linux every 10 items to avoid "not responding"
      if (Platform.isLinux && ++index % 10 == 0) await Future.delayed(Duration.zero);
    }

    if (Platform.isLinux && kDebugMode) debugPrint('[LINUX_DIAG] initializePreviewImages (cache) loop done');
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
    // On Linux only: keep gallery bounded (FIFO trim) to avoid memory growth
    if (Platform.isLinux) {
      while (gallery.length > kGalleryMaxCount) {
        final removed = gallery.removeAt(0);
        messageIdCache.remove(removed.id);
      }
    }
  }

  void clear() {
    gallery.clear();
    messageIdCache.clear();
  }
}