
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ox_chat/utils/send_message/chat_send_message_helper.dart';
import 'package:ox_common/business_interface/ox_chat/call_message_type.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_action_dialog.dart';
import 'package:uuid/uuid.dart';
import 'package:ox_chat/manager/chat_draft_manager.dart';
import 'package:ox_chat/manager/chat_data_cache.dart';
import 'package:ox_chat/manager/chat_page_config.dart';
import 'package:ox_chat/page/session/chat_video_play_page.dart';
import 'package:ox_chat/page/session/zaps_sending_page.dart';
import 'package:ox_chat/utils/message_factory.dart';
import 'package:ox_chat_ui/ox_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat/page/contacts/contact_user_info_page.dart';
import 'package:ox_chat/utils/chat_log_utils.dart';
import 'package:ox_chat/utils/message_report.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_chat/widget/report_dialog.dart';
import 'package:ox_common/business_interface/ox_chat/custom_message_type.dart';
import 'package:ox_common/business_interface/ox_calling/interface.dart';
import 'package:ox_common/business_interface/ox_usercenter/interface.dart';
import 'package:ox_common/business_interface/ox_usercenter/zaps_detail_model.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/permission_utils.dart';
import 'package:ox_common/utils/uplod_aliyun_utils.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/common_webview.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:images_picker/images_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:video_compress/video_compress.dart';
import 'custom_message_utils.dart';
import 'chat_reply_handler.dart';

part 'chat_send_message_handler.dart';

class ChatGeneralHandler {

  ChatGeneralHandler({
    required this.session,
    types.User? author,
    this.refreshMessageUI,
    this.fileEncryptionType = types.EncryptionType.none,
  }) : author = author ?? _defaultAuthor();

  final types.User author;
  final ChatSessionModel session;
  final types.EncryptionType fileEncryptionType;

  bool hasMoreMessage = false;

  ChatReplyHandler replyHandler = ChatReplyHandler();

  TextEditingController inputController = TextEditingController();

  Function(List<types.Message>)? refreshMessageUI;

  ValueChanged<types.Message>? messageDeleteHandler;

  static types.User _defaultAuthor() {
    UserDB? userDB = OXUserInfoManager.sharedInstance.currentUserInfo;
    return types.User(
      id: userDB!.pubKey,
      sourceObject: userDB,
    );
  }
}

extension ChatMessageHandlerEx on ChatGeneralHandler {

  Future loadMoreMessage(
      List<types.Message> originMessage, {
        List<types.Message>? allMessage,
        int increasedCount = ChatPageConfig.messagesPerPage,
      }) async {
    final allMsg = allMessage ?? (await ChatDataCache.shared.getSessionMessage(session));
    var end = 0;
    // Find the index of the last message in all the messages.
    var index = -1;
    for (int i = originMessage.length - 1; i >= 0; i--) {
      final msg = originMessage[i];
      final result = allMsg.indexOf(msg);
      if (result >= 0) {
        index = result;
        break ;
      }
    }
    if (index == -1 && increasedCount == 0) {
      end = ChatPageConfig.messagesPerPage;
    } else {
      end = index + 1 + increasedCount;
    }
    hasMoreMessage = end < allMsg.length;
    refreshMessageUI?.call(allMsg.sublist(0, min(allMsg.length, end)));
  }

  void refreshMessage(List<types.Message> originMessage, List<types.Message> allMessage) {
    loadMoreMessage(originMessage, allMessage: allMessage, increasedCount: 0);
  }
}

extension ChatGestureHandlerEx on ChatGeneralHandler {

  void messageStatusPressHandler(BuildContext context, types.Message message) async {
    if (message.status != types.Status.error) return ;
    final result = await OXCommonHintDialog.showConfirmDialog(
      context,
      content: Localized.text('ox_chat.message_resend_hint'),
    );
    if (result) {
      OXNavigator.pop(context);
      resendMessage(context, message);
    }
  }

  /// Handles the avatar click event in chat messages.
  Future avatarPressHandler(context, {required String userId}) async {

    if (OXUserInfoManager.sharedInstance.isCurrentUser(userId)) {
      ChatLogUtils.info(className: 'ChatMessagePage', funcName: '_avatarPressHandler', message: 'Not allowed push own detail page');
      return ;
    }

    var userDB = await Account.sharedInstance.getUserInfo(userId);

    if (userDB == null) {
      CommonToast.instance.show(context, 'User not found');
      return ;
    }

    await OXNavigator.pushPage(context, (context) => ContactUserInfoPage(userDB: userDB));
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
          await zapsMessagePressHandler(context, message);
          break ;
        case CustomMessageType.call:
          callMessagePressHandler(context, message);
          break ;
        default:
          break ;
      }
    }
  }

  Future zapsMessagePressHandler(BuildContext context, types.CustomMessage message) async {

    OXLoading.show();

    final senderPubkey = message.author.sourceObject?.encodedPubkey ?? '';
    final myPubkey = OXUserInfoManager.sharedInstance.currentUserInfo?.encodedPubkey ?? '';

    if (senderPubkey.isEmpty) {
      CommonToast.instance.show(context, 'Error');
      return ;
    }
    if (myPubkey.isEmpty) {
      CommonToast.instance.show(context, 'Error');
      return ;
    }

    final receiverPubkey = senderPubkey == myPubkey
        ? (session.chatId ?? '' ): myPubkey;
    final invoice = message.invoice;
    final zapper = message.zapper;
    final description = message.description;

    final requestInfo = Zaps.getPaymentRequestInfo(invoice);

    final zapsReceiptList = await Zaps.getZapReceipt(zapper, invoice: invoice);
    final zapsReceipt = zapsReceiptList.length > 0 ? zapsReceiptList.first : null;

    OXLoading.dismiss();

    final zapsDetail = ZapsRecordDetail(
      invoice: invoice,
      amount: (requestInfo.amount.toDouble() * 100000000).toInt(),
      fromPubKey: senderPubkey,
      toPubKey: receiverPubkey,
      zapsTime: (requestInfo.timestamp.toInt() * 1000).toString(),
      description: description,
      isConfirmed: zapsReceipt != null,
    );

    OXUserCenterInterface.jumpToZapsRecordPage(context, zapsDetail);
  }

  void callMessagePressHandler(BuildContext context, types.CustomMessage message) {
    final user = message.author.sourceObject;
    CallMessageType? pageType;
    switch (message.callType) {
      case CallMessageType.audio:
        pageType = CallMessageType.audio;
        break ;
      case CallMessageType.video:
        pageType = CallMessageType.video;
        break ;
      default:
        break ;
    }
    if (user == null || pageType == null) return ;
    OXCallingInterface.pushCallingPage(
      context,
      user,
      pageType,
    );
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
      case MessageLongPressEventType.quote:
        replyHandler.quoteMenuItemPressHandler(context, message);
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
      final messageId = message.remoteId;
      if (messageId != null) {
        OXLoading.show();
        OKEvent event = await Messages.deleteMessageFromRelay([messageId], '');
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
      await _goToPhoto(context, type);
    } else {
      await OXCommonHintDialog.show(context, content: 'Please grant permission to access the photo', actionList: [
        OXCommonHintAction(
          text: () => 'Go to settings',
          onTap: () {
            openAppSettings();
            OXNavigator.pop(context);
          }),
      ], isRowAction: true, showCancelButton: true,);
    }
  }

  Future cameraPressHandler(BuildContext context,) async {
    _goToCamera(context);
  }

  Future callPressHandler(BuildContext context, UserDB user) async {
    OXActionModel? oxActionModel = await OXActionDialog.show(
      context,
      data: [
        OXActionModel(identify: 0, text: 'str_video_call'.localized(), iconName: 'icon_call_video.png', package: 'ox_chat'),
        OXActionModel(identify: 1, text: 'str_voice_call'.localized(), iconName: 'icon_call_voice.png', package: 'ox_chat'),
      ],
      backGroundColor: ThemeColor.color180,
      separatorCancelColor: ThemeColor.color190,
    );
    if (oxActionModel != null) {
      OXCallingInterface.pushCallingPage(
        context,
        user,
        oxActionModel.identify == 1 ? CallMessageType.audio : CallMessageType.video,
      );
    }
  }

  Future zapsPressHandler(BuildContext context, UserDB user) async {
    await OXNavigator.presentPage<Map<String, String>>(
      context, (_) => ZapsSendingPage(user, (zapsInfo) {
        final zapper = zapsInfo['zapper'] ?? '';
        final invoice = zapsInfo['invoice'] ?? '';
        final amount = zapsInfo['amount'] ?? '';
        final description = zapsInfo['description'] ?? '';
        if (zapper.isNotEmpty && invoice.isNotEmpty && amount.isNotEmpty && description.isNotEmpty) {
          sendZapsMessage(context, zapper, invoice, amount, description);
        } else {
          ChatLogUtils.error(
            className: 'ChatGeneralHandler',
            funcName: 'zapsPressHandler',
            message: 'zapper: $zapper, invoice: $invoice, amount: $amount, description: $description, ',
          );
        }
      }),
    );
  }

  Future<void> _goToPhoto(BuildContext context, int type) async {

    final isVideo = type == 2;
    final pickType = isVideo ? PickType.video : PickType.image;
    final messageSendHandler = isVideo ? this.sendVideoMessageSend : this.sendImageMessage;

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

    messageSendHandler(context, fileList);
  }

  Future<void> _goToCamera(BuildContext context) async {
    //Open the camera or gallery based on the status indicator
    List<Media>? res = await ImagesPicker.openCamera(
      pickType: PickType.image,
      quality: 0.8, // only for android
      maxSize: 1024,
    );
    if(res == null || res.isEmpty) return;

    final media = res.first;
    final file = File(media.path);
    sendImageMessage(context, [file]);
  }
}

extension ChatInputHandlerEx on ChatGeneralHandler {

  InputOptions get inputOptions => InputOptions(
    onTextChanged: _onTextChanged,
    textEditingController: inputController,
  );

  void _onTextChanged(String text) {
    final chatId = session.chatId ?? '';
    if (chatId.isEmpty) return ;
    ChatDraftManager.shared.updateTempDraft(chatId, text);
  }
}

extension StringChatEx on String {
  /// Returns whether it is a local path or null if it is not a path String
  bool? get isLocalPath {
    return !this.startsWith('http://') && !this.startsWith('https://');
  }
}

mixin ChatGeneralHandlerMixin<T extends StatefulWidget> on State<T> {

  @protected
  ChatSessionModel get session;

  @protected
  ChatGeneralHandler get chatGeneralHandler;

  @override
  void initState() {
    final draft = session.draft ?? '';
    if (draft.isNotEmpty) {
      chatGeneralHandler.inputController.text = draft;
      ChatDraftManager.shared.updateTempDraft(session.chatId ?? '', draft);
    }
    super.initState();
  }

  @override
  void dispose() {
    ChatDraftManager.shared.updateSession();
    super.dispose();
  }
}