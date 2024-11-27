import 'dart:async';
import 'dart:io';

import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/encode_utils.dart';
import 'package:ox_common/utils/image_picker_utils.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/utils/uplod_aliyun_utils.dart';
import 'package:ox_common/widgets/common_file_cache_manager.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:uuid/uuid.dart';

class VideoDataManager {
  static final VideoDataManager _instance = VideoDataManager._internal();
  factory VideoDataManager() => _instance;
  static VideoDataManager get shared => _instance;
  VideoDataManager._internal();

  _VideoThumbnailHandler _thumbnailHandler = _VideoThumbnailHandler();

  final int _maxConcurrentTasks = 3;
  final List<_Task<Media?>> _taskQueue = [];
  int _currentTasks = 0;

  Future<Media?> fetchVideoMedia({
    required String videoURL,
    String? encryptedKey,
    String? encryptedNonce,
  }) async {
    final task = _Task<Media?>(
      taskKey: videoURL,
      task: () async {
        Media media = Media()..galleryMode = GalleryMode.video;
        final fileManager = OXFileCacheManager.get(
          encryptKey: encryptedKey,
          encryptNonce: encryptedNonce,
        );

        final cacheFile = await fileManager.getFileFromCache(videoURL);
        if (cacheFile != null) {
          media.path = cacheFile.file.path;
        } else{
          final cacheManager = OXFileCacheManager.get(
            encryptKey: encryptedKey,
            encryptNonce: encryptedNonce,
          );

          final tempFile = (await cacheManager.downloadFile(videoURL)).file;
          if (encryptedKey != null) {
            await DecryptedCacheManager.decryptFile(
              tempFile,
              encryptedKey,
              decryptedFile: tempFile,
              nonce: encryptedNonce,
            );
          }

          final cacheFile = await cacheManager.putFile(
            videoURL,
            tempFile.readAsBytesSync(),
            fileExtension: tempFile.path.getFileExtension(),
          );

          media.path = cacheFile.path;
        }

        final videoFile = File(media.path ?? '');
        if (!videoFile.existsSync()) {
          return null;
        }

        final thumbnailFile = await _thumbnailHandler.fetchVideoThumbnail(
          videoURL: videoURL,
          videoFilePath: videoFile.path,
        );
        media.thumbPath = thumbnailFile?.path;

        return media;
      },
      completer: Completer<Media?>(),
    );

    return _addTask(task);
  }

  Future<File?> fetchVideoThumbnailWithLocalFile({
    required String videoFilePath,
    String cacheKey = '',
  }) {
    return _thumbnailHandler.fetchVideoThumbnailWithLocalFile(
      videoFilePath: videoFilePath,
      cacheKey: cacheKey,
    );
  }

  Future<File> putThumbnailToCacheWithURL({
    required String videoURL,
    required String thumbnailPath,
  }) {
    return _thumbnailHandler.putThumbnailToCacheWithURL(
      videoURL: videoURL,
      thumbnailPath: thumbnailPath,
    );
  }

  Future<Media?> _addTask<T>(_Task<Media?> task) async {
    final queue = [..._taskQueue];
    final existTask = queue.where((e) => e.taskKey == task.taskKey).firstOrNull;

    if (existTask != null) return existTask.completer.future;

    _taskQueue.add(task);
    _executeNextTask();
    return task.completer.future;
  }

  void _executeNextTask() {
    if (_currentTasks >= _maxConcurrentTasks || _taskQueue.isEmpty) {
      return;
    }

    try {
      final task = _taskQueue.firstWhere((task) => !task.isExecuting);
      if (task.isCancel) {
        _taskQueue.remove(task);
        _executeNextTask();
        return;
      }

      task.isExecuting = true;
      _currentTasks++;

      task.task().then((result) {
        if (task.isCancel) return;
        task.completer.complete(result);
      }).catchError((error) {
        if (task.isCancel) return;
        task.completer.completeError(error);
      }).whenComplete(() {
        _taskQueue.remove(task);
        _currentTasks--;
        _executeNextTask();
      });
    } catch (e) { return; }
  }

  void cancelTask(String taskKey) {
    final list = [..._taskQueue];
    final task = list.where((e) => e.taskKey == taskKey).firstOrNull;
    task?.isCancel = true;
  }
}

class _VideoThumbnailHandler {
  final int _maxConcurrentTasks = 1;
  final List<_Task<File?>> _taskQueue = [];
  int _currentTasks = 0;

  Future<File?> fetchVideoThumbnail({
    required String videoURL,
    required String videoFilePath,
  }) async {
    final thumbnailURL = _thumbnailSnapshotURL(videoURL);
    final task = _Task(
      taskKey: thumbnailURL,
      task: () async {
        final cacheManager = OXFileCacheManager.get();

        // Cache
        final thumbnailCacheFile = (await cacheManager.getFileFromCache(thumbnailURL))?.file;
        if (thumbnailCacheFile != null && thumbnailCacheFile.existsSync()) return thumbnailCacheFile;

        // New Create
        final videoFile = File(videoFilePath);
        if (!videoFile.existsSync()) return null;

        final tempFile = await cacheManager.store.fileSystem.createFile(
          '${const Uuid().v1()}.jpg',
        );
        tempFile.createSync(recursive: true);

        final thumbnailFilePath = await VideoThumbnail.thumbnailFile(
          video: videoFilePath,
          thumbnailPath: tempFile.path,
          imageFormat: ImageFormat.JPEG,
          maxWidth: (Adapt.screenW * Adapt.devicePixelRatio).toInt(),
          quality: 100,
        );

        if (thumbnailFilePath == null) return null;

        final cacheFile = await cacheManager.putFile(
          thumbnailURL,
          tempFile.readAsBytesSync(),
          fileExtension: tempFile.path.getFileExtension(),
        );
        tempFile.delete();
        return cacheFile;
      },
      completer: Completer<File>(),
    );

    return _addTask(task);
  }

  Future<File?> fetchVideoThumbnailWithLocalFile({
    required String videoFilePath,
    String cacheKey = '',
  }) async {
    final task = _Task(
      taskKey: videoFilePath,
      task: () async {
        final videoFile = File(videoFilePath);
        if (!videoFile.existsSync()) return null;

        final fileId = cacheKey.isNotEmpty ? cacheKey : await EncodeUtils.generatePartialFileMd5(videoFile);
        final cacheManager = OXFileCacheManager.get();

        // Cache
        final thumbnailCacheFile = (await cacheManager.getFileFromCache(fileId))?.file;
        if (thumbnailCacheFile != null && thumbnailCacheFile.existsSync()) return thumbnailCacheFile;

        // New Create
        if (!videoFile.existsSync()) return null;

        final tempFile = await cacheManager.store.fileSystem.createFile(
          '${const Uuid().v1()}.jpg',
        );
        tempFile.createSync(recursive: true);

        final thumbnailFilePath = await VideoThumbnail.thumbnailFile(
          video: videoFilePath,
          thumbnailPath: tempFile.path,
          imageFormat: ImageFormat.JPEG,
          maxWidth: (Adapt.screenW * Adapt.devicePixelRatio).toInt(),
          quality: 100,
        );

        if (thumbnailFilePath == null) return null;

        final cacheFile = await cacheManager.putFile(
          fileId,
          tempFile.readAsBytesSync(),
          fileExtension: tempFile.path.getFileExtension(),
        );
        tempFile.delete();
        return cacheFile;
      },
      completer: Completer<File>(),
    );

    return _addTask(task);
  }

  Future<File> putThumbnailToCacheWithURL({
    required String videoURL,
    required String thumbnailPath,
  }) async {
    final thumbnailURL = _thumbnailSnapshotURL(videoURL);
    final thumbnailFile = File(thumbnailPath);
    return OXFileCacheManager.get().putFile(
      thumbnailURL,
      thumbnailFile.readAsBytesSync(),
      fileExtension: thumbnailPath.getFileExtension(),
    );
  }

  Future<File?> _addTask(_Task<File?> task) async {
    final queue = [..._taskQueue];
    final existTask = queue.where((e) => e.taskKey == task.taskKey).firstOrNull;

    if (existTask != null) return existTask.completer.future;

    _taskQueue.add(task);
    _executeNextTask();
    return task.completer.future;
  }

  void _executeNextTask() {
    if (_currentTasks >= _maxConcurrentTasks || _taskQueue.isEmpty) {
      return;
    }

    try {
      final task = _taskQueue.firstWhere((task) => !task.isExecuting);
      if (task.isCancel) {
        _taskQueue.remove(task);
        _executeNextTask();
        return;
      }

      task.isExecuting = true;
      _currentTasks++;

      task.task().then((result) {
        if (task.isCancel) return;
        task.completer.complete(result);
      }).catchError((error) {
        if (task.isCancel) return;
        task.completer.completeError(error);
      }).whenComplete(() {
        _taskQueue.remove(task);
        _currentTasks--;
        _executeNextTask();
      });
    } catch (e) { return; }
  }

  void cancelTask(String taskKey) {
    final list = [..._taskQueue];
    final task = list.where((e) => e.taskKey == taskKey).firstOrNull;
    task?.isCancel = true;
  }

  static String _thumbnailSnapshotURL(String videoURL) {
    if (UplodAliyun.isAliOSSUrl(videoURL)) {
      return UplodAliyun.getSnapshot(videoURL);
    } else {
      return '$videoURL\_oxchatThumbnailSnapshot';
    }
  }
}

class _Task<T> {
  final String taskKey;
  final Future<T> Function() task;
  final Completer<T> completer;
  bool isExecuting = false;
  bool isCancel = false;

  _Task({
    required this.taskKey,
    required this.task,
    required this.completer,
  });
}
