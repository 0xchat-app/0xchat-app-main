import 'package:cashu_dart/cashu_dart.dart';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/model/msg_notification_model.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/chat_prompt_tone.dart';
import 'package:ox_common/utils/file_utils.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_chat_observer.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/user_config_tool.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_theme/ox_theme.dart';
import 'package:ox_usercenter/model/setting_model.dart';
import 'package:ox_usercenter/page/set_up/chat_setting_page.dart';
import 'package:ox_usercenter/page/set_up/database_setting_page.dart';
import 'package:ox_usercenter/page/set_up/file_server_page.dart';
import 'package:ox_usercenter/page/set_up/ice_server_page.dart';
import 'package:ox_usercenter/page/set_up/keys_page.dart';
import 'package:ox_usercenter/page/set_up/language_settings_page.dart';
import 'package:ox_usercenter/page/set_up/logs_file_page.dart';
import 'package:ox_usercenter/page/set_up/message_notification_page.dart';
import 'package:ox_usercenter/page/set_up/privacy_page.dart';
import 'package:ox_usercenter/page/set_up/relays_page.dart';
import 'package:ox_usercenter/page/set_up/theme_settings_page.dart';
import 'package:ox_usercenter/page/set_up/translate_settings_page.dart';
import 'package:ox_usercenter/page/set_up/zaps_page.dart';
import 'package:ox_usercenter/utils/import_data_tools.dart';
import 'package:ox_usercenter/widget/bottom_sheet_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'nuts_zaps/nuts_zaps_page.dart';

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
  bool _isOpenDevLog = false;
  late String _version = '1.0.0';

  @override
  void initState() {
    super.initState();
    OXChatBinding.sharedInstance.addObserver(this);
    ThemeManager.addOnThemeChangedCallback(onThemeStyleChange);
    Localized.addLocaleChangedCallback(onLocaleChange);
    _loadData();
    _getPackageInfo();
  }

  void _loadData() async {
    _settingModelList = SettingModel.getItemData(_settingModelList);
    _isShowZapBadge = _getZapBadge();
    _isOpenDevLog = UserConfigTool.getSetting(StorageSettingKey.KEY_OPEN_DEV_LOG.name, defaultValue: false);
    setState(() {});
  }

  void _getPackageInfo() {
    PackageInfo.fromPlatform().then((value) {
      _version = value.version;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(16)),
        color: ThemeColor.color180,
      ),
      child: Column(
        children: [
          ListView.builder(
            padding: const EdgeInsets.only(bottom: 0),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: _itemBuild,
            itemCount: _settingModelList.length,
          ),
          Divider(
            height: 0.5.px,
            color: ThemeColor.color160,
          ),
          buildOption(
            title: 'ox_usercenter.version',
            iconName: 'icon_settings_version.png',
            rightContent: _version,
            showArrow: false,
            decoration: const BoxDecoration(),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Future<void> claimEcash() async {
    final balance = await NpubCash.balance();
    if(balance != null && balance > 0){
      OXCommonHintDialog.show(
        context,
        title: Localized.text('ox_usercenter.str_claim_ecash_hint_title'),
        content: Localized.text('ox_usercenter.str_claim_ecash_hint'),
        actionList: [
          OXCommonHintAction.sure(
            text: Localized.text('ox_usercenter.str_claim_ecash_confirm'),
            onTap: () async {
              OXNavigator.pop(context);
              final token = await NpubCash.claim();
              if(token != null){
                OXLoading.show();
                final response = await Cashu.redeemEcash(
                  ecashString: token,
                );
                OXLoading.dismiss();
                CommonToast.instance.show(
                  context,
                  Localized.text(response.isSuccess ? 'ox_usercenter.str_claim_ecash_success' : 'ox_usercenter.str_claim_ecash_fail'),
                );
              }
            },
          ),
        ],
        isRowAction: true,
      );
    }
  }

  Widget _itemBuild(BuildContext context, int index) {
    SettingModel _settingModel = _settingModelList[index];
    if (_settingModel.settingItemType == SettingItemType.language) {
      _settingModel.rightContent = Localized.getCurrentLanguage().languageText;
    }
    if (_settingModel.settingItemType == SettingItemType.theme) {
      _settingModel.rightContent = ThemeManager.getCurrentThemeStyle().value() == ThemeSettingType.light.saveText
          ? Localized.text('ox_usercenter.theme_color_light')
          : Localized.text('ox_usercenter.theme_color_dart');
    }
    if (_settingModel.settingItemType == SettingItemType.sound) {
      _settingModel.rightContent = PromptToneManager.sharedInstance.currentSoundTheme.symbol;
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        switch(_settingModel.settingItemType) {
          case SettingItemType.messageNotification:
            OXNavigator.pushPage(context, (context) => const MessageNotificationPage()).then((value) {
              setState(() {});
            });
            break;
          case SettingItemType.relays:
            OXNavigator.pushPage(context, (context) => const RelaysPage()).then((value) {
              setState(() {});
            });
            break;
          case SettingItemType.keys:
            OXNavigator.pushPage(context, (context) => const KeysPage());
            break;
          case SettingItemType.zaps:
            if (_getZapBadge()) {
              MsgNotification(noticeNum: 0).dispatch(context);
              UserConfigTool.saveSetting(StorageSettingKey.KEY_ZAP_BADGE.name, false).then((value) {
                setState(() {
                  _isShowZapBadge = _getZapBadge();
                });
              });
            }
            claimEcash();
            OXNavigator.pushPage(context, (context) => const ZapsPage());
            break;
          case SettingItemType.nutsZaps:
            OXNavigator.pushPage(context, (context) => NutsZapsPage());
            break;
          case SettingItemType.privacy:
            OXNavigator.pushPage(context, (context) => const PrivacyPage());
            break;
          case SettingItemType.database:
            OXNavigator.pushPage(context, (context) => const DatabaseSettingPage());
            break;
          case SettingItemType.language:
            OXNavigator.pushPage(context, (context) => const LanguageSettingsPage());
            break;
          case SettingItemType.theme:
            await OXNavigator.pushPage(context, (context) => const ThemeSettingsPage());
            break;
          case SettingItemType.ice:
            OXNavigator.pushPage(context, (context) => const ICEServerPage());
            break;
          case SettingItemType.dataRevovery:
            final file = await FileUtils.importFile();
            if (file != null) {
              OXLoading.show();
              final success = await ImportDataTools.unzipAndProcessFile(file);
              OXLoading.dismiss();
              if (success) {
                CommonToast.instance.show(context, Localized.text('ox_usercenter.str_import_success'));
              } else {
                CommonToast.instance.show(context, Localized.text('ox_usercenter.str_import_failure'));
              }
            }
            break;
          case SettingItemType.devLog:
            if (_isOpenDevLog) OXNavigator.pushPage(context, (context) => const LogsFilePage());
            break;
          case SettingItemType.fileServer:
            OXNavigator.pushPage(context, (context) => const FileServerPage());
            break;
          case SettingItemType.sound:
            List<BottomSheetItem> items = SoundTheme.values
                .map((theme) => BottomSheetItem(
                    title: theme.symbol,
                    onTap: () {
                      PromptToneManager.sharedInstance.currentSoundTheme = theme;
                      UserConfigTool.saveSetting(StorageSettingKey.KEY_SOUND_THEME.name, theme.id);
                      setState(() {});
                    })).toList();
            BottomSheetDialog.showBottomSheet(context, items);
            break;
          case SettingItemType.chats:
            OXNavigator.pushPage(context, (context) => const ChatSettingPage());
            break;
          case SettingItemType.translate:
            OXNavigator.pushPage(context, (context) => const TranslateSettingsPage());
            break;
          case SettingItemType.none:
            // TODO: Handle this case.
            break;
        }
      },
      child: itemView(
        _settingModel.iconName,
        _settingModel.title,
        _settingModel.rightContent,
        index == _settingModelList.length - 1 ? false : true,
        showArrow: _settingModel.settingItemType == SettingItemType.none ? false : true,
        badge: _settingModel.settingItemType == SettingItemType.zaps ? _buildZapBadgeWidget() : Container(),
        isShowZapBadge: _isShowZapBadge,
        devLogWidget: _settingModel.settingItemType == SettingItemType.devLog ? _devLogWidget() : null,
      ),
    );
  }

  @override
  void didZapRecordsCallBack(ZapRecordsDBISAR zapRecordsDB, {Function? onValue}) {
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
    return UserConfigTool.getSetting(StorageSettingKey.KEY_ZAP_BADGE.name, defaultValue: false);
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

  Widget _devLogWidget() {
    return Switch(
      value: _isOpenDevLog,
      activeColor: Colors.white,
      activeTrackColor: ThemeColor.gradientMainStart,
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: ThemeColor.color160,
      onChanged: (value) => _changeOpenDevLogFn(value),
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
  }

  Future<void> _changeOpenDevLogFn(bool value) async {
    _isOpenDevLog = value;
    UserConfigTool.saveSetting(StorageSettingKey.KEY_OPEN_DEV_LOG.name, value);
    setState(() {});
  }

  onThemeStyleChange() {
    if (mounted) setState(() {});
  }

  onLocaleChange() {
    if (mounted) setState(() {});
  }

}

Widget buildOption({required String title, required String iconName, String rightContent = '', bool showArrow = true, Function()? onTap, Decoration? decoration}){
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: onTap,
    child: Container(
      width: double.infinity,
      decoration: decoration ?? BoxDecoration(
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
      child: itemView(iconName, title, rightContent, false, showArrow: showArrow),
    ),
  );
}


Widget itemView(String iconName, String title, String rightContent, bool showDivider,{bool showArrow = true,Widget? badge, bool isShowZapBadge = false, Widget? devLogWidget}) {
  return Column(
    children: [
      Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 10.px),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CommonImage(
                  iconName: iconName,
                  width: Adapt.px(32),
                  height: Adapt.px(32),
                  package: 'ox_usercenter',
                ),
                SizedBox(width: 12.px),
                Container(
                  constraints: BoxConstraints(maxWidth: Adapt.screenW / (rightContent.isEmpty || badge == null ? 2 : 3)),
                  child: Text(
                    Localized.text(title),
                    style: TextStyle(
                      color: ThemeColor.color0,
                      fontSize: Adapt.px(16),
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Container(
              child: devLogWidget ?? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  isShowZapBadge ? badge ?? const SizedBox() : const SizedBox(),
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
              ),
            ),
          ],
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

