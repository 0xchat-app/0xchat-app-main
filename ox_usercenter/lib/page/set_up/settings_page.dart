import 'package:flutter/material.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/model/msg_notification_model.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_chat_observer.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_theme/ox_theme.dart';
import 'package:ox_usercenter/model/setting_model.dart';
import 'package:ox_usercenter/page/set_up/database_setting_page.dart';
import 'package:ox_usercenter/page/set_up/ice_server_page.dart';
import 'package:ox_usercenter/page/set_up/keys_page.dart';
import 'package:ox_usercenter/page/set_up/language_settings_page.dart';
import 'package:ox_usercenter/page/set_up/logs_file_page.dart';
import 'package:ox_usercenter/page/set_up/message_notification_page.dart';
import 'package:ox_usercenter/page/set_up/privacy_page.dart';
import 'package:ox_usercenter/page/set_up/relays_page.dart';
import 'package:ox_usercenter/page/set_up/theme_settings_page.dart';
import 'package:ox_usercenter/page/set_up/zaps_page.dart';
import 'package:ox_usercenter/utils/widget_tool.dart';
import 'package:chatcore/chat-core.dart';

///Title: settings_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/5/4 15:20
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> with OXChatObserver {
  late List<SettingModel> _settingModelList = [];
  bool _isShowZapBadge = false;
  final pubKey = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '';

  @override
  void initState() {
    super.initState();
    OXChatBinding.sharedInstance.addObserver(this);
    ThemeManager.addOnThemeChangedCallback(onThemeStyleChange);
    Localized.addLocaleChangedCallback(onLocaleChange);
    _loadData();
  }

  void _loadData() async {
    _settingModelList = SettingModel.getItemData(_settingModelList);
    _isShowZapBadge = _getZapBadge();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'str_settings'.localized(),
        backgroundColor: ThemeColor.color200,
      ),
      backgroundColor: ThemeColor.color200,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.px, vertical: 12.px),
        child: _body(),
      ),
    );
  }

  Widget _body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Adapt.px(16)),
            color: ThemeColor.color180,
          ),
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 0),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: _itemBuild,
            itemCount: _settingModelList.length,
          ),
        ),
        SizedBox(height: Adapt.px(24),),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async {
            //TODO show Tor dialog
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
              'str_tor_orbot_setup'.localized(),
              style: TextStyle(
                color: ThemeColor.color0,
                fontSize: Adapt.px(15),
              ),
            ),
          ),
        ),
        SizedBox(height: Adapt.px(24),),
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
              Localized.text('ox_usercenter.sign_out'),
              style: TextStyle(
                color: ThemeColor.color0,
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
              Localized.text('ox_usercenter.delete_account'),
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

  Widget _itemBuild(BuildContext context, int index) {
    SettingModel _settingModel = _settingModelList[index];
    if(_settingModel.settingItemType == SettingItemType.language){
      _settingModel.rightContent = Localized.getCurrentLanguage().languageText;
    }
    if( _settingModel.settingItemType == SettingItemType.theme){
      _settingModel.rightContent = ThemeManager.getCurrentThemeStyle().value() == ThemeSettingType.light.saveText ? Localized.text('ox_usercenter.theme_color_light') : Localized.text('ox_usercenter.theme_color_dart');
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async{
        if (_settingModel.settingItemType == SettingItemType.messageNotification) {
          OXNavigator.pushPage(context, (context) => const MessageNotificationPage()).then((value) {
            setState(() {});
          });
        } else if (_settingModel.settingItemType == SettingItemType.relays) {
          OXNavigator.pushPage(context, (context) => const RelaysPage()).then((value) {
            setState(() {});
          });
        } else if (_settingModel.settingItemType == SettingItemType.keys) {
          OXNavigator.pushPage(context, (context) => const KeysPage());
        } else if (_settingModel.settingItemType == SettingItemType.zaps) {
          if(OXChatBinding.sharedInstance.isZapBadge){
            MsgNotification(noticeNum: 0).dispatch(context);
            OXChatBinding.sharedInstance.isZapBadge = false;
            OXCacheManager.defaultOXCacheManager.saveData('$pubKey.zap_badge', false).then((value){
              setState(() {
                _isShowZapBadge = _getZapBadge();
              });
            });
          }
          OXNavigator.pushPage(context, (context) => const ZapsPage());
        } else if (_settingModel.settingItemType == SettingItemType.privacy) {
          OXNavigator.pushPage(context, (context) => const PrivacyPage());
        } else if (_settingModel.settingItemType == SettingItemType.database) {
          OXNavigator.pushPage(context, (context) => const DatabaseSettingPage());
        } else if (_settingModel.settingItemType == SettingItemType.language) {
          OXNavigator.pushPage(context, (context) => const LanguageSettingsPage());
        } else if (_settingModel.settingItemType == SettingItemType.theme) {
          await OXNavigator.pushPage(context, (context) => const ThemeSettingsPage());
        } else if (_settingModel.settingItemType == SettingItemType.ice) {
          OXNavigator.pushPage(context, (context) => const ICEServerPage());
        } else if (_settingModel.settingItemType == SettingItemType.devLog) {
          OXNavigator.pushPage(context, (context) => const LogsFilePage());
        }
      },
      child: itemView(
        _settingModel.iconName,
        _settingModel.title,
        _settingModel.rightContent,
        index == _settingModelList.length - 1 ? false : true,
        showArrow: _settingModel.settingItemType == SettingItemType.none
            ? false
            : true,
        badge: _settingModel.settingItemType == SettingItemType.zaps
            ? _buildZapBadgeWidget()
            : Container(),
        isShowZapBadge : _isShowZapBadge,
      ),
    );
  }

  @override
  void didZapRecordsCallBack(ZapRecordsDB zapRecordsDB,{Function? onValue}) {
    super.didZapRecordsCallBack(zapRecordsDB);
    setState(() {
      _isShowZapBadge = _getZapBadge();
    });
  }

  @override
  void dispose() {
    super.dispose();
    OXChatBinding.sharedInstance.removeObserver(this);
  }

  bool _getZapBadge() {
    return OXChatBinding.sharedInstance.isZapBadge;
  }

  Widget _buildZapBadgeWidget(){
    return Container(
      color: Colors.transparent,
      width: Adapt.px(6),
      height: Adapt.px(6),
      child: const Image(
        image: AssetImage("assets/images/unread_dot.png"),
      ),
    );
  }

  void _logout() async {
    OXCommonHintDialog.show(context,
        title: Localized.text('ox_usercenter.warn_title'),
        content: Localized.text('ox_usercenter.sign_out_dialog_content'),
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
                OXNavigator.pop(context);
                await OXLoading.dismiss();
              }),
        ],
        isRowAction: true);
  }

  void _deleteAccountHandler() {
    OXCommonHintDialog.show(context,
      title: Localized.text('ox_usercenter.warn_title'),
      content: Localized.text('ox_usercenter.delete_account_dialog_content'),
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
    const matchWord = 'DELETE';
    OXCommonHintDialog.show(
      context,
      title: 'Permanently delete account',
      contentView: TextField(
        onChanged: (value) {
          userInput = value;
        },
        decoration: const InputDecoration(hintText: 'Type $matchWord to delete'),
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

  onThemeStyleChange() {
    if (mounted) setState(() {});
  }

  onLocaleChange() {
    if (mounted) setState(() {});
  }

}

Widget buildOption({required String title, required String iconName, Function()? onTap}){
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: onTap,
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
      child: itemView(iconName, title, '', false),
    ),
  );
}


Widget itemView(String iconName, String title, String rightContent, bool showDivider,{bool showArrow = true,Widget? badge, bool isShowZapBadge = false}) {
  return Column(
    children: [
      Container(
        width: double.infinity,
        height: Adapt.px(52),
        alignment: Alignment.center,
        child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: Adapt.px(16)),
            leading: CommonImage(
              iconName: iconName,
              width: Adapt.px(32),
              height: Adapt.px(32),
              package: iconName == 'icon_mute.png' ? 'ox_common' : 'ox_usercenter',
            ),
            title: Text(
              Localized.text(title),
              style: TextStyle(
                color: ThemeColor.color0,
                fontSize: Adapt.px(16),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                isShowZapBadge ? badge ?? Container() : Container(),
                Text(
                  rightContent,
                  style: TextStyle(
                    color: ThemeColor.color100,
                    fontSize: Adapt.px(16),
                  ),
                ),
                showArrow ? CommonImage(
                  iconName: 'icon_arrow_more.png',
                  width: Adapt.px(24),
                  height: Adapt.px(24),
                ) : Container(),
              ],
            )),
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

