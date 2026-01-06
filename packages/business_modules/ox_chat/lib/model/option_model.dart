import 'package:ox_chat/model/search_chat_model.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_localizable/ox_localizable.dart';

///Title: option_model
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/5/26 17:13
enum OptionModel {
  AddGroup,
  AddHotGroup,
  AddFriend,
  ScanQCode,
  ShareIDCard,
  RecommenderTools,
  CheckNetworkConfig,
  NewChannel,
}

enum ChatHistoryForNewMembersType{
  show,
  hidden,
}

extension ChatHistoryForNewMembersTypeEx on ChatHistoryForNewMembersType{
  String get text {
    switch (this) {
      case ChatHistoryForNewMembersType.show:
        return 'str_chat_history_for_new_members_show'.localized();
      case ChatHistoryForNewMembersType.hidden:
        return 'str_chat_history_for_new_members_hidden'.localized();
    }
  }

  String get typeDesc {
    switch (this) {
      case ChatHistoryForNewMembersType.show:
        return 'str_group_show_description'.localized();
      case ChatHistoryForNewMembersType.hidden:
        return 'str_group_hidden_description'.localized();
    }
  }
}

enum GroupType{
  openGroup,
  closeGroup,
  privateGroup,
  privateMLSGroup,
  channel,
}

extension GroupTypeEx on GroupType{
  String get text {
    switch (this) {
      case GroupType.openGroup:
        return 'str_group_type_open'.localized();
      case GroupType.closeGroup:
        return 'str_group_type_close'.localized();
      case GroupType.privateGroup:
        return 'str_group_type_private'.localized();
      case GroupType.privateMLSGroup:
        return 'str_group_type_mls'.localized();
      case GroupType.channel:
        return 'create_channel'.localized();
    }
  }

  String get typeIcon {
    switch (this) {
      case GroupType.openGroup:
        return 'icon_group_open.png';
      case GroupType.closeGroup:
        return 'icon_group_close.png';
      case GroupType.privateGroup:
        return 'icon_group_private.png';
      case GroupType.privateMLSGroup:
        return 'icon_group_private.png';
      case GroupType.channel:
        return 'icon_group_channel.png';
    }
  }

  String get groupDesc {
    switch (this) {
      case GroupType.openGroup:
        return 'str_group_open_description'.localized();
      case GroupType.closeGroup:
        return 'str_group_close_description'.localized();
      case GroupType.privateGroup:
        return 'str_group_private_description'.localized();
      case GroupType.privateMLSGroup:
        return 'str_group_MLS_description'.localized();
      case GroupType.channel:
        return 'str_public_channel_description'.localized();
    }
  }
}
enum GroupMenuType{
  copy,
  share,
}

extension GroupMenuTypeEx on GroupMenuType{
  String get text {
    switch (this) {
      case GroupMenuType.copy:
        return Localized.text('ox_chat.str_group_share_menu_copy');
      case GroupMenuType.share:
        return Localized.text('ox_chat.str_group_share_menu_send_to_friend');
    }
  }
}