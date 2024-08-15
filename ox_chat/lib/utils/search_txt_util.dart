
import 'package:chatcore/chat-core.dart';
import 'package:ox_chat/model/group_ui_model.dart';
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
  static List<UserDBISAR>? loadChatFriendsWithSymbol(String symbol) {
    List<UserDBISAR>? friendList = Contacts.sharedInstance.fuzzySearch(symbol);
    return friendList;
  }

  //Queries the list of Channels to see if each Channel name contains a search character
  static List<ChannelDBISAR>? loadChatChannelsWithSymbol(String symbol) {
    final List<ChannelDBISAR>? channelList =
    Channels.sharedInstance.fuzzySearch(symbol);
    return channelList;
  }

  static Future<List<GroupUIModel>?> loadChatGroupWithSymbol(String symbol) async {
    List<GroupUIModel> groupUIModels = [];
    final List<GroupDBISAR>? groupDBlist = Groups.sharedInstance.fuzzySearch(symbol);
    final List<RelayGroupDBISAR>? relayGroupDBlist = await RelayGroup.sharedInstance.fuzzySearch(symbol);
    if(groupDBlist!=null && groupDBlist.length>0) {
      List<GroupUIModel> groupUIModelList = [];
      groupDBlist.forEach((element) {
        groupUIModelList.add(GroupUIModel.groupdbToUIModel(element));
      });
      groupUIModels.addAll(groupUIModelList);
    }
    if(relayGroupDBlist!=null && relayGroupDBlist.length>0) {
      List<GroupUIModel> relayGroupUIModelList = [];
      relayGroupDBlist.forEach((element) {
        relayGroupUIModelList.add(GroupUIModel.relayGroupdbToUIModel(element));
      });
      groupUIModels.addAll(relayGroupUIModelList);
    }
    return groupUIModels;
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
      tempMap = await Messages.searchGroupMessagesFromDB(chatId, orignalSearchTxt);
      List<MessageDBISAR> messages = tempMap['messages'];
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
                ChatType.convertMessageChatType(item.chatType ?? ChatType.chatChannel),
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
              ChatType.convertMessageChatType(element.chatType ?? ChatType.chatChannel),
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
      tempMap = await Messages.searchPrivateMessagesFromDB(chatId, orignalSearchTxt);
      List<MessageDBISAR> messages = tempMap['messages'];
      if (messages.length != 0) {
        if (chatId == null) {
          Map<String, ChatMessage> messageInduceMap = {};
          messages.forEach((item) {
            String chatId = '';
            if (item.sender != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey
                || item.receiver == OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey) {
              chatId = item.sender;
            } else if (item.sender == OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey
                || item.receiver != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey) {
              chatId = item.receiver;
            } else if (item.sender == OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey
                || item.receiver == OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey) {
              chatId = item.sender;
            }
            if (messageInduceMap[chatId] == null) {
              messageInduceMap[chatId] = ChatMessage(
                chatId,
                item.messageId ?? '',
                Account.sharedInstance.userCache[chatId]?.value.name ?? '',
                item.decryptContent,
                Account.sharedInstance.userCache[chatId]?.value.picture ?? '',
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
              Account.sharedInstance.userCache[chatId]?.value.name ?? '',
              element.decryptContent,
              Account.sharedInstance.userCache[chatId]?.value.picture ?? '',
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

  static String _getName(MessageDBISAR messageDB){
    String name = '';
    if (messageDB.chatType == ChatType.chatChannel) {
      ChannelDBISAR? channelDB = Channels.sharedInstance.channels[messageDB.groupId];
      name = channelDB?.name ?? messageDB.groupId;
    } else {
      GroupDBISAR? groupDBDB = Groups.sharedInstance.groups[messageDB.groupId];
      name = groupDBDB?.name ?? messageDB.groupId;
    }
    return name;
  }

  static String _getPicUrl(MessageDBISAR messageDB){
    String picUrl = '';
    if (messageDB.chatType == ChatType.chatChannel) {
      ChannelDBISAR? channelDB = Channels.sharedInstance.channels[messageDB.groupId];
      picUrl = channelDB?.picture ?? '';
    } else {
      GroupDBISAR? groupDBDB = Groups.sharedInstance.groups[messageDB.groupId];
      picUrl = groupDBDB?.picture ?? '';
    }
    return picUrl;
  }
}