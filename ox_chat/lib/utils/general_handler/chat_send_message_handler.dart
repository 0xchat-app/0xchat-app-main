part of 'chat_general_handler.dart';

extension ChatMessageSendEx on ChatGeneralHandler {
  static Future sendTextMessageHandler(
    String receiverPubkey,
    String text, {
    int chatType = ChatType.chatSingle,
    BuildContext? context,
    ChatSessionModelISAR? session,
    String secretSessionId = '',
  }) async {
    final sender = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '';
    if (sender.isEmpty) return;

    session ??= _getSessionModel(
      receiverPubkey,
      chatType,
      secretSessionId,
    );
    if (session == null) return;

    ChatGeneralHandler(session: session).sendTextMessage(context, text);
  }

  static void sendTemplateMessage({
    required String receiverPubkey,
    String title = '',
    String subTitle = '',
    String icon = '',
    String link = '',
    int chatType = ChatType.chatSingle,
    String secretSessionId = '',
    ChatSessionModelISAR? session,
  }) {
    final sender = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '';
    if (sender.isEmpty) return;

    session ??= _getSessionModel(
      receiverPubkey,
      chatType,
      secretSessionId,
    );
    if (session == null) return;

    ChatGeneralHandler(session: session)._sendTemplateMessage(
      title: title,
      content: subTitle,
      icon: icon,
      link: link,
    );
  }

  static Future sendSystemMessageHandler(
    String receiverPubkey,
    String text, {
    int chatType = ChatType.chatSingle,
    BuildContext? context,
    ChatSessionModelISAR? session,
    String secretSessionId = '',
  }) async {
    final sender = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '';
    if (sender.isEmpty) return;

    session ??= _getSessionModel(
      receiverPubkey,
      chatType,
      secretSessionId,
    );
    if (session == null) return;

    ChatGeneralHandler(session: session).sendSystemMessage(text, context: context);
  }

  static ChatSessionModelISAR? _getSessionModel(String receiverPubkey, int type,
      [String secretSessionId = '']) {
    final sender = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '';
    if (sender.isEmpty) return null;

    final session = OXChatBinding.sharedInstance.sessionMap[receiverPubkey];
    if (session != null) return session;

    return ChatSessionModelISAR.getDefaultSession(
      type,
      receiverPubkey,
      sender,
      secretSessionId: secretSessionId,
    );
  }

  Future _sendMessageHandler({
    BuildContext? context,
    required String? content,
    required MessageType? messageType,
    types.Message? resendMessage,
    ChatSendingType sendingType = ChatSendingType.remote,
    String? replaceMessageId,
    Function(types.Message)? sendActionFinishHandler,
  }) async {
    types.Message? message;
    int tempCreateTime = DateTime.now().millisecondsSinceEpoch;
    if (resendMessage != null) {
      message = resendMessage.copyWith(
        createdAt: tempCreateTime,
        status: null,
      );
    } else if (content != null && messageType != null) {
      final mid = Uuid().v4();
      message = await ChatMessageHelper.createUIMessage(
        messageId: mid,
        authorPubkey: author.id,
        contentString: content,
        type: messageType,
        createTime: tempCreateTime,
        chatId: session.chatId,
        replyId: messageType == MessageType.text ? replyHandler.replyMessage?.remoteId : null,
      );
    }
    if (message == null) return;

    if (replaceMessageId != null) {
      final replaceMessage = dataController.getMessage(replaceMessageId);
      message = message.copyWith(
        id: replaceMessageId,
        createdAt: replaceMessage?.createdAt ?? message.createdAt,
      );
    }

    if (resendMessage == null) {
      message = await tryPrepareSendFileMessage(context, message);
    }
    if (message == null) return;

    if (sendingType == ChatSendingType.memory) {
      tempMessageSet.add(message);
    }

    var sendFinish = OXValue(false);
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
            default:
              break;
          }
        }
        return null;
      },
      replaceMessageId: replaceMessageId,
      sendEventHandler: (event, sendMsg) => _sendEventHandler(event, sendMsg, sendFinish),
      sendActionFinishHandler: (message) {
        _sendActionFinishHandler(
          message: message,
          sendFinish: sendFinish,
          sendingType: sendingType,
          replaceMessageId: replaceMessageId,
        );
        sendActionFinishHandler?.call(message);
      },
    );
    if (errorMsg != null && errorMsg.isNotEmpty) {
      CommonToast.instance.show(context, errorMsg);
    }
  }

  Future _sendEventHandler(OKEvent event, types.Message sendMsg, OXValue sendFinish) async {
    sendFinish.value = true;
    final message = await dataController.getMessage(sendMsg.id);
    if (message == null) return;

    final updatedMessage = message.copyWith(
      remoteId: event.eventId,
      status: event.status ? types.Status.sent : types.Status.error,
    );
    dataController.updateMessage(updatedMessage, originMessageId: sendMsg.id);
  }

  void _sendActionFinishHandler({
    required types.Message message,
    required OXValue<bool> sendFinish,
    required ChatSendingType sendingType,
    String? replaceMessageId,
  }) {
    if (replaceMessageId != null && replaceMessageId.isNotEmpty) {
      dataController.updateMessage(message, originMessageId: replaceMessageId);
    } else {
      dataController.addMessage(message);
      dataController.galleryCache.tryAddPreviewImage(message: message);
    }

    if (sendingType == ChatSendingType.remote) {
      // If the message is not sent within a short period of time, change the status to the sending state
      _setMessageSendingStatusIfNeeded(sendFinish, message);
    }
  }

  void _setMessageSendingStatusIfNeeded(OXValue<bool> sendFinish, types.Message message) {
    Future.delayed(const Duration(milliseconds: 500), () async {
      if (!sendFinish.value) {
        final msg = await dataController.getMessage(message.id);
        if (msg == null) return;
        _updateMessageStatus(msg, types.Status.sending);
      }
    });
  }

  void _updateMessageStatus(types.Message message, types.Status status) {
    final updatedMessage = message.copyWith(
      status: status,
    );
    dataController.updateMessage(updatedMessage);
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

    if (resendMsg.isImageSendingMessage) {
      sendImageMessage(
        context: context,
        resendMessage: resendMsg as types.CustomMessage,
      );
      return;
    } else if (resendMsg.isVideoSendingMessage) {
      sendVideoMessage(
        context: context,
        resendMessage: resendMsg as types.CustomMessage,
      );
    }

    _sendMessageHandler(
      context: context,
      content: null,
      messageType: null,
      resendMessage: message,
    );
  }

  Future<bool> sendTextMessage(BuildContext? context, String text) async {
    if (session.isContentEncrypt && text.length > 30000) {
      CommonToast.instance.show(context, 'chat_input_length_over_hint'.localized());
      return false;
    }
    await _sendMessageHandler(
      content: text,
      messageType: MessageType.text,
      context: context,
    );
    replyHandler.updateReplyMessage(null);
    return true;
  }

  void sendZapsMessage(BuildContext context, String zapper, String invoice, String amount,
      String description) async {
    try {
      final content = jsonEncode(CustomMessageEx.zapsMetaData(
        zapper: zapper,
        invoice: invoice,
        amount: amount,
        description: description,
      ));
      _sendMessageHandler(
        context: context,
        content: content,
        messageType: MessageType.template,
      );
    } catch (_) {}
  }

  Future sendImageMessageWithFile(BuildContext context, List<File> images) async {
    for (final imageFile in images) {
      final fileId = await EncodeUtils.generatePartialFileMd5(imageFile);
      final bytes = await imageFile.readAsBytes();
      final image = await decodeImageFromList(bytes);

      String? encryptedKey;
      String? encryptedNonce;
      String? imageURL;
      final uploadResult = UploadManager.shared.getUploadResult(fileId, otherUser?.pubKey);
      if (uploadResult?.isSuccess == true) {
        final url = uploadResult?.url;
        encryptedKey = uploadResult?.encryptedKey;
        encryptedNonce = uploadResult?.encryptedNonce;
        if (url != null && url.isNotEmpty) {
          imageURL = generateUrlWithInfo(
            originalUrl: url,
            width: image.width,
            height: image.height,
          );
        }
      } else {
        encryptedKey =
            fileEncryptionType == types.EncryptionType.encrypted ? createEncryptKey() : null;
        encryptedNonce =
            fileEncryptionType == types.EncryptionType.encrypted ? createEncryptNonce() : null;
      }

      await sendImageMessage(
        context: context,
        fileId: fileId,
        filePath: imageFile.path,
        imageWidth: image.width,
        imageHeight: image.height,
        encryptedKey: encryptedKey,
        encryptedNonce: encryptedNonce,
        url: imageURL,
      );
    }
  }

  Future sendImageMessage({
    BuildContext? context,
    String? fileId,
    String? filePath,
    String? url,
    int? imageWidth,
    int? imageHeight,
    String? encryptedKey,
    String? encryptedNonce,
    types.CustomMessage? resendMessage,
  }) async {
    if (resendMessage != null) {
      fileId ??= ImageSendingMessageEx(resendMessage).fileId;
      filePath ??= ImageSendingMessageEx(resendMessage).path;
      imageWidth ??= ImageSendingMessageEx(resendMessage).width;
      imageHeight ??= ImageSendingMessageEx(resendMessage).height;
      encryptedKey ??= ImageSendingMessageEx(resendMessage).encryptedKey;
      encryptedNonce ??= ImageSendingMessageEx(resendMessage).encryptedNonce;
      url ??= ImageSendingMessageEx(resendMessage).url;
    }

    if (url != null && url.isRemoteURL) {
      sendImageMessageWithURL(
        imageURL: url,
        imagePath: filePath,
        imageWidth: imageWidth,
        imageHeight: imageHeight,
        encryptedKey: encryptedKey,
        encryptedNonce: encryptedNonce,
        resendMessage: resendMessage,
      );
      return;
    }

    if (filePath == null || fileId == null) {
      ChatLogUtils.error(
        className: 'ChatMessageSendEx',
        funcName: 'sendImageMessage',
        message: 'filePath: $filePath, fileId: $fileId',
      );
      return;
    }

    String content = '';
    try {
      content = jsonEncode(CustomMessageEx.imageSendingMetaData(
        fileId: fileId,
        path: filePath,
        url: url ?? '',
        width: imageWidth,
        height: imageHeight,
        encryptedKey: encryptedKey,
        encryptedNonce: encryptedNonce,
      ));
    } catch (_) {}
    if (content.isEmpty) {
      ChatLogUtils.error(
        className: 'ChatMessageSendEx',
        funcName: 'sendImageMessage',
        message: 'content is empty',
      );
      return;
    }

    UploadManager.shared.prepareUploadStream(fileId, otherUser?.pubKey);
    await _sendMessageHandler(
      context: context,
      content: content,
      messageType: MessageType.template,
      resendMessage: resendMessage,
      sendingType: ChatSendingType.store,
      sendActionFinishHandler: (sendMessage) {
        UploadManager.shared.uploadFile(
          fileType: FileType.image,
          filePath: filePath!,
          uploadId: fileId,
          receivePubkey: otherUser?.pubKey ?? '',
          encryptedKey: encryptedKey,
          encryptedNonce: encryptedNonce,
          autoStoreImage: false,
          completeCallback: (uploadResult, isFromCache) async {
            var imageURL = uploadResult.url;
            if (!uploadResult.isSuccess || imageURL.isEmpty) return;

            imageURL = generateUrlWithInfo(
              originalUrl: imageURL,
              width: imageWidth,
              height: imageHeight,
            );

            // Store cache image for new URL
            final imageFile = File(filePath!);
            OXFileCacheManager.get(encryptKey: encryptedKey).putFile(
              imageURL,
              imageFile.readAsBytesSync(),
              fileExtension: imageFile.path.getFileExtension(),
            );

            sendImageMessageWithURL(
              imageURL: imageURL,
              imagePath: filePath,
              imageWidth: imageWidth,
              imageHeight: imageHeight,
              encryptedKey: encryptedKey,
              encryptedNonce: encryptedNonce,
              replaceMessageId: sendMessage.id,
            );
          },
        );
      },
    );
  }

  void sendImageMessageWithURL({
    required String imageURL,
    String? fileId,
    String? imagePath,
    int? imageWidth,
    int? imageHeight,
    String? encryptedKey,
    String? encryptedNonce,
    String? replaceMessageId,
    types.Message? resendMessage,
  }) {
    try {
      final content = jsonEncode(CustomMessageEx.imageSendingMetaData(
        fileId: fileId ?? '',
        url: imageURL,
        path: imagePath ?? '',
        width: imageWidth,
        height: imageHeight,
        encryptedKey: encryptedKey,
          encryptedNonce: encryptedNonce,
      ));

      _sendMessageHandler(
        content: content,
        messageType: MessageType.template,
        replaceMessageId: replaceMessageId,
        resendMessage: resendMessage,
      );
    } catch (_) {
      return;
    }
  }

  Future sendGifImageMessage(BuildContext context, GiphyImage image) async {
    String? filePath, url;
    if (image.url.isRemoteURL) {
      url = image.url;
    } else {
      filePath = image.url;
    }

    await sendImageMessage(
      context: context,
      filePath: filePath,
      url: url,
    );
  }

  void sendInsertedContentMessage(BuildContext context, KeyboardInsertedContent insertedContent) {
    String base64String =
        'data:${insertedContent.mimeType};base64,${base64.encode(insertedContent.data!)}';
    _sendMessageHandler(
      context: context,
      content: base64String,
      messageType: MessageType.text,
    );
  }

  Future sendVoiceMessage(BuildContext context, String path, Duration duration) async {
    OXLoading.show();
    // File audioFile = File(path);
    // final duration = await ChatVoiceMessageHelper.getAudioDuration(audioFile.path);
    // final bytes = await audioFile.readAsBytes();

    await _sendMessageHandler(
      context: context,
      content: path,
      messageType: fileEncryptionType == types.EncryptionType.encrypted
          ? MessageType.encryptedAudio
          : MessageType.audio,
    );

    OXLoading.dismiss();
  }

  Future sendVideoMessageWithFile(BuildContext context, List<Media> videos) async {
    for (final videoMedia in videos) {
      final videoPath = videoMedia.path ?? '';
      if (videoPath.isEmpty) continue;

      final videoFile = File(videoPath);
      final fileId = await EncodeUtils.generatePartialFileMd5(videoFile);

      File? thumbnailImageFile;
      final thumbPath = videoMedia.thumbPath ?? '';
      if (thumbPath.isNotEmpty) {
        thumbnailImageFile = File(thumbPath);
      } else {
        thumbnailImageFile = await OXVideoUtils.getVideoThumbnailImageWithFilePath(
          videoFilePath: videoFile.path,
          cacheKey: fileId,
        );
      }

      ui.Image? thumbnailImage;
      final bytes = await thumbnailImageFile?.readAsBytes();
      if (bytes != null) {
        thumbnailImage = await decodeImageFromList(bytes);
      }

      String? encryptedKey;
      String? encryptedNonce;
      String? videoURL;
      final uploadResult = UploadManager.shared.getUploadResult(fileId, otherUser?.pubKey);
      if (uploadResult?.isSuccess == true) {
        final url = uploadResult?.url;
        encryptedKey = uploadResult?.encryptedKey;
        encryptedNonce = uploadResult?.encryptedNonce;
        if (url != null && url.isNotEmpty) {
          videoURL = generateUrlWithInfo(
            originalUrl: url,
            width: thumbnailImage?.width,
            height: thumbnailImage?.height,
          );
        }
      } else {
        encryptedKey =
            fileEncryptionType == types.EncryptionType.encrypted ? createEncryptKey() : null;
        encryptedNonce =
            fileEncryptionType == types.EncryptionType.encrypted ? createEncryptNonce() : null;
      }

      await sendVideoMessage(
          context: context,
          videoPath: videoFile.path,
          videoURL: videoURL,
          snapshotPath: thumbnailImageFile?.path,
          imageWidth: thumbnailImage?.width,
          imageHeight: thumbnailImage?.height,
          fileId: fileId,
          encryptedKey: encryptedKey,
          encryptedNonce: encryptedNonce);
    }
  }

  Future sendVideoMessage({
    BuildContext? context,
    String? videoPath,
    String? videoURL,
    String? snapshotPath,
    int? imageWidth,
    int? imageHeight,
    String? fileId,
    String? encryptedKey,
    String? encryptedNonce,
    types.CustomMessage? resendMessage,
  }) async {
    if (resendMessage != null) {
      videoPath = VideoMessageEx(resendMessage).videoPath;
      videoURL = VideoMessageEx(resendMessage).url;
      snapshotPath = VideoMessageEx(resendMessage).snapshotPath;
      imageWidth = VideoMessageEx(resendMessage).width;
      imageHeight = VideoMessageEx(resendMessage).height;
      fileId = VideoMessageEx(resendMessage).fileId;
    }

    if (videoURL != null && videoURL.isRemoteURL) {
      sendVideoMessageWithURL(
        videoURL: videoURL,
        fileId: fileId ?? '',
        videoPath: videoPath,
        snapshotPath: snapshotPath,
        imageWidth: imageWidth,
        imageHeight: imageHeight,
        resendMessage: resendMessage,
        encryptedKey: encryptedKey,
        encryptedNonce: encryptedNonce,
      );
      return;
    }

    if (videoPath == null || fileId == null) return;
    String content = '';
    try {
      content = jsonEncode(CustomMessageEx.videoMetaData(
        fileId: fileId,
        snapshotPath: snapshotPath ?? '',
        videoPath: videoPath,
        url: videoURL ?? '',
        width: imageWidth,
        height: imageHeight,
      ));
    } catch (_) {}
    if (content.isEmpty) return;

    UploadManager.shared.prepareUploadStream(fileId, null);
    await _sendMessageHandler(
      context: context,
      content: content,
      messageType: MessageType.template,
      sendingType: ChatSendingType.store,
      sendActionFinishHandler: (sendMessage) {
        UploadManager.shared.uploadFile(
          fileType: FileType.video,
          filePath: videoPath!,
          uploadId: fileId,
          receivePubkey: otherUser?.pubKey ?? '',
          encryptedKey: encryptedKey,
          encryptedNonce: encryptedNonce,
          completeCallback: (uploadResult, isFromCache) async {
            var videoURL = uploadResult.url;
            if (!uploadResult.isSuccess || videoURL.isEmpty) return;

            videoURL = generateUrlWithInfo(
              originalUrl: videoURL,
              width: imageWidth,
              height: imageHeight,
            );

            if (snapshotPath != null && snapshotPath.isNotEmpty && !isFromCache) {
              final snapshotFile = File(snapshotPath);
              OXVideoUtils.putFileToCacheWithURL(
                videoURL,
                snapshotFile,
              );
            }

            if (videoPath != null && videoPath.isNotEmpty && !isFromCache) {
              final videoFile = File(videoPath);
              videoFile.readAsBytes().then((bytes) {
                OXFileCacheManager.get(encryptKey: encryptedKey).putFile(
                  videoURL,
                  bytes,
                  fileExtension: videoFile.path.getFileExtension(),
                );
              });
            }

            sendVideoMessageWithURL(
              videoURL: videoURL,
              fileId: fileId ?? '',
              videoPath: videoPath,
              snapshotPath: snapshotPath,
              imageWidth: imageWidth,
              imageHeight: imageHeight,
              replaceMessageId: sendMessage.id,
              encryptedKey: encryptedKey,
              encryptedNonce: encryptedNonce
            );
          },
        );
      },
    );
  }

  void sendVideoMessageWithURL({
    required String videoURL,
    String fileId = '',
    String? videoPath,
    String? snapshotPath,
    int? imageWidth,
    int? imageHeight,
    String? replaceMessageId,
    String? encryptedKey,
    String? encryptedNonce,
    types.Message? resendMessage,
  }) {
    try {
      final contentJson = jsonEncode(
        CustomMessageEx.videoMetaData(
          fileId: fileId,
          snapshotPath: snapshotPath ?? '',
          videoPath: videoPath ?? '',
          url: videoURL,
          width: imageWidth,
          height: imageHeight,
          encryptedKey: encryptedKey,
          encryptedNonce: encryptedNonce,
        ),
      );
      _sendMessageHandler(
        content: contentJson,
        messageType: MessageType.template,
        replaceMessageId: replaceMessageId,
        resendMessage: resendMessage,
      );
    } catch (_) {}
  }

  void _sendTemplateMessage({
    BuildContext? context,
    String title = '',
    String content = '',
    String icon = '',
    String link = '',
  }) {
    try {
      final contentJson = jsonEncode(
        CustomMessageEx.templateMetaData(
          title: title,
          content: content,
          icon: icon,
          link: link,
        ),
      );
      _sendMessageHandler(
        context: context,
        content: contentJson,
        messageType: MessageType.template,
      );
    } catch (_) {}
  }

  void sendSystemMessage(
    String text, {
    BuildContext? context,
    String? localTextKey,
    ChatSendingType sendingType = ChatSendingType.remote,
  }) {
    _sendMessageHandler(
      context: context,
      content: localTextKey ?? text,
      messageType: MessageType.system,
      sendingType: sendingType,
    );
  }

  void sendEcashMessage(
    BuildContext context, {
    required List<String> tokenList,
    List<String> receiverPubkeys = const [],
    List<EcashSignee> signees = const [],
    String validityDate = '',
  }) {
    try {
      final content = jsonEncode(CustomMessageEx.ecashV2MetaData(
        tokenList: tokenList,
        receiverPubkeys: receiverPubkeys,
        signees: signees,
        validityDate: validityDate,
      ));
      _sendMessageHandler(
        context: context,
        content: content,
        messageType: MessageType.template,
      );
    } catch (_) {}
  }
}

extension ChatMessageSendUtileEx on ChatGeneralHandler {
  String createEncryptKey() => bytesToHex(AesEncryptUtils.secureRandom());
  String createEncryptNonce() => bytesToHex(AesEncryptUtils.secureRandomNonce());

  Future<UploadResult> uploadFile({
    required FileType fileType,
    required String filePath,
    required String messageId,
    String? encryptedKey,
    String? encryptedNonce,
  }) async {
    final file = File(filePath);
    final ext = Path.extension(filePath);
    final fileName = '$messageId$ext';
    return await UploadUtils.uploadFile(
        fileType: fileType, file: file, filename: fileName, encryptedKey: encryptedKey, encryptedNonce: encryptedNonce);
  }

  Future<types.Message?> tryPrepareSendFileMessage(
      BuildContext? context, types.Message message) async {
    types.Message? updatedMessage;
    if (message is types.AudioMessage) {
      updatedMessage = await prepareSendAudioMessage(
        message: message,
        context: context,
      );
    } else {
      return message;
    }

    return updatedMessage;
  }

  Future<types.Message?> prepareSendAudioMessage({
    BuildContext? context,
    required types.AudioMessage message,
  }) async {
    final filePath = message.uri;
    final uriIsLocalPath = filePath.isLocalPath;

    if (uriIsLocalPath == null) {
      ChatLogUtils.error(
        className: 'ChatMessageSendEx',
        funcName: 'prepareSendAudioMessage',
        message: 'uriIsLocalPath is null, message: ${message.toJson()}',
      );
      return null;
    }
    if (uriIsLocalPath) {
      final encryptedKey =
          fileEncryptionType == types.EncryptionType.encrypted ? createEncryptKey() : null;
      final encryptedNonce =
          fileEncryptionType == types.EncryptionType.encrypted ? createEncryptNonce() : null;
      final result = await uploadFile(
          fileType: FileType.voice,
          filePath: filePath,
          messageId: message.id,
          encryptedKey: encryptedKey,
          encryptedNonce: encryptedNonce);
      if (!result.isSuccess) {
        CommonToast.instance.show(
            context, '${Localized.text('ox_chat.message_send_audio_fail')}: ${result.errorMsg}');
        return null;
      }

      final audioURL = result.url;
      final audioFile = File(filePath);

      final audioManager = OXFileCacheManager.get(
        encryptKey: encryptedKey,
        encryptNonce: encryptedNonce,
      );

      final cacheFile = await audioManager.putFile(
        audioURL,
        audioFile.readAsBytesSync(),
        fileExtension: audioFile.path.getFileExtension(),
      );

      if (audioFile.path != cacheFile.path) {
        audioFile.delete();
      }

      return message.copyWith(
        uri: audioURL,
        audioFile: cacheFile,
        decryptKey: encryptedKey,
        decryptNonce: encryptedNonce,
      );
    }
    return message;
  }

  String generateUrlWithInfo({
    required String originalUrl,
    int? width,
    int? height,
  }) {
    Uri uri;
    try {
      uri = Uri.parse(originalUrl);
    } catch (_) {
      return originalUrl;
    }

    final originalQuery = uri.queryParameters;
    final updatedUri = uri.replace(
      queryParameters: {
        ...uri.queryParameters,
        if (width != null && !originalQuery.containsKey('width')) 'width': width.toString(),
        if (height != null && !originalQuery.containsKey('height')) 'height': height.toString(),
      },
    );

    return updatedUri.toString();
  }
}
