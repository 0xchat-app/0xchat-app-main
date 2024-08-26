import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' as Intl;
import 'package:ox_common/business_interface/ox_chat/interface.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:path/path.dart';
import '../model/moment_extension_model.dart';
import '../model/moment_ui_model.dart';
import 'moment_content_analyze_utils.dart';
import 'dart:math' as Math;
import 'moment_widgets_utils.dart';

class DiscoveryUtils {
  static String formatTimeAgo(int timestamp) {
    DateTime givenTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    DateTime currentTime = DateTime.now();
    Duration diff = currentTime.difference(givenTime);

    if (diff.inDays >= 1) {
      return formatTimestamp(timestamp * 1000);
    } else if (diff.inHours >= 12) {
      return '12 ${Localized.text('ox_discovery.hour_age_tips')}';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} ${Localized.text('ox_discovery.hour_age_tips')}';
    } else if (diff.inMinutes >= 30) {
      return '30 ${Localized.text('ox_discovery.minute_age_tips')}';
    } else if (diff.inMinutes >= 15) {
      return '15 ${Localized.text('ox_discovery.minute_age_tips')}';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} ${Localized.text('ox_discovery.minute_age_tips')}';
    } else {
      return Localized.text('ox_discovery.just_now');
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
    UserDBISAR? user = await Account.sharedInstance.getUserInfo(pubkey);
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
  static List<String> getUserMomentInfo(UserDBISAR? user, String time) {
    if (user == null) return [time, ''];
    String dns = '';
    String? dnsStr = user.dns;

    dns = dnsStr != null && dnsStr.isNotEmpty && dnsStr != 'null'
        ? dnsStr
        : user.encodedPubkey.substring(0, 10);
    if (dns.length > 20) {
      dns = dns.substring(0, 7) + '...' + dns.substring(dns.length - 7);
    }
    return ['$dns · $time', dns];
  }

  static List<String> momentContentSplit(String input) {
    int previousMatchEnd = 0;
    List<String> results = [];

    RegExp noteExp = MomentContentAnalyzeUtils.regexMap['noteExp'] as RegExp;
    RegExp naddrExp = MomentContentAnalyzeUtils.regexMap['naddrExp'] as RegExp;
    RegExp lightningInvoiceExp =
        MomentContentAnalyzeUtils.regexMap['lightningInvoiceExp'] as RegExp;
    RegExp ecashExp = MomentContentAnalyzeUtils.regexMap['ecashExp'] as RegExp;

    final RegExp contentExp = RegExp(
        [
          noteExp.pattern,
          naddrExp.pattern,
          lightningInvoiceExp.pattern,
          ecashExp.pattern,
        ].join('|'),
        caseSensitive: false);

    Iterable<RegExpMatch> matches = contentExp.allMatches(input);

    for (var match in matches) {
      if (previousMatchEnd < match.start) {
        results.add(input.substring(previousMatchEnd, match.start));
      }
      results.add(input.substring(match.start, match.end));
      previousMatchEnd = match.end;
    }

    if (previousMatchEnd < input.length) {
      results.add(input.substring(previousMatchEnd));
    }
    return results;
  }

  static List<String>? getMentionReplyUserList(
      Map<String, UserDBISAR> draftCueUserMap, String text) {
    List<String> replyUserList = [];

    if (draftCueUserMap.isEmpty) return null;
    draftCueUserMap.values.map((UserDBISAR user) {
      String name = user.name ?? user.pubKey;
      if (text.toLowerCase().contains(name.toLowerCase())) {
        replyUserList.add(user.pubKey);
      }
    }).toList();
    return replyUserList.isEmpty ? null : replyUserList;
  }

  static String changeAtUserToNpub(
      Map<String, UserDBISAR> draftCueUserMap, String text) {
    String content = text;
    draftCueUserMap.forEach((tag, replacement) {
      content = content.replaceAll(tag, 'nostr:${replacement.encodedPubkey}');
    });
    return content;
  }

  static String truncateTextAndProcessUsers(String text, {int limit = 300}) {
    String draft = text;
    if (!draft.contains('nostr:')) {
      draft = '${draft.substring(0, Math.min(limit, draft.length))} show more';
    }
    int charactersNum = 0;
    String showContent = '';
    List<String> splitText = draft.split(' ');

    for (String content in splitText) {
      if (charactersNum >= limit) {
        break;
      }

      if (content.contains('nostr:')) {
        Map<String, dynamic>? userMap = Account.decodeProfile(content);
        if (userMap != null &&
            userMap['pubkey'] != null &&
            userMap['pubkey'].isNotEmpty) {
          showContent = '$showContent $content';
          continue;
        }
      }

      charactersNum += content.length;
      showContent = '$showContent $content'.trim();
    }

    return showContent;
  }

  static Future<Map<String, dynamic>?> tryDecodeNostrScheme(
      String content) async {
    String? result = await OXChatInterface.tryDecodeNostrScheme(content);
    if (result == null) return null;
    return jsonDecode(result);
  }
}
