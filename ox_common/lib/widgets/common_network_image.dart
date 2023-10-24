
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class OXCachedNetworkImage extends StatelessWidget {

  /// See [CachedNetworkImage.imageUrl]
  final String imageUrl;

  /// See [CachedNetworkImage.fit]
  final BoxFit? fit;

  /// See [CachedNetworkImage.width]
  final double? width;

  /// See [CachedNetworkImage.height]
  final double? height;

  /// See [CachedNetworkImage.placeholder]
  final PlaceholderWidgetBuilder? placeholder;

  /// See [CachedNetworkImage.errorWidget]
  final LoadingErrorWidgetBuilder? errorWidget;

  OXCachedNetworkImage({
    required this.imageUrl,
    this.fit,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {

    final ratio = MediaQuery.of(context).devicePixelRatio;

    int? memCacheWidth;
    if (width != null && width != double.infinity) {
      memCacheWidth = (width! * ratio).round();
    }

    int? memCacheHeight;
    if (memCacheWidth == null && height != null && height != double.infinity) {
      memCacheWidth = (height! * ratio).round();
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      placeholder: placeholder,
      errorWidget: errorWidget,
    );
  }
}

extension OXCachedNetworkImageProviderEx on CachedNetworkImageProvider {
  static ImageProvider create(BuildContext context, String url, {
    double? width,
    double? height,
    Map<String, String>? headers,
    BaseCacheManager? cacheManager,
  }) {
    final ratio = MediaQuery.of(context).devicePixelRatio;

    int? resizeWidth;
    if (width != null && width != double.infinity) {
      resizeWidth = (width * ratio).round();
    }

    int? resizeHeight;
    if (height != null && height != double.infinity) {
      resizeHeight = (height * ratio).round();
    }

    if (resizeWidth == null && resizeHeight == null) {
      assert(false);
    }

    return ResizeImage.resizeIfNeeded(
      resizeWidth,
      resizeHeight,
      CachedNetworkImageProvider(
        url,
        headers: headers,
        cacheManager: cacheManager,
      ),
    );
  }
}