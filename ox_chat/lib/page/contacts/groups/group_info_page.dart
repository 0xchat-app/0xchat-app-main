import 'dart:io';

import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:flutter/services.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';

import '../contact_group_list_page.dart';
import '../contact_group_member_page.dart';
import 'group_edit_page.dart';
import 'group_join_requests.dart';
import 'group_notice_page.dart';
import 'group_setting_qrcode_page.dart';

import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'group_share_page.dart';

class GroupInfoPage extends StatefulWidget {
  final String groupId;

  GroupInfoPage({Key? key, required this.groupId}) : super(key: key);

  @override
  _GroupInfoPageState createState() => new _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  bool _isMute = false;
  List<UserDB> groupMember = [];
  GroupDB? groupDBInfo = null;
  @override
  void initState() {
    super.initState();
    _groupInfoInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _groupInfoInit() async {
    GroupDB? groupDB = await Groups.sharedInstance.myGroups[widget.groupId];
    List<UserDB>? groupList =
        await Groups.sharedInstance.getAllGroupMembers(widget.groupId);

    if (groupDB != null) {
      groupDBInfo = groupDB;

      groupMember = groupList;
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
        title: 'Group Info',
        backgroundColor: ThemeColor.color190,
        actions: [
          _appBarActionWidget(),
          SizedBox(
            width: Adapt.px(24),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: Adapt.px(24),
          ),
          child: Column(
            children: [
              _optionMemberWidget(),
              _groupBaseOptionView(),
              _groupLocationView(),
              _leaveBtnWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBarActionWidget() {
    return GestureDetector(
      onTap: _shareGroupFn,
      child: CommonImage(
        iconName: 'share_icon.png',
        width: Adapt.px(24),
        height: Adapt.px(24),
        useTheme: true,
      ),
    );
  }

  Widget _optionMemberWidget() {
    return Container(
      margin: EdgeInsets.only(
        top: Adapt.px(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _memberAvatarWidget(),
              _addOrDelMember(),
            ],
          ),
          GestureDetector(
            onTap: () => _groupMemberOptionFn(GroupListAction.view),
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: Adapt.px(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: Adapt.px(20),
                    child: Text(
                      'View All ${groupMember.length} Members',
                      style: TextStyle(
                        fontSize: Adapt.px(14),
                        color: ThemeColor.color100,
                      ),
                    ),
                  ),
                  CommonImage(
                    iconName: 'icon_more.png',
                    width: Adapt.px(24),
                    height: Adapt.px(24),
                    package: 'ox_chat',
                    useTheme: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _memberAvatarWidget() {
    if (groupMember.length == 0) return Container();
    return Container(
      margin: EdgeInsets.only(
        right: Adapt.px(0),
      ),
      constraints: BoxConstraints(
          maxWidth: Adapt.px(24 * groupMember.length + 24),
          minWidth: Adapt.px(48)),
      child: AvatarStack(
        settings: RestrictedPositions(
            // maxCoverage: 0.1,
            // minCoverage: 0.2,
            align: StackAlign.left,
            laying: StackLaying.first),
        borderColor: ThemeColor.color180,
        height: Adapt.px(48),
        avatars: [
          for (var n = 0; n < groupMember.length; n++)
            if (groupMember[n].picture?.isNotEmpty != null)
              CachedNetworkImageProvider(groupMember[n].picture!)
            else
              const AssetImage('assets/images/user_image.png',
                  package: 'ox_common'),
        ],
      ),
    );
  }

  Widget _addOrDelMember() {
    return Container(
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _groupMemberOptionFn(GroupListAction.add),
            child: CommonImage(
              iconName: 'add_circle_icon.png',
              width: Adapt.px(48),
              height: Adapt.px(48),
              useTheme: true,
            ),
          ),
          GestureDetector(
            onTap: () => _groupMemberOptionFn(GroupListAction.remove),
            child: Container(
              margin: EdgeInsets.only(
                left: Adapt.px(12),
              ),
              child: CommonImage(
                iconName: 'del_circle_icon.png',
                width: Adapt.px(48),
                height: Adapt.px(48),
                useTheme: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _groupBaseOptionView() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(16)),
        color: ThemeColor.color180,
      ),
      child: Column(
        children: [
          _topItemBuild(
              title: 'Group Name',
              subTitle: groupDBInfo?.name ?? '--',
              onTap: _updateGroupNameFn,
              isShowMoreIcon: _isGroupMember),
          _topItemBuild(
              title: 'Members',
              subTitle: groupMember.length.toString(),
              isShowMoreIcon: false),
          _topItemBuild(
            title: 'Group QR Code',
            actionWidget: CommonImage(
              iconName: 'qrcode_icon.png',
              width: Adapt.px(24),
              height: Adapt.px(24),
              useTheme: true,
            ),
            onTap: _groupQrCodeFn,
          ),
          _topItemBuild(
            title: 'Group Notice',
            titleDes: groupDBInfo?.pinned?[0] ?? '--',
            onTap: _updateGroupNoticeFn,
            isShowMoreIcon: _isGroupMember,
          ),
          _topItemBuild(
            title: 'Join requests',
            onTap: () =>
                OXNavigator.pushPage(context, (context) => GroupJoinRequests()),
          ),
          _topItemBuild(
            title: 'Mute',
            isShowDivider: false,
            actionWidget: _muteSwitchWidget(),
            isShowMoreIcon: false,
          ),
        ],
      ),
    );
  }

  Widget _groupLocationView() {
    return Container(
      margin: EdgeInsets.only(
        top: Adapt.px(12),
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(16)),
        color: ThemeColor.color180,
      ),
      child: Column(
        children: [],
      ),
    );
  }

  Widget _muteSwitchWidget() {
    return Container(
      height: Adapt.px(25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Switch(
            value: _isMute,
            activeColor: Colors.white,
            activeTrackColor: ThemeColor.gradientMainStart,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: ThemeColor.color160,
            onChanged: (value) => _changeMuteFn(value),
            materialTapTargetSize: MaterialTapTargetSize.padded,
          ),
        ],
      ),
    );
  }

  Widget _topItemBuild({
    String? title,
    String? titleDes,
    String? subTitle,
    bool isShowMoreIcon = true,
    bool isShowDivider = true,
    Widget? actionWidget,
    GestureTapCallback? onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap != null ? onTap : () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: Adapt.px(16),
            ),
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: Adapt.px(12),
            ),
            // height: Adapt.px(52),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  // margin: EdgeInsets.only(left: Adapt.px(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title ?? '',
                        style: TextStyle(
                          color: ThemeColor.color0,
                          fontSize: Adapt.px(16),
                        ),
                      ),
                      titleDes != null
                          ? Container(
                              width: Adapt.px(280),
                              margin: EdgeInsets.only(
                                top: Adapt.px(4),
                              ),
                              child: Text(
                                titleDes,
                                style: TextStyle(
                                  fontSize: Adapt.px(14),
                                  fontWeight: FontWeight.w400,
                                  color: ThemeColor.color100,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      actionWidget != null ? actionWidget : Container(),
                      subTitle != null
                          ? Text(
                              subTitle,
                              style: TextStyle(
                                fontSize: Adapt.px(14),
                                fontWeight: FontWeight.w400,
                                color: ThemeColor.color100,
                              ),
                            )
                          : Container(),
                      isShowMoreIcon
                          ? CommonImage(
                              iconName: 'icon_arrow_more.png',
                              width: Adapt.px(24),
                              height: Adapt.px(24),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: isShowDivider,
            child: Divider(
              height: Adapt.px(0.5),
              color: ThemeColor.color160,
            ),
          ),
        ],
      ),
    );
  }

  Widget _leaveBtnWidget() {
    if (!_isGroupMember) return Container();
    String content = _isGroupOwner() ? 'Delete and leave' : 'Leave';
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(
          top: Adapt.px(16),
          bottom: Adapt.px(50),
        ),
        width: double.infinity,
        height: Adapt.px(48),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: ThemeColor.color180,
        ),
        alignment: Alignment.center,
        child: Text(
          content,
          style: TextStyle(
            color: ThemeColor.red,
            fontSize: Adapt.px(16),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      onTap: _leaveConfirmWidget,
    );
  }

  void _leaveConfirmWidget() {
    String tips = _isGroupOwner()
        ? 'Delete and remove all group members? ?'
        : 'Leave this group?';
    String content = _isGroupOwner() ? 'Delete and leave' : 'Leave';
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: Opacity(
            opacity: 1,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: Adapt.px(175),
              decoration: BoxDecoration(
                color: ThemeColor.color180,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: Adapt.px(8),
                    ),
                    child: Text(
                      tips,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: Adapt.px(14),
                        fontWeight: FontWeight.w400,
                        color: ThemeColor.color100,
                      ),
                    ),
                  ),
                  Divider(
                    height: Adapt.px(0.5),
                    color: ThemeColor.color160,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      OKEvent event = await Groups.sharedInstance.leaveGroup(
                          widget.groupId, 'Leave group chat success');
                      if (event.status) {
                        CommonToast.instance
                            .show(context, 'Leave group chat success');
                        OXNavigator.popToRoot(context);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: Adapt.px(17),
                      ),
                      child: Text(
                        content,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: Adapt.px(16),
                          fontWeight: FontWeight.w400,
                          color: ThemeColor.red,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: Adapt.px(8),
                    color: ThemeColor.color190,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      OXNavigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                        top: Adapt.px(17),
                      ),
                      width: double.infinity,
                      height: Adapt.px(80),
                      color: ThemeColor.color180,
                      child: Text(
                        Localized.text('ox_common.cancel'),
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 16, color: ThemeColor.color0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool _isGroupOwner() {
    UserDB? userInfo = OXUserInfoManager.sharedInstance.currentUserInfo;
    if (userInfo == null || groupDBInfo == null) return false;

    return userInfo.pubKey == groupDBInfo?.owner;
  }

  bool get _isGroupMember {
    UserDB? userInfo = OXUserInfoManager.sharedInstance.currentUserInfo;
    if (userInfo == null || groupMember.length == 0) return false;
    UserDB? userDB =
        groupMember.firstWhere((userDB) => userDB.pubKey == userInfo.pubKey);
    return userDB != null;
  }

  void _updateGroupNameFn() async {
    if (!_isGroupMember) return;

    bool? result = await OXNavigator.pushPage(
      context,
      (context) => GroupEditPage(
        pageType: EGroupEditType.groupName,
        groupId: widget.groupId,
      ),
    );

    if (result != null && result) _groupInfoInit();
  }

  void _updateGroupNoticeFn() async {
    if (!_isGroupMember) return;
    await OXNavigator.pushPage(
      context,
      (context) => GroupNoticePage(
        groupId: widget.groupId,
      ),
    );
    _groupInfoInit();
  }

  void _groupQrCodeFn() {
    if (!_isGroupMember) return _DisableShareDialog();
    OXNavigator.pushPage(
      context,
      (context) => GroupSettingQrcodePage(groupId: widget.groupId),
    );
  }

  void _DisableShareDialog() {
    OXCommonHintDialog.show(
      context,
      title: "",
      content:
          'This Group has enabled group-join verification. An invitation by a current group admin is required to join.',
      actionList: [
        OXCommonHintAction.sure(
          text: Localized.text('ox_common.confirm'),
          onTap: () => OXNavigator.pop(context),
        ),
      ],
      isRowAction: true,
    );
  }

  void _shareGroupFn() {
    if (!_isGroupMember) return _DisableShareDialog();
    OXNavigator.pushPage(
      context,
      (context) => GroupSharePage(
        groupId: widget.groupId,
      ),
    );
  }

  void _changeMuteFn(bool value) async {
    if (!_isGroupMember) {
      CommonToast.instance.show(context, 'Not group members cannot operate');
      return;
    }
    if (value) {
      await Groups.sharedInstance.muteGroup(widget.groupId);
      CommonToast.instance.show(context, 'Successful operation');
    } else {
      await Groups.sharedInstance.unMuteGroup(widget.groupId);
      CommonToast.instance.show(context, 'Successful operation');
    }
    setState(() {
      _isMute = value;
    });
  }

  void _groupMemberOptionFn(GroupListAction action) async{
    bool? result = await OXNavigator.presentPage(
      context,
      (context) => ContactGroupMemberPage(
        groupId: widget.groupId,
        groupListAction: action,
      ),
    );
    if(result != null && result) _groupInfoInit();
  }
}
