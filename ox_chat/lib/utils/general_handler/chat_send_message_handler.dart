
part of 'chat_general_handler.dart';

extension ChatMessageSendEx on ChatGeneralHandler {
  static Future sendTextMessageHandler(
      String receiverPubkey,
      String text, {
        int chatType = ChatType.chatSingle,
        BuildContext? context,
        ChatSessionModel? session,
      }) async {
    session ??= _getSessionModel(receiverPubkey, chatType);
    if (session == null) return ;

    final handler = ChatGeneralHandler(session: session);
    handler.sendTextMessage(context, text);
  }

  static void sendTemplateMessage({
    required String receiverPubkey,
    String title = '',
    String subTitle = '',
    String icon = '',
    String link = '',
    int chatType = ChatType.chatSingle,
    ChatSessionModel? session,
  }) {
    session ??= _getSessionModel(receiverPubkey,chatType);
    if (session == null) return ;
    ChatGeneralHandler(session: session)._sendTemplateMessage(title: title, content: subTitle, icon: icon, link: link);
  }

  static ChatSessionModel? _getSessionModel(String receiverPubkey, int type) {
    final sender = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '';
    if (sender.isEmpty) return null;

    final session = OXChatBinding.sharedInstance.sessionMap[receiverPubkey];
    if (session != null) return session;

    return ChatSessionModel(
      receiver: receiverPubkey,
      chatType: type,
      sender: sender,
    );
  }

  Future _sendMessageHandler(
      types.Message message, {
        BuildContext? context,
        bool isResend = false,
        ChatSendingType sendingType = ChatSendingType.remote,
      }) async {
    if (!isResend) {
      final sendMsg = await tryPrepareSendFileMessage(context, message);
      if (sendMsg == null) return ;
      message = sendMsg;
    }

    if (sendingType == ChatSendingType.memory) {
      tempMessageSet.add(message);
    }

    final errorMsg = await ChatSendMessageHelper.sendMessage(
      session: session,
      message: message,
      sendingType: sendingType,
      contentEncoder: messageContentEncoder,
      sourceCreator: (message) {
        if (message is types.CustomMessage) {
          switch (message.customType) {
            case CustomMessageType.ecash:
              final tokenList = EcashMessageEx(message).tokenList;
              if (tokenList.length == 1) {
                return tokenList.first;
              } else {
                return '''[You've received cashu token via 0xchat]''';
              }
            case CustomMessageType.ecashV2:
              final tokenList = EcashV2MessageEx(message).tokenList;
              final signees = EcashV2MessageEx(message).signees;
              if (tokenList.length == 1 && signees.isEmpty) {
                return tokenList.first;
              } else {
                return '''[You've received cashu token via 0xchat]''';
              }
            default: break;
          }
        }
        return null;
      }
    );
    if (errorMsg != null && errorMsg.isNotEmpty) {
      CommonToast.instance.show(context, errorMsg);
    }
  }

  FutureOr<String?> messageContentEncoder(types.Message message) {

    List<MessageContentParser> parserList = [
      if (mentionHandler != null) mentionHandler!.tryEncoder,
    ];

    for (final fn in parserList) {
      final result = fn(message);
      if (result != null) return result;
    }

    return null;
  }

  void resendMessage(BuildContext context, types.Message message) {
    final resendMsg = message.copyWith(
      createdAt: DateTime.now().millisecondsSinceEpoch,
      status: types.Status.sending,
    );
    ChatDataCache.shared.deleteMessage(session, resendMsg);
    _sendMessageHandler(resendMsg, context: context, isResend: true);
  }

  Future sendTextMessage(BuildContext? context, String text) async {
    
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

    await _sendMessageHandler(message, context: context);
  }

  void sendZapsMessage(BuildContext context, String zapper, String invoice, String amount, String description) {
    String message_id = const Uuid().v4();
    int tempCreateTime = DateTime.now().millisecondsSinceEpoch;
    final message = CustomMessageFactory().createZapsMessage(
      author: author,
      timestamp: tempCreateTime,
      id: message_id,
      roomId: session.chatId,
      zapper: zapper,
      invoice: invoice,
      amount: amount,
      description: description,
    );

    _sendMessageHandler(message, context: context);
  }

  Future sendImageMessage(BuildContext context, List<File> images) async {
    for (final result in images) {
      OXLoading.show();
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
        roomId: session.chatId,
        name: fileName,
        size: bytes.length,
        uri: result.path.toString(),
        width: image.width.toDouble(),
        fileEncryptionType: fileEncryptionType,
        decryptKey: fileEncryptionType == types.EncryptionType.encrypted ? createEncryptKey() : null,
      );

      await _sendMessageHandler(message, context: context);

      OXLoading.dismiss();
    }
  }

  void sendGifImageMessage(BuildContext context, GiphyImage image) {
    String message_id = const Uuid().v4();
    int tempCreateTime = DateTime.now().millisecondsSinceEpoch;

    final message = types.ImageMessage(
      uri: image.url,
      author: author,
      createdAt: tempCreateTime,
      id: message_id,
      roomId: session.chatId,
      name: image.name,
      size: double.parse(image.size!),
    );

    _sendMessageHandler(message, context: context);
  }

  void sendInsertedContentMessage(BuildContext context, KeyboardInsertedContent insertedContent) {
    String base64String = base64.encode(insertedContent.data!);
    String sendMessage = 'data:${insertedContent.mimeType};base64,$base64String';

    String message_id = const Uuid().v4();
    int tempCreateTime = DateTime.now().millisecondsSinceEpoch;

    final message = types.ImageMessage(
      uri: sendMessage,
      author: author,
      createdAt: tempCreateTime,
      id: message_id,
      roomId: session.chatId,
      name: insertedContent.uri,
      size: sendMessage.length,
      fileEncryptionType: EncryptionType.none,
    );

    _sendMessageHandler(message, context: context);
  }

  Future sendVoiceMessage(BuildContext context, String path, Duration duration) async {
    OXLoading.show();
    File audioFile = File(path);
    final duration = await ChatVoiceMessageHelper.getAudioDuration(audioFile.path);
    final bytes = await audioFile.readAsBytes();
    String message_id = const Uuid().v4();
    final fileName = '${message_id}.mp3';
    int tempCreateTime = DateTime.now().millisecondsSinceEpoch;

    final message = types.AudioMessage(
      uri: path,
      id: message_id,
      createdAt: tempCreateTime,
      author: author,
      name: fileName,
      audioFile: audioFile,
      duration: duration,
      size: bytes.length,
    );

    _sendMessageHandler(message, context: context);

    OXLoading.dismiss();
  }

  Future sendVideoMessageSend(BuildContext context, List<File> images) async {
    for (final result in images) {
      OXLoading.show();
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

      _sendMessageHandler(message, context: context);

      OXLoading.dismiss();
    }
  }

  void _sendTemplateMessage({
    BuildContext? context,
    String title = '',
    String content = '',
    String icon = '',
    String link = '',
  }) {
    String message_id = const Uuid().v4();
    int tempCreateTime = DateTime.now().millisecondsSinceEpoch;
    final message = CustomMessageFactory().createTemplateMessage(
      author: author,
      timestamp: tempCreateTime,
      roomId: session.chatId,
      id: message_id,
      title: title,
      content: content,
      icon: icon,
      link: link,
    );

    _sendMessageHandler(message, context: context);
  }

  void sendSystemMessage(
      BuildContext context,
      String text, {
        String? localTextKey,
        ChatSendingType sendingType = ChatSendingType.remote,
      }) {
    String message_id = const Uuid().v4();
    int tempCreateTime = DateTime.now().millisecondsSinceEpoch;

    final message = types.SystemMessage(
      author: author,
      createdAt: tempCreateTime,
      id: message_id,
      roomId: session.chatId,
      text: text,
      metadata: {
        'localTextKey': localTextKey,
      },
    );

    _sendMessageHandler(message, context: context, sendingType: sendingType);
  }

  void sendEcashMessage(BuildContext context, {
    required List<String> tokenList,
    List<String> receiverPubkeys = const [],
    List<EcashSignee> signees = const [],
    String validityDate = '',
  }) {
    String message_id = const Uuid().v4();
    int tempCreateTime = DateTime.now().millisecondsSinceEpoch;

    final message = CustomMessageFactory().createEcashMessage(
      author: author,
      timestamp: tempCreateTime,
      id: message_id,
      roomId: session.chatId,
      tokenList: tokenList,
      receiverPubkeys: receiverPubkeys,
      signees: signees,
      validityDate: validityDate,
    );

    _sendMessageHandler(message, context: context);
  }
}

extension ChatMessageSendUtileEx on ChatGeneralHandler {

  String createEncryptKey() => bytesToHex(MessageDB.getRandomSecret());

  Future<String> uploadFile({
    required UplodAliyunType fileType,
    required String filePath,
    required String messageId,
    String? encryptedKey,
  }) async {
    final file = File(filePath);
    final ext = Path.extension(filePath);
    final fileName = '$messageId$ext';
    return await UplodAliyun.uploadFileToAliyun(fileType: fileType, file: file, filename: fileName, encryptedKey: encryptedKey);
  }

  Future<types.Message?> tryPrepareSendFileMessage(BuildContext? context, types.Message message) async {
    types.Message? updatedMessage;
    if (message is types.ImageMessage) {
      updatedMessage = await prepareSendImageMessage(
        message: message,
        context: context,
      );
    } else if (message is types.AudioMessage) {
      updatedMessage = await prepareSendAudioMessage(
        message: message,
        context: context,
      );
    } else if (message is types.VideoMessage) {
      updatedMessage = await prepareSendVideoMessage(
        message: message,
        context: context,
      );
    } else {
      return message;
    }

    return updatedMessage;
  }

  Future<types.Message?> prepareSendImageMessage({
    BuildContext? context,
    required types.ImageMessage message,
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
      final pk = message.fileEncryptionType == types.EncryptionType.encrypted ? message.decryptKey : null;
      final uri = await uploadFile(fileType: UplodAliyunType.imageType, filePath: filePath, messageId: message.id, encryptedKey: pk);
      if (uri.isEmpty) {
        CommonToast.instance.show(context, Localized.text('ox_chat.message_send_image_fail'));
        return null;
      }
      return message.copyWith(uri: uri);
    }
    return message;
  }

  Future<types.Message?> prepareSendAudioMessage({
    BuildContext? context,
    required types.AudioMessage message,
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
      final pk = message.fileEncryptionType == types.EncryptionType.encrypted ? message.decryptKey : null;
      final uri = await uploadFile(fileType: UplodAliyunType.voiceType, filePath: filePath, messageId: message.id, encryptedKey: pk);
      if (uri.isEmpty) {
        CommonToast.instance.show(context, Localized.text('ox_chat.message_send_audio_fail'));
        return null;
      }
      return message.copyWith(uri: uri);
    }
    return message;
  }

  Future<types.Message?> prepareSendVideoMessage({
    BuildContext? context,
    required types.VideoMessage message,
  }) async {
    final filePath = message.metadata?['videoUrl'] as String? ?? '';
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
      final pk = message.fileEncryptionType == types.EncryptionType.encrypted ? message.decryptKey : null;
      final uri = await uploadFile(fileType: UplodAliyunType.videoType, filePath: filePath, messageId: message.id, encryptedKey: pk);
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