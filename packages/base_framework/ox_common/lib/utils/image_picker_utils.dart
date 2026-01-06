import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:ox_common/ox_common.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_localizable/ox_localizable.dart';
// Android only imports
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:path_provider/path_provider.dart';

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
    int selectCount = 9,
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
    // iOS uses native method channel, Android uses wechat_assets_picker
    if (Platform.isIOS) {
      return await _pickerPathsIOS(
        galleryMode: galleryMode,
        uiConfig: uiConfig,
        selectCount: selectCount,
        showCamera: showCamera,
        showGif: showGif,
        cropConfig: cropConfig,
        compressSize: compressSize,
        videoRecordMaxSecond: videoRecordMaxSecond,
        videoRecordMinSecond: videoRecordMinSecond,
        videoSelectMaxSecond: videoSelectMaxSecond,
        videoSelectMinSecond: videoSelectMinSecond,
        language: language,
      );
    } else {
      return await _pickerPathsAndroid(
        galleryMode: galleryMode,
        uiConfig: uiConfig,
        selectCount: selectCount,
        showCamera: showCamera,
        showGif: showGif,
        cropConfig: cropConfig,
        compressSize: compressSize,
        videoRecordMaxSecond: videoRecordMaxSecond,
        videoRecordMinSecond: videoRecordMinSecond,
        videoSelectMaxSecond: videoSelectMaxSecond,
        videoSelectMinSecond: videoSelectMinSecond,
        language: language,
      );
    }
  }

  /// iOS implementation using native method channel
  static Future<List<Media>> _pickerPathsIOS({
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
      if (media.path == media.thumbPath) {
        media.galleryMode = GalleryMode.image;
      } else {
        media.galleryMode = GalleryMode.video;
      }
      medias.add(media);
    });
    return medias;
  }

  /// Android implementation using wechat_assets_picker
  static Future<List<Media>> _pickerPathsAndroid({
    GalleryMode galleryMode = GalleryMode.image,
    UIConfig? uiConfig,
    int selectCount = 9,
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
    // Request permission
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (!ps.hasAccess) {
      return [];
    }

    // Determine request type based on galleryMode
    RequestType requestType;
    switch (galleryMode) {
      case GalleryMode.image:
        requestType = RequestType.image;
        break;
      case GalleryMode.video:
        requestType = RequestType.video;
        break;
      case GalleryMode.all:
        requestType = RequestType.common;
        break;
    }

    // Build filter options
    final FilterOptionGroup filterOptionGroup = FilterOptionGroup(
      imageOption: FilterOption(
        sizeConstraint: SizeConstraint(ignoreSize: true),
      ),
      videoOption: FilterOption(
        durationConstraint: DurationConstraint(
          min: Duration(seconds: videoSelectMinSecond),
          max: Duration(seconds: videoSelectMaxSecond),
        ),
      ),
    );

    // Set confirm button color based on platform
    // Android: theme purple
    final Color confirmButtonColor = ThemeColor.purple2; // Theme purple color

    // Create ThemeData and customize buttonTheme
    final ThemeData pickerTheme = ThemeData.dark().copyWith(
      colorScheme: ColorScheme.dark(
        primary: Colors.black,
        secondary: confirmButtonColor,
      ),
    );

    // Get text delegate based on current app language
    AssetPickerTextDelegate? textDelegate;
    if (language == Language.system) {
      // Use current app language setting
      final LocaleType currentLocale = Localized.getCurrentLanguage();
      textDelegate = _getTextDelegateFromLocaleType(currentLocale);
    } else {
      // Use specified language
      textDelegate = _getTextDelegateFromLanguage(language);
    }

    // Configure picker config
    final AssetPickerConfig pickerConfig = AssetPickerConfig(
      selectedAssets: <AssetEntity>[],
      maxAssets: selectCount,
      requestType: requestType,
      filterOptions: filterOptionGroup,
      pickerTheme: pickerTheme,
      textDelegate: textDelegate,
      pageSize: 320,
      gridThumbnailSize: const ThumbnailSize(80, 80),
      previewThumbnailSize: const ThumbnailSize(150, 150),
      specialItemPosition: showCamera ? SpecialItemPosition.prepend : SpecialItemPosition.none,
    );

    // Show picker and get selected assets
    final List<AssetEntity>? selectedAssets = await AssetPicker.pickAssets(
      OXNavigator.navigatorKey.currentContext!,
      pickerConfig: pickerConfig,
    );

    if (selectedAssets == null || selectedAssets.isEmpty) {
      return [];
    }

    // Convert AssetEntity to Media
    List<Media> medias = [];
    for (AssetEntity asset in selectedAssets) {
      Media media = await _assetEntityToMedia(asset, compressSize);
      medias.add(media);
    }

    return medias;
  }

  /// Convert AssetEntity to Media
  static Future<Media> _assetEntityToMedia(AssetEntity asset, int compressSize) async {
    Media media = Media();
    
    if (asset.type == AssetType.image) {
      media.galleryMode = GalleryMode.image;
      
      // Get image file
      File? file = await asset.file;
      if (file == null) {
        return media;
      }
      
      // Check if compression is needed
      int fileSize = await file.length();
      int compressSizeBytes = compressSize * 1024; // Convert KB to bytes
      
      // Check if it's a GIF or WebP by file extension
      // These formats should not be compressed to preserve their original format
      bool isGif = file.path.toLowerCase().endsWith('.gif');
      bool isWebP = file.path.toLowerCase().endsWith('.webp');
      
      if (fileSize > compressSizeBytes && !isGif && !isWebP) {
        // Compress image
        Uint8List? imageData = await asset.originBytes;
        if (imageData != null) {
          // Get temporary directory
          final Directory tempDir = await getTemporaryDirectory();
          final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
          final File compressedFile = File('${tempDir.path}/$fileName');
          
          // Write compressed image
          await compressedFile.writeAsBytes(imageData);
          
          // TODO: Implement actual compression logic if needed
          // For now, we just use the original file
          media.path = compressedFile.path;
          media.thumbPath = compressedFile.path;
        } else {
          media.path = file.path;
          media.thumbPath = file.path;
        }
      } else {
        media.path = file.path;
        media.thumbPath = file.path;
      }
    } else if (asset.type == AssetType.video) {
      media.galleryMode = GalleryMode.video;
      
      // Get video file
      File? file = await asset.file;
      if (file != null) {
        media.path = file.path;
      }
      
      // Get video thumbnail
      Uint8List? thumbData = await asset.thumbnailDataWithSize(
        const ThumbnailSize(200, 200),
      );
      if (thumbData != null) {
        final Directory tempDir = await getTemporaryDirectory();
        final String thumbFileName = 'thumb_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final File thumbFile = File('${tempDir.path}/$thumbFileName');
        await thumbFile.writeAsBytes(thumbData);
        media.thumbPath = thumbFile.path;
      }
    }
    
    return media;
  }

  /// Get text delegate from LocaleType
  static AssetPickerTextDelegate _getTextDelegateFromLocaleType(LocaleType localeType) {
    // Map LocaleType to wechat_assets_picker text delegate
    // Default AssetPickerTextDelegate() is Chinese (zh)
    switch (localeType) {
      case LocaleType.zh:
        return const AssetPickerTextDelegate(); // Default is Chinese
      case LocaleType.zh_tw:
        return const AssetPickerTextDelegate(); // Use Chinese for traditional Chinese too
      case LocaleType.en:
        return const EnglishAssetPickerTextDelegate();
      case LocaleType.ja:
        return const JapaneseAssetPickerTextDelegate();
      case LocaleType.fr:
        return const FrenchAssetPickerTextDelegate();
      case LocaleType.de:
        return const GermanAssetPickerTextDelegate();
      case LocaleType.ru:
        return const RussianAssetPickerTextDelegate();
      case LocaleType.vi:
        return const VietnameseAssetPickerTextDelegate();
      case LocaleType.ko:
        return const KoreanAssetPickerTextDelegate();
      case LocaleType.ar:
        return const ArabicAssetPickerTextDelegate();
      default:
        // For other languages not supported, use English
        return const EnglishAssetPickerTextDelegate();
    }
  }

  /// Get text delegate from Language enum
  static AssetPickerTextDelegate _getTextDelegateFromLanguage(Language language) {
    LocaleType localeType;
    switch (language) {
      case Language.chinese:
        localeType = LocaleType.zh;
        break;
      case Language.traditional_chinese:
        localeType = LocaleType.zh_tw;
        break;
      case Language.english:
        localeType = LocaleType.en;
        break;
      case Language.japanese:
        localeType = LocaleType.ja;
        break;
      case Language.france:
        localeType = LocaleType.fr;
        break;
      case Language.german:
        localeType = LocaleType.de;
        break;
      case Language.russian:
        localeType = LocaleType.ru;
        break;
      case Language.vietnamese:
        localeType = LocaleType.vi;
        break;
      case Language.korean:
        localeType = LocaleType.ko;
        break;
      case Language.portuguese:
        localeType = LocaleType.pt;
        break;
      case Language.spanish:
        localeType = LocaleType.es;
        break;
      case Language.arabic:
        localeType = LocaleType.ar;
        break;
      default:
        localeType = LocaleType.en;
    }
    return _getTextDelegateFromLocaleType(localeType);
  }

  /// Return information of the selected picture or video
  ///
  /// cameraMimeType  CameraMimeType.photo is a photo, CameraMimeType.video is a video
  ///
  /// cropConfig  Crop configuration (video does not support cropping and compression, this parameter is not available when selecting video)
  ///
  /// compressSize Ignore compression size after selection, will not compress unit KB when the image size is smaller than compressSize

  static Future<Media?> openCamera({
    CameraMimeType cameraMimeType = CameraMimeType.photo,
    CropConfig? cropConfig,
    int compressSize = 500,
    int videoRecordMaxSecond = 120,
    int videoRecordMinSecond = 1,
    Language language = Language.system,
  }) async {
    // For camera functionality, we still use the native method channel
    // as wechat_assets_picker doesn't provide direct camera access
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
