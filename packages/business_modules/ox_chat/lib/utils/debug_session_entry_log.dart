// #region agent log
// Debug instrumentation for session entry lag. Writes NDJSON to workspace .cursor/debug.log.
import 'dart:convert';
import 'dart:io';

void debugSessionEntryLog({
  required String location,
  required String message,
  required String hypothesisId,
  Map<String, dynamic> data = const {},
  String runId = 'run1',
}) {
  try {
    const logPath = '/Users/bear/Desktop/jenkins/.cursor/debug.log';
    final line = jsonEncode({
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'location': location,
      'message': message,
      'data': data,
      'sessionId': 'debug-session',
      'runId': runId,
      'hypothesisId': hypothesisId,
    }) + '\n';
    File(logPath).writeAsStringSync(line, mode: FileMode.append);
  } catch (_) {}
}
// #endregion
