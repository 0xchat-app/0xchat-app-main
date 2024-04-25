import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' as Intl;

class DiscoveryUtils {
  static String formatTimeAgo(int timestamp) {
    DateTime givenTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    DateTime currentTime = DateTime.now();
    Duration diff = currentTime.difference(givenTime);

    if (diff.inDays >= 1) {
      return formatTimestamp(timestamp * 1000);
    } else if (diff.inHours >= 12) {
      return '12 hours ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} hours ago';
    } else if (diff.inMinutes >= 30) {
      return '30 minutes ago';
    } else if (diff.inMinutes >= 15) {
      return '15 minutes ago';
    } else {
      return 'just now';
    }
  }

  static String formatTimestamp(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String formattedDate = Intl.DateFormat('MM/dd').format(date);
    return formattedDate;
  }

  static int getTextLine(String text, double width, int? maxLine) {
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text.trim(),
      ),
      maxLines: maxLine ?? 100,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: width);
    int lineCount = textPainter.computeLineMetrics().length;

    return lineCount;
  }
}
