import 'package:flutter/material.dart';
import 'package:ox_chat/model/group_ui_model.dart';
import 'package:ox_chat/model/search_chat_model.dart';
import 'package:ox_chat/page/session/chat_message_page.dart';
import 'package:ox_chat/page/session/search_chat_detail_page.dart';
import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';

class SearchItemClickHandler {
  static void handleClick(BuildContext context, dynamic item,
      [String searchQuery = '']) {
    if (item is ChatMessage) {
      bool hasSingleRelatedRecord = item.relatedCount > 1;
      if (hasSingleRelatedRecord) {
        gotoSearchChatDetailPage(context, item, searchQuery);
      } else {
        gotoChatMessagePage(context, item);
      }
    } else if (item is UserDBISAR) {
      gotoContactSession(context, item);
    } else if (item is GroupUIModel) {
      gotoGroupSession(context, item);
    } else if (item is ChannelDBISAR) {
      gotoChatChannelSession(context, item);
    }
  }

  static void gotoSearchChatDetailPage(
      BuildContext context,
      ChatMessage chatMessage,
      String searchQuery,
      ) {
    OXNavigator.pushPage(
      context,
          (context) => SearchChatDetailPage(
        searchQuery: searchQuery,
        chatMessage: chatMessage,
      ),
    );
  }

  static void gotoChatMessagePage(
      BuildContext context,
      ChatMessage item,
      ) {
    final type = item.chatType;
    final sessionModel = OXChatBinding.sharedInstance.sessionMap[item.chatId];
    if (sessionModel == null) return;
    switch (type) {
      case ChatType.chatSingle:
      case ChatType.chatChannel:
      case ChatType.chatSecret:
      case ChatType.chatGroup:
      case ChatType.chatRelayGroup:
        ChatMessagePage.open(
          context: context,
          communityItem: sessionModel,
          anchorMsgId: item.msgId,
        );
        break;
    }
  }

  static void gotoContactSession(BuildContext context, UserDBISAR userDB) {
    ChatMessagePage.open(
      context: context,
      communityItem: ChatSessionModelISAR(
        chatId: userDB.pubKey,
        chatName: userDB.name,
        sender: OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey,
        receiver: userDB.pubKey,
        chatType: ChatType.chatSingle,
      ),
    );
  }

  static void gotoGroupSession(BuildContext context, GroupUIModel groupUIModel) {
    if (groupUIModel.chatType == ChatType.chatGroup || groupUIModel.chatType == ChatType.chatRelayGroup) {
      ChatMessagePage.open(
        context: context,
        communityItem: ChatSessionModelISAR(
          chatId: groupUIModel.groupId,
          chatName: groupUIModel.name,
          chatType: groupUIModel.chatType,
          avatar: groupUIModel.picture,
          groupId: groupUIModel.groupId,
        ),
      );
    }
  }

  static void gotoChatChannelSession(BuildContext context, ChannelDBISAR channelDB) {
    ChatMessagePage.open(
      context: context,
      communityItem: ChatSessionModelISAR(
        chatId: channelDB.channelId,
        chatName: channelDB.name,
        chatType: ChatType.chatChannel,
        avatar: channelDB.picture,
        groupId: channelDB.channelId,
        createTime: channelDB.createTime,
      ),
    );
  }
}