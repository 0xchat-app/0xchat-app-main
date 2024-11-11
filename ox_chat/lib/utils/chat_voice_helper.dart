import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/widgets/common_file_cache_manager.dart';

class ChatVoiceMessageHelper {
  static Future<Duration?> getAudioDuration(String uri) async {
    final player = AudioPlayer();
    await player.setSource(uri.isRemoteURL ? UrlSource(uri) : DeviceFileSource(uri));
    return await player.getDuration();
  }

  static Future<(File audioFile, Duration? duration)> populateMessageWithAudioDetails({
    required ChatSessionModelISAR session,
    required types.AudioMessage message,
  }) async {
    File sourceFile;
    final uri = message.uri;
    final urlExtension = uri.split('.').last;
    final audioManager =
        OXFileCacheManager.get(encryptKey: message.decryptKey, encryptNonce: message.decryptNonce);
    final cacheFile = message.audioFile ?? (await audioManager.getFileFromCache(uri))?.file;

    if (cacheFile != null) {
      sourceFile = cacheFile;
    } else {
      final response = await audioManager.downloadFile(uri);

      File tempFile = response.file;
      String newExtension = tempFile.path.split('.').last;
      String newPath = tempFile.path.replaceAll(newExtension, urlExtension);
      tempFile = await tempFile.rename(newPath);

      if (message.fileEncryptionType == types.EncryptionType.encrypted &&
          message.decryptKey != null) {
        final decryptedFile = await DecryptedCacheManager.decryptFile(
          tempFile,
          message.decryptKey!,
          nonce: message.decryptNonce,
        );
        tempFile = decryptedFile;
      }

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
