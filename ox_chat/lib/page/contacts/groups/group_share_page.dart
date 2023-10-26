import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_common/widgets/common_toast.dart';

class GroupSharePage extends StatefulWidget {
  final String groupId;
  final String inviterPubKey;
  final String groupOwner;
  GroupSharePage({required this.groupId,required this.inviterPubKey,required this.groupOwner});

  @override
  _GroupSharePageState createState() => new _GroupSharePageState();
}

class _GroupSharePageState extends State<GroupSharePage> {
  TextEditingController _groupJoinInfoText = TextEditingController();
  GroupDB? groupDBInfo = null;
  UserDB? inviterUserDB = null;

  @override
  void initState() {
    super.initState();
    _groupInfoInit();
    _getInviterInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getInviterInfo()async {
    UserDB? userDB = await Account.sharedInstance.getUserInfo(widget.inviterPubKey);
    if(userDB != null){
      setState(() {
        inviterUserDB = userDB;
      });
    }
  }

  void _groupInfoInit() async {
    GroupDB? groupDB = await Groups.sharedInstance.myGroups[widget.groupId];

    if (groupDB != null) {
      groupDBInfo = groupDB;

      setState(() {});
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
      onTap: () {},
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
          '${inviterUserDB?.name ?? '--'} invited you to join the Group',
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
                imageUrl: groupDBInfo?.picture ?? '',
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
                    groupDBInfo?.name ?? '',
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
          'Join Group Chat',
          style: TextStyle(
            color: Colors.white,
            fontSize: Adapt.px(16),
          ),
        ),
      ),
    );
  }

  void confirmJoin() async {
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
          OXCommonHintAction.sure(text: 'Send', onTap: () async {
            OKEvent event = await Groups.sharedInstance.requestGroup(widget.groupId,widget.groupOwner, _groupJoinInfoText.text);
            if(event.status) {
              CommonToast.instance.show(context, 'The application is successful');
              OXNavigator.pop(context);
            }
          }),
        ],
        isRowAction: true,
    );
  }

  String get _dealWithGroupId {
    String? groupId = groupDBInfo?.groupId;
    if(groupId == null) return '--';
    return groupId.substring(0,5) + '...' +  groupId.substring(groupId.length - 5);
  }

//
}
