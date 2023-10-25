import 'package:flutter/material.dart';
import 'package:ox_chat/page/contacts/contact_group_list_page.dart';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_chat/utils/general_handler/chat_general_handler.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';

class ContactGroupMemberPage extends ContactGroupListPage {
  final String groupId;
  final String? title;
  final GroupListAction? groupListAction;

  const ContactGroupMemberPage({required this.groupId,this.title,this.groupListAction}) : super(title: title);

  @override
  _ContactGroupMemberState createState() => _ContactGroupMemberState();
}

class _ContactGroupMemberState extends ContactGroupListPageState {

  late final groupId;

  @override
  void initState() {
    super.initState();
    groupId = (widget as ContactGroupMemberPage).groupId;
    _fetchUserListAsync();
  }

  Future<void> _fetchUserListAsync() async {
    List<UserDB> users = await fetchUserList();
    setState(() {
      userList = users;
      super.groupedUser();
    });
  }

  Future<List<UserDB>> fetchUserList() async {
    List<UserDB> allGroupMembers = await Groups.sharedInstance.getAllGroupMembers(groupId);
    List<UserDB> allContacts = Contacts.sharedInstance.allContacts.values.toList();
    GroupDB? groupDB = Groups.sharedInstance.groups[groupId];
    String owner = '';
    if(groupDB != null) owner = groupDB.owner;
    switch (widget.groupListAction) {
      case GroupListAction.view:
        return allGroupMembers;
      case GroupListAction.add:
        for(int index =0;index <allGroupMembers.length;index ++){
          allContacts.removeWhere((element) => element.pubKey == allGroupMembers[index].pubKey);
        }
        return allContacts;
      case GroupListAction.remove:
        allGroupMembers.removeWhere((element) => element.pubKey == owner);
        return allGroupMembers;
      case GroupListAction.send:
        return allContacts;
      default:
        return [];
    }
  }

  @override
  String buildTitle() {
    final userCount = userList.length;
    final selectedUserCount = selectedUserList.length;
    if (widget.title == null) {
      switch (widget.groupListAction) {
        case GroupListAction.view:
          return '${Localized.text('ox_chat.group_member')} ${userCount > 0 ? '($userCount)' : ''}';
        case GroupListAction.add:
          return '${Localized.text('ox_chat.add_member_title')} ${selectedUserCount > 0 ? '($selectedUserCount)' : ''}';
        case GroupListAction.remove:
          return '${Localized.text('ox_chat.remove_member_title')} ${selectedUserCount > 0 ? '($selectedUserCount)' : ''}';
        case GroupListAction.send:
          return '${Localized.text('ox_chat.select_chat')}';
        default:
          return '';
      }
    }
    return widget.title!;
  }

  @override
  Widget build(BuildContext context) {
    if (userList.isEmpty) {
      return SizedBox(
          height: Adapt.px(24),
          width: Adapt.px(24),
          child: CircularProgressIndicator());
    }
    return super.build(context);
  }

  @override
  buildViewPressed() {
    OXNavigator.presentPage(context, (context) => ContactGroupMemberPage(groupId:groupId,groupListAction: GroupListAction.add,));
  }

  @override
  buildAddPressed() async {
    List<String> members = selectedUserList.map((user) => user.pubKey).toList();
    OKEvent okEvent = await Groups.sharedInstance.addGroupMembers(groupId, '${Localized.text('ox_chat.add_member_title')}', members);
    if(okEvent.status){
      await CommonToast.instance.show(context, Localized.text('ox_chat.add_member_success_tips'));
      OXNavigator.pop(context,true);
      return;
    }
    return CommonToast.instance.show(context, Localized.text('ox_chat.add_member_fail_tips'));
  }

  @override
  buildRemovePressed() async {
    List<String> members = selectedUserList.map((user) => user.pubKey).toList();
    OKEvent okEvent = await Groups.sharedInstance.removeGroupMembers(groupId, '${Localized.text('remove_member_title')}', members);
    if(okEvent.status){
      await CommonToast.instance.show(context, Localized.text('ox_chat.remove_member_success_tips'));
      OXNavigator.pop(context,true);
      return;
    }
    return CommonToast.instance.show(context, Localized.text('ox_chat.remove_member_fail_tips'));
  }

  @override
  buildSendPressed() {
    GroupDB? groupDB = Groups.sharedInstance.groups[groupId];
    final groupName = groupDB?.name;
    final invited = OXUserInfoManager.sharedInstance.currentUserInfo?.name ?? OXUserInfoManager.sharedInstance.currentUserInfo?.nickName ?? '';
    OXCommonHintDialog.show(context,
        title: Localized.text('ox_common.tips'),
        content: Localized.text('ox_chat.group_share_tips'),
        actionList: [
          OXCommonHintAction.cancel(onTap: () {
            OXNavigator.pop(context, false);
          }),
          OXCommonHintAction.sure(
              text: Localized.text('ox_common.confirm'),
              onTap: () async {
                OXNavigator.pop(context, true);
                selectedUserList.forEach((element) {
                  ChatMessageSendEx.sendTemplatePrivateMessage(
                      receiverPubkey: element.pubKey,
                      icon: 'icon_group_default.png',
                      title: 'Group Chat Invitation',
                      subTitle: '${invited} invited you to join this Group "${groupName}"');
                });
                OXNavigator.pop(context, true);
              }),
        ],
        isRowAction: true);
  }
}
