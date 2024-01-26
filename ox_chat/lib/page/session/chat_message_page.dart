
import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat/manager/chat_message_builder.dart';
import 'package:ox_chat/utils/chat_voice_helper.dart';
import 'package:ox_chat/utils/message_prompt_tone_mixin.dart';
import 'package:ox_chat/widget/not_contact_top_widget.dart';
import 'package:ox_chat_ui/ox_chat_ui.dart';
import 'package:ox_chat/manager/chat_data_cache.dart';
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_chat/manager/chat_page_config.dart';
import 'package:ox_chat/utils/general_handler/chat_general_handler.dart';
import 'package:ox_chat/utils/chat_log_utils.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_appbar.dart';

class ChatMessagePage extends StatefulWidget {

  final ChatSessionModel communityItem;
  final String? anchorMsgId;

  const ChatMessagePage({Key? key, required this.communityItem, this.anchorMsgId}) : super(key: key);

  @override
  State<ChatMessagePage> createState() => _ChatMessagePageState();
}

class _ChatMessagePageState extends State<ChatMessagePage> with MessagePromptToneMixin, ChatGeneralHandlerMixin {

  List<types.Message> _messages = [];

  late types.User _user;
  bool isMore = false;
  late double keyboardHeight = 0;
  late ChatStatus chatStatus;

  UserDB? otherUser;
  String get receiverPubkey => otherUser?.pubKey ?? widget.communityItem.chatId ?? '';

  late ChatGeneralHandler chatGeneralHandler;
  final pageConfig = ChatPageConfig();
  bool isShowContactMenu = true;

  @override
  ChatSessionModel get session => widget.communityItem;
  
  @override
  void initState() {
    setupUser();
    setupChatGeneralHandler();
    super.initState();

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
      fileEncryptionType: types.EncryptionType.encrypted,
    );
    chatGeneralHandler.messageDeleteHandler = _removeMessage;
  }

  void setupUser() {
    // Mine
    UserDB? userDB = OXUserInfoManager.sharedInstance.currentUserInfo;
    _user = types.User(
      id: userDB!.pubKey,
      sourceObject: userDB,
    );
    otherUser = Account.sharedInstance.userCache[widget.communityItem.chatId];
    isShowContactMenu = userDB.pubKey != otherUser?.pubKey;
    if (otherUser == null) {
      () async {
        otherUser = await Account.sharedInstance.getUserInfo(widget.communityItem.chatId ?? '');
        setState(() { });
      };
    }
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
    bool showUserNames = widget.communityItem.chatType == 0 ? false : true;
    return Scaffold(
      backgroundColor: ThemeColor.color200,
      resizeToAvoidBottomInset: false,
      appBar: CommonAppBar(
        useLargeTitle: false,
        centerTitle: true,
        title: otherUser?.getUserShowName() ?? '',
        backgroundColor: ThemeColor.color200,
        actions: [
          Container(
            alignment: Alignment.center,
            child: OXUserAvatar(
              chatId: widget.communityItem.chatId,
              user: otherUser,
              size: Adapt.px(36),
              isClickable: true,
              onReturnFromNextPage: () {
                setState(() { });
              },
            ),
          ).setPadding(EdgeInsets.only(right: Adapt.px(24))),
        ],
      ),
      body: Chat(
        chatId:widget.communityItem.chatId,
        theme: pageConfig.pageTheme,
        anchorMsgId: widget.anchorMsgId,
        messages: _messages,
        isLastPage: !chatGeneralHandler.hasMoreMessage,
        onEndReached: () async {
          await _loadMoreMessages();
        },
        onMessageTap: chatGeneralHandler.messagePressHandler,
        onPreviewDataFetched: _handlePreviewDataFetched,
        onSendPressed: (msg) async => await chatGeneralHandler.sendTextMessage(context, msg.text),
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
          InputMoreItemEx.ecash(chatGeneralHandler, otherUser),
          InputMoreItemEx.call(chatGeneralHandler, otherUser),
        ],
        onVoiceSend: (String path, Duration duration) => chatGeneralHandler.sendVoiceMessage(context, path, duration),
        onGifSend: (GiphyImage image) => chatGeneralHandler.sendGifImageMessage(context, image),
        onAttachmentPressed: () {},
        onMessageLongPressEvent: _handleMessageLongPress,
        longPressMenuItemsCreator: pageConfig.longPressMenuItemsCreator,
        onMessageStatusTap: chatGeneralHandler.messageStatusPressHandler,
        textMessageOptions: chatGeneralHandler.textMessageOptions(context),
        imageGalleryOptions: pageConfig.imageGalleryOptions(decryptionKey: receiverPubkey),
        customTopWidget: isShowContactMenu ? NotContactTopWidget(chatSessionModel: widget.communityItem, onTap: _hideContactMenu) : null,
        customMessageBuilder: ChatMessageBuilder.buildCustomMessage,
        inputOptions: chatGeneralHandler.inputOptions,
        inputBottomView: chatGeneralHandler.replyHandler.buildReplyMessageWidget(),
        onFocusNodeInitialized: chatGeneralHandler.replyHandler.focusNodeSetter,
        repliedMessageBuilder: ChatMessageBuilder.buildRepliedMessageView,
        onAudioDataFetched: (message) => ChatVoiceMessageHelper.populateMessageWithAudioDetails(session: session, message: message),
        onInsertedContent: (KeyboardInsertedContent insertedContent) => chatGeneralHandler.sendInsertedContentMessage(context, insertedContent),
      ),
    );
  }

  void _hideContactMenu() {
    setState(() {
      isShowContactMenu = false;
    });
  }

  void _updateChatStatus() {
    final userId = receiverPubkey;
    final user = Contacts.sharedInstance.allContacts[userId];
    if (user == null) {
      chatStatus = ChatStatus.NotContact;
    } else {
      chatStatus = ChatStatus.Normal;
    }
    ChatLogUtils.info(className: 'ChatMessagePage', funcName: '_updateChatStatus', message: 'chatStatus: $chatStatus, user: $user');
  }

  void _removeMessage(types.Message message) {
    ChatDataCache.shared.deleteMessage(widget.communityItem, message);
  }

  Widget customBottomWidget() {
    keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: isMore ? Adapt.px(300) : Adapt.px(90),
      width: double.infinity,
      margin: EdgeInsets.only(
        left: Adapt.px(16),
        right: Adapt.px(16),
        bottom: Adapt.px(30),
      ),
      color: Colors.red,
      child: GestureDetector(
        child: Container(
          width: 60,
          height: 40,
          color: Colors.amber,
        ),
        onTap: () {
          isMore = !isMore;
          setState(() {});
        },
      ),
    );
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
    ChatDataCache.shared.updateMessage(session: widget.communityItem, message: updatedMessage);
  }

  Future<void> _loadMoreMessages() async {
    await chatGeneralHandler.loadMoreMessage(_messages);
  }
}
