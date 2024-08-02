
import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat/model/constant.dart';
import 'package:ox_chat/utils/message_prompt_tone_mixin.dart';
import 'package:ox_chat/widget/common_chat_widget.dart';
import 'package:ox_chat/widget/not_contact_top_widget.dart';
import 'package:ox_chat/manager/chat_data_cache.dart';
import 'package:ox_chat/utils/general_handler/chat_general_handler.dart';
import 'package:ox_common/business_interface/ox_chat/utils.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_localizable/ox_localizable.dart';

class ChatMessagePage extends StatefulWidget {

  final ChatSessionModelISAR communityItem;
  final String? anchorMsgId;

  const ChatMessagePage({Key? key, required this.communityItem, this.anchorMsgId}) : super(key: key);

  @override
  State<ChatMessagePage> createState() => _ChatMessagePageState();
}

class _ChatMessagePageState extends State<ChatMessagePage> with MessagePromptToneMixin, ChatGeneralHandlerMixin {

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
    addListener();
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
  }

  void prepareData() {
    _loadMoreMessages();
    _updateChatStatus();
    ChatDataCache.shared.setSessionAllMessageIsRead(widget.communityItem);
    _handelDMRelay();
  }

  void addListener() {
    ChatDataCache.shared.addObserver(widget.communityItem, (value) {
      chatGeneralHandler.refreshMessage(_messages, value);
    });
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
         if(!result){
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
