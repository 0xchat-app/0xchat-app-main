import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart'; //
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_webview.dart';
import 'package:ox_module_service/ox_module_service.dart';

import '../page/moments/moments_page.dart';
import '../page/moments/topic_moment_page.dart';

class MomentRichText extends StatelessWidget {
  MomentRichText({
    super.key,
    required this.text,
    this.textSize,
    this.defaultTextColor,
    this.maxLines,
  });

  final String text;
  final double? textSize;
  final Color? defaultTextColor;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final textSpans = _buildTextSpans(text, context);

    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(8.0),
      child: RichText(
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        maxLines: maxLines ?? 100,
        text: TextSpan(
          style: TextStyle(
              color: defaultTextColor ?? ThemeColor.color0,
              fontSize: textSize ?? 16.px),
          children: textSpans,
        ),
      ),
    );
  }

  List<TextSpan> _buildTextSpans(String text, BuildContext context) {
    final List<TextSpan> spans = [];
    final RegExp regex =
        RegExp(r"#(\w+)|@(\w+)|(https?:\/\/[^\s]+)|(Read More)|\n");

    int lastMatchEnd = 0;
    regex.allMatches(text).forEach((match) {
      final beforeMatch = text.substring(lastMatchEnd, match.start);
      if (beforeMatch.isNotEmpty) {
        spans.add(TextSpan(
          text: beforeMatch,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              OXNavigator.pushPage(context, (context) => MomentsPage());
            },
        ));
      }

      final matchText = match.group(0);
      if (matchText == '\n') {
        spans.add(const TextSpan(text: '\n'));
      } else {
        spans.add(_buildLinkSpan(matchText!, context));
      }

      lastMatchEnd = match.end;
    });

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd)));
    }

    return spans;
  }

  TextSpan _buildLinkSpan(String text, BuildContext context) {
    return TextSpan(
      text: text + ' ',
      style: TextStyle(color: ThemeColor.purple2),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          _onTextTap(text, context);
        },
    );
  }

  void _onTextTap(String text, BuildContext context) {
    if (text.startsWith('#')) {
      OXNavigator.pushPage(context, (context) => TopicMomentPage(title: text));
    } else if (text.startsWith('@')) {
      final pubKey = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '';
      OXModuleService.pushPage(context, 'ox_chat', 'ContactUserInfoPage', {
        'pubkey': pubKey,
      });
    } else if (text.startsWith('http')) {
      OXNavigator.presentPage(context, allowPageScroll: true, (context) => CommonWebView(text), fullscreenDialog: true);
    } else if (text == 'Read More ') {
      print('Navigate to Read More');
    } else {
      OXNavigator.pushPage(context, (context) => const MomentsPage());
    }
  }
}
