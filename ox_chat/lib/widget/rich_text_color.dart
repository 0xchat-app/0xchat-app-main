import 'package:flutter/cupertino.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';

///Title: rich_text_color
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/8/24 14:45
class RichTextColor extends StatelessWidget {
  final String text;
  final List<String> highlightTextList;
  final int maxLines;

  RichTextColor({
    Key? key,
    required this.text,
    required this.highlightTextList,
    required this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return getHighlightText(text, highlightTextList, maxLines: maxLines);
  }

  Widget getHighlightText(String mainText, List<String> highlightTextList, {int? maxLines = 1}) {
    final normalTextStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: ThemeColor.color120,
      height: 1.5
    );
    final highlightTextStyle = normalTextStyle.copyWith(
      color: ThemeColor.color10,
    );

    List<InlineSpan> spans = [];

    int lastEnd = 0;
    while (lastEnd < mainText.length) {
      int firstOccurrenceIndex = mainText.length;
      String? closestHighlight;

      for (var highlight in highlightTextList) {
        int occurrenceIndex = mainText.indexOf(highlight, lastEnd);
        if (occurrenceIndex != -1 && occurrenceIndex < firstOccurrenceIndex) {
          firstOccurrenceIndex = occurrenceIndex;
          closestHighlight = highlight;
        }
      }

      if (closestHighlight != null) {
        spans.add(TextSpan(
          text: mainText.substring(lastEnd, firstOccurrenceIndex),
          style: normalTextStyle,
        ));
        spans.add(TextSpan(
          text: closestHighlight,
          style: highlightTextStyle,
        ));
        lastEnd = firstOccurrenceIndex + closestHighlight.length;
      } else {
        spans.add(TextSpan(
          text: mainText.substring(lastEnd),
          style: normalTextStyle,
        ));
        break;
      }
    }

    return Text.rich(
      TextSpan(children: spans),
      maxLines: maxLines,
    );
  }
}
