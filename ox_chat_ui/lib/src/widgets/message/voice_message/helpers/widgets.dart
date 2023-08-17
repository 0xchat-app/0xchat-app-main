import 'package:flutter/material.dart';

///
class Widgets {
  ///
  static circle(
    BuildContext context,
    double width,
    Color color, {
    Widget child = const SizedBox(),
  }) =>
      Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        width: width,
        height: width,
        child: child,
      );
}
