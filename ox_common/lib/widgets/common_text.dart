
import 'package:flutter/material.dart';
import 'package:ox_common/utils/theme_color.dart';

extension OXText on Text {
  static themeText(String text, {TextStyle? style}) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: [
            ThemeColor.gradientMainEnd,
            ThemeColor.gradientMainStart,
          ],
        ).createShader(Offset.zero & bounds.size);
      },
      child: Text(
        text,
        style: style,
      ),
    );
  }
}