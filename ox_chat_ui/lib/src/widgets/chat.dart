import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:intl/intl.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/web_url_helper.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:photo_view/photo_view.dart' show PhotoViewComputedScale;
import 'package:scroll_to_index/scroll_to_index.dart';

import '../chat_l10n.dart';
import '../chat_theme.dart';
import '../models/bubble_rtl_alignment.dart';
import '../models/date_header.dart';
import '../models/emoji_enlargement_behavior.dart';
import '../models/giphy_image.dart';
import '../models/message_spacer.dart';
import '../models/preview_image.dart';
import '../models/unread_header_data.dart';
import '../util.dart';
import 'chat_list.dart';
import 'image_gallery.dart';
import 'input/input.dart';
import 'input/input_more_page.dart';
import 'message/message.dart';
import 'message/system_message.dart';
import 'message/text_message.dart';
import 'state/inherited_chat_theme.dart';
import 'state/inherited_l10n.dart';
import 'state/inherited_user.dart';
import 'typing_indicator.dart';
import 'unread_header.dart';

enum ChatStatus {
  Unknown,
  NotJoined,
  NotJoinedGroup,
  RequestGroup,
  NotContact,
  InsufficientBadge,
  Normal,
}

/// Entry widget, represents the complete chat. If you wrap it in [SafeArea] and
/// it should be full screen, set [SafeArea]'s `bottom` to `false`.
class Chat extends StatefulWidget {
  /// Creates a chat widget.
  const Chat({
    super.key,
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
    this.onMessageLongPressEvent,
    this.chatStatus,
    this.onJoinChannelTap,
    this.onJoinGroupTap,
    this.onRequestGroupTap,
    this.longPressMenuItemsCreator,
    this.onGifSend,
    this.inputBottomView,
    this.mentionUserListWidget,
    this.onFocusNodeInitialized,
    this.onInsertedContent,
  });

  final ChatStatus? chatStatus;
  final void Function()? onJoinChannelTap;
  final void Function()? onJoinGroupTap;
  final void Function()? onRequestGroupTap;

  /// See [Message.audioMessageBuilder].
  final Widget Function(types.AudioMessage, {required int messageWidth})?
      audioMessageBuilder;

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
  final Widget Function(types.CustomMessage, {required int messageWidth})?
      customMessageBuilder;

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
  final Widget Function(types.FileMessage, {required int messageWidth})?
      fileMessageBuilder;

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
  final Widget Function(types.ImageMessage, {required int messageWidth})?
      imageMessageBuilder;

  /// See [Input.options].
  final InputOptions inputOptions;

  /// See [Input.isAttachmentUploading].
  final bool? isAttachmentUploading;

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

  /// See [Message.onMessageDoubleTap].
  final void Function(BuildContext context, types.Message)? onMessageDoubleTap;

  /// See [Message.onMessageLongPress].
  final void Function(BuildContext context, types.Message)? onMessageLongPress;

  /// See [Message.onMessageStatusLongPress].
  final void Function(BuildContext context, types.Message)?
      onMessageStatusLongPress;

  /// See [Message.onMessageStatusTap].
  final void Function(BuildContext context, types.Message)? onMessageStatusTap;

  /// See [Message.onMessageTap].
  final void Function(BuildContext context, types.Message)? onMessageTap;

  /// See [Message.onMessageVisibilityChanged].
  final void Function(types.Message, bool visible)? onMessageVisibilityChanged;

  /// See [Message.onPreviewDataFetched].
  final void Function(types.TextMessage, PreviewData)?
      onPreviewDataFetched;

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
  final Widget Function(types.VideoMessage, {required int messageWidth})?
      videoMessageBuilder;

  /// See [Message.repliedMessageBuilder].
  final Widget Function(types.Message, {required int messageWidth})?
  repliedMessageBuilder;

  ///Called  when the menu items clicked after a long press‘
  final void Function(types.Message, MessageLongPressEventType type, String? emoji)? onMessageLongPressEvent;

  /// Create a menu that pops up when long pressing on a message
  final List<ItemModel> Function(BuildContext context, types.Message message)? longPressMenuItemsCreator;

  final Widget? inputBottomView;

  final ValueChanged<FocusNode>? onFocusNodeInitialized;

  @override
  State<Chat> createState() => ChatState();
}

/// [Chat] widget state.
class ChatState extends State<Chat> {
  /// Used to get the correct auto scroll index from [_autoScrollIndexById].
  static const String _unreadHeaderId = 'unread_header_id';

  List<Object> _chatMessages = [];
  List<PreviewImage> _gallery = [];
  PageController? _galleryPageController;
  bool _hadScrolledToUnreadOnOpen = false;
  final bool _isImageViewVisible = false;

  /// Keep track of all the auto scroll indices by their respective message's id to allow animating to them.
  final Map<String, int> _autoScrollIndexById = {};
  late final AutoScrollController _scrollController;
  final GlobalKey<InputState> _inputKey = GlobalKey<InputState>();

  @override
  void initState() {
    super.initState();

    _scrollController = widget.scrollController ?? AutoScrollController();

    didUpdateWidget(widget);
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
      _gallery = result[1] as List<PreviewImage>;

      _refreshAutoScrollMapping();
      _maybeScrollToFirstUnread();
    }
  }

  @override
  void dispose() {
    _galleryPageController?.dispose();
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
  void scrollToMessage(String id, {Duration? duration}) =>
      _scrollController.scrollToIndex(
        _autoScrollIndexById[id] ?? 0,
        duration: duration ?? scrollAnimationDuration,
      );

  @override
  Widget build(BuildContext context) {
    final anchorMsgId = widget.anchorMsgId;
    var scrollToAnchorMsgAction = null;
    if (anchorMsgId != null && anchorMsgId.isNotEmpty)
      scrollToAnchorMsgAction = () => scrollToMessage(anchorMsgId);
    final mentionUserListBottom = _getBottomOffsetForMentionUserList();
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
                    widget.chatStatus == ChatStatus.NotContact
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: Adapt.px(12),
                            ),
                            child: widget.customTopWidget ?? SizedBox(),
                          )
                        : SizedBox(),
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
                        ),)
                          : GestureDetector(
                        onTap: () {
                          _inputKey.currentState?.dissMissMoreView();
                          FocusManager.instance.primaryFocus?.unfocus();
                          widget.onBackgroundTap?.call();
                        },
                        child: ChatList(
                          scrollToAnchorMsgAction: scrollToAnchorMsgAction,
                          bottomWidget: widget.listBottomWidget,
                          bubbleRtlAlignment:
                          widget.bubbleRtlAlignment!,
                          isLastPage: widget.isLastPage,
                          itemBuilder: (Object item, int? index) =>
                              LayoutBuilder(
                                  builder: (BuildContext context,
                                      BoxConstraints constraints,) =>
                                      _messageBuilder(
                                        item,
                                        constraints,
                                        index,
                                      )),
                          items: _chatMessages,
                          keyboardDismissBehavior:
                          widget.keyboardDismissBehavior,
                          onEndReached: widget.onEndReached,
                          onEndReachedThreshold:
                          widget.onEndReachedThreshold,
                          scrollController: _scrollController,
                          scrollPhysics: widget.scrollPhysics,
                          typingIndicatorOptions:
                          widget.typingIndicatorOptions,
                          useTopSafeAreaInset:
                          widget.useTopSafeAreaInset ?? isMobile,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Adapt.px(12),),
                      child: widget.customBottomWidget ?? _buildBottomInputArea(),
                    ),
                  ],
                ),
              ),
              widget.customCenterWidget != null ? widget.customCenterWidget! :  SizedBox(),
              if (widget.mentionUserListWidget != null && mentionUserListBottom != null)
                Positioned(
                  left: Adapt.px(12),
                  right: Adapt.px(12),
                  bottom: mentionUserListBottom,
                  child: widget.mentionUserListWidget!,
                ),
            ],
          ),
        ),
      ),
    );
  }

  double? _getBottomOffsetForMentionUserList() {
    if (_inputKey.currentContext != null) {
      final renderBox = _inputKey.currentContext!.findRenderObject() as RenderBox;
      // Do not delete this line of code, or you will mention that the user list view does not fit the keyboard
      final _ = MediaQuery.of(context).size.height;
      final inputHeight = renderBox.size.height;
      return inputHeight + Adapt.px(16);
    } else {
      return null;
    }
  }

    Widget _buildBottomInputArea() {
      final chatStatus = widget.chatStatus;
      Widget container({required Widget child}) => SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: ThemeColor.color190,
            borderRadius: BorderRadius.circular(Adapt.px(12)),
          ),
          margin: EdgeInsets.only(bottom: Adapt.px(10)),
          height: Adapt.px(58),
          child: child,
        ),
      );
      if (chatStatus == ChatStatus.NotJoined) {
        return GestureDetector(
          child: container(
            child: Container(
              alignment:Alignment.center,
              child: Text(
                Localized.text('ox_chat_ui.channel_join'),
                style: TextStyle(color: ThemeColor.gradientMainStart),
              ),
            ),
          ),
          onTap: (){
            widget.onJoinChannelTap?.call();
          },
        );
      }
      else if (chatStatus == ChatStatus.NotJoinedGroup) {
        return GestureDetector(
          child: container(
            child: Container(
              alignment:Alignment.center,
              child: Text(
                Localized.text('ox_chat_ui.group_join'),
                style: TextStyle(color: ThemeColor.gradientMainStart),
              ),
            ),
          ),
          onTap: (){
            widget.onJoinGroupTap?.call();
          },
        );
      }
      else if (chatStatus == ChatStatus.RequestGroup) {
        return GestureDetector(
          child: container(
            child: Container(
              alignment:Alignment.center,
              child: Text(
                Localized.text('ox_chat_ui.group_request'),
                style: TextStyle(color: ThemeColor.gradientMainStart),
              ),
            ),
          ),
          onTap: (){
            widget.onRequestGroupTap?.call();
          },
        );
      }
      else if (chatStatus == ChatStatus.InsufficientBadge) {
        final text = chatStatus == ChatStatus.InsufficientBadge ?
        Localized.text('ox_chat_ui.channel_badge_requirements') :
        Localized.text('ox_chat_ui.friend_requirements');
        return container(
          child: Container(
            alignment:Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: Adapt.px(56)),
            child: Text(
              text,
              style: TextStyle(color: ThemeColor.color100, fontSize: Adapt.px(12)),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else {
        return Input(
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
            if (_scrollController.hasClients && _scrollController.offset > 0) {
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 10),
                curve: Curves.easeInQuad,
              );
            }
          },
          inputBottomView: widget.inputBottomView,
          onFocusNodeInitialized: widget.onFocusNodeInitialized,
          onInsertedContent: widget.onInsertedContent,
        );
      }
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
        return widget.dateHeaderBuilder?.call(object) ??
            Container(
              alignment: Alignment.center,
              margin: widget.theme.dateDividerMargin,
              child: Text(
                object.text,
                style: widget.theme.dateDividerTextStyle,
              ),
            );
      } else if (object is MessageSpacer) {
        return SizedBox(
          height: object.height,
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
        final showUserAvatars = widget.avatarBuilder != null;

        if (message is types.SystemMessage) {
          messageWidget = widget.systemMessageBuilder?.call(message) ??
              SystemMessage(message: message.text);
        } else {
          final messageWidth = showUserAvatars && message.author.id != widget.user.id
              ? min(constraints.maxWidth * 0.72, Adapt.px(250)).floor()
              : min(constraints.maxWidth * 0.78, Adapt.px(250)).floor();

          messageWidget = Message(
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
              onMessageTap: (context, tappedMessage) {
                if (tappedMessage is types.ImageMessage &&
                    widget.disableImageGallery != true) {
                  _onImagePressed(tappedMessage);
                }

                widget.onMessageTap?.call(context, tappedMessage);
              },
              onMessageVisibilityChanged: widget.onMessageVisibilityChanged,
              onPreviewDataFetched: _onPreviewDataFetched,
              onAudioDataFetched: widget.onAudioDataFetched,
              roundBorder: map['nextMessageInGroup'] == true,
              showAvatar: map['nextMessageInGroup'] == false,
              // showName: map['showName'] == true,
              showName:widget.showUserNames,
              showStatus: map['showStatus'] == true,
              textMessageBuilder: widget.textMessageBuilder,
              textMessageOptions: widget.textMessageOptions,
              usePreviewData: widget.usePreviewData,
              userAgent: widget.userAgent,
              videoMessageBuilder: widget.videoMessageBuilder,
              repliedMessageBuilder: widget.repliedMessageBuilder,
              onMessageLongPressEvent:widget.onMessageLongPressEvent,
              longPressMenuItemsCreator: widget.longPressMenuItemsCreator,
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

    void _onCloseGalleryPressed() {
      // setState(() {
      //   _isImageViewVisible = false;
      // });
      OXNavigator.pop(context);
      _galleryPageController?.dispose();
      _galleryPageController = null;
    }

    void _onImagePressed(types.ImageMessage message) {
      final initialPage = _gallery.indexWhere(
            (element) => element.id == message.id && element.uri == message.uri,
      );
      _galleryPageController = PageController(initialPage: initialPage);
      OXNavigator.presentPage(context, (context) => ImageGallery(
        imageHeaders: widget.imageHeaders,
        images: _gallery,
        pageController: _galleryPageController!,
        onClosePressed: _onCloseGalleryPressed,
        options: widget.imageGalleryOptions,
      ));


      // setState(() {
      //   _isImageViewVisible = true;
      // });
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
  }

