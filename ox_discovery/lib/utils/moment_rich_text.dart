import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart'; //
import 'package:ox_common/utils/theme_color.dart';
import 'package:url_launcher/url_launcher.dart';

class MomentRichText extends StatelessWidget {
  const MomentRichText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final textSpans = _buildTextSpans(text, context);

    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(8.0),
      child: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          style: TextStyle(color: ThemeColor.color0, fontSize: 16),
          children: textSpans,
        ),
      ),
    );
  }

  List<TextSpan> _buildTextSpans(String text, BuildContext context) {
    final List<TextSpan> spans = [];
    final RegExp regex = RegExp(r"#(\w+)|@(\w+)|(https?:\/\/[^\s]+)|(Read More)|\n");

    int lastMatchEnd = 0;
    regex.allMatches(text).forEach((match) {
      final beforeMatch = text.substring(lastMatchEnd, match.start);
      if (beforeMatch.isNotEmpty) {
        spans.add(TextSpan(text: beforeMatch));
      }

      final matchText = match.group(0);
      if (matchText == '\n') {
        spans.add(TextSpan(text: '\n'));
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
      print('Navigate to topic: $text');
    } else if (text.startsWith('@')) {
      print('Navigate to user: $text');
    } else if (text.startsWith('http')) {
      print('Open URL: $text');
      _launchURL(text);
    } else if (text == 'Read More ') {
      print('Navigate to Read More');
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}
