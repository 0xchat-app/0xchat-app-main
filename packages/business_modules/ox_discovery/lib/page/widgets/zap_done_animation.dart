import 'package:flutter/material.dart';

class ZapDoneAnimation extends StatefulWidget {
  final AnimationController controller;
  final Widget child;

  const ZapDoneAnimation({super.key, required this.controller, required this.child});

  @override
  State<ZapDoneAnimation> createState() => _ZapDoneAnimationState();
}

class _ZapDoneAnimationState extends State<ZapDoneAnimation> {
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -5.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -5.0, end: 5.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 5.0, end: -5.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -5.0, end: 5.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 5.0, end: 0.0), weight: 1),
    ]).animate(widget.controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0,_shakeAnimation.value),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
