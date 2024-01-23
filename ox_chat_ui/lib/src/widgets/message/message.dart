import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_common/widgets/common_image.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';

import '../../../ox_chat_ui.dart';
import '../../models/bubble_rtl_alignment.dart';
import '../../models/emoji_enlargement_behavior.dart';
import '../../util.dart';
import '../pop_menu/custom_pop_up_menu.dart';
import '../state/inherited_chat_theme.dart';
import '../state/inherited_user.dart';
import 'audio_message_page.dart';
import 'file_message.dart';
import 'image_message.dart';
import 'message_status.dart';
import 'text_message.dart';
import 'user_avatar.dart';
import 'video_message.dart';


/// Base widget for all message types in the chat. Renders bubbles around
/// messages and status. Sets maximum width for a message for
/// a nice look on larger screens.

class _LayoutConstant {
  static double menuVerticalPadding = Adapt.px(16);
  static double menuHorizontalPadding = Adapt.px(8);
  static double menuItemWidth = Adapt.px(61);
  static double menuIconSize = Adapt.px(24);
  static double menuTitleTopPadding = Adapt.px(6);
  static double menuTitleSize = Adapt.px(12);
}

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
    this.onMessageLongPressEvent,
    this.longPressMenuItemsCreator,
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
  final Widget Function(types.CustomMessage, {required int messageWidth})?
  customMessageBuilder;

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

  ///Called  when the menu items clicked after a long press
  final void Function(types.Message, MessageLongPressEventType type)? onMessageLongPressEvent;

  /// See [TextMessage.onPreviewDataFetched].
  final void Function(types.TextMessage, types.PreviewData)?
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

  /// Create a menu that pops up when long pressing on a message
  final List<ItemModel> Function(BuildContext context, types.Message)? longPressMenuItemsCreator;

  @override
  State<Message> createState() => _MessageState();
}



class _MessageState extends State<Message> {

  final CustomPopupMenuController _popController = CustomPopupMenuController();
  List<ItemModel> menuItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final longPressMenuItemsCreator = widget.longPressMenuItemsCreator;
    if (longPressMenuItemsCreator != null) {
      menuItems = longPressMenuItemsCreator(context, widget.message);
    }
  }

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

  Widget _buildLongPressMenu() => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: _LayoutConstant.menuHorizontalPadding, vertical: _LayoutConstant.menuVerticalPadding),
          color: ThemeColor.color180,
          child: Wrap(
            children: menuItems
                .map((item) => GestureDetector(
              onTap: () {
                widget.onMessageLongPressEvent?.call(widget.message, item.type);
                _popController.hideMenu();
              },
              child: SizedBox(
                width: _LayoutConstant.menuItemWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CommonImage(
                      iconName:item.icon.path,
                      fit: BoxFit.fill,
                      width: _LayoutConstant.menuIconSize,
                      height: _LayoutConstant.menuIconSize,
                      package: item.icon.package,
                      useTheme: true,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: _LayoutConstant.menuTitleTopPadding),
                      child: Text(
                        item.title,
                        style: TextStyle(color: ThemeColor.color0, fontSize: _LayoutConstant.menuTitleSize),
                      ),
                    ),
                  ],
                ),
              ),
            )).toList(),
          ),
        ),
      );

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

    final useThemeBubbleBg = (currentUserIsAuthor
        && widget.message.type != types.MessageType.image
        && widget.message.type != types.MessageType.video
        && widget.message.type != types.MessageType.custom);

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
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          gradient: useThemeBubbleBg ? LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              ThemeColor.gradientMainEnd,
              ThemeColor.gradientMainStart
            ],
          ) : null,
          color: !currentUserIsAuthor
              ? (!currentUserIsAuthor && widget.message.type == types.MessageType.image)
                  ? null
                  : ThemeColor.color180
              : null,
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: _messageBuilder(context),
        ),
      );
    }
    // return bubble;
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
                    child: widget.repliedMessageBuilder?.call(widget.message, messageWidth: widget.messageWidth),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _messageBuilder(BuildContext context) {
    switch (widget.message.type) {
      case types.MessageType.audio:
        final audioMessage = widget.message as types.AudioMessage;
        return widget.audioMessageBuilder?.call(audioMessage, messageWidth: widget.messageWidth)
            ?? AudioMessagePage(
              message: audioMessage,
              fetchAudioFile: widget.onAudioDataFetched,
              onPlay: (message) {
                widget.onMessageTap?.call(context, message);
              },
            );
      case types.MessageType.custom:
        final customMessage = widget.message as types.CustomMessage;
        return widget.customMessageBuilder?.call(customMessage, messageWidth: widget.messageWidth)
            ?? const SizedBox();
      case types.MessageType.file:
        final fileMessage = widget.message as types.FileMessage;
        return widget.fileMessageBuilder?.call(fileMessage, messageWidth: widget.messageWidth)
            ?? FileMessage(message: fileMessage);
      case types.MessageType.image:
        final imageMessage = widget.message as types.ImageMessage;
        return widget.imageMessageBuilder?.call(imageMessage, messageWidth: widget.messageWidth)
            ?? ImageMessage(
              imageHeaders: widget.imageHeaders,
              message: imageMessage,
              messageWidth: widget.messageWidth,
            );
      case types.MessageType.text:
        final textMessage = widget.message as types.TextMessage;
        return widget.textMessageBuilder?.call(
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
      case types.MessageType.video:
        final videoMessage = widget.message as types.VideoMessage;
        return widget.videoMessageBuilder?.call(videoMessage, messageWidth: widget.messageWidth)
            ?? VideoMessage(
              imageHeaders: widget.imageHeaders,
              message: videoMessage,
              messageWidth: widget.messageWidth,
            );
      default:
        return const SizedBox();
    }
  }
}

class ItemModel {
  String title;
  AssetImageData icon;
  MessageLongPressEventType type;
  ItemModel(this.title, this.icon, this.type);
}

class AssetImageData {
  String path;
  String? package;
  AssetImageData(this.path, { this. package });
}

enum MessageLongPressEventType {
  copy,
  share,
  delete,
  forward,
  quote,
  report
}

