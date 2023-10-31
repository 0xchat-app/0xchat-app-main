import 'package:flutter/material.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';

import '../../session/chat_group_message_page.dart';

class GroupSharePage extends StatefulWidget {
  final String groupId;
  final String inviterPubKey;
  final String groupOwner;
  final String groupPic;
  final String groupName;
  GroupSharePage({required this.groupId,required this.inviterPubKey,required this.groupOwner,required this.groupName, required this.groupPic});
  @override
  _GroupSharePageState createState() => new _GroupSharePageState();
}

class _GroupSharePageState extends State<GroupSharePage> {
  TextEditingController _groupJoinInfoText = TextEditingController();
  UserDB? inviterUserDB = null;

  bool requestTag = true;

  @override
  void initState() {
    super.initState();
    _getInviterInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getInviterInfo()async {
    String pubKey = widget.inviterPubKey;
    if(pubKey.isEmpty) return;
    UserDB? userDB = await Account.sharedInstance.getUserInfo(pubKey);
    if(userDB != null){
      setState(() {
        inviterUserDB = userDB;
      });
    }
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
            'Done',
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
            'Group share',
            style: TextStyle(
              color: ThemeColor.color0,
              fontSize: Adapt.px(24),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          '${inviterUserDB?.name ?? ''} invited you to join the Group',
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
            padding: EdgeInsets.only(
              left: Adapt.px(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    bottom: Adapt.px(2),
                  ),
                  child: Text(
                    _dealWithGroupName,
                    style: TextStyle(
                      color: ThemeColor.color0,
                      fontSize: Adapt.px(16),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  _dealWithGroupId,
                  style: TextStyle(
                    color: ThemeColor.color120,
                    fontSize: Adapt.px(14),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _joinBtnWidget() {
    int status = Groups.sharedInstance.getInGroupStatus(widget.groupId);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: confirmJoin,
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
          return 'request Group Chat';
        case 1:
          return 'join Group Chat';
        case 2:
          return 'Jump Group Chat';
        default:
          return '--';
      }
  }

  void confirmJoin() async {
    int status = Groups.sharedInstance.getInGroupStatus(widget.groupId);
    if(status == 2) return _createGroup();
    if(status == 1) return _joinGroupFn();
    OXCommonHintDialog.show(context,
        title: '',
        contentView: Container(
          child: Column(
            children: [
              Text(
                "The group owner has required 'invitation Approval'. you can add an join reason to give the group owner and admin.",
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
                    hintText: "Please enter...",
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
          OXCommonHintAction.sure(text: 'Send', onTap: _requestGroupFn),
        ],
        isRowAction: true,
    );
  }

  void _requestGroupFn()async{
    if(requestTag){
      _changeRequestTagStatus(false);
      OXLoading.show();
      OKEvent event = await Groups.sharedInstance.requestGroup(widget.groupId,widget.groupOwner, _groupJoinInfoText.text);

      if (!event.status) {
        _changeRequestTagStatus(true);
        CommonToast.instance.show(context, event.message);
        OXLoading.dismiss();
        return;
      }

      CommonToast.instance.show(context, 'Request to join the group');
      OXNavigator.pop(context);
    }

  }

  void _joinGroupFn()async{
    if(requestTag){
      _changeRequestTagStatus(false);
      OXLoading.show();
      OKEvent event = await Groups.sharedInstance.joinGroup(widget.groupId,'${Account.sharedInstance.me?.name} join the group');

      if (!event.status) {
        _changeRequestTagStatus(true);
        CommonToast.instance.show(context, event.message);
        OXLoading.dismiss();
        return;
      }
    }
      CommonToast.instance.show(context, 'Join the group');
      OXNavigator.pop(context);
  }

  void _changeRequestTagStatus(bool status) {
    setState(() {
      requestTag = status;
    });
  }

  Future<void> _createGroup() async {
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
      OXNavigator.pushReplacement(
        context,
        ChatGroupMessagePage(
          communityItem: session,
        ),
      );
  }

  String get _dealWithGroupId {
    String groupId = widget.groupId;
    return groupId.substring(0,5) + '...' +  groupId.substring(groupId.length - 5);
  }

  String get _dealWithGroupName {
    String name = widget.groupName;
    if(name.length > 15){
      return name.substring(0,5) + '...' +  name.substring(name.length - 5);
    }
    return name;
  }

}
