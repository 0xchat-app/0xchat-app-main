import 'package:flutter/material.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_moment_manager.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';

///Title: moment_longpress_dialog
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2024
///@author Michael
///CreateTime: 2024/12/2 11:09
class MomentLongPressDialog {
  static final MomentLongPressDialog sharedInstance = MomentLongPressDialog._internal();

  MomentLongPressDialog._internal();

  factory MomentLongPressDialog() {
    return sharedInstance;
  }

  void showPopupDialog(BuildContext context, GlobalKey momentGlobalKey) async {

    final RenderBox renderBox = momentGlobalKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    List<MomentMenuModel> menuList = _getMenuList();
    if (menuList.isEmpty) return;
    double screenHeight = MediaQuery.of(context).size.height;
    final buttonPosition = renderBox.localToGlobal(Offset.zero);
    final buttonSize = renderBox.size;
    double topPosition =  buttonPosition.dy + buttonSize.height;
    double leftPosition = buttonPosition.dx + buttonSize.width - 180.px;

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
                top: topPosition,
                left: leftPosition,
                child: Container(
                  width: 180.px,
                  height: menuList.length * 44.px,
                  constraints: BoxConstraints(maxHeight: screenHeight/2),
                  decoration: BoxDecoration(
                    color: ThemeColor.color180,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.px),
                        topRight: Radius.circular(16.px),
                        bottomLeft: Radius.circular(16.px),
                        bottomRight: Radius.circular( 16.px)),
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
                      MomentMenuModel? model;
                      if (menuList.isNotEmpty && menuIndex > -1) {
                        model = menuList[menuIndex];
                      }
                      return _menuItemView(context, model);
                    },
                  ),

                ),
              ),
            ],
          );
        });
      },
    );
  }

  Widget _menuItemView(BuildContext context, MomentMenuModel? model){
    final optionType = model?.type;
    String showName = model?.type.text ?? '';
    String showPicture = model?.iconName ?? '';
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
                color: optionType == MomentLpMenuType.remove
                    ? ThemeColor.red
                    : ThemeColor.color100,
                fontWeight: FontWeight.w500,
              ),
            ),
            CommonImage(
                iconName: showPicture,
                size:  24.px,
                color: optionType == MomentLpMenuType.remove
                    ? ThemeColor.red
                    : ThemeColor.color100,
                package: model?.iconPackage),
          ],
        ),
      ),
    );
  }

  List<MomentMenuModel> _getMenuList() {
    List<MomentMenuModel> list = [];
    list.add(MomentMenuModel(type: MomentLpMenuType.moveToTabBar,  iconName: 'icon_moments_movedown.png', iconPackage: 'ox_chat'));
    list.add(MomentMenuModel(type: MomentLpMenuType.createNewMoment,  iconName: 'icon_moments_new_moment.png', iconPackage: 'ox_chat'));
    list.add(MomentMenuModel(type: MomentLpMenuType.remove,  iconName: 'icon_chat_delete.png', iconPackage: 'ox_chat'));
    return list;
  }

  void _menuOnTap(BuildContext context, MomentMenuModel model) async {
    OXNavigator.pop(context);
    switch(model.type){
      case MomentLpMenuType.moveToTabBar:
        OXUserInfoManager.sharedInstance.momentPosition = 1;
        OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.APP_MOMENT_POSITION, 1);
        OXMomentManager.sharedInstance.moveToTabBarCallBack();
        break;
      case MomentLpMenuType.createNewMoment:
        if (OXUserInfoManager.sharedInstance.isLogin) {
          OXModuleService.pushPage(
            context,
            'ox_discovery',
            'CreateMomentsPage',
            null,
          );
        }
        break;
      case MomentLpMenuType.remove:
        OXCommonHintDialog.show(OXNavigator.navigatorKey.currentContext!,
            title: Localized.text('ox_chat.str_remove_moments'),
            content: Localized.text('ox_chat.str_remove_moments_hint'),
            actionList: [
              OXCommonHintAction.cancel(onTap: () {
                OXNavigator.pop(OXNavigator.navigatorKey.currentContext!);
              }),
              OXCommonHintAction.sure(
                  text: Localized.text('ox_common.confirm'),
                  onTap: () async {
                    OXNavigator.pop(OXNavigator.navigatorKey.currentContext!);
                    OXUserInfoManager.sharedInstance.momentPosition = 2;
                    OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.APP_MOMENT_POSITION, 2);
                    OXMomentManager.sharedInstance.deleteMomentsCallBack();
                  }),
            ],
            isRowAction: true);
        break;
    }
  }
}

class MomentMenuModel {
  final MomentLpMenuType type;
  final String iconName;
  final String iconPackage;

  MomentMenuModel({this.type = MomentLpMenuType.moveToTabBar, this.iconName = '', this.iconPackage = ''});
}

enum MomentLpMenuType{
  moveToTabBar,
  createNewMoment,
  remove,
}

extension MomentLpMenuTypeEx on MomentLpMenuType{

  String get text {
    switch (this) {
      case MomentLpMenuType.moveToTabBar:
        return 'str_move_to_tabbar'.localized();
      case MomentLpMenuType.createNewMoment:
        return Localized.text('ox_discovery.new_moments_title');
      case MomentLpMenuType.remove:
        return 'str_remove'.localized();
    }
  }
}