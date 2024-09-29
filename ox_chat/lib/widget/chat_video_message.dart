
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat/widget/image_preview_widget.dart';
import 'package:ox_common/upload/upload_utils.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/video_utils.dart';
import 'package:ox_chat/utils/custom_message_utils.dart';
import 'package:ox_common/widgets/common_file_cache_manager.dart';

class ChatVideoMessage extends StatefulWidget {

  ChatVideoMessage({
    required this.message,
    required this.messageWidth,
    required this.reactionWidget,
    required this.receiverPubkey,
    this.messageUpdateCallback,
  });

  final types.CustomMessage message;
  final int messageWidth;
  final Widget reactionWidget;
  final String? receiverPubkey;
  final Function(types.Message newMessage)? messageUpdateCallback;

  @override
  State<StatefulWidget> createState() => ChatVideoMessageState();
}

class ChatVideoMessageState extends State<ChatVideoMessage> {

  String videoURL = '';
  String videoPath = '';
  late Future<String> snapshotPath;
  int? width;
  int? height;
  String? encryptedKey;
  Stream<double>? stream;

  bool canOpen = false;

  @override
  void initState() {
    super.initState();
    prepareData();
    tryInitializeVideoFile();
  }

  @override
  void didUpdateWidget(covariant ChatVideoMessage oldWidget) {
    super.didUpdateWidget(oldWidget);
    prepareData();
  }

  void prepareData() {
    final message = widget.message;
    final fileId = VideoMessageEx(message).fileId;
    videoURL = VideoMessageEx(message).url;
    videoPath = VideoMessageEx(message).videoPath;
    encryptedKey = VideoMessageEx(message).encryptedKey;
    canOpen = VideoMessageEx(message).canOpen;

    width = VideoMessageEx(message).width;
    height = VideoMessageEx(message).height;
    stream = fileId.isEmpty || videoURL.isNotEmpty
        ? null
        : UploadManager.shared.getUploadProgress(fileId, null);

    if (width == null || height == null) {
      try {
        final uri = Uri.parse(videoURL);
        final query = uri.queryParameters;
        width ??= int.tryParse(query['width'] ?? query['w'] ?? '');
        height ??= int.tryParse(query['height'] ?? query['h'] ?? '');
      } catch (_) { }
    }

    final snapshotPath = VideoMessageEx(message).snapshotPath;
    if (snapshotPath.isNotEmpty) {
      this.snapshotPath = Future.value(snapshotPath);
    } else if (videoURL.isNotEmpty) {
      this.snapshotPath = OXVideoUtils.getVideoThumbnailImage(videoURL: videoURL).then((file) => file?.path ?? '');
    } else if (fileId.isNotEmpty) {
      this.snapshotPath = Future.value(OXVideoUtils.getVideoThumbnailImageFromMem(cacheKey: fileId)?.path ?? '');
    }
  }

  void tryInitializeVideoFile() async {
    if (videoPath.isNotEmpty) return ;
    if (videoURL.isEmpty) return ;

    File sourceFile;
    final fileManager = OXFileCacheManager.get(encryptKey: encryptedKey);
    final cacheFile = await fileManager.getFileFromCache(videoURL);
    if (cacheFile != null) {
      sourceFile = cacheFile.file;
    } else{
      sourceFile = await fileManager.getSingleFile(videoURL);
      if (encryptedKey != null) {
        sourceFile = await DecryptedCacheManager.decryptFile(sourceFile, encryptedKey!);
      }
    }

    final path = sourceFile.path;
    if (path.isEmpty) return ;

    final snapshotPath = (await OXVideoUtils.getVideoThumbnailImageWithFilePath(videoFilePath: path))?.path ?? '';

    types.CustomMessage newMessage = widget.message.copyWith();
    VideoMessageEx(newMessage).videoPath = path;
    VideoMessageEx(newMessage).snapshotPath = snapshotPath;

    widget.messageUpdateCallback?.call(newMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder(
          future: snapshotPath,
          builder: (context, snapshot) {
            final snapshotPath = snapshot.data ?? '';
            return snapshotBuilder(snapshotPath);
          },
        ),
        if (videoURL.isNotEmpty)
          Positioned.fill(
            child: Center(
              child: canOpen ? buildPlayIcon() : buildLoadingWidget()
            ),
          )
      ],
    );
  }

  Widget buildPlayIcon() => Icon(Icons.play_circle, size: 60.px,);

  Widget buildLoadingWidget() => CircularProgressIndicator(
    strokeWidth: 5,
    backgroundColor: Colors.white.withOpacity(0.5),
    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    strokeCap: StrokeCap.round,
  );

  Widget snapshotBuilder(String imagePath) {
    return ImagePreviewWidget(
      uri: imagePath,
      imageWidth: width,
      imageHeight: height,
      maxWidth: widget.messageWidth,
      progressStream: stream,
    );
  }
}