
import 'dart:async';

import 'package:ox_chat/manager/chat_draft_manager.dart';
import 'package:ox_chat/utils/general_handler/chat_general_handler.dart';
import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:ox_common/utils/ox_chat_observer.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:chatcore/chat-core.dart';
import 'package:ox_chat/manager/chat_data_manager_models.dart';
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_chat/utils/chat_log_utils.dart';
import 'package:ox_common/business_interface/ox_chat/utils.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';

class ChatDataCache with OXChatObserver {

  static final ChatDataCache shared = ChatDataCache._internal();

  ChatDataCache._internal() {
    OXChatBinding.sharedInstance.addObserver(this);
  }

  Completer setupCompleter = Completer();

  Completer offlinePrivateMessageFlag = Completer();
  Completer offlineSecretMessageFlag = Completer();
  Completer offlineChannelMessageFlag = Completer();
  Completer offlineGroupMessageFlag = Completer();

  Future get offlineMessageComplete => Future.wait([
    offlinePrivateMessageFlag.future,
    offlineSecretMessageFlag.future,
    offlineChannelMessageFlag.future,
    offlineGroupMessageFlag.future,
  ]);

  setup() async {

    ChatLogUtils.info(
      className: 'ChatDataCache',
      funcName: 'setup',
      message: 'start',
    );

    final setupCompleter = Completer();
    this.setupCompleter = setupCompleter;
    setupAllCompleter();

    ChatDraftManager.shared.setup();

    ChatLogUtils.info(
      className: 'ChatDataCache',
      funcName: 'setup',
      message: 'finish',
    );
    if (!setupCompleter.isCompleted) {
      setupCompleter.complete();
    }
  }

  void setupAllCompleter() {
    offlinePrivateMessageFlag = Completer();
    offlineSecretMessageFlag = Completer();
    offlineChannelMessageFlag = Completer();
    offlineGroupMessageFlag = Completer();
  }

  @override
  void didPrivateMessageCallBack(MessageDBISAR message) async {
    receiveMessageHandler(message);
    updateSessionExpiration(message);
  }

  @override
  void didChatMessageUpdateCallBack(MessageDBISAR message, String replacedMessageId) async { }

  @override
  void didSecretChatMessageCallBack(MessageDBISAR message) async {
    receiveMessageHandler(message);
    updateSessionExpiration(message);
  }

  @override
  void didGroupMessageCallBack(MessageDBISAR message) async {
    receiveMessageHandler(message);
  }

  @override
  void didChannalMessageCallBack(MessageDBISAR message) async {
    receiveMessageHandler(message);
  }

  @override
  void didSecretChatAcceptCallBack(SecretSessionDBISAR ssDB) async {
    final toPubkey = ssDB.toPubkey ?? '';
    final sessionModel = OXChatBinding.sharedInstance.sessionMap[ssDB.sessionId];
    if (sessionModel == null || toPubkey.isEmpty) {
      ChatLogUtils.error(
        className: 'ChatDataCache',
        funcName: 'didSecretChatAcceptCallBack',
        message: 'sessionModel: $sessionModel, toPubkey: $toPubkey',
      );
      return ;
    }
    final toUser = await Account.sharedInstance.getUserInfo(toPubkey);
    final userName = toUser?.getUserShowName() ?? '';

    ChatMessageSendEx.sendSystemMessageHandler(
      sessionModel.getOtherPubkey,
      '$userName joined Secret Chat',
      secretSessionId: sessionModel.chatId,
    );
  }

  @override
  void didMessageActionsCallBack(MessageDBISAR message) async {
    final sessionId = message.chatTypeKey?.sessionId;
    final messageId = message.messageId;
    if (sessionId == null || sessionId.isEmpty || messageId.isEmpty) return;
    if (!OXUserInfoManager.sharedInstance.isCurrentUser(message.sender)) return;

    OXChatBinding.sharedInstance.addReactionMessage(sessionId, messageId);
  }

  @override
  void didMessageDeleteCallBack(List<MessageDBISAR> delMessages) async {
    for (var message in delMessages) {
      final chatType = message.chatTypeKey;
      if (chatType == null) continue ;

      final loadParams = chatType.messageLoaderParams;
      List<MessageDBISAR> messages = (await Messages.loadMessagesFromDB(
        receiver: loadParams.receiver,
        groupId: loadParams.groupId,
        sessionId: loadParams.sessionId,
      ))['messages'] ?? <MessageDBISAR>[];

      types.Message? lastMessage = await messages.firstOrNull?.toChatUIMessage();
      OXChatBinding.sharedInstance.deleteMessageHandler(message, lastMessage?.messagePreviewText ?? '');
    }
  }

  @override
  void didOfflinePrivateMessageFinishCallBack() {
    if (!offlinePrivateMessageFlag.isCompleted) {
      offlinePrivateMessageFlag.complete();
    }
  }

  @override
  void didOfflineSecretMessageFinishCallBack() {
    if (!offlineSecretMessageFlag.isCompleted) {
      offlineSecretMessageFlag.complete();
    }
  }

  @override
  void didOfflineChannelMessageFinishCallBack() {
    if (!offlineChannelMessageFlag.isCompleted) {
      offlineChannelMessageFlag.complete();
    }
  }

  @override
  void didOfflineGroupMessageFinishCallBack() {
    if (!offlineGroupMessageFlag.isCompleted) {
      offlineGroupMessageFlag.complete();
    }
  }

  void updateSessionExpiration(MessageDBISAR message) {
    final sessionId = message.chatTypeKey?.sessionId;
    if (sessionId == null || sessionId.isEmpty) return ;

    final myPubkey = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey;
    if(message.receiver != myPubkey) return;

    ChatSessionModelISAR? sessionModel = OXChatBinding.sharedInstance.sessionMap[sessionId];

    if (sessionModel != null && message.createTime >= sessionModel.createTime) {
      int expiration = 0;
      if(message.expiration != null && message.expiration! > message.createTime) {
        expiration = message.expiration! - message.createTime;
      }
      OXChatBinding.sharedInstance.updateChatSession(sessionId, expiration: expiration);
    }
  }

  Future receiveMessageHandler(MessageDBISAR message) async {
    final sessionId = message.chatTypeKey?.sessionId;
    final messageId = message.messageId;
    if (sessionId == null || sessionId.isEmpty || messageId.isEmpty) return null;

    await message.toChatUIMessage(
      isMentionMessageCallback: () {
        OXChatBinding.sharedInstance.addMentionMessage(sessionId, messageId);
      },
    );
  }
}

extension CommonChatSessionEx on ChatSessionModelISAR {
  bool get showUserNames => chatType != 0;

  /// Integer value for [MessageDBISAR.chatType].
  /// Returns `null` if the [chatType] does not match any known chat type.
  int? get coreChatType {
    switch(chatType) {
      case ChatType.chatSingle:
        return 0;
      case ChatType.chatGroup:
        return 1;
      case ChatType.chatChannel:
        return 2;
      case ChatType.chatSecret:
        return 3;
      case ChatType.chatRelayGroup:
        return 4;
      default:
        return null;
    }
  }
}
