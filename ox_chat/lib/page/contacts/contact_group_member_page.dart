import 'package:flutter/material.dart';
import 'package:ox_chat/page/contacts/contact_group_list_page.dart';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/widgets/common_toast.dart';

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
    });
  }

  Future<List<UserDB>> fetchUserList() async {
    List<UserDB> allGroupMembers = await Groups.sharedInstance.getAllGroupMembers(groupId);
    GroupDB? groupDB = Groups.sharedInstance.groups[groupId];
    String owner = '';
    if(groupDB != null) owner = groupDB.owner;
    switch (widget.groupListAction) {
      case GroupListAction.view:
        return allGroupMembers;
      case GroupListAction.add:
        List<UserDB> allContacts = Contacts.sharedInstance.allContacts.values.toList();
        for(int index =0;index <allGroupMembers.length;index ++){
          allContacts.removeWhere((element) => element.pubKey == allGroupMembers[index].pubKey);
        }
        return allContacts;
      case GroupListAction.remove:
        allGroupMembers.removeWhere((element) => element.pubKey == owner);
        return allGroupMembers;
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
          return 'Members ${userCount > 0 ? '($userCount)' : ''}';
        case GroupListAction.add:
          return 'Add members ${selectedUserCount > 0 ? '($selectedUserCount)' : ''}';
        case GroupListAction.remove:
          return 'Remove members ${selectedUserCount > 0 ? '($selectedUserCount)' : ''}';
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
    super.groupedUser();
    return super.build(context);
  }

  @override
  buildViewPressed() {
    OXNavigator.presentPage(context, (context) => ContactGroupMemberPage(groupId:groupId,groupListAction: GroupListAction.add,));
  }

  @override
  buildAddPressed() async {
    List<String> members = selectedUserList.map((user) => user.pubKey).toList();
    OKEvent okEvent = await Groups.sharedInstance.addGroupMembers(groupId, '添加成员', members);
    if(okEvent.status){
      await CommonToast.instance.show(context, 'add success');
      OXNavigator.pop(context,true);
      return;
    }
    return CommonToast.instance.show(context, 'add failed');
  }

  @override
  buildRemovePressed() async {
    List<String> members = selectedUserList.map((user) => user.pubKey).toList();
    OKEvent okEvent = await Groups.sharedInstance.removeGroupMembers(groupId, '移除群聊', members);
    if(okEvent.status){
      await CommonToast.instance.show(context, 'remove success');
      OXNavigator.pop(context,true);
      return;
    }
    return CommonToast.instance.show(context, 'remove failed');
  }
}
