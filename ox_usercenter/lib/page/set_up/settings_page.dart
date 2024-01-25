import 'package:flutter/material.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/model/msg_notification_model.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_chat_observer.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:ox_theme/ox_theme.dart';
import 'package:ox_usercenter/model/setting_model.dart';
import 'package:ox_usercenter/page/set_up/database_setting_page.dart';
import 'package:ox_usercenter/page/set_up/donate_page.dart';
import 'package:ox_usercenter/page/set_up/ice_server_page.dart';
import 'package:ox_usercenter/page/set_up/keys_page.dart';
import 'package:ox_usercenter/page/set_up/language_settings_page.dart';
import 'package:ox_usercenter/page/set_up/message_notification_page.dart';
import 'package:ox_usercenter/page/set_up/privacy_page.dart';
import 'package:ox_usercenter/page/set_up/relays_page.dart';
import 'package:ox_usercenter/page/set_up/theme_settings_page.dart';
import 'package:ox_usercenter/page/set_up/zaps_page.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:chatcore/chat-core.dart';
import 'package:cashu_dart/cashu_dart.dart';
import 'package:ox_common/business_interface/ox_wallet/interface.dart';

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

  Future<bool>? _isShowZapBadge;

  final pubKey = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '';

  @override
  void initState() {
    super.initState();
    OXChatBinding.sharedInstance.addObserver(this);
    _isShowZapBadge = _getZapBadge();
    ThemeManager.addOnThemeChangedCallback(onThemeStyleChange);
    Localized.addLocaleChangedCallback(onLocaleChange);
    _getPackageInfo();
    _settingModelList = SettingModel.getItemData(_settingModelList);
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
        _buildOption(
          title: 'ox_usercenter.wallet',
          iconName: 'icon_settings_wallet.png',
          onTap: () async {
            final isWalletAvailable = OXWalletInterface.isWalletAvailable() ?? false;
            if (isWalletAvailable) {
              await OXModuleService.pushPage(context, 'ox_wallet', 'WalletHomePage', {});
            } else {
              await OXModuleService.pushPage(context, 'ox_wallet', 'WalletPage', {});
            }
          },
        ),
        SizedBox(
          height: Adapt.px(24),
        ),
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
        SizedBox(
          height: Adapt.px(24),
        ),
        _buildOption(
            title: 'ox_usercenter.donate',
            iconName: 'icon_settings_donate.png',
            onTap: () => OXNavigator.pushPage(context, (context) => const DonatePage())),
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

  Widget _itemView(String iconName, String title, String rightContent, bool showDivider,{bool showArrow = true,Widget? badge}) {
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
              trailing: FutureBuilder(
                future: _getZapBadge(),
                builder: (context,snapshot) {
                  final isShowZapBadge = snapshot.data ?? false;
                    return Row(
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
                  );
                }
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
          if(OXChatBinding.sharedInstance.isZapBadge){
            MsgNotification(noticeNum: 0).dispatch(context);
            OXChatBinding.sharedInstance.isZapBadge = false;
            OXCacheManager.defaultOXCacheManager.saveData('$pubKey.zap_badge', false).then((value){
              setState(() {
                _isShowZapBadge = _getZapBadge();
              });
            });
          }
          OXNavigator.pushPage(context, (context) => ZapsPage());
        } else if (_settingModel.settingItemType == SettingItemType.privacy) {
          OXNavigator.pushPage(context, (context) => const PrivacyPage());
        } else if (_settingModel.settingItemType == SettingItemType.database) {
          OXNavigator.pushPage(context, (context) => const DatabaseSettingPage());
        } else if (_settingModel.settingItemType == SettingItemType.language) {
          OXNavigator.pushPage(context, (context) => LanguageSettingsPage());
        } else if (_settingModel.settingItemType == SettingItemType.theme) {
          await OXNavigator.pushPage(context, (context) => ThemeSettingsPage());
        } else if (_settingModel.settingItemType == SettingItemType.ice) {
          OXNavigator.pushPage(context, (context) => ICEServerPage());
        }
      },
      child: _itemView(
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
      ),
    );
  }

  Widget _buildOption({required String title, required String iconName, Function()? onTap}){
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
        child: _itemView(iconName, title, '', false),
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

  Future<bool> _getZapBadge() async {
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

  void _getPackageInfo() {
    String version = '1.0.0';
    PackageInfo.fromPlatform().then((value) {
      version = value.version;

      setState(() {
        _settingModelList.add(SettingModel(
          iconName: 'icon_settings_version.png',
          title: 'ox_usercenter.version',
          rightContent: version,
        ));
      });
    });
  }

  onThemeStyleChange() {
    if (mounted) setState(() {});
  }

  onLocaleChange() {
    if (mounted) setState(() {});
  }

}


