import 'dart:async';

class ThrottleUtils {
  final Duration delay;
  Timer? _timer;
  bool _hasPending = false;

  ThrottleUtils({required this.delay});

  void call(Function action) {
    if (_timer == null || !_timer!.isActive) {
      action();
      _timer = Timer(delay, () {
        if (_hasPending) {
          action();
          _hasPending = false;
        }
      });
    } else {
      _hasPending = true;
    }
  }
}