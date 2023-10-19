import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:ox_common/ox_common.dart';

class ImagesPicker {
  static const MethodChannel _channel = OXCommon.channel;

  static Future<List<Media>?> pick({
    int count = 1,
    PickType pickType = PickType.image,
    bool gif = true,
    int maxTime = 120,
    CropOption? cropOpt,
    int? maxSize,
    double? quality,
    Language language = Language.System,
  }) async {
    assert(count > 0, 'count must > 0');
    if (quality != null) {
      assert(quality > 0, 'quality must > 0');
      assert(quality <= 1, 'quality must <= 1');
    }
    if (maxSize != null) {
      assert(maxSize > 0, 'maxSize must > 0');
    }
    try {
      List<dynamic>? res = await _channel.invokeMethod('pick', {
        "count": count,
        "pickType": pickType.toString(),
        "gif": gif,
        "maxTime": maxTime,
        "maxSize": maxSize ?? null,
        "quality": quality ?? -1,
        "cropOption": cropOpt != null
            ? {
                "quality": quality ?? 1,
                "cropType": cropOpt.cropType.toString(),
                "aspectRatioX": cropOpt.aspectRatio?.aspectRatioX,
                "aspectRatioY": cropOpt.aspectRatio?.aspectRatioY,
              }
            : null,
        "language": language.toString(),
      });
      if (res != null) {
        List<Media> output = res.map((image) {
          Media media = Media(
            path: image["path"],
            size: ((image["size"] ?? 0) / 1024).toDouble(),
            thumbPath: image["thumbPath"],
          );
          return media;
        }).toList();
        return output;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Media>?> openCamera({
    PickType pickType = PickType.image,
    int maxTime = 15,
    CropOption? cropOpt,
    int? maxSize,
    double? quality,
    Language language = Language.System,
  }) async {
    if (quality != null) {
      assert(quality > 0, 'quality must > 0');
      assert(quality <= 1, 'quality must <= 1');
    }
    if (maxSize != null) {
      assert(maxSize > 0, 'maxSize must > 0');
    }
    try {
      List<dynamic>? res = await _channel.invokeMethod('openCamera', {
        "pickType": pickType.toString(),
        "maxTime": maxTime,
        "maxSize": maxSize ?? null,
        "quality": quality ?? -1,
        "cropOption": cropOpt != null
            ? {
                "quality": quality ?? 1,
                "cropType": cropOpt.cropType.toString(),
                "aspectRatioX": cropOpt.aspectRatio?.aspectRatioX,
                "aspectRatioY": cropOpt.aspectRatio?.aspectRatioY,
              }
            : null,
        "language": language.toString(),
      });
      if (res != null) {
        List<Media> output = res.map((image) {
          Media media = Media(
            path: image["path"],
            size: ((image["size"] ?? 0) / 1024).toDouble(),
            thumbPath: image["thumbPath"],
          );
          return media;
        }).toList();
        return output;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> saveImageToAlbum(File file, {String? albumName}) async {
    try {
      return await _channel.invokeMethod('saveImageToAlbum', {
        "path": file.path,
        "albumName": albumName,
      });
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> saveVideoToAlbum(File file, {String? albumName}) async {
    try {
      return await _channel.invokeMethod('saveVideoToAlbum', {
        "path": file.path,
        "albumName": albumName,
      });
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }
}

enum PickType {
  image,
  video,
  all,
}

enum CropType {
  rect,
  circle,
}

enum Language {
  System,
  Chinese,
  ChineseTraditional,
  English,
  Japanese,
  French,
  Korean,
  German,
  Vietnamese,
}

class CropAspectRatio {
  final int aspectRatioX;
  final int aspectRatioY;

  const CropAspectRatio(this.aspectRatioX, this.aspectRatioY)
      : assert(aspectRatioX > 0, 'aspectRatioX must > 0'),
        assert(aspectRatioY > 0, 'aspectRatioY must > 0');

  static const custom = null;
  static const wh2x1 = CropAspectRatio(2, 1);
  static const wh1x2 = CropAspectRatio(1, 2);
  static const wh3x4 = CropAspectRatio(3, 4);
  static const wh4x3 = CropAspectRatio(4, 3);
  static const wh16x9 = CropAspectRatio(16, 9);
  static const wh9x16 = CropAspectRatio(9, 16);
}

class CropOption {
  final CropType cropType;
  final CropAspectRatio? aspectRatio;

  CropOption({
    this.aspectRatio = CropAspectRatio.custom,
    this.cropType = CropType.rect,
  });
}

class Media {
  ///视频缩略图图片路径
  ///Video thumbnail image path
  String? thumbPath;

  ///视频路径或图片路径
  ///Video path or image path
  String path;

  /// 文件大小
  double size;

  Media({
    required this.path,
    this.thumbPath,
    required this.size,
  });
}
