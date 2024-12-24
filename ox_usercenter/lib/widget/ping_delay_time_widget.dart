import 'dart:async';
import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';

class PingDelayTimeWidget extends StatefulWidget {
  final String host;
  final PingLifecycleController controller;

  const PingDelayTimeWidget({super.key, required this.host, required this.controller});

  @override
  State<PingDelayTimeWidget> createState() => _PingDelayTimeWidgetState();
}

class _PingDelayTimeWidgetState extends State<PingDelayTimeWidget> {

  int _delayTime = 0;
  Timer? _timer;
  final _interval = 5;
  StreamSubscription? _pingSubscription;

  @override
  void initState() {
    super.initState();
    _doPing();
    _startPingTimer();
    widget.controller.isPaused.addListener(_onPausedChanged);
  }

  void _startPingTimer() {
    _timer = Timer.periodic(Duration(seconds: _interval), (_) {
      _doPing();
    });
  }

  void _stopPingTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _stopPingSubscription() {
    _pingSubscription?.cancel();
    _pingSubscription = null;
  }

  _onPausedChanged() {
    if (widget.controller.isPaused.value) {
      _stopPingTimer();
      _stopPingSubscription();
    } else {
      _startPingTimer();
      _doPing();
    }
  }

  void _doPing() {
    _pingSubscription?.cancel();

    final ping = Ping(widget.host, count: 1);
    _pingSubscription = ping.stream.listen(
      (event) {
        int newDelayTime;
        if (event.error != null) {
          newDelayTime = -1;
        } else if (event.response != null) {
          newDelayTime = event.response?.time?.inMilliseconds ?? 0;
        } else {
          return;
        }

        if (newDelayTime != _delayTime) {
          setState(() {
            _delayTime = newDelayTime;
          });
        }
      },
    );
  }

  Color _getPingDelayColor(int pingDelay) {
    if (pingDelay <= 0) {
      return ThemeColor.white;
    } else if (pingDelay <= 300) {
      return ThemeColor.green4;
    } else if (pingDelay <= 500) {
      return ThemeColor.orange;
    } else {
      return ThemeColor.red1;
    }
  }


  @override
  Widget build(BuildContext context) {
    String text = _delayTime > 0 ? '${_delayTime.toString()}ms' : '--';
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.px,
        fontWeight: FontWeight.w400,
        color: _getPingDelayColor(_delayTime),
      ),
    );
  }

  @override
  void dispose() {
    _stopPingTimer();
    _stopPingSubscription();
    widget.controller.isPaused.removeListener(_onPausedChanged);
    super.dispose();
  }
}

class PingLifecycleController {
  final ValueNotifier<bool> isPaused = ValueNotifier(false);
}
