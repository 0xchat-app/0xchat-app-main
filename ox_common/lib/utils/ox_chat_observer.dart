import 'package:chatcore/chat-core.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';

///Title: ox_chat_observer
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/10/9 19:28
abstract mixin class OXChatObserver {
  void didSecretChatRequestCallBack() {}

  void didPrivateMessageCallBack(MessageDBISAR message) {}

  void didSecretChatAcceptCallBack(SecretSessionDB ssDB) {}

  void didSecretChatRejectCallBack(SecretSessionDB ssDB) {}

  void didSecretChatCloseCallBack(SecretSessionDB ssDB) {}

  void didSecretChatUpdateCallBack(SecretSessionDB ssDB) {}

  void didContactUpdatedCallBack() {}

  void didCreateChannel(ChannelDB? channelDB) {}

  void didDeleteChannel(ChannelDB? channelDB) {}

  void didChannalMessageCallBack(MessageDBISAR message) {}

  void didGroupMessageCallBack(MessageDBISAR message) {}

  void didRelayGroupJoinReqCallBack(JoinRequestDB joinRequestDB) {}

  void didRelayGroupModerationCallBack(ModerationDB moderationDB) {}

  void didMessageActionsCallBack(MessageDBISAR message) {}

  void didChannelsUpdatedCallBack() {}

  void didGroupsUpdatedCallBack() {}

  void didRelayGroupsUpdatedCallBack() {}

  void didSessionUpdate() {}

  void didSecretChatMessageCallBack(MessageDBISAR message) {}

  void didPromptToneCallBack(MessageDBISAR message, int type) {}

  void didZapRecordsCallBack(ZapRecordsDB zapRecordsDB) {
    final pubKey = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '';
    OXCacheManager.defaultOXCacheManager.saveData('$pubKey.zap_badge', true);
    OXChatBinding.sharedInstance.isZapBadge = true;
  }

  void didOfflinePrivateMessageFinishCallBack() {}
  void didOfflineSecretMessageFinishCallBack() {}
  void didOfflineChannelMessageFinishCallBack() {}
}