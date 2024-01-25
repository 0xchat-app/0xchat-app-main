
import 'package:flutter/services.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/ox_common.dart';

///Title: image_picker_utils
///Description: TODO(Take a photo or select an image from an album)
///Copyright: Copyright (c) 2023
///@author john
///@CheckItem Fill in by oneself
///@since Dart 2.3
class ImagePickerUtils {

  /// Choose an image or video
  ///
  /// Return information of the selected picture or video
  ///
  /// galleryMode enum Select an image or select a video to enumerate
  ///
  /// uiConfig  Select an image or select the theme of the video page Default 0xfffefefe
  ///
  /// selectCount Number of images to select
  ///
  /// showCamera Whether to display the camera button
  ///
  /// cropConfig  Crop configuration (video does not support cropping and compression, this parameter is not available when selecting video)
  ///
  /// compressSize Ignore compression size after selection, will not compress unit KB when the image size is smaller than compressSize
  ///
  /// videoRecordMaxSecond  Maximum video recording time (seconds)
  ///
  /// videoRecordMinSecond  Minimum video recording time (seconds)
  ///
  /// videoSelectMaxSecond  Maximum video duration when selecting a video (seconds)
  ///
  /// videoSelectMinSecond  Minimum video duration when selecting a video (seconds)
  static Future<List<Media>> pickerPaths({
    GalleryMode galleryMode = GalleryMode.image,
    UIConfig? uiConfig,
    int selectCount = 1,
    bool showCamera = false,
    bool showGif = true,
    CropConfig? cropConfig,
    int compressSize = 500,
    int videoRecordMaxSecond = 120,
    int videoRecordMinSecond = 1,
    int videoSelectMaxSecond = 120,
    int videoSelectMinSecond = 1,
    Language language = Language.system,
  }) async {
    Color uiColor = UIConfig.defUiThemeColor;
    if (uiConfig != null) {
      uiColor = uiConfig.uiThemeColor;
    }

    bool enableCrop = false;
    int width = -1;
    int height = -1;
    if (cropConfig != null) {
      enableCrop = cropConfig.enableCrop;
      width = cropConfig.width <= 0 ? -1 : cropConfig.width;
      height = cropConfig.height <= 0 ? -1 : cropConfig.height;
    }

    final Map<String, dynamic> params = <String, dynamic>{
      'galleryMode': galleryMode.name,
      'showGif': showGif,
      'uiColor': {
        "a": 255,
        "r": uiColor.red,
        "g": uiColor.green,
        "b": uiColor.blue,
        "l": (uiColor.computeLuminance() * 255).toInt()
      },
      'selectCount': selectCount,
      'showCamera': showCamera,
      'enableCrop': enableCrop,
      'width': width,
      'height': height,
      'compressSize': compressSize < 50 ? 50 : compressSize,
      'videoRecordMaxSecond': videoRecordMaxSecond,
      'videoRecordMinSecond': videoRecordMinSecond,
      'videoSelectMaxSecond': videoSelectMaxSecond,
      'videoSelectMinSecond': videoSelectMinSecond,
      'language': language.name,
    };
    final List<dynamic> paths =
    await OXCommon.channel.invokeMethod('getPickerPaths', params);
    List<Media> medias = [];
    paths.forEach((data) {
      Media media = Media();
      media.thumbPath = data["thumbPath"];
      media.path = data["path"];
      if(media.path == media.thumbPath){
        media.galleryMode = GalleryMode.image;
      }else{
        media.galleryMode = GalleryMode.video;
      }
      medias.add(media);
    });
    return medias;
  }

  /// Return information of the selected picture or video
  ///
  /// cameraMimeType  CameraMimeType.photo is a photo, CameraMimeType.video is a video
  ///
  /// cropConfig  Crop configuration (video does not support cropping and compression, this parameter is not available when selecting video)
  ///
  /// compressSize Ignore compression size after selection, will not compress unit KB when the image size is smaller than compressSize
  ///
  /// videoRecordMaxSecond  Maximum video recording time (seconds)
  ///
  /// videoRecordMinSecond  Minimum video recording time (seconds)
  ///

  static Future<Media?> openCamera({
    CameraMimeType cameraMimeType = CameraMimeType.photo,
    CropConfig? cropConfig,
    int compressSize = 500,
    int videoRecordMaxSecond = 120,
    int videoRecordMinSecond = 1,
    Language language = Language.system,
  }) async {

    bool enableCrop = false;
    int width = -1;
    int height = -1;
    if (cropConfig != null) {
      enableCrop = cropConfig.enableCrop;
      width = cropConfig.width <= 0 ? -1 : cropConfig.width;
      height = cropConfig.height <= 0 ? -1 : cropConfig.height;
    }

    Color uiColor = UIConfig.defUiThemeColor;
    final Map<String, dynamic> params = <String, dynamic>{
      'galleryMode': "image",
      'showGif': true,
      'uiColor': {
        "a": 255,
        "r": uiColor.red,
        "g": uiColor.green,
        "b": uiColor.blue,
        "l": (uiColor.computeLuminance() * 255).toInt()
      },
      'selectCount': 1,
      'showCamera': false,
      'enableCrop': enableCrop,
      'width': width,
      'height': height,
      'compressSize': compressSize < 50 ? 50 : compressSize,
      'cameraMimeType': cameraMimeType.name,
      'videoRecordMaxSecond': videoRecordMaxSecond,
      'videoRecordMinSecond': videoRecordMinSecond,
      'language': language.name,
    };
    final List<dynamic>? paths =
    await OXCommon.channel.invokeMethod('getPickerPaths', params);

    if (paths != null && paths.length > 0) {
      Media media = Media();
      media.thumbPath = paths[0]["thumbPath"];
      media.path = paths[0]["path"];
      if(cameraMimeType == CameraMimeType.photo){
        media.galleryMode = GalleryMode.image;
      }else{
        media.galleryMode = GalleryMode.video;
      }
      return media;
    }

    return null;
  }
}

enum GalleryMode {
  image,
  video,
  all,
}

enum CameraMimeType {
  photo,
  video,
}

class Media {
  ///Video thumbnail image path
  String? thumbPath;

  ///Video path or image path
  String? path;
  GalleryMode? galleryMode;

  @override
  String toString() {
    return '( thumbPath = $thumbPath, path = $path, galleryMode = ${galleryMode?.name} )';
  }
}

/// Select image page color configuration
class UIConfig {
  static const Color defUiThemeColor = Color(0xfffefefe);
  Color uiThemeColor;

  /// uiThemeColor
  UIConfig({this.uiThemeColor = defUiThemeColor});
}

///Crop configuration
class CropConfig {

  bool enableCrop = false;

  ///Cropped width ratio
  int width = -1;

  ///Crop height ratio
  int height = -1;

  CropConfig({this.enableCrop = false, this.width = -1, this.height = -1});
}

enum Language {
  system,

  chinese,

  traditional_chinese,

  english,

  japanese,

  france,

  german,

  russian,

  vietnamese,

  korean,

  portuguese,

  spanish,

  arabic,
}