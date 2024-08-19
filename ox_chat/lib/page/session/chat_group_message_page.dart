
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
import 'package:ox_module_service/ox_module_service.dart';

class ChatGroupMessagePage extends StatefulWidget {

  final ChatSessionModelISAR communityItem;
  final List<types.Message> initialMessage;
  final String? anchorMsgId;
  final bool hasMoreMessage;

  const ChatGroupMessagePage({
    super.key,
    required this.communityItem,
    required this.initialMessage,
    this.anchorMsgId,
    this.hasMoreMessage = false,
  });

  @override
  State<ChatGroupMessagePage> createState() => _ChatGroupMessagePageState();
}

class _ChatGroupMessagePageState extends State<ChatGroupMessagePage> with MessagePromptToneMixin {

  late ChatGeneralHandler chatGeneralHandler;
  List<types.Message> _messages = [];

  ChatHintParam? bottomHintParam;

  GroupDBISAR? group;
  String get groupId => group?.groupId ?? widget.communityItem.groupId ?? '';

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
      fileEncryptionType: types.EncryptionType.encrypted,
    );
    chatGeneralHandler.hasMoreMessage = widget.hasMoreMessage;
  }

  void setupGroup() {
    final groupId = widget.communityItem.groupId;
    if (groupId == null) return ;
    group = Groups.sharedInstance.groups[groupId];
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
      body: CommonChatWidget(
        handler: chatGeneralHandler,
        messages: _messages,
        anchorMsgId: widget.anchorMsgId,
        bottomHintParam: bottomHintParam,
      ),
    );
  }

  void _updateChatStatus() {
    if (!Groups.sharedInstance.checkInGroup(groupId)) {
      bottomHintParam = ChatHintParam(
        Localized.text('ox_chat_ui.group_request'),
        onRequestGroupTap,
      );
      return ;
    } else if (!Groups.sharedInstance.checkInMyGroupList(groupId)) {
      bottomHintParam = ChatHintParam(
        Localized.text('ox_chat_ui.group_join'),
        onJoinGroupTap,
      );
      return ;
    }

    final userDB = OXUserInfoManager.sharedInstance.currentUserInfo;

    if (groupId.isEmpty || userDB == null) {
      ChatLogUtils.error(
        className: 'ChatGroupMessagePage',
        funcName: '_initializeChatStatus',
        message: 'groupId: $groupId, userDB: $userDB',
      );
      return ;
    }

    bottomHintParam = null;
  }

  Future<void> _loadMoreMessages() async {
    await chatGeneralHandler.loadMoreMessage(_messages);
  }

  Future onJoinGroupTap() async {
    await OXLoading.show();
    final OKEvent okEvent = await Groups.sharedInstance.joinGroup(groupId, '${chatGeneralHandler.author.firstName} join the group');
    await OXLoading.dismiss();
    if (okEvent.status) {
      OXChatBinding.sharedInstance.groupsUpdatedCallBack();
      setState(() {
        _updateChatStatus();
      });
    } else {
      CommonToast.instance.show(context, okEvent.message);
    }
  }

  Future onRequestGroupTap() async {
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
  }
}
