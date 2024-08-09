
import 'dart:io';

import 'package:ox_common/utils/adapt.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:uuid/uuid.dart';
import 'package:ox_common/utils/uplod_aliyun_utils.dart';
import 'package:ox_common/widgets/common_file_cache_manager.dart';

class OXVideoUtils {

  static Future<File?> getVideoThumbnailImage({
    required videoURL,
  }) async {

    final cacheManager = OXFileCacheManager.get();
    final thumbnailURL = _thumbnailSnapshotURL(videoURL);
    File? thumbnailImageFile;

    if (UplodAliyun.isAliOSSUrl(videoURL)) {
      try {
        thumbnailImageFile = await cacheManager.getSingleFile(thumbnailURL);
      } catch (_) { }
    } else {
      thumbnailImageFile = (await cacheManager.getFileFromCache(thumbnailURL))?.file;
    }

    if (thumbnailImageFile != null) return thumbnailImageFile;

    final file = await cacheManager.store.fileSystem.createFile(
      '${const Uuid().v1()}.jpg',
    );
    file.createSync(recursive: true);

    final filePath = await VideoThumbnail.thumbnailFile(
      video: videoURL,
      thumbnailPath: file.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: (400 * Adapt.devicePixelRatio).toInt(),
      quality: 100,
    );

    if (filePath == null) return null;

    thumbnailImageFile = File(filePath);
    thumbnailImageFile.readAsBytes().then((bytes) {
      cacheManager.putFile(thumbnailURL, bytes);
    });
    return thumbnailImageFile;
  }

  static String _thumbnailSnapshotURL(String videoURL) {
    if (UplodAliyun.isAliOSSUrl(videoURL)) {
      return UplodAliyun.getSnapshot(videoURL);
    } else {
      return '$videoURL/oxchatThumbnailSnapshot';
    }
  }
}