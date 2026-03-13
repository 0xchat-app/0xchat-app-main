
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ox_chat/utils/chat_log_utils.dart';
import 'package:ox_common/upload/upload_utils.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/widgets/common_network_image.dart';

class ChatImagePreviewWidget extends StatefulWidget {
  ChatImagePreviewWidget({
    required this.uri,
    this.imageWidth,
    this.imageHeight,
    this.maxWidth,
    this.decryptKey,
    this.decryptNonce,
    this.progressStream,
  });

  final String uri;
  final int? imageWidth;
  final int? imageHeight;
  final double? maxWidth;
  final String? decryptKey;
  final String? decryptNonce;
  final Stream<UploadProgress>? progressStream;

  @override
  State<StatefulWidget> createState() => ChatImagePreviewWidgetState();
}

class ChatImagePreviewWidgetState extends State<ChatImagePreviewWidget> {

  ImageProvider? imageProvider;
  ImageStream? imageStream;
  Size imageSize = Size.zero;

  bool isLoadImageFinish = false;

  // Non-null when the image has been loading too long without result.
  String? _loadingStatus;
  Timer? _slowTimer;
  Timer? _blockedTimer;

  double get minWidth => 100.px;
  double get minHeight => 100.px;
  double get maxHeight => 300.px;

  @override
  void initState() {
    super.initState();
    prepareImage();
    _startLoadingTimers();
  }

  void prepareImage() {
    final uri = widget.uri;

    final ratio = Adapt.devicePixelRatio;
    double? width = (widget.imageWidth?.toDouble() ?? 0) / ratio;
    double? height = (widget.imageHeight?.toDouble() ?? 0) / ratio;

    if (width < 1) width = null;
    if (height < 1) height = null;
    if (width != null && height != null) {
      imageSize = Size(width, height);
    }

    if (uri.isEmpty) return ;
    imageProvider = OXCachedImageProviderEx.create(
      uri,
      width: width,
      height: height,
      maxWidth: widget.maxWidth,
      decryptedKey: widget.decryptKey,
      decryptedNonce: widget.decryptNonce
    );

    if (uri.isImageBase64) {
      imageSize = OXCachedImageProviderEx.getImageSizeWithBase64(uri) ?? imageSize;
    }
  }

  @override
  void didUpdateWidget(covariant ChatImagePreviewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.uri != widget.uri
        || oldWidget.imageWidth != widget.imageWidth
        || oldWidget.imageHeight != widget.imageHeight) {
      isLoadImageFinish = false;
      _loadingStatus = null;
      _cancelLoadingTimers();
      prepareImage();
      _startLoadingTimers();
    }
  }

  void _startLoadingTimers() {
    // Only show slow/blocked hints for received images (no upload stream),
    // and only when there is actually a URI to load.
    if (widget.progressStream != null || widget.uri.isEmpty || widget.uri.isImageBase64) return;
    _slowTimer = Timer(const Duration(seconds: 10), () {
      if (mounted && !isLoadImageFinish) {
        setState(() {
          _loadingStatus = 'Image is taking longer than expected\nSlow or blocked network?';
        });
      }
    });
    _blockedTimer = Timer(const Duration(seconds: 25), () {
      if (mounted && !isLoadImageFinish) {
        setState(() {
          _loadingStatus = 'Could not load image\nMay be blocked by your ISP or network';
        });
      }
    });
  }

  void _cancelLoadingTimers() {
    _slowTimer?.cancel();
    _blockedTimer?.cancel();
    _slowTimer = null;
    _blockedTimer = null;
  }

  Uint8List dataUriToBytes(String dataUri) {
    final base64String = dataUri.split(',').last;
    return base64.decode(base64String);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (imageSize.isEmpty) {
      addImageSizeListener();
    }
  }

  @override
  void dispose() {
    _cancelLoadingTimers();
    imageStream?.removeListener(ImageStreamListener(updateImage));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progressStream = widget.progressStream;
    return Stack(
      children: [
        buildImageWidget(),
        if (progressStream != null) Positioned.fill(child: buildStreamProgressMask(progressStream)),
        if (progressStream == null && !isLoadImageFinish && _loadingStatus != null)
          Positioned.fill(child: _buildStatusOverlay(_loadingStatus!)),
      ],
    );
  }

  Widget buildImageWidget() {
    return Container(
      constraints: BoxConstraints(
        minWidth: minWidth,
        maxWidth: widget.maxWidth?.toDouble() ?? double.infinity,
        minHeight: minHeight,
        maxHeight: maxHeight,
      ),
      color: isLoadImageFinish == true ? null : Colors.grey.withOpacity(0.7),
      child: AspectRatio(
        aspectRatio: imageSize.aspectRatio > 0 ? imageSize.aspectRatio : 0.7,
        child: imageProvider != null ? Image(
          fit: BoxFit.cover,
          image: imageProvider!,
          frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded,) {
            if (!isLoadImageFinish && frame != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  isLoadImageFinish = true;
                });
              });
            }
            return child;
          },
          errorBuilder: (context, error, stackTrace,) {
            ChatLogUtils.error(
              className: 'ImagePreviewWidget',
              funcName: 'buildImageWidget',
              message: error.toString(),
            );
            final msg = _friendlyError(error);
            return Container(
              alignment: Alignment.center,
              color: Colors.grey.withOpacity(0.15),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.broken_image_outlined, color: Colors.white54, size: 28),
                    SizedBox(height: 6),
                    Text(
                      msg,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            final expectedTotalBytes = loadingProgress.expectedTotalBytes ?? 0;
            final progress = expectedTotalBytes > 0
                ? loadingProgress.cumulativeBytesLoaded / expectedTotalBytes
                : 0.0;
            return buildProgressMask(progress.clamp(0.0, 1.0), label: 'Loading...');
          },
        ) : null,
      ),
    );
  }

  Widget buildStreamProgressMask(Stream<UploadProgress> stream) {
    return StreamBuilder<UploadProgress>(
      stream: stream,
      builder: (context, snapshot) {
        final info = snapshot.data;
        return buildProgressMask(info?.progress ?? 0.0, serverName: info?.serverName, label: 'Uploading...');
      },
    );
  }

  Widget buildProgressMask(double progress, {String? serverName, String label = 'Loading...'}) {
    final percent = (progress * 100).round();
    return Container(
      alignment: Alignment.center,
      color: Colors.black.withOpacity(0.35),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: CircularProgressIndicator(
              value: progress > 0 ? progress : null,
              strokeWidth: 5,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeCap: StrokeCap.round,
            ),
          ),
          SizedBox(height: 8),
          Text(
            progress > 0 ? '$percent%' : label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.none,
            ),
          ),
          if (serverName != null && serverName.isNotEmpty) ...[            SizedBox(height: 3),
            Text(
              'via $serverName',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusOverlay(String message) {
    final isBlocked = message.contains('blocked') || message.contains('Could not');
    return Container(
      alignment: Alignment.center,
      color: Colors.black.withOpacity(0.45),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isBlocked ? Icons.cloud_off_outlined : Icons.hourglass_bottom_rounded,
              color: Colors.white70,
              size: 28,
            ),
            SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addImageSizeListener() {
    final oldImageStream = imageStream;
    imageStream = imageProvider?.resolve(createLocalImageConfiguration(context));
    if (imageStream?.key == oldImageStream?.key) {
      return;
    }
    final listener = ImageStreamListener(
      updateImage,
      onError: (dynamic error, StackTrace? stackTrace) {
        ChatLogUtils.error(
          className: 'ChatImagePreviewWidget',
          funcName: 'imageStream.onError',
          message: error.toString(),
        );
        // errorBuilder on the Image widget will handle the UI;
        // we cancel timers so the timeout overlay doesn't also show.
        _cancelLoadingTimers();
      },
    );
    oldImageStream?.removeListener(ImageStreamListener(updateImage));
    imageStream?.addListener(listener);
  }

  void updateImage(ImageInfo info, bool _) {
    _cancelLoadingTimers();
    setState(() {
      _loadingStatus = null;
      imageSize = Size(
        info.image.width.toDouble(),
        info.image.height.toDouble(),
      );
    });
  }

  String _friendlyError(Object error) {
    final msg = error.toString().toLowerCase();
    if (msg.contains('socketexception') || msg.contains('connection refused') || msg.contains('network')) {
      return 'Network error — check your connection';
    }
    if (msg.contains('timeout')) return 'Connection timed out';
    if (msg.contains('404') || msg.contains('not found')) return 'Image not found (404)';
    if (msg.contains('403') || msg.contains('forbidden')) return 'Access denied (403)';
    if (msg.contains('certificate') || msg.contains('ssl') || msg.contains('tls')) {
      return 'SSL/TLS error';
    }
    if (msg.contains('no address') || msg.contains('failed host lookup')) {
      return 'Could not resolve host';
    }
    // Strip dart noise, keep first meaningful sentence.
    final clean = error.toString().replaceAll(RegExp(r'\(.*?\)'), '').trim();
    return clean.length > 80 ? '${clean.substring(0, 80)}…' : clean;
  }
}