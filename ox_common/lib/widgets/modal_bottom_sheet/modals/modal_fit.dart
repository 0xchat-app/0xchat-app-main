import 'package:flutter/material.dart';

import '../../../utils/theme_color.dart';

class ModalFit extends StatelessWidget {
  final Widget? child;
  const ModalFit({required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ThemeColor.X1D1D1D,
        child: SafeArea(
      top: false,
      child: child ?? Container(),
    ));
  }
}
