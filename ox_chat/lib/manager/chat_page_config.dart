
import 'package:flutter/material.dart';
import 'package:ox_chat_ui/ox_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:chatcore/chat-core.dart';
import 'package:ox_chat/utils/chat_general_handler.dart';
import 'package:ox_chat/utils/chat_log_utils.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:photo_view/photo_view.dart' show PhotoViewComputedScale;

class ChatPageConfig {

  /// Menu item by message long pressed
  List<ItemModel> longPressMenuItemsCreator(BuildContext context, types.Message message) {

    List<ItemModel> menuList = [];

    // Base
    menuList.addAll([
      ItemModel(
        Localized.text('ox_chat.message_menu_report'),
        AssetImageData('assets/images/icon_report.png', package: 'ox_chat'),
        MessageLongPressEventType.report,
      ),
    ]);

    // own message
    if (OXUserInfoManager.sharedInstance.isCurrentUser(message.author.id)) {
      menuList.insert(0,
        ItemModel(
          Localized.text('ox_chat.message_menu_delete'),
          AssetImageData('assets/images/icon_delete.png', package: 'ox_chat'),
          MessageLongPressEventType.delete,
        ),
      );
    }

    // text message
    if (message is types.TextMessage) {
      menuList.insert(0,
        ItemModel(
          Localized.text('ox_chat.message_menu_copy'),
          AssetImageData('assets/images/icon_copy.png', package: 'ox_chat'),
          MessageLongPressEventType.copy,
        ),
      );
    }

    return menuList;
  }


  ImageGalleryOptions imageGalleryOptions({String decryptionKey = ''}) =>
      ImageGalleryOptions(
        maxScale: PhotoViewComputedScale.covered,
        minScale: PhotoViewComputedScale.contained,
        decryptionKey: decryptionKey,
      );
}

extension InputMoreItemEx on InputMoreItem {

  static album(ChatGeneralHandler handler) =>
      InputMoreItem(
        id: 'album',
        title: () => Localized.text('ox_chat_ui.input_more_album'),
        iconName: 'chat_photo_more.png',
        action: (context) {
          handler.albumPressHandler(context, 1);
        },
      );

  static camera(ChatGeneralHandler handler) =>
      InputMoreItem(
        id: 'camera',
        title: () => Localized.text('ox_chat_ui.input_more_camera'),
        iconName: 'chat_camera_more.png',
        action: (context) {
          handler.cameraPressHandler();
        },
      );

  static video(ChatGeneralHandler handler) =>
      InputMoreItem(
        id: 'video',
        title: () => Localized.text('ox_chat_ui.input_more_video'),
        iconName: 'chat_video_icon.png',
        action: (context) {
          handler.albumPressHandler(context, 2);
        },
      );

  static call(ChatGeneralHandler handler, UserDB? otherUser) =>
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

  static zaps(ChatGeneralHandler handler, UserDB? otherUser) =>
      InputMoreItem(
        id: 'zaps',
        title: () => Localized.text('ox_chat_ui.input_more_zaps'),
        iconName: 'chat_zaps_icon.png',
        action: (context) {
          final user = otherUser;
          if (user == null) {
            ChatLogUtils.error(className: 'ChatPageConfig', funcName: 'call', message: 'user is null');
            CommonToast.instance.show(context, 'User info not found');
            return ;
          }
          handler.zapsPressHandler(context, user);
        },
      );

}
