
import 'dart:async';
import 'dart:io';

import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/encode_utils.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:uuid/uuid.dart';
import 'package:ox_common/utils/uplod_aliyun_utils.dart';
import 'package:ox_common/widgets/common_file_cache_manager.dart';

class OXVideoUtils {

  static Map<String, File> _thumbnailFileCache = <String, File>{};

  static File? getVideoThumbnailImageFromMem(String videoURL) {
    final thumbnailURL = _thumbnailSnapshotURL(videoURL);
    return _thumbnailFileCache[thumbnailURL];
  }
  static void putVideoThumbnailImageToMem(String videoURL, File? file) {
    final thumbnailURL = _thumbnailSnapshotURL(videoURL);

    if (file != null) {
      _thumbnailFileCache[thumbnailURL] = file;
    } else {
      _thumbnailFileCache.remove(thumbnailURL);
    }
  }

  static Future<File?> getVideoThumbnailImage({
    required String videoURL,
    bool onlyFromCache = false,
  }) async {

    final cacheManager = OXFileCacheManager.get();
    final thumbnailURL = _thumbnailSnapshotURL(videoURL);
    File? thumbnailImageFile;

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

    if (onlyFromCache) return thumbnailImageFile;

    if (thumbnailImageFile != null) {
      putVideoThumbnailImageToMem(videoURL, thumbnailImageFile);
      return thumbnailImageFile;
    }

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
    putVideoThumbnailImageToMem(videoURL, cacheFile);
    return cacheFile;
  }

  static Future<File?> getVideoThumbnailImageWithFilePath({
    required String videoFilePath,
    String? cacheKey,
    bool onlyFromCache = false,
  }) async {
    final cacheManager = OXFileCacheManager.get();
    cacheKey ??= await EncodeUtils.generatePartialFileMd5(File(videoFilePath));
    final thumbnailCache = await cacheManager.getFileFromCache(cacheKey);

    if (onlyFromCache || thumbnailCache != null) return thumbnailCache?.file;

    final file = await cacheManager.store.fileSystem.createFile(
      '${const Uuid().v1()}.jpg',
    );
    file.createSync(recursive: true);

    final filePath = await VideoThumbnail.thumbnailFile(
      video: videoFilePath,
      thumbnailPath: file.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: (Adapt.screenW * Adapt.devicePixelRatio).toInt(),
      quality: 100,
    );

    if (filePath == null) return null;

    final thumbnailImageFile = File(filePath);
    final cacheFile = _putFileToCache(cacheKey, thumbnailImageFile);
    return cacheFile;
  }

  static Future<File> putFileToCacheWithURL(String url, File file) async {
    if (!url.isRemoteURL) throw Exception('url must be remote url');
    final cacheKey = _thumbnailSnapshotURL(url);
    final bytes = file.readAsBytesSync();
    final cacheFile = await OXFileCacheManager.get().putFile(
      cacheKey,
      bytes,
      fileExtension: file.path.getFileExtension(),
    );
    putVideoThumbnailImageToMem(url, cacheFile);
    return cacheFile;
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
    final bytes = file.readAsBytesSync();
    final cacheFile = await OXFileCacheManager.get().putFile(
      cacheKey,
      bytes,
      fileExtension: file.path.getFileExtension(),
    );
    file.deleteSync();
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