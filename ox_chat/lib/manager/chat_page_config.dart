
import 'package:flutter/material.dart';
import 'package:ox_chat/widget/message_long_press_widget.dart';
import 'package:ox_chat/widget/reaction_input_widget.dart';
import 'package:ox_chat_ui/ox_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:chatcore/chat-core.dart';
import 'package:ox_chat/utils/general_handler/chat_general_handler.dart';
import 'package:ox_chat/utils/chat_log_utils.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image_gallery.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:photo_view/photo_view.dart' show PhotoViewComputedScale;

class ChatPageConfig {

  static const messagesPerPage = 15;

  /// Menu item by message long pressed
  Widget longPressWidgetBuilder({
    required BuildContext context,
    required types.Message message,
    required CustomPopupMenuController controller,
    required ChatGeneralHandler handler,
  }) {
    return MessageLongPressWidget(
      pageContext: context,
      message: message,
      controller: controller,
      handler: handler,
    );
  }

  ImageGalleryOptions get imageGalleryOptions =>
      ImageGalleryOptions(
        maxScale: PhotoViewComputedScale.covered,
        minScale: PhotoViewComputedScale.contained,
      );

  List<InputMoreItem> inputMoreItemsWithHandler(ChatGeneralHandler handler) {
    final items = [
      InputMoreItemEx.album(handler),
      InputMoreItemEx.camera(handler),
      InputMoreItemEx.video(handler),
      InputMoreItemEx.ecash(handler),
    ];

    final otherUser = handler.otherUser;
    if (handler.session.chatType == ChatType.chatSingle && otherUser != null) {
      items.add(InputMoreItemEx.zaps(handler, otherUser));
      items.add(InputMoreItemEx.call(handler, otherUser));
    }

    return items;
  }

  ChatTheme get pageTheme =>
      DefaultChatTheme(
        sentMessageBodyTextStyle: TextStyle(
          color: ThemeColor.white,
          fontSize: Adapt.sp(16),
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
        receivedMessageBodyTextStyle: TextStyle(
          color: ThemeColor.color0,
          fontSize: Adapt.sp(16),
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
        inputTextColor: ThemeColor.color0,
      );
}

extension InputMoreItemEx on InputMoreItem {

  static InputMoreItem album(ChatGeneralHandler handler) =>
      InputMoreItem(
        id: 'album',
        title: () => Localized.text('ox_chat_ui.input_more_album'),
        iconName: 'chat_photo_more.png',
        action: (context) {
          handler.albumPressHandler(context, 1);
        },
      );

  static InputMoreItem camera(ChatGeneralHandler handler) =>
      InputMoreItem(
        id: 'camera',
        title: () => Localized.text('ox_chat_ui.input_more_camera'),
        iconName: 'chat_camera_more.png',
        action: (context) {
          handler.cameraPressHandler(context);
        },
      );

  static InputMoreItem video(ChatGeneralHandler handler) =>
      InputMoreItem(
        id: 'video',
        title: () => Localized.text('ox_chat_ui.input_more_video'),
        iconName: 'chat_video_icon.png',
        action: (context) {
          handler.albumPressHandler(context, 2);
        },
      );

  static InputMoreItem call(ChatGeneralHandler handler, UserDBISAR? otherUser) =>
      InputMoreItem(
        id: 'call',
        title: () => Localized.text('ox_chat_ui.input_more_call'),
        iconName: 'chat_call_icon.png',
        action: (context) {
          final user = otherUser;
          if (user == null) {
            ChatLogUtils.error(className: 'ChatPageConfig', funcName: 'call', message: 'user is null');
            CommonToast.instance.show(context, 'User info not found');
            return ;
          }
          handler.callPressHandler(context, user);
        },
      );

  static InputMoreItem zaps(ChatGeneralHandler handler, UserDBISAR? otherUser) =>
      InputMoreItem(
        id: 'zaps',
        title: () => Localized.text('ox_chat_ui.input_more_zaps'),
        iconName: 'chat_zaps_icon.png',
        action: (context) {
          final user = otherUser;
          if (user == null) {
            ChatLogUtils.error(className: 'ChatPageConfig', funcName: 'zaps', message: 'user is null');
            CommonToast.instance.show(context, 'User info not found');
            return ;
          }
          handler.zapsPressHandler(context, user);
        },
      );

  static InputMoreItem ecash(ChatGeneralHandler handler) =>
      InputMoreItem(
        id: 'ecash',
        title: () => Localized.text('ox_chat_ui.input_more_nuts'),
        iconName: 'chat_ecash_icon.png',
        action: (context) {
          handler.ecashPressHandler(context);
        },
      );

}
