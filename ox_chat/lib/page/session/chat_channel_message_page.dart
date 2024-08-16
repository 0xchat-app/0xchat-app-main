
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat/utils/message_prompt_tone_mixin.dart';
import 'package:ox_chat/widget/common_chat_widget.dart';
import 'package:ox_chat_ui/ox_chat_ui.dart';
import 'package:ox_chat/manager/chat_data_cache.dart';
import 'package:ox_chat/utils/general_handler/chat_general_handler.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_localizable/ox_localizable.dart';

class ChatChannelMessagePage extends StatefulWidget {

  final ChatSessionModelISAR communityItem;
  final String? anchorMsgId;

  ChatChannelMessagePage({Key? key, required this.communityItem, this.anchorMsgId}) : super(key: key);

  @override
  State<ChatChannelMessagePage> createState() => _ChatChannelMessagePageState();
}

class _ChatChannelMessagePageState extends State<ChatChannelMessagePage> with MessagePromptToneMixin {

  late ChatGeneralHandler chatGeneralHandler;
  List<types.Message> _messages = [];

  ChannelDBISAR? channel;
  String get channelId => channel?.channelId ?? widget.communityItem.groupId ?? '';

  ChatHintParam? bottomHintParam;

  @override
  ChatSessionModelISAR get session => widget.communityItem;

  @override
  void initState() {
    setupChannel();
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

  @override
  void dispose() {
    ChatDataCache.shared.removeObserver(widget.communityItem);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ChannelDBISAR? channelDB = Channels.sharedInstance.channels[widget.communityItem.chatId];
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
      body: CommonChatWidget(
        handler: chatGeneralHandler,
        messages: _messages,
        anchorMsgId: widget.anchorMsgId,
        bottomHintParam: bottomHintParam,
      ),
    );
  }

  void _updateChatStatus() {
    if (!Channels.sharedInstance.myChannels.containsKey(channelId)) {
      bottomHintParam = ChatHintParam(
        Localized.text('ox_chat_ui.channel_join'),
        onJoinChannelTap,
      );
    }
    else{
      bottomHintParam = null;
    }
  }

  Future<void> _loadMoreMessages() async {
    await chatGeneralHandler.loadMoreMessage(_messages);
  }

  Future onJoinChannelTap() async {
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
  }
}
