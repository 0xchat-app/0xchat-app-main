
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'widgets/pop_menu/custom_pop_up_menu.dart';

/// A configuration class for customizing the UI elements in a chat interface.
class ChatUIConfig {

  /// This is to allow custom user name builder
  /// By using this we can fetch newest user info based on id
  final Widget Function(String userId)? nameBuilder;

  /// Represents a widget for a user's avatar.
  ///
  /// If [avatarWidget] is `null`, the avatar will be hidden.
  final Widget Function(types.Message message)? avatarBuilder;

  /// Build a custom message inside predefined bubble.
  final Widget Function({
    required types.CustomMessage message,
    required int messageWidth,
    required Widget reactionWidget,
  })? customMessageBuilder;

  /// Create a widget that pops up when long pressing on a message
  final Widget Function(
    BuildContext context,
    types.Message message,
    CustomPopupMenuController controller
  )? longPressWidgetBuilder;

  /// Build a custom status widgets.
  final Widget Function(types.Message message, {required BuildContext context})? customStatusBuilder;

  /// A builder for rendering a custom widget for a code block within a text message.
  ///
  /// [codeText] is the raw content of the code block.
  /// Returns a widget that displays the code block.
  final Widget Function({
    required BuildContext context,
    required String codeText,
  })? codeBlockBuilder;

  /// A builder for rendering a custom "more" button in a message item.
  ///
  /// [message] is the message object, which can be used to decide how the button looks or behaves.
  /// Returns a widget that replaces or extends the default "more" button.
  final InlineSpan Function({
    required BuildContext context,
    required types.TextMessage message,
    required String moreText,
    required bool isMessageSender,
    TextStyle? bodyTextStyle,
  })? moreButtonBuilder;

  final Widget Function(types.Message, {required int messageWidth})? repliedMessageBuilder;

  final Widget Function(types.Message, {required int messageWidth})? reactionViewBuilder;

  /// Constructor: all fields are optional. The user can provide only what they need.
  const ChatUIConfig({
    this.nameBuilder,
    this.avatarBuilder,
    this.customMessageBuilder,
    this.longPressWidgetBuilder,
    this.customStatusBuilder,
    this.codeBlockBuilder,
    this.moreButtonBuilder,
    this.repliedMessageBuilder,
    this.reactionViewBuilder,
  });
}