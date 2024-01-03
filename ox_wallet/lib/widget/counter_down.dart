import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';

class CounterDown extends StatefulWidget {
  final int second;
  final VoidCallback? onCountDownCompleted;
  const CounterDown({super.key, required this.second, this.onCountDownCompleted});

  @override
  State<CounterDown> createState() => _CounterDownState();
}

class _CounterDownState extends State<CounterDown> {

  Timer? _timer;

  String _remainTime = '';

  @override
  void initState() {
    super.initState();
    _startCountDown(widget.second);
  }

  void _startCountDown(int time){
    if(_timer != null){
      if(_timer!.isActive){
        _timer!.cancel();
        _timer = null;
      }
    }
    if(time <= 0){
      return;
    }

    int countTime = time;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if(countTime <=0){
        _timer?.cancel();
        _timer = null;
        widget.onCountDownCompleted?.call();
        return ;
      }
      countTime--;
      setState(() {
        _remainTime = _countDown(countTime);
      });
    });
  }

  String _countDown(int seconds) {
    int hour = seconds ~/ 3600;
    int minute = seconds % 3600 ~/ 60;
    int second = seconds % 60;

    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _remainTime,
      style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
          color: ThemeColor.color0),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
}
