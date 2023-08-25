import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat_ui/ox_chat_ui.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';
import 'package:ox_chat/manager/chat_data_cache.dart';
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_chat/manager/chat_page_config.dart';
import 'package:ox_chat/utils/chat_general_handler.dart';
import 'package:ox_chat/utils/chat_log_utils.dart';
import 'package:ox_chat/widget/avatar.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/common_loading.dart';

class ChatGroupMessagePage extends StatefulWidget {

  final ChatSessionModel communityItem;
  final String? anchorMsgId;

  ChatGroupMessagePage({Key? key, required this.communityItem, this.anchorMsgId}) : super(key: key);

  @override
  State<ChatGroupMessagePage> createState() => _ChatGroupMessagePageState();
}

class _ChatGroupMessagePageState extends State<ChatGroupMessagePage> {

  List<types.Message> _messages = [];
  
  late types.User _user;
  double keyboardHeight = 0;
  late ChatStatus chatStatus;

  ChannelDB? channel;
  String get channelId => channel?.channelId ?? widget.communityItem.groupId ?? '';

  late ChatGeneralHandler chatGeneralHandler;
  final pageConfig = ChatPageConfig();

  @override
  void initState() {
    super.initState();

    setupUser();
    setupChatGeneralHandler();
    prepareData();
    addListener();
  }

  void setupChatGeneralHandler() {
    chatGeneralHandler = ChatGeneralHandler(
      author: _user,
      session: widget.communityItem,
      refreshMessageUI: (messages) {
        setState(() {
          _messages = messages;
        });
      },
      sendMessageHandler: _sendMessage,
    );
    chatGeneralHandler.messageDeleteHandler = _removeMessage;
    chatGeneralHandler.messageResendHandler = _resendMessage;
    chatGeneralHandler.imageMessageSendHandler = _onImageMessageSend;
    chatGeneralHandler.videoMessageSendHandler = _onVideoMessageSend;
  }

  void setupUser() {
    // Mine
    UserDB? userDB = OXUserInfoManager.sharedInstance.currentUserInfo;
    channel = Channels.sharedInstance.channels[widget.communityItem.groupId];
    _user = types.User(
      id: userDB!.pubKey!,
      sourceObject: userDB,
    );
  }

  void prepareData() {
    _loadMoreMessages();
    _updateChatStatus();
    ChatDataCache.shared.setSessionAllMessageIsRead(widget.communityItem);
  }

  void addListener() {
    ChatDataCache.shared.addObserver(widget.communityItem, (value) {
      chatGeneralHandler.refreshMessage(_messages, value);
    });
  }

  @override
  void dispose() {
    ChatDataCache.shared.removeObserver(widget.communityItem);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool showUserNames = true;
    return Scaffold(
      backgroundColor: ThemeColor.color200,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: CommonAppBar(
          useLargeTitle: false,
          centerTitle: true,
          title: widget.communityItem.chatName!,
          backgroundColor: ThemeColor.color200,
          backCallback: () {
            OXNavigator.popToRoot(context);
          },
          actions: [
            Container(
              alignment: Alignment.center,
              child: OXChannelAvatar(
                channel: channel,
                size: Adapt.px(36),
                isClickable: true,
                onReturnFromNextPage: () {
                  setState(() { });
                },
              ),
            ).setPadding(EdgeInsets.only(right: Adapt.px(24))),
          ],
        ),
      ),
      body: Chat(
        anchorMsgId: widget.anchorMsgId,
        messages: _messages,
        isLastPage: !chatGeneralHandler.hasMoreMessage,
        onEndReached: () async {
          await _loadMoreMessages();
        },
        onMessageTap: chatGeneralHandler.messagePressHandler,
        onPreviewDataFetched: _handlePreviewDataFetched,
        onSendPressed: _handleSendPressed,
        avatarBuilder: (message) => OXUserAvatar(
          user: message.author.sourceObject,
          size: Adapt.px(40),
          isCircular: false,
          isClickable: true,
          onReturnFromNextPage: () {
            setState(() { });
          },
        ),
        showUserNames: showUserNames,
        //Group chat display nickname
        user: _user,
        useTopSafeAreaInset: true,
        chatStatus: chatStatus,
        inputMoreItems: [
          InputMoreItemEx.album(chatGeneralHandler),
          InputMoreItemEx.camera(chatGeneralHandler),
          InputMoreItemEx.video(chatGeneralHandler),
        ],
        onVoiceSend: (path, duration) {
          LogUtil.e("onVoiceSend : ${path}");
          _onVoiceSend(path, duration);
        },
        onAttachmentPressed: () {},
        onMessageLongPressEvent: _handleMessageLongPress,
        onJoinChannelTap: () async {
          await OXLoading.show();
          final OKEvent okEvent = await Channels.sharedInstance.joinChannel(channelId);
          await OXLoading.dismiss();
          if (okEvent.status) {
            OXChatBinding.sharedInstance.channelsUpdatedCallBack();
            setState(() {
              _updateChatStatus();
            });
          } else {
            CommonToast.instance.show(context, okEvent.message);
          }
        },
        longPressMenuItemsCreator: pageConfig.longPressMenuItemsCreator,
        onMessageStatusTap: chatGeneralHandler.messageStatusPressHandler,
        textMessageOptions: chatGeneralHandler.textMessageOptions(context),
        imageGalleryOptions: pageConfig.imageGalleryOptions(),
      ),
    );
  }

  void _updateChatStatus() {

    if (!Channels.sharedInstance.myChannels.containsKey(channelId)) {
      chatStatus = ChatStatus.NotJoined;
      return ;
    }

    final userDB = OXUserInfoManager.sharedInstance.currentUserInfo;

    if (channelId.isEmpty || userDB == null) {
      ChatLogUtils.error(className: 'ChatGroupMessagePage', funcName: '_initializeChatStatus', message: 'channelId: $channelId, userDB: $userDB');
      chatStatus = ChatStatus.Unknown;
      return ;
    }

    final channelBadgesJsonString = Channels.sharedInstance.channels[channelId]?.badges ?? '[]';
    List<String> channelBadgesList;
    try {
      final list = JsonDecoder().convert(channelBadgesJsonString) as List? ?? [];
      channelBadgesList = list.cast<String>();
    } catch (e) {
      ChatLogUtils.error(className: 'ChatGroupMessagePage', funcName: '_initializeChatStatus', message: 'error: $e');
      chatStatus = ChatStatus.Unknown;
      return ;
    }

    final badgesList = userDB.badgesList ?? [];

    ChatLogUtils.info(
      className: 'ChatGroupMessagePage',
      funcName: '_initializeChatStatus',
      message: 'my badgesList: ${badgesList}, channelBadges: $channelBadgesList',
    );

    chatStatus = ChatStatus.InsufficientBadge;
    if (channelBadgesList.length > 0) {
      channelBadgesList.forEach((channelBadges) {
        if (badgesList.contains(channelBadges)) {
          chatStatus = ChatStatus.Normal;
        }
      });
    } else {
      chatStatus = ChatStatus.Normal;
    }
  }

  void _addMessage(types.Message message) {
    ChatDataCache.shared.addNewMessage(widget.communityItem, message);
  }

  void _removeMessage(types.Message message) {
    ChatDataCache.shared.deleteMessage(widget.communityItem, message);
  }

  Future _resendMessage(types.Message message) async {
    final resendMsg = message.copyWith(
      createdAt: DateTime.now().millisecondsSinceEpoch,
      status: types.Status.sending,
    );
    ChatDataCache.shared.deleteMessage(widget.communityItem, resendMsg);
    _sendMessage(resendMsg, isResend: true);
  }

  Future<types.Message?> _tryPrepareSendFileMessage(types.Message message) async {
    types.Message? updatedMessage;
    if (message is types.ImageMessage) {
      updatedMessage = await chatGeneralHandler.prepareSendImageMessage(context, message);
    } else if (message is types.AudioMessage) {
      updatedMessage = await chatGeneralHandler.prepareSendAudioMessage(context, message);
    } else if (message is types.VideoMessage) {
      updatedMessage = await chatGeneralHandler.prepareSendVideoMessage(context, message);
    } else {
      return message;
    }

    return updatedMessage;
  }

  Future _onImageMessageSend(List<File> images) async {
    for (final result in images) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      String message_id = const Uuid().v4();
      String fileName = Path.basename(result.path);
      fileName = fileName.substring(13);
      int tempCreateTime = DateTime.now().millisecondsSinceEpoch;

      final message = types.ImageMessage(
        author: _user,
        createdAt: tempCreateTime,
        height: image.height.toDouble(),
        id: message_id,
        name: fileName,
        size: bytes.length,
        uri: result.path.toString(),
        // uri:uri,
        width: image.width.toDouble(),
      );

      final sendMsg = await _tryPrepareSendFileMessage(message);
      if (sendMsg == null) return ;
      _sendMessage(sendMsg);
    }
  }

  Future _onVoiceSend(String path, Duration duration) async {
    File voiceFile = File(path);
    final bytes = await voiceFile.readAsBytes();
    String message_id = const Uuid().v4();
    final fileName = '${message_id}.mp3';
    int tempCreateTime = DateTime.now().millisecondsSinceEpoch;

    final message = types.AudioMessage(
      // uri: 'http://music.163.com/song/media/outer/url?id=447925558.mp3',
      // uri: uri,
      uri: path,
      id: message_id,
      createdAt: tempCreateTime,
      author: _user,
      name: fileName,
      duration: duration,
      size: bytes.length,
    );

    final sendMsg = await _tryPrepareSendFileMessage(message);
    if (sendMsg == null) return ;
    _sendMessage(sendMsg);
  }

  Future _onVideoMessageSend(List<File> images) async {
    for (final result in images) {
      final bytes = await result.readAsBytes();
      final uint8list = await VideoCompress.getByteThumbnail(result.path,
          quality: 50, // default(100)
          position: -1 // default(-1)
          );
      final image = await decodeImageFromList(uint8list!);
      Directory directory = await getTemporaryDirectory();
      String thumbnailDirPath = '${directory.path}/thumbnails';
      await Directory(thumbnailDirPath).create(recursive: true);

      // Save the thumbnail to a file
      String thumbnailPath = '$thumbnailDirPath/thumbnail.jpg';
      File thumbnailFile = File(thumbnailPath);
      await thumbnailFile.writeAsBytes(uint8list);

      String message_id = const Uuid().v4();
      String fileName = '${message_id}${Path.basename(result.path)}';
      int tempCreateTime = DateTime.now().millisecondsSinceEpoch;

      final message = types.VideoMessage(
        author: _user,
        createdAt: tempCreateTime,
        height: image.height.toDouble(),
        id: message_id,
        name: fileName,
        size: bytes.length,
        metadata: {
          "videoUrl": result.path.toString(),
        },
        // metadata:{"videoUrl" : uri ?? "","snapshotUrl":snapshotUrl},
        uri: thumbnailPath,
        // uri: snapshotUrl,
        width: image.width.toDouble(),
      );

      final sendMsg = await _tryPrepareSendFileMessage(message);
      if (sendMsg == null) return ;
      _sendMessage(sendMsg);
    }
  }

  void _handleMessageLongPress(types.Message message, MessageLongPressEventType type) async {
    chatGeneralHandler.menuItemPressHandler(context, message, type);
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    ChatDataCache.shared.updateMessage(widget.communityItem, updatedMessage);
  }

  void _handleSendPressed(types.PartialText message) {

    final mid = Uuid().v4();
    int tempCreateTime = DateTime.now().millisecondsSinceEpoch;

    final textMessage = types.TextMessage(
      author: _user,
      createdAt: tempCreateTime,
      id: mid,
      text: message.text,
    );

    _sendMessage(textMessage);
  }

  Future _sendMessage(types.Message message, {bool isResend = false}) async {

    if (!isResend) {
      final sendMsg = await _tryPrepareSendFileMessage(message);
      if (sendMsg == null) return ;
      message = sendMsg;
    }

    // send message
    var sendFinish = OXValue(false);
    final type = message.dbMessageType(encrypt: message.fileEncryptionType != types.EncryptionType.none);
    final contentString = message.contentString(message.content);

    final event = Channels.sharedInstance.getSendChannelMessageEvent(channelId, type, contentString);
    if (event == null) {
      CommonToast.instance.show(context, 'send message fail');
      return ;
    }

    final sendMsg = message.copyWith(
      id: event.id,
    );

    _addMessage(sendMsg);

    Channels.sharedInstance.sendChannelMessage(
      widget.communityItem.chatId!,
      type,
      contentString,
      event: event,
    ).then((event) {
      sendFinish.value = true;
      final updatedMessage = sendMsg.copyWith(
        remoteId: event.eventId,
        status: event.status ? types.Status.sent : types.Status.error,
      );
      ChatDataCache.shared.updateMessage(widget.communityItem, updatedMessage);
    });

    // If the message is not sent within a short period of time, change the status to the sending state
    _setMessageSendingStatusIfNeeded(sendFinish, sendMsg);

    // sync message to session
    chatGeneralHandler.syncChatSessionForSendMsg(
      createTime: sendMsg.createdAt,
      content: sendMsg.content,
      type: type,
      groupId: widget.communityItem.groupId ?? '',
    );
  }

  void _updateMessageStatus(types.Message message, types.Status status) {
    final updatedMessage = message.copyWith(
      status: status,
    );
    ChatDataCache.shared.updateMessage(widget.communityItem, updatedMessage);
  }

  void _setMessageSendingStatusIfNeeded(OXValue<bool> sendFinish, types.Message message) {
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (!sendFinish.value) {
        _updateMessageStatus(message, types.Status.sending);
      }
    });
  }

  Future<void> _loadMoreMessages() async {
    await chatGeneralHandler.loadMoreMessage(_messages);
  }
}
