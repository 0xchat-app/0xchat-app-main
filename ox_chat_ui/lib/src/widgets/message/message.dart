
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/took_kit.dart';
import 'package:ox_common/utils/web_url_helper.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';
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
    this.replySwipeTriggerCallback,
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

  final Function(types.Message)? replySwipeTriggerCallback;

  @override
  State<Message> createState() => MessageState();
}

class MessageState extends State<Message> {

  final CustomPopupMenuController _popController = CustomPopupMenuController();

  double get horizontalPadding => 12.px;
  double get avatarPadding => 8.px;
  double get avatarSize => 40.px; // Keep equal to avatarBuilder widget size
  double get statusSize => 20.px;
  double get statusPadding => 8.px;
  double get messageGapPadding => 50.px;
  int get contentMaxWidth =>
      (widget.messageWidth.toDouble()
      - avatarSize
      - avatarPadding
      - horizontalPadding
      - statusSize
      - statusPadding
      - messageGapPadding).floor();

  Duration get flashDisplayDuration => const Duration(milliseconds: 300);
  Duration get flashDismissDuration => const Duration(milliseconds: 1000);
  late Duration flashDuration = flashDisplayDuration;

  Color get flashColor => ThemeColor.color190;
  late Color flashBackgroundColor = flashColor.withOpacity(0);

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
        start: isMobile ? query.padding.left : 0,
      );
    } else {
      margin = EdgeInsets.only(
        bottom: 16,
        left: (isMobile ? query.padding.left : 0) + horizontalPadding,
        right: (isMobile ? query.padding.right : 0) + horizontalPadding,
      );
    }

    Widget content = AnimatedContainer(
      duration: flashDuration,
      curve: Curves.easeIn,
      color: flashBackgroundColor,
      child: Container(
        alignment: alignment,
        margin: margin,
        child: _buildMessageContentView(),
      ),
    );

    if (widget.replySwipeTriggerCallback != null) {
      content = _SwipeToReply(
        revealIconBuilder: (progress) => Opacity(
          opacity: progress,
          child: Transform.scale(
            scale: progress,
            child: _buildSwipeQuoteIcon(),
          ),
        ),
        onSwipeComplete: () {
          widget.replySwipeTriggerCallback?.call(widget.message);
        },
        child: content,
        offset: currentUserIsAuthor ? Offset(50.px, 0) : Offset.zero,
      );
    }

    return content;
  }

  Widget _buildSwipeQuoteIcon() => Container(
    width: 32.px,
    height: 32.px,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16.px),
      color: ThemeColor.color180,
    ),
    alignment: Alignment.center,
    child: CommonImage(
      iconName: 'icon_message_swipe_quote.png',
      size: 16.px,
      package: 'ox_chat_ui',
    ),
  );

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
        if (!currentUserIsAuthor && avatarBuilder != null)
          _avatarBuilder(avatarBuilder(widget.message)).setPaddingOnly(
            right: avatarPadding,
          ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMessageBubbleView(),
            ],
          ),
        ),
        if (currentUserIsAuthor && avatarBuilder != null)
          _avatarBuilder(avatarBuilder(widget.message)).setPaddingOnly(
            left: avatarPadding,
          ),
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
      horizontalMargin: horizontalPadding,
      verticalMargin: 0,
      child: _bubbleBuilder(
        context,
        borderRadius.resolve(Directionality.of(context)),
        currentUserIsAuthor,
        enlargeEmojis,
      ),
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
    return avatarBuilder(widget.message);
  }

  Widget _bubbleBuilder(BuildContext context, BorderRadius borderRadius, bool currentUserIsAuthor, bool enlargeEmojis) {

    Widget bubble;

    var useBubbleBg = !widget.message.viewWithoutBubble;
    if (enlargeEmojis) {
      useBubbleBg = widget.message.hasReactions;
    }

    if (widget.bubbleBuilder != null) {
      bubble = widget.bubbleBuilder!(
        _messageBuilder(context),
        message: widget.message,
        nextMessageInGroup: widget.roundBorder,
      );
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
          _buildStatusWidget().setPaddingOnly(right: statusPadding),
        if (widget.message.repliedMessageId == null || widget.message.repliedMessageId!.isEmpty)
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
                      messageWidth: contentMaxWidth,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (!currentUserIsAuthor)
          _buildStatusWidget().setPaddingOnly(left: statusPadding),
      ],
    );
  }

  Widget _buildStatusWidget() => GestureDetector(
    onLongPress: () =>
        widget.onMessageStatusLongPress?.call(context, widget.message),
    onTap: () {
      widget.onMessageStatusTap?.call(context, widget.message);
    },
    child: widget.customStatusBuilder?.call(widget.message, context: context)
        ?? MessageStatus(size: statusSize, status: widget.message.status),
  );

  Widget _messageBuilder(BuildContext context, [bool addReaction = false]) {
    Widget messageContentWidget;
    switch (widget.message.type) {
      case types.MessageType.audio:
        final audioMessage = widget.message as types.AudioMessage;
        messageContentWidget = widget.audioMessageBuilder?.call(
          audioMessage,
          messageWidth: contentMaxWidth,
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
          messageWidth: contentMaxWidth,
          reactionWidget: _reactionViewBuilder(),
        ) ?? const SizedBox();
        break ;
      case types.MessageType.file:
        final fileMessage = widget.message as types.FileMessage;
        messageContentWidget = widget.fileMessageBuilder?.call(
          fileMessage,
          messageWidth: contentMaxWidth,
        ) ?? FileMessage(message: fileMessage);
        break ;
      case types.MessageType.image:
        final imageMessage = widget.message as types.ImageMessage;
        messageContentWidget = widget.imageMessageBuilder?.call(
          imageMessage,
          messageWidth: contentMaxWidth,
        ) ?? ImageMessage(
              imageHeaders: widget.imageHeaders,
              message: imageMessage,
              messageWidth: contentMaxWidth,
            );
        break ;
      case types.MessageType.text:
        final textMessage = widget.message as types.TextMessage;
        messageContentWidget = widget.textMessageBuilder?.call(
          textMessage,
          messageWidth: contentMaxWidth,
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
          maxLimit: textMessage.maxLimit,
        );
        break ;
      case types.MessageType.video:
        final videoMessage = widget.message as types.VideoMessage;
        messageContentWidget = widget.videoMessageBuilder?.call(
          videoMessage,
          messageWidth: contentMaxWidth,
        ) ?? VideoMessage(
              imageHeaders: widget.imageHeaders,
              message: videoMessage,
              messageWidth: contentMaxWidth,
            );
        break ;
      default:
        return const SizedBox();
    }

    messageContentWidget = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: contentMaxWidth.toDouble(),
      ),
      child: messageContentWidget,
    );

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
    messageWidth: contentMaxWidth,
  ) ?? const SizedBox();

  void flash() {
    setState(() {
      flashBackgroundColor = flashColor;
      flashDuration = flashDisplayDuration;
    });
    Future.delayed(flashDisplayDuration, () {
      if (!mounted) return;
      setState(() {
        flashBackgroundColor = flashColor.withOpacity(0.0);
        flashDuration = flashDismissDuration;
      });
    });
  }
}

class _SwipeToReply extends StatefulWidget {
  final Widget child;
  final Offset offset;
  final Widget Function(double progress) revealIconBuilder;
  final VoidCallback onSwipeComplete;

  const _SwipeToReply({
    super.key,
    required this.child,
    required this.revealIconBuilder,
    required this.onSwipeComplete,
    this.offset = Offset.zero,
  });

  @override
  _SwipeToReplyState createState() => _SwipeToReplyState();
}

class _SwipeToReplyState extends State<_SwipeToReply>
    with SingleTickerProviderStateMixin {
  double _dragDistance = 0.0;
  double get swipeDistance => _dragDistance.abs();
  late AnimationController _controller;

  bool hasFeedback = false;

  double get triggerOffset => 60.px;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      value: 1.0,
      duration: const Duration(milliseconds: 100),
    )..addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragDistance += details.primaryDelta ?? 0;
      // Only can left drag
      if (_dragDistance > 0) {
        _dragDistance = 0;
      }

      // Feedback
      if (!hasFeedback && swipeDistance >= triggerOffset) {
        hasFeedback = true;
        TookKit.vibrateEffect();
      }
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (swipeDistance >= triggerOffset) {
      widget.onSwipeComplete();
    }

    // Rebound
    _controller.reverse(from: 1.0).then((_) {
      setState(() {
        _dragDistance = 0.0;
      });
      _controller.value = 1.0;
      hasFeedback = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = (swipeDistance / triggerOffset).clamp(0.0, 1.0);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        var distance = 0.0;
        if (swipeDistance > triggerOffset) {
          distance = (swipeDistance - triggerOffset) * 0.3 + triggerOffset;
        } else {
          distance = swipeDistance;
        }

        final offset = _controller.value * -distance;
        return Stack(
          children: [
            Positioned(
              right: 10 - offset - widget.offset.dx,
              top: widget.offset.dy,
              bottom: 0,
              child: Center(child: widget.revealIconBuilder(progress)),
            ),
            Transform.translate(
              offset: Offset(offset, 0),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragUpdate: _onHorizontalDragUpdate,
                onHorizontalDragEnd: _onHorizontalDragEnd,
                child: widget.child,
              ),
            )
          ],
        );
      },
    );
  }
}