import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_chat/model/option_model.dart';
import 'package:ox_chat/page/contacts/groups/relay_group_base_info_page.dart';
import 'package:ox_chat/page/contacts/groups/relay_group_manage_page.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../../../manager/chat_data_cache.dart';
import '../contact_group_list_page.dart';
import '../contact_group_member_page.dart';
import 'group_edit_page.dart';
import 'group_join_requests.dart';
import 'group_notice_page.dart';
import 'group_setting_qrcode_page.dart';

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
    _loadDataFromRelay();
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
        padding: EdgeInsets.zero,
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 12.px,
          ),
          child: Column(
            children: [
              _groupBaseInfoView(),
              _optionMemberWidget(),
              _groupTypeView(),
              _groupNotesView(),
              _muteWidget(),
              _groupHistoryView(),
              _leaveBtnWidget(),
              SizedBox(height: 50.px),
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
    return RelayGroupBaseInfoView(
      relayGroup: groupDBInfo,
      groupQrCodeFn: _groupQrCodeFn,
    );
  }

  Widget _optionMemberWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(16)),
        color: ThemeColor.color180,
      ),
      margin: EdgeInsets.only(top: 16.px),
      padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 12.px),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _groupMemberOptionFn(GroupListAction.view),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          SizedBox(height: 8.px),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _memberAvatarWidget(),
              _addOrDelMember(),
            ],
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
        size: 40.px,
        useTheme: true,
      ),
    );
  }

  Widget _removeMemberBtnWidget() {
    if (!_isGroupManager) return SizedBox();
    return GestureDetector(
      onTap: () => _groupMemberOptionFn(GroupListAction.remove),
      child: Container(
        margin: EdgeInsets.only(left: 12.px),
        child: CommonImage(
          iconName: 'del_circle_icon.png',
          size: 40.px,
          useTheme: true,
        ),
      ),
    );
  }

  Widget _groupTypeView() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(16)),
        color: ThemeColor.color180,
      ),
      margin: EdgeInsets.only(top: 16.px),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GroupItemBuild(
            title: Localized.text('ox_chat.str_group_type'),
            subTitle: groupDBInfo != null
                ? (groupDBInfo!.private ? GroupType.closeGroup.text : GroupType.openGroup.text)
                : '--',
            subTitleIcon: groupDBInfo != null
                ? (groupDBInfo!.private ? GroupType.closeGroup.typeIcon : GroupType.openGroup.typeIcon)
                : null,
            onTap: _updateGroupTypeFn,
            isShowMoreIcon: _isGroupMember,
          ),
          GroupItemBuild(
            title: Localized.text('ox_chat.str_group_relay'),
            subTitle: groupDBInfo?.relay ?? '--',
            onTap: null,
            isShowMoreIcon: _isGroupMember,
          ),
          GroupItemBuild(
            title: Localized.text('ox_chat.str_group_manage'),
            onTap: _manageGroupNoticeFn,
            isShowMoreIcon: true,
            isShowDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _groupNotesView(){
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.px),
          color: ThemeColor.color180,
        ),
        margin: EdgeInsets.only(top: 16.px),
        child: Column(
          children: [
            GroupItemBuild(
              title: Localized.text('ox_chat.str_group_notes'),
              onTap: _gotoGroupNotesFn,
              isShowMoreIcon: true,
              isShowDivider: false,
            ),
          ],
        ),
    );
  }
  Widget _groupHistoryView() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(16)),
        color: ThemeColor.color180,
      ),
      margin: EdgeInsets.only(top: 16.px),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GroupItemBuild(
            title: Localized.text('ox_chat.str_group_search_chat_history'),
            onTap: _searchChatHistoryFn,
            isShowMoreIcon: true,
          ),
          GroupItemBuild(
            title: Localized.text('ox_chat.str_group_clear_chat_history'),
            onTap: _clearChatHistoryFn,
            isShowMoreIcon: true,
            isShowDivider: false,
          ),
          // GroupItemBuild(
          //   title: Localized.text('ox_chat.str_group_report'),
          //   subTitle: groupDBInfo?.groupId ?? '--',
          //   onTap: _reportFn,
          //   isShowMoreIcon: _isGroupMember,
          // ),
          // GroupItemBuild(
          //   title: Localized.text('ox_chat.group_notice'),
          //   titleDes: _getGroupNotice,
          //   onTap: _updateGroupNoticeFn,
          //   isShowMoreIcon: _isGroupMember,
          // ),
        ],
      ),
    );
  }

  void _searchChatHistoryFn() async {

  }

  void _clearChatHistoryFn() async {

  }

  void _reportFn() async {

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
      margin: EdgeInsets.only(top: 16.px),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(16)),
        color: ThemeColor.color180,
      ),
      child: Column(
        children: [
          ///Remark
          ///Alias
          GroupItemBuild(
            title: Localized.text('ox_chat.mute_item'),
            isShowDivider: false,
            actionWidget: _muteSwitchWidget(),
            isShowMoreIcon: false,
          ),
        ],
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

  Widget _leaveBtnWidget() {
    if (!_isGroupMember) return SizedBox();
    String content = _isGroupManager ? Localized.text('ox_chat.delete_and_leave_item') : Localized.text('ox_chat.str_leave_group');
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(top: 16.px),
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

  void _manageGroupNoticeFn() async {
    if (!_isGroupManager) return;
    await OXNavigator.pushPage(
      context,
          (context) => RelayGroupManagePage(
        relayGroupDB: groupDBInfo!,
      ),
    );
    _groupInfoInit();
  }

  void _gotoGroupNotesFn() async {
   await OXModuleService.pushPage(
      context,
      'ox_discovery',
      'GroupMomentsPage',
      {
        'groupId': widget.groupId,
      },
    );
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
    bool? result = await OXNavigator.presentPage(
      context,
      (context) => ContactGroupMemberPage(
        groupId: widget.groupId,
        groupListAction: action,
        groupType: groupDBInfo != null ? (groupDBInfo!.private ? GroupType.closeGroup : GroupType.openGroup) : null,
      ),
    );
    if (result != null && result) _groupInfoInit();
  }

  void _leaveGroupFn() async {
    if (requestTag) {
      _changeRequestTagStatus(false);
      OXLoading.show();
      OKEvent event = await RelayGroup.sharedInstance.leaveGroup(widget.groupId);
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
    if (groupDB != null) {
      groupDBInfo = groupDB;
      _getIsGroupManagerValue(groupDB.admins);
      _loadMembers(groupDB);
      setState(() {});
    }
  }

  void _getIsGroupManagerValue(List<GroupAdmin>? tempAdmins){
    UserDB? userInfo = OXUserInfoManager.sharedInstance.currentUserInfo;
    List<GroupAdmin>? admins = tempAdmins ?? null;
    if (userInfo == null) {
      _isGroupManager = false;
    } else {
      if (groupDBInfo?.author == userInfo.pubKey) {
        _isGroupManager = true;
      } else {
        if (admins == null || admins.isEmpty) {
          _isGroupManager = false;
        } else {
          for (GroupAdmin amin in admins) {
            if (userInfo.pubKey == amin.pubkey) {
              _isGroupManager = true;
            }
          }
        }
      }
    }
  }

  void _getIsGroupMemberValue(List<UserDB> memberUserDBs) {
    UserDB? userInfo = OXUserInfoManager.sharedInstance.currentUserInfo;
    if (userInfo == null) {
      _isGroupMember = false;
    } else {
      _isGroupMember = memberUserDBs.any((userDB) => userDB.pubKey == userInfo.pubKey);
    }
  }

  void _loadMembers(RelayGroupDB groupDB) async {
    List<UserDB> localMembers = await RelayGroup.sharedInstance.getGroupMembersFromLocal(widget.groupId);
    if (localMembers.isNotEmpty) {
      _getIsGroupMemberValue(localMembers);
    }
    setState(() {});
  }

  void _loadDataFromRelay() async {
    RelayGroup.sharedInstance.getGroupMetadataFromRelay(widget.groupId).then((relayGroupDB) {
      if (!mounted) return ;
      if (relayGroupDB != null) {
        setState(() {
          groupDBInfo = relayGroupDB;
        });
      }
    });
    RelayGroup.sharedInstance.getGroupAdminsFromRelay(widget.groupId).then((groupAdmins){
      if (groupAdmins != null && groupAdmins.isNotEmpty) {
        _getIsGroupManagerValue(groupAdmins);
      }
    });
    RelayGroup.sharedInstance.getGroupMembersFromRelay(widget.groupId).then((memberUsers){
      if (memberUsers != null && memberUsers.isNotEmpty) {
        _getIsGroupMemberValue(memberUsers);
      }
    });
  }
}
