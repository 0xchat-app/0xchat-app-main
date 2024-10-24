
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:flutter/material.dart';
import 'package:ox_chat/widget/common_chat_nav_bar.dart';
import 'package:ox_chat/widget/common_chat_widget.dart';
import 'package:ox_chat_ui/ox_chat_ui.dart';
import 'package:ox_chat/utils/general_handler/chat_general_handler.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_localizable/ox_localizable.dart';

class ChatChannelMessagePage extends StatefulWidget {

  final ChatGeneralHandler handler;

  const ChatChannelMessagePage({
    super.key,
    required this.handler,
  });

  @override
  State<ChatChannelMessagePage> createState() => _ChatChannelMessagePageState();
}

class _ChatChannelMessagePageState extends State<ChatChannelMessagePage> {

  ChannelDBISAR? channel;
  ChatGeneralHandler get handler => widget.handler;
  ChatSessionModelISAR get session => handler.session;
  String get channelId => channel?.channelId ?? session.groupId ?? '';

  ChatHintParam? bottomHintParam;


  @override
  void initState() {
    setupChannel();
    super.initState();

    prepareData();
  }

  void setupChannel() {
    final channelId = session.groupId;
    if (channelId == null) return ;
    channel = Channels.sharedInstance.channels[channelId]?.value;
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
    _updateChatStatus();
  }

  @override
  Widget build(BuildContext context) {
    return CommonChatWidget(
      handler: handler,
      navBar: buildNavBar(),
      bottomHintParam: bottomHintParam,
    );
  }

  Widget buildNavBar() {
    ChannelDBISAR? channelDB = Channels.sharedInstance.channels[channelId]?.value;
    String showName = channelDB?.name ?? '';
    return CommonChatNavBar(
      handler: handler,
      title: showName,
      actions: [
        Container(
          alignment: Alignment.center,
          child: OXChannelAvatar(
            channel: channel,
            size: 36,
            isClickable: true,
            onReturnFromNextPage: () {
              if (!mounted) return ;
              setState(() { });
            },
          ),
        ).setPadding(EdgeInsets.only(right: Adapt.px(24))),
      ],
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
