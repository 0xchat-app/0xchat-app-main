import 'dart:convert';

import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat/manager/chat_message_builder.dart';
import 'package:ox_chat/utils/chat_voice_helper.dart';
import 'package:ox_chat/utils/general_handler/chat_mention_handler.dart';
import 'package:ox_chat/utils/message_prompt_tone_mixin.dart';
import 'package:ox_chat_ui/ox_chat_ui.dart';
import 'package:ox_chat/manager/chat_data_cache.dart';
import 'package:ox_chat/manager/chat_page_config.dart';
import 'package:ox_chat/utils/general_handler/chat_general_handler.dart';
import 'package:ox_chat/utils/chat_log_utils.dart';
import 'package:ox_common/utils/web_url_helper.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/common_loading.dart';

class ChatChannelMessagePage extends StatefulWidget {

  final ChatSessionModel communityItem;
  final String? anchorMsgId;

  ChatChannelMessagePage({Key? key, required this.communityItem, this.anchorMsgId}) : super(key: key);

  @override
  State<ChatChannelMessagePage> createState() => _ChatChannelMessagePageState();
}

class _ChatChannelMessagePageState extends State<ChatChannelMessagePage> with MessagePromptToneMixin, ChatGeneralHandlerMixin {

  List<types.Message> _messages = [];
  
  late types.User _user;
  double keyboardHeight = 0;
  late ChatStatus chatStatus;

  ChannelDB? channel;
  String get channelId => channel?.channelId ?? widget.communityItem.groupId ?? '';

  late ChatGeneralHandler chatGeneralHandler;
  final pageConfig = ChatPageConfig();

  @override
  ChatSessionModel get session => widget.communityItem;

  @override
  void initState() {
    setupUser();
    setupChannel();
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
          if (messages != null) _messages = messages;
        });
      },
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
  }

  void setupChannel() {
    final channelId = widget.communityItem.groupId;
    if (channelId == null) return ;
    channel = Channels.sharedInstance.channels[channelId];
    if (channel == null) {
      Channels.sharedInstance.searchChannel(channelId, null).then((c) {
        if (!mounted) return ;
        if (c != null) {
          setState(() {
            channel = c;
          });
        }
      });
    }
  }

  void prepareData() {
    _loadMoreMessages();
    _updateChatStatus();
    ChatDataCache.shared.setSessionAllMessageIsRead(widget.communityItem);

    if (widget.communityItem.isMentioned) {
      OXChatBinding.sharedInstance.updateChatSession(channelId, isMentioned: false);
    }
  }

  void addListener() {
    ChatDataCache.shared.addObserver(widget.communityItem, (value) {
      chatGeneralHandler.refreshMessage(_messages, value);
    });
  }

  @override
  void dispose() {
    ChatDataCache.shared.removeObserver(widget.communityItem);
    chatGeneralHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool showUserNames = true;
    ChannelDB? channelDB = Channels.sharedInstance.channels[widget.communityItem.chatId];
    String showName = channelDB?.name ?? '';
    return Scaffold(
      backgroundColor: ThemeColor.color200,
      resizeToAvoidBottomInset: false,
      appBar: CommonAppBar(
        useLargeTitle: false,
        centerTitle: true,
        title: showName,
        backgroundColor: ThemeColor.color200,
        backCallback: () {
          OXNavigator.popToRoot(context);
        },
        actions: [
          Container(
            alignment: Alignment.center,
            child: OXChannelAvatar(
              channel: channel,
              size: 36,
              isClickable: true,
              onReturnFromNextPage: () {
                setState(() { });
              },
            ),
          ).setPadding(EdgeInsets.only(right: Adapt.px(24))),
        ],
      ),
      body: Chat(
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
          onLongPress: () {
            final user = message.author.sourceObject;
            if (user != null)
              chatGeneralHandler.mentionHandler?.addMentionText(user);
          },
        ),
        showUserNames: showUserNames,
        //Group chat display nickname
        user: _user,
        useTopSafeAreaInset: true,
        chatStatus: chatStatus,
        inputMoreItems: pageConfig.inputMoreItemsWithHandler(chatGeneralHandler),
        onVoiceSend: (String path, Duration duration) => chatGeneralHandler.sendVoiceMessage(context, path, duration),
        onGifSend: (GiphyImage image) => chatGeneralHandler.sendGifImageMessage(context, image),
        onAttachmentPressed: () {},
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
        longPressWidgetBuilder: (context, message, controller) => pageConfig.longPressWidgetBuilder(
          context: context,
          message: message,
          controller: controller,
          handler: chatGeneralHandler,
        ),
        onMessageStatusTap: chatGeneralHandler.messageStatusPressHandler,
        textMessageOptions: chatGeneralHandler.textMessageOptions(context),
        imageGalleryOptions: pageConfig.imageGalleryOptions(),
        customMessageBuilder: ChatMessageBuilder.buildCustomMessage,
        inputOptions: chatGeneralHandler.inputOptions,
        inputBottomView: chatGeneralHandler.replyHandler.buildReplyMessageWidget(),
        onFocusNodeInitialized: chatGeneralHandler.replyHandler.focusNodeSetter,
        repliedMessageBuilder: ChatMessageBuilder.buildRepliedMessageView,
        reactionViewBuilder: ChatMessageBuilder.buildReactionsView,
        mentionUserListWidget: chatGeneralHandler.mentionHandler?.buildMentionUserList(),
        onAudioDataFetched: (message) => ChatVoiceMessageHelper.populateMessageWithAudioDetails(session: session, message: message),
        onInsertedContent: (KeyboardInsertedContent insertedContent) => chatGeneralHandler.sendInsertedContentMessage(context, insertedContent),
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

  void _removeMessage(types.Message message) {
    ChatDataCache.shared.deleteMessage(widget.communityItem, message);
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    PreviewData previewData,
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
