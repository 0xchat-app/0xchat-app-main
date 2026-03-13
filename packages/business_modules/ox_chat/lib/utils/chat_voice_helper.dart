import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/widgets/common_file_cache_manager.dart';

class ChatVoiceMessageHelper {
  static const int _maxCacheEntries = 200;
  static const int _maxRetries = 5;

  static final Map<String, Duration> durationCache = {};

  // Deduplicates concurrent download+probe calls for the same URI so that
  // multiple visible instances of the same audio message don't each spawn
  // independent network requests.
  static final Map<String, Future<(File, Duration?)>> _inFlight = {};

  /// Probes the duration of a local or remote audio file.
  /// The [AudioPlayer] is always disposed after use to prevent resource leaks.
  static Future<Duration?> getAudioDuration(String uri) async {
    final cache = durationCache[uri];
    if (cache != null && cache != Duration.zero) return cache;

    final player = AudioPlayer();
    try {
      await player.setSource(
          uri.isRemoteURL ? UrlSource(uri) : DeviceFileSource(uri));
      final duration = await player.getDuration();
      if (duration != null && duration != Duration.zero) {
        _putDurationCache(uri, duration);
      }
      return duration;
    } finally {
      player.dispose();
    }
  }

  static void _putDurationCache(String key, Duration value) {
    // Evict oldest entry when cache is full (insertion-order eviction).
    if (durationCache.length >= _maxCacheEntries) {
      durationCache.remove(durationCache.keys.first);
    }
    durationCache[key] = value;
  }

  /// Downloads the audio file for [message] (with exponential-backoff retries
  /// on network failure) and returns its [File] + [Duration].
  /// Concurrent calls for the same URI share a single in-flight [Future].
  static Future<(File audioFile, Duration? duration)> populateMessageWithAudioDetails({
    required ChatSessionModelISAR session,
    required types.AudioMessage message,
  }) {
    final uri = message.uri;
    if (_inFlight.containsKey(uri)) return _inFlight[uri]!;

    final future = _doPopulate(message);
    _inFlight[uri] = future;
    future.whenComplete(() => _inFlight.remove(uri));
    return future;
  }

  static Future<(File audioFile, Duration? duration)> _doPopulate(
    types.AudioMessage message,
  ) async {
    final uri = message.uri;
    final urlExtension = uri.split('.').last;
    final audioManager = OXFileCacheManager.get(
      encryptKey: message.decryptKey,
      encryptNonce: message.decryptNonce,
    );

    File sourceFile;
    final cacheFile =
        message.audioFile ?? (await audioManager.getFileFromCache(uri))?.file;

    if (cacheFile != null) {
      sourceFile = cacheFile;
    } else {
      // Retry the download with exponential backoff: 2s, 4s, 8s, 16s, 32s.
      Exception? lastError;
      File? tempFile;
      for (int attempt = 0; attempt < _maxRetries; attempt++) {
        if (attempt > 0) {
          await Future.delayed(Duration(seconds: 2 << (attempt - 1)));
        }
        try {
          tempFile = await audioManager.getSingleFile(uri);
          break;
        } catch (e) {
          lastError = e is Exception ? e : Exception(e.toString());
        }
      }
      if (tempFile == null) {
        throw lastError ?? Exception('Failed to download audio: $uri');
      }

      String newExtension = tempFile.path.split('.').last;
      final withoutExt = tempFile.path.endsWith('.$newExtension')
          ? tempFile.path.substring(0, tempFile.path.length - newExtension.length - 1)
          : tempFile.path;
      String newPath = '$withoutExt.$urlExtension';
      final newDir = Directory(newPath.substring(0, newPath.lastIndexOf('/')));
      if (!newDir.existsSync()) await newDir.create(recursive: true);
      tempFile = await tempFile.rename(newPath);

      sourceFile = await audioManager.putFile(
        uri,
        tempFile.readAsBytesSync(),
        fileExtension: tempFile.path.getFileExtension(),
      );

      tempFile.delete();
    }

    final duration = await getAudioDuration(sourceFile.path);
    return (sourceFile, duration);
  }
}
