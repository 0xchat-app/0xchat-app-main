
part of 'chat_general_handler.dart';

extension ChatMessageSendEx on ChatGeneralHandler {

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
}

extension ChatMessageSendUtileEx on ChatGeneralHandler {

  Future<String> uploadFile({
    required UplodAliyunType fileType,
    required String filePath,
    required String messageId,
    String? pubkey,
  }) async {
    final file = File(filePath);
    final ext = path.extension(filePath);
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
      final uri = await uploadFile(fileType: UplodAliyunType.imageType, filePath: filePath, messageId: message.id, pubkey: pubkey);
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