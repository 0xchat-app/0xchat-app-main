
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
    String extension = message.uri.split('.').last;
    final audioManager = OXFileCacheManager.get(encryptKey: message.decryptKey);
    final cacheFile = await audioManager.getFileFromCache(message.uri);
    if (cacheFile != null) {
       sourceFile = cacheFile.file;
    }
    else{
      sourceFile = await audioManager.getSingleFile(message.uri);
      if (message.fileEncryptionType == types.EncryptionType.encrypted &&
          message.decryptKey != null) {
        sourceFile = await DecryptedCacheManager.decryptFile(sourceFile, message.decryptKey!);
      }
    }
    String newPath = sourceFile.path.replaceAll('.bin', '.$extension');
    sourceFile = await sourceFile.rename(newPath);
    final duration = await getAudioDuration(sourceFile.path);
    return (sourceFile, duration);
  }
}