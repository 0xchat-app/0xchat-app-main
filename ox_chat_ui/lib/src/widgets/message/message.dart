import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
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
    required this.roundBorder,
    required this.showAvatar,
    required this.showName,
    required this.showStatus,
    this.textMessageBuilder,
    required this.textMessageOptions,
    required this.usePreviewData,
    this.userAgent,
    this.videoMessageBuilder,
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
    final enlargeEmojis =
        widget.emojiEnlargementBehavior != EmojiEnlargementBehavior.never &&
            widget.message is types.TextMessage &&
            isConsistsOfEmojis(
              widget.emojiEnlargementBehavior,
              widget.message as types.TextMessage,
            );
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
    final avatarBuilder = widget.avatarBuilder;
    return Container(
      alignment: widget.bubbleRtlAlignment == BubbleRtlAlignment.left
          ? currentUserIsAuthor
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart
          : currentUserIsAuthor
          ? Alignment.centerRight
          : Alignment.centerLeft,
      margin: widget.bubbleRtlAlignment == BubbleRtlAlignment.left
          ? EdgeInsetsDirectional.only(
        bottom: 16,
        end: isMobile ? query.padding.right : 0,
        start: 20 + (isMobile ? query.padding.left : 0),
      )
          : EdgeInsets.only(
        bottom: 16,
        left: 20 + (isMobile ? query.padding.left : 0),
        right: isMobile ? query.padding.right : 0,
      ),
      child: Row(
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
                GestureDetector(
                  onDoubleTap: () => widget.onMessageDoubleTap?.call(context, widget.message),
                  onLongPress: () => widget.onMessageLongPress?.call(context, widget.message),
                  onTap: () => widget.onMessageTap?.call(context, widget.message),
                  child: widget.onMessageVisibilityChanged != null
                      ? VisibilityDetector(
                    key: Key(widget.message.id),
                    onVisibilityChanged: (visibilityInfo) =>
                        widget.onMessageVisibilityChanged!(
                          widget.message,
                          visibilityInfo.visibleFraction > 0.1,
                        ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (widget.showName)
                          UserName(author: widget.message.author),
                        CustomPopupMenu(
                          controller: _popController,
                          arrowColor: ThemeColor.color180,
                          menuBuilder: _buildLongPressMenu,
                          pressType: PressType.longPress,
                          child: _bubbleBuilder(
                            context,
                            borderRadius
                                .resolve(Directionality.of(context)),
                            currentUserIsAuthor,
                            enlargeEmojis,
                          ),
                          menuOnChange:(isChange){

                          },
                        )
                      ],
                    ),
                  )
                      : Column(
                    crossAxisAlignment: currentUserIsAuthor
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      if (widget.showName)
                        UserName(author: widget.message.author),
                      CustomPopupMenu(
                        controller: _popController,
                        arrowColor: ThemeColor.color180,
                        menuBuilder: _buildLongPressMenu,
                        pressType: PressType.longPress,
                        child: _bubbleBuilder(
                          context,
                          borderRadius.resolve(Directionality.of(context)),
                          currentUserIsAuthor,
                          enlargeEmojis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (currentUserIsAuthor)
            Padding(
              padding: EdgeInsets.only(right: 10),
            ),
          if (currentUserIsAuthor && avatarBuilder != null) _avatarBuilder(avatarBuilder(widget.message)),
        ],
      ),
    );
  }

  Widget _buildLongPressMenu() => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: _LayoutConstant.menuHorizontalPadding, vertical: _LayoutConstant.menuVerticalPadding),
          color: ThemeColor.color180,
          child: Wrap(
            children: menuItems
                .map((item) => GestureDetector(
              onTap: () {
                if (widget.onMessageLongPressEvent != null) {
                  widget.onMessageLongPressEvent!(
                      widget.message, item.type);
                }
                _popController.hideMenu();
              },
              child: SizedBox(
                width: _LayoutConstant.menuItemWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset(
                        item.icon.path,
                        width: _LayoutConstant.menuIconSize,
                        height: _LayoutConstant.menuIconSize,
                        fit: BoxFit.fill,
                        package: item.icon.package,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: _LayoutConstant.menuTitleTopPadding),
                      child: Text(
                        item.title,
                        style: TextStyle(color: Colors.white, fontSize: _LayoutConstant.menuTitleSize),
                      ),
                    ),
                  ],
                ),
              ),
            )).toList(),
          ),
        ),
      );

  Widget _avatarBuilder(Widget child) => Container(
    margin: widget.bubbleRtlAlignment == BubbleRtlAlignment.left
        ? const EdgeInsetsDirectional.only(end: 8)
        : const EdgeInsets.only(right: 8),
    child: child,
  );

  Widget _bubbleBuilder(BuildContext context, BorderRadius borderRadius, bool currentUserIsAuthor, bool enlargeEmojis) {

    Widget bubble;

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
          gradient: !currentUserIsAuthor ||
              widget.message.type == types.MessageType.image ||
              widget.message.type == types.MessageType.video
              ? null
              : LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              ThemeColor.gradientMainEnd,
              ThemeColor.gradientMainStart
            ],
          ),
          color: !currentUserIsAuthor ||
              widget.message.type == types.MessageType.image
              ? ThemeColor.color180
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
              child: widget.customStatusBuilder != null
                  ? widget.customStatusBuilder!(widget.message, context: context)
                  : MessageStatus(status: widget.message.status),
            ),
          ),
        Flexible(child: bubble),
      ],
    );
  }

  Widget _messageBuilder(BuildContext context) {
    switch (widget.message.type) {
      case types.MessageType.audio:
        final audioMessage = widget.message as types.AudioMessage;
        return widget.audioMessageBuilder != null
            ? widget.audioMessageBuilder!(audioMessage, messageWidth: widget.messageWidth)
            : AudioMessagePage(
          //When the voice message is clicked for playback, emit the event to refresh the interface
          audioSrc: audioMessage.uri,
          message: audioMessage,
          onPlay: (message) {
            widget.onMessageTap?.call(context, message);
          },
        );
      case types.MessageType.custom:
        final customMessage = widget.message as types.CustomMessage;
        return widget.customMessageBuilder != null
            ? widget.customMessageBuilder!(customMessage, messageWidth: widget.messageWidth)
            : const SizedBox();
      case types.MessageType.file:
        final fileMessage = widget.message as types.FileMessage;
        return widget.fileMessageBuilder != null
            ? widget.fileMessageBuilder!(fileMessage, messageWidth: widget.messageWidth)
            : FileMessage(message: fileMessage);
      case types.MessageType.image:
        final imageMessage = widget.message as types.ImageMessage;
        return widget.imageMessageBuilder != null
            ? widget.imageMessageBuilder!(imageMessage, messageWidth: widget.messageWidth)
            : ImageMessage(
          imageHeaders: widget.imageHeaders,
          message: imageMessage,
          messageWidth: widget.messageWidth,
        );
      case types.MessageType.text:
        final textMessage = widget.message as types.TextMessage;
        return widget.textMessageBuilder != null
            ? widget.textMessageBuilder!(
          textMessage,
          messageWidth: widget.messageWidth,
          showName: widget.showName,
        )
          : TextMessage(
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
        return widget.videoMessageBuilder != null
            ? widget.videoMessageBuilder!(videoMessage, messageWidth: widget.messageWidth)
            : VideoMessage(
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

// class Message extends StatelessWidget {
//   /// Creates a particular message from any message type.
//   Message({
//     super.key,
//     this.audioMessageBuilder,
//     this.avatarBuilder,
//     this.bubbleBuilder,
//     this.bubbleRtlAlignment,
//     this.customMessageBuilder,
//     this.customStatusBuilder,
//     required this.emojiEnlargementBehavior,
//     this.fileMessageBuilder,
//     required this.hideBackgroundOnEmojiMessages,
//     this.imageHeaders,
//     this.imageMessageBuilder,
//     required this.message,
//     required this.messageWidth,
//     this.nameBuilder,
//     this.onAvatarTap,
//     this.onMessageDoubleTap,
//     this.onMessageLongPress,
//     this.onMessageStatusLongPress,
//     this.onMessageStatusTap,
//     this.onMessageTap,
//     this.onMessageVisibilityChanged,
//     this.onPreviewDataFetched,
//     required this.roundBorder,
//     required this.showAvatar,
//     required this.showName,
//     required this.showStatus,
//     required this.showUserAvatars,
//     this.textMessageBuilder,
//     required this.textMessageOptions,
//     required this.usePreviewData,
//     this.userAgent,
//     this.videoMessageBuilder,
//   });
//
//   /// Build an audio message inside predefined bubble.
//   final Widget Function(types.AudioMessage, {required int messageWidth})?
//       audioMessageBuilder;
//
//   /// This is to allow custom user avatar builder
//   /// By using this we can fetch newest user info based on id
//   final Widget Function(String userId)? avatarBuilder;
//
//   /// Customize the default bubble using this function. `child` is a content
//   /// you should render inside your bubble, `message` is a current message
//   /// (contains `author` inside) and `nextMessageInGroup` allows you to see
//   /// if the message is a part of a group (messages are grouped when written
//   /// in quick succession by the same author)
//   final Widget Function(
//     Widget child, {
//     required types.Message message,
//     required bool nextMessageInGroup,
//   })? bubbleBuilder;
//
//   /// Determine the alignment of the bubble for RTL languages. Has no effect
//   /// for the LTR languages.
//   final BubbleRtlAlignment? bubbleRtlAlignment;
//
//   /// Build a custom message inside predefined bubble.
//   final Widget Function(types.CustomMessage, {required int messageWidth})?
//       customMessageBuilder;
//
//   /// Build a custom status widgets.
//   final Widget Function(types.Message message, {required BuildContext context})?
//       customStatusBuilder;
//
//   /// Controls the enlargement behavior of the emojis in the
//   /// [types.TextMessage].
//   /// Defaults to [EmojiEnlargementBehavior.multi].
//   final EmojiEnlargementBehavior emojiEnlargementBehavior;
//
//   /// Build a file message inside predefined bubble.
//   final Widget Function(types.FileMessage, {required int messageWidth})?
//       fileMessageBuilder;
//
//   /// Hide background for messages containing only emojis.
//   final bool hideBackgroundOnEmojiMessages;
//
//   /// See [Chat.imageHeaders].
//   final Map<String, String>? imageHeaders;
//
//   /// Build an image message inside predefined bubble.
//   final Widget Function(types.ImageMessage, {required int messageWidth})?
//       imageMessageBuilder;
//
//   /// Any message type.
//   final types.Message message;
//
//   /// Maximum message width.
//   final int messageWidth;
//
//   /// See [TextMessage.nameBuilder].
//   final Widget Function(String userId)? nameBuilder;
//
//   /// See [UserAvatar.onAvatarTap].
//   final void Function(types.User)? onAvatarTap;
//
//   /// Called when user double taps on any message.
//   final void Function(BuildContext context, types.Message)? onMessageDoubleTap;
//
//   /// Called when user makes a long press on any message.
//   final void Function(BuildContext context, types.Message)? onMessageLongPress;
//
//   /// Called when user makes a long press on status icon in any message.
//   final void Function(BuildContext context, types.Message)?
//       onMessageStatusLongPress;
//
//   /// Called when user taps on status icon in any message.
//   final void Function(BuildContext context, types.Message)? onMessageStatusTap;
//
//   /// Called when user taps on any message.
//   final void Function(BuildContext context, types.Message)? onMessageTap;
//
//   /// Called when the message's visibility changes.
//   final void Function(types.Message, bool visible)? onMessageVisibilityChanged;
//
//   /// See [TextMessage.onPreviewDataFetched].
//   final void Function(types.TextMessage, types.PreviewData)?
//       onPreviewDataFetched;
//
//   /// Rounds border of the message to visually group messages together.
//   final bool roundBorder;
//
//   /// Show user avatar for the received message. Useful for a group chat.
//   final bool showAvatar;
//
//   /// See [TextMessage.showName].
//   final bool showName;
//
//   /// Show message's status.
//   final bool showStatus;
//
//   /// Show user avatars for received messages. Useful for a group chat.
//   final bool showUserAvatars;
//
//   /// Build a text message inside predefined bubble.
//   final Widget Function(
//     types.TextMessage, {
//     required int messageWidth,
//     required bool showName,
//   })? textMessageBuilder;
//
//   /// See [TextMessage.options].
//   final TextMessageOptions textMessageOptions;
//
//   /// See [TextMessage.usePreviewData].
//   final bool usePreviewData;
//
//   /// See [TextMessage.userAgent].
//   final String? userAgent;
//
//   /// Build an audio message inside predefined bubble.
//   final Widget Function(types.VideoMessage, {required int messageWidth})?
//       videoMessageBuilder;
//
//   CustomPopupMenuController _popController = CustomPopupMenuController();
//   List<ItemModel> menuItems = [
//     ItemModel('copy', Icons.content_copy),
//     ItemModel('Forward', Icons.send),
//     // ItemModel('Collections', Icons.collections),
//     ItemModel('Delete', Icons.delete),
//     ItemModel('Share', Icons.share),
//     // ItemModel('Select Multiple', Icons.playlist_add_check),
//     // ItemModel('Quote', Icons.format_quote),
//     // ItemModel('Alert', Icons.add_alert),
//     // ItemModel('Search', Icons.search),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     final query = MediaQuery.of(context);
//     final user = InheritedUser.of(context).user;
//     final currentUserIsAuthor = user.id == message.author.id;
//     final enlargeEmojis =
//         emojiEnlargementBehavior != EmojiEnlargementBehavior.never &&
//             message is types.TextMessage &&
//             isConsistsOfEmojis(
//               emojiEnlargementBehavior,
//               message as types.TextMessage,
//             );
//     final messageBorderRadius =
//         InheritedChatTheme.of(context).theme.messageBorderRadius;
//
//     final borderRadius = bubbleRtlAlignment == BubbleRtlAlignment.left
//         ? BorderRadiusDirectional.only(
//             bottomEnd: Radius.circular(
//               !currentUserIsAuthor || roundBorder ? messageBorderRadius : 0,
//             ),
//             bottomStart: Radius.circular(
//               currentUserIsAuthor || roundBorder ? messageBorderRadius : 0,
//             ),
//             topEnd: Radius.circular(messageBorderRadius),
//             topStart: Radius.circular(messageBorderRadius),
//           )
//         : BorderRadius.only(
//             bottomLeft: Radius.circular(
//               messageBorderRadius,
//             ),
//             bottomRight: Radius.circular(
//               messageBorderRadius,
//             ),
//             topLeft:
//                 Radius.circular(currentUserIsAuthor ? messageBorderRadius : 0),
//             topRight:
//                 Radius.circular(currentUserIsAuthor ? 0 : messageBorderRadius),
//           );
//     return Container(
//       alignment: bubbleRtlAlignment == BubbleRtlAlignment.left
//           ? currentUserIsAuthor
//               ? AlignmentDirectional.centerEnd
//               : AlignmentDirectional.centerStart
//           : currentUserIsAuthor
//               ? Alignment.centerRight
//               : Alignment.centerLeft,
//       margin: bubbleRtlAlignment == BubbleRtlAlignment.left
//           ? EdgeInsetsDirectional.only(
//               bottom: 16,
//               end: isMobile ? query.padding.right : 0,
//               start: 20 + (isMobile ? query.padding.left : 0),
//             )
//           : EdgeInsets.only(
//               bottom: 16,
//               left: 20 + (isMobile ? query.padding.left : 0),
//               right: isMobile ? query.padding.right : 0,
//             ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         textDirection: bubbleRtlAlignment == BubbleRtlAlignment.left
//             ? null
//             : TextDirection.ltr,
//         children: [
//           if (!currentUserIsAuthor && showUserAvatars) _avatarBuilder(),
//           ConstrainedBox(
//             constraints: BoxConstraints(
//               maxWidth: messageWidth.toDouble(),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 GestureDetector(
//                   onDoubleTap: () => onMessageDoubleTap?.call(context, message),
//                   onLongPress: () => onMessageLongPress?.call(context, message),
//                   onTap: () => onMessageTap?.call(context, message),
//                   child: onMessageVisibilityChanged != null
//                       ? VisibilityDetector(
//                           key: Key(message.id),
//                           onVisibilityChanged: (visibilityInfo) =>
//                               onMessageVisibilityChanged!(
//                             message,
//                             visibilityInfo.visibleFraction > 0.1,
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               if (showName)
//                               UserName(author: message.author),
//                               _bubbleBuilder(
//                                 context,
//                                 borderRadius
//                                     .resolve(Directionality.of(context)),
//                                 currentUserIsAuthor,
//                                 enlargeEmojis,
//                               )
//                             ],
//                           ),
//                         )
//                       : Column(
//                           crossAxisAlignment: currentUserIsAuthor
//                               ? CrossAxisAlignment.end
//                               : CrossAxisAlignment.start,
//                           children: [
//                             if (showName)
//                             UserName(author: message.author),
//                             // _bubbleBuilder(
//                             //   context,
//                             //   borderRadius.resolve(Directionality.of(context)),
//                             //   currentUserIsAuthor,
//                             //   enlargeEmojis,
//                             // ),
//
//                             CustomPopupMenu(
//                               controller: _popController,
//                               menuBuilder: _buildLongPressMenu,
//                               pressType: PressType.longPress,
//                               child:_bubbleBuilder(
//                                 context,
//                                 borderRadius.resolve(Directionality.of(context)),
//                                 currentUserIsAuthor,
//                                 enlargeEmojis,
//                               ),
//                                 menuOnChange:(isChange){
//
//                                 }
//                             )
//
//                           ],
//                         ),
//                 ),
//               ],
//             ),
//           ),
//           if (currentUserIsAuthor)
//             Padding(
//               padding: EdgeInsets.only(right: 10),
//               // child: showStatus
//               //     ? GestureDetector(
//               //         onLongPress: () =>
//               //             onMessageStatusLongPress?.call(context, message),
//               //         onTap: () => onMessageStatusTap?.call(context, message),
//               //         child: customStatusBuilder != null
//               //             ? customStatusBuilder!(message, context: context)
//               //             : MessageStatus(status: message.status),
//               //       )
//               //     : null,
//             ),
//           if (currentUserIsAuthor) _avatarBuilder(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLongPressMenu() => ClipRRect(
//       borderRadius: BorderRadius.circular(5),
//       child: Container(
//         width: 180,
//         color: const Color(0xFF4C4C4C),
//         child: GridView.count(
//           padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
//           crossAxisCount: 4,
//           crossAxisSpacing: 0,
//           mainAxisSpacing: 10,
//           shrinkWrap: true,
//           physics: NeverScrollableScrollPhysics(),
//           children: menuItems
//               .map((item) => GestureDetector(
//                 onTap: (){
//                   _popController.hideMenu();
//                   _popController.hideMenu();
//                 },
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 Icon(
//                   item.icon,
//                   size: 20,
//                   color: Colors.white,
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(top: 2),
//                   child: Text(
//                     item.title,
//                     style: TextStyle(color: Colors.white, fontSize: 12),
//                   ),
//                 ),
//               ],
//             ),
//           ))
//               .toList(),
//         ),
//       ),
//     );
//
//   Widget _avatarBuilder() => UserAvatar(
//         author: message.author,
//         bubbleRtlAlignment: bubbleRtlAlignment,
//         imageHeaders: imageHeaders,
//         onAvatarTap: onAvatarTap,
//       );
//
//   Widget _bubbleBuilder(
//     BuildContext context,
//     BorderRadius borderRadius,
//     bool currentUserIsAuthor,
//     bool enlargeEmojis,
//   ) =>
//       bubbleBuilder != null
//           ? bubbleBuilder!(
//               _messageBuilder(context),
//               message: message,
//               nextMessageInGroup: roundBorder,
//             )
//           : enlargeEmojis && hideBackgroundOnEmojiMessages
//               ? _messageBuilder(context)
//               : Container(
//                   decoration: BoxDecoration(
//                     borderRadius: borderRadius,
//                     gradient: !currentUserIsAuthor ||
//                             message.type == types.MessageType.image ||
//                             message.type == types.MessageType.video
//                         ? null
//                         : LinearGradient(
//                             begin: Alignment.centerLeft,
//                             end: Alignment.centerRight,
//                             colors: [
//                               ThemeColor.gradientMainEnd,
//                               ThemeColor.gradientMainStart
//                             ],
//                           ),
//                     color: !currentUserIsAuthor ||
//                             message.type == types.MessageType.image
//                         ? ThemeColor.color180
//                         : null,
//                   ),
//                   child: ClipRRect(
//                     borderRadius: borderRadius,
//                     child: _messageBuilder(context),
//                   ),
//                 );
//
//   Widget _messageBuilder(BuildContext context) {
//     switch (message.type) {
//       case types.MessageType.audio:
//         final audioMessage = message as types.AudioMessage;
//         return audioMessageBuilder != null
//             ? audioMessageBuilder!(audioMessage, messageWidth: messageWidth)
//             : AudioMessagePage(
//                 audioSrc: audioMessage.uri,
//                 message: audioMessage,
//                 onPlay: (message) {
//                   onMessageTap?.call(context, message);
//                 },
//               );
//       case types.MessageType.custom:
//         final customMessage = message as types.CustomMessage;
//         return customMessageBuilder != null
//             ? customMessageBuilder!(customMessage, messageWidth: messageWidth)
//             : const SizedBox();
//       case types.MessageType.file:
//         final fileMessage = message as types.FileMessage;
//         return fileMessageBuilder != null
//             ? fileMessageBuilder!(fileMessage, messageWidth: messageWidth)
//             : FileMessage(message: fileMessage);
//       case types.MessageType.image:
//         final imageMessage = message as types.ImageMessage;
//         return imageMessageBuilder != null
//             ? imageMessageBuilder!(imageMessage, messageWidth: messageWidth)
//             : ImageMessage(
//                 imageHeaders: imageHeaders,
//                 message: imageMessage,
//                 messageWidth: messageWidth,
//               );
//       case types.MessageType.text:
//         final textMessage = message as types.TextMessage;
//         return textMessageBuilder != null
//             ? textMessageBuilder!(
//                 textMessage,
//                 messageWidth: messageWidth,
//                 showName: showName,
//               )
//             : TextMessage(
//                 emojiEnlargementBehavior: emojiEnlargementBehavior,
//                 hideBackgroundOnEmojiMessages: hideBackgroundOnEmojiMessages,
//                 message: textMessage,
//                 nameBuilder: nameBuilder,
//                 onPreviewDataFetched: onPreviewDataFetched,
//                 options: textMessageOptions,
//                 showName: showName,
//                 usePreviewData: usePreviewData,
//                 userAgent: userAgent,
//               );
//       case types.MessageType.video:
//         final videoMessage = message as types.VideoMessage;
//         return videoMessageBuilder != null
//             ? videoMessageBuilder!(videoMessage, messageWidth: messageWidth)
//             : VideoMessage(
//                 imageHeaders: imageHeaders,
//                 message: videoMessage,
//                 messageWidth: messageWidth,
//               );
//       default:
//         return const SizedBox();
//     }
//   }
// }


