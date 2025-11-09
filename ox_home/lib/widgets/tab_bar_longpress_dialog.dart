import 'package:flutter/material.dart';
import 'package:ox_common/business_interface/ox_chat/interface.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_home/model/home_tabbar_type.dart';
import 'package:ox_home/model/tab_bar_menu_model.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';

///Title: tab_bar_longpress_dialog
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2024
///@author Michael
///CreateTime: 2024/12/5 18:34
class TabBarLongPressDialog {
  double _dialogItemWidth = 180.px;
  TabbarMenuModel? currentUser;
  List<HomeTabBarType> typeList;
  double horizontalPadding;
  List<TabbarMenuModel> userCacheList;

  TabBarLongPressDialog({required this.currentUser, required this.userCacheList, required this.typeList, required this.horizontalPadding});


  void showPopupDialog(BuildContext context, int index, List<GlobalKey> navItemKeyList, Widget tabbarItemWidget) async {

    final RenderBox renderBox =
    navItemKeyList[index].currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    List<TabbarMenuModel> menuList = _getMenuList(index);
    if (menuList.isEmpty) return;
    double leftPosition = _calculateDialogPosition(context, index, position, renderBox);
    double screenHeight = MediaQuery.of(context).size.height;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (context, animation, secondaryAnimation) {
        return StatefulBuilder(builder: (context, setState){
          return Stack(
            children: [
              Positioned(
                top: position.dy,
                left: position.dx,
                child: Material(
                  color: Colors.transparent,
                  child: tabbarItemWidget,
                ),
              ),
              Positioned(
                bottom: screenHeight - position.dy + 4.px + (typeList.elementAt(index) == HomeTabBarType.me ? 46.px : 0),
                left: leftPosition,
                child: Container(
                  width: _dialogItemWidth,
                  height: menuList.length * 44.px,
                  constraints: BoxConstraints(maxHeight: screenHeight/2),
                  decoration: BoxDecoration(
                    color: ThemeColor.color180,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.px),
                        topRight: Radius.circular(16.px),
                        bottomLeft: Radius.circular(typeList.elementAt(index) == HomeTabBarType.me ? 0 : 16.px),
                        bottomRight: Radius.circular(typeList.elementAt(index) == HomeTabBarType.me ? 0 : 16.px)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8.px,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: menuList.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, menuIndex) {
                      TabbarMenuModel? model;
                      if (menuList.isNotEmpty && menuIndex > -1) {
                        model = menuList[menuIndex];
                      }
                      return _menuItemView(context, index, model);
                    },
                  ),

                ),
              ),
              Visibility(
                visible: typeList.elementAt(index) == HomeTabBarType.me,
                child: Positioned(
                  bottom: screenHeight - position.dy + 4.px,
                  left: leftPosition,
                  child: Container(
                    width: _dialogItemWidth,
                    height: 46.px,
                    constraints: BoxConstraints(maxHeight: screenHeight/2),
                    decoration: BoxDecoration(
                      color: ThemeColor.color180,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16.px),
                          bottomRight: Radius.circular(16.px)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8.px,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(height: 2.px, color: ThemeColor.color200),
                        _menuItemView(context, typeList.indexOf(HomeTabBarType.me), currentUser),
                      ],
                    ),),
                ),
              ),
            ],
          );
        });
      },
    );
  }

  Widget _menuItemView(BuildContext context, int index, TabbarMenuModel? model){
    final optionType = model?.type;
    String showName = model?.name ?? '';
    String showPicture = model?.picture ?? '';
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (model != null) {
          _menuOnTap(context, model);
        }
      },
      child: Container(
        height: 44.px,
        padding: EdgeInsets.symmetric(horizontal: 16.px),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              showName,
              style: TextStyle(
                fontSize: 16.px,
                color: optionType == MenuItemType.deleteMoments
                    ? ThemeColor.red
                    : ThemeColor.color100,
                fontWeight: FontWeight.w500,
              ),
            ),
            typeList.elementAt(index) == HomeTabBarType.me
                ? (showName == Localized.text('ox_usercenter.str_add_account')
                ? CommonImage(
              iconName: 'add_circle_icon.png',
              size: 24.px,
              package: 'ox_common',
              useTheme: true,
            )
                : OXUserAvatar(
                imageUrl: showPicture, size: 24.px))
                : CommonImage(
                iconName: model?.picture ?? '',
                size: optionType == MenuItemType.addContact || optionType == MenuItemType.addGroup ? 18.px : 24.px,
                color: optionType == MenuItemType.deleteMoments
                    ? ThemeColor.red
                    : ThemeColor.color100,
                package: model?.iconPackage).setPadding(EdgeInsets.only(right: model != null && (model.type == MenuItemType.addContact || model.type == MenuItemType.addGroup) ? 6.px : 0)),
          ],
        ),
      ),
    );
  }

  double _calculateDialogPosition(BuildContext context, int index, Offset position, RenderBox renderBox) {
    final size = renderBox.size;
    final currentWidth = size.width;
    double dialogOffset;
    if (index == 0) {
      dialogOffset = horizontalPadding;
    } else if (typeList.length - 1 == index) {
      dialogOffset = Adapt.screenW - _dialogItemWidth - horizontalPadding;
    } else {
      dialogOffset = position.dx + currentWidth / 2 - _dialogItemWidth / 2;
    }
    return dialogOffset;
  }

  List<TabbarMenuModel> _getMenuList(int index) {
    HomeTabBarType tabBarType = typeList.elementAt(index);
    List<TabbarMenuModel> list = [];
    switch(tabBarType){
      case HomeTabBarType.contact:
        list.add(TabbarMenuModel(type: MenuItemType.addContact, name: Localized.text('ox_common.str_add_friend'), picture: 'icon_new_friend.png', iconPackage: 'ox_common'));
        list.add(TabbarMenuModel(type: MenuItemType.addGroup, name: Localized.text('ox_chat.str_new_group'), picture: 'icon_new_group.png', iconPackage: 'ox_common'));
        break;
      case HomeTabBarType.home:
        int unReadCount = OXChatBinding.sharedInstance.getAllSessionUnReadCount();
        if (unReadCount > 0) {
          list.add(TabbarMenuModel(type: MenuItemType.markToRead, name: Localized.text('ox_chat.str_all_chats_mark_as_read'), picture: 'icon_chat_mark_as_read.png', iconPackage: 'ox_chat'));
        }
        break;
      case HomeTabBarType.me:
        list = userCacheList.toList();
        break;
      case HomeTabBarType.discover:
        list.add(TabbarMenuModel(type: MenuItemType.createNewMoment,  name: Localized.text('ox_discovery.new_moments_title'), picture: 'icon_moments_new_moment.png', iconPackage: 'ox_chat'));
        break;
    }

    return list;
  }

  void _menuOnTap(BuildContext context, TabbarMenuModel model) async {
    OXNavigator.pop(context);
    switch(model.type) {
      case MenuItemType.userType:
        String pubKey = model.pubKey;
        if (pubKey.isEmpty) {
          CommonToast.instance.show(context, 'PubKey is empty, try other.');
          return;
        }
        if (pubKey == OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey) {
          return;
        }
        await OXLoading.show();
        await OXUserInfoManager.sharedInstance.switchAccount(pubKey);
        await OXLoading.dismiss();
        break;
      case MenuItemType.addUserType:
        OXModuleService.pushPage(context, 'ox_login', 'LoginPage', {});
        break;
      case MenuItemType.markToRead:
        OXChatBinding.sharedInstance.setAllSessionToReaded();
        break;
      case MenuItemType.addContact:
        OXChatInterface.addContact(context);
        break;
      case MenuItemType.addGroup:
        OXChatInterface.addGroup(context);
        break;
      case MenuItemType.createNewMoment:
        if (OXUserInfoManager.sharedInstance.isLogin) {
          OXModuleService.pushPage(
            context,
            'ox_discovery',
            'CreateMomentsPage',
            null,
          );
        }
        break;
      case MenuItemType.moveToTop:
        // Removed: move tab functionality
        break;
      case MenuItemType.deleteMoments:
        // Removed: delete moments functionality
        break;
    }
  }
}