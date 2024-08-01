
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
import 'package:ox_module_service/ox_module_service.dart';

class ChatGroupMessagePage extends StatefulWidget {

  final ChatSessionModel communityItem;
  final String? anchorMsgId;

  ChatGroupMessagePage({Key? key, required this.communityItem, this.anchorMsgId}) : super(key: key);

  @override
  State<ChatGroupMessagePage> createState() => _ChatGroupMessagePageState();
}

class _ChatGroupMessagePageState extends State<ChatGroupMessagePage> with MessagePromptToneMixin, ChatGeneralHandlerMixin {

  List<types.Message> _messages = [];

  late types.User _user;
  double keyboardHeight = 0;
  late ChatStatus chatStatus;

  GroupDBISAR? group;
  String get groupId => group?.groupId ?? widget.communityItem.groupId ?? '';

  late ChatGeneralHandler chatGeneralHandler;
  final pageConfig = ChatPageConfig();

  @override
  ChatSessionModel get session => widget.communityItem;

  @override
  void initState() {
    setupUser();
    setupGroup();
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
      fileEncryptionType: types.EncryptionType.encrypted,
    );
    chatGeneralHandler.messageDeleteHandler = _removeMessage;
  }

  void setupUser() {
    // Mine
    UserDBISAR? userDB = OXUserInfoManager.sharedInstance.currentUserInfo;
    _user = types.User(
      id: userDB!.pubKey,
      sourceObject: userDB,
    );
  }

  void setupGroup() {
    final groupId = widget.communityItem.groupId;
    if (groupId == null) return ;
    group = Groups.sharedInstance.groups[groupId];
  }

  void prepareData() {
    _loadMoreMessages();
    _updateChatStatus();
    ChatDataCache.shared.setSessionAllMessageIsRead(widget.communityItem);

    if (widget.communityItem.isMentioned) {
      OXChatBinding.sharedInstance.updateChatSession(groupId, isMentioned: false);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool showUserNames = true;
    GroupDBISAR? group = Groups.sharedInstance.groups[widget.communityItem.groupId];
    String showName = group?.name ?? '';
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
            child: OXGroupAvatar(
              group: group,
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
        onJoinGroupTap: () async {
          await OXLoading.show();
          final OKEvent okEvent = await Groups.sharedInstance.joinGroup(groupId, '${_user.firstName} join the group');
          await OXLoading.dismiss();
          if (okEvent.status) {
            OXChatBinding.sharedInstance.groupsUpdatedCallBack();
            setState(() {
              _updateChatStatus();
            });
          } else {
            CommonToast.instance.show(context, okEvent.message);
          }
        },
        onRequestGroupTap: () async {
          OXModuleService.invoke('ox_chat', 'groupSharePage',[context],
              {
                Symbol('groupPic'): group?.picture ?? '',
                Symbol('groupName'):groupId,
                Symbol('groupOwner'): group?.owner ?? '',
                Symbol('groupId'):groupId,
                Symbol('inviterPubKey'):'',
              }
          );
          // await OXLoading.show();
          // final OKEvent okEvent = await Groups.sharedInstance.requestGroup(groupId, group?.owner ?? '','');
          //
          // await OXLoading.dismiss();
          // if (okEvent.status) {
          //   CommonToast.instance.show(context, 'Request Sent!');
          // } else {
          //   CommonToast.instance.show(context, okEvent.message);
          // }
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
    if(!Groups.sharedInstance.checkInGroup(groupId)){
      chatStatus = ChatStatus.RequestGroup;
      return ;
    }
    else if (!Groups.sharedInstance.checkInMyGroupList(groupId)) {
      chatStatus = ChatStatus.NotJoinedGroup;
      return ;
    }

    final userDB = OXUserInfoManager.sharedInstance.currentUserInfo;

    if (groupId.isEmpty || userDB == null) {
      ChatLogUtils.error(className: 'ChatGroupMessagePage', funcName: '_initializeChatStatus', message: 'groupId: $groupId, userDB: $userDB');
      chatStatus = ChatStatus.Unknown;
      return ;
    }

    chatStatus = ChatStatus.Normal;
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
