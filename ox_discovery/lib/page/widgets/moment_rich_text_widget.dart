import 'package:flutter/material.dart';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_video_page.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_discovery/utils/discovery_utils.dart';
import 'package:ox_discovery/utils/moment_content_analyze_utils.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:ox_chat/utils/translate_service.dart';
import 'package:ox_usercenter/page/set_up/translate_settings_page.dart' as TranslateSettings;
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/user_config_tool.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import '../moments/topic_moment_page.dart';

class MomentRichTextWidget extends StatefulWidget {
  final String text;
  final int? maxLines;
  final double? textSize;
  final Color? defaultTextColor;
  final Function? clickBlankCallback;
  final Function? showMoreCallback;
  final bool isShowAllContent;
  final bool showTranslateButton;

  const MomentRichTextWidget({
    super.key,
    required this.text,
    this.textSize,
    this.defaultTextColor,
    this.maxLines,
    this.clickBlankCallback,
    this.showMoreCallback,
    this.isShowAllContent = false,
    this.showTranslateButton = true,
  });

  @override
  _MomentRichTextWidgetState createState() => _MomentRichTextWidgetState();
}

class _MomentRichTextWidgetState extends State<MomentRichTextWidget>
    with WidgetsBindingObserver {
  final GlobalKey _containerKey = GlobalKey();

  Map<String, UserDBISAR?> userDBList = {};

  bool isOnSelectText = false;
  String? translatedText;
  bool isTranslating = false;
  bool showTranslation = false;

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
      // Clear translation state when text changes
      translatedText = null;
      showTranslation = false;
      isTranslating = false;
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
    String plainText = MomentContentAnalyzeUtils(widget.text).getMomentPlainText;
    bool hasText = plainText.trim().isNotEmpty;
    
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
          if (hasText && widget.showTranslateButton) _buildTranslateButton(),
          if (showTranslation && translatedText != null && translatedText!.isNotEmpty)
            _buildTranslationResult(),
        ],
      ),
    );
  }

  List<TextSpan> _buildTextSpans(String text, BuildContext context) {
    MomentContentAnalyzeUtils analyze = MomentContentAnalyzeUtils(text);
    String showContent = analyze.getMomentPlainText;
    
    if (!widget.isShowAllContent && showContent.length > 300) {
      text = '${DiscoveryUtils.truncateTextAndProcessUsers(text)} show more';
    }

    final List<TextSpan> spans = [];
    Map<String, RegExp> regexMap = MomentContentAnalyzeUtils.regexMap;
    final RegExp contentExp = RegExp(
        [
          (regexMap['hashRegex'] as RegExp).pattern,
          (regexMap['urlExp'] as RegExp).pattern,
          (regexMap['nostrExp'] as RegExp).pattern,
          (regexMap['lineFeedExp'] as RegExp).pattern,
          (regexMap['showMoreExp'] as RegExp).pattern,
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
        UserDBISAR userDB = userDBList[text]!;
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
      MomentContentAnalyzeUtils analyzeUtils = MomentContentAnalyzeUtils(text);
      if(analyzeUtils.getMediaList(2).isNotEmpty){
        CommonVideoPage.show(text);
        return;
      }
      OXModuleService.invoke('ox_common', 'gotoWebView', [context, text, null, null, null, null]);
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

  Widget _buildTranslateButton() {
    return GestureDetector(
      onTap: _handleTranslate,
      child: Container(
        margin: EdgeInsets.only(top: 8.px),
        padding: EdgeInsets.symmetric(horizontal: 8.px, vertical: 4.px),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.language,
              size: 14.px,
              color: ThemeColor.color100,
            ),
            SizedBox(width: 4.px),
            Text(
              showTranslation 
                ? Localized.text('ox_chat.translate_hide')
                : Localized.text('ox_chat.message_menu_translate'),
              style: TextStyle(
                fontSize: 13.px,
                color: ThemeColor.color100,
                fontWeight: FontWeight.w400,
              ),
            ),
            if (isTranslating)
              Padding(
                padding: EdgeInsets.only(left: 8.px),
                child: SizedBox(
                  width: 12.px,
                  height: 12.px,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(ThemeColor.color100),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTranslationResult() {
    return Container(
      margin: EdgeInsets.only(top: 8.px),
      padding: EdgeInsets.all(12.px),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.px),
        color: ThemeColor.color190,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Localized.text('ox_chat.translate_translated'),
            style: TextStyle(
              fontSize: 12.px,
              color: ThemeColor.color100,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.px),
          Text(
            translatedText!,
            style: TextStyle(
              fontSize: 14.px,
              color: ThemeColor.color0,
            ),
          ),
        ],
      ),
    );
  }

  void _handleTranslate() async {
    if (showTranslation) {
      // Toggle hide translation
      setState(() {
        showTranslation = false;
      });
      return;
    }

    // If translation already exists, just show it
    if (translatedText != null && translatedText!.isNotEmpty) {
      setState(() {
        showTranslation = true;
      });
      return;
    }

    // Check if translation service is configured
    final url = UserConfigTool.getSetting(
      StorageSettingKey.KEY_TRANSLATE_URL.name,
      defaultValue: '',
    ) as String;
    
    // If URL is not configured, show dialog to navigate to settings
    if (url.isEmpty) {
      final shouldGoToSettings = await OXCommonHintDialog.show<bool>(
        context,
        title: Localized.text('ox_chat.translate_not_configured_title'),
        content: Localized.text('ox_chat.translate_not_configured_content'),
        isRowAction: true,
        actionList: [
          OXCommonHintAction.cancel(onTap: () {
            OXNavigator.pop(context, false);
          }),
          OXCommonHintAction.sure(
            text: Localized.text('ox_chat.translate_goto_settings'),
            onTap: () {
              OXNavigator.pop(context, true);
            },
          ),
        ],
      );
      
      if (shouldGoToSettings == true) {
        OXNavigator.pushPage(context, (context) => TranslateSettings.TranslateSettingsPage());
      }
      return;
    }

    // Perform translation
    String plainText = MomentContentAnalyzeUtils(widget.text).getMomentPlainText.trim();
    if (plainText.isEmpty) {
      CommonToast.instance.show(context, Localized.text('ox_chat.translate_empty_message'));
      return;
    }

    setState(() {
      isTranslating = true;
    });

    try {
      final translationService = TranslateService();
      final result = await translationService.translate(plainText);
      
      setState(() {
        isTranslating = false;
        if (result != null && result.isNotEmpty) {
          translatedText = result;
          showTranslation = true;
        } else {
          CommonToast.instance.show(context, Localized.text('ox_chat.translate_not_supported'));
        }
      });
    } catch (e) {
      setState(() {
        isTranslating = false;
      });
      String errorMessage = e.toString();
      // Extract meaningful error message
      if (errorMessage.contains('Exception:')) {
        errorMessage = errorMessage.split('Exception:').last.trim();
      }
      // If error message is too technical, use default
      if (errorMessage.isEmpty || errorMessage.length > 100) {
        errorMessage = Localized.text('ox_chat.translate_error');
      }
      CommonToast.instance.show(context, errorMessage);
    }
  }
}
