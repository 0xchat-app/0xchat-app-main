// Stub file for flutter_sound on unsupported platforms (Linux/macOS)
// This file provides empty implementations to allow compilation
// when flutter_sound is not available in pubspec.yaml

class FlutterSoundRecorder {
  Future<void> openRecorder() async {}
  Future<void> closeRecorder() async {}
  Future<void> setSubscriptionDuration(Duration duration) async {}
  Future<void> startRecorder({
    String? toFile,
    dynamic codec,
    int? bitRate,
    int? sampleRate,
    dynamic audioSource,
  }) async {}
  Future<void> stopRecorder() async {}
  Stream<dynamic>? onProgress;
}

class FlutterSoundPlayer {
  Future<void> openPlayer() async {}
  Future<void> closePlayer() async {}
  Future<void> stopPlayer() async {}
  Future<void> startPlayer({
    String? fromURI,
    dynamic codec,
    int? sampleRate,
    void Function()? whenFinished,
  }) async {}
  Future<void> setSubscriptionDuration(Duration duration) async {}
  bool get isPlaying => false;
  Stream<dynamic>? onProgress;
  Future<PlayerState> getPlayerState() async => PlayerState.isStopped;
}

enum PlayerState {
  isPlaying,
  isPaused,
  isStopped,
}

enum Codec {
  pcm16WAV,
  aacADTS,
  mp3,
}

enum AudioSource {
  microphone,
}
