import 'package:flutter/material.dart';
import 'package:ox_chat/manager/chat_data_manager_models.dart';
import 'package:ox_chat/model/option_model.dart';
import 'package:ox_chat/page/session/chat_relay_group_msg_page.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';

import '../../session/chat_group_message_page.dart';

class GroupSharePage extends StatefulWidget {
  final String groupId;
  final String? inviterPubKey;
  final String groupOwner;
  String groupPic;
  String groupName;
  GroupType groupType;
  GroupSharePage({required this.groupId, this.inviterPubKey,required this.groupOwner,required this.groupName, required this.groupPic, required this.groupType});
  @override
  _GroupSharePageState createState() => new _GroupSharePageState();
}

class _GroupSharePageState extends State<GroupSharePage> {
  TextEditingController _groupJoinInfoText = TextEditingController();
  UserDBISAR? inviterUserDB = null;
  bool requestTag = true;
  String _practicalGroupId = '';

  @override
  void initState() {
    super.initState();
    _getInviterInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getInviterInfo() async {
    final pubKey = widget.inviterPubKey;
    if (pubKey != null && pubKey.isNotEmpty) {
      UserDBISAR? userDB = await Account.sharedInstance.getUserInfo(pubKey);
      if (userDB != null) {
        inviterUserDB = userDB;
      }
    }
    switch (widget.groupType) {
      case GroupType.channel:
        break;
      case GroupType.privateGroup:
        _practicalGroupId = widget.groupId;
        break;
      case GroupType.openGroup:
      case GroupType.closeGroup:
        SimpleGroups simpleGroups = RelayGroup.sharedInstance.getHostAndGroupId(widget.groupId);
        _practicalGroupId = simpleGroups.groupId;
        RelayGroupDBISAR? tempRelayGroupDB = await RelayGroup.sharedInstance.getGroupMetadataFromRelay(widget.groupId);
        if (tempRelayGroupDB != null) {
          widget.groupName = tempRelayGroupDB.name;
          widget.groupPic = tempRelayGroupDB.picture;
          widget.groupType = tempRelayGroupDB.closed ? GroupType.closeGroup : GroupType.openGroup;
        }
        break;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        useLargeTitle: false,
        centerTitle: true,
        backgroundColor: ThemeColor.color190,
        actions: [
          _appBarActionWidget(),
          SizedBox(
            width: Adapt.px(24),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Column(
                children: [
                  _titleInfoWidget(),
                  _userCardWidget(),
                ],
              ),
            ),
            _joinBtnWidget(),
          ],
        ),
      ),
    );
  }

  Widget _appBarActionWidget() {
    return GestureDetector(
      onTap: () {
        OXNavigator.pop(context);
      },
      child: Center(
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [
                ThemeColor.gradientMainEnd,
                ThemeColor.gradientMainStart,
              ],
            ).createShader(Offset.zero & bounds.size);
          },
          child: Text(
            Localized.text('ox_common.complete'),
            style: TextStyle(
              fontSize: Adapt.px(16),
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _titleInfoWidget() {
    return Container(
        child: Column(
      children: [
        Container(
          padding: EdgeInsets.only(
            bottom: Adapt.px(8),
          ),
          child: Text(
            Localized.text('ox_chat.group_share'),
            style: TextStyle(
              color: ThemeColor.color0,
              fontSize: Adapt.px(24),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          Localized.text('ox_chat.group_invited_item').replaceAll(r'${name}', '${inviterUserDB?.name ?? ''}'),
          style: TextStyle(
            color: ThemeColor.color60,
            fontSize: Adapt.px(12),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ));
  }

  Widget _userCardWidget() {
    Widget placeholderImage = CommonImage(
      iconName: 'user_image.png',
      width: Adapt.px(76),
      height: Adapt.px(76),
    );
    return Container(
      decoration: BoxDecoration(
        color: ThemeColor.color180,
        borderRadius: BorderRadius.all(
          Radius.circular(
            Adapt.px(12),
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: Adapt.px(12),
        horizontal: Adapt.px(24),
      ),
      margin: EdgeInsets.only(
        left: Adapt.px(24),
        right: Adapt.px(24),
        top: Adapt.px(24),
      ),
      child: Row(
        children: [
          Container(
            width: Adapt.px(48),
            height: Adapt.px(48),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Adapt.px(48)),
              child: CachedNetworkImage(
                imageUrl: widget.groupPic ?? '',
                fit: BoxFit.cover,
                placeholder: (context, url) => placeholderImage,
                errorWidget: (context, url, error) =>
                placeholderImage,
                width: Adapt.px(48),
                height: Adapt.px(48),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 16.px),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 2.px),
                  child: Text(
                    _dealWithGroupName,
                    style: TextStyle(
                      color: ThemeColor.color0,
                      fontSize: 16.px,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  _dealWithGroupId,
                  style: TextStyle(
                    color: ThemeColor.color120,
                    fontSize: 14.px,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _joinBtnWidget() {
    int status = widget.groupType == GroupType.privateGroup
        ? Groups.sharedInstance.getInGroupStatus(widget.groupId)
        : RelayGroup.sharedInstance.getInGroupStatus(widget.groupId);
    LogUtil.e('Michael: ---_joinBtnWidget--status =${status}');
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        confirmJoin(status);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: Adapt.px(24),
          vertical: Adapt.px(54),
        ),
        width: double.infinity,
        height: Adapt.px(48),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: ThemeColor.color180,
          gradient: LinearGradient(
            colors: [
              ThemeColor.gradientMainEnd,
              ThemeColor.gradientMainStart,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          _getBtnContent(status),
          style: TextStyle(
            color: Colors.white,
            fontSize: Adapt.px(16),
          ),
        ),
      ),
    );
  }

  String _getBtnContent(int status){
      switch(status){
        case 0:
          return Localized.text('ox_chat.request_group_chat_button');
        case 1:
          return Localized.text('ox_chat.join_group_chat_button');
        case 2:
          return Localized.text('ox_chat.jump_group_chat_button');
        default:
          return '--';
      }
  }

  void confirmJoin(int status) async {
    if(status == 2) return _gotoGroupChat();
    if(status == 1) return _joinGroupFn();
    if (widget.groupType == GroupType.openGroup) return _requestGroupFn();
    OXCommonHintDialog.show(context,
        title: '',
        contentView: Container(
          child: Column(
            children: [
              Text(
                Localized.text('ox_chat.confirm_join_dialog_content'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ThemeColor.color0,
                  fontSize: Adapt.px(16),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: Adapt.px(10),
                ),
                height: Adapt.px(42),
                decoration: BoxDecoration(
                  color: ThemeColor.color190,
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      Adapt.px(12),
                    ),
                  ),
                ),
                child: TextField(
                  controller: _groupJoinInfoText,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: Localized.text('ox_chat.confirm_join_dialog_hint'),
                    hintStyle: TextStyle(
                      color: ThemeColor.color100,
                      fontSize: Adapt.px(15),
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (str) {
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
        actionList: [
          OXCommonHintAction.cancel(onTap: () {
            OXNavigator.pop(context);
          }),
          OXCommonHintAction.sure(text: Localized.text('ox_chat.send'), onTap: () {
            OXNavigator.pop(context);
            _requestGroupFn();
          }),
        ],
        isRowAction: true,
    );
  }

  void _requestGroupFn()async{
    OXLoading.show();
    OKEvent? event;
    if (widget.groupType == GroupType.privateGroup) {
      event = await Groups.sharedInstance.requestGroup(
          widget.groupId, widget.groupOwner, widget.groupName, _groupJoinInfoText.text);
    } else {
      event = await RelayGroup.sharedInstance.sendJoinRequest(
          widget.groupId, _groupJoinInfoText.text);
    }
    if (!event.status) {
      CommonToast.instance.show(context, event.message);
      OXLoading.dismiss();
      return;
    }
    OXLoading.dismiss();
    if (widget.groupType == GroupType.openGroup) {
      OXNavigator.pushReplacement(
        context,
        ChatRelayGroupMsgPage(
          communityItem: ChatSessionModel(
            chatId: widget.groupId,
            groupId: widget.groupId,
            chatType: ChatType.chatRelayGroup,
            chatName: widget.groupName,
          ),
        ),
      );
    } else {
      CommonToast.instance.show(context, Localized.text('ox_chat.request_join_toast_success'));
      OXNavigator.pop(context);
    }

  }

  void _joinGroupFn()async{
    OXLoading.show();
    OKEvent? event;
    if (widget.groupType == GroupType.privateGroup) {
      event = await Groups.sharedInstance.joinGroup(widget.groupId, '${Account.sharedInstance.me?.name} join the group');
    } else {
      event = await RelayGroup.sharedInstance.joinGroup(widget.groupId, '${Account.sharedInstance.me?.name} join the group');
    }
    OXLoading.dismiss();
    if (!event.status) {
      CommonToast.instance.show(context, event.message);
      return;
    }
    if (widget.groupType != GroupType.privateGroup) {
      OXNavigator.pushReplacement(
        context,
        ChatRelayGroupMsgPage(
          communityItem: ChatSessionModel(
            chatId: widget.groupId,
            groupId: widget.groupId,
            chatType: ChatType.chatRelayGroup,
            chatName: widget.groupName,
          ),
        ),
      );
    } else {
      CommonToast.instance.show(context, Localized.text('ox_chat.join_group_success'));
      OXNavigator.pop(context);
    }
  }

  Future<void> _gotoGroupChat() async {
    ChatSessionModel? session = OXChatBinding.sharedInstance.sessionMap[widget.groupId];
    int tempCreateTime = DateTime.now().millisecondsSinceEpoch;
    if(session == null){
      session = ChatSessionModel(
        groupId: widget.groupId,
        chatType: ChatType.chatGroup,
        chatName: widget.groupName,
        createTime: tempCreateTime,
        avatar: widget.groupPic,
      );
    }
    if (widget.groupType == GroupType.privateGroup) {
      OXNavigator.pushReplacement(
        context,
        ChatGroupMessagePage(
          communityItem: session,
        ),
      );
    } else {
      OXNavigator.pushReplacement(
        context,
        ChatRelayGroupMsgPage(
          communityItem: ChatSessionModel(
            chatId: _practicalGroupId,
            groupId: _practicalGroupId,
            chatType: ChatType.chatRelayGroup,
            chatName: widget.groupName,
          ),
        ),
      );
    }
  }

  String get _dealWithGroupId {
    String groupId = _practicalGroupId;
    if(groupId.length > 33) {
      return groupId.substring(0,8) + '...' +  groupId.substring(groupId.length - 8);
    }
    return groupId;
  }

  String get _dealWithGroupName {
    String name = widget.groupName;
    if(name.length > 15){
      return name.substring(0,5) + '...' +  name.substring(name.length - 5);
    }
    return name;
  }

}
