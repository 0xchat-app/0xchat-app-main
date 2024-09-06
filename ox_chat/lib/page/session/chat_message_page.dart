
import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat/manager/chat_page_config.dart';
import 'package:ox_chat/model/constant.dart';
import 'package:ox_chat/page/session/chat_channel_message_page.dart';
import 'package:ox_chat/page/session/chat_group_message_page.dart';
import 'package:ox_chat/page/session/chat_relay_group_msg_page.dart';
import 'package:ox_chat/page/session/chat_secret_message_page.dart';
import 'package:ox_chat/utils/message_prompt_tone_mixin.dart';
import 'package:ox_chat/widget/common_chat_widget.dart';
import 'package:ox_chat/widget/not_contact_top_widget.dart';
import 'package:ox_chat/manager/chat_data_cache.dart';
import 'package:ox_chat/utils/general_handler/chat_general_handler.dart';
import 'package:ox_common/business_interface/ox_chat/utils.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_localizable/ox_localizable.dart';

class ChatMessagePage extends StatefulWidget {

  final ChatSessionModelISAR communityItem;
  final List<types.Message> initialMessage;
  final String? anchorMsgId;
  final bool hasMoreMessage;

  const ChatMessagePage({
    super.key,
    required this.communityItem,
    required this.initialMessage,
    this.anchorMsgId,
    this.hasMoreMessage = false,
  });

  @override
  State<ChatMessagePage> createState() => _ChatMessagePageState();

  static open({
    required BuildContext context,
    required ChatSessionModelISAR communityItem,
    String? anchorMsgId,
    bool isPushWithReplace = false,
  }) async {
    ChatDataCache.shared.cleanSessionMessage(communityItem);
    final initialMessage = await ChatDataCache.shared.loadSessionMessage(
      session: communityItem,
      loadMsgCount:  ChatPageConfig.messagesPerPage,
    );
    final hasMoreMessage = initialMessage.isNotEmpty;

    // Try request newest message
    final chatType = communityItem.coreChatType;
    int? since = initialMessage.firstOrNull?.createdAt;
    if (since != null) since ~/= 1000;
    if (chatType != null) {
      Messages.recoverMessagesFromRelay(
        communityItem.chatId,
        chatType,
        since: since,
      );
      if (initialMessage.isNotEmpty && initialMessage.length < ChatPageConfig.messagesPerPage) {
        int until = initialMessage.last.createdAt ~/ 1000;
        Messages.recoverMessagesFromRelay(
          communityItem.chatId,
          chatType,
          until: until,
          limit: ChatPageConfig.messagesPerPage * 3,
        );
      }
    }

    Widget? pageWidget;
    final sessionType = communityItem.chatType;
    switch (sessionType) {
      case ChatType.chatSingle:
      case ChatType.chatStranger:
        pageWidget = ChatMessagePage(
          communityItem: communityItem,
          initialMessage: initialMessage,
          hasMoreMessage: hasMoreMessage,
        );
        break ;
      case ChatType.chatSecret:
        pageWidget = ChatSecretMessagePage(
          communityItem: communityItem,
          initialMessage: initialMessage,
          hasMoreMessage: hasMoreMessage,
        );
        break ;
      case ChatType.chatChannel:
        pageWidget = ChatChannelMessagePage(
          communityItem: communityItem,
          initialMessage: initialMessage,
          hasMoreMessage: hasMoreMessage,
        );
        break ;
      case ChatType.chatGroup:
        pageWidget = ChatGroupMessagePage(
          communityItem: communityItem,
          initialMessage: initialMessage,
          hasMoreMessage: hasMoreMessage,
        );
        break ;
      case ChatType.chatRelayGroup:
        pageWidget = ChatRelayGroupMsgPage(
          communityItem: communityItem,
          initialMessage: initialMessage,
          hasMoreMessage: hasMoreMessage,
        );
        break ;
    }

    if (pageWidget == null) return ;

    if (isPushWithReplace) {
      return OXNavigator.pushReplacement(context, pageWidget);
    }
    return OXNavigator.pushPage(context, (context) => pageWidget!);
  }
}

class _ChatMessagePageState extends State<ChatMessagePage> with MessagePromptToneMixin {

  late ChatGeneralHandler chatGeneralHandler;
  List<types.Message> _messages = [];

  UserDBISAR? get otherUser => chatGeneralHandler.otherUser;

  bool isShowContactMenu = true;

  @override
  ChatSessionModelISAR get session => widget.communityItem;
  
  @override
  void initState() {
    setupChatGeneralHandler();
    super.initState();

    prepareData();
  }

  void setupChatGeneralHandler() {
    chatGeneralHandler = ChatGeneralHandler(
      session: widget.communityItem,
      refreshMessageUI: (messages) {
        setState(() {
          if (messages != null) _messages = messages;
        });
      },
      fileEncryptionType: types.EncryptionType.encrypted,
    );
    chatGeneralHandler.hasMoreMessage = widget.hasMoreMessage;
  }

  void prepareData() {
    _messages = [...widget.initialMessage];
    // _loadMoreMessages();
    _updateChatStatus();
    ChatDataCache.shared.setSessionAllMessageIsRead(widget.communityItem);
    _handleAutoDelete();
    _handelDMRelay();
  }

  @override
  void dispose() {
    ChatDataCache.shared.removeObserver(widget.communityItem);
    // close other uer dm relays
    Contacts.sharedInstance.closeUserDMRelays(widget.communityItem.chatId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: CommonChatWidget(
        handler: chatGeneralHandler,
        messages: _messages,
        anchorMsgId: widget.anchorMsgId,
        customTopWidget: isShowContactMenu
          ? NotContactTopWidget(
            chatSessionModel: widget.communityItem,
            onTap: _hideContactMenu,
          ) : null,
      ),
    );
  }

  void _hideContactMenu() {
    setState(() {
      isShowContactMenu = false;
    });
  }

  void _updateChatStatus() {
    final userId = otherUser?.pubKey ?? '';
    if (userId.isEmpty) return ;

    final isContact = Contacts.sharedInstance.allContacts.containsKey(userId);
    isShowContactMenu = !isContact;
  }

  Future<void> _loadMoreMessages() async {
    await chatGeneralHandler.loadMoreMessage(_messages);
  }

  void _handleAutoDelete() {
    int? time = session.expiration;
    String timeStr = '';
    if(time != null && time > 0){
      if(time >= 24 * 3600){
        timeStr = (time ~/ (24*3600)).toString() + ' ' + Localized.text('ox_chat.day');
      } else if (time >= 3600){
        timeStr = '${(time ~/ 3600).toString()} ${Localized.text('ox_chat.hours')} ${Localized.text('ox_chat.and')} ${((time % 3600) ~/ 60).toString()} ${Localized.text('ox_chat.minutes')}';
      } else {
        timeStr = (time ~/ 60).toString() + ' ' + Localized.text('ox_chat.minutes');
      }
      chatGeneralHandler.sendSystemMessage(
        context,
        Localized.text('ox_chat.str_dm_auto_delete_hint').replaceAll(r'${time}', timeStr),
        sendingType: ChatSendingType.memory,
      );
    }
  }

  Future<void> _handelDMRelay() async {
    await Account.sharedInstance.reloadProfileFromRelay(otherUser?.pubKey ?? '');
    if(otherUser?.dmRelayList?.isNotEmpty == false){
      chatGeneralHandler.sendSystemMessage(
        context,
        Localized.text('ox_chat.user_dmrelay_not_set_hint_message'),
        sendingType: ChatSendingType.memory,
      );
    }
    else{
      // connect to other uer dm relays
      Contacts.sharedInstance.connectUserDMRelays(widget.communityItem.chatId).then((result){
         if(!result && mounted){
           chatGeneralHandler.sendSystemMessage(
             context,
             Localized.text('ox_chat.user_dmrelay_not_connect_hint_message'),
             sendingType: ChatSendingType.memory,
           );
         }
      });
      // check my dm relay
      if(chatGeneralHandler.author.sourceObject?.dmRelayList?.isNotEmpty == false){
        chatGeneralHandler.sendSystemMessage(
          context,
          Localized.text('ox_chat.my_dmrelay_not_set_hint_message'),
          sendingType: ChatSendingType.memory,
        );
      }
    }
  }
}
