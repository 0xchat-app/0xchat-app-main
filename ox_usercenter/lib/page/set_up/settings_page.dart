import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_usercenter/page/set_up/donate_page.dart';
import 'package:ox_usercenter/page/set_up/keys_page.dart';
import 'package:ox_usercenter/page/set_up/message_notification_page.dart';
import 'package:ox_usercenter/page/set_up/relays_page.dart';
import 'package:ox_usercenter/page/set_up/zaps_page.dart';
import 'package:chatcore/chat-core.dart';

///Title: settings_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/5/4 15:20
class SettingsPage extends StatefulWidget {
  SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  late List<SettingModel> _settingModelList = [];

  @override
  void initState() {
    super.initState();
    _settingModelList.add(SettingModel(
      iconName: 'icon_mute.png',
      title: 'Notifications',
      rightContent: '',
      settingItemType: SettingItemType.messageNotification,
    ));
    _settingModelList.add(SettingModel(
      iconName: 'icon_settings_relays.png',
      title: 'Relays',
      rightContent: '',
      settingItemType: SettingItemType.relays,
    ));
    _settingModelList.add(SettingModel(
      iconName: 'icon_settings_zaps.png',
      title: 'Zaps',
      rightContent: '',
      settingItemType: SettingItemType.zaps,
    ));
    _settingModelList.add(SettingModel(
      iconName: 'icon_settings_keys.png',
      title: 'Keys',
      rightContent: '',
      settingItemType: SettingItemType.keys,
    ));
    _settingModelList.add(SettingModel(
      iconName: 'icon_settings_version.png',
      title: 'Version',
      rightContent: '1.23',
    ));
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            OXNavigator.pushPage(context, (context) => DonatePage());
          },
          child: Container(
            width: double.infinity,
            height: Adapt.px(52),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  ThemeColor.gradientMainEnd.withOpacity(0.24),
                  ThemeColor.gradientMainStart.withOpacity(0.24),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: _itemView('icon_settings_donate.png', 'Donate', '', false),
          ),
        ),
        SizedBox(
          height: Adapt.px(24),
        ),
        Container(
          height: Adapt.px(52 * 4 + 0.5 * 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Adapt.px(16)),
            color: ThemeColor.color180,
          ),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: _itemBuild,
            itemCount: _settingModelList.length,
          ),
        ),
        SizedBox(
          height: Adapt.px(24),
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            _logout();
          },
          child: Container(
            width: double.infinity,
            height: Adapt.px(48),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: ThemeColor.color180,
            ),
            alignment: Alignment.center,
            child: Text(
              'Sign out',
              style: TextStyle(
                color: Colors.white,
                fontSize: Adapt.px(15),
              ),
            ),
          ),
        ),
        SizedBox(
          height: Adapt.px(24),
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            _deleteAccountHandler();
          },
          child: Container(
            width: double.infinity,
            height: Adapt.px(48),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: ThemeColor.color180,
            ),
            alignment: Alignment.center,
            child: Text(
              'Delete Account',
              style: TextStyle(
                color: ThemeColor.red1,
                fontSize: Adapt.px(15),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _itemView(String iconName, String title, String rightContent, bool showDivider) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: Adapt.px(52),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: Adapt.px(16)),
            leading: CommonImage(
              iconName: iconName,
              width: Adapt.px(32),
              height: Adapt.px(32),
              package: iconName == 'icon_mute.png' ? 'ox_common' : 'ox_usercenter',
            ),
            title: Text(
              title,
              style: TextStyle(
                color: ThemeColor.color0,
                fontSize: Adapt.px(16),
              ),
            ),
            trailing: rightContent.isNotEmpty
                ? Text(
                    rightContent,
                    style: TextStyle(
                      color: ThemeColor.color100,
                      fontSize: Adapt.px(16),
                    ),
                  )
                : CommonImage(
                    iconName: 'icon_arrow_more.png',
                    width: Adapt.px(24),
                    height: Adapt.px(24),
                  ),
          ),
        ),
        showDivider
            ? Divider(
                height: Adapt.px(0.5),
                color: ThemeColor.color160,
              )
            : Container(),
      ],
    );
  }

  Widget _itemBuild(BuildContext context, int index) {
    SettingModel _settingModel = _settingModelList[index];
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (_settingModel.settingItemType == SettingItemType.messageNotification) {
          OXNavigator.pushPage(context, (context) => MessageNotificationPage()).then((value) {
            setState(() {});
          });
        } else if (_settingModel.settingItemType == SettingItemType.relays) {
          OXNavigator.pushPage(context, (context) => RelaysPage()).then((value) {
            setState(() {});
          });
        } else if (_settingModel.settingItemType == SettingItemType.keys) {
          OXNavigator.pushPage(context, (context) => KeysPage());
        } else if (_settingModel.settingItemType == SettingItemType.zaps) {
          OXNavigator.pushPage(context, (context) => ZapsPage());
        }
      },
      child: _itemView(_settingModel.iconName, _settingModel.title, _settingModel.rightContent, index == _settingModelList.length - 1 ? false : true),
    );
  }

  void _logout() async {
    OXCommonHintDialog.show(context,
        title: 'Warning',
        content: "Make sure you've backed up your private key. Otherwise, you risk losing access to your account.",
        actionList: [
          OXCommonHintAction.cancel(onTap: () {
            OXNavigator.pop(context);
          }),
          OXCommonHintAction.sure(
              text: Localized.text('ox_common.confirm'),
              onTap: () async {
                OXNavigator.pop(context);
                await OXLoading.show();
                await OXUserInfoManager.sharedInstance.logout();
                await OXLoading.dismiss();
              }),
        ],
        isRowAction: true);
  }

  void _deleteAccountHandler() {
    OXCommonHintDialog.show(context,
      title: 'Warning',
      content: 'This will sign an event that deletes this account.\n\nyou will no loger be able to log into 0xchat using this account key.\n\nAre you sure you want to continue?',
      actionList: [
        OXCommonHintAction.cancel(onTap: () {
          OXNavigator.pop(context);
        }),
        OXCommonHintAction.sure(
          text: Localized.text('ox_common.confirm'),
          onTap: () async {
            OXNavigator.pop(context);
            showDeleteAccountDialog();
          },
        ),
      ],
      isRowAction: true,
    );
  }

  void showDeleteAccountDialog() {
    String userInput = '';
    final matchWord = 'DELETE';
    OXCommonHintDialog.show(
      context,
      title: 'Permanently delete account',
      contentView: TextField(
        onChanged: (value) {
          userInput = value;
        },
        decoration: InputDecoration(hintText: 'Type $matchWord to delete'),
      ),
      actionList: [
        OXCommonHintAction.cancel(onTap: () {
          OXNavigator.pop(context);
        }),
        OXCommonHintAction(
          text: () => 'Delete',
          style: OXHintActionStyle.red,
          onTap: () async {
            OXNavigator.pop(context);
            if (userInput == matchWord) {
              await OXLoading.show();
              await OXUserInfoManager.sharedInstance.logout();
              await OXLoading.dismiss();
            }
            OXNavigator.pop(context);
          },
        ),
      ],
      isRowAction: true,
    );
  }

}

class SettingModel {
  final String iconName;
  final String title;
  final String rightContent;
  final SettingItemType settingItemType;

  SettingModel({
    this.iconName = '',
    this.title = '',
    this.rightContent = '',
    this.settingItemType = SettingItemType.relays,
  });
}

enum SettingItemType {
  messageNotification,
  relays,
  zaps,
  keys,
}
