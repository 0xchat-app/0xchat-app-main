import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_chat/model/option_model.dart';
import 'package:ox_chat/page/contacts/contact_group_list_page.dart';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_chat/utils/chat_send_invited_template_helper.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';

import '../session/chat_group_message_page.dart';

class ContactGroupMemberPage extends ContactGroupListPage {
  final String groupId;
  final String? title;
  final GroupListAction? groupListAction;

  const ContactGroupMemberPage({
    required this.groupId,
    this.title,
    this.groupListAction,
    super.groupType,
  }) : super(title: title);

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
    List<UserDBISAR> users = await fetchUserList();
    setState(() {
      userList = users;
      super.groupedUser();
    });
  }

  Future<List<UserDBISAR>> fetchUserList() async {
    List<UserDBISAR> allGroupMembers = widget.groupType ==null || widget.groupType == GroupType.privateGroup ? await Groups.sharedInstance.getAllGroupMembers(groupId)
      : await RelayGroup.sharedInstance.getGroupMembersFromLocal(groupId);
    List<UserDBISAR> allContacts = Contacts.sharedInstance.allContacts.values.toList();
    String owner = '';
    if (widget.groupType ==null || widget.groupType == GroupType.privateGroup) {
      GroupDBISAR? groupDB = Groups.sharedInstance.groups[groupId];
      if (groupDB != null) owner = groupDB.owner;
    } else {
      RelayGroupDBISAR? groupDB = RelayGroup.sharedInstance.groups[groupId];
      if (groupDB != null) owner = groupDB.author;
    }
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
    return super.build(context);
  }

  @override
  buildViewPressed() {
    OXNavigator.presentPage(context, (context) => ContactGroupMemberPage(groupId:groupId,groupListAction: GroupListAction.add,));
  }

  @override
  buildAddPressed() async {
    if(userList.isEmpty){
      CommonToast.instance.show(context, Localized.text('ox_chat.create_group_select_toast'));
      return;
    }
    await OXLoading.show();
    List<String> members = selectedUserList.map((user) => user.pubKey).toList();
    OKEvent? okEvent;
    if (widget.groupType == GroupType.privateGroup) {
      await OXLoading.show();
      GroupDBISAR? groupDB = await Groups.sharedInstance
          .addMembersToPrivateGroup(groupId, members);
      await OXLoading.dismiss();
      _createGroup(groupDB);
      return;
    } else {
      okEvent = await RelayGroup.sharedInstance.addUser(groupId, List.from(members), '');
    }
    await OXLoading.dismiss();
    if(okEvent.status){
      await CommonToast.instance.show(context, Localized.text('ox_chat.add_member_success_tips'));
      OXNavigator.pop(context,true);
      ChatSendInvitedTemplateHelper.sendGroupInvitedTemplate(selectedUserList,groupId, widget.groupType ?? GroupType.openGroup);
      return;
    } else {
      CommonToast.instance.show(context, okEvent.message);
    }
  }

  @override
  buildRemovePressed() async {
    await OXLoading.show();
    List<String> members = selectedUserList.map((user) => user.pubKey).toList();
    OKEvent? okEvent;
    if (widget.groupType == GroupType.privateGroup) {
      await OXLoading.show();
      GroupDBISAR? groupDB = await Groups.sharedInstance
          .removeMembersFromPrivateGroup(groupId, members);
      await OXLoading.dismiss();
      _createGroup(groupDB);
      return;
    } else {
      okEvent = await RelayGroup.sharedInstance.removeUser(groupId, List.from(members), '');
    }
    await OXLoading.dismiss();
    if(okEvent.status){
      await CommonToast.instance.show(context, Localized.text('ox_chat.remove_member_success_tips'));
      OXNavigator.pop(context,true);
      return;
    } else {
      CommonToast.instance.show(context, okEvent.message);
    }
  }

  @override
  buildSendPressed() {
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
                ChatSendInvitedTemplateHelper.sendGroupInvitedTemplate(selectedUserList,groupId, widget.groupType ?? GroupType.openGroup);
                OXNavigator.pop(context, true);
              }),
        ],
        isRowAction: true);
  }

  Future<void> _createGroup(GroupDBISAR? groupDB) async {
    if (groupDB != null) {
      OXNavigator.pop(context);
      OXNavigator.pushReplacement(
        context,
        ChatGroupMessagePage(
          communityItem: ChatSessionModelISAR(
            chatId: groupDB.groupId,
            groupId: groupDB.groupId,
            chatType: ChatType.chatGroup,
            chatName: groupDB.name,
            createTime: groupDB.updateTime,
            avatar: groupDB.picture,
          ),
        ),
      );
    } else {
      CommonToast.instance.show(context, Localized.text('ox_chat.create_group_fail_tips'));
    }
  }
}
