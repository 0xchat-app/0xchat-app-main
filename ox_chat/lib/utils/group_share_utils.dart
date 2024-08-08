import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_chat/model/option_model.dart';
import 'package:ox_chat/page/contacts/contact_group_list_page.dart';
import 'package:ox_chat/page/contacts/contact_group_member_page.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_chat/widget/group_share_menu_dialog.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/took_kit.dart';

///Title: group_share_utils
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/7/16 15:46
class GroupShareUtils{

  static void shareGroup(BuildContext context, String groupId, GroupType groupType) async {
    if (groupType == GroupType.openGroup || groupType == GroupType.closeGroup) {
      String? groupNevent = RelayGroup.sharedInstance.encodeGroup(groupId);
      var result = await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return GroupShareMenuDialog(titleTxT: '');
        },
      );
      if (result != null && result is GroupMenuType) {
        if (result == GroupMenuType.copy) {
          TookKit.copyKey(context, groupNevent ??'');
        } else if (result == GroupMenuType.share){
          OXNavigator.presentPage(
            context,
                (context) => ContactGroupMemberPage(
              groupId: groupId,
              groupListAction: GroupListAction.send,
              groupType: groupType,
            ),
          );
        }
      }
    } else {
      OXNavigator.presentPage(
        context,
            (context) => ContactGroupMemberPage(
          groupId: groupId,
          groupListAction: GroupListAction.send,
        ),);
    }
  }
}