import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart'; //
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_webview.dart';
import 'package:ox_discovery/utils/moment_content_analyze_utils.dart';
import 'package:ox_module_service/ox_module_service.dart';
import '../../utils/discovery_utils.dart';
import '../moments/topic_moment_page.dart';

class MomentRichTextWidget extends StatefulWidget {
  final String text;
  final int? maxLines;
  final double? textSize;
  final Color? defaultTextColor;
  final Function? clickBlankCallback;
  final bool isShowMoreTextBtn;

  const MomentRichTextWidget({
    super.key,
    required this.text,
    this.textSize,
    this.defaultTextColor,
    this.maxLines = 4,
    this.clickBlankCallback,
    this.isShowMoreTextBtn = true,
  });

  @override
  _MomentRichTextWidgetState createState() => _MomentRichTextWidgetState();
}

class _MomentRichTextWidgetState extends State<MomentRichTextWidget> with WidgetsBindingObserver {
  final GlobalKey _containerKey = GlobalKey();

  bool isShowMore = false;
  bool isOverTwoLines = false;
  Map<String,UserDB?> userDBList = {};

  int? showMaxLine;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserInfo();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_containerKey.currentContext != null) {
        final RenderBox renderBox = _containerKey.currentContext!.findRenderObject() as RenderBox;
        String getShowText = MomentContentAnalyzeUtils(widget.text).getMomentShowContent;
        _getIsOutOfText(getShowText,renderBox.size.width);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _getUserInfo() async{
    userDBList = await MomentContentAnalyzeUtils(widget.text).getUserInfoMap;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String getShowText = MomentContentAnalyzeUtils(widget.text).getMomentShowContent;
    final textSpans = _buildTextSpans(getShowText, context);

    return Container(
      key: _containerKey,
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            maxLines: isShowMore ? 100 : showMaxLine,
            text: TextSpan(
              style: TextStyle(
                  color: widget.defaultTextColor ?? ThemeColor.color0,
                  fontSize: widget.textSize ?? 16.px,
              ),
              children: textSpans,
            ),
          ),
          _isShowMoreWidget(getShowText),
        ],
      ),
    );
  }

  Widget _isShowMoreWidget(String text) {
    if (!widget.isShowMoreTextBtn || isShowMore || !isOverTwoLines) return const SizedBox();
    return GestureDetector(
      onTap: () {
        isShowMore = true;
        setState(() {});
      },
      child: Text(
        'Read More',
        style: TextStyle(
          color: ThemeColor.purple2,
          fontSize: 14.px,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  List<TextSpan> _buildTextSpans(String text, BuildContext context) {
    final List<TextSpan> spans = [];
    final RegExp regex =
        RegExp(r"#(\w+)|nostr:npub(\w+)|npub1(\w+)|(https?:\/\/[^\s]+)|\n");

    int lastMatchEnd = 0;
    regex.allMatches(text).forEach((match) {
      final beforeMatch = text.substring(lastMatchEnd, match.start);
      if (beforeMatch.isNotEmpty) {
        spans.add(TextSpan(
          text: beforeMatch,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
            widget.clickBlankCallback?.call();
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
    List<String> list = _dealWithText(text);
    return TextSpan(
      text: list[0] + ' ',
      style: TextStyle(color: ThemeColor.purple2),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          _onTextTap(list[1], context);
        },
    );
  }
  
  List<String> _dealWithText(String text){
    if(text.startsWith('nostr:npub1') || text.startsWith('npub1')){

      if(userDBList[text] != null){
        UserDB userDB = userDBList[text]!;
        return ['@${userDB.name}','@${userDB.pubKey}'];
      }else{
        UserDB myDB = OXUserInfoManager.sharedInstance.currentUserInfo!;
        return ['@${myDB.name}','@${myDB.pubKey}'];
      }
    }

    if(text.startsWith('http')){
      int subLength = text.length > 20 ? 20 : text.length;
      return [text.substring(0,subLength) + '...',text];
    }
    return [text,text];
  }

  void _onTextTap(String text, BuildContext context) async{
    if (text.startsWith('#')) {
      OXNavigator.pushPage(context, (context) => TopicMomentPage(title: text));
      return;
    }
    if (text.startsWith('@')) {
      OXModuleService.pushPage(context, 'ox_chat', 'ContactUserInfoPage', {
        'pubkey':text.substring(1),
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

  void _getIsOutOfText(String text,double width) {
    final textInfo = DiscoveryUtils.getTextLine(text,width,16, widget.maxLines);
    bool isOver = textInfo['isOver'];
    int lineCount = textInfo['lineCount'];
    _getMaxLines(isOver, lineCount);
    isOverTwoLines = isOver;
    setState(() {});
  }

  void _getMaxLines(bool isOver,int lineCount){
    if(lineCount < widget.maxLines!){
      showMaxLine = lineCount == 0 ? 1 : lineCount;
    }else{
      int? max = isShowMore ? 100 : widget.maxLines;
      showMaxLine = !isOver ? widget.maxLines : max;
    }
    setState(() {});
  }
}
