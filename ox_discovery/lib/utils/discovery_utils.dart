import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' as Intl;
import 'package:ox_common/utils/adapt.dart';

import 'moment_content_analyze_utils.dart';
import 'moment_widgets_utils.dart';

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
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }

  static String formatTimestamp(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String formattedDate = Intl.DateFormat('MM/dd').format(date);
    return formattedDate;
  }

  static Map<String, dynamic> getTextLine(
      String text, double width, double fontSize, int? maxLine) {
    TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: TextStyle(fontSize: fontSize.px)),
      maxLines: maxLine,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: width);
    int lineCount = textPainter.computeLineMetrics().length;
    bool isOver = textPainter.didExceedMaxLines;
    return {'isOver': isOver, 'lineCount': lineCount};
  }

  static Future<String> getAvatar(String pubkey) async {
    UserDB? user = await Account.sharedInstance.getUserInfo(pubkey);
    return user?.picture ?? '';
  }

  static Future<List<String>> getAvatarBatch(List<String> pubkeys) async {
    List<String> avatars = [];
    for (var element in pubkeys) {
      String avatar = await getAvatar(element);
      avatars.add(avatar);
    }
    return avatars;
  }

  // [fullName,dns]
  static List<String> getUserMomentInfo(UserDB? user, String time) {
    if (user == null) return [time,''];
    String dns = '';
    String? dnsStr = user.dns;

    dns = dnsStr != null && dnsStr.isNotEmpty && dnsStr != 'null'
        ? dnsStr
        : user.encodedPubkey.substring(0, 10);
    if(dns.length > 20){
      dns = dns.substring(0, 7) + '...' + dns.substring(dns.length - 7);
    }
    return ['$dns · $time',dns];
  }

  static List<String> momentContentSplit(String text) {
    MomentContentAnalyzeUtils analyze = MomentContentAnalyzeUtils(text);
    List<String> quoteUrlList = analyze.getQuoteUrlList;
    if(quoteUrlList.isEmpty) return [text];

    List<String> showList = text.split(' ');
    String draft = '';
    List<String> result = [];

    for (String content in showList) {
      if (quoteUrlList.contains(content)) {
        if (draft.isNotEmpty) {
          result.add(draft.trim());
          draft = '';
        }
        result.add(content);
      } else {
        draft += (draft.isEmpty ? "" : " ") + content;
      }
    }

    if (draft.isNotEmpty) {
      result.add(draft.trim());
    }
    return result;
  }
}
