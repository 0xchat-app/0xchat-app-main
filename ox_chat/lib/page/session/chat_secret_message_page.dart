import 'dart:io';

import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat/utils/message_prompt_tone_mixin.dart';
import 'package:ox_chat/widget/not_contact_top_widget.dart';
import 'package:ox_chat/widget/secret_hint_widget.dart';
import 'package:ox_chat_ui/ox_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';
import 'package:ox_chat/manager/chat_data_cache.dart';
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_chat/manager/chat_page_config.dart';
import 'package:ox_chat/manager/chat_user_cache.dart';
import 'package:ox_chat/utils/chat_general_handler.dart';
import 'package:ox_chat/utils/chat_log_utils.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_chat/widget/avatar.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_chat/page/session/chat_video_play_page.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:screen_protector/screen_protector.dart';

class ChatSecretMessagePage extends StatefulWidget {
  final ChatSessionModel communityItem;
  final String? anchorMsgId;

  const ChatSecretMessagePage({Key? key, required this.communityItem, this.anchorMsgId}) : super(key: key);

  @override
  State<ChatSecretMessagePage> createState() => _ChatSecretMessagePageState();
}

class _ChatSecretMessagePageState extends State<ChatSecretMessagePage> with OXChatObserver, MessagePromptToneMixin, ChatGeneralHandlerMixin {
  List<types.Message> _messages = [];
  late types.User _user;
  bool isMore = false;
  bool isShowContactMenu = true;
  late double keyboardHeight = 0;
  late ChatStatus chatStatus;
  SecretSessionDB? _secretSessionDB;
  UserDB? otherUser;

  String get receiverPubkey =>
      otherUser?.pubKey ??
      (widget.communityItem.receiver != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey
          ? widget.communityItem.receiver
          : widget.communityItem.sender) ??
      '';

  @override
  ChatSessionModel get session => widget.communityItem;

  String get sessionId => widget.communityItem.chatId ?? '';

  late ChatGeneralHandler chatGeneralHandler;
  final pageConfig = ChatPageConfig();

  @override
  void initState() {
    setupUser();
    setupChatGeneralHandler();
    super.initState();

    OXChatBinding.sharedInstance.addObserver(this);
    protectScreen();
    initSecretData();
    prepareData();
    addListener();
  }

  @override
  void dispose() {
    OXChatBinding.sharedInstance.removeObserver(this);
    ChatDataCache.shared.removeObserver(widget.communityItem);
    disProtectScreen();
    super.dispose();
  }

  void protectScreen() async {
    if (Platform.isAndroid) {
      await ScreenProtector.protectDataLeakageOn();
    } else if (Platform.isIOS) {
      await ScreenProtector.preventScreenshotOn();
    }
  }

  void disProtectScreen() async {
    if (Platform.isAndroid) {
      await ScreenProtector.protectDataLeakageOff();
    } else if (Platform.isIOS) {
      await ScreenProtector.preventScreenshotOff();
    }
  }

  void initSecretData() {
    if (widget.communityItem.chatType == ChatType.chatSecret || widget.communityItem.chatType == ChatType.chatSecretStranger) {
      setState(() {
        _secretSessionDB = Contacts.sharedInstance.secretSessionMap[widget.communityItem.chatId];
        LogUtil.e('Michael: _secretSessionDB =${_secretSessionDB.toString()}');
      });
    }
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
    chatGeneralHandler.gifMessageSendHandler = _onGifImageMessageSend;
  }

  void setupUser() {
    // Mine
    UserDB? userDB = OXUserInfoManager.sharedInstance.currentUserInfo;
    _user = types.User(
      id: userDB!.pubKey!,
      sourceObject: userDB,
    );

    () async {
      // Other
      if (widget.communityItem.chatType == ChatType.chatSecret || widget.communityItem.chatType == ChatType.chatSecretStranger) {
        final pubkeys = (widget.communityItem.receiver != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey
                ? widget.communityItem.receiver
                : widget.communityItem.sender) ??
            '';
        otherUser = await ChatUserCache.shared.getUserDB(pubkeys);
      } else {
        final pubkeys = widget.communityItem.chatId ?? '';
        otherUser = await ChatUserCache.shared.getUserDB(pubkeys);
      }
      setState(() {});
    }();
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
  Widget build(BuildContext context) {
    bool showUserNames = widget.communityItem.chatType == 0 ? false : true;
    return WillPopScope(
      onWillPop: () async {
        await OXLoading.dismiss();
        OXNavigator.popToRoot(context);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: ThemeColor.color200,
        resizeToAvoidBottomInset: false,
        appBar: CommonAppBar(
          useLargeTitle: false,
          centerTitle: true,
          title: otherUser?.getUserShowName() ?? '',
          titleWidget: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.only(top: Adapt.px(2)),
                  child: CommonImage(
                    iconName: 'icon_lock_secret.png',
                    width: Adapt.px(16),
                    height: Adapt.px(16),
                    package: 'ox_chat',
                  ),
                ),
                SizedBox(
                  width: Adapt.px(4),
                ),
                Text(
                  otherUser?.getUserShowName() ?? '',
                  style: TextStyle(
                    color: ThemeColor.color0,
                    fontSize: Adapt.px(17),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: ThemeColor.color200,
          backCallback: () {
            OXNavigator.popToRoot(context);
          },
          actions: [
            Container(
              alignment: Alignment.center,
              child: OXUserAvatar(
                user: otherUser,
                size: Adapt.px(36),
                isClickable: true,
                onReturnFromNextPage: () {
                  setState(() {});
                },
              ),
            ).setPadding(EdgeInsets.only(right: Adapt.px(24))),
          ],
        ),
        body: Chat(
          anchorMsgId: widget.anchorMsgId,
          messages: _messages,
          isLastPage: !chatGeneralHandler.hasMoreMessage,
          onEndReached: () async {
            await _loadMoreMessages();
          },
          onMessageTap: _handleMessageTap,
          onPreviewDataFetched: _handlePreviewDataFetched,
          onSendPressed: _handleSendPressed,
          avatarBuilder: (message) => OXUserAvatar(
            user: message.author.sourceObject,
            size: Adapt.px(40),
            isCircular: false,
            isClickable: true,
            onReturnFromNextPage: () {
              setState(() {});
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
            InputMoreItemEx.zaps(chatGeneralHandler, otherUser),
          ],
          onVoiceSend: (path, duration) {
            _onVoiceSend(path, duration);
          },
          onGifSend: (value) {
            _onGifImageMessageSend(value);
          },
          onAttachmentPressed: () {},
          onMessageLongPressEvent: _handleMessageLongPress,
          longPressMenuItemsCreator: pageConfig.longPressMenuItemsCreator,
          onMessageStatusTap: chatGeneralHandler.messageStatusPressHandler,
          textMessageOptions: chatGeneralHandler.textMessageOptions(context),
          imageGalleryOptions: pageConfig.imageGalleryOptions(decryptionKey: receiverPubkey),
          customTopWidget: isShowContactMenu ? NotContactTopWidget(chatSessionModel: widget.communityItem, onTap: _hideContactMenu) : null,
          customCenterWidget: _messages.length > 0 ? null : SecretHintWidget(chatSessionModel: widget.communityItem),
          customBottomWidget: (_secretSessionDB == null || _secretSessionDB!.status == 2) ? null : customBottomWidget(),
          inputOptions: chatGeneralHandler.inputOptions,
        ),
      ),
    );
  }

  @override
  void didSecretChatAcceptCallBack(SecretSessionDB ssDB) {
    setState(() {
      _secretSessionDB = ssDB;
    });
  }

  @override
  void didSecretChatRejectCallBack(SecretSessionDB ssDB) {
    setState(() {
      _secretSessionDB = ssDB;
    });
  }

  void _hideContactMenu() {
    setState(() {
      isShowContactMenu = false;
    });
  }

  Widget _buildGroupDefaultImage() => Image.asset(
        'assets/images/icon_user_default.png',
        fit: BoxFit.contain,
        width: Adapt.px(36),
        height: Adapt.px(36),
        package: 'ox_chat',
      );

  Widget _buildDetailIcon() => GestureDetector(
        onTap: () {
          var userId = receiverPubkey;
          if (userId.isNotEmpty) {
            chatGeneralHandler.avatarPressHandler(context, userId: userId);
          }
        },
        child: Container(
          width: Adapt.px(36),
          height: Adapt.px(36),
          alignment: Alignment.center,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(36.0)),
            child: CachedNetworkImage(
              imageUrl: widget.communityItem.avatar ?? '',
              fit: BoxFit.cover,
              width: Adapt.px(36),
              height: Adapt.px(36),
              placeholder: (context, url) => _buildGroupDefaultImage(),
              errorWidget: (context, url, error) => _buildGroupDefaultImage(),
            ),
          ),
        ),
      );

  void _updateChatStatus() {
    final userId = receiverPubkey;
    final user = Contacts.sharedInstance.allContacts[userId];
    if (user == null) {
      chatStatus = ChatStatus.NotContact;
    } else {
      chatStatus = ChatStatus.Normal;
    }
    ChatLogUtils.info(className: 'ChatSecretMessagePage', funcName: '_updateChatStatus', message: 'chatStatus: $chatStatus, user: $user');
  }

  void _addMessage(types.Message message) {
    ChatDataCache.shared.addNewMessage(widget.communityItem, message);
  }

  void _removeMessage(types.Message message) {
    ChatDataCache.shared.deleteMessage(widget.communityItem, message);
  }

  void _resendMessage(types.Message message) async {
    final resendMsg = message.copyWith(
      createdAt: DateTime.now().millisecondsSinceEpoch,
      status: types.Status.sending,
    );
    ChatDataCache.shared.deleteMessage(widget.communityItem, resendMsg);
    _sendMessage(resendMsg);
  }

  Future<types.Message?> _tryPrepareSendFileMessage(types.Message message) async {
    types.Message? updatedMessage;
    if (message is types.ImageMessage) {
      updatedMessage = await chatGeneralHandler.prepareSendImageMessage(
        context,
        message,
        pubkey: receiverPubkey,
      );
    } else if (message is types.AudioMessage) {
      updatedMessage = await chatGeneralHandler.prepareSendAudioMessage(
        context,
        message,
      );
    } else if (message is types.VideoMessage) {
      updatedMessage = await chatGeneralHandler.prepareSendVideoMessage(
        context,
        message,
      );
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
        roomId: receiverPubkey,
        name: fileName,
        size: bytes.length,
        uri: result.path.toString(),
        width: image.width.toDouble(),
        fileEncryptionType: types.EncryptionType.encrypted,
      );

      final sendMsg = await _tryPrepareSendFileMessage(message);
      if (sendMsg == null) return;
      _sendMessage(sendMsg);
    }
  }

  Future _onGifImageMessageSend(GiphyImage image) async {
    String message_id = const Uuid().v4();
    int tempCreateTime = DateTime.now().millisecondsSinceEpoch;

    final message = types.ImageMessage(
      uri: image.url,
      author: _user,
      createdAt: tempCreateTime,
      id: message_id,
      roomId: receiverPubkey,
      name: image.name,
      size: double.parse(image.size!),
      fileEncryptionType: types.EncryptionType.encrypted,
    );

    final sendMsg = await _tryPrepareSendFileMessage(message);
    if(sendMsg == null) return;
    _sendMessage(sendMsg);
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
    ChatLogUtils.info(className: 'ChatSecretMessagePage', funcName: '_onVoiceSend', message: 'uri: ${path}, size: ${bytes.length / 1024}KB');

    final sendMsg = await _tryPrepareSendFileMessage(message);
    if (sendMsg == null) return;
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
      if (sendMsg == null) return;
      _sendMessage(sendMsg);
    }
  }

  Widget customBottomWidget() {
    String _hintText = '';
    String _leftBtnTxt = '';
    String _rightBtnTxt = '';
    if (_secretSessionDB!.status == 0) {
      _hintText = 'str_waiting_other_join'.localized({r'$username': widget.communityItem.chatName ?? ''});
    } else if (_secretSessionDB!.status == 1) {
      _leftBtnTxt = 'str_reject_secret_chat'.localized();
      _rightBtnTxt = 'str_john_secret_chat'.localized();
    } else if (_secretSessionDB!.status == 3) {
      _hintText = Localized.text('ox_chat.str_other_rejected');
    } else if (_secretSessionDB!.status == 6) {
      _hintText = Localized.text('ox_chat.str_other_expired');
    } else {
      _hintText = 'ox_chat.str_waiting_join';
    }

    return Container(
      width: double.infinity,
      height: Adapt.px(58),
      margin: EdgeInsets.only(
        left: Adapt.px(12),
        right: Adapt.px(12),
        bottom: Adapt.px(30),
      ),
      decoration: BoxDecoration(
        color: ThemeColor.color190,
        borderRadius: BorderRadius.circular(Adapt.px(12)),
      ),
      alignment: Alignment.center,
      child: GestureDetector(
        child: _secretSessionDB!.status == 1
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: Adapt.px(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          _rejectSecretChat();
                        },
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          alignment: Alignment.center,
                          child: Text(
                            _leftBtnTxt,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: ThemeColor.color100,
                              fontSize: Adapt.px(14),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          _johnSecretChat();
                        },
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          alignment: Alignment.center,
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                colors: [
                                  ThemeColor.gradientMainEnd,
                                  ThemeColor.gradientMainStart,
                                ],
                              ).createShader(Offset.zero & bounds.size);
                            },
                            child: Text(
                              _rightBtnTxt,
                              style: TextStyle(
                                fontSize: Adapt.px(14),
                                letterSpacing: Adapt.px(0.4),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: Adapt.px(50)),
                child: Text(
                  _hintText,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: ThemeColor.color100,
                    fontSize: Adapt.px(14),
                  ),
                ),
              ),
        onTap: () {
          //TODO:
          setState(() {});
        },
      ),
    );
  }

  void _handleMessageLongPress(types.Message message, MessageLongPressEventType type) async {
    chatGeneralHandler.menuItemPressHandler(context, message, type);
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;
      if (message.uri.startsWith('http')) {
        try {
          final index = _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage = (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );
          ChatDataCache.shared.updateMessage(widget.communityItem, updatedMessage);

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          // if (!File(localPath).existsSync()) {
          //   final file = File(localPath);
          //   await file.writeAsBytes(bytes);
          // }
        } finally {
          final index = _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage = (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );
          ChatDataCache.shared.updateMessage(widget.communityItem, updatedMessage);
        }
      }
    } else if (message is types.VideoMessage) {
      LogUtil.e("_handleMessageTap : VideoMessage");
      final index = _messages.indexWhere((element) => element.id == message.id);
      types.VideoMessage videoMessage = _messages[index] as types.VideoMessage;
      LogUtil.e(videoMessage.metadata);
      OXNavigator.pushPage(context, (context) => ChatVideoPlayPage(videoUrl: videoMessage.metadata!["videoUrl"] ?? ''));
    }
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

    var textMessage = types.TextMessage(
      author: _user,
      createdAt: tempCreateTime,
      id: mid,
      text: message.text,
    );

    _sendMessage(textMessage);
  }

  void _sendMessage(types.Message message) async {
    // send message
    var sendFinish = OXValue(false);
    final type = message.dbMessageType(encrypt: message.fileEncryptionType != types.EncryptionType.none);
    final contentString = message.contentString(message.content);

    final event = await Contacts.sharedInstance.getSendSecretMessageEvent(
      sessionId,
      receiverPubkey,
      '',
      type,
      contentString,
    );
    if (event == null) {
      CommonToast.instance.show(context, 'send message fail');
      return;
    }

    final sendMsg = message.copyWith(
      id: event.id,
    );

    _addMessage(sendMsg);

    ChatLogUtils.info(
      className: 'ChatSecretMessagePage',
      funcName: '_sendMessage',
      message: 'sessionId: $sessionId, receiverPubkey: $receiverPubkey, contentString: $contentString, type: ${sendMsg.type}',
    );
    Contacts.sharedInstance
        .sendSecretMessage(
      sessionId,
      receiverPubkey,
      '',
      type,
      contentString,
      event: event,
    )
        .then((event) {
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
    ChatGeneralHandler.syncChatSessionForSendMsg(
      createTime: sendMsg.createdAt,
      content: sendMsg.content,
      type: type,
      receiver: receiverPubkey,
      decryptContent: contentString,
      sessionId: sessionId,
    );
  }

  void _updateMessageStatus(types.Message message, types.Status status) {
    final updatedMessage = message.copyWith(
      status: status,
    );
    ChatDataCache.shared.updateMessage(widget.communityItem, updatedMessage);
  }

  void _setMessageSendingStatusIfNeeded(OXValue<bool> sendFinish, types.Message message) {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!sendFinish.value) {
        _updateMessageStatus(message, types.Status.sending);
      }
    });
  }

  Future<void> _loadMoreMessages() async {
    await chatGeneralHandler.loadMoreMessage(_messages);
  }

  void _rejectSecretChat() async {
    OXCommonHintDialog.show(context,
        title: '',
        content: 'Are you sure reject and delete？',
        actionList: [
          OXCommonHintAction.cancel(onTap: () {
            OXNavigator.pop(context);
          }),
          OXCommonHintAction.sure(
              text: Localized.text('ox_common.confirm'),
              onTap: () async {
                await OXLoading.show();
                final OKEvent okEvent = await Contacts.sharedInstance.reject(_secretSessionDB!.sessionId);
                await OXLoading.dismiss();
                if (okEvent.status) {
                  UserDB? toPubkeyUserDB = Contacts.sharedInstance.allContacts[_secretSessionDB!.toPubkey];
                  await OXChatBinding.sharedInstance.deleteSession(
                    widget.communityItem,
                    isStranger: toPubkeyUserDB == null,
                  );
                  OXNavigator.pop(context); //pop dialog
                  OXNavigator.pop(context); //pop page
                } else {
                  CommonToast.instance.show(context, okEvent.message);
                }
              }),
        ],
        isRowAction: true);
  }

  void _johnSecretChat() async {
    await OXLoading.show();
    final OKEvent okEvent = await Contacts.sharedInstance.accept(_secretSessionDB!.sessionId);
    await OXLoading.dismiss();
    if (okEvent.status) {
      OXChatBinding.sharedInstance.updateChatSession(
        widget.communityItem.chatId!,
        content: "You have accepted [${otherUser?.name ?? ''}]'s secret chat request.",
      );
      _secretSessionDB!.status = 2;
      setState(() {});
    } else {
      CommonToast.instance.show(context, okEvent.message);
    }
  }
}
