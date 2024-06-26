
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/web_url_helper.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../ox_chat_ui.dart';
import '../../util.dart';
import '../pop_menu/custom_pop_up_menu.dart';
import '../state/inherited_chat_theme.dart';
import '../state/inherited_user.dart';
import 'audio_message_page.dart';
import 'video_message.dart';


/// Base widget for all message types in the chat. Renders bubbles around
/// messages and status. Sets maximum width for a message for
/// a nice look on larger screens.

class Message extends StatefulWidget {
  Message({
    super.key,
    this.audioMessageBuilder,
    this.avatarBuilder,
    this.bubbleBuilder,
    this.bubbleRtlAlignment,
    this.customMessageBuilder,
    this.customStatusBuilder,
    required this.emojiEnlargementBehavior,
    this.fileMessageBuilder,
    required this.hideBackgroundOnEmojiMessages,
    this.imageHeaders,
    this.imageMessageBuilder,
    required this.message,
    required this.messageWidth,
    this.nameBuilder,
    this.onAvatarTap,
    this.onMessageDoubleTap,
    this.onMessageLongPress,
    this.onMessageStatusLongPress,
    this.onMessageStatusTap,
    this.onMessageTap,
    this.onMessageVisibilityChanged,
    this.onPreviewDataFetched,
    this.onAudioDataFetched,
    required this.roundBorder,
    required this.showAvatar,
    required this.showName,
    required this.showStatus,
    this.textMessageBuilder,
    required this.textMessageOptions,
    required this.usePreviewData,
    this.userAgent,
    this.videoMessageBuilder,
    this.repliedMessageBuilder,
    this.longPressWidgetBuilder,
    this.reactionViewBuilder,
  });

  /// Build an audio message inside predefined bubble.
  final Widget Function(types.AudioMessage, {required int messageWidth})?
  audioMessageBuilder;

  /// Represents a widget for a user's avatar.
  ///
  /// If [avatarWidget] is `null`, the avatar will be hidden.
  final Widget Function(types.Message message)? avatarBuilder;

  /// Customize the default bubble using this function. `child` is a content
  /// you should render inside your bubble, `message` is a current message
  /// (contains `author` inside) and `nextMessageInGroup` allows you to see
  /// if the message is a part of a group (messages are grouped when written
  /// in quick succession by the same author)
  final Widget Function(
      Widget child, {
      required types.Message message,
      required bool nextMessageInGroup,
      })? bubbleBuilder;

  /// Determine the alignment of the bubble for RTL languages. Has no effect
  /// for the LTR languages.
  final BubbleRtlAlignment? bubbleRtlAlignment;

  /// Build a custom message inside predefined bubble.
  final Widget Function({
    required types.CustomMessage message,
    required int messageWidth,
    required Widget reactionWidget,
  })? customMessageBuilder;

  /// Build a custom status widgets.
  final Widget Function(types.Message message, {required BuildContext context})?
  customStatusBuilder;

  /// Controls the enlargement behavior of the emojis in the
  /// [types.TextMessage].
  /// Defaults to [EmojiEnlargementBehavior.multi].
  final EmojiEnlargementBehavior emojiEnlargementBehavior;

  /// Build a file message inside predefined bubble.
  final Widget Function(types.FileMessage, {required int messageWidth})?
  fileMessageBuilder;

  /// Hide background for messages containing only emojis.
  final bool hideBackgroundOnEmojiMessages;

  /// See [Chat.imageHeaders].
  final Map<String, String>? imageHeaders;

  /// Build an image message inside predefined bubble.
  final Widget Function(types.ImageMessage, {required int messageWidth})?
  imageMessageBuilder;

  /// Any message type.
  final types.Message message;

  /// Maximum message width.
  final int messageWidth;

  /// See [TextMessage.nameBuilder].
  final Widget Function(String userId)? nameBuilder;

  /// See [UserAvatar.onAvatarTap].
  final void Function(types.User)? onAvatarTap;

  /// Called when user double taps on any message.
  final void Function(BuildContext context, types.Message)? onMessageDoubleTap;

  /// Called when user makes a long press on any message.
  final void Function(BuildContext context, types.Message)? onMessageLongPress;

  /// Called when user makes a long press on status icon in any message.
  final void Function(BuildContext context, types.Message)?
  onMessageStatusLongPress;

  /// Called when user taps on status icon in any message.
  final void Function(BuildContext context, types.Message)? onMessageStatusTap;

  /// Called when user taps on any message.
  final void Function(BuildContext context, types.Message)? onMessageTap;

  /// Called when the message's visibility changes.
  final void Function(types.Message, bool visible)? onMessageVisibilityChanged;

  /// See [TextMessage.onPreviewDataFetched].
  final void Function(types.TextMessage, PreviewData)?
  onPreviewDataFetched;

  final Function(types.AudioMessage)? onAudioDataFetched;

  /// Rounds border of the message to visually group messages together.
  final bool roundBorder;

  /// Show user avatar for the received message. Useful for a group chat.
  final bool showAvatar;

  /// See [TextMessage.showName].
  final bool showName;

  /// Show message's status.
  final bool showStatus;

  /// Build a text message inside predefined bubble.
  final Widget Function(
      types.TextMessage, {
      required int messageWidth,
      required bool showName,
      })? textMessageBuilder;

  /// See [TextMessage.options].
  final TextMessageOptions textMessageOptions;

  /// See [TextMessage.usePreviewData].
  final bool usePreviewData;

  /// See [TextMessage.userAgent].
  final String? userAgent;

  /// Build an audio message inside predefined bubble.
  final Widget Function(types.VideoMessage, {required int messageWidth})?
  videoMessageBuilder;

  final Widget Function(types.Message, {required int messageWidth})?
  repliedMessageBuilder;

  final Widget Function(types.Message, {required int messageWidth})?
  reactionViewBuilder;

  /// Create a widget that pops up when long pressing on a message
  final Widget Function(BuildContext context, types.Message, CustomPopupMenuController controller)? longPressWidgetBuilder;

  @override
  State<Message> createState() => _MessageState();
}



class _MessageState extends State<Message> {

  final CustomPopupMenuController _popController = CustomPopupMenuController();

  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);
    final user = InheritedUser.of(context).user;
    final currentUserIsAuthor = user.id == widget.message.author.id;

    AlignmentGeometry? alignment;
    if (widget.bubbleRtlAlignment == BubbleRtlAlignment.left) {
      if (currentUserIsAuthor) {
        alignment = AlignmentDirectional.centerEnd;
      } else {
        alignment = AlignmentDirectional.centerStart;
      }
    } else {
      if (currentUserIsAuthor) {
        alignment = Alignment.centerRight;
      } else {
        alignment = Alignment.centerLeft;
      }
    }

    EdgeInsetsGeometry? margin;
    if (widget.bubbleRtlAlignment == BubbleRtlAlignment.left) {
      margin = EdgeInsetsDirectional.only(
        bottom: 16,
        end: isMobile ? query.padding.right : 0,
        start: 20 + (isMobile ? query.padding.left : 0),
      );
    } else {
      margin = EdgeInsets.only(
        bottom: 16,
        left: 20 + (isMobile ? query.padding.left : 0),
        right: isMobile ? query.padding.right : 0,
      );
    }

    return Container(
      alignment: alignment,
      margin: margin,
      child: _buildMessageContentView(),
    );
  }

  // avatar & name & message
  Widget _buildMessageContentView() {
    final user = InheritedUser.of(context).user;
    final currentUserIsAuthor = user.id == widget.message.author.id;
    final avatarBuilder = widget.avatarBuilder;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      textDirection: widget.bubbleRtlAlignment == BubbleRtlAlignment.left
          ? null
          : TextDirection.ltr,
      children: [
        if (!currentUserIsAuthor && avatarBuilder != null) _avatarBuilder(avatarBuilder(widget.message)),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: widget.messageWidth.toDouble(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMessageBubbleView(),
            ],
          ),
        ),
        if (currentUserIsAuthor)
          Padding(
            padding: EdgeInsets.only(right: 10),
          ),
        if (currentUserIsAuthor && avatarBuilder != null) _avatarBuilder(avatarBuilder(widget.message)),
      ],
    );
  }

  // name & message
  Widget _buildMessageBubbleView() {
    final user = InheritedUser.of(context).user;
    final currentUserIsAuthor = user.id == widget.message.author.id;
    final messageBorderRadius =
        InheritedChatTheme.of(context).theme.messageBorderRadius;
    final borderRadius = widget.bubbleRtlAlignment == BubbleRtlAlignment.left
        ? BorderRadiusDirectional.only(
      bottomEnd: Radius.circular(
        !currentUserIsAuthor || widget.roundBorder ? messageBorderRadius : 0,
      ),
      bottomStart: Radius.circular(
        currentUserIsAuthor || widget.roundBorder ? messageBorderRadius : 0,
      ),
      topEnd: Radius.circular(messageBorderRadius),
      topStart: Radius.circular(messageBorderRadius),
    )
        : BorderRadius.only(
      bottomLeft: Radius.circular(
        messageBorderRadius,
      ),
      bottomRight: Radius.circular(
        messageBorderRadius,
      ),
      topLeft:
      Radius.circular(currentUserIsAuthor ? messageBorderRadius : 0),
      topRight:
      Radius.circular(currentUserIsAuthor ? 0 : messageBorderRadius),
    );
    final enlargeEmojis =
        widget.emojiEnlargementBehavior != EmojiEnlargementBehavior.never &&
            widget.message is types.TextMessage &&
            isConsistsOfEmojis(
              widget.emojiEnlargementBehavior,
              widget.message as types.TextMessage,
            );
    final bubbleWithPopupMenu = CustomPopupMenu(
      controller: _popController,
      arrowColor: ThemeColor.color180,
      menuBuilder: _buildLongPressMenu,
      pressType: PressType.longPress,
      child: _bubbleBuilder(
        context,
        borderRadius.resolve(Directionality.of(context)),
        currentUserIsAuthor,
        enlargeEmojis,
      )
    );

    final bubbleWithName = Column(
      crossAxisAlignment: currentUserIsAuthor
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        if (widget.showName)
          UserName(author: widget.message.author),
        bubbleWithPopupMenu,
      ],
    );

    return GestureDetector(
      onDoubleTap: () => widget.onMessageDoubleTap?.call(context, widget.message),
      onLongPress: () => widget.onMessageLongPress?.call(context, widget.message),
      onTap: () => widget.onMessageTap?.call(context, widget.message),
      child: widget.onMessageVisibilityChanged != null
          ? _buildWithVisibilityDetector(child: bubbleWithName)
          : bubbleWithName,
    );
  }

  Widget _buildWithVisibilityDetector({required Widget child}) => VisibilityDetector(
      key: Key(widget.message.id),
      onVisibilityChanged: (visibilityInfo) =>
          widget.onMessageVisibilityChanged!(
            widget.message,
            visibilityInfo.visibleFraction > 0.1,
          ),
      child: child,
    );

  Widget _buildLongPressMenu() =>
      widget.longPressWidgetBuilder?.call(context, widget.message, _popController) ?? const SizedBox();

  Widget _avatarBuilder(Widget child) {
    final avatarBuilder = widget.avatarBuilder;
    if (avatarBuilder == null) return SizedBox();
    return Container(
      margin: widget.bubbleRtlAlignment == BubbleRtlAlignment.left
          ? const EdgeInsetsDirectional.only(end: 8)
          : const EdgeInsets.only(right: 8),
      child: avatarBuilder(widget.message),
    );
  }

  Widget _bubbleBuilder(BuildContext context, BorderRadius borderRadius, bool currentUserIsAuthor, bool enlargeEmojis) {

    Widget bubble;

    final useBubbleBg = !widget.message.viewWithoutBubble;

    if (widget.bubbleBuilder != null) {
      bubble = widget.bubbleBuilder!(
        _messageBuilder(context),
        message: widget.message,
        nextMessageInGroup: widget.roundBorder,
      );
    } else if (enlargeEmojis && widget.hideBackgroundOnEmojiMessages) {
      bubble = _messageBuilder(context);
    } else {
      bubble = Container(
        decoration: useBubbleBg ? BoxDecoration(
          borderRadius: borderRadius,
          gradient: currentUserIsAuthor ? LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              ThemeColor.gradientMainEnd,
              ThemeColor.gradientMainStart
            ],
          ) : null,
          color: ThemeColor.color180,
        ) : null,
        child: ClipRRect(
          borderRadius: borderRadius,
          child: _messageBuilder(context, useBubbleBg),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (currentUserIsAuthor)
          Padding(
            padding: EdgeInsets.only(right: Adapt.px(8),),
            child: GestureDetector(
              onLongPress: () =>
                  widget.onMessageStatusLongPress?.call(context, widget.message),
              onTap: () {
                if (widget.message.status == types.Status.error) {
                  widget.onMessageStatusTap?.call(context, widget.message);
                }
              },
              child: widget.customStatusBuilder?.call(widget.message, context: context)
                  ?? MessageStatus(status: widget.message.status),
            ),
          ),
        if (widget.message.repliedMessage == null)
          Flexible(child: bubble,)
        else
          Flexible(
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: currentUserIsAuthor ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  bubble,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: widget.repliedMessageBuilder?.call(
                      widget.message,
                      messageWidth: widget.messageWidth,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _messageBuilder(BuildContext context, [bool addReaction = false]) {
    Widget messageContentWidget;
    switch (widget.message.type) {
      case types.MessageType.audio:
        final audioMessage = widget.message as types.AudioMessage;
        messageContentWidget = widget.audioMessageBuilder?.call(
          audioMessage,
          messageWidth: widget.messageWidth,
        ) ?? AudioMessagePage(
              message: audioMessage,
              fetchAudioFile: widget.onAudioDataFetched,
              onPlay: (message) {
                widget.onMessageTap?.call(context, message);
              },
            );
        break ;
      case types.MessageType.custom:
        final customMessage = widget.message as types.CustomMessage;
        messageContentWidget = widget.customMessageBuilder?.call(
          message: customMessage,
          messageWidth: widget.messageWidth,
          reactionWidget: _reactionViewBuilder(),
        ) ?? const SizedBox();
        break ;
      case types.MessageType.file:
        final fileMessage = widget.message as types.FileMessage;
        messageContentWidget = widget.fileMessageBuilder?.call(
          fileMessage,
          messageWidth: widget.messageWidth,
        ) ?? FileMessage(message: fileMessage);
        break ;
      case types.MessageType.image:
        final imageMessage = widget.message as types.ImageMessage;
        messageContentWidget = widget.imageMessageBuilder?.call(
          imageMessage,
          messageWidth: widget.messageWidth,
        ) ?? ImageMessage(
              imageHeaders: widget.imageHeaders,
              message: imageMessage,
              messageWidth: widget.messageWidth,
            );
        break ;
      case types.MessageType.text:
        final textMessage = widget.message as types.TextMessage;
        messageContentWidget = widget.textMessageBuilder?.call(
          textMessage,
          messageWidth: widget.messageWidth,
          showName: widget.showName,
        ) ?? TextMessage(
          emojiEnlargementBehavior: widget.emojiEnlargementBehavior,
          hideBackgroundOnEmojiMessages: widget.hideBackgroundOnEmojiMessages,
          message: textMessage,
          nameBuilder: widget.nameBuilder,
          onPreviewDataFetched: widget.onPreviewDataFetched,
          options: widget.textMessageOptions,
          showName: widget.showName,
          usePreviewData: widget.usePreviewData,
          userAgent: widget.userAgent,
        );
        break ;
      case types.MessageType.video:
        final videoMessage = widget.message as types.VideoMessage;
        messageContentWidget = widget.videoMessageBuilder?.call(
          videoMessage,
          messageWidth: widget.messageWidth,
        ) ?? VideoMessage(
              imageHeaders: widget.imageHeaders,
              message: videoMessage,
              messageWidth: widget.messageWidth,
            );
        break ;
      default:
        return const SizedBox();
    }

    if (addReaction) {
      messageContentWidget = _reactionWrapper(messageContentWidget);
    }

    return messageContentWidget;
  }

  Widget _reactionWrapper(Widget content) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      content,
      _reactionViewBuilder(),
    ],
  );

  Widget _reactionViewBuilder() => widget.reactionViewBuilder?.call(
    widget.message,
    messageWidth: widget.messageWidth,
  ) ?? const SizedBox();
}

