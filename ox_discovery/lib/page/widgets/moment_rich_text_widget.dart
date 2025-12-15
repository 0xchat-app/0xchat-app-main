import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../moments/topic_moment_page.dart';
import '../moments/moment_article_page.dart';

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
    String plainText = MomentContentAnalyzeUtils(widget.text).getMomentPlainText;
    bool hasText = plainText.trim().isNotEmpty;
    
    return Container(
      key: _containerKey,
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMarkdownText(getShowText, context),
          if (hasText && widget.showTranslateButton) _buildTranslateButton(),
          if (showTranslation && translatedText != null && translatedText!.isNotEmpty)
            _buildTranslationResult(),
        ],
      ),
    );
  }

  Widget _buildMarkdownText(String text, BuildContext context) {
    MomentContentAnalyzeUtils analyze = MomentContentAnalyzeUtils(text);
    String showContent = analyze.getMomentPlainText;
    
    if (!widget.isShowAllContent && showContent.length > 300) {
      text = '${DiscoveryUtils.truncateTextAndProcessUsers(text)} show more';
    }

    final baseTextStyle = TextStyle(
      color: widget.defaultTextColor ?? ThemeColor.color0,
      fontSize: widget.textSize ?? 16.px,
    );

    // Preprocess text to handle custom features (hashtags, Nostr links) before Markdown rendering
    String processedText = _preprocessTextForMarkdown(text);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // Handle blank area tap to trigger detail page navigation
        widget.clickBlankCallback?.call();
      },
      child: MarkdownBody(
        data: processedText,
        selectable: false,
        styleSheet: MarkdownStyleSheet(
          p: baseTextStyle,
          h1: baseTextStyle.copyWith(
            fontSize: (widget.textSize ?? 16.px) * 2,
            fontWeight: FontWeight.bold,
          ),
          h2: baseTextStyle.copyWith(
            fontSize: (widget.textSize ?? 16.px) * 1.75,
            fontWeight: FontWeight.bold,
          ),
          h3: baseTextStyle.copyWith(
            fontSize: (widget.textSize ?? 16.px) * 1.5,
            fontWeight: FontWeight.bold,
          ),
          h4: baseTextStyle.copyWith(
            fontSize: (widget.textSize ?? 16.px) * 1.25,
            fontWeight: FontWeight.bold,
          ),
          h5: baseTextStyle.copyWith(
            fontSize: (widget.textSize ?? 16.px) * 1.1,
            fontWeight: FontWeight.bold,
          ),
          h6: baseTextStyle.copyWith(
            fontSize: widget.textSize ?? 16.px,
            fontWeight: FontWeight.bold,
          ),
          strong: baseTextStyle.copyWith(fontWeight: FontWeight.bold),
          em: baseTextStyle.copyWith(fontStyle: FontStyle.italic),
          del: baseTextStyle.copyWith(decoration: TextDecoration.lineThrough),
          code: baseTextStyle.copyWith(
            fontFamily: defaultTargetPlatform == TargetPlatform.iOS ? 'Courier' : 'monospace',
            backgroundColor: ThemeColor.color190,
          ),
          codeblockDecoration: BoxDecoration(
            color: ThemeColor.color190,
            borderRadius: BorderRadius.circular(4.px),
          ),
          codeblockPadding: EdgeInsets.all(8.px),
          listBullet: baseTextStyle,
          blockquote: baseTextStyle.copyWith(
            color: ThemeColor.color100,
            fontStyle: FontStyle.italic,
          ),
          blockquoteDecoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: ThemeColor.purple2, width: 2.px),
            ),
          ),
          blockquotePadding: EdgeInsets.only(left: 16.px),
          a: baseTextStyle.copyWith(color: ThemeColor.purple2),
          listIndent: 24.px,
        ),
      onTapLink: (text, href, title) {
        if (href != null) {
          // Handle custom link formats
          if (href.startsWith('moment://hashtag/')) {
            _onTextTap('#${href.substring(18)}', context);
          } else if (href.startsWith('moment://nostr/')) {
            String nostrLink = href.substring(15);
            List<String> list = _dealWithText(nostrLink);
            if (list[1].isNotEmpty) {
              _onTextTap(list[1], context);
            }
          } else if (href.startsWith('moment://note/')) {
            // Handle note/event references - show as quoted moment
            String noteRef = href.substring(14);
            _handleNoteReference(noteRef, context);
          } else if (href.startsWith('moment://naddr/')) {
            // Handle naddr (article) references
            String naddrRef = href.substring(15);
            _handleNaddrReference(naddrRef, context);
          } else if (href.startsWith('moment://showmore')) {
            widget.showMoreCallback?.call();
          } else {
            // Regular URL
            _onTextTap(href, context);
          }
        }
      },
      ),
    );
  }

  // Preprocess text to convert custom formats to Markdown-compatible links
  String _preprocessTextForMarkdown(String text) {
    Map<String, RegExp> regexMap = MomentContentAnalyzeUtils.regexMap;
    String processed = text;

    // Convert hashtags to Markdown links
    final hashRegex = regexMap['hashRegex']!;
    processed = processed.replaceAllMapped(hashRegex, (match) {
      String tag = match.group(0)!;
      String tagName = match.group(1)!;
      // Skip headings like "## title" or empty tags
      if (tagName.isEmpty || tagName.contains('#')) return tag;
      return '[$tag](moment://hashtag/$tagName)';
    });

    // Convert Nostr profiles to Markdown links with user names
    final nostrRegex = regexMap['nostrExp']!;
    processed = processed.replaceAllMapped(nostrRegex, (match) {
      String nostr = match.group(0)!;
      // Try to get user name from userDBList
      String displayText = nostr;
      if (userDBList.containsKey(nostr) && userDBList[nostr] != null) {
        UserDBISAR userDB = userDBList[nostr]!;
        displayText = '@${userDB.name ?? userDB.nickName ?? userDB.pubKey}';
      } else {
        // Try to decode and get pubkey for display
        Map<String, dynamic>? userMap = Account.decodeProfile(nostr);
        if (userMap != null && userMap['pubkey'] != null && userMap['pubkey'].toString().isNotEmpty) {
          displayText = '@${userMap['pubkey'].toString().substring(0, 8)}...';
        }
      }
      return '[$displayText](moment://nostr/$nostr)';
    });

    // Convert Nostr note/event references to readable links
    final noteRegex = regexMap['noteExp']!;
    processed = processed.replaceAllMapped(noteRegex, (match) {
      String noteRef = match.group(0)!;
      String displayText = noteRef.contains('nevent') ? '📝 Event' : '📝 Note';
      return '[$displayText](moment://note/$noteRef)';
    });

    // Convert Nostr address (article) references to readable links
    final naddrRegex = regexMap['naddrExp']!;
    processed = processed.replaceAllMapped(naddrRegex, (match) {
      String naddr = match.group(0)!;
      return '[📄 Article](moment://naddr/$naddr)';
    });

    // Convert "show more" to Markdown link
    final showMoreRegex = regexMap['showMoreExp']!;
    processed = processed.replaceAllMapped(showMoreRegex, (match) {
      return '[... show more](moment://showmore)';
    });

    return processed;
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

  void _handleNoteReference(String noteRef, BuildContext context) {
    // Note/event references are handled by MomentQuoteWidget in moment_widget.dart
    // For now, just show a toast. In the future, could navigate to the note.
    CommonToast.instance.show(context, 'Note reference: ${noteRef.substring(0, 20)}...');
  }

  void _handleNaddrReference(String naddrRef, BuildContext context) {
    // Naddr (article) references are handled by MomentArticleWidget in moment_widget.dart
    // Navigate to the article page
    OXNavigator.presentPage(
      context,
      (context) => MomentArticlePage(naddr: naddrRef),
    );
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
      if (mounted) {
        setState(() {
          showTranslation = false;
        });
      }
      return;
    }

    // If translation already exists, just show it
    if (translatedText != null && translatedText!.isNotEmpty) {
      if (mounted) {
        setState(() {
          showTranslation = true;
        });
      }
      return;
    }

    // Check if translation service is configured
    // Only check URL for LibreTranslate (serviceIndex == 1), Google ML Kit doesn't need URL
    final serviceIndex = UserConfigTool.getSetting(
      StorageSettingKey.KEY_TRANSLATE_SERVICE.name,
      defaultValue: 0, // Default to Google ML Kit
    ) as int;
    
    if (serviceIndex == 1) {
      // LibreTranslate requires URL configuration
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
    }

    // Perform translation
    String plainText = MomentContentAnalyzeUtils(widget.text).getMomentPlainText.trim();
    if (plainText.isEmpty) {
      CommonToast.instance.show(context, Localized.text('ox_chat.translate_empty_message'));
      return;
    }

    if (mounted) {
      setState(() {
        isTranslating = true;
      });
    }

    try {
      final translationService = TranslateService();
      final result = await translationService.translate(plainText);
      
      if (mounted) {
        setState(() {
          isTranslating = false;
          if (result != null && result.isNotEmpty) {
            translatedText = result;
            showTranslation = true;
          } else {
            CommonToast.instance.show(context, Localized.text('ox_chat.translate_not_supported'));
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isTranslating = false;
        });
      }
      if (mounted) {
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
}
