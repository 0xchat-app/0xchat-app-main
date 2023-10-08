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

   Future<void> play(String url, AudioRestoreCallback stopCallback) async {
     try {
       if (_currentPlayingUrl != null && _currentPlayingUrl != url) {
         // If the currently playing voice message is not the one to be played, pause the current voice message first
         final restoreCallback = onRestore;
         if(restoreCallback != null){
           restoreCallback(_currentPlayingUrl);
         }
         await stop();
       }

       if (audioPlayer.state == PlayerState.playing) {
         // If there is another audio playing, stop it first
         await stop();
       }

       _currentPlayingUrl = url;

       if (url.isRemoteURL) {
         // If it's a network file, play it directly
         await audioPlayer.play(UrlSource(url));
       } else {
         // If it's a local file, you need to add the path before "file://"
         await audioPlayer.play(DeviceFileSource('file://$url'));
       }
       onRestore = stopCallback;
     } catch (e) {
       print('Error playing audio: $e');
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

