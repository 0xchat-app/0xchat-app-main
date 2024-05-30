class OXStopwatch {
  static Stopwatch stopwatch = Stopwatch();

  static start() => stopwatch.start();

  static stop() {
    stopwatch.stop();
    stopwatch.reset();
  }

  static output(String key) {
    print('[$key]，time: ${stopwatch.elapsedMilliseconds} ms');
  }
}