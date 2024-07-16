import 'package:chatcore/chat-core.dart';
import 'package:ox_chat/model/option_model.dart';
import 'package:ox_chat/utils/general_handler/chat_general_handler.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/utils/custom_uri_helper.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';

class ChatSendInvitedTemplateHelper {
  static sendGroupInvitedTemplate(List<UserDB> selectedUserList,String groupId, GroupType groupType, String shareContent){
    final inviterName = OXUserInfoManager.sharedInstance.currentUserInfo?.name ?? OXUserInfoManager.sharedInstance.currentUserInfo?.nickName ?? '';
    final inviterPubKey = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey;
    String groupName = '';
    String groupOwner = '';
    String groupPic = '';
    if (groupType == GroupType.privateGroup) {
      GroupDB? groupDB = Groups.sharedInstance.groups[groupId];
      groupName = groupDB?.name ?? '';
      groupOwner = groupDB?.owner ?? '';
      groupPic = groupDB?.picture ?? '';
    } else if (groupType == GroupType.openGroup || groupType == GroupType.closeGroup) {
      RelayGroupDB? groupDB = RelayGroup.sharedInstance.groups[groupId];
      groupName = groupDB?.name ?? '';
      groupOwner = groupDB?.author ?? '';
      groupPic = groupDB?.picture ?? '';
      groupId = groupDB?.id ?? '';
    }

    selectedUserList.forEach((element) {
      ChatMessageSendEx.sendTextMessageHandler(
        element.pubKey,
        shareContent,
        chatType: ChatType.chatRelayGroup,
      );
    });

    // String link = CustomURIHelper.createModuleActionURI(module: 'ox_chat', action: 'groupSharePage', params: {
    //   'groupPic': groupPic,
    //   'groupName': groupName,
    //   'groupId': groupId,
    //   'inviterPubKey': inviterPubKey,
    //   'groupOwner': groupOwner,
    //   'groupTypeIndex': groupType.index,
    // });
    // selectedUserList.forEach((element) {
    //   ChatMessageSendEx.sendTemplateMessage(
    //     receiverPubkey: element.pubKey,
    //     icon: 'icon_group_default.png',
    //     title: 'Group Chat Invitation',
    //     subTitle: '${inviterName} invited you to join this Group "${groupName}"',
    //     link: link,
    //   );
    // });
  }
}