import 'package:ox_localizable/ox_localizable.dart';

///Title: search_chat_model
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/2/27 17:05
class ChatMessage {
  String chatId;
  String msgId;
  String name;
  String subtitle;
  String picture;
  int chatType;
  int relatedCount;

  ChatMessage(this.chatId, this.msgId, this.name, this.subtitle, this.picture,
      this.chatType, this.relatedCount);

  @override
  String toString() {
    return 'ChatMessage{chatId: ${chatId}, msgId: $msgId, name: $name, subtitle: $subtitle, picture: $picture, chatType: ${chatType}, relatedCount: $relatedCount}';
  }
}

enum SearchItemType {
  friend,
  channel,
  groups,
  messagesGroup,
  message,
}

enum SearchType {
  chat(label: 'Chats'),
  contact(label: 'Contacts'),
  group(label: 'Groups'),
  channel(label: 'Channels'),
  // ecash(label: 'Ecash'),
  media(label: 'Media');
  // link(label: 'Links');

  final String label;

  const SearchType({required this.label});
}

extension SearchTypeEx on SearchType {
  String getLocalizedLabel() {
    switch (this) {
      case SearchType.chat:
        return Localized.text('ox_chat.str_title_chats');
      case SearchType.contact:
        return Localized.text('ox_chat.str_title_contacts');
      case SearchType.group:
        return Localized.text('ox_chat.str_title_groups');
      case SearchType.channel:
        return Localized.text('ox_chat.str_title_channels');
      case SearchType.media:
        return Localized.text('ox_chat.str_title_media');
    }
  }
}

class Group {
  final String title;
  final SearchItemType type;
  final List items;

  Group({required this.title, required this.type, required this.items});

  @override
  String toString() {
    return 'Group{title: $title, type: $type, items: $items}';
  }
}
