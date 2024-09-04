
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ox_chat/manager/chat_message_helper.dart';
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
import 'package:ox_common/upload/file_type.dart';
import 'package:ox_common/upload/upload_utils.dart';
import 'package:ox_common/utils/encode_utils.dart';
import 'package:ox_common/utils/image_picker_utils.dart';
import 'package:ox_common/utils/list_extension.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/custom_uri_helper.dart';
import 'package:ox_common/utils/video_utils.dart';
import 'package:ox_common/widgets/common_action_dialog.dart';
import 'package:ox_common/widgets/common_file_cache_manager.dart';
import 'package:ox_common/widgets/common_image_gallery.dart';
import 'package:ox_common/widgets/common_long_content_page.dart';
import 'package:ox_common/widgets/common_video_page.dart';
import 'package:uuid/uuid.dart';
import 'package:ox_chat/manager/chat_draft_manager.dart';
import 'package:ox_chat/manager/chat_data_cache.dart';
import 'package:ox_chat/manager/chat_page_config.dart';
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
import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/permission_utils.dart';
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
  }) : author = author ?? _defaultAuthor() {
    setupOtherUserIfNeeded();
    setupMentionHandlerIfNeeded();
  }

  final types.User author;
  UserDBISAR? otherUser;
  final ChatSessionModelISAR session;
  final types.EncryptionType fileEncryptionType;

  bool hasMoreMessage = false;

  ChatReplyHandler replyHandler = ChatReplyHandler();
  ChatMentionHandler? mentionHandler;

  TextEditingController inputController = TextEditingController();

  Function(List<types.Message>?)? refreshMessageUI;

  Set<String> reactionsListenMsgId = {};

  final tempMessageSet = <types.Message>{};

  static types.User _defaultAuthor() {
    UserDBISAR? userDB = OXUserInfoManager.sharedInstance.currentUserInfo;
    return types.User(
      id: userDB!.pubKey,
      sourceObject: userDB,
    );
  }

  static UserDBISAR? _defaultOtherUser(ChatSessionModelISAR session) {
    return Account.sharedInstance.userCache[session.getOtherPubkey]?.value;
  }

  void setupOtherUserIfNeeded() {
    if (session.hasMultipleUsers) return ;

    otherUser = _defaultOtherUser(session);

    if (otherUser == null) {
      final userFuture = Account.sharedInstance.getUserInfo(session.getOtherPubkey);
      if (userFuture is Future<UserDBISAR?>) {
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

    final mentionHandler = ChatMentionHandler(
      allUserGetter: userListGetter,
      isUseAllUserCache: session.chatType == ChatType.chatChannel,
    );
    userListGetter().then((userList) {
      mentionHandler.allUserCache = userList;
    });
    mentionHandler.inputController = inputController;

    this.mentionHandler = mentionHandler;
  }

  void dispose() {
    // for (var msg in tempMessageSet) {
    //   ChatDataCache.shared.deleteMessage(session, msg);
    // }
    ChatDataCache.shared.cleanSessionMessage(session);
    removeMessageReactionsListener();
  }
}

extension ChatMessageHandlerEx on ChatGeneralHandler {

  Future loadMoreMessage(
      List<types.Message> originMessage, {
        List<types.Message>? allMessage,
        int increasedCount = ChatPageConfig.messagesPerPage,
      }) async {
    // final allMsg = allMessage ?? (await ChatDataCache.shared.getSessionMessage(session));
    // var end = 0;
    // // Find the index of the last message in all the messages.
    // var index = -1;
    // for (int i = originMessage.length - 1; i >= 0; i--) {
    //   final msg = originMessage[i];
    //   final result = allMsg.indexOf(msg);
    //   if (result >= 0) {
    //     index = result;
    //     break ;
    //   }
    // }
    // if (index == -1 && increasedCount == 0) {
    //   end = ChatPageConfig.messagesPerPage;
    // } else {
    //   end = index + 1 + increasedCount;
    // }
    // hasMoreMessage = end < allMsg.length;
    //
    // final newMessageList = allMsg.sublist(0, min(allMsg.length, end));
    // refreshMessageUI?.call(newMessageList);

    final newMessages = await ChatDataCache.shared.loadSessionMessage(
      session: session,
      loadMsgCount: increasedCount,
    );
    hasMoreMessage = newMessages.isNotEmpty;

    final messages = await ChatDataCache.shared.getSessionMessage(session: session);
    updateMessageReactionsListener(messages);
  }

  void refreshMessage(List<types.Message> messages) {
    refreshMessageUI?.call(messages);
  }
}

extension ChatGestureHandlerEx on ChatGeneralHandler {

  void messageStatusPressHandler(BuildContext context, types.Message message) async {
    final status = message.status;
    switch (status) {
      case types.Status.warning:
        await OXCommonHintDialog.show(
          context,
          title: Localized.text('ox_usercenter.warn_title'),
          content: 'This message is not a gift-wrapped message.',
          actionList: [OXCommonHintAction.sure(
              text: 'OK')
          ],
          isRowAction: true,
          showCancelButton: false,
        );
      case types.Status.error:
        final result = await OXCommonHintDialog.showConfirmDialog(
          context,
          content: Localized.text('ox_chat.message_resend_hint'),
        );
        if (result) {
          OXNavigator.pop(context);
          resendMessage(context, message);
        }
        break ;
      default:
        break ;
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
      CommonVideoPage.show(message.videoURL);
    } else if (message is types.ImageMessage) {
      imageMessagePressHandler(
        messageId: message.id,
        imageUri: message.uri,
      );
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
        case CustomMessageType.imageSending:
          imageMessagePressHandler(
            messageId: message.id,
            imageUri: ImageSendingMessageEx(message).url,
          );
          break;
        case CustomMessageType.video:
          CommonVideoPage.show(VideoMessageEx(message).url);
          break;
        default:
          break;
      }
    } else if (message is types.TextMessage && message.text.length > message.maxLimit) {
      final text = message.text;
      OXNavigator.presentPage(context, (context) =>
          CommonLongContentPage(
            content: text,
            author: message.author.sourceObject,
            timeStamp: message.createdAt,
          ));
    }
  }

  Future imageMessagePressHandler({
    required String messageId,
    required String imageUri,
  }) async {
    final messages = await ChatDataCache.shared.getSessionMessage(session: session);
    final gallery = messages.map((message) {
      if (message is types.ImageMessage) {
        return PreviewImage(
          id: message.id,
          uri: message.uri,
          decryptSecret: message.decryptKey,
        );
      } else if (message is types.CustomMessage
          && message.customType == CustomMessageType.imageSending) {
        String uri = ImageSendingMessageEx(message).url;
        if (uri.isEmpty) {
          uri = ImageSendingMessageEx(message).path;
        }
        if (uri.isEmpty) return null;

        return PreviewImage(
          id: message.id,
          uri: uri,
          decryptSecret: message.decryptKey,
        );
      }
    }).whereNotNull().toList();

    final initialPage = gallery.indexWhere(
      (element) => element.id == messageId || element.uri == imageUri,
    );
    if (initialPage < 0) {
      ChatLogUtils.error(
        className: 'ChatGeneralHandler',
        funcName: 'imageMessagePressHandler',
        message: 'image not found',
      );
      return ;
    }

    CommonImageGallery.show(
      imageList: gallery.map((e) => ImageEntry(
        id: e.id,
        url: e.uri,
        decryptedKey: e.decryptSecret,
      )).toList(),
      initialPage: initialPage,
    );
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
  void _copyMenuItemPressHandler(types.Message message) {
    if (message is types.TextMessage) {
      Clipboard.setData(ClipboardData(text: message.text));
    }
  }

  /// Handles the press event for the "Delete" button in a menu item.
  void _deleteMenuItemPressHandler(BuildContext context, types.Message message) async {
    final messageId = message.remoteId;
    if (messageId == null || messageId.isEmpty) {
      messageDeleteHandler(message);
      return;
    }

    // Relay group && has delete permission
    if (session.chatType == ChatType.chatRelayGroup) {
      _showDeleteMode(context, message);
      return ;
    }

    // General
    _performDeleteAction(
      context: context,
      message: message,
      deleteAction: () => Messages.deleteMessageFromRelay(messageId, ''),
    );
  }

  void _showDeleteMode(BuildContext context, types.Message message) async {
    final messageId = message.remoteId;
    final groupId = session.groupId;
    if (groupId == null || groupId.isEmpty) return ;
    if (messageId == null || messageId.isEmpty) {
      messageDeleteHandler(message);
      return;
    }

    const forMeActionType = 0;
    const forAllActionType = 1;
    final result = await OXActionDialog.show(
      context,
      data: [
        OXActionModel(
          identify: forMeActionType,
          text: 'delete_message_me_action_mode'.localized(),
        ),
        if (RelayGroup.sharedInstance.hasDeletePermission(groupId))
          OXActionModel(
            identify: forAllActionType,
            text: 'delete_message_everyone_action_mode'.localized(),
          ),
      ],
    );

    if (result == null) return ;

    final identify = result.identify;
    switch (identify) {
      case forMeActionType:
        _performDeleteAction(
          context: context,
          message: message,
          deleteAction: () async {
            return RelayGroup.sharedInstance.deleteMessageFromLocal(messageId);
          },
        );
        break;
      case forAllActionType:
        _performDeleteAction(
          context: context,
          message: message,
          deleteAction: () async {
            return RelayGroup.sharedInstance.deleteMessageFromRelay(
              groupId,
              messageId,
              '',
            );
          },
        );
        break;
    }
  }

  void _performDeleteAction({
    required BuildContext context,
    required types.Message message,
    required Future<OKEvent> Function() deleteAction,
  }) async {
    final result = await OXCommonHintDialog.showConfirmDialog(
      context,
      content: Localized.text('ox_chat.message_delete_hint'),
    );

    if (result) {
      OXLoading.show();
      OKEvent event = await deleteAction(); //await Messages.deleteMessageFromRelay(messageId, '');
      OXLoading.dismiss();
      if (event.status) {
        OXNavigator.pop(null);
        messageDeleteHandler(message);
      } else {
        CommonToast.instance.show(context, event.message);
      }
    }
  }

  /// Handles the press event for the "Report" button in a menu item.
  void _reportMenuItemPressHandler(BuildContext context, types.Message message) async {

    ChatLogUtils.info(
      className: 'ChatMessagePage',
      funcName: '_reportMenuItemPressHandler',
      message: 'id: ${message.id}, content: ${message.content}',
    );

    final reportSuccess = await ReportDialog.show(context, target: MessageReportTarget(message));
    final messageDeleteHandler = this.messageDeleteHandler;
    if (reportSuccess == true) {
      messageDeleteHandler(message);
    }
  }

  void _zapMenuItemPressHandler(BuildContext context, types.Message message) async {
    final user = await Account.sharedInstance.getUserInfo(message.author.id);
    final eventId = message.remoteId;
    if (user == null || eventId == null || eventId.isEmpty) {
      CommonToast.instance.show(
        context,
        'Failed: Critical information is missing, user is null: ${user == null}, eventId: $eventId',
      );
      return ;
    }
    ZapsActionHandler handler = await ZapsActionHandler.create(
      userDB: user,
      isAssistedProcess: true,
      zapType: session.asZapType,
      groupId: session.hasMultipleUsers ? session.groupId : null,
    );
    await handler.handleZap(context: context, eventId: eventId);
  }

  void messageDeleteHandler(types.Message message) {
    ChatDataCache.shared.deleteMessage(session, message);
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

    final completer = Completer<bool>();
    final messageId = message.remoteId;
    if (messageId == null || messageId.isEmpty) {
      ChatLogUtils.error(
        className: 'ChatMessagePage',
        funcName: 'reactionPressHandler',
        message: 'messageId is $messageId',
      );
      return false;
    }

    // Check if already sent it
    final reactions = [...message.reactions];
    for (var reaction in reactions) {
      if (reaction.content != content) continue ;
      final authors = [...reaction.authors];
      final haveSent = authors.any((authorPubkey) =>
          OXUserInfoManager.sharedInstance.isCurrentUser(authorPubkey));
      if (haveSent) {
        return false;
      }
    }

    Messages.sharedInstance.sendMessageReaction(
      messageId,
      content,
      groupId: session.groupId
    ).then((event) {
      if (!completer.isCompleted) {
        completer.complete(event.status);
      }
    });

    // Pre-update UI
    final author = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey;
    if (author != null && author.isNotEmpty) {
      final reactions = [...message.reactions];
      bool isNewContent = true;
      for (var reaction in reactions) {
        if (reaction.content != content) continue ;
        reaction.authors.add(author);
        isNewContent = false;
      }
      if (isNewContent) {
        reactions.add(
          Reaction(
            authors: [author],
            content: content,
          )
        );
      }

      ChatDataCache.shared.updateMessage(
        session: session,
        message: message.copyWith(
          reactions: reactions,
        ),
      );
    }

    return completer.future;
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
        final messageSendHandler = type == 2 ? this.sendVideoMessage : this.sendImageMessage;
        messageSendHandler(context, fileList);
        return;
      }
    } else {
      storagePermission = await PermissionUtils.getPhotosPermission(context,type: type);
    }
    if(storagePermission){
      await _goToPhoto(context, type);
    } else {
    }
  }

  Future cameraPressHandler(BuildContext context,) async {
    _goToCamera(context);
  }

  Future callPressHandler(BuildContext context, UserDBISAR user) async {
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

  Future zapsPressHandler(BuildContext context, UserDBISAR user) async {
    ZapsActionHandler handler = await ZapsActionHandler.create(
      userDB: user,
      isAssistedProcess: true,
      zapType: session.asZapType,
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
    final messageSendHandler = isVideo ? this.sendVideoMessage : this.sendImageMessage;

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

extension ChatReactionsHandlerEx on ChatGeneralHandler {

  void updateMessageReactionsListener(List<types.Message> newMessageList) {
    final actionSubscriptionId = newMessageList
        .map((e) => e.remoteId)
        .where((id) => id != null && id.isNotEmpty)
        .toList()
        .cast<String>();

    reactionsListenMsgId.addAll(actionSubscriptionId);

    Messages.sharedInstance.loadMessagesReactions(reactionsListenMsgId.toList(), session.chatType);
  }

  void removeMessageReactionsListener() {
    reactionsListenMsgId.clear();
    Messages.sharedInstance.closeMessagesActionsRequests();
  }
}

extension StringChatEx on String {
  /// Returns whether it is a local path or null if it is not a path String
  bool? get isLocalPath {
    return !this.startsWith('http://') && !this.startsWith('https://') && !this.startsWith('data:image/');
  }
}

extension ChatZapsEx on ChatSessionModelISAR {
  ZapType? get asZapType {
    switch (chatType) {
      case ChatType.chatSingle:
      case ChatType.chatStranger:
      case ChatType.chatSecret:
      case ChatType.chatSecretStranger:
        return ZapType.privateChat;
      case ChatType.chatGroup:
        return ZapType.privateGroup;
      case ChatType.chatChannel:
        return ZapType.channelChat;
      case ChatType.chatRelayGroup:
        return ZapType.relayGroup;
    }
    return null;
  }
}