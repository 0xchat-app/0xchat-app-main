
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_decrypted_image_provider.dart';

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
    final decryptKey = widget.decryptKey;

    if (uri.isEmpty) return ;

    if (decryptKey == null && uri.startsWith('data:image/')) {
      // Image data
      imageProvider = Image.memory(
        dataUriToBytes(uri),
      ).image;
    } else if (uri.isRemoteURL) {
      // Network url
      imageProvider = CachedNetworkImageProvider(
        uri,
        cacheManager: decryptKey != null ? DecryptedCacheManager(decryptKey) : null,
      );
    } else {
      // File path
      imageProvider = Image.file(File(uri)).image;
    }

    if (widget.imageWidth != null && widget.imageHeight != null) {
      imageSize = Size(widget.imageWidth!.toDouble(), widget.imageHeight!.toDouble());
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
        if (progressStream != null) Positioned.fill(child: buildProgressMask(progressStream)),
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
      child: AspectRatio(
        aspectRatio: imageSize.aspectRatio > 0 ? imageSize.aspectRatio : 0.7,
        child: imageProvider != null ? Image(
          fit: BoxFit.cover,
          image: imageProvider!,
        ) : Container(color: ThemeColor.gray01,),
      ),
    );
  }

  Widget buildProgressMask(Stream<double> stream) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        final progress = snapshot.data ?? 0.0;
        return Container(
          color: Colors.grey.withOpacity(0.7),
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 5,
            backgroundColor: Colors.grey.withOpacity(0.9),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeCap: StrokeCap.round,
          ),
        );
      }
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