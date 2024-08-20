
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:ox_common/utils/adapt.dart';
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
    return SizedBox();

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
    );
  }
}

extension OXCachedImageProviderEx on CachedNetworkImageProvider {

  static Map<String, Size> sizeCache = {};

  static String _cacheKeyWithBase64(String imageBase64) {
    return md5.convert(utf8.encode(imageBase64)).toString();
  }

  static Size? getImageSizeWithBase64(String imageBase64) {
    final cacheKey = _cacheKeyWithBase64(imageBase64);
    final size = sizeCache[cacheKey];
    if (size != null) return size;

    decodeImageFromList(_base64ToBytes(imageBase64)).then((image) {
      final size = Size(image.width.toDouble(), image.height.toDouble());
      sizeCache[cacheKey] = size;
    });

    return null;
  }

  static ImageProvider create(String uri, {
    double? width,
    double? height,
    Map<String, String>? headers,
    BaseCacheManager? cacheManager,
    String? decryptedKey,
  }) {
    final ratio = Adapt.devicePixelRatio;

    int? resizeWidth;
    if (width != null && width != double.infinity) {
      resizeWidth = (width * ratio).round();
    }

    int? resizeHeight;
    if (height != null && height != double.infinity) {
      resizeHeight = (height * ratio).round();
    }

    if (resizeWidth == null && resizeHeight == null) {
      resizeWidth = (500 * ratio).round();
    }

    ImageProvider provider;
    if (uri.isImageBase64) {
      provider = MemoryImage(_base64ToBytes(uri));
    } else if (uri.isRemoteURL) {
      provider = CachedNetworkImageProvider(
        uri,
        headers: headers,
        cacheManager: cacheManager ?? OXFileCacheManager.get(encryptKey: decryptedKey),
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