import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Returns the platform-specific font family for color emoji rendering.
/// Without this, emojis may render as black/white outline symbols on Linux and some desktops.
String get colorEmojiFontFamily {
  switch (defaultTargetPlatform) {
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      return 'Apple Color Emoji';
    case TargetPlatform.windows:
      return 'Segoe UI Emoji';
    case TargetPlatform.android:
    case TargetPlatform.linux:
    case TargetPlatform.fuchsia:
      return 'Noto Color Emoji';
  }
}

/// TextStyle that uses a color emoji font so emojis render in color instead of outline.
/// Use for EmojiPicker Config.emojiTextStyle and any Text/RichText that displays emoji.
TextStyle emojiTextStyle({
  double? fontSize,
  Color? color,
  FontWeight? fontWeight,
}) {
  return TextStyle(
    fontFamily: colorEmojiFontFamily,
    fontSize: fontSize,
    color: color,
    fontWeight: fontWeight,
  );
}
