
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ox_chat/page/session/chat_video_play_page.dart';
import 'package:ox_chat/page/session/zaps_sending_page.dart';
import 'package:ox_chat/utils/message_factory.dart';
import 'package:ox_chat_ui/ox_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat/page/contacts/contact_friend_user_info_page.dart';
import 'package:ox_chat/utils/chat_log_utils.dart';
import 'package:ox_chat/utils/message_report.dart';
import 'package:ox_chat/widget/report_dialog.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/permission_utils.dart';
import 'package:ox_common/utils/uplod_aliyun_utils.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/common_webview.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:images_picker/images_picker.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:ox_module_service/ox_module_service.dart';

import 'custom_message_utils.dart';

class ChatGeneralHandler {

  ValueChanged<types.Message>? messageDeleteHandler;

  ValueChanged<types.Message>? messageResendHandler;

  Future Function(List<File> images)? imageMessageSendHandler;

  Future Function(List<File> images)? videoMessageSendHandler;

  Future Function(String invoice, String amount, String description)? zapsMessageSendHandler;

  Future<String> uploadFile({
    required UplodAliyunType fileType,
    required String filePath,
    required String messageId,
    String? pubkey,
  }) async {
    final file = File(filePath);
    final ext = path.extension(filePath);
    final fileName = '$messageId$ext';
    return await UplodAliyun.uploadFileToAliyun(fileType: fileType, file: file, filename: fileName, pubkey: pubkey);
  }

  Future<types.Message?> prepareSendImageMessage(
    BuildContext context,
    types.ImageMessage message, {
    String? pubkey,
  }) async {
    final filePath = message.uri;
    final uriIsLocalPath = filePath.isLocalPath;

    if (uriIsLocalPath == null) {
      ChatLogUtils.error(
        className: 'ChatGroupMessagePage',
        funcName: '_resendMessage',
        message: 'message: ${message.toJson()}',
      );
      return null;
    }

    if (uriIsLocalPath) {
      final uri = await uploadFile(fileType: UplodAliyunType.imageType, filePath: filePath, messageId: message.id, pubkey: pubkey);
      if (uri.isEmpty) {
        CommonToast.instance.show(context, Localized.text('ox_chat.message_send_image_fail'));
        return null;
      }
      return message.copyWith(uri: uri);
    }
    return message;
  }

  Future<types.Message?> prepareSendAudioMessage(
    BuildContext context,
    types.AudioMessage message, {
    String? pubkey,
  }) async {
    final filePath = message.uri;
    final uriIsLocalPath = filePath.isLocalPath;

    if (uriIsLocalPath == null) {
      ChatLogUtils.error(
        className: 'ChatGroupMessagePage',
        funcName: '_resendMessage',
        message: 'message: ${message.toJson()}',
      );
      return null;
    }

    if (uriIsLocalPath) {
      final uri = await uploadFile(fileType: UplodAliyunType.voiceType, filePath: filePath, messageId: message.id, pubkey: pubkey);
      if (uri.isEmpty) {
        CommonToast.instance.show(context, Localized.text('ox_chat.message_send_audio_fail'));
        return null;
      }
      return message.copyWith(uri: uri);
    }
    return message;
  }

  Future<types.Message?> prepareSendVideoMessage(
    BuildContext context,
    types.VideoMessage message, {
    String? pubkey,
  }) async {
    final filePath = message.metadata?['videoUrl'] as String ?? '';
    final uriIsLocalPath = filePath.isLocalPath;

    if (filePath.isEmpty || uriIsLocalPath == null) {
      ChatLogUtils.error(
        className: 'ChatGroupMessagePage',
        funcName: '_resendMessage',
        message: 'message: ${message.toJson()}',
      );
      return null;
    }

    if (uriIsLocalPath) {
      final uri = await uploadFile(fileType: UplodAliyunType.videoType, filePath: filePath, messageId: message.id, pubkey: pubkey);
      if (uri.isEmpty) {
        CommonToast.instance.show(context, Localized.text('ox_chat.message_send_video_fail'));
        return null;
      }
      return message.copyWith(
        metadata: {
          'videoUrl': uri,
        },
      );
    }
    return message;
  }

  void syncChatSessionForSendMsg({
    required int createTime,
    required String content,
    required MessageType type,
    String decryptContent = '',
    String receiver = '',
    String groupId = '',
  }) async {

    final sender = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey;
    if (sender == null) {
      ChatLogUtils.error(
          className: 'ChatGeneralHandler',
          funcName: 'syncChatSessionForSendMsg',
          message: 'sender is null',
      );
      return ;
    }

    final time = (createTime / 1000).round();

    final messageDB = MessageDB(
      sender: sender,
      receiver: receiver,
      groupId: groupId,
      createTime: time,
      content: content,
      decryptContent: decryptContent,
      read: true,
      type: MessageDB.messageTypeToString(type),
    );

    OXChatBinding.sharedInstance.syncChatSessionTable(messageDB);
  }
}

extension ChatGestureHandlerEx on ChatGeneralHandler {

  void messageStatusPressHandler(BuildContext context, types.Message message) async {
    final messageResendHandler = this.messageResendHandler;
    if (messageResendHandler == null || message.status != types.Status.error) return ;

    final result = await OXCommonHintDialog.showConfirmDialog(
      context,
      content: Localized.text('ox_chat.message_resend_hint'),
    );
    if (result) {
      OXNavigator.pop(context);
      messageResendHandler(message);
    }
  }

  /// Handles the avatar click event in chat messages.
  Future avatarPressHandler(context, {required String userId}) async {

    if (OXUserInfoManager.sharedInstance.isCurrentUser(userId)) {
      ChatLogUtils.info(className: 'ChatMessagePage', funcName: '_avatarPressHandler', message: 'Not allowed push own detail page');
      return ;
    }

    var userDB = await Account.getUserFromDB(pubkey: userId);
    if (userDB == null) {
      OXLoading.show();
      Map<String, UserDB> result = await Account.syncProfilesFromRelay([userId]);
      OXLoading.dismiss();
      userDB = result[userId];
    }

    if (userDB == null) {
      CommonToast.instance.show(context, 'User not found');
      return ;
    }

    await OXNavigator.pushPage(context, (context) => ContactFriendUserInfoPage(userDB: userDB!));
  }

  TextMessageOptions textMessageOptions(BuildContext context) =>
      TextMessageOptions(
        isTextSelectable:false,
        openOnPreviewTitleTap: true,
        onLinkPressed: (url) => _onLinkTextPressed(context, url),
      );

  void _onLinkTextPressed(BuildContext context, String text) {
    OXNavigator.presentPage(context, (context) => CommonWebView(text));
  }

  Future messagePressHandler(BuildContext context, types.Message message) async {
    if (message is types.VideoMessage) {
      OXNavigator.pushPage(context, (context) => ChatVideoPlayPage(videoUrl: message.metadata!["videoUrl"] ?? ''));
    } else if (message is types.CustomMessage) {
      switch(message.customType) {
        case CustomMessageType.zaps:
          await zapsMessagePressHandler();
          break ;
        default:
          break ;
      }
    }
  }

  Future zapsMessagePressHandler() async {

  }
}

extension ChatMenuHandlerEx on ChatGeneralHandler {
  /// Handles the press event for a menu item.
  void menuItemPressHandler(BuildContext context, types.Message message, MessageLongPressEventType type) {
    switch (type) {
      case MessageLongPressEventType.copy:
        _copyMenuItemPressHandler(message);
        break;
      case MessageLongPressEventType.delete:
        _deleteMenuItemPressHandler(context, message);
        break;
      case MessageLongPressEventType.report:
        _reportMenuItemPressHandler(context, message);
        break;
      default:
        break;
    }
  }

  /// Handles the press event for the "Copy" button in a menu item.
  _copyMenuItemPressHandler(types.Message message) {
    if (message is types.TextMessage) {
      Clipboard.setData(ClipboardData(text: message.text));
    }
  }

  /// Handles the press event for the "Delete" button in a menu item.
  _deleteMenuItemPressHandler(BuildContext context, types.Message message) async {
    final result = await OXCommonHintDialog.showConfirmDialog(
      context,
      content: Localized.text('ox_chat.message_delete_hint'),
    );

    if (result) {
      final privkey = OXUserInfoManager.sharedInstance.currentUserInfo?.privkey;
      final messageId = message.remoteId;
      if (privkey != null && messageId != null) {
        OXLoading.show();
        OKEvent event = await Messages.deleteMessageFromRelay([messageId], '', privkey);
        OXLoading.dismiss();
        if (event.status) {
          OXNavigator.pop(context);
          final messageDeleteHandler = this.messageDeleteHandler;
          if (messageDeleteHandler != null) {
            messageDeleteHandler(message);
          }
        } else {
          CommonToast.instance.show(context, event.message);
        }
      } else {
        ChatLogUtils.error(className: 'ChatGeneralHandler', funcName: '_deleteMenuItemPressHandler', message: 'messageId: $messageId');
      }
    }
  }

  /// Handles the press event for the "Report" button in a menu item.
  _reportMenuItemPressHandler(BuildContext context, types.Message message) async {

    ChatLogUtils.info(
      className: 'ChatMessagePage',
      funcName: '_reportMenuItemPressHandler',
      message: 'id: ${message.id}, content: ${message.content}',
    );

    final reportSuccess = await ReportDialog.show(context, target: MessageReportTarget(message));
    final messageDeleteHandler = this.messageDeleteHandler;
    if (reportSuccess == true && messageDeleteHandler != null) {
      messageDeleteHandler(message);
    }
  }
}

extension ChatInputMoreHandlerEx on ChatGeneralHandler {

  // type: 1 - image, 2 - video
  Future albumPressHandler(BuildContext context, int type) async {
    final storagePermission = await PermissionUtils.getPhotosPermission();
    if(storagePermission){
      await _goToPhoto(type);
    } else {
      await OXCommonHintDialog.show(context, content: 'Please grant permission to access the photo', actionList: [
        OXCommonHintAction(
          text: () => 'Go to settings',
          onTap: () {
            openAppSettings();
            OXNavigator.pop(context);
          }),
      ]);
    }
  }

  Future cameraPressHandler() async {
    _goToCamera();
  }

  Future callPressHandler(BuildContext context, UserDB user) async {
    OXModuleService.pushPage(
      context,
      'ox_calling',
      'CallPage',
      {
        'userDB': user,
        'media': 'video',
      },
    );
  }

  Future zapsPressHandler(BuildContext context, UserDB user) async {
    final result = await OXNavigator.presentPage<Map<String, String>>(context, (context) => ZapsSendingPage(user));
    if (result != null) {
      final invoice = result['invoice'] ?? '';
      final amount = result['amount'] ?? '';
      final description = result['description'] ?? '';
      final zapsMessageSendHandler = this.zapsMessageSendHandler;
      if (invoice.isNotEmpty && amount.isNotEmpty && description.isNotEmpty && zapsMessageSendHandler != null)
        zapsMessageSendHandler(invoice, amount, description);
    }
  }

  Future<void> _goToPhoto(int type) async {

    final isVideo = type == 2;
    final pickType = isVideo ? PickType.video : PickType.image;
    final messageSendHandler = isVideo ? this.videoMessageSendHandler : this.imageMessageSendHandler;

    if (messageSendHandler == null) {
      ChatLogUtils.error(
        className: 'ChatGroupMessagePage',
        funcName: 'goToPhoto',
        message: 'messageSendHandler is null',
      );
      return ;
    }

    final res = await ImagesPicker.pick(
      count: 1, // Maximum selectable quantity
      pickType: pickType, // Select media type, default is image
      quality: 0.8, // only for android
      maxSize: 1024,
      gif: false,
    );

    if(res == null) return;

    List<File> fileList = [];
    await Future.forEach(res, (element) async {
      final entity = element;
      final file = File(entity.path);
      fileList.add(file);
    });

    messageSendHandler(fileList);
  }

  Future<void> _goToCamera() async {
    //Open the camera or gallery based on the status indicator
    List<Media>? res = await ImagesPicker.openCamera(
      pickType: PickType.image,
      quality: 0.8, // only for android
      maxSize: 1024,
    );
    final imageMessageSendHandler = this.imageMessageSendHandler;
    if(res == null || imageMessageSendHandler == null) return;

    final media = res.first;
    final file = File(media.path);
    imageMessageSendHandler([file]);
  }
}

extension StringChatEx on String {
  /// Returns whether it is a local path or null if it is not a path String
  bool? get isLocalPath {
    return !this.startsWith('http://') && !this.startsWith('https://');
  }
}