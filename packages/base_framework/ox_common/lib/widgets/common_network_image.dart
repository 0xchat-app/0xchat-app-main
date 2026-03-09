
import 'dart:async';
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

class OXCachedNetworkImage extends StatefulWidget {

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

  const OXCachedNetworkImage({
    Key? key,
    required this.imageUrl,
    this.fit,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
    this.isThumb = false,
  }) : super(key: key);

  @override
  State<OXCachedNetworkImage> createState() => _OXCachedNetworkImageState();
}

class _OXCachedNetworkImageState extends State<OXCachedNetworkImage> {
  static const int _maxRetries = 5;

  int _retryCount = 0;
  // Incrementing this key forces a new CachedNetworkImage instance on retry
  int _imageKey = 0;
  Timer? _retryTimer;

  @override
  void didUpdateWidget(OXCachedNetworkImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _retryTimer?.cancel();
      _retryCount = 0;
      _imageKey = 0;
    }
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    super.dispose();
  }

  void _scheduleRetry(String cacheKey) {
    if (_retryCount >= _maxRetries) return;
    // Exponential backoff: 2s, 4s, 8s, 16s, 32s
    final delay = Duration(seconds: 2 << _retryCount);
    _retryTimer?.cancel();
    _retryTimer = Timer(delay, () async {
      try {
        await OXFileCacheManager.get().removeFile(cacheKey);
      } catch (_) {}
      if (mounted) {
        setState(() {
          _retryCount++;
          _imageKey++;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ratio = MediaQuery.of(context).devicePixelRatio;

    const int maxMemoryCacheSize = 800;

    int? memCacheWidth;
    if (widget.width != null && widget.width != double.infinity) {
      memCacheWidth = (widget.width! * ratio).round();
      if (memCacheWidth > maxMemoryCacheSize) memCacheWidth = maxMemoryCacheSize;
    }

    int? memCacheHeight;
    if (memCacheWidth == null && widget.height != null && widget.height != double.infinity) {
      memCacheHeight = (widget.height! * ratio).round();
      if (memCacheHeight > maxMemoryCacheSize) memCacheHeight = maxMemoryCacheSize;
    }

    String? cacheKey;
    int? maxWidthDiskCache;
    int? maxHeightDiskCache;
    if (widget.isThumb) {
      cacheKey = '${widget.imageUrl}_thumb';
      maxWidthDiskCache = (80.px * ratio).round();
      maxHeightDiskCache = (80.px * ratio).round();
    } else {
      final screenWidth = MediaQuery.of(context).size.width;
      maxWidthDiskCache = (screenWidth * ratio * 1.5).round();
      maxHeightDiskCache = (screenWidth * ratio * 1.5).round();
    }

    final effectiveCacheKey = cacheKey ?? widget.imageUrl;

    return CachedNetworkImage(
      key: ValueKey(_imageKey),
      imageUrl: widget.imageUrl,
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      placeholder: widget.placeholder,
      errorWidget: (context, url, error) {
        // Schedule a retry with exponential backoff; uses microtask to avoid
        // calling setState during the build phase.
        if (_retryCount < _maxRetries) {
          Future.microtask(() => _scheduleRetry(effectiveCacheKey));
          // Show placeholder while waiting for retry
          return widget.placeholder?.call(context, url) ??
              SizedBox(width: widget.width, height: widget.height);
        }
        // All retries exhausted — show caller's error widget or empty box
        return widget.errorWidget?.call(context, url, error) ??
            SizedBox(width: widget.width, height: widget.height);
      },
      cacheManager: OXFileCacheManager.get(),
      cacheKey: cacheKey,
      maxWidthDiskCache: maxWidthDiskCache,
      maxHeightDiskCache: maxHeightDiskCache,
    );
  }
}

extension OXCachedImageProviderEx on CachedNetworkImageProvider {

  static const int _maxSizeCacheEntries = 200;
  static final Map<String, Size> sizeCache = {};

  static String _cacheKeyWithBase64(String imageBase64) {
    return md5.convert(utf8.encode(imageBase64)).toString();
  }

  static Size? getImageSizeWithBase64(String imageBase64) {
    final cacheKey = _cacheKeyWithBase64(imageBase64);
    final size = sizeCache[cacheKey];
    if (size != null) return size;

    decodeImageFromList(_base64ToBytes(imageBase64)).then((image) {
      final size = Size(image.width.toDouble(), image.height.toDouble());
      // Evict oldest entry when cache is full.
      if (sizeCache.length >= _maxSizeCacheEntries) {
        sizeCache.remove(sizeCache.keys.first);
      }
      sizeCache[cacheKey] = size;
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