import 'package:flutter/material.dart';
import 'package:ox_chat/widget/search_result_item.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/model/chat_type.dart';

class SearchResultItemUtils {
  static ValueNotifier? getValueNotifier(SearchResultItem item) {
    ValueNotifier? valueNotifier;
    switch (item.type) {
      case SearchResultItemType.contact:
        valueNotifier = Account.sharedInstance.getUserNotifier(item.pubkey);
        break;
      case SearchResultItemType.channel:
        valueNotifier = Channels.sharedInstance.getChannelNotifier(item.pubkey);
        break;
      case SearchResultItemType.group:
        valueNotifier = Groups.sharedInstance.getPrivateGroupNotifier(item.pubkey);
        break;
      case SearchResultItemType.relayGroup:
        valueNotifier = RelayGroup.sharedInstance.getRelayGroupNotifier(item.pubkey);
        break;
      default:
    }
    return valueNotifier;
  }

  static SearchResultItemType convertSearchResultItemType(int chatType) {
    switch (chatType) {
      case ChatType.chatSingle:
      case ChatType.chatSecret:
        return SearchResultItemType.contact;
      case ChatType.chatChannel:
        return SearchResultItemType.channel;
      case ChatType.chatGroup:
        return SearchResultItemType.group;
      case ChatType.chatRelayGroup:
        return SearchResultItemType.relayGroup;
      default:
        return SearchResultItemType.contact;
    }
  }
}