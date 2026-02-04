
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_chat/manager/chat_page_config.dart';
import 'package:ox_chat/manager/ecash_helper.dart';
import 'package:ox_chat/model/constant.dart';
import 'package:ox_chat/page/ecash/ecash_open_dialog.dart';
import 'package:ox_chat/page/ecash/ecash_sending_page.dart';
import 'package:ox_chat/utils/custom_message_utils.dart';
import 'package:ox_chat/utils/general_handler/chat_mention_handler.dart';
import 'package:ox_chat/utils/general_handler/chat_reply_handler.dart';
import 'package:ox_chat/utils/message_parser/define.dart';
import 'package:ox_chat/utils/send_message/chat_send_message_helper.dart';
import 'package:ox_chat/widget/chat_send_image_prepare_dialog.dart';
import 'package:ox_common/business_interface/ox_chat/call_message_type.dart';
import 'package:ox_common/business_interface/ox_wallet/interface.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/ox_common.dart';
import 'package:ox_common/upload/file_type.dart';
import 'package:ox_common/upload/upload_utils.dart';
import 'package:ox_common/utils/aes_encrypt_utils.dart';
import 'package:ox_common/utils/clipboard.dart';
import 'package:ox_common/utils/encode_utils.dart';
import 'package:ox_common/utils/file_utils.dart';
import 'package:ox_common/utils/image_picker_utils.dart';
import 'package:ox_common/utils/list_extension.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/platform_utils.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/custom_uri_helper.dart';
import 'package:ox_common/utils/took_kit.dart';
import 'package:ox_common/utils/video_data_manager.dart';
import 'package:ox_common/widgets/common_action_dialog.dart';
import 'package:ox_common/widgets/common_file_cache_manager.dart';
import 'package:ox_common/widgets/common_image_gallery.dart';
import 'package:ox_common/widgets/common_long_content_page.dart';
import 'package:ox_common/widgets/common_video_page.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:uuid/uuid.dart';
import 'package:ox_chat/manager/chat_draft_manager.dart';
import 'package:ox_chat/manager/chat_data_cache.dart';
import 'package:ox_chat_ui/ox_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat/page/contacts/contact_user_info_page.dart';
import 'package:ox_chat/page/session/message_info_page.dart';
import 'package:ox_chat/utils/chat_log_utils.dart';
import 'package:ox_chat/utils/message_report.dart';
import 'package:ox_chat/utils/translate_service.dart' as TranslateServiceLib;
import 'package:ox_usercenter/page/set_up/translate_settings_page.dart' as TranslateSettings;
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
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/user_config_tool.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:flutter_chat_types/src/message.dart' as UIMessage;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:ox_common/widgets/zaps/zaps_action_handler.dart';

import '../../manager/chat_data_manager_models.dart';
import 'chat_highlight_message_handler.dart';
import 'message_data_controller.dart';

part 'chat_send_message_handler.dart';

class ChatGeneralHandler {

  ChatGeneralHandler({
    required this.session,
    types.User? author,
    this.anchorMsgId,
    int unreadMessageCount = 0,
  }) : author = author ?? _defaultAuthor(),
       fileEncryptionType = _fileEncryptionType(session) {
    setupDataController();
    setupOtherUserIfNeeded();
    setupReplyHandler();
    setupMentionHandlerIfNeeded();
    setupHighlightMessageHandler(session, unreadMessageCount);
  }

  final types.User author;
  UserDBISAR? otherUser;
  final ChatSessionModelISAR session;
  final types.EncryptionType fileEncryptionType;
  final String? anchorMsgId;

  GlobalKey<ChatState>? chatWidgetKey;
  late ChatReplyHandler replyHandler;
  ChatMentionHandler? mentionHandler;
  late MessageDataController dataController;
  late ChatHighlightMessageHandler highlightMessageHandler;

  TextEditingController inputController = TextEditingController();
  FocusNode? inputFocusNode;

  final tempMessageSet = <types.Message>{};

  bool isPreviewMode = false;

  /// Set in dispose(); used so deferred _runInitializeMessage (Linux) does not run after exit.
  bool _disposed = false;

  static types.User _defaultAuthor() {
    UserDBISAR? userDB = OXUserInfoManager.sharedInstance.currentUserInfo;
    return types.User(
      id: userDB!.pubKey,
      sourceObject: userDB,
    );
  }

  static types.EncryptionType _fileEncryptionType(ChatSessionModelISAR session) {
    final sessionType = session.chatType;
    switch (sessionType) {
      case ChatType.chatSingle:
      case ChatType.chatStranger:
      case ChatType.chatSecret:
      case ChatType.chatGroup:
        return types.EncryptionType.encrypted;
      case ChatType.chatChannel:
      case ChatType.chatRelayGroup:
        return types.EncryptionType.none;
      default:
        return types.EncryptionType.none;
    }
  }

  static UserDBISAR? _defaultOtherUser(ChatSessionModelISAR session) {
    return Account.sharedInstance.userCache[session.getOtherPubkey]?.value;
  }

  void setupDataController() {
    final chatType = session.chatTypeKey;
    if (chatType == null) throw Exception('setupDataController: chatType is null');
    dataController = MessageDataController(chatType);
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

  void setupReplyHandler() {
    replyHandler = ChatReplyHandler(session.chatId);
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

  void setupHighlightMessageHandler(ChatSessionModelISAR session, int unreadMessageCount) {
    highlightMessageHandler = ChatHighlightMessageHandler(session.chatId)
      ..dataController = dataController
      ..unreadMessageCount = unreadMessageCount;

    highlightMessageHandler.initialize(session).then((_) {
      if (!isPreviewMode) {
        OXChatBinding.sharedInstance.removeReactionMessage(session.chatId, false);
        OXChatBinding.sharedInstance.removeMentionMessage(session.chatId, false);
      }
    });
  }

  /// On Linux, defer to after first frame and yield to GTK event loop so app does not report "not responding".
  /// Set env OXCHAT_LINUX_SKIP_SESSION_LOAD=1 to skip message/gallery load (for diagnosing freeze).
  Future initializeMessage() async {
    if (Platform.isLinux && kDebugMode) {
      debugPrint('[LINUX_DIAG] initializeMessage called, chatId=${session.chatId}');
    }
    if (Platform.isLinux) {
      final skipLoad = Platform.environment['OXCHAT_LINUX_SKIP_SESSION_LOAD'] == '1';
      if (skipLoad && kDebugMode) {
        debugPrint('[LINUX_DIAG] OXCHAT_LINUX_SKIP_SESSION_LOAD=1, skipping load');
        return;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration.zero, () => _runInitializeMessage());
      });
      return;
    }
    await _runInitializeMessage();
  }

  Future _runInitializeMessage() async {
    if (_disposed) return;
    if (Platform.isLinux && kDebugMode) debugPrint('[LINUX_DIAG] _runInitializeMessage start');
    if (Platform.isLinux) await Future.delayed(Duration.zero);
    if (_disposed) return;
    final anchorMsgId = this.anchorMsgId;
    if (anchorMsgId != null && anchorMsgId.isNotEmpty) {
      if (Platform.isLinux && kDebugMode) debugPrint('[LINUX_DIAG] loadNearbyMessage start');
      await dataController.loadNearbyMessage(
        targetMessageId: anchorMsgId,
        beforeCount: ChatPageConfig.messagesPerPage,
        afterCount: ChatPageConfig.messagesPerPage,
      );
      if (Platform.isLinux && kDebugMode) debugPrint('[LINUX_DIAG] loadNearbyMessage done');
    } else {
      if (Platform.isLinux && kDebugMode) debugPrint('[LINUX_DIAG] loadMoreMessage start');
      final messages = await dataController.loadMoreMessage(
        loadMsgCount: ChatPageConfig.messagesPerPage,
      );
      if (Platform.isLinux && kDebugMode) debugPrint('[LINUX_DIAG] loadMoreMessage done, count=${messages.length}');
      if (_disposed) return;
      if (Platform.isLinux) await Future.delayed(Duration.zero);
      if (_disposed) return;
      final chatType = session.coreChatType;
      if (chatType != null) {
        int? since = messages.firstOrNull?.createdAt;
        if (since != null) since ~/= 1000;
        Messages.recoverMessagesFromRelay(
          session.chatId,
          chatType,
          since: since,
        );
      }
    }
    if (_disposed) return;
    if (Platform.isLinux) await Future.delayed(Duration.zero);
    if (_disposed) return;
    if (Platform.isLinux && kDebugMode) debugPrint('[LINUX_DIAG] initializeImageGallery start');
    await initializeImageGallery();
    if (Platform.isLinux && kDebugMode) debugPrint('[LINUX_DIAG] initializeImageGallery done');
  }

  /// Limit gallery load on Linux to avoid memory spike.
  static const int kGalleryLoadLimit = 200;

  Future initializeImageGallery() async {
    if (_disposed) return;
    if (Platform.isLinux && kDebugMode) debugPrint('[LINUX_DIAG] getLocalMessage (gallery) start');
    final messageList = await dataController.getLocalMessage(
      messageTypes: [
        MessageType.image,
        MessageType.encryptedImage,
        MessageType.template,
      ],
      limit: Platform.isLinux ? kGalleryLoadLimit : null,
    );
    if (Platform.isLinux && kDebugMode) debugPrint('[LINUX_DIAG] getLocalMessage done, count=${messageList.length}');
    if (_disposed) return;
    if (Platform.isLinux && kDebugMode) debugPrint('[LINUX_DIAG] initializePreviewImages start');
    await dataController.galleryCache.initializePreviewImages(messageList);
    if (Platform.isLinux && kDebugMode) debugPrint('[LINUX_DIAG] initializePreviewImages done');
    if (Platform.isLinux) await Future.delayed(Duration.zero);
  }

  void dispose() {
    _disposed = true;
    dataController.dispose();
    highlightMessageHandler.dispose();
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
        isTextSelectable: PlatformUtils.isDesktop,
        openOnPreviewTitleTap: true,
        onLinkPressed: (url) => _onLinkTextPressed(context, url),
      );

  void _onLinkTextPressed(BuildContext context, String text) {
    OXModuleService.invoke('ox_common', 'gotoWebView', [context, text, null, null, null, null]);
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
          final videoURI = VideoMessageEx(message).videoURI;
          if (videoURI.isEmpty) return ;

          CommonVideoPage.show(videoURI);
          break;
        default:
          break;
      }
    } else if (message is types.TextMessage && message.text.length > message.maxLimit) {
      final text = message.text;
      CommonLongContentPage.present(
        context: context,
        content: text,
        author: message.author.sourceObject,
        timeStamp: message.createdAt,
      );
    }
  }

  Future imageMessagePressHandler({
    required String messageId,
    required String imageUri,
  }) async {

    final galleryCache = dataController.galleryCache;

    await galleryCache.initializeComplete;

    final gallery = galleryCache.gallery;
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
        decryptedNonce: e.decryptNonce,
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
    final amount = Zaps.getPaymentRequestAmount(invoice);

    final zapsReceiptList = await Zaps.getZapReceipt(zapper, invoice: invoice);
    final zapsReceipt = zapsReceiptList.length > 0 ? zapsReceiptList.first : null;

    OXLoading.dismiss();

    final zapsDetail = ZapsRecordDetail(
      invoice: invoice,
      amount: amount,
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
      OXModuleService.invoke('ox_common', 'gotoWebView', [context, link, null, null, null, null]);
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
      final newToken = await EcashHelper.addP2PKSignatureToToken(token);
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
        replyHandler.quoteMenuItemPressHandler(message);
        break;
      case MessageLongPressEventType.zaps:
        _zapMenuItemPressHandler(context, message);
        break;
      case MessageLongPressEventType.info:
        _infoMenuItemPressHandler(context, message);
        break;
      case MessageLongPressEventType.translate:
        _translateMenuItemPressHandler(context, message);
        break;
      default:
        break;
    }
  }

  /// Handles the press event for the "Copy" button in a menu item.
  void _copyMenuItemPressHandler(types.Message message) async {
    if (message is types.TextMessage) {
      Clipboard.setData(ClipboardData(text: message.text));
    } else if (message.isSingleEcashMessage) {
      final token = EcashV2MessageEx(message as types.CustomMessage).tokenList.first;
      Clipboard.setData(ClipboardData(text: token));
    } else if (message is types.CustomMessage && message.customType == CustomMessageType.imageSending) {
      var path = ImageSendingMessageEx(message).path;
      final url = ImageSendingMessageEx(message).url;
      if (path.isEmpty && url.isNotEmpty) {
        final manager = OXFileCacheManager.get(
          encryptKey: message.decryptKey,
          encryptNonce: message.decryptNonce,
        );
        final file = await manager.getFileFromCache(url);
        path = file?.file.path ?? '';
      }
      if (path.isNotEmpty) {
        OXClipboard.copyImageToClipboard(path);
      }
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
    BuildContext? tempContext;
    final result = await OXCommonHintDialog.showConfirmDialog(
      context,
      content: Localized.text('ox_chat.message_delete_hint'),
      onDialogContextCreated: (BuildContext dialogContext) {
        tempContext = dialogContext;
      },
    );
    if (result) {
      OXLoading.show();
      OKEvent event = await deleteAction(); //await Messages.deleteMessageFromRelay(messageId, '');
      OXLoading.dismiss();
      if (event.status) {
        OXNavigator.pop(tempContext);
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

    final reportSuccess = await ReportDialog.show(context, target: MessageReportTarget(message.remoteId));
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

  /// Handles the press event for the "Translate" button in a menu item.
  void _translateMenuItemPressHandler(BuildContext context, types.Message message) async {
    if (message is! types.TextMessage) {
      return;
    }

    final textToTranslate = message.text.trim();
    if (textToTranslate.isEmpty) {
      CommonToast.instance.show(context, Localized.text('ox_chat.translate_empty_message'));
      return;
    }

    // Check if translation service is configured
    // Only check URL for LibreTranslate (serviceIndex == 1), Google ML Kit doesn't need URL
    final serviceIndex = UserConfigTool.getSetting(
      StorageSettingKey.KEY_TRANSLATE_SERVICE.name,
      defaultValue: 0, // Default to Google ML Kit
    ) as int;
    
    if (serviceIndex == 1) {
      // LibreTranslate requires URL configuration
      final url = UserConfigTool.getSetting(
        StorageSettingKey.KEY_TRANSLATE_URL.name,
        defaultValue: '',
      ) as String;
      
      // If URL is not configured, show dialog to navigate to settings
      if (url.isEmpty) {
        final shouldGoToSettings = await OXCommonHintDialog.show<bool>(
          context,
          title: Localized.text('ox_chat.translate_not_configured_title'),
          content: Localized.text('ox_chat.translate_not_configured_content'),
          isRowAction: true,
          actionList: [
            OXCommonHintAction.cancel(onTap: () {
              OXNavigator.pop(context, false);
            }),
            OXCommonHintAction.sure(
              text: Localized.text('ox_chat.translate_goto_settings'),
              onTap: () {
                OXNavigator.pop(context, true);
              },
            ),
          ],
        );
        
        if (shouldGoToSettings == true) {
          OXNavigator.pushPage(context, (context) => TranslateSettings.TranslateSettingsPage());
        }
        return;
      }
    }

    // Check if translation already exists in metadata
    final existingTranslation = message.metadata?['translated_text'] as String?;
    if (existingTranslation != null && existingTranslation.isNotEmpty) {
      // Toggle translation display: remove translation to hide it
      final updatedMetadata = Map<String, dynamic>.from(message.metadata ?? {});
      updatedMetadata.remove('translated_text');
      final updatedMessage = message.copyWith(metadata: updatedMetadata);
      dataController.updateMessage(updatedMessage);
      return;
    }

    // Perform translation
    OXLoading.show();
    try {
      final translationService = TranslateServiceLib.TranslateService();
      final translatedText = await translationService.translate(textToTranslate);
      
      OXLoading.dismiss();

      if (translatedText != null && translatedText.isNotEmpty) {
        // Store translation in message metadata and update message
        final updatedMetadata = Map<String, dynamic>.from(message.metadata ?? {});
        updatedMetadata['translated_text'] = translatedText;
        final updatedMessage = message.copyWith(metadata: updatedMetadata);
        dataController.updateMessage(updatedMessage);
      } else {
        // Translation failed or same language
        CommonToast.instance.show(context, Localized.text('ox_chat.translate_not_supported'));
      }
    } catch (e) {
      OXLoading.dismiss();
      String errorMessage = e.toString();
      // Extract meaningful error message
      if (errorMessage.contains('Exception:')) {
        errorMessage = errorMessage.split('Exception:').last.trim();
      }
      // If error message is too technical, use default
      if (errorMessage.isEmpty || errorMessage.length > 100) {
        errorMessage = Localized.text('ox_chat.translate_error');
      }
      CommonToast.instance.show(context, errorMessage);
      ChatLogUtils.error(
        className: 'ChatGeneralHandler',
        funcName: '_translateMenuItemPressHandler',
        message: 'Translation error: $e',
      );
    }
  }

  /// Handles the press event for the "Info" button in a menu item.
  void _infoMenuItemPressHandler(BuildContext context, types.Message message) async {
    // Try message.remoteId first, then fallback to message.id
    String? messageId = message.remoteId;
    if (messageId == null || messageId.isEmpty) {
      messageId = message.id;
    }

    if (messageId.isEmpty) {
      ChatLogUtils.error(
        className: 'ChatGeneralHandler',
        funcName: '_infoMenuItemPressHandler',
        message: 'Message ID is empty: id=${message.id}, remoteId=${message.remoteId}',
      );
      return;
    }

    ChatLogUtils.info(
      className: 'ChatGeneralHandler',
      funcName: '_infoMenuItemPressHandler',
      message: 'Loading message info for messageId: $messageId',
    );

    // Load MessageDBISAR to get giftwrappedEventId (if exists)
    final messageDB = await Messages.sharedInstance.loadMessageDBFromDB(messageId);
    if (messageDB == null) {
      ChatLogUtils.error(
        className: 'ChatGeneralHandler',
        funcName: '_infoMenuItemPressHandler',
        message: 'MessageDBISAR not found for messageId: $messageId',
      );
      CommonToast.instance.show(context, Localized.text('ox_chat.message_info_not_found'));
      return;
    }

    // For gift-wrapped messages, use giftwrappedEventId; for normal messages, use messageId
    String eventId;
    if (messageDB.giftwrappedEventId != null && messageDB.giftwrappedEventId!.isNotEmpty) {
      eventId = messageDB.giftwrappedEventId!;
      ChatLogUtils.info(
        className: 'ChatGeneralHandler',
        funcName: '_infoMenuItemPressHandler',
        message: 'Using giftwrappedEventId: $eventId',
      );
    } else {
      eventId = messageId;
      ChatLogUtils.info(
        className: 'ChatGeneralHandler',
        funcName: '_infoMenuItemPressHandler',
        message: 'Using messageId as eventId: $eventId',
      );
    }

    ChatLogUtils.info(
      className: 'ChatGeneralHandler',
      funcName: '_infoMenuItemPressHandler',
      message: 'Navigating to message info page with eventId: $eventId',
    );

    // Navigate to message info page
    MessageInfoPage.show(context, giftwrappedEventId: eventId);
  }

  void messageDeleteHandler(types.Message message) {
    dataController.removeMessage(message: message);
  }

  /// Handles the press event for the "Reaction emoji" in a menu item.
  Future<bool> reactionPressHandler(
    BuildContext context,
    types.Message message,
    types.Reaction reactionPress,
  ) async {
    ChatLogUtils.info(
      className: 'ChatMessagePage',
      funcName: 'reactionPressHandler',
      message: 'id: ${message.id}, content: ${message.content}',
    );
    TookKit.vibrateEffect();

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
      if (reaction.content != reactionPress.content) continue ;
      final authors = [...reaction.authors];
      final haveSent = authors.any((authorPubkey) =>
          OXUserInfoManager.sharedInstance.isCurrentUser(authorPubkey));
      if (haveSent) {
        return false;
      }
    }

    Messages.sharedInstance.sendMessageReaction(
      messageId, reactionPress.content,
      groupId: session.groupId, emojiURL: reactionPress.emojiURL,
      emojiShotCode: reactionPress.emojiShotCode
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
        if (reaction.content != reactionPress.content) continue ;
        reaction.authors.add(author);
        isNewContent = false;
      }
      if (isNewContent) {
        reactions.add(
          UIMessage.Reaction(
            authors: [author],
            content: reactionPress.content,
            emojiShotCode: reactionPress.emojiShotCode,
            emojiURL: reactionPress.emojiURL
          )
        );
      }

      dataController.updateMessage(
        message.copyWith(
          reactions: reactions,
        )
      );
    }

    return completer.future;
  }
}

extension ChatInputMoreHandlerEx on ChatGeneralHandler {

  // type: 1 - image, 2 - video
  Future albumPressHandler(BuildContext context, int type) async {
    if(PlatformUtils.isDesktop){
      await _goToPhoto(context, type);
      return;
    }
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

        bool isVideo = type == 2;
        if (isVideo) {
          List<Media> fileList = [];
          await Future.forEach(filePaths, (path) async {
            fileList.add(Media()..path = path);
          });
          sendVideoMessageWithFile(context, fileList);
        } else {
          List<File> fileList = [];
          await Future.forEach(filePaths, (path) async {
            fileList.add(File(path));
          });
          sendImageMessageWithFile(context, fileList);
        }
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
    GalleryMode mode = isVideo ? GalleryMode.video : GalleryMode.image;
    List<Media> res = [];
    if(PlatformUtils.isMobile){
      res = await ImagePickerUtils.pickerPaths(
        galleryMode: mode,
        selectCount: 1,
        showGif: false,
        compressSize: 1024,
      );
    }else{
      List<Media>? mediaList = await FileUtils.importClientFile(type);
      if(mediaList != null){
        res = mediaList;
      }
    }


    if (isVideo) {
      sendVideoMessageWithFile(context, res);
    } else {
      List<File> fileList = [];
      await Future.forEach(res, (element) async {
        final entity = element;
        final file = File(entity.path ?? '');
        fileList.add(file);
      });
      sendImageMessageWithFile(context, fileList);
    }
  }

  Future<void> _goToCamera(BuildContext context) async {
    //Open the camera or gallery based on the status indicator
    Media? res = await ImagePickerUtils.openCamera(
      cameraMimeType: CameraMimeType.photo,
      compressSize: 1024,
    );
    if(res == null) return;
    final file = File(res.path ?? '');
    sendImageMessageWithFile(context, [file]);
  }
}

extension ChatInputHandlerEx on ChatGeneralHandler {

  InputOptions get inputOptions => InputOptions(
    onTextChanged: _onTextChanged,
    textEditingController: inputController,
    contextMenuBuilder: _inputContextMenuBuilder,
    pasteTextAction: CallbackAction(onInvoke: (_) => _pasteTextActionHandler())
  );

  void _onTextChanged(String text) {
    final chatId = session.chatId;
    if (chatId.isEmpty) return ;
    ChatDraftManager.shared.updateTempDraft(chatId, text);
  }

  Widget _inputContextMenuBuilder(BuildContext context, EditableTextState editableTextState) {
    final hasImagesFuture = OXClipboard.hasImages();
    return FutureBuilder(
      future: hasImagesFuture,
      builder: (_, asyncSnapshot) {
        if (asyncSnapshot.data == true) {
          return AdaptiveTextSelectionToolbar.buttonItems(
            buttonItems: [
              ContextMenuButtonItem(
                onPressed: () async {
                  chatWidgetKey?.currentState?.inputUnFocus();
                  _showImageClipboardDataHint();
                },
                type: ContextMenuButtonType.paste,
              ),
              ...editableTextState.contextMenuButtonItems.map(
                      (item) => item.type != ContextMenuButtonType.paste ? item : null
              ).whereNotNull(),
            ],
            anchors: editableTextState.contextMenuAnchors,
          );
        } else if (asyncSnapshot.data == false) {
          return AdaptiveTextSelectionToolbar.editableText(editableTextState: editableTextState);
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _showImageClipboardDataHint() async {

    final context = OXNavigator.navigatorKey.currentContext;
    if (context == null) return;

    final imageFile = (await OXClipboard.getImages()).firstOrNull;
    if (imageFile == null || !imageFile.existsSync()) {
      CommonToast.instance.show(context, 'Get image from clipboard failure.');
      return;
    }

    final isConfirm = await ChatSendImagePrepareDialog.show(context, imageFile);
    if (!isConfirm) return;

    sendImageMessageWithFile(context, [imageFile]);
  }

  void _pasteTextActionHandler() async {
    final hasImages = await OXClipboard.hasImages();
    if (hasImages) {
      _showImageClipboardDataHint();
      return;
    }

    final text = await OXClipboard.getText() ?? '';
    if (text.isNotEmpty) {
      TextSelection selection = inputController.selection;
      if (!selection.isValid) {
        selection = TextSelection.collapsed(offset: 0);
      }
      final int lastSelectionIndex = math.max(selection.baseOffset, selection.extentOffset);
      final TextEditingValue collapsedTextEditingValue = inputController.value.copyWith(
        selection: TextSelection.collapsed(offset: lastSelectionIndex),
      );
      inputController.value = collapsedTextEditingValue.replaced(selection, text);
      inputFocusNode?.requestFocus();
    }
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

  bool get isContentEncrypt {
    switch (chatType) {
      case ChatType.chatSingle:
      case ChatType.chatStranger:
      case ChatType.chatSecret:
      case ChatType.chatSecretStranger:
      case ChatType.chatGroup:
        return true;
    }
    return false;
  }
}