import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:intl/intl.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/num_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/web_url_helper.dart';
import 'package:photo_view/photo_view.dart' show PhotoViewComputedScale;
import 'package:scroll_to_index/scroll_to_index.dart';

import '../chat_l10n.dart';
import '../chat_theme.dart';
import '../models/bubble_rtl_alignment.dart';
import '../models/date_header.dart';
import '../models/emoji_enlargement_behavior.dart';
import '../models/giphy_image.dart';
import '../models/message_spacer.dart';
import '../models/unread_header_data.dart';
import '../util.dart';
import 'chat_list.dart';
import 'image_gallery.dart';
import 'input/input.dart';
import 'input/input_more_page.dart';
import 'message/message.dart';
import 'message/system_message.dart';
import 'message/text_message.dart';
import 'pop_menu/custom_pop_up_menu.dart';
import 'state/inherited_chat_theme.dart';
import 'state/inherited_l10n.dart';
import 'state/inherited_user.dart';
import 'typing_indicator.dart';
import 'unread_header.dart';

class ChatHintParam {
  ChatHintParam(this.text, this.onTap);
  final String text;
  final VoidCallback? onTap;
}

/// Entry widget, represents the complete chat. If you wrap it in [SafeArea] and
/// it should be full screen, set [SafeArea]'s `bottom` to `false`.
class Chat extends StatefulWidget {
  /// Creates a chat widget.
  const Chat({
    super.key,
    this.isContentInteractive = true,
    this.audioMessageBuilder,
    this.avatarBuilder,
    this.chatId,
    this.anchorMsgId,
    this.bubbleBuilder,
    this.bubbleRtlAlignment = BubbleRtlAlignment.right,
    this.customTopWidget,
    this.customCenterWidget,
    this.customBottomWidget,
    this.customDateHeaderText,
    this.customMessageBuilder,
    this.customStatusBuilder,
    this.dateFormat,
    this.dateHeaderBuilder,
    this.dateHeaderThreshold = 900000,
    this.dateIsUtc = false,
    this.dateLocale,
    this.disableImageGallery,
    this.emojiEnlargementBehavior = EmojiEnlargementBehavior.multi,
    this.emptyState,
    this.fileMessageBuilder,
    this.groupMessagesThreshold = 60000,
    this.hideBackgroundOnEmojiMessages = true,
    this.imageGalleryOptions = const ImageGalleryOptions(
      maxScale: PhotoViewComputedScale.covered,
      minScale: PhotoViewComputedScale.contained,
    ),
    this.imageHeaders,
    this.imageMessageBuilder,
    this.inputOptions = const InputOptions(),
    this.isAttachmentUploading,
    this.isFirstPage,
    this.isLastPage,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.l10n = const ChatL10nEn(),
    this.listBottomWidget,
    required this.messages,
    this.nameBuilder,
    this.onAttachmentPressed,
    this.onAvatarTap,
    this.onBackgroundTap,
    this.onEndReached,
    this.onEndReachedThreshold,
    this.onHeaderReached,
    this.onMessageDoubleTap,
    this.onMessageLongPress,
    this.onMessageStatusLongPress,
    this.onMessageStatusTap,
    this.onMessageTap,
    this.onMessageVisibilityChanged,
    this.onPreviewDataFetched,
    this.onAudioDataFetched,
    required this.onSendPressed,
    required this.inputMoreItems,
    this.scrollController,
    this.scrollPhysics,
    this.scrollToUnreadOptions = const ScrollToUnreadOptions(),
    this.showUserNames = false,
    this.systemMessageBuilder,
    this.textMessageBuilder,
    this.textMessageOptions = const TextMessageOptions(),
    this.theme = const DefaultChatTheme(),
    this.timeFormat,
    this.typingIndicatorOptions = const TypingIndicatorOptions(),
    this.usePreviewData = true,
    required this.user,
    this.userAgent,
    this.useTopSafeAreaInset,
    this.videoMessageBuilder,
    this.repliedMessageBuilder,
    this.onVoiceSend,
    this.longPressWidgetBuilder,
    this.reactionViewBuilder,
    this.onGifSend,
    this.inputBottomView,
    this.mentionUserListWidget,
    this.onFocusNodeInitialized,
    this.onInsertedContent,
    this.enableBottomWidget = true,
    this.bottomHintParam,
    this.textFieldHasFocus,
    this.scrollToUnreadWidget,
    this.scrollToBottomWidget,
    this.messageHasBuilder,
    this.isShowScrollToBottomButton = false,
    this.replySwipeTriggerCallback,
  });

  final bool isContentInteractive;
  final ChatHintParam? bottomHintParam;
  final bool enableBottomWidget;

  /// See [Message.audioMessageBuilder].
  final Widget Function(types.AudioMessage, {required int messageWidth})? audioMessageBuilder;

  /// See [Message.avatarBuilder].
  final Widget Function(types.Message message)? avatarBuilder;

  final String? chatId;

  final String? anchorMsgId;

  /// See [Message.bubbleBuilder].
  final Widget Function(
    Widget child, {
    required types.Message message,
    required bool nextMessageInGroup,
  })? bubbleBuilder;

  /// See [Message.bubbleRtlAlignment].
  final BubbleRtlAlignment? bubbleRtlAlignment;

  final Widget? customTopWidget;

  final Widget? customCenterWidget;

  final Widget? mentionUserListWidget;

  final Widget? scrollToUnreadWidget;

  final Widget? scrollToBottomWidget;

  /// Allows you to replace the default Input widget e.g. if you want to create
  /// a channel view. If you're looking for the bottom widget added to the chat
  /// list, see [listBottomWidget] instead.
  final Widget? customBottomWidget;

  /// If [dateFormat], [dateLocale] and/or [timeFormat] is not enough to
  /// customize date headers in your case, use this to return an arbitrary
  /// string based on a [DateTime] of a particular message. Can be helpful to
  /// return "Today" if [DateTime] is today. IMPORTANT: this will replace
  /// all default date headers, so you must handle all cases yourself, like
  /// for example today, yesterday and before. Or you can just return the same
  /// date header for any message.
  final String Function(DateTime)? customDateHeaderText;

  /// See [Message.customMessageBuilder].
  final Widget Function({
    required types.CustomMessage message,
    required int messageWidth,
    required Widget reactionWidget,
  })? customMessageBuilder;

  /// See [Message.customStatusBuilder].
  final Widget Function(types.Message message, {required BuildContext context})?
      customStatusBuilder;

  /// Allows you to customize the date format. IMPORTANT: only for the date,
  /// do not return time here. See [timeFormat] to customize the time format.
  /// [dateLocale] will be ignored if you use this, so if you want a localized date
  /// make sure you initialize your [DateFormat] with a locale. See [customDateHeaderText]
  /// for more customization.
  final DateFormat? dateFormat;

  /// Custom date header builder gives ability to customize date header widget.
  final Widget Function(DateHeader)? dateHeaderBuilder;

  /// Time (in ms) between two messages when we will render a date header.
  /// Default value is 15 minutes, 900000 ms. When time between two messages
  /// is higher than this threshold, date header will be rendered. Also,
  /// not related to this value, date header will be rendered on every new day.
  final int dateHeaderThreshold;

  /// Use utc time to convert message milliseconds to date.
  final bool dateIsUtc;

  /// Locale will be passed to the `Intl` package. Make sure you initialized
  /// date formatting in your app before passing any locale here, otherwise
  /// an error will be thrown. Also see [customDateHeaderText], [dateFormat], [timeFormat].
  final String? dateLocale;

  /// Disable automatic image preview on tap.
  final bool? disableImageGallery;

  /// See [Message.emojiEnlargementBehavior].
  final EmojiEnlargementBehavior emojiEnlargementBehavior;

  /// Allows you to change what the user sees when there are no messages.
  /// `emptyChatPlaceholder` and `emptyChatPlaceholderTextStyle` are ignored
  /// in this case.
  final Widget? emptyState;

  /// See [Message.fileMessageBuilder].
  final Widget Function(types.FileMessage, {required int messageWidth})? fileMessageBuilder;

  /// Time (in ms) between two messages when we will visually group them.
  /// Default value is 1 minute, 60000 ms. When time between two messages
  /// is lower than this threshold, they will be visually grouped.
  final int groupMessagesThreshold;

  /// See [Message.hideBackgroundOnEmojiMessages].
  final bool hideBackgroundOnEmojiMessages;

  /// See [ImageGallery.options].
  final ImageGalleryOptions imageGalleryOptions;

  /// Headers passed to all network images used in the chat.
  final Map<String, String>? imageHeaders;

  /// See [Message.imageMessageBuilder].
  final Widget Function(types.ImageMessage, {required int messageWidth})? imageMessageBuilder;

  /// See [Input.options].
  final InputOptions inputOptions;

  /// See [Input.isAttachmentUploading].
  final bool? isAttachmentUploading;

  /// See [ChatList.isFirstPage].
  final bool? isFirstPage;

  /// See [ChatList.isLastPage].
  final bool? isLastPage;

  /// See [ChatList.keyboardDismissBehavior].
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// Localized copy. Extend [ChatL10n] class to create your own copy or use
  /// existing one, like the default [ChatL10nEn]. You can customize only
  /// certain properties, see more here [ChatL10nEn].
  final ChatL10n l10n;

  /// See [ChatList.bottomWidget]. For a custom chat input
  /// use [customBottomWidget] instead.
  final Widget? listBottomWidget;

  /// List of [types.Message] to render in the chat widget.
  final List<types.Message> messages;

  /// See [Message.nameBuilder].
  final Widget Function(String userId)? nameBuilder;

  /// See [Input.onAttachmentPressed].
  final VoidCallback? onAttachmentPressed;

  /// See [Message.onAvatarTap].
  final void Function(types.User)? onAvatarTap;

  /// Called when user taps on background.
  final VoidCallback? onBackgroundTap;

  /// See [ChatList.onEndReached].
  final Future<void> Function()? onEndReached;

  /// See [ChatList.onEndReachedThreshold].
  final double? onEndReachedThreshold;

  final Future<void> Function()? onHeaderReached;

  /// See [Message.onMessageDoubleTap].
  final void Function(BuildContext context, types.Message)? onMessageDoubleTap;

  /// See [Message.onMessageLongPress].
  final void Function(BuildContext context, types.Message)? onMessageLongPress;

  /// See [Message.onMessageStatusLongPress].
  final void Function(BuildContext context, types.Message)? onMessageStatusLongPress;

  /// See [Message.onMessageStatusTap].
  final void Function(BuildContext context, types.Message)? onMessageStatusTap;

  /// See [Message.onMessageTap].
  final void Function(BuildContext context, types.Message)? onMessageTap;

  /// See [Message.onMessageVisibilityChanged].
  final void Function(types.Message, bool visible)? onMessageVisibilityChanged;

  /// See [Message.onPreviewDataFetched].
  final void Function(types.TextMessage, PreviewData)? onPreviewDataFetched;

  final Function(types.AudioMessage)? onAudioDataFetched;

  /// See [Input.onSendPressed].
  final Future Function(types.PartialText) onSendPressed;

  final List<InputMoreItem> inputMoreItems;

  ///Send a voice message
  final void Function(String path, Duration duration)? onVoiceSend;

  ///Send a inserted content
  final void Function(KeyboardInsertedContent insertedContent)? onInsertedContent;

  ///Send a gif message
  final void Function(GiphyImage image)? onGifSend;

  /// See [ChatList.scrollController].
  /// If provided, you cannot use the scroll to message functionality.
  final AutoScrollController? scrollController;

  /// See [ChatList.scrollPhysics].
  final ScrollPhysics? scrollPhysics;

  /// Controls if and how the chat should scroll to the newest unread message.
  final ScrollToUnreadOptions scrollToUnreadOptions;

  /// Show user names for received messages. Useful for a group chat. Will be
  /// shown only on text messages.
  final bool showUserNames;

  /// Builds a system message outside of any bubble.
  final Widget Function(types.SystemMessage)? systemMessageBuilder;

  /// See [Message.textMessageBuilder].
  final Widget Function(
    types.TextMessage, {
    required int messageWidth,
    required bool showName,
  })? textMessageBuilder;

  /// See [Message.textMessageOptions].
  final TextMessageOptions textMessageOptions;

  /// Chat theme. Extend [ChatTheme] class to create your own theme or use
  /// existing one, like the [DefaultChatTheme]. You can customize only certain
  /// properties, see more here [DefaultChatTheme].
  final ChatTheme theme;

  /// Allows you to customize the time format. IMPORTANT: only for the time,
  /// do not return date here. See [dateFormat] to customize the date format.
  /// [dateLocale] will be ignored if you use this, so if you want a localized time
  /// make sure you initialize your [DateFormat] with a locale. See [customDateHeaderText]
  /// for more customization.
  final DateFormat? timeFormat;

  /// Used to show typing users with indicator. See [TypingIndicatorOptions].
  final TypingIndicatorOptions typingIndicatorOptions;

  /// See [Message.usePreviewData].
  final bool usePreviewData;

  /// See [InheritedUser.user].
  final types.User user;

  /// See [Message.userAgent].
  final String? userAgent;

  /// See [ChatList.useTopSafeAreaInset].
  final bool? useTopSafeAreaInset;

  /// See [Message.videoMessageBuilder].
  final Widget Function(types.VideoMessage, {required int messageWidth})? videoMessageBuilder;

  /// See [Message.repliedMessageBuilder].
  final Widget Function(types.Message, {required int messageWidth})? repliedMessageBuilder;

  /// Create a widget that pops up when long pressing on a message
  final Widget Function(
          BuildContext context, types.Message message, CustomPopupMenuController controller)?
      longPressWidgetBuilder;

  final Widget Function(types.Message, {required int messageWidth})? reactionViewBuilder;

  final Widget? inputBottomView;

  final ValueChanged<FocusNode>? onFocusNodeInitialized;

  final Function()? textFieldHasFocus;

  final Function(types.Message message, int? index)? messageHasBuilder;

  final bool isShowScrollToBottomButton;

  final Function(types.Message message)? replySwipeTriggerCallback;

  @override
  State<Chat> createState() => ChatState();
}

/// [Chat] widget state.
class ChatState extends State<Chat> {
  /// Used to get the correct auto scroll index from [_autoScrollIndexById].
  static const String _unreadHeaderId = 'unread_header_id';

  double get bottomThreshold => 100.px;
  List<Object> _chatMessages = [];
  bool _hadScrolledToUnreadOnOpen = false;

  bool isShowScrollToBottomButton = false;

  /// Keep track of all the auto scroll indices by their respective message's id to allow animating to them.
  final Map<String, int> _autoScrollIndexById = {};
  late final AutoScrollController _scrollController;
  final GlobalKey _bottomWidgetKey = GlobalKey();
  final GlobalKey<InputState> _inputKey = GlobalKey<InputState>();

  /// Key: [types.Message.id], Value: Message widget key
  final Map<String, GlobalKey<MessageState>> messageKeyMap = {};

  @override
  void initState() {
    super.initState();

    _scrollController = widget.scrollController ?? AutoScrollController();

    didUpdateWidget(widget);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant Chat oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.messages.isNotEmpty) {
      final result = calculateChatMessages(
        widget.messages,
        widget.user,
        customDateHeaderText: widget.customDateHeaderText,
        dateFormat: widget.dateFormat,
        dateHeaderThreshold: widget.dateHeaderThreshold,
        dateIsUtc: widget.dateIsUtc,
        dateLocale: widget.dateLocale,
        groupMessagesThreshold: widget.groupMessagesThreshold,
        lastReadMessageId: widget.scrollToUnreadOptions.lastReadMessageId,
        showUserNames: widget.showUserNames,
        timeFormat: widget.timeFormat,
      );

      _chatMessages = (result[0] as List<Object>).reversed.toList();

      _refreshAutoScrollMapping();
      _maybeScrollToFirstUnread();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Scroll to the unread header.
  void scrollToUnreadHeader() {
    final unreadHeaderIndex = _autoScrollIndexById[_unreadHeaderId];
    if (unreadHeaderIndex != null) {
      _scrollController.scrollToIndex(
        unreadHeaderIndex,
        duration: widget.scrollToUnreadOptions.scrollDuration,
      );
    }
  }

  /// Scroll to the message with the specified [id].
  Future scrollToMessage(String messageId, {Duration? duration}) async {
    await _scrollController.scrollToIndex(
      _autoScrollIndexById[messageId] ?? 0,
      duration: duration ?? scrollAnimationDuration,
      preferPosition: AutoScrollPosition.middle,
    );
    flashMessage(messageId);
  }

  void flashMessage(String messageId) {
    final widgetKey = messageKeyMap[messageId];
    if (widgetKey == null) return ;

    widgetKey.currentState?.flash();
  }

  @override
  Widget build(BuildContext context) {
    final anchorMsgId = widget.anchorMsgId;
    var scrollToAnchorMsgAction = null;
    if (anchorMsgId != null && anchorMsgId.isNotEmpty)
      scrollToAnchorMsgAction = () => scrollToMessage(anchorMsgId);
    final mentionUserListBottom = _getInputViewHeight() + Adapt.px(16);
    return InheritedUser(
      user: widget.user,
      child: InheritedChatTheme(
        theme: widget.theme,
        child: InheritedL10n(
          l10n: widget.l10n,
          child: Stack(
            children: [
              Container(
                color: ThemeColor.color200,
                child: Column(
                  children: [
                    if (widget.customTopWidget != null)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Adapt.px(12),
                        ),
                        child: widget.customTopWidget,
                      ),
                    Flexible(
                      child: widget.messages.isEmpty
                          ? SizedBox.expand(
                              child: GestureDetector(
                                child: _emptyStateBuilder(),
                                onTap: () {
                                  _inputKey.currentState?.dissMissMoreView();
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  widget.onBackgroundTap?.call();
                                },
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                _inputKey.currentState?.dissMissMoreView();
                                FocusManager.instance.primaryFocus?.unfocus();
                                widget.onBackgroundTap?.call();
                              },
                              child: NotificationListener<ScrollNotification>(
                                onNotification: (notification) {
                                  checkIfShowUnreadAnchorButton(notification);
                                  return false;
                                },
                                child: ChatList(
                                  scrollToAnchorMsgAction: scrollToAnchorMsgAction,
                                  bottomWidget: widget.listBottomWidget,
                                  bubbleRtlAlignment: widget.bubbleRtlAlignment!,
                                  isFirstPage: widget.isFirstPage,
                                  isLastPage: widget.isLastPage,
                                  itemBuilder: (Object item, int? index) => LayoutBuilder(
                                      builder: (
                                    BuildContext context,
                                    BoxConstraints constraints,
                                  ) =>
                                          IgnorePointer(
                                            ignoring: !widget.isContentInteractive,
                                            child: _messageBuilder(
                                              item,
                                              constraints,
                                              index,
                                            ),
                                          )),
                                  items: _chatMessages,
                                  keyboardDismissBehavior: widget.keyboardDismissBehavior,
                                  onEndReached: widget.onEndReached,
                                  onEndReachedThreshold: widget.onEndReachedThreshold,
                                  onHeadReached: widget.onHeaderReached,
                                  scrollController: _scrollController,
                                  scrollPhysics: widget.scrollPhysics,
                                  typingIndicatorOptions: widget.typingIndicatorOptions,
                                  useTopSafeAreaInset: widget.useTopSafeAreaInset ?? isMobile,
                                ),
                              ),
                            ),
                    ),
                    Visibility(
                      visible: widget.enableBottomWidget,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Adapt.px(12),
                        ),
                        child: widget.customBottomWidget ?? _buildBottomInputArea(),
                      ),
                    ),
                  ],
                ),
              ),
              widget.customCenterWidget ?? SizedBox(),
              if (widget.scrollToUnreadWidget != null)
                Positioned(
                  right: 12.px,
                  top: 50.px,
                  child: widget.scrollToUnreadWidget!,
                ),
              if (widget.scrollToBottomWidget != null &&
                  (widget.isShowScrollToBottomButton || isShowScrollToBottomButton))
                Positioned(
                  right: 12.px,
                  bottom: mentionUserListBottom,
                  child: widget.scrollToBottomWidget!,
                ),
              if (widget.mentionUserListWidget != null && mentionUserListBottom != null)
                Positioned(
                  left: 12.px,
                  right: 12.px,
                  bottom: mentionUserListBottom,
                  child: widget.mentionUserListWidget!,
                ),
            ],
          ),
        ),
      ),
    );
  }

  double? _getInputViewHeight() {
    if (!widget.enableBottomWidget) return 0.0;

    if (_bottomWidgetKey.currentContext != null) {
      final renderBox = _bottomWidgetKey.currentContext!.findRenderObject() as RenderBox;
      // Do not delete this line of code, or you will mention that the user list view does not fit the keyboard
      final _ = MediaQuery.of(context).size.height;
      final inputHeight = renderBox.size.height;
      return inputHeight;
    } else {
      return null;
    }
  }

  Widget _buildBottomInputArea() {
    final bottomHintParam = widget.bottomHintParam;
    return Stack(
      key: _bottomWidgetKey,
      children: [
        Visibility(
          visible: bottomHintParam != null,
          child: SafeArea(
            child: GestureDetector(
              onTap: bottomHintParam?.onTap,
              child: Container(
                decoration: BoxDecoration(
                  color: ThemeColor.color190,
                  borderRadius: BorderRadius.circular(Adapt.px(12)),
                ),
                margin: EdgeInsets.only(bottom: Adapt.px(10)),
                height: Adapt.px(58),
                alignment: Alignment.center,
                child: Text(
                  bottomHintParam?.text ?? '',
                  style: TextStyle(
                    color: ThemeColor.gradientMainStart,
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: bottomHintParam == null,
          child: Input(
            key: _inputKey,
            chatId: widget.chatId,
            items: widget.inputMoreItems,
            isAttachmentUploading: widget.isAttachmentUploading,
            onAttachmentPressed: widget.onAttachmentPressed,
            onSendPressed: widget.onSendPressed,
            options: widget.inputOptions,
            onVoiceSend: widget.onVoiceSend,
            onGifSend: widget.onGifSend,
            textFieldHasFocus: () {
              widget.textFieldHasFocus?.call();
            },
            inputBottomView: widget.inputBottomView,
            onFocusNodeInitialized: widget.onFocusNodeInitialized,
            onInsertedContent: widget.onInsertedContent,
          ),
        ),
      ],
    );
  }

  Widget _emptyStateBuilder() =>
      widget.emptyState ??
      Container(
        color: ThemeColor.color200,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Text(
          // widget.l10n.emptyChatPlaceholder,
          '',
          style: widget.theme.emptyChatPlaceholderTextStyle,
          textAlign: TextAlign.center,
        ),
      );

  /// Only scroll to first unread if there are messages and it is the first open.
  void _maybeScrollToFirstUnread() {
    if (widget.scrollToUnreadOptions.scrollOnOpen &&
        _chatMessages.isNotEmpty &&
        !_hadScrolledToUnreadOnOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (mounted) {
          await Future.delayed(widget.scrollToUnreadOptions.scrollDelay);
          scrollToUnreadHeader();
        }
      });
      _hadScrolledToUnreadOnOpen = true;
    }
  }

  /// We need the index for auto scrolling because it will scroll until it reaches an index higher or equal that what it is scrolling towards. Index will be null for removed messages. Can just set to -1 for auto scroll.
  Widget _messageBuilder(
    Object object,
    BoxConstraints constraints,
    int? index,
  ) {
    if (object is DateHeader) {
      return AutoScrollTag(
        controller: _scrollController,
        index: index ?? -1,
        key: Key('DateHeader-${object.id}'),
        child: widget.dateHeaderBuilder?.call(object) ??
            Container(
              alignment: Alignment.center,
              margin: widget.theme.dateDividerMargin,
              child: Text(
                object.text,
                style: widget.theme.dateDividerTextStyle,
              ),
            ),
      );
    } else if (object is MessageSpacer) {
      return AutoScrollTag(
        controller: _scrollController,
        index: index ?? -1,
        key: Key('MessageSpacer-${object.id}'),
        child: SizedBox(
          height: object.height,
        ),
      );
    } else if (object is UnreadHeaderData) {
      return AutoScrollTag(
        controller: _scrollController,
        index: index ?? -1,
        key: const Key('unread_header'),
        child: UnreadHeader(
          marginTop: object.marginTop,
        ),
      );
    } else {
      final map = object as Map<String, Object>;
      final message = map['message']! as types.Message;

      final Widget messageWidget;

      widget.messageHasBuilder?.call(message, index);

      if (message is types.SystemMessage) {
        messageWidget =
            widget.systemMessageBuilder?.call(message) ?? SystemMessage(message: message.text);
      } else {
        final messageWidth = constraints.maxWidth.floor();

        final messageId = message.id;
        final messageRemoteId = message.remoteId;

        final widgetKey = messageKeyMap.putIfAbsent(messageId, () => GlobalKey());
        if (messageId != messageRemoteId && messageRemoteId != null && messageRemoteId.isNotEmpty) {
          messageKeyMap[messageRemoteId] = widgetKey;
        }

        messageWidget = Message(
          key: widgetKey,
          audioMessageBuilder: widget.audioMessageBuilder,
          avatarBuilder: widget.avatarBuilder,
          bubbleBuilder: widget.bubbleBuilder,
          bubbleRtlAlignment: widget.bubbleRtlAlignment,
          customMessageBuilder: widget.customMessageBuilder,
          customStatusBuilder: widget.customStatusBuilder,
          emojiEnlargementBehavior: widget.emojiEnlargementBehavior,
          fileMessageBuilder: widget.fileMessageBuilder,
          hideBackgroundOnEmojiMessages: widget.hideBackgroundOnEmojiMessages,
          imageHeaders: widget.imageHeaders,
          imageMessageBuilder: widget.imageMessageBuilder,
          message: message,
          messageWidth: messageWidth,
          nameBuilder: widget.nameBuilder,
          onAvatarTap: widget.onAvatarTap,
          onMessageDoubleTap: widget.onMessageDoubleTap,
          onMessageLongPress: widget.onMessageLongPress,
          onMessageStatusLongPress: widget.onMessageStatusLongPress,
          onMessageStatusTap: widget.onMessageStatusTap,
          onMessageTap: widget.onMessageTap,
          onMessageVisibilityChanged: widget.onMessageVisibilityChanged,
          onPreviewDataFetched: _onPreviewDataFetched,
          onAudioDataFetched: widget.onAudioDataFetched,
          roundBorder: map['nextMessageInGroup'] == true,
          showAvatar: map['nextMessageInGroup'] == false,
          // showName: map['showName'] == true,
          showName: widget.showUserNames,
          showStatus: map['showStatus'] == true,
          textMessageBuilder: widget.textMessageBuilder,
          textMessageOptions: widget.textMessageOptions,
          usePreviewData: widget.usePreviewData,
          userAgent: widget.userAgent,
          videoMessageBuilder: widget.videoMessageBuilder,
          repliedMessageBuilder: widget.repliedMessageBuilder,
          longPressWidgetBuilder: widget.longPressWidgetBuilder,
          reactionViewBuilder: widget.reactionViewBuilder,
          replySwipeTriggerCallback: widget.replySwipeTriggerCallback,
        );
      }
      return AutoScrollTag(
        controller: _scrollController,
        index: index ?? -1,
        key: Key('scroll-${message.id}'),
        child: messageWidget,
      );
    }
  }

  void _onPreviewDataFetched(
    types.TextMessage message,
    PreviewData previewData,
  ) {
    widget.onPreviewDataFetched?.call(message, previewData);
  }

  /// Updates the [_autoScrollIndexById] mapping with the latest messages.
  void _refreshAutoScrollMapping() {
    _autoScrollIndexById.clear();
    var i = 0;
    for (final object in _chatMessages) {
      if (object is UnreadHeaderData) {
        _autoScrollIndexById[_unreadHeaderId] = i;
      } else if (object is Map<String, Object>) {
        final message = object['message']! as types.Message;
        _autoScrollIndexById[message.id] = i;
      }
      i++;
    }
  }

  void checkIfShowUnreadAnchorButton(ScrollNotification notification) {
    final isShowScrollToBottomButton = notification.metrics.pixels > bottomThreshold;
    if (this.isShowScrollToBottomButton != isShowScrollToBottomButton) {
      setState(() {
        this.isShowScrollToBottomButton = isShowScrollToBottomButton;
      });
    }
  }
}
