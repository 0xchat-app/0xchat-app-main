import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_link_previewer/flutter_link_previewer.dart'
    show LinkPreview;
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:ox_common/const/common_constant.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/web_url_helper.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/emoji_enlargement_behavior.dart';
import '../../models/pattern_style.dart';
import '../../util.dart';
import '../state/inherited_chat_theme.dart';
import '../state/inherited_user.dart';

/// A class that represents text message widget with optional link preview.
class TextMessage extends StatelessWidget {
  /// Creates a text message widget from a [types.TextMessage] class.
  TextMessage({
    super.key,
    required this.emojiEnlargementBehavior,
    required this.hideBackgroundOnEmojiMessages,
    required this.message,
    this.nameBuilder,
    this.onPreviewDataFetched,
    this.options = const TextMessageOptions(),
    required this.showName,
    required this.usePreviewData,
    this.userAgent,
    this.maxLimit,
    this.codeBlockBuilder,
  }) : messageText = message.text.trim();

  /// See [Message.emojiEnlargementBehavior].
  final EmojiEnlargementBehavior emojiEnlargementBehavior;

  /// See [Message.hideBackgroundOnEmojiMessages].
  final bool hideBackgroundOnEmojiMessages;

  /// [types.TextMessage].
  final types.TextMessage message;

  final String messageText;

  /// This is to allow custom user name builder
  /// By using this we can fetch newest user info based on id
  final Widget Function(String userId)? nameBuilder;

  /// See [LinkPreview.onPreviewDataFetched].
  final void Function(types.TextMessage, PreviewData)?
      onPreviewDataFetched;

  /// Customisation options for the [TextMessage].
  final TextMessageOptions options;

  /// Show user name for the received message. Useful for a group chat.
  final bool showName;

  /// Enables link (URL) preview.
  final bool usePreviewData;

  /// User agent to fetch preview data with.
  final String? userAgent;

  final int? maxLimit;

  final Widget Function({required BuildContext context, required String codeText,})? codeBlockBuilder;

  @override
  Widget build(BuildContext context) {
    final enlargeEmojis =
        emojiEnlargementBehavior != EmojiEnlargementBehavior.never &&
            isConsistsOfEmojis(emojiEnlargementBehavior, message);
    final theme = InheritedChatTheme.of(context).theme;
    final user = InheritedUser.of(context).user;
    final width = MediaQuery.of(context).size.width;

    if (usePreviewData && onPreviewDataFetched != null) {
      var urlRegexp = RegExp(WebURLHelper.regexLink, caseSensitive: false);
      var matches = urlRegexp.allMatches(messageText);

      if (matches.isNotEmpty) {
        return _linkPreview(user, width, context);
      }

      urlRegexp = RegExp(WebURLHelper.regexNostr, caseSensitive: false);
      matches = urlRegexp.allMatches(messageText);

      if (matches.isNotEmpty) {
        final text = messageText.replaceFirst('nostr:', CommonConstant.njumpURL);
        return _linkPreview(user, width, context, text: text);
      }
    }

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: (enlargeEmojis && !message.hasReactions) ? 0 : theme.messageInsetsHorizontal,
        vertical:  (enlargeEmojis && !message.hasReactions) ? 0 : theme.messageInsetsVertical,
      ),
      child: _textWidgetBuilder(user, context, enlargeEmojis),
    );
  }

  Widget _linkPreview(
    types.User user,
    double width,
    BuildContext context,
      {String? text}
  ) {
    final theme = InheritedChatTheme.of(context).theme;
    final linkDescriptionTextStyle = user.id == message.author.id
        ? theme.sentMessageBodyTextStyle
        : theme.receivedMessageBodyTextStyle;
    final linkTitleTextStyle = user.id == message.author.id
        ? theme.sentMessageBodyTextStyle
        : theme.receivedMessageBodyTextStyle;

    return LinkPreview(
      enableAnimation: true,
      metadataTextStyle: linkDescriptionTextStyle,
      metadataTitleStyle: linkTitleTextStyle,
      onLinkPressed: options.onLinkPressed,
      onPreviewDataFetched: _onPreviewDataFetched,
      openOnPreviewImageTap: options.openOnPreviewImageTap,
      openOnPreviewTitleTap: options.openOnPreviewTitleTap,
      padding: EdgeInsets.symmetric(
        horizontal:
            InheritedChatTheme.of(context).theme.messageInsetsHorizontal,
        vertical: InheritedChatTheme.of(context).theme.messageInsetsVertical,
      ),
      previewData: message.previewData,
      text: text ?? messageText,
      textWidget: _textWidgetBuilder(user, context, false),
      userAgent: userAgent,
      width: width,
    );
  }

  void _onPreviewDataFetched(PreviewData previewData) {
    if (message.previewData == null) {
      onPreviewDataFetched?.call(message, previewData);
    }
  }

  Widget _textWidgetBuilder(
    types.User user,
    BuildContext context,
    bool enlargeEmojis,
  ) {
    final theme = InheritedChatTheme.of(context).theme;
    final bodyLinkTextStyle = user.id == message.author.id
        ? InheritedChatTheme.of(context).theme.sentMessageBodyLinkTextStyle
        : InheritedChatTheme.of(context).theme.receivedMessageBodyLinkTextStyle;
    final bodyTextStyle = user.id == message.author.id
        ? theme.sentMessageBodyTextStyle
        : theme.receivedMessageBodyTextStyle;
    final boldTextStyle = user.id == message.author.id
        ? theme.sentMessageBodyBoldTextStyle
        : theme.receivedMessageBodyBoldTextStyle;
    final codeTextStyle = user.id == message.author.id
        ? theme.sentMessageBodyCodeTextStyle
        : theme.receivedMessageBodyCodeTextStyle;
    final emojiTextStyle = user.id == message.author.id
        ? theme.sentEmojiMessageTextStyle
        : theme.receivedEmojiMessageTextStyle;
    final moreBtnColor = user.id == message.author.id
        ? Colors.black.withOpacity(0.6)
        : ThemeColor.gradientMainStart;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (showName)
        //   nameBuilder?.call(message.author.id) ??
        //       UserName(author: message.author),
        if (enlargeEmojis)
          if (options.isTextSelectable)
            SelectableText(messageText, style: emojiTextStyle)
          else
            Text(messageText, style: emojiTextStyle)
        else
          TextMessageText(
            bodyLinkTextStyle: bodyLinkTextStyle,
            bodyTextStyle: bodyTextStyle,
            boldTextStyle: boldTextStyle,
            codeTextStyle: codeTextStyle,
            codeBlockBuilder: codeBlockBuilder,
            options: options,
            text: messageText,
            maxLines: 100,
            overflow: TextOverflow.ellipsis,
            maxLimit: maxLimit,
            moreBtnColor: moreBtnColor,
          ),
      ],
    );
  }
}

/// Widget to reuse the markdown capabilities, e.g., for previews.
class TextMessageText extends StatelessWidget {
  const TextMessageText({
    super.key,
    this.bodyLinkTextStyle,
    required this.bodyTextStyle,
    this.boldTextStyle,
    this.codeTextStyle,
    this.codeBlockBuilder,
    this.maxLines,
    this.options = const TextMessageOptions(),
    this.overflow = TextOverflow.clip,
    required this.text,
    this.maxLimit,
    this.moreBtnColor,
  });

  /// Style to apply to anything that matches a link.
  final TextStyle? bodyLinkTextStyle;

  /// Regular style to use for any unmatched text. Also used as basis for the fallback options.
  final TextStyle bodyTextStyle;

  /// Style to apply to anything that matches bold markdown.
  final TextStyle? boldTextStyle;

  /// Style to apply to anything that matches code markdown.
  final TextStyle? codeTextStyle;
  
  final Widget Function({required BuildContext context, required String codeText,})? codeBlockBuilder;

  /// See [ParsedText.maxLines].
  final int? maxLines;

  /// See [TextMessage.options].
  final TextMessageOptions options;

  /// See [ParsedText.overflow].
  final TextOverflow overflow;

  /// Text that is shown as markdown.
  final String text;

  final int? maxLimit;

  final Color? moreBtnColor;

  @override
  Widget build(BuildContext context) {
    var text = this.text;
    final maxLimit = this.maxLimit;
    final moreText = Localized.text('ox_chat.more');
    if (maxLimit != null && text.length > maxLimit) {
      final moreFlag = '\$\{0xchat_more_flag\}';
      text = this.text.substring(0, maxLimit) + '...' + moreFlag;
    }
    return ParsedText(
      parse: [
        ...options.matchers,
        MatchText(
          pattern: r'\$\{0xchat_more_flag\}',
          renderWidget: ({required String text, required String pattern,}) => WidgetSpan(
            child: IgnorePointer(
              child: Text(
                moreText,
                style: bodyTextStyle.copyWith(
                  color: moreBtnColor ?? Colors.blueAccent,
                  height: 1.1,
                ),
              ),
            ),
          ),
        ),
        MatchText(
          onTap: (mail) async {
            final url = Uri(scheme: 'mailto', path: mail);
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            }
          },
          pattern: WebURLHelper.regexEmail,
          style: bodyLinkTextStyle ??
              bodyTextStyle.copyWith(
                decoration: TextDecoration.underline,
              ),
        ),
        MatchText(
          onTap: (urlText) async {
            urlText = urlText.replaceFirst('nostr:', CommonConstant.njumpURL);
            if (options.onLinkPressed != null) {
              options.onLinkPressed!(urlText);
            } else {
              final url = Uri.tryParse(urlText);
              if (url != null && await canLaunchUrl(url)) {
                await launchUrl(
                  url,
                  mode: LaunchMode.externalApplication,
                );
              }
            }
          },
          pattern: WebURLHelper.regexNostr,
          style: bodyLinkTextStyle ??
              bodyTextStyle.copyWith(
                decoration: TextDecoration.underline,
              ),
        ),
        MatchText(
          pattern: PatternStyle.code.pattern,
          style: codeTextStyle ??
              bodyTextStyle.merge(PatternStyle.code.textStyle),
          renderWidget: ({required String text, required String pattern,}) {
            final regex = RegExp(r'(?<=^|\s)```([\s\S]+?)```(?=\s|$)');
            final match = regex.firstMatch(text);
            final codeText = (match?.group(1) ?? text).trim();
            return TextSpan(
              children: [
                if (!this.text.startsWith(text)) TextSpan(text: '\n'),
                WidgetSpan(
                  child: codeBlockBuilder?.call(context: context, codeText: codeText)
                      ?? Text(codeText, style: bodyTextStyle,),
                ),
                if (!this.text.endsWith(text)) TextSpan(text: '\n'),
              ],
            );
          },
        ),
        MatchText(
          onTap: (urlText) async {
            final protocolIdentifierRegex = RegExp(
              r'^((http|ftp|https):\/\/)',
              caseSensitive: false,
            );
            if (!urlText.startsWith(protocolIdentifierRegex)) {
              urlText = 'https://$urlText';
            }
            if (options.onLinkPressed != null) {
              options.onLinkPressed!(urlText);
            } else {
              final url = Uri.tryParse(urlText);
              if (url != null && await canLaunchUrl(url)) {
                await launchUrl(
                  url,
                  mode: LaunchMode.externalApplication,
                );
              }
            }
          },
          pattern: WebURLHelper.regexLink,
          style: bodyLinkTextStyle ??
              bodyTextStyle.copyWith(
                decoration: TextDecoration.underline,
              ),
        ),
      ],
      maxLines: maxLines,
      overflow: overflow,
      regexOptions: const RegexOptions(multiLine: true, dotAll: true),
      selectable: options.isTextSelectable,
      style: bodyTextStyle,
      text: text,
      textWidthBasis: TextWidthBasis.longestLine,
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
    );
  }
}

@immutable
class TextMessageOptions {
  const TextMessageOptions({
    this.isTextSelectable = true,
    this.onLinkPressed,
    this.openOnPreviewImageTap = false,
    this.openOnPreviewTitleTap = false,
    this.matchers = const [],
  });

  /// Whether user can tap and hold to select a text content.
  final bool isTextSelectable;

  /// Custom link press handler.
  final void Function(String)? onLinkPressed;

  /// See [LinkPreview.openOnPreviewImageTap].
  final bool openOnPreviewImageTap;

  /// See [LinkPreview.openOnPreviewTitleTap].
  final bool openOnPreviewTitleTap;

  /// Additional matchers to parse the text.
  final List<MatchText> matchers;
}
