import 'package:flutter/cupertino.dart';
class FadeRouteCustom<T> extends PageRouteBuilder<T> {
  final Widget page;
  final int milliseconds;

  FadeRouteCustom({required this.page,this.milliseconds = 500})
      : super(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      });

  @override
  Duration get transitionDuration => Duration(milliseconds: milliseconds);
}
