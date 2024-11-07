import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ox_chat/page/contacts/contact_create_secret_chat.dart';
import 'package:ox_chat/page/session/chat_message_page.dart';
import 'package:ox_chat/utils/chat_session_utils.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_common/business_interface/ox_chat/call_message_type.dart';
import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';

///Title: contact_longpress_menu_dialog
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2024
///@author Michael
///CreateTime: 2024/10/25 15:04
class ContactLongPressMenuDialog extends StatefulWidget{
  final ChatSessionModelISAR communityItem;
  ContactLongPressMenuDialog({required this.communityItem});

  static showDialog({
    required BuildContext context,
    required ChatSessionModelISAR communityItem,
    required Widget pageWidget,
    bool isPushWithReplace = false,
    bool isLongPressShow = false,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.transparent,
      routeSettings: OXRouteSettings(isShortLived: true),
      transitionBuilder: (context, animation1, animation2, child) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            OXNavigator.pop(context);
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
              ),
              ScaleTransition(
                scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation1,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(
                      left: 20.px,
                      right: 20.px,
                      bottom: 44.px),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: Adapt.screenH * 0.6,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.px),
                          child: pageWidget,
                        ),
                      ),
                      SizedBox(height: 8.px),
                      ContactLongPressMenuDialog(communityItem: communityItem),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (context, animation1, animation2) => Container(),
    );
  }

  @override
  State<StatefulWidget> createState() {
    return _ContactLongPressMenuDialogState();
  }

}

class _ContactLongPressMenuDialogState extends State<ContactLongPressMenuDialog>{
  late List<CLongPressOptionType> _menulist = [];

  @override
  void initState() {
    super.initState();
    _menulist = CLongPressOptionTypeEx.getOptionModelList(widget.communityItem);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180.px,
      alignment: Alignment.bottomRight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.px),
        color: ThemeColor.color180.withOpacity(0.72),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _menulist.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          CLongPressOptionType optionType = _menulist[index];
          String showItemName = CLongPressOptionTypeEx.getOptionName(widget.communityItem, optionType);
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              CLongPressOptionTypeEx.optionsOnTap(context, optionType, widget.communityItem);
            },
            child: Container(
              height: 40.px,
              padding: EdgeInsets.symmetric(horizontal: 16.px),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    showItemName,
                    style: TextStyle(
                      fontSize: 14.px,
                      color: optionType == CLongPressOptionType.deleteContact ||
                              optionType == CLongPressOptionType.leaveGroupOrChannel
                          ? ThemeColor.red
                          : ThemeColor.color100,
                    ),
                  ),
                  CommonImage(
                    iconName: optionType.icon,
                    size: 24.px,
                    package: 'ox_chat',
                    color: optionType == CLongPressOptionType.deleteContact ||
                        optionType == CLongPressOptionType.leaveGroupOrChannel
                        ? ThemeColor.red
                        : ThemeColor.color100,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}


enum CLongPressOptionType {
  sendMessage,
  startSecretChat,
  voiceCall,
  videoCall,
  deleteContact,
  leaveGroupOrChannel,
}

extension CLongPressOptionTypeEx on CLongPressOptionType {
  String get text {
    switch (this) {
      case CLongPressOptionType.sendMessage:
        return 'send_message'.localized();
      case CLongPressOptionType.startSecretChat:
        return 'secret_chat'.localized();
      case CLongPressOptionType.voiceCall:
        return 'str_voice_call'.localized();
      case CLongPressOptionType.videoCall:
        return 'str_video_call'.localized();
      case CLongPressOptionType.deleteContact:
        return 'str_delete_contact'.localized();
      case CLongPressOptionType.leaveGroupOrChannel:
        return 'delete'.localized();
    }
  }

  String get icon {
    switch (this) {
      case CLongPressOptionType.sendMessage:
        return "icon_message.png";
      case CLongPressOptionType.startSecretChat:
        return 'icon_secret.png';
      case CLongPressOptionType.voiceCall:
        return 'icon_call_voice.png';
      case CLongPressOptionType.videoCall:
        return "icon_call_video.png";
      case CLongPressOptionType.deleteContact:
        return 'icon_chat_delete.png';
      case CLongPressOptionType.leaveGroupOrChannel:
        return 'icon_chat_delete.png';
    }
  }

  static String getOptionName(ChatSessionModelISAR chatSessionModelISAR, CLongPressOptionType type){
    if (type == CLongPressOptionType.leaveGroupOrChannel){
      if (chatSessionModelISAR.chatType == ChatType.chatChannel){
        return 'leave_item'.localized();
      } else {
        return 'str_leave_group'.localized();
      }
    }
    return type.text;
  }

  static List<CLongPressOptionType> getOptionModelList(ChatSessionModelISAR chatSessionModelISAR) {
    if (chatSessionModelISAR.chatType == ChatType.chatSingle ||
        chatSessionModelISAR.chatType == ChatType.chatStranger ||
        chatSessionModelISAR.chatType == ChatType.chatSecret ||
        chatSessionModelISAR.chatType == ChatType.chatSecretStranger) {
      return [
        CLongPressOptionType.sendMessage,
        CLongPressOptionType.startSecretChat,
        CLongPressOptionType.voiceCall,
        CLongPressOptionType.videoCall,
        CLongPressOptionType.deleteContact,
      ];
    } else {
      return [
        CLongPressOptionType.sendMessage,
        CLongPressOptionType.leaveGroupOrChannel,
      ];
    }
  }

  static void optionsOnTap(BuildContext context, CLongPressOptionType optionType, ChatSessionModelISAR sessionModelISAR) async {
    switch(optionType){
      case CLongPressOptionType.sendMessage:
        ChatMessagePage.open(
          context: context,
          communityItem: sessionModelISAR,
          isPushWithReplace: false,
        );
        break;
      case CLongPressOptionType.startSecretChat:
        UserDBISAR? userDB = Contacts.sharedInstance.allContacts[sessionModelISAR.getOtherPubkey] as UserDBISAR;
        OXNavigator.pushPage(context, (context) => ContactCreateSecret(userDB: userDB));
      case CLongPressOptionType.voiceCall:
        UserDBISAR? userDB = Contacts.sharedInstance.allContacts[sessionModelISAR.getOtherPubkey] as UserDBISAR;
        if (userDB.pubKey == OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey) {
          return CommonToast.instance.show(context, "Don't call yourself");
        }
        OXModuleService.pushPage(
          context,
          'ox_calling',
          'CallPage',
          {
            'userDB': userDB,
            'media': CallMessageType.audio.text
          },
        );
        break;
      case CLongPressOptionType.videoCall:
        UserDBISAR? userDB = Contacts.sharedInstance.allContacts[sessionModelISAR.getOtherPubkey] as UserDBISAR;
        if (userDB.pubKey == OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey) {
          return  CommonToast.instance.show(context, "Don't call yourself");
        }
        OXModuleService.pushPage(
          context,
          'ox_calling',
          'CallPage',
          {
            'userDB': userDB,
            'media': CallMessageType.video.text
          },
        );
        break;
      case CLongPressOptionType.deleteContact:
        UserDBISAR? userDB = Contacts.sharedInstance.allContacts[sessionModelISAR.getOtherPubkey] as UserDBISAR;
        OXCommonHintDialog.show(context,
            title: Localized.text('ox_chat.remove_contacts'),
            content: Localized.text('ox_chat.remove_contacts_dialog_content')
                .replaceAll(r'${name}', '${userDB.name}'),
            actionList: [
              OXCommonHintAction.cancel(onTap: () {
                OXNavigator.pop(context);
              }),
              OXCommonHintAction.sure(
                  text: Localized.text('ox_common.confirm'),
                  onTap: () async {
                    await OXLoading.show();
                    final OKEvent okEvent = await Contacts.sharedInstance
                        .removeContact(userDB.pubKey ?? '');
                    await OXLoading.dismiss();
                    OXNavigator.pop(context);
                    OXNavigator.pop(context);
                    if (okEvent.status) {
                      CommonToast.instance.show(context,
                          Localized.text('ox_chat.remove_contacts_success_toast'));
                    } else {
                      CommonToast.instance.show(context, okEvent.message);
                    }
                  }),
            ],
            isRowAction: true);
          break;
        case CLongPressOptionType.leaveGroupOrChannel:
          if (sessionModelISAR.chatType == ChatType.chatChannel){
            OXCommonHintDialog.show(context,
                title: Localized.text('ox_common.tips'),
                content: Localized.text('ox_chat.leave_channel_tips'),
                actionList: [
                  OXCommonHintAction.cancel(onTap: () {
                    OXNavigator.pop(context);
                  }),
                  OXCommonHintAction.sure(
                      text: Localized.text('ox_common.confirm'),
                      onTap: () async {
                        await OXLoading.show();
                        final OKEvent okEvent = await Channels.sharedInstance.leaveChannel(sessionModelISAR.chatId);
                        OXUserInfoManager.sharedInstance.setNotification();
                        await OXLoading.dismiss();
                        if (okEvent.status) {
                          OXChatBinding.sharedInstance.channelsUpdatedCallBack();
                          OXNavigator.popToRoot(context);
                        } else {
                          OXNavigator.pop(context);
                          CommonToast.instance.show(context, okEvent.message);
                        }
                      }),
                ],
                isRowAction: true);
          } else if (sessionModelISAR.chatType == ChatType.chatGroup){
            UserDBISAR? userInfo = OXUserInfoManager.sharedInstance.currentUserInfo;
            GroupDBISAR? groupDBInfo = await Groups.sharedInstance.myGroups[sessionModelISAR.chatId]?.value;
            bool isGroupOwner = (userInfo == null || groupDBInfo == null) ? false : userInfo.pubKey == groupDBInfo.owner;
            ChatSessionUtils.leaveConfirmWidget(context, sessionModelISAR.chatType, sessionModelISAR.chatId, isGroupOwner: isGroupOwner);
          } else if (sessionModelISAR.chatType == ChatType.chatRelayGroup){
            String groupId = sessionModelISAR.chatId;
            UserDBISAR? userDB = OXUserInfoManager.sharedInstance.currentUserInfo;
            RelayGroupDBISAR? groupDB = RelayGroup.sharedInstance.groups[groupId]?.value;
            List<UserDBISAR> memberUserDBs = await RelayGroup.sharedInstance.getGroupMembersFromLocal(groupId);
            bool isGroupMember = false;
            bool hasDeleteGroupPermission = RelayGroup.sharedInstance.hasPermissions(groupDB?.admins ?? [], userDB?.pubKey??'', [GroupActionKind.deleteGroup]);
            if (memberUserDBs.isNotEmpty) {
              UserDBISAR? userInfo = OXUserInfoManager.sharedInstance.currentUserInfo;
              if (userInfo == null) {
                isGroupMember = false;
              } else {
                isGroupMember = memberUserDBs.any((userDB) => userDB.pubKey == userInfo.pubKey);
              }
            }
            ChatSessionUtils.leaveConfirmWidget(context, sessionModelISAR.chatType, sessionModelISAR.chatId, isGroupMember: isGroupMember, hasDeleteGroupPermission: hasDeleteGroupPermission);
          }
          break;
    }

  }
}

