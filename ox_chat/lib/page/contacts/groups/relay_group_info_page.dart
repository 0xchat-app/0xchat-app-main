import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:flutter/material.dart';
import 'package:ox_chat/model/option_model.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_common/business_interface/ox_chat/interface.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_network_image.dart';
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

class RelayGroupInfoPage extends StatefulWidget {
  final String groupId;

  RelayGroupInfoPage({Key? key, required this.groupId}) : super(key: key);

  @override
  _RelayGroupInfoPageState createState() => new _RelayGroupInfoPageState();
}

class _RelayGroupInfoPageState extends State<RelayGroupInfoPage> {
  bool _isMute = false;
  List<UserDB> groupMember = [];
  RelayGroupDB? groupDBInfo = null;
  bool requestTag = true;
  bool _isGroupManager = false;
  bool _isGroupMember = false;

  @override
  void initState() {
    super.initState();
    _groupInfoInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String get _getGroupNotice {
    String groupNotice = '';
    List<String>? pinned = groupDBInfo?.pinned;
    if (pinned != null && pinned.length > 0) {
      groupNotice = pinned[0];
    }
    return groupNotice.isEmpty ? Localized.text('ox_chat.group_notice_default_hint') : groupNotice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        useLargeTitle: false,
        centerTitle: true,
        title: Localized.text('ox_chat.group_info'),
        backgroundColor: ThemeColor.color190,
        actions: [
          _appBarActionWidget(),
          SizedBox(width: 24.px),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 24.px,
          ),
          child: Column(
            children: [
              _groupBaseInfoView(),
              _optionMemberWidget(),
              _groupBaseOptionView(),
              _muteWidget(),
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
      child: Container(
        child: CommonImage(
          iconName: 'share_icon.png',
          width: Adapt.px(20),
          height: Adapt.px(20),
          useTheme: true,
        ),
      ),
    );
  }

  Widget _groupBaseInfoView() {
    return Container(
      width: double.infinity,
      height: 80.px,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(16)),
        color: ThemeColor.color180,
      ),
      child: Row(
        children: [
          OXRelayGroupAvatar(
            relayGroup: groupDBInfo,
            size: 56.px,
          ),
          
        ],
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
                      Localized.text('ox_chat.view_all_members').replaceAll(r'${count}', '${groupMember.length}'),
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
    int groupMemberNum = groupMember.length;
    if (groupMemberNum == 0) return Container();
    int renderCount = groupMemberNum > 8 ? 8 : groupMemberNum;
    return Container(
      margin: EdgeInsets.only(
        right: Adapt.px(0),
      ),
      constraints: BoxConstraints(
          maxWidth: Adapt.px(24 * renderCount + 24), minWidth: Adapt.px(48)),
      child: AvatarStack(
        settings: RestrictedPositions(
            // maxCoverage: 0.1,
            // minCoverage: 0.2,
            align: StackAlign.left,
            laying: StackLaying.first),
        borderColor: ThemeColor.color180,
        height: Adapt.px(48),
        avatars: _showMemberAvatarWidget(renderCount),
      ),
    );
  }

  List<ImageProvider<Object>> _showMemberAvatarWidget(int renderCount) {
    List<ImageProvider<Object>> avatarList = [];
    for (var n = 0; n < renderCount; n++) {
      String? groupPic = groupMember[n].picture;
      if (groupPic != null && groupPic.isNotEmpty) {
        avatarList.add(OXCachedNetworkImageProviderEx.create(
          context,
          groupPic,
          // height: Adapt.px(26),
        ));
      } else {
        avatarList.add(
            AssetImage('assets/images/user_image.png', package: 'ox_common'));
      }
      // CachedNetworkImageProvider()
    }
    return avatarList;
  }

  Widget _addOrDelMember() {
    return Container(
      child: Row(
        children: [
          _addMemberBtnWidget(),
          _removeMemberBtnWidget(),
        ],
      ),
    );
  }

  Widget _addMemberBtnWidget() {
    return GestureDetector(
      onTap: () => _groupMemberOptionFn(GroupListAction.add),
      child: CommonImage(
        iconName: 'add_circle_icon.png',
        width: Adapt.px(48),
        height: Adapt.px(48),
        useTheme: true,
      ),
    );
  }

  Widget _removeMemberBtnWidget() {
    if (!_isGroupManager) return Container();
    return GestureDetector(
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
            title: Localized.text('ox_chat.group_name'),
            subTitle: groupDBInfo?.name ?? '--',
            onTap: _updateGroupNameFn,
            isShowMoreIcon: _isGroupMember,
          ),
          _topItemBuild(
            title: Localized.text('ox_chat.str_group_type'),
            subTitle: groupDBInfo != null ? (groupDBInfo!.private ? GroupType.closeGroup.text: GroupType.openGroup.text) : '--',
            subTitleIcon : groupDBInfo != null ? (groupDBInfo!.private ? GroupType.closeGroup.typeIcon: GroupType.openGroup.typeIcon) : null,
            onTap: _updateGroupTypeFn,
            isShowMoreIcon: _isGroupMember,
          ),
          _topItemBuild(
            title: Localized.text('ox_chat.str_group_relay'),
            subTitle: groupDBInfo?.relay ?? '--',
            onTap: null,
            isShowMoreIcon: _isGroupMember,
          ),
          _topItemBuild(
            title: Localized.text('ox_chat.str_group_ID'),
            subTitle: groupDBInfo?.groupId ?? '--',
            onTap: null,
            isShowMoreIcon: _isGroupMember,
          ),
          _topItemBuild(
            title: Localized.text('ox_chat.group_member'),
            subTitle: groupMember.length.toString(),
            onTap: () => _groupMemberOptionFn(GroupListAction.view),
            isShowMoreIcon: _isGroupMember,
          ),
          _topItemBuild(
            title: Localized.text('ox_chat.group_qr_code'),
            actionWidget: CommonImage(
              iconName: 'qrcode_icon.png',
              width: Adapt.px(24),
              height: Adapt.px(24),
              useTheme: true,
            ),
            onTap: _groupQrCodeFn,
          ),
          _topItemBuild(
            title: Localized.text('ox_chat.group_notice'),
            titleDes: _getGroupNotice,
            onTap: _updateGroupNoticeFn,
            isShowMoreIcon: _isGroupMember,
          ),
          _topItemBuild(
            title: Localized.text('ox_chat.join_request'),
            onTap: _jumpJoinRequestFn,
            isShowMoreIcon: _isGroupManager,
            isShowDivider: false,
          ),
        ],
      ),
    );
  }

  void _jumpJoinRequestFn() {
    if (!_isGroupManager) return;
    OXNavigator.pushPage(
      context,
      (context) => GroupJoinRequests(groupId: groupDBInfo?.groupId ?? ''),
    );
  }

  Widget _muteWidget() {
    return Container(
      margin: EdgeInsets.only(
        top: Adapt.px(16),
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(16)),
        color: ThemeColor.color180,
      ),
      child: _topItemBuild(
        title: Localized.text('ox_chat.mute_item'),
        isShowDivider: false,
        actionWidget: _muteSwitchWidget(),
        isShowMoreIcon: false,
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
    String? subTitleIcon,
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
                          : SizedBox(),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      actionWidget != null ? actionWidget : SizedBox(),
                      subTitle != null
                          ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if(subTitleIcon != null) CommonImage(iconName: subTitleIcon, size: 24.px, package: OXChatInterface.moduleName),
                          MyText(subTitle, 14.sp,ThemeColor.color100,fontWeight: FontWeight.w400)
                        ],
                      )
                          : SizedBox(),
                      isShowMoreIcon
                          ? CommonImage(
                              iconName: 'icon_arrow_more.png',
                              width: Adapt.px(24),
                              height: Adapt.px(24),
                            )
                          : SizedBox(),
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
    String content = _isGroupManager ? Localized.text('ox_chat.delete_and_leave_item') : Localized.text('ox_chat.str_leave_group');
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
    String tips = _isGroupManager
        ? Localized.text('ox_chat.delete_group_tips')
        : Localized.text('ox_chat.leave_group_tips');
    String content = _isGroupManager ? Localized.text('ox_chat.delete_and_leave_item') : Localized.text('ox_chat.str_leave_group');
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
                    onTap: _isGroupManager ? _disbandGroupFn : _leaveGroupFn,
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

  void _updateGroupTypeFn() async {

  }

  void _updateGroupNoticeFn() async {
    if (!_isGroupManager) return;
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
      content: Localized.text('ox_chat.enabled_group_join_verification'),
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
    OXNavigator.presentPage(
      context,
      (context) => ContactGroupMemberPage(
        groupId: widget.groupId,
        groupListAction: GroupListAction.send,
      ),
    );
  }

  void _changeMuteFn(bool value) async {
    if (!_isGroupMember) {
      CommonToast.instance.show(context, Localized.text('ox_chat.group_mute_no_member_toast'));
      return;
    }
    if (value) {
      await Groups.sharedInstance.muteGroup(widget.groupId);
      CommonToast.instance.show(context, Localized.text('ox_chat.group_mute_operate_success_toast'));
    } else {
      await Groups.sharedInstance.unMuteGroup(widget.groupId);
      CommonToast.instance.show(context, Localized.text('ox_chat.group_mute_operate_success_toast'));
    }
    setState(() {
      _isMute = value;
    });
  }

  void _groupMemberOptionFn(GroupListAction action) async {
    if (!_isGroupMember) return;
    if (GroupListAction.add == action && !_isGroupManager) return _shareGroupFn();
    bool? result = await OXNavigator.presentPage(
      context,
      (context) => ContactGroupMemberPage(
        groupId: widget.groupId,
        groupListAction: action,
      ),
    );
    if (result != null && result) _groupInfoInit();
  }

  void _leaveGroupFn() async {
    if (requestTag) {
      _changeRequestTagStatus(false);
      OXLoading.show();
      UserDB? userInfo = OXUserInfoManager.sharedInstance.currentUserInfo;
      OKEvent event = await Groups.sharedInstance
          .leaveGroup(widget.groupId, Localized.text('ox_chat.leave_group_system_message').replaceAll(r'${name}', '${userInfo?.name}'));

      if (!event.status) {
        _changeRequestTagStatus(true);
        CommonToast.instance.show(context, event.message);
        OXLoading.dismiss();
        return;
      }

      OXLoading.dismiss();
      CommonToast.instance.show(context, Localized.text('ox_chat.leave_group_success_toast'));
      OXNavigator.popToRoot(context);
    }
  }

  void _disbandGroupFn() async {
    if (requestTag) {
      _changeRequestTagStatus(false);
      OXLoading.show();
      OKEvent event = await Groups.sharedInstance
          .deleteAndLeave(widget.groupId, Localized.text('ox_chat.disband_group_toast'));

      if (!event.status) {
        _changeRequestTagStatus(true);
        CommonToast.instance.show(context, event.message);
        OXLoading.dismiss();
        return;
      }

      OXLoading.dismiss();
      CommonToast.instance.show(context, Localized.text('ox_chat.disband_group_toast'));
      OXNavigator.popToRoot(context);
    }
  }

  void _changeRequestTagStatus(bool status) {
    setState(() {
      requestTag = status;
    });
  }

  void _groupInfoInit() async {
    String groupId = widget.groupId;
    RelayGroupDB? groupDB = await RelayGroup.sharedInstance.myGroups[groupId];
    List<UserDB>? groupList =
        await Groups.sharedInstance.getAllGroupMembers(groupId);

    if (groupDB != null) {
      UserDB? userInfo = OXUserInfoManager.sharedInstance.currentUserInfo;
      if (userInfo == null || groupMember.length == 0) {
        _isGroupMember = false;
      } else {
        _isGroupMember = groupMember.any((userDB) => userDB.pubKey == userInfo.pubKey);
      }
      List<GroupAdmin>? admins = groupDB?.admins ?? null;
      if (userInfo == null || groupDB == null || admins == null || admins.length > 0) {
        _isGroupManager = false;
      } else {
        for (GroupAdmin amin in admins) {
          if (userInfo.pubKey == amin.pubkey) {
            _isGroupManager = true;
          }
        }
      }
      groupDBInfo = groupDB;
      groupMember = groupList;
      setState(() {});
    }
  }
}
