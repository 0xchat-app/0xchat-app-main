import 'package:flutter/material.dart';
import 'package:ox_chat/model/option_model.dart';
import 'package:ox_chat/page/contacts/contact_channel_create.dart';
import 'package:ox_chat/page/contacts/contact_group_chat_choose_page.dart';
import 'package:ox_chat/page/contacts/contact_group_list_page.dart';
import 'package:ox_chat/page/contacts/contact_qrcode_add_friend.dart';
import 'package:ox_chat/page/contacts/groups/relay_group_create_page.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_chat/widget/group_create_selector_dialog.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/scan_utils.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_scan_page.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:chatcore/chat-core.dart';
import 'package:permission_handler/permission_handler.dart';

class CommunityMenuOptionModel {
  OptionModel optionModel;
  String content;
  String iconName;

  CommunityMenuOptionModel({
    this.optionModel = OptionModel.AddFriend,
    this.content = '',
    this.iconName = '',
  });

  static List<CommunityMenuOptionModel> getOptionModelList({String whitelistLevel = '0'}) {
    List<CommunityMenuOptionModel> list = [];
    list.add(
      CommunityMenuOptionModel(
        content: Localized.text('ox_common.str_scan'),
        iconName: 'icon_scan_qr.png',
        optionModel: OptionModel.ScanQCode,
      ),
    );
    list.add(
      CommunityMenuOptionModel(
        content: Localized.text('ox_chat.str_new_group'),
        iconName: 'icon_new_group.png',
        optionModel: OptionModel.AddGroup,
      ),
    );
    list.add(
      CommunityMenuOptionModel(
        content: Localized.text('ox_common.str_add_friend'),
        iconName: 'icon_new_friend.png',
        optionModel: OptionModel.AddFriend,
      ),
    );
    // list.add(
    //   CommunityMenuOptionModel(
    //     content: Localized.text('ox_common.str_new_channel'),
    //     iconName: 'icon_new_channel.png',
    //     optionModel: OptionModel.NewChannel,
    //   ),
    // );
    return list;
  }

  static void optionsOnTap(BuildContext context, OptionModel optionModel) async {
    bool isLogin = OXUserInfoManager.sharedInstance.isLogin;
    if (isLogin == false) {
      await _navigateToLoginPage(context);
      return;
    }
    if (optionModel == OptionModel.AddFriend) {
      gotoAddFriend(context);
    // } else if (optionModel == OptionModel.NewChannel) {
    //   OXNavigator.pushPage(context, (context) => ChatChannelCreate());
    } else if (optionModel == OptionModel.ScanQCode) {
      gotoScan(context);
    } else if (optionModel == OptionModel.RecommenderTools) {
      CommonToast.instance.show(context, 'str_stay_tuned'.localized());
    } else if (optionModel == OptionModel.AddGroup) {
      createGroupBottomDialog(context);
    }
  }

  static _navigateToLoginPage(BuildContext context) async {
    await OXModuleService.pushPage(
      context,
      "ox_login",
      "LoginPage",
      {},
    );
  }

  static void gotoAddFriend(BuildContext context) {
    bool isLogin = OXUserInfoManager.sharedInstance.isLogin;
    if (!isLogin) {
      _navigateToLoginPage(context);
      return;
    }
    OXNavigator.pushPage(context, (context) => CommunityQrcodeAddFriend());
  }

  static void _createGroup(BuildContext context, GroupType groupType) {
    final height = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    List<UserDBISAR> userList = Contacts.sharedInstance.allContacts.values.toList();
    switch(groupType){
      case GroupType.channel:
        OXNavigator.pushPage(context, (context) => ChatChannelCreate());
        break;
      case GroupType.privateGroup:
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) =>
              Container(
                height: height,
                child: ContactGroupChatChoosePage(
                  groupType: groupType,
                  userList: userList,
                  groupListAction: GroupListAction.create,
                  searchBarHintText: Localized.text('ox_chat.create_group_search_hint_text'),
                ),
              ),
        );
        break;
      case GroupType.openGroup:
      case GroupType.closeGroup:
        OXNavigator.pushPage(context, (context) => RelayGroupCreatePage(groupType: groupType));
        break;
    }
  }

  static void createGroupBottomDialog(BuildContext context) async {
    var result = await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return GroupCreateSelectorDialog(titleTxT: 'str_group_create_hint'.localized());
      },
    );
    if (result != null && result is GroupType) {
      _createGroup(context, result);
    }
  }

  static void gotoScan(BuildContext context) async {
    if (await Permission.camera.request().isGranted) {
      String? result = await OXNavigator.pushPage(context, (context) => CommonScanPage());
      if (result != null) {
        ScanUtils.analysis(context, result);
      }
    } else {
      OXCommonHintDialog.show(context, content: Localized.text('ox_chat.str_permission_camera_hint'), actionList: [
        OXCommonHintAction(
            text: () => Localized.text('ox_chat.str_go_to_settings'),
            onTap: () {
              openAppSettings();
              OXNavigator.pop(context);
            }),
      ]);
    }
  }
}
