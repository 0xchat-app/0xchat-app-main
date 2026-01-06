import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';

class HighlightedClickableText extends StatelessWidget {
  final String text;
  final List<String> highlightWords;
  final TextStyle? highlightStyle;
  final TextStyle? unHighlightStyle;
  final Function(String)? onWordTap;

  HighlightedClickableText({
    super.key,
    required this.text,
    required this.highlightWords,
    this.highlightStyle,
    this.unHighlightStyle,
    this.onWordTap,
  });

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textSpans = [];
    int currentIndex = 0;

    for (int i = 0; i < highlightWords.length; i++) {
      String word = highlightWords[i];
      int index = text.indexOf(word, currentIndex);

      if (index != -1) {
        if (index > currentIndex) {
          textSpans.add(
            TextSpan(
              text: text.substring(currentIndex, index),
              style: unHighlightStyle ?? _defaultStyle(color: ThemeColor.color100),
            ),
          );
        }

        textSpans.add(
          TextSpan(
            text: word,
            style: highlightStyle ?? _defaultStyle(color: ThemeColor.color0),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                if (onWordTap != null) {
                  onWordTap!(word);
                }
              },
          ),
        );

        currentIndex = index + word.length;
      }
    }

    if (currentIndex < text.length) {
      textSpans.add(
        TextSpan(
          text: text.substring(currentIndex),
          style: unHighlightStyle ?? _defaultStyle(color: ThemeColor.color100),
        ),
      );
    }

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          children: textSpans,
          style: TextStyle(height: Adapt.px(22) / Adapt.px(16))),
    );
  }

  TextStyle _defaultStyle({required Color color}) {
    return TextStyle(
      color: color,
      fontSize: Adapt.px(16),
      fontWeight: FontWeight.w400,
    );
  }
}
