
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ox_chat/utils/chat_log_utils.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_network_image.dart';

class ImagePreviewWidget extends StatefulWidget {
  ImagePreviewWidget({
    required this.uri,
    this.imageWidth,
    this.imageHeight,
    this.maxWidth,
    this.decryptKey,
    this.progressStream,
  });

  final String uri;
  final int? imageWidth;
  final int? imageHeight;
  final int? maxWidth;
  final String? decryptKey;
  final Stream<double>? progressStream;

  @override
  State<StatefulWidget> createState() => ImagePreviewWidgetState();
}

class ImagePreviewWidgetState extends State<ImagePreviewWidget> {

  ImageProvider? imageProvider;
  ImageStream? imageStream;
  Size imageSize = Size.zero;

  double get minWidth => 100.px;
  double get minHeight => 100.px;
  double get maxHeight => 300.px;

  @override
  void initState() {
    super.initState();
    prepareImage();
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
      decryptedKey: widget.decryptKey,
    );

    if (uri.isImageBase64) {
      imageSize = OXCachedImageProviderEx.getImageSizeWithBase64(uri) ?? imageSize;
    }
  }

  @override
  void didUpdateWidget(covariant ImagePreviewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.uri != widget.uri
        || oldWidget.imageWidth != widget.imageWidth
        || oldWidget.imageHeight != widget.imageHeight) {
      prepareImage();
    }
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
      color: ThemeColor.gray01,
      child: AspectRatio(
        aspectRatio: imageSize.aspectRatio > 0 ? imageSize.aspectRatio : 0.7,
        child: imageProvider != null ? Image(
          fit: BoxFit.cover,
          image: imageProvider!,
          errorBuilder: (context, error, stackTrace,) {
            ChatLogUtils.error(
              className: 'ImagePreviewWidget',
              funcName: 'buildImageWidget',
              message: error.toString(),
            );
            return SizedBox();
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            final expectedTotalBytes = loadingProgress.expectedTotalBytes ?? 0;
            final progress = expectedTotalBytes > 0
                ? loadingProgress.cumulativeBytesLoaded / expectedTotalBytes
                : 0.0;
            return buildProgressMask(progress.clamp(0.0, 1.0));
          },
        ) : null,
      ),
    );
  }

  Widget buildStreamProgressMask(Stream<double> stream) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) =>
          buildProgressMask(snapshot.data ?? 0.0),
    );
  }

  Widget buildProgressMask(double progress) {
    return Container(
      color: Colors.grey.withOpacity(0.7),
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        value: progress,
        strokeWidth: 5,
        backgroundColor: Colors.white.withOpacity(0.5),
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        strokeCap: StrokeCap.round,
      ),
    );
  }

  void addImageSizeListener() {
    final oldImageStream = imageStream;
    imageStream = imageProvider?.resolve(createLocalImageConfiguration(context));
    if (imageStream?.key == oldImageStream?.key) {
      return;
    }
    final listener = ImageStreamListener(updateImage);
    oldImageStream?.removeListener(listener);
    imageStream?.addListener(listener);
  }

  void updateImage(ImageInfo info, bool _) {
    setState(() {
      imageSize = Size(
        info.image.width.toDouble(),
        info.image.height.toDouble(),
      );
    });
  }
}