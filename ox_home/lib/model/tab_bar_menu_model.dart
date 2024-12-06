import 'package:ox_common/utils/user_config_tool.dart';

///Title: tab_bar_menu_model
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2024
///@author Michael
///CreateTime: 2024/12/5 18:44
class TabbarMenuModel extends MultipleUserModel{
  final MenuItemType type;
  final String iconPackage;

  TabbarMenuModel({this.type = MenuItemType.userType, this.iconPackage = '', super.pubKey = '', super.name = '', super.picture = '', super.dns = ''});
}

enum MenuItemType{
  userType,
  addUserType,
  markToRead,
  addContact,
  addGroup,
  moveToTop,
  createNewMoment,
  deleteMoments,
}