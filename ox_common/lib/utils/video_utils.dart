
import 'dart:async';
import 'dart:io';

import 'package:ox_common/log_util.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/encode_utils.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:uuid/uuid.dart';
import 'package:ox_common/utils/uplod_aliyun_utils.dart';
import 'package:ox_common/widgets/common_file_cache_manager.dart';

class OXVideoUtils {

  static Map<String, File> _thumbnailFileCache = <String, File>{};

  static File? getVideoThumbnailImageFromMem({
    String? videoURL,
    String? cacheKey,
  }) {
    if (videoURL != null) {
      cacheKey ??= _thumbnailSnapshotURL(videoURL);
    }
    if (cacheKey == null) {
      LogUtil.e('Both videoURL and cacheKey are null');
      return null;
    }

    final file = _thumbnailFileCache[cacheKey];
    if (file != null && !file.existsSync()) return null;

    return file;
  }

  static void putVideoThumbnailImageToMem({
    String? videoURL,
    String? cacheKey,
    File? file,
  }) {
    if (videoURL != null) {
      cacheKey ??= _thumbnailSnapshotURL(videoURL);
    }
    if (cacheKey == null) {
      LogUtil.e('Both videoURL and cacheKey are null');
      return null;
    }

    if (file != null && file.existsSync()) {
      _thumbnailFileCache[cacheKey] = file;
    } else {
      _thumbnailFileCache.remove(cacheKey);
    }
  }

  static Future<File?> getVideoThumbnailImage({
    required String videoURL,
    bool onlyFromCache = false,
  }) async {
    File? thumbnailImageFile;

    // Memory
    thumbnailImageFile = getVideoThumbnailImageFromMem(videoURL: videoURL);
    if (thumbnailImageFile != null) return thumbnailImageFile;

    // Store
    final cacheManager = OXFileCacheManager.get();
    final thumbnailURL = _thumbnailSnapshotURL(videoURL);
    if (UplodAliyun.isAliOSSUrl(videoURL)) {
      try {
        if (onlyFromCache) {
          thumbnailImageFile = (await cacheManager.getFileFromCache(thumbnailURL))?.file;
        } else {
          thumbnailImageFile = await cacheManager.getSingleFile(thumbnailURL);
        }
      } catch (_) { }
    } else {
      thumbnailImageFile = (await cacheManager.getFileFromCache(thumbnailURL))?.file;
    }

    if (onlyFromCache || thumbnailImageFile != null && thumbnailImageFile.existsSync()) {
      putVideoThumbnailImageToMem(videoURL: videoURL, file: thumbnailImageFile);
      return thumbnailImageFile;
    }

    // New Create
    final file = await cacheManager.store.fileSystem.createFile(
      '${const Uuid().v1()}.jpg',
    );
    file.createSync(recursive: true);

    final filePath = await VideoThumbnail.thumbnailFile(
      video: videoURL,
      thumbnailPath: file.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: (Adapt.screenW * Adapt.devicePixelRatio).toInt(),
      quality: 100,
    );

    if (filePath == null) return null;

    thumbnailImageFile = File(filePath);
    final cacheFile = await _putFileToCache(thumbnailURL, thumbnailImageFile);
    return cacheFile;
  }

  static Future<File?> getVideoThumbnailImageWithFilePath({
    required String videoFilePath,
    String? cacheKey,
    bool onlyFromCache = false,
  }) async {
    File? thumbnailImageFile;

    // Memory
    if (cacheKey != null) {
      thumbnailImageFile = getVideoThumbnailImageFromMem(cacheKey: cacheKey);
      if (thumbnailImageFile != null) return thumbnailImageFile;
    }

    // Store
    final cacheManager = OXFileCacheManager.get();
    cacheKey ??= await EncodeUtils.generatePartialFileMd5(File(videoFilePath));
    thumbnailImageFile = (await cacheManager.getFileFromCache(cacheKey))?.file;

    if (thumbnailImageFile != null && thumbnailImageFile.existsSync()) {
      putVideoThumbnailImageToMem(cacheKey: cacheKey, file: thumbnailImageFile);
    }
    if (onlyFromCache || thumbnailImageFile != null) return thumbnailImageFile;

    // New Create
    final file = await cacheManager.store.fileSystem.createFile(
      '${const Uuid().v1()}.jpg',
    );
    file.createSync(recursive: true);

    String? filePath;
    try {
      filePath = await VideoThumbnail.thumbnailFile(
        video: videoFilePath,
        thumbnailPath: file.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: (Adapt.screenW * Adapt.devicePixelRatio).toInt(),
        quality: 100,
      );
    } catch (e) {
      LogUtil.e(e);
    }

    if (filePath == null || filePath.isEmpty) return null;

    final tempFile = File(filePath);
    final cacheFile = _putFileToCache(cacheKey, tempFile);
    return cacheFile;
  }

  static Future<File> putFileToCacheWithURL(String url, File file) async {
    if (!url.isRemoteURL) throw Exception('url must be remote url');
    final cacheKey = _thumbnailSnapshotURL(url);
    return _putFileToCache(cacheKey, file);
  }

  static Future<File> putFileToCacheWithFileId(String fileId, File file) async {
    final cacheKey = fileId;
    final bytes = file.readAsBytesSync();
    return await OXFileCacheManager.get().putFile(
      cacheKey,
      bytes,
      fileExtension: file.path.getFileExtension(),
    );
  }

  static Future<File> _putFileToCache(String cacheKey, File file) async {
    if (!file.existsSync()) throw Exception('file is not exists');
    // Put on store
    final bytes = file.readAsBytesSync();
    final cacheFile = await OXFileCacheManager.get().putFile(
      cacheKey,
      bytes,
      fileExtension: file.path.getFileExtension(),
    );

    // Replace memory info & Delete origin file
    // final originCacheKey = _thumbnailFileCache.keys.where((key) {
    //   return _thumbnailFileCache[key]?.path == file.path;
    // });
    final updateCacheKey = [
      // ...originCacheKey,
      cacheKey,
    ];
    updateCacheKey.forEach((key) {
      putVideoThumbnailImageToMem(cacheKey: key, file: cacheFile);
    });
    // file.delete();

    return cacheFile;
  }

  static String _thumbnailSnapshotURL(String videoURL) {
    if (UplodAliyun.isAliOSSUrl(videoURL)) {
      return UplodAliyun.getSnapshot(videoURL);
    } else {
      return '$videoURL\_oxchatThumbnailSnapshot';
    }
  }
}