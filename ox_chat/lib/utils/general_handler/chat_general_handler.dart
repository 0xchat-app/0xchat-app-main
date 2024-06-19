
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ox_chat/manager/ecash_helper.dart';
import 'package:ox_chat/model/constant.dart';
import 'package:ox_chat/page/ecash/ecash_open_dialog.dart';
import 'package:ox_chat/page/ecash/ecash_sending_page.dart';
import 'package:ox_chat/utils/chat_voice_helper.dart';
import 'package:ox_chat/utils/custom_message_utils.dart';
import 'package:ox_chat/utils/general_handler/chat_mention_handler.dart';
import 'package:ox_chat/utils/general_handler/chat_reply_handler.dart';
import 'package:ox_chat/utils/message_parser/define.dart';
import 'package:ox_chat/utils/send_message/chat_send_message_helper.dart';
import 'package:ox_common/business_interface/ox_chat/call_message_type.dart';
import 'package:ox_common/business_interface/ox_wallet/interface.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/ox_common.dart';
import 'package:ox_common/utils/image_picker_utils.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/custom_uri_helper.dart';
import 'package:ox_common/widgets/common_action_dialog.dart';
import 'package:uuid/uuid.dart';
import 'package:ox_chat/manager/chat_draft_manager.dart';
import 'package:ox_chat/manager/chat_data_cache.dart';
import 'package:ox_chat/manager/chat_page_config.dart';
import 'package:ox_chat/page/session/chat_video_play_page.dart';
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
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_compress/video_compress.dart';
import 'package:flutter_chat_types/src/message.dart';
import 'package:device_info/device_info.dart';
import 'package:ox_common/widgets/zaps/zaps_action_handler.dart';

part 'chat_send_message_handler.dart';


class ChatGeneralHandler {

  ChatGeneralHandler({
    required this.session,
    types.User? author,
    this.refreshMessageUI,
    this.fileEncryptionType = types.EncryptionType.none,
  }) : author = author ?? _defaultAuthor(),
        otherUser = _defaultOtherUser(session) {
    setupOtherUserIfNeeded();
    setupMentionHandlerIfNeeded();
  }

  final types.User author;
  UserDB? otherUser;
  final ChatSessionModel session;
  final types.EncryptionType fileEncryptionType;

  bool hasMoreMessage = false;

  ChatReplyHandler replyHandler = ChatReplyHandler();
  ChatMentionHandler? mentionHandler;

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

  static UserDB? _defaultOtherUser(ChatSessionModel session) {
    return Account.sharedInstance.userCache[session.chatId]?.value
        ?? Account.sharedInstance.userCache[session.getOtherPubkey]?.value;
  }

  void setupOtherUserIfNeeded() {
    if (otherUser == null) {
      final userFuture = Account.sharedInstance.getUserInfo(session.getOtherPubkey);
      if (userFuture is Future<UserDB?>) {
        userFuture.then((value){
          otherUser = value;
        });
      } else {
        otherUser = userFuture;
      }
    }
  }

  void setupMentionHandlerIfNeeded() {
    final userListGetter = session.userListGetter;
    if (userListGetter == null) return ;

    final mentionHandler = ChatMentionHandler();
    userListGetter().then((userList) {
      mentionHandler.allUser = userList;
    });
    mentionHandler.inputController = inputController;

    this.mentionHandler = mentionHandler;
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

    await OXNavigator.pushPage(context, (context) => ContactUserInfoPage(pubkey: userDB.pubKey));
  }

  TextMessageOptions textMessageOptions(BuildContext context) =>
      TextMessageOptions(
        isTextSelectable:false,
        openOnPreviewTitleTap: true,
        onLinkPressed: (url) => _onLinkTextPressed(context, url),
      );

  void _onLinkTextPressed(BuildContext context, String text) {
    OXNavigator.presentPage(context, allowPageScroll: true, (context) => CommonWebView(text), fullscreenDialog: true);
  }

  Future messagePressHandler(BuildContext context, types.Message message) async {
    if (message is types.VideoMessage) {
      OXNavigator.pushPage(context, (context) => ChatVideoPlayPage(videoUrl: message.metadata!["videoUrl"] ?? ''));
    } else if (message is types.CustomMessage) {
      switch(message.customType) {
        case CustomMessageType.zaps:
          await zapsMessagePressHandler(context, message);
          break;
        case CustomMessageType.call:
          callMessagePressHandler(context, message);
          break;
        case CustomMessageType.template:
          templateMessagePressHandler(context, message);
          break;
        case CustomMessageType.note:
          noteMessagePressHandler(context, message);
          break;
        case CustomMessageType.ecash:
        case CustomMessageType.ecashV2:
          ecashMessagePressHandler(context, message);
          break;
        default:
          break;
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
        ? session.chatId : myPubkey;
    final invoice = ZapsMessageEx(message).invoice;
    final zapper = ZapsMessageEx(message).zapper;
    final description = ZapsMessageEx(message).description;

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
    final otherUser = this.otherUser;
    CallMessageType? pageType;
    switch (CallMessageEx(message).callType) {
      case CallMessageType.audio:
        pageType = CallMessageType.audio;
        break ;
      case CallMessageType.video:
        pageType = CallMessageType.video;
        break ;
      default:
        break ;
    }
    if (otherUser == null || pageType == null) return ;
    OXCallingInterface.pushCallingPage(
      context,
      otherUser,
      pageType,
    );
  }

  void templateMessagePressHandler(BuildContext context, types.CustomMessage message) {
    final link = TemplateMessageEx(message).link;
    if (link.isRemoteURL) {
      OXNavigator.presentPage(context, allowPageScroll: true, (context) => CommonWebView(link), fullscreenDialog: true);
    } else {
      link.tryHandleCustomUri(context: context);
    }
  }

  void noteMessagePressHandler(BuildContext context, types.CustomMessage message) {
    final link = NoteMessageEx(message).link;
    link.tryHandleCustomUri(context: context);
  }

  void ecashMessagePressHandler(BuildContext context, types.CustomMessage message) async {
    if (!OXWalletInterface.checkWalletActivate()) return ;
    final package = await EcashHelper.createPackageFromMessage(message);
    EcashOpenDialog.show(
      context: context,
      package: package,
      approveOnTap: () async {
        if (message.customType != CustomMessageType.ecashV2) return ;

        await Future.wait([
          ecashApproveHandler(context, message),
          Future.delayed(const Duration(seconds: 1)),
        ]);

        OXNavigator.pop(context);
      },
    );
  }

  Future ecashApproveHandler(BuildContext context, types.CustomMessage message) async {
    final tokenList = EcashV2MessageEx(message).tokenList;
    final signatureTokenList = <String>[];
    for (var token in tokenList) {
      final newToken = await EcashHelper.addSignatureToToken(token);
      if (newToken.isEmpty) {
        CommonToast.instance.show(context, 'Signature failure');
        return ;
      }
      signatureTokenList.add(newToken);
    }

    final signees = <EcashSignee>[];
    EcashV2MessageEx(message).signees.forEach((signee) {
      if (OXUserInfoManager.sharedInstance.isCurrentUser(signee.$1)) {
        signees.add((signee.$1, 'finished'));
      } else {
        signees.add(signee);
      }
    });

    sendEcashMessage(
      context,
      tokenList: signatureTokenList,
      receiverPubkeys: EcashV2MessageEx(message).receiverPubkeys,
      signees: signees,
    );

    EcashHelper.setMessageSigned(message.id);
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
      case MessageLongPressEventType.zaps:
        _zapMenuItemPressHandler(context, message);
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

  _zapMenuItemPressHandler(BuildContext context, types.Message message) async {
    UserDB? user = await Account.sharedInstance.getUserInfo(message.author.id);
    if(user == null) return;
    if (user.lnAddress.isEmpty) {
      await CommonToast.instance.show(context, 'The friend has not set LNURL!');
      return;
    }
    // await OXNavigator.presentPage(
    //   context,
    //       (context) => MomentZapPage(
    //     userDB: user,
    //     eventId: message.remoteId,
    //     isDefaultEcashWallet: true,
    //   ),
    // );
  }

  /// Handles the press event for the "Reaction emoji" in a menu item.
  Future<bool> reactionPressHandler(
    BuildContext context,
    types.Message message,
    String content,
  ) async {
    ChatLogUtils.info(
      className: 'ChatMessagePage',
      funcName: 'reactionPressHandler',
      message: 'id: ${message.id}, content: ${message.content}',
    );
    final messageId = message.remoteId;
    if (messageId == null || messageId.isEmpty) {
      ChatLogUtils.error(
        className: 'ChatMessagePage',
        funcName: 'reactionPressHandler',
        message: 'messageId is $messageId',
      );
      return false;
    }

    final event = await Messages.sharedInstance.sendMessageReaction(
      messageId,
      content,
    );
    return event.status;
  }
}

extension ChatInputMoreHandlerEx on ChatGeneralHandler {

  // type: 1 - image, 2 - video
  Future albumPressHandler(BuildContext context, int type) async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    bool storagePermission = false;
    if (Platform.isAndroid && (await plugin.androidInfo).version.sdkInt >= 34) {
      Map<String, bool> result = await OXCommon.request34MediaPermission(type);
      LogUtil.e('Michael: albumPressHandler----result =${result.toString()}');
      bool readMediaImagesGranted = result['READ_MEDIA_IMAGES'] ?? false;
      bool readMediaVideoGranted = result['READ_MEDIA_VIDEO'] ?? false;
      bool readMediaVisualUserSelectedGranted = result['READ_MEDIA_VISUAL_USER_SELECTED'] ?? false;
      if (readMediaImagesGranted || readMediaVideoGranted) {
        storagePermission = true;
      } else if (readMediaVisualUserSelectedGranted) {
        final filePaths = await OXCommon.select34MediaFilePaths(type);
        LogUtil.d('Michael: albumPressHandler------filePaths =${filePaths}');
        List<File> fileList = [];
        await Future.forEach(filePaths, (element) async {
          fileList.add(File(element));
        });
        final messageSendHandler = type == 2 ? this.sendVideoMessageSend : this.sendImageMessage;
        messageSendHandler(context, fileList);
        return;
      }
    } else {
      storagePermission = await PermissionUtils.getPhotosPermission(type: type);
    }
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
        OXActionModel(identify: 0, text: 'str_video_call'.localized(), iconName: 'icon_call_video.png', package: 'ox_chat', isUseTheme:true),
        OXActionModel(identify: 1, text: 'str_voice_call'.localized(), iconName: 'icon_call_voice.png', package: 'ox_chat', isUseTheme:true),
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
    ZapsActionHandler handler = await ZapsActionHandler.create(
      userDB: user,
      isAssistedProcess: true,
      zapsInfoCallback: (zapsInfo) {
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
      }
    );
    await handler.handleZap(context: context,);
  }

  Future ecashPressHandler(BuildContext context) async {
    if (!OXWalletInterface.checkWalletActivate()) return ;
    await OXNavigator.presentPage<Map<String, String>>(
      context, (_) =>
        EcashSendingPage(
          isGroupEcash: session.hasMultipleUsers,
          singleReceiver: !session.hasMultipleUsers ? otherUser : null,
          membersGetter: () async {
            final getter = session.userListGetter;
            return getter?.call();
          },
          ecashInfoCallback: (ecash) async {
            final (
              List<String> tokenList,
              List<String> receiverPubkeys,
              List<String> signeePubkeys,
              _,
            ) = ecash;
            if (tokenList.isEmpty) return ;

            if (tokenList.length == 1 && receiverPubkeys.isEmpty && signeePubkeys.isEmpty) {
              await sendTextMessage(context, tokenList.first);
            } else {
              sendEcashMessage(
                context,
                tokenList: tokenList,
                receiverPubkeys: receiverPubkeys,
                signees: signeePubkeys.map((pubkey) {
                  return (pubkey, '');
                }).toList(),
              );
            }
            OXNavigator.pop(context);
          },
        ),
    );
  }

  Future<void> _goToPhoto(BuildContext context, int type) async {
    // type: 1 - image, 2 - video
    final isVideo = type == 2;
    final messageSendHandler = isVideo ? this.sendVideoMessageSend : this.sendImageMessage;

    final res = await ImagePickerUtils.pickerPaths(
      galleryMode: isVideo ? GalleryMode.video : GalleryMode.image,
      selectCount: 1,
      showGif: false,
      compressSize: 1024,
    );

    List<File> fileList = [];
    await Future.forEach(res, (element) async {
      final entity = element;
      final file = File(entity.path ?? '');
      fileList.add(file);
    });

    messageSendHandler(context, fileList);
  }

  Future<void> _goToCamera(BuildContext context) async {
    //Open the camera or gallery based on the status indicator
    Media? res = await ImagePickerUtils.openCamera(
      cameraMimeType: CameraMimeType.photo,
      compressSize: 1024,
    );
    if(res == null) return;
    final file = File(res.path ?? '');
    sendImageMessage(context, [file]);
  }
}

extension ChatInputHandlerEx on ChatGeneralHandler {

  InputOptions get inputOptions => InputOptions(
    onTextChanged: _onTextChanged,
    textEditingController: inputController,
  );

  void _onTextChanged(String text) {
    final chatId = session.chatId;
    if (chatId.isEmpty) return ;
    ChatDraftManager.shared.updateTempDraft(chatId, text);
  }
}

extension StringChatEx on String {
  /// Returns whether it is a local path or null if it is not a path String
  bool? get isLocalPath {
    return !this.startsWith('http://') && !this.startsWith('https://') && !this.startsWith('data:image/');
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
      ChatDraftManager.shared.updateTempDraft(session.chatId, draft);
    }
    super.initState();
  }

  @override
  void dispose() {
    ChatDraftManager.shared.updateSession();
    super.dispose();
  }
}