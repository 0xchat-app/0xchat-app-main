import 'package:flutter/material.dart';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_webview.dart';
import 'package:ox_discovery/utils/moment_content_analyze_utils.dart';
import 'package:ox_module_service/ox_module_service.dart';
import '../moments/topic_moment_page.dart';

class MomentRichTextWidget extends StatefulWidget {
  final String text;
  final int? maxLines;
  final double? textSize;
  final Color? defaultTextColor;
  final Function? clickBlankCallback;
  final Function? showMoreCallback;
  final bool isShowAllContent;

  const MomentRichTextWidget({
    super.key,
    required this.text,
    this.textSize,
    this.defaultTextColor,
    this.maxLines,
    this.clickBlankCallback,
    this.showMoreCallback,
    this.isShowAllContent = false,
  });

  @override
  _MomentRichTextWidgetState createState() => _MomentRichTextWidgetState();
}

class _MomentRichTextWidgetState extends State<MomentRichTextWidget>
    with WidgetsBindingObserver {
  final GlobalKey _containerKey = GlobalKey();

  Map<String, UserDB?> userDBList = {};

  bool isOnSelectText = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserInfo();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      _getUserInfo();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _getUserInfo() async {
    userDBList = await MomentContentAnalyzeUtils(widget.text).getUserInfoMap;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    String getShowText =
        MomentContentAnalyzeUtils(widget.text).getMomentShowContent;
    final textSpans = _buildTextSpans(getShowText, context);
    return Container(
      key: _containerKey,
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText.rich(
            onSelectionChanged:(TextSelection selection, SelectionChangedCause? cause){
              if(cause == SelectionChangedCause.longPress){
                isOnSelectText = true;
              }
            },
            onTap: _clearSelectTextToCallback,
            maxLines: widget.maxLines,
            TextSpan(
              style: TextStyle(
                color: widget.defaultTextColor ?? ThemeColor.color0,
                fontSize: widget.textSize ?? 16.px,
              ),
              children: textSpans,
            ),
          ),
        ],
      ),
    );
  }

  List<TextSpan> _buildTextSpans(String text, BuildContext context) {
    MomentContentAnalyzeUtils analyze = MomentContentAnalyzeUtils(text);
    String showContent = analyze.getMomentPlainText;
    if (!widget.isShowAllContent && showContent.length > 300) {
      text = '${text.substring(0, 300)} show more';
    }
    final List<TextSpan> spans = [];
    Map<String, RegExp> regexMap = MomentContentAnalyzeUtils.regexMap;
    final RegExp contentExp = RegExp(
        [
          (regexMap['hashRegex'] as RegExp).pattern,
          (regexMap['urlExp'] as RegExp).pattern,
          (regexMap['nostrExp'] as RegExp).pattern,
          (regexMap['lineFeed'] as RegExp).pattern,
          (regexMap['showMore'] as RegExp).pattern,
          (regexMap['youtubeExp'] as RegExp).pattern,
        ].join('|'),
        caseSensitive: false
    );
    int lastMatchEnd = 0;
    contentExp.allMatches(text).forEach((match) {
      final beforeMatch = text.substring(lastMatchEnd, match.start);
      if (beforeMatch.isNotEmpty) {
        spans.add(TextSpan(
          text: beforeMatch,
          recognizer: TapGestureRecognizer()
            ..onTap = _clearSelectTextToCallback,
        ));
      }

      final matchText = match.group(0);
      if (matchText == '\n') {
        spans.add(const TextSpan(text: '\n'));
      } else if (matchText == 'show more') {
        spans.add(TextSpan(
          text: '... show more',
          style: TextStyle(color: ThemeColor.purple2),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              widget.showMoreCallback?.call();
            },
        ));
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
    List<String> list = _dealWithText(text);
    bool hasClickInfo = list[1].isNotEmpty;
    return TextSpan(
      text: list[0],
      style: TextStyle(color: hasClickInfo ? ThemeColor.purple2 : ThemeColor.white),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          _onTextTap(list[1], context);
        },
    );
  }

  List<String> _dealWithText(String text) {
    if (text.startsWith('nostr:npub') ||
        text.startsWith('npub') ||
        text.startsWith('nostr:nprofile')) {
      if (userDBList[text] != null) {
        UserDB userDB = userDBList[text]!;
        return ['@${userDB.name}', '@${userDB.pubKey}'];
      }

      Map<String, dynamic>? userMap = Account.decodeProfile(text);
      String showContent = '';
      if(userMap == null || userMap['pubkey'].isEmpty){
        showContent = text;
      }
      return [showContent, ''];
    }

    if (text.startsWith('http')) {
      int subLength = text.length > 20 ? 20 : text.length;
      return [text.substring(0, subLength) + '...', text];
    }
    return [text, text];
  }

  void _onTextTap(String text, BuildContext context) async {
    if (text.startsWith('#')) {
      OXNavigator.pushPage(context, (context) => TopicMomentPage(title: text));
      return;
    }
    if (text.startsWith('@')) {
      OXModuleService.pushPage(context, 'ox_chat', 'ContactUserInfoPage', {
        'pubkey': text.substring(1),
      });
      return;
    }
    if (text.startsWith('http')) {
      OXNavigator.presentPage(
          context,
          allowPageScroll: true,
          (context) => CommonWebView(text),
          fullscreenDialog: true);
      return;
    }
    widget.clickBlankCallback?.call();
  }

  void _clearSelectTextToCallback(){
    if (FocusScope.of(context).hasFocus && isOnSelectText) {
      FocusScope.of(context).unfocus();
      isOnSelectText = false;
    } else {
      widget.clickBlankCallback?.call();
    }
  }
}
