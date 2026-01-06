class OXStopwatch {
  static Stopwatch stopwatch = Stopwatch();
  static String logKey = '';

  static start(String logKey) {
    print('[$logKey]，start');
    OXStopwatch.logKey = logKey;
    stopwatch.start();
  }

  static stop() {
    stopwatch.stop();
    stopwatch.reset();
    OXStopwatch.logKey = '';
  }

  static output([String info = '']) {
    print('[$logKey]${info.isNotEmpty ? '[$info]': ''}，time: ${_formatDuration(stopwatch.elapsedMilliseconds)}');
  }

  static String _formatDuration(int milliseconds) {
    int minutes = milliseconds ~/ 60000;
    int seconds = (milliseconds % 60000) ~/ 1000;
    int remainingMs = milliseconds % 1000;

    String formattedDuration = '';
    if (minutes > 0) {
      formattedDuration += '${minutes}m ';
    }
    if (seconds > 0 || minutes > 0) { // Display seconds even if they are 0 but minutes > 0
      formattedDuration += '${seconds}s ';
    }
    formattedDuration += '${remainingMs}ms';

    return formattedDuration.trim();
  }
}