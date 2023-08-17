import 'package:flutter/material.dart';

class LoseFocusWrap extends StatelessWidget {
  final Widget body;

  LoseFocusWrap(this.body);

  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: body,
    );
  }
}
