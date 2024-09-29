
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:chatcore/chat-core.dart';
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_chat/utils/custom_message_utils.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_chat/widget/chat_video_message.dart';
import 'package:ox_chat/widget/image_preview_widget.dart';
import 'package:ox_common/business_interface/ox_chat/call_message_type.dart';
import 'package:ox_common/business_interface/ox_chat/custom_message_type.dart';
import 'package:ox_common/business_interface/ox_chat/utils.dart';
import 'package:ox_common/business_interface/ox_chat/interface.dart';
import 'package:ox_common/upload/upload_utils.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/date_utils.dart';
import 'package:ox_common/utils/num_utils.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/video_utils.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_localizable/ox_localizable.dart';

part 'chat_message_builder_custom.dart';
part 'chat_message_builder_reaction.dart';

class ChatMessageBuilder {

  static Widget buildRepliedMessageView(types.Message message, {
    required int messageWidth,
    Function(String repliedMessageId)? onTap,
  }) {
    final repliedMessageId = message.repliedMessageId;
    if (repliedMessageId == null) return SizedBox();

    final repliedMessage = message.repliedMessage;
    return GestureDetector(
      onTap: () => onTap?.call(repliedMessage?.remoteId ?? ''),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: messageWidth.toDouble(),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Adapt.px(12)),
            color: ThemeColor.color190,
          ),
          margin: EdgeInsets.only(top: Adapt.px(2)),
          padding: EdgeInsets.symmetric(
              horizontal: Adapt.px(12), vertical: Adapt.px(4)),
          child: Text(
            repliedMessage?.replyDisplayContent ?? '[Not Found]',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: ThemeColor.color120,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  static Widget buildReactionsView(types.Message message, {
    required int messageWidth,
    Function(types.Reaction reaction)? itemOnTap,
  }) {
    return ChatMessageBuilderReactionEx.buildReactionsView(
      message,
      messageWidth: messageWidth,
      itemOnTap: itemOnTap,
    );
  }

  static Widget buildImageMessage(types.ImageMessage message, {
    required int messageWidth,
  }) {
    return ImagePreviewWidget(
      uri: message.uri,
      imageWidth: message.width?.toInt(),
      imageHeight: message.height?.toInt(),
      maxWidth: messageWidth,
      decryptKey: message.decryptKey,
    );
  }

  static Widget buildCustomMessage({
    required types.CustomMessage message,
    required int messageWidth,
    required Widget reactionWidget,
    String? receiverPubkey,
    Function(types.Message newMessage)? messageUpdateCallback,
  }) {
    final isMe = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey == message.author.id;
    final type = message.customType;

    switch (type) {
      case CustomMessageType.zaps:
        return ChatMessageBuilderCustomEx._buildZapsMessage(message, reactionWidget);
      case CustomMessageType.call:
        return ChatMessageBuilderCustomEx._buildCallMessage(message, isMe);
      case CustomMessageType.template:
        return ChatMessageBuilderCustomEx._buildTemplateMessage(message, reactionWidget, isMe);
      case CustomMessageType.note:
        return ChatMessageBuilderCustomEx._buildNoteMessage(message, reactionWidget, isMe);
      case CustomMessageType.ecash:
        return ChatMessageBuilderCustomEx._buildEcashMessage(message, reactionWidget, isMe);
      case CustomMessageType.ecashV2:
        return ChatMessageBuilderCustomEx._buildEcashV2Message(message, reactionWidget);
      case CustomMessageType.imageSending:
        return ChatMessageBuilderCustomEx._buildImageSendingMessage(message, messageWidth, reactionWidget, receiverPubkey);
      case CustomMessageType.video:
        return ChatMessageBuilderCustomEx._buildVideoMessage(message, messageWidth, reactionWidget, receiverPubkey, messageUpdateCallback);
      default:
        return SizedBox();
    }
  }
}

extension CallMessageTypeEx on CallMessageType {
  String get iconName {
    switch (this) {
      case CallMessageType.audio:
        return 'icon_message_call.png';
      case CallMessageType.video:
        return 'icon_message_camera.png';
      default:
        return '';
    }
  }
}