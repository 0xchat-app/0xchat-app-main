
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat/utils/message_prompt_tone_mixin.dart';
import 'package:ox_chat/widget/common_chat_widget.dart';
import 'package:ox_chat_ui/ox_chat_ui.dart';
import 'package:ox_chat/manager/chat_data_cache.dart';
import 'package:ox_chat/utils/general_handler/chat_general_handler.dart';
import 'package:ox_chat/utils/chat_log_utils.dart';
import 'package:ox_common/utils/ox_chat_observer.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_localizable/ox_localizable.dart';

class ChatRelayGroupMsgPage extends StatefulWidget {

  final ChatSessionModelISAR communityItem;
  final List<types.Message> initialMessage;
  final String? anchorMsgId;
  final bool hasMoreMessage;

  const ChatRelayGroupMsgPage({
    super.key,
    required this.communityItem,
    required this.initialMessage,
    this.anchorMsgId,
    this.hasMoreMessage = false,
  });

  @override
  State<ChatRelayGroupMsgPage> createState() => _ChatRelayGroupMsgPageState();
}

class _ChatRelayGroupMsgPageState extends State<ChatRelayGroupMsgPage> with MessagePromptToneMixin, OXChatObserver {

  late ChatGeneralHandler chatGeneralHandler;
  List<types.Message> _messages = [];
  
  ChatHintParam? bottomHintParam;

  RelayGroupDBISAR? relayGroup;
  String get groupId => relayGroup?.groupId ?? widget.communityItem.groupId ?? '';

  @override
  ChatSessionModelISAR get session => widget.communityItem;

  @override
  void initState() {
    setupGroup();
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
    chatGeneralHandler.hasMoreMessage = widget.hasMoreMessage;
  }

  void setupGroup() {
    final groupId = widget.communityItem.groupId;
    if (groupId == null) return ;
    relayGroup = RelayGroup.sharedInstance.groups[groupId];
    if (relayGroup == null) {
      RelayGroup.sharedInstance.getGroupMetadataFromRelay(groupId).then((relayGroupDB) {
        if (!mounted) return ;
        if (relayGroupDB != null) {
          _updateChatStatus();
          setState(() {
            relayGroup = relayGroupDB;
          });
        }
      });
    }
  }

  void prepareData() {
    _messages = [...widget.initialMessage];
    // _loadMoreMessages();
    _updateChatStatus();
    ChatDataCache.shared.setSessionAllMessageIsRead(widget.communityItem);

    if (widget.communityItem.isMentioned) {
      OXChatBinding.sharedInstance.updateChatSession(groupId, isMentioned: false);
    }
  }

  @override
  void dispose() {
    ChatDataCache.shared.removeObserver(widget.communityItem);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    RelayGroupDBISAR? tempDb = RelayGroup.sharedInstance.groups[widget.communityItem.groupId];
    String showName = tempDb?.name ?? '';
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
            child: OXRelayGroupAvatar(
              relayGroup: relayGroup,
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
    int status = RelayGroup.sharedInstance.getInGroupStatus(groupId);
    if (status == 0) {
      bottomHintParam = ChatHintParam(
        Localized.text('ox_chat_ui.group_request'),
        _onRequestGroupTap,
      );
      return;
    } else if (status == 1) {
      bottomHintParam = ChatHintParam(
        Localized.text('ox_chat_ui.group_join'),
        _onJoinGroupTap,
      );
      return;
    }

    final userDB = OXUserInfoManager.sharedInstance.currentUserInfo;

    if (groupId.isEmpty || userDB == null) {
      ChatLogUtils.error(className: 'ChatGroupMessagePage',
          funcName: '_initializeChatStatus',
          message: 'channelId: $groupId, userDB: $userDB');
      return;
    }

    bottomHintParam = null;
  }

  void _onJoinGroupTap() async {
    OXLoading.show();
    OKEvent event = await RelayGroup.sharedInstance.joinGroup(groupId, '${chatGeneralHandler.author.firstName} join the group');
    OXUserInfoManager.sharedInstance.setNotification();
    OXLoading.dismiss();
    if (!event.status) {
      CommonToast.instance.show(context, event.message);
    }
    setState(() {
      _updateChatStatus();
    });
  }

  void _onRequestGroupTap() async {
    await OXLoading.show();
    final OKEvent okEvent = await RelayGroup.sharedInstance.sendJoinRequest(groupId, '${chatGeneralHandler.author.firstName} join the group');
    OXUserInfoManager.sharedInstance.setNotification();
    await OXLoading.dismiss();
    if (!okEvent.status) {
      CommonToast.instance.show(context, okEvent.message);
    }
    else{
      CommonToast.instance.show(context, 'Request send successfully');
    }
    setState(() {
      _updateChatStatus();
    });
  }

  @override
  void didRelayGroupModerationCallBack(ModerationDBISAR moderationDB) {
    setState(() {
      _updateChatStatus();
    });
  }
}
