import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat/widget/chat_image_preview_widget.dart';
import 'package:ox_common/upload/upload_utils.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/video_data_manager.dart';
import 'package:ox_chat/utils/custom_message_utils.dart';

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

  String get fileId => VideoMessageEx(widget.message).fileId;
  String get videoURL => VideoMessageEx(widget.message).url;
  String get videoPath => VideoMessageEx(widget.message).videoPath;
  String get snapshotPath => VideoMessageEx(widget.message).snapshotPath;
  String? get encryptedKey => VideoMessageEx(widget.message).encryptedKey;
  String? get encryptedNonce => VideoMessageEx(widget.message).encryptedNonce;
  bool get canOpen => VideoMessageEx(widget.message).canOpen;

  int? width;
  int? height;
  Stream<UploadProgress>? stream;

  @override
  void initState() {
    super.initState();
    prepareData();
    tryInitializeVideoMedia();
  }
  
  @override
  void dispose() {
    VideoDataManager.shared.cancelTask(videoURL);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ChatVideoMessage oldWidget) {
    super.didUpdateWidget(oldWidget);
    prepareData();
  }

  void prepareData() {
    final message = widget.message;

    width = VideoMessageEx(message).width;
    height = VideoMessageEx(message).height;
    stream = fileId.isEmpty || videoURL.isNotEmpty || widget.message.status == types.Status.error
        ? null
        : UploadManager.shared.getUploadProgress(fileId, widget.receiverPubkey);

    if (width == null || height == null) {
      try {
        final uri = Uri.parse(videoURL);
        final query = uri.queryParameters;
        width ??= int.tryParse(query['width'] ?? query['w'] ?? '');
        height ??= int.tryParse(query['height'] ?? query['h'] ?? '');
      } catch (_) { }
    }
  }

  void tryInitializeVideoMedia() async {
    if (videoURL.isEmpty) return;
    // Already resolved, e.g. the bubble scrolled back into view: skip the
    // fetch and the message update, which regroups the whole chat.
    if (_isMediaResolved()) return;

    final media = await VideoDataManager.shared.fetchVideoMedia(
      videoURL: videoURL,
      encryptedKey: encryptedKey,
      encryptedNonce: encryptedNonce,
    );
    if (media == null) return;

    final newVideoPath = media.path ?? '';
    final newSnapshotPath = media.thumbPath ?? '';
    if (newVideoPath == videoPath && newSnapshotPath == snapshotPath) return;

    types.CustomMessage newMessage = widget.message.copyWith();
    VideoMessageEx(newMessage).videoPath = newVideoPath;
    VideoMessageEx(newMessage).snapshotPath = newSnapshotPath;

    widget.messageUpdateCallback?.call(newMessage);
  }

  /// The bubble has its thumbnail, and whatever it plays from is available:
  /// a local file when one is recorded (always for encrypted videos, see
  /// [VideoMessageEx.canOpen]), otherwise the URL.
  bool _isMediaResolved() {
    if (!_isExistingFile(snapshotPath)) return false;
    if (videoPath.isEmpty) return encryptedKey == null;
    return _isExistingFile(videoPath);
  }

  bool _isExistingFile(String path) => path.isNotEmpty && File(path).existsSync();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        snapshotBuilder(snapshotPath),
        if (videoURL.isNotEmpty || widget.message.status == types.Status.error)
          Positioned.fill(
            child: Center(
              child: canOpen || widget.message.status == types.Status.error
                  ? buildPlayIcon()
                  : buildLoadingWidget()
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
    return ChatImagePreviewWidget(
      uri: imagePath,
      imageWidth: width,
      imageHeight: height,
      maxWidth: widget.messageWidth.toDouble(),
      progressStream: stream,
    );
  }
}