
import 'package:chatcore/chat-core.dart';
import 'package:ox_chat/model/search_chat_model.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';

///Title: search_txt_util
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/2/27 17:02
class SearchTxtUtil{
  //Queries the list of Friends to see if each Friend name contains a search character
  static List<UserDB>? loadChatFriendsWithSymbol(String symbol) {
    List<UserDB>? friendList = Contacts.sharedInstance.fuzzySearch(symbol);
    return friendList;
  }

  //Queries the list of Channels to see if each Channel name contains a search character
  static List<ChannelDB>? loadChatChannelsWithSymbol(String symbol) {
    final List<ChannelDB>? channelList =
    Channels.sharedInstance.fuzzySearch(symbol);
    return channelList;
  }

  static List<GroupDB>? loadChatGroupWithSymbol(String symbol) {
    final List<GroupDB>? groupDBlist = Groups.sharedInstance.fuzzySearch(symbol);
    return groupDBlist;
  }

  static Future<List<ChatMessage>> loadChatMessagesWithSymbol(String symbol,
      {String? chatId}) async {
    List<ChatMessage> chatMessageList = [];
    String originalSearchTxt = symbol;
    originalSearchTxt = originalSearchTxt.replaceFirst("/", "//");
    originalSearchTxt = originalSearchTxt.replaceFirst("_", "/_");
    originalSearchTxt = originalSearchTxt.replaceFirst("%", "/%");
    originalSearchTxt = originalSearchTxt.replaceFirst(" ", "%");
    final List<ChatMessage> channelMsgList = await loadChannelMsgWithSearchTxt(originalSearchTxt, chatId: chatId);
    final List<ChatMessage> privateChatMsgList = await loadPrivateChatMsgWithSearchTxt(originalSearchTxt, chatId: chatId);
    chatMessageList.addAll(channelMsgList);
    chatMessageList.addAll(privateChatMsgList);
    return chatMessageList;
  }

  static Future<List<ChatMessage>> loadChannelMsgWithSearchTxt(String orignalSearchTxt,
      {String? chatId}) async {
    List<ChatMessage> chatMessageList = [];
    try {
      Map<dynamic, dynamic> tempMap = {};
      if (chatId == null) {
        tempMap = await Messages.loadMessagesFromDB(
          where:
          'groupId IS NOT NULL AND groupId != ? AND content COLLATE NOCASE NOT LIKE ? AND decryptContent COLLATE NOCASE LIKE ?',
          whereArgs: ['', '%{%}%', "%${orignalSearchTxt}%"],
        );
      } else {
        tempMap = await Messages.loadMessagesFromDB(
          where:
          'groupId = ? AND content COLLATE NOCASE NOT LIKE ? AND decryptContent COLLATE NOCASE LIKE ?',
          whereArgs: [chatId, '%{%}%', "%${orignalSearchTxt}%"],
        );
      }
      List<MessageDB> messages = tempMap['messages'];
      LogUtil.e('Michael:loadChannelMsgWithSearchTxt  messages.length =${messages.length}');
      if (messages.length != 0) {
        if (chatId == null) {
          Map<String, ChatMessage> messageInduceMap = {};
          messages.forEach((item) {
            if (messageInduceMap[item.groupId] == null) {
              messageInduceMap[item.groupId] = ChatMessage(
                item.groupId,
                item.messageId ?? '',
                _getName(item),
                item.decryptContent,
                _getPicUrl(item),
                item.chatType ?? ChatType.chatChannel,
                1,
              );
            } else {
              messageInduceMap[item.groupId]!.relatedCount =
                  messageInduceMap[item.groupId]!.relatedCount + 1;
              messageInduceMap[item.groupId]!.subtitle =
              '${messageInduceMap[item.groupId]!.relatedCount} related messages';
            }
          });
          LogUtil.e('Michael: messageInduceMap.length =${messageInduceMap.length}');
          chatMessageList = messageInduceMap.values.toList();
        } else {
          messages.forEach((element) {
            chatMessageList.add(ChatMessage(
              element.groupId,
              element.messageId ?? '',
              _getName(element),
              element.decryptContent,
              _getPicUrl(element),
              element.chatType ?? ChatType.chatChannel,
              1,
            ));
          });
        }
      }
    } catch (e) {
      LogUtil.e('Michael: e =${e}');
    }
    return chatMessageList;
  }

  static Future<List<ChatMessage>> loadPrivateChatMsgWithSearchTxt(
      String orignalSearchTxt,
      {String? chatId}) async {
    List<ChatMessage> chatMessageList = [];
    try {
      Map<dynamic, dynamic> tempMap = {};
      if (chatId == null) {
        tempMap = await Messages.loadMessagesFromDB(
          where:
          "sender IS NOT NULL AND sender != ? AND receiver IS NOT NULL AND receiver != ? AND decryptContent COLLATE NOCASE NOT LIKE ? AND decryptContent COLLATE NOCASE LIKE ?",
          whereArgs: ['', '', '%{%}%', "%${orignalSearchTxt}%"],
        );
      } else {
        tempMap = await Messages.loadMessagesFromDB(
          where:
          "(sender = ? AND receiver = ? ) OR (sender = ? AND receiver = ? ) AND decryptContent COLLATE NOCASE NOT LIKE ? AND decryptContent COLLATE NOCASE LIKE ?",
          whereArgs: [
            chatId,
            OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey,
            OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey,
            chatId,
            '%{%}%',
            "%${orignalSearchTxt}%",
          ],
        );
      }
      List<MessageDB> messages = tempMap['messages'];
      if (messages.length != 0) {
        if (chatId == null) {
          Map<String, ChatMessage> messageInduceMap = {};
          messages.forEach((item) {
            String chatId = '';
            if (item.sender == OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey
                || item.receiver == OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey) {
              chatId = item.sender;
            } else if (item.sender == OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey
                || item.receiver != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey) {
              chatId = item.receiver;
            } else if (item.sender != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey
                || item.receiver == OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey) {
              chatId = item.sender;
            }
            if (messageInduceMap[chatId] == null) {
              messageInduceMap[chatId] = ChatMessage(
                chatId,
                item.messageId ?? '',
                Account.sharedInstance.userCache[chatId]?.name ?? '',
                item.decryptContent,
                Account.sharedInstance.userCache[chatId]?.picture ?? '',
                ChatType.chatSingle,
                1,
              );
            } else {
              messageInduceMap[chatId]!.relatedCount =
                  messageInduceMap[chatId]!.relatedCount + 1;
              messageInduceMap[chatId]!.subtitle =
              '${messageInduceMap[chatId]!.relatedCount} related messages';
            }
          });
          chatMessageList = messageInduceMap.values.toList();
        } else {
          messages.forEach((element) {
            chatMessageList.add(ChatMessage(
              chatId,
              element.messageId ?? '',
              Account.sharedInstance.userCache[chatId]?.name ?? '',
              element.decryptContent,
              Account.sharedInstance.userCache[chatId]?.picture ?? '',
              ChatType.chatSingle,
              1,
            ));
          });
        }
      }
    } catch (e) {
      LogUtil.e('Michael: e =${e}');
    }
    return chatMessageList;
  }

  static String _getName(MessageDB messageDB){
    String name = '';
    if (messageDB.chatType == ChatType.chatChannel) {
      ChannelDB? channelDB = Channels.sharedInstance.channels[messageDB.groupId];
      name = channelDB?.name ?? messageDB.groupId;
    } else {
      GroupDB? groupDBDB = Groups.sharedInstance.groups[messageDB.groupId];
      name = groupDBDB?.name ?? messageDB.groupId;
    }
    return name;
  }

  static String _getPicUrl(MessageDB messageDB){
    String picUrl = '';
    if (messageDB.chatType == ChatType.chatChannel) {
      ChannelDB? channelDB = Channels.sharedInstance.channels[messageDB.groupId];
      picUrl = channelDB?.picture ?? '';
    } else {
      GroupDB? groupDBDB = Groups.sharedInstance.groups[messageDB.groupId];
      picUrl = groupDBDB?.picture ?? '';
    }
    return picUrl;
  }
}