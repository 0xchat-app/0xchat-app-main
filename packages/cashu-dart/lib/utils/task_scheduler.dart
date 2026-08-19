
import 'dart:async';
import 'dart:math';

class TaskScheduler {
  final Completer<void> _initCompleter = Completer<void>();
  Future Function() task;
  bool isDispose = false;
  int _taskExecutionCount = 0;

  bool useFixedInterval = false;
  Timer? taskTimer;

  TaskScheduler({required this.task});

  void start() {
    _initCompleter.future.then((_) => _scheduleTask());
  }

  void initComplete() {
    if (!_initCompleter.isCompleted) {
      _initCompleter.complete();
    }
  }

  void dispose() {
    isDispose = true;
  }

  void enableFixedInterval(Duration interval) {
    useFixedInterval = true;
    if (taskTimer != null) {
      taskTimer?.cancel();
    }
    taskTimer = Timer.periodic(interval, (_) {
      if (!useFixedInterval) return ;
      _executeTask();
    });
  }

  void disableFixedInterval() {
    useFixedInterval = false;
    taskTimer?.cancel();
    taskTimer = null;
    start();
  }

  void _scheduleTask() {
    if (isDispose || useFixedInterval) return;

    _taskExecutionCount += 1;
    _executeTask();

    // Calculate delay time
    final fixedIncrement = 10 * _taskExecutionCount;
    final exponentialDelay = pow(2, _taskExecutionCount).toInt();
    final delaySeconds = min(fixedIncrement + exponentialDelay, 3600); // Max 1 hour

    Future.delayed(Duration(seconds: delaySeconds), _scheduleTask);
  }

  void _executeTask() {
    if (isDispose) return;
    task();
  }
}
