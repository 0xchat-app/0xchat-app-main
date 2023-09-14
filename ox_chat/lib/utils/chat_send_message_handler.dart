
part of 'chat_general_handler.dart';

extension ChatMessageSendEx on ChatGeneralHandler {

  Future resendMessage(types.Message message) async {
    final resendMsg = message.copyWith(
      createdAt: DateTime.now().millisecondsSinceEpoch,
      status: types.Status.sending,
    );
    ChatDataCache.shared.deleteMessage(session, resendMsg);
    sendMessageHandler(message, isResend: true);
  }

  void sendTextMessage(String text) {

    final mid = Uuid().v4();
    int tempCreateTime = DateTime.now().millisecondsSinceEpoch;

    var message = types.TextMessage(
      author: author,
      createdAt: tempCreateTime,
      id: mid,
      text: text,
      repliedMessage: replyHandler.replyMessage,
    );

    replyHandler.updateReplyMessage(null);

    sendMessageHandler(message);
  }

  Future sendZapsMessage(String zapper, String invoice, String amount, String description) async {
    String message_id = const Uuid().v4();
    int tempCreateTime = DateTime.now().millisecondsSinceEpoch;
    final message = CustomMessageFactory().createZapsMessage(
      author: author,
      timestamp: tempCreateTime,
      id: message_id,
      roomId: session.chatId ?? '',
      zapper: zapper,
      invoice: invoice,
      amount: amount,
      description: description,
    );

    sendMessageHandler(message);
  }

  Future sendImageMessage(List<File> images) async {
    for (final result in images) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      String message_id = const Uuid().v4();
      String fileName = Path.basename(result.path);
      fileName = fileName.substring(13);
      int tempCreateTime = DateTime.now().millisecondsSinceEpoch;

      final message = types.ImageMessage(
        author: author,
        createdAt: tempCreateTime,
        height: image.height.toDouble(),
        id: message_id,
        roomId: session.chatId ?? '',
        name: fileName,
        size: bytes.length,
        uri: result.path.toString(),
        width: image.width.toDouble(),
        fileEncryptionType: fileEncryptionType,
      );

      sendMessageHandler(message);
    }
  }

  Future sendGifImageMessage(GiphyImage image) async {
    String message_id = const Uuid().v4();
    int tempCreateTime = DateTime.now().millisecondsSinceEpoch;

    final message = types.ImageMessage(
      uri: image.url,
      author: author,
      createdAt: tempCreateTime,
      id: message_id,
      roomId: session.chatId ?? '',
      name: image.name,
      size: double.parse(image.size!),
    );

    sendMessageHandler(message);
  }

  Future sendVoiceMessage(String path, Duration duration) async {
    File voiceFile = File(path);
    final bytes = await voiceFile.readAsBytes();
    String message_id = const Uuid().v4();
    final fileName = '${message_id}.mp3';
    int tempCreateTime = DateTime.now().millisecondsSinceEpoch;

    final message = types.AudioMessage(
      uri: path,
      id: message_id,
      createdAt: tempCreateTime,
      author: author,
      name: fileName,
      duration: duration,
      size: bytes.length,
    );

    sendMessageHandler(message);
  }

  Future sendVideoMessageSend(List<File> images) async {
    for (final result in images) {
      final bytes = await result.readAsBytes();
      final uint8list = await VideoCompress.getByteThumbnail(result.path,
          quality: 50, // default(100)
          position: -1 // default(-1)
      );
      final image = await decodeImageFromList(uint8list!);
      Directory directory = await getTemporaryDirectory();
      String thumbnailDirPath = '${directory.path}/thumbnails';
      await Directory(thumbnailDirPath).create(recursive: true);

      // Save the thumbnail to a file
      String thumbnailPath = '$thumbnailDirPath/thumbnail.jpg';
      File thumbnailFile = File(thumbnailPath);
      await thumbnailFile.writeAsBytes(uint8list);

      String message_id = const Uuid().v4();
      String fileName = '${message_id}${Path.basename(result.path)}';
      int tempCreateTime = DateTime.now().millisecondsSinceEpoch;

      final message = types.VideoMessage(
        author: author,
        createdAt: tempCreateTime,
        height: image.height.toDouble(),
        id: message_id,
        name: fileName,
        size: bytes.length,
        metadata: {
          "videoUrl": result.path.toString(),
        },
        uri: thumbnailPath,
        width: image.width.toDouble(),
        fileEncryptionType: fileEncryptionType,
      );

      sendMessageHandler(message);
    }
  }
}

extension ChatMessageSendUtileEx on ChatGeneralHandler {

  Future<String> uploadFile({
    required UplodAliyunType fileType,
    required String filePath,
    required String messageId,
    String? pubkey,
  }) async {
    final file = File(filePath);
    final ext = Path.extension(filePath);
    final fileName = '$messageId$ext';
    return await UplodAliyun.uploadFileToAliyun(fileType: fileType, file: file, filename: fileName, pubkey: pubkey);
  }

  Future<types.Message?> prepareSendImageMessage(
      BuildContext context,
      types.ImageMessage message, {
        String? pubkey,
      }) async {
    final filePath = message.uri;
    final uriIsLocalPath = filePath.isLocalPath;

    if (uriIsLocalPath == null) {
      ChatLogUtils.error(
        className: 'ChatGroupMessagePage',
        funcName: '_resendMessage',
        message: 'message: ${message.toJson()}',
      );
      return null;
    }

    if (uriIsLocalPath) {
      final pk = message.fileEncryptionType == types.EncryptionType.encrypted ? pubkey : null;
      final uri = await uploadFile(fileType: UplodAliyunType.imageType, filePath: filePath, messageId: message.id, pubkey: pk);
      if (uri.isEmpty) {
        CommonToast.instance.show(context, Localized.text('ox_chat.message_send_image_fail'));
        return null;
      }
      return message.copyWith(uri: uri);
    }
    return message;
  }

  Future<types.Message?> prepareSendAudioMessage(
      BuildContext context,
      types.AudioMessage message, {
        String? pubkey,
      }) async {
    final filePath = message.uri;
    final uriIsLocalPath = filePath.isLocalPath;

    if (uriIsLocalPath == null) {
      ChatLogUtils.error(
        className: 'ChatGroupMessagePage',
        funcName: '_resendMessage',
        message: 'message: ${message.toJson()}',
      );
      return null;
    }

    if (uriIsLocalPath) {
      final uri = await uploadFile(fileType: UplodAliyunType.voiceType, filePath: filePath, messageId: message.id, pubkey: pubkey);
      if (uri.isEmpty) {
        CommonToast.instance.show(context, Localized.text('ox_chat.message_send_audio_fail'));
        return null;
      }
      return message.copyWith(uri: uri);
    }
    return message;
  }

  Future<types.Message?> prepareSendVideoMessage(
      BuildContext context,
      types.VideoMessage message, {
        String? pubkey,
      }) async {
    final filePath = message.metadata?['videoUrl'] as String ?? '';
    final uriIsLocalPath = filePath.isLocalPath;

    if (filePath.isEmpty || uriIsLocalPath == null) {
      ChatLogUtils.error(
        className: 'ChatGroupMessagePage',
        funcName: '_resendMessage',
        message: 'message: ${message.toJson()}',
      );
      return null;
    }

    if (uriIsLocalPath) {
      final uri = await uploadFile(fileType: UplodAliyunType.videoType, filePath: filePath, messageId: message.id, pubkey: pubkey);
      if (uri.isEmpty) {
        CommonToast.instance.show(context, Localized.text('ox_chat.message_send_video_fail'));
        return null;
      }
      return message.copyWith(
        metadata: {
          'videoUrl': uri,
        },
      );
    }
    return message;
  }
}