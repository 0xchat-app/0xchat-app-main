
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:flutter/material.dart';
import 'package:ox_chat/widget/common_chat_nav_bar.dart';
import 'package:ox_chat/widget/common_chat_widget.dart';
import 'package:ox_chat_ui/ox_chat_ui.dart';
import 'package:ox_chat/utils/general_handler/chat_general_handler.dart';
import 'package:ox_chat/utils/chat_log_utils.dart';
import 'package:ox_common/utils/ox_chat_observer.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_localizable/ox_localizable.dart';

class ChatRelayGroupMsgPage extends StatefulWidget {

  final ChatGeneralHandler handler;

  const ChatRelayGroupMsgPage({
    super.key,
    required this.handler,
  });

  @override
  State<ChatRelayGroupMsgPage> createState() => _ChatRelayGroupMsgPageState();
}

class _ChatRelayGroupMsgPageState extends State<ChatRelayGroupMsgPage> with OXChatObserver {

  RelayGroupDBISAR? relayGroup;
  ChatGeneralHandler get handler => widget.handler;
  ChatSessionModelISAR get session => handler.session;
  String get groupId => relayGroup?.groupId ?? session.groupId ?? '';
  
  ChatHintParam? bottomHintParam;

  @override
  void initState() {
    setupGroup();
    super.initState();

    prepareData();
  }

  Future<void> setupGroup() async {
    final groupId = session.groupId;
    if (groupId == null) return ;
    relayGroup = RelayGroup.sharedInstance.groups[groupId]?.value;
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
    else{
      int status = RelayGroup.sharedInstance.getInGroupStatus(groupId);
      if(status == 0){
        bool result = await RelayGroup.sharedInstance.checkInGroupFromRelay(groupId, Account.sharedInstance.currentPubkey);
        if(result && mounted) {
          setState(() {
            _updateChatStatus();
          });
        }
      }
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

  PreferredSizeWidget buildNavBar() {
    RelayGroupDBISAR? tempDb = RelayGroup.sharedInstance.groups[groupId]?.value;
    String showName = tempDb?.name ?? '';
    return CommonChatNavBar(
      handler: handler,
      title: showName,
      actions: [
        Container(
          alignment: Alignment.center,
          child: OXRelayGroupAvatar(
            relayGroup: relayGroup,
            size: 36,
            isClickable: true,
            onReturnFromNextPage: () {
              if (!mounted) return ;
              setState(() { });
            },
          ),
        ),
      ],
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
        _onRequestGroupTap,
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
    OKEvent event = await RelayGroup.sharedInstance.joinGroup(groupId, '${handler.author.firstName} join the group');
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
    final OKEvent okEvent = await RelayGroup.sharedInstance.sendJoinRequest(groupId, '${handler.author.firstName} join the group');
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
