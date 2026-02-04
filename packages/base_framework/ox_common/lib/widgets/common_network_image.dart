
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/num_utils.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/widgets/common_file_cache_manager.dart';

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

  final bool isThumb;

  OXCachedNetworkImage({
    required this.imageUrl,
    this.fit,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
    this.isThumb = false,
  });

  @override
  Widget build(BuildContext context) {

    final ratio = MediaQuery.of(context).devicePixelRatio;

    // Optimized: Limit memory cache size to reduce memory pressure
    // Maximum memory cache size: 800px to prevent excessive memory usage
    const int maxMemoryCacheSize = 800;
    
    int? memCacheWidth;
    if (width != null && width != double.infinity) {
      memCacheWidth = (width! * ratio).round();
      // Limit memory cache width to prevent excessive memory usage
      if (memCacheWidth > maxMemoryCacheSize) {
        memCacheWidth = maxMemoryCacheSize;
      }
    }

    int? memCacheHeight;
    if (memCacheWidth == null && height != null && height != double.infinity) {
      memCacheHeight = (height! * ratio).round();
      // Limit memory cache height to prevent excessive memory usage
      if (memCacheHeight > maxMemoryCacheSize) {
        memCacheHeight = maxMemoryCacheSize;
      }
    }

    String? cacheKey;
    int? maxWidthDiskCache;
    int? maxHeightDiskCache;
    if (isThumb) {
      cacheKey = '$imageUrl\_thumb';
      maxWidthDiskCache = (80.px * ratio).round();
      maxHeightDiskCache = (80.px * ratio).round();
    } else {
      // Optimized: Set default disk cache limits for non-thumb images
      // Limit to screen width to reduce disk usage
      final screenWidth = MediaQuery.of(context).size.width;
      maxWidthDiskCache = (screenWidth * ratio * 1.5).round(); // 1.5x for high DPI
      maxHeightDiskCache = (screenWidth * ratio * 1.5).round();
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
      cacheManager: OXFileCacheManager.get(),
      cacheKey: cacheKey,
      maxWidthDiskCache: maxWidthDiskCache,
      maxHeightDiskCache: maxHeightDiskCache,
    );
  }
}

extension OXCachedImageProviderEx on CachedNetworkImageProvider {

  static Map<String, Size> sizeCache = {};
  /// Max entries to avoid unbounded growth (e.g. Linux long sessions).
  static const int kSizeCacheMaxEntries = 500;
  /// FIFO key order for eviction (oldest first).
  static final List<String> _sizeCacheKeys = [];

  static int get sizeCacheLength => sizeCache.length;

  static String _cacheKeyWithBase64(String imageBase64) {
    return md5.convert(utf8.encode(imageBase64)).toString();
  }

  static Size? getImageSizeWithBase64(String imageBase64) {
    final cacheKey = _cacheKeyWithBase64(imageBase64);
    final size = sizeCache[cacheKey];
    if (size != null) return size;

    decodeImageFromList(_base64ToBytes(imageBase64)).then((image) {
      final size = Size(image.width.toDouble(), image.height.toDouble());
      if (Platform.isLinux &&
          sizeCache.length >= kSizeCacheMaxEntries &&
          _sizeCacheKeys.isNotEmpty) {
        final oldest = _sizeCacheKeys.removeAt(0);
        sizeCache.remove(oldest);
      }
      if (!sizeCache.containsKey(cacheKey)) {
        _sizeCacheKeys.add(cacheKey);
        sizeCache[cacheKey] = size;
      }
    });

    return null;
  }

  static ImageProvider create(String uri, {
    double? width,
    double? height,
    double? maxWidth,
    double? maxHeight,
    Map<String, String>? headers,
    BaseCacheManager? cacheManager,
    String? decryptedKey,
    String? decryptedNonce,
  }) {
    final pixelRatio = Adapt.devicePixelRatio;

    // uri = ' https://nostr-chat-bucket.oss-cn-hongkong.aliyuncs.com/images/bdaa9320-f02a-11ef-b7a0-6125491236fb.jpeg';
    // Initialize value
    final defaultWidth = Adapt.screenW;
    final defaultHeight = Adapt.screenH;
    if (!width.isValid() && maxWidth != null) {
      width = defaultWidth;
    } else if (!height.isValid() && maxHeight != null) {
      height = defaultHeight;
    } else if (!width.isValid() && !height.isValid()) {
      width = defaultWidth;
    }

    final maxPixelWidth = maxWidth * pixelRatio;
    final maxPixelHeight = maxHeight * pixelRatio;

    int? resizeWidth;
    int? resizeHeight;
    double? widthFactor;
    double? heightFactor;

    if (width != null && width.isValid()) {
      resizeWidth = (width * pixelRatio).round();
      if (maxPixelWidth != null) {
        widthFactor = maxPixelWidth / resizeWidth;
      }
    }
    if (height != null && height != double.infinity) {
      resizeHeight = (height * pixelRatio).round();
      if (maxPixelHeight != null) {
        heightFactor = maxPixelHeight / resizeHeight;
      }
    }

    final factor = min(widthFactor ?? 1, heightFactor ?? 1);
    if (factor > 0.0 && factor < 1.0) {
      resizeWidth = (resizeWidth?.toDouble() * factor)?.toInt();
      resizeHeight = (resizeHeight?.toDouble() * factor)?.toInt();
    }

    ImageProvider provider;
    if (uri.isImageBase64) {
      provider = MemoryImage(_base64ToBytes(uri));
    } else if (uri.isRemoteURL) {
      provider = CachedNetworkImageProvider(
        uri,
        headers: headers,
        cacheManager: cacheManager ?? OXFileCacheManager.get(encryptKey: decryptedKey, encryptNonce: decryptedNonce),
      );
    } else {
      provider = FileImage(File(uri));
    }

    return ResizeImage.resizeIfNeeded(
      resizeWidth,
      resizeHeight,
      provider,
    );
  }

  static Uint8List _base64ToBytes(String imageBase64) {
    final base64String = imageBase64.split(',').last;
    return base64.decode(base64String);
  }
}