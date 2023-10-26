import 'package:chatcore/chat-core.dart';
import 'package:ox_chat/utils/general_handler/chat_general_handler.dart';
import 'package:ox_common/utils/custom_uri_helper.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';

class ChatSendInvitedTemplateHelper {
  static sendGroupInvitedTemplate(List<UserDB> selectedUserList,String groupId){
    GroupDB? groupDB = Groups.sharedInstance.groups[groupId];
    final groupName = groupDB?.name;
    final inviterName = OXUserInfoManager.sharedInstance.currentUserInfo?.name ?? OXUserInfoManager.sharedInstance.currentUserInfo?.nickName ?? '';
    final inviterPubKey = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey;
    String link = CustomURIHelper.createModuleActionURI(module: 'ox_chat', action: 'groupSharePage',params: {'groupId': groupId,'inviterPubKey':inviterPubKey});
    selectedUserList.forEach((element) {
      ChatMessageSendEx.sendTemplatePrivateMessage(
        receiverPubkey: element.pubKey,
        icon: 'icon_group_default.png',
        title: 'Group Chat Invitation',
        subTitle: '${inviterName} invited you to join this Group "${groupName}"',
        link: link,
      );
    });
  }
}