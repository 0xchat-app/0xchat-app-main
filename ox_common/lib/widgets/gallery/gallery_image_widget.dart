
import 'package:flutter/material.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/widgets/common_network_image.dart';

class GalleryImageWidget extends StatefulWidget {

  GalleryImageWidget({
    super.key,
    required this.uri,
    this.fit,
    this.decryptKey,
    this.decryptNonce,
  });

  // Remote url / Local path / Base64 string
  final String uri;

  final BoxFit? fit;

  final String? decryptKey;
  final String? decryptNonce;

  @override
  State<StatefulWidget> createState() => GalleryImageWidgetState();
}

class GalleryImageWidgetState extends State<GalleryImageWidget> {

  late ImageProvider imageProvider;

  @override
  void initState() {
    super.initState();
    setupImageProvider();
  }

  @override
  void didUpdateWidget(covariant GalleryImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.uri != oldWidget.uri) {
      setupImageProvider();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Image(
      fit: widget.fit,
      image: imageProvider,
      errorBuilder: (context, error, stackTrace,) {
        LogUtil.e(
          'className: ImagePreviewWidget'
          'funcName: buildImageWidget'
          'message: ${error.toString()}'
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
    );
  }

  void setupImageProvider() {
    if (widget.uri.isEmpty) return;

    imageProvider = OXCachedImageProviderEx.create(
        widget.uri,
        decryptedKey: widget.decryptKey,
        decryptedNonce: widget.decryptNonce
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
}