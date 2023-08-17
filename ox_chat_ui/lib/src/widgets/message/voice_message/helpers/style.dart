import 'dart:math';

import 'package:flutter/material.dart';

import 'colors.dart';

///
class S {
  ///
  static innerBoxShadow() => [
        BoxShadow(color: Colors.black.withOpacity(.13)),
        BoxShadow(
          color: Colors.grey.shade200.withOpacity(1),
          spreadRadius: -16.0,
          offset: const Offset(0, 30),
          blurRadius: 40.0,
        ),
        BoxShadow(
          color: Colors.grey.shade200,
          spreadRadius: -16.0,
          offset: const Offset(-40, 0),
          blurRadius: 40.0,
        ),
        BoxShadow(
          color: Colors.grey.shade200,
          spreadRadius: -16.0,
          offset: const Offset(40, 0),
          blurRadius: 40.0,
        ),
      ];

  ///
  static radius38(BuildContext context) =>
      min(38, MediaQuery.of(context).size.width * .08);

  ///
  static boxShadow(
    BuildContext context, {
    double opacity = .2,
    Color color = Colors.black87,
  }) =>
      BoxShadow(
        color: color.withOpacity(opacity),
        offset: const Offset(0, 18),
        blurRadius: 31,
        spreadRadius: 4.7,
      );

  ///
  static pinkShadow({Color? shadow}) => [
        BoxShadow(
          color: shadow ?? AppColors.pink300,
          blurRadius: 56,
          spreadRadius: .4,
          offset: const Offset(0, 13),
        )
      ];

  ///
  static double w(Size? s) => s!.width;

  ///
  static double h(Size? s) => s!.height;
}
