// Stub implementation for FlutterSoundRecorder

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
