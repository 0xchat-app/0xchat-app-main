import 'package:flutter/material.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';

///Title: chat_session_utils
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/4/1 07:58
class ChatSessionUtils {
  static ValueNotifier? getChatValueNotifier(ChatSessionModelISAR model) {
    ValueNotifier? valueNotifier;

    switch (model.chatType) {
      case ChatType.chatSingle:
      case ChatType.chatSecret:
        valueNotifier = Account.sharedInstance.getUserNotifier(model.getOtherPubkey);
        break;
      case ChatType.chatChannel:
        valueNotifier = Channels.sharedInstance.getChannelNotifier(model.chatId);
        break;
      case ChatType.chatGroup:
        valueNotifier = Groups.sharedInstance.getPrivateGroupNotifier(model.chatId);
        break;
      case ChatType.chatRelayGroup:
        valueNotifier = RelayGroup.sharedInstance.getRelayGroupNotifier(model.chatId);
        break;
    }
    return valueNotifier;
  }

  static String getChatName(ChatSessionModelISAR model) {
    String showName = '';
    switch (model.chatType) {
      case ChatType.chatChannel:
        showName = Channels.sharedInstance.channels[model.chatId]?.value.name ?? '';
        if (showName.isEmpty) showName = Channels.encodeChannel(model.chatId, null, null);
        break;
      case ChatType.chatSingle:
      case ChatType.chatSecret:
        showName = Account.sharedInstance.userCache[model.getOtherPubkey]?.value.name ?? '';
        break;
      case ChatType.chatGroup:
        showName = Groups.sharedInstance.groups[model.chatId]?.value.name ?? '';
        if (showName.isEmpty) showName = Groups.encodeGroup(model.chatId, null, null);
        break;
      case ChatType.chatRelayGroup:
        showName = RelayGroup.sharedInstance.groups[model.chatId]?.value.name ?? '';
        if (showName.isEmpty) showName = RelayGroup.sharedInstance.encodeGroup(model.chatId) ?? '';
        break;
      case ChatType.chatNotice:
        showName = model.chatName ?? '';
        break;
    }
    return showName;
  }

  static String getChatIcon(ChatSessionModelISAR model) {
    String showPicUrl = '';
    switch (model.chatType) {
      case ChatType.chatChannel:
        showPicUrl = Channels.sharedInstance.channels[model.chatId]?.value.picture ?? '';
        break;
      case ChatType.chatSingle:
      case ChatType.chatSecret:
        showPicUrl = Account.sharedInstance.userCache[model.getOtherPubkey]?.value.picture ?? '';
        break;
      case ChatType.chatGroup:
        showPicUrl = Groups.sharedInstance.groups[model.chatId]?.value.picture ?? '';
        break;
      case ChatType.chatRelayGroup:
        showPicUrl = RelayGroup.sharedInstance.groups[model.chatId]?.value.picture ?? '';
        break;
    }
    return showPicUrl;
  }

  static String getChatDefaultIcon(ChatSessionModelISAR model) {
    String localAvatarPath = '';
    switch (model.chatType) {
      case ChatType.chatChannel:
        localAvatarPath = 'icon_group_default.png';
        break;
      case ChatType.chatSingle:
      case ChatType.chatSecret:
        localAvatarPath = 'user_image.png';
        break;
      case ChatType.chatGroup:
      case ChatType.chatRelayGroup:
        localAvatarPath = 'icon_group_default.png';
        break;
      case ChatType.chatNotice:
        localAvatarPath = 'icon_request_avatar.png';
        break;
    }
    return localAvatarPath;
  }

  static bool getChatMute(ChatSessionModelISAR model) {
    bool isMute = false;
    switch (model.chatType) {
      case ChatType.chatChannel:
        ChannelDBISAR? channelDB = Channels.sharedInstance.channels[model.chatId]?.value;
        if (channelDB != null) {
          isMute = channelDB.mute ?? false;
        }
        break;
      case ChatType.chatSingle:
      case ChatType.chatSecret:
      UserDBISAR? tempUserDB = Account.sharedInstance.userCache[model.chatId]?.value;
        if (tempUserDB != null) {
          isMute = tempUserDB.mute ?? false;
        }
        break;
      case ChatType.chatGroup:
        GroupDBISAR? groupDB = Groups.sharedInstance.groups[model.chatId]?.value;
        if (groupDB != null) {
          isMute = groupDB.mute;
        }
        break;
      case ChatType.chatRelayGroup:
        RelayGroupDBISAR? relayGroupDB = RelayGroup.sharedInstance.groups[model.chatId]?.value;
        if (relayGroupDB != null) {
          isMute = relayGroupDB.mute;
        }
        break;
    }
    return isMute;
  }

  static Widget getTypeSessionView(int chatType, String chatId){
    String? iconName;
    switch (chatType) {
      case ChatType.chatChannel:
        iconName = 'icon_type_channel.png';
        break;
      case ChatType.chatGroup:
        iconName = 'icon_type_private_group.png';
        break;
      case ChatType.chatRelayGroup:
        RelayGroupDBISAR? relayGroupDB = RelayGroup.sharedInstance.groups[chatId]?.value;
        if (relayGroupDB != null){
          if (relayGroupDB.closed){
            iconName = 'icon_type_close_group.png';
          } else {
            iconName = 'icon_type_open_group.png';
          }
        }
        break;
      default:
        break;
    }
    Widget typeSessionWidget = iconName != null ? CommonImage(iconName: iconName, size: 24.px, package: 'ox_chat',useTheme: true,) : SizedBox();
    return typeSessionWidget;
  }

  static bool checkIsMute(MessageDBISAR message, int type) {
    bool isMute = false;
    switch (type) {
      case ChatType.chatChannel:
        ChannelDBISAR? channelDB = Channels.sharedInstance.channels[message.groupId]?.value;
        isMute = channelDB?.mute ?? false;
        return isMute;
      case ChatType.chatGroup:
        GroupDBISAR? groupDB = Groups.sharedInstance.myGroups[message.groupId]?.value;
        isMute = groupDB?.mute ?? false;
        return isMute;
      case ChatType.chatRelayGroup:
        RelayGroupDBISAR? relayGroupDB = RelayGroup.sharedInstance.myGroups[message.groupId]?.value;
        isMute = relayGroupDB?.mute ?? false;
        return isMute;
      default:
        final tempUserDB = Account.sharedInstance.getUserInfo(message.sender);
        isMute = tempUserDB is UserDBISAR ? (tempUserDB?.mute ?? false) : false;
        return isMute;
    }
  }

  static void setChatMute(ChatSessionModelISAR model, bool muteValue) async {
    switch (model.chatType) {
      case ChatType.chatChannel:
        if (muteValue) {
          await Channels.sharedInstance.muteChannel(model.chatId);
        } else {
          await Channels.sharedInstance.unMuteChannel(model.chatId);
        }
        break;
      case ChatType.chatSingle:
      case ChatType.chatSecret:
        if (muteValue) {
          await Contacts.sharedInstance.muteFriend(model.chatId);
        } else {
          await Contacts.sharedInstance.unMuteFriend(model.chatId);
        }
        break;
      case ChatType.chatGroup:
        if (muteValue) {
          await Groups.sharedInstance.muteGroup(model.chatId);
        } else {
          await Groups.sharedInstance.unMuteGroup(model.chatId);
        }
        break;
      case ChatType.chatRelayGroup:
        if (muteValue) {
          await RelayGroup.sharedInstance.muteGroup(model.chatId);
        } else {
          await RelayGroup.sharedInstance.unMuteGroup(model.chatId);
        }
        break;
    }
    OXUserInfoManager.sharedInstance.setNotification().then((value) {
      if (value) {
        OXChatBinding.sharedInstance.sessionUpdate();
      }
    });
  }

  static void leaveConfirmWidget(BuildContext context, int chatType, String groupId, {bool isGroupOwner = false, bool isGroupMember = false, bool hasDeleteGroupPermission = false}) {
    String tips = '';
    String content = '';
    if (chatType == ChatType.chatRelayGroup) {
      tips = !isGroupMember
          ? Localized.text('ox_common.tips')
          : (hasDeleteGroupPermission
          ? 'delete_group_tips'.localized()
          : 'leave_group_tips'.localized());
      content = hasDeleteGroupPermission
          ? Localized.text('ox_chat.delete_and_leave_item')
          : Localized.text('ox_chat.str_leave_group');
    } else if (chatType == ChatType.chatGroup) {
      tips = isGroupOwner
          ? Localized.text('ox_chat.delete_group_tips')
          : Localized.text('ox_chat.leave_group_tips');
      content = isGroupOwner ? Localized.text('ox_chat.delete_and_leave_item') : Localized.text('ox_chat.str_leave_group');
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SafeArea(
          bottom: false,
          child: Material(
            type: MaterialType.transparency,
            child: Opacity(
              opacity: 1,
              child: Container(
                alignment: Alignment.bottomCenter,
                height: 156.5.px,
                decoration: BoxDecoration(
                  color: ThemeColor.color180,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12.px), topRight: Radius.circular(12.px)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 36.px,
                      child: MyText(tips, 14, ThemeColor.color100, textAlign: TextAlign.center),
                    ),
                    Divider(
                      height: 0.5.px,
                      color: ThemeColor.color160,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (chatType == ChatType.chatRelayGroup) {
                          leaveRelayGroupFn(
                              context, hasDeleteGroupPermission, groupId);
                        } else if (chatType == ChatType.chatGroup) {
                          leaveGroupFn(context, groupId, isGroupOwner);
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 56.px,
                        child: MyText(content, 16, ThemeColor.red, textAlign: TextAlign.center),
                      ),
                    ),
                    Container(
                      height: 8.px,
                      color: ThemeColor.color190,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        OXNavigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 56.px,
                        color: ThemeColor.color180,
                        child: MyText(Localized.text('ox_common.cancel'), 16, ThemeColor.color0, textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void leaveRelayGroupFn(BuildContext context, bool hasDeleteGroupPermission, String groupId) async {
    OXLoading.show();
    if(hasDeleteGroupPermission){
      await RelayGroup.sharedInstance.deleteGroup(groupId, 'delete group');
    }
    OKEvent event = await RelayGroup.sharedInstance.leaveGroup(groupId, 'leave group');
    OXUserInfoManager.sharedInstance.setNotification();
    OXLoading.dismiss();
    if (!event.status) {
      CommonToast.instance.show(context, event.message);
      return;
    }
    CommonToast.instance.show(context, Localized.text('ox_chat.leave_group_success_toast'));
    OXNavigator.popToRoot(context);
  }

  // private group
  static void leaveGroupFn(BuildContext context, String groupId, bool isGroupOwner) async {
    UserDBISAR? userInfo = OXUserInfoManager.sharedInstance.currentUserInfo;

    OXLoading.show();
    late OKEvent event;
    if (isGroupOwner){
      event = await Groups.sharedInstance
          .deleteAndLeave(groupId, Localized.text('ox_chat.disband_group_toast'));
    } else {
      event = await Groups.sharedInstance.leaveGroup(groupId,
          Localized.text('ox_chat.leave_group_system_message').replaceAll(
              r'${name}', '${userInfo?.name}'));
    }
    OXLoading.dismiss();
    if (!event.status) {
      CommonToast.instance.show(context, event.message);
      return;
    }
    CommonToast.instance.show(context, isGroupOwner ? Localized.text('ox_chat.disband_group_toast') : Localized.text('ox_chat.leave_group_success_toast'));
    OXNavigator.popToRoot(context);
  }

}
