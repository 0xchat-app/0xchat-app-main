import 'package:ox_chat/utils/widget_tool.dart';

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


enum GroupType{
  openGroup,
  closeGroup,
  privateGroup,
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
    }
  }


}