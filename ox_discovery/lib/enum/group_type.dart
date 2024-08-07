import 'package:ox_localizable/ox_localizable.dart';

enum GroupType{
  channel,
  openGroup,
  privateGroup,
}

extension GroupTypeEx on GroupType{
  String get text {
    switch (this) {
      case GroupType.openGroup:
        return Localized.text('ox_chat.str_group_type_open');
      case GroupType.privateGroup:
        return Localized.text('ox_chat.str_group_type_private');
      case GroupType.channel:
        return Localized.text('ox_common.str_new_channel');
    }
  }

  String get typeIcon {
    switch (this) {
      case GroupType.openGroup:
        return 'icon_type_open_group.png';
      case GroupType.privateGroup:
        return 'icon_type_private_group.png';
      case GroupType.channel:
        return 'icon_type_channel.png';
    }
  }

  String get groupDesc {
    switch (this) {
      case GroupType.openGroup:
        return Localized.text('ox_chat.str_group_open_description');
      case GroupType.privateGroup:
        return Localized.text('ox_chat.str_group_private_description');
      case GroupType.channel:
        return 'Channel description';
    }
  }
}