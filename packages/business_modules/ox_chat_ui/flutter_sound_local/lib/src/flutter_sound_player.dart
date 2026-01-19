// Stub implementation for FlutterSoundPlayer

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
