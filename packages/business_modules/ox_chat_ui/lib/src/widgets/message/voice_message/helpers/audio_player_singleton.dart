import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:ox_common/utils/string_utils.dart';

// class AudioPlayerSingleton {
//   static final AudioPlayerSingleton _singleton = AudioPlayerSingleton._internal();
//   AudioPlayer? _audioPlayer;
//   String? _currentPlayingUrl;
//   Function()? onRestore;
//
//   factory AudioPlayerSingleton() {
//     return _singleton;
//   }
//
//   AudioPlayerSingleton._internal() {
//     if (_audioPlayer == null) {
//       _audioPlayer = AudioPlayer();
//       _currentPlayingUrl = '';
//       audioPlayer.onPlayerStateChanged.listen((playerState) {
//         if (playerState == PlayerState.completed) {
//             // _currentPlayingUrl = '';
//         }
//       });
//     }
//   }
//
//   Future<void> play(String url) async {
//     if (_currentPlayingUrl != null && _currentPlayingUrl != url) {
//       if(onRestore != null){
//         onRestore!();
//       }
//       await stop();
//     }
//     try {
//       _currentPlayingUrl = url;
//       if (RegExp(r'https?:\/\/').hasMatch(url)) {
//         await audioPlayer.play(UrlSource(url));
//       } else {
//         await audioPlayer.play(DeviceFileSource('file://$url'));
//       }
//     } catch (e) {
//       print('Error playing audio: $e');
//     }
//   }
//
//   Future<void> stop() async {
//     try {
//       await audioPlayer.stop();
//       // _currentPlayingUrl = '';
//     } catch (e) {
//       print('Error stopping audio: $e');
//     }
//   }
//
//   AudioPlayer get audioPlayer => audioPlayer;
// }
//

 typedef AudioRestoreCallback = void Function(String? url);

 class AudioPlayerSingleton {
   static final AudioPlayerSingleton _singleton = AudioPlayerSingleton._internal();
   final AudioPlayer _audioPlayer = AudioPlayer();
   String? _currentPlayingUrl;
   AudioRestoreCallback? onRestore;

   /// key: play URL
   Map<String, VoidCallback> stopCallbackMap = {};

   factory AudioPlayerSingleton() => _singleton;

   AudioPlayerSingleton._internal() {
     _currentPlayingUrl = '';
     audioPlayer.onPlayerStateChanged.listen((playerState) {
       // When the voice message playback is completed, set the currently playing URL to null
       if (playerState == PlayerState.completed) {
         _currentPlayingUrl = '';
       }
     });
   }

   /// Returns null on success, or an error message string on failure.
   Future<String?> play(String url, AudioRestoreCallback stopCallback) async {
     try {
       if (_currentPlayingUrl != null && _currentPlayingUrl != url) {
         final restoreCallback = onRestore;
         if(restoreCallback != null){
           restoreCallback(_currentPlayingUrl);
         }
         await stop();
       }

       if (audioPlayer.state == PlayerState.playing) {
         await stop();
       }

       _currentPlayingUrl = url;

       if (url.isRemoteURL) {
         await audioPlayer.play(UrlSource(url));
       } else {
         await audioPlayer.play(DeviceFileSource('file://$url'));
       }
       onRestore = stopCallback;
       return null;
     } catch (e) {
       _currentPlayingUrl = '';
       print('Error playing audio: $e');
       return e.toString();
     }
   }

   Future<void> stop() async {
     try {
       await audioPlayer.stop();
       _currentPlayingUrl = '';
     } catch (e) {
       print('Error stopping audio: $e');
     }
   }

   String? getCurrentPlayingUrl() => _currentPlayingUrl;

   AudioPlayer get audioPlayer => _audioPlayer;
 }

