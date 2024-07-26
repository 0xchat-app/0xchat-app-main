import 'package:flutter/material.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/model/msg_notification_model.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/file_utils.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_chat_observer.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_theme/ox_theme.dart';
import 'package:ox_usercenter/model/setting_model.dart';
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
import 'package:ox_usercenter/page/set_up/zaps_page.dart';
import 'package:ox_usercenter/utils/import_data_tools.dart';
import 'package:ox_usercenter/utils/widget_tool.dart';
import 'package:chatcore/chat-core.dart';
import 'package:cashu_dart/cashu_dart.dart';

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
  double  fillH = 200;
  bool _isOpenDevLog = false;

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
    fillH = Adapt.screenH() - 60.px - 52.px * _settingModelList.length;
    _isOpenDevLog = await OXCacheManager.defaultOXCacheManager.getForeverData(StorageSettingKey.KEY_OPEN_DEV_LOG.name, defaultValue: false);
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
      body: _body(),
    );
  }

  Widget _body() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Adapt.px(16)),
              color: ThemeColor.color180,
            ),
            margin: EdgeInsets.symmetric(horizontal: 24.px, vertical: 12.px),
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 0),
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: _itemBuild,
              itemCount: _settingModelList.length,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: fillH < Adapt.screenH() ? fillH.abs() : 50.px),
        ),
      ],
    );
  }

  Future<void> claimEcash() async {
    final token = await NpubCash.claim();
    if(token != null){
      OXCommonHintDialog.show(
        context,
        title: Localized.text('ox_usercenter.str_claim_ecash_hint_title'),
        content: Localized.text('ox_usercenter.str_claim_ecash_hint'),
        actionList: [
          OXCommonHintAction.sure(
            text: Localized.text('ox_usercenter.str_claim_ecash_confirm'),
            onTap: () async {
              OXNavigator.pop(context);
              OXLoading.show();
              final response = await Cashu.redeemEcash(
                ecashString: token,
                redeemPrivateKey: [Account.sharedInstance.currentPrivkey],
                signFunction: (key, message) async {
                  return Account.getSignatureWithSecret(message, key);
                },
              );
              OXLoading.dismiss();
              CommonToast.instance.show(
                context,
                Localized.text(response.isSuccess ? 'ox_usercenter.str_claim_ecash_success' : 'ox_usercenter.str_claim_ecash_fail'),
              );
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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
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
          if (OXChatBinding.sharedInstance.isZapBadge) {
            MsgNotification(noticeNum: 0).dispatch(context);
            OXChatBinding.sharedInstance.isZapBadge = false;
            OXCacheManager.defaultOXCacheManager.saveData('$pubKey${StorageSettingKey.KEY_ZAP_BADGE.name}', false).then((value) {
              setState(() {
                _isShowZapBadge = _getZapBadge();
              });
            });
          }
          claimEcash();
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
        } else if (_settingModel.settingItemType == SettingItemType.dataRevovery) {
          final file = await FileUtils.importFile();
          if (file != null) {
            OXLoading.show();
            final success = await ImportDataTools.unzipAndProcessFile(file);
            OXLoading.dismiss();
            if (success) {
              CommonToast.instance.show(context, 'Import successfully');
            } else {
              CommonToast.instance.show(context, 'Import failure');
            }
          }
        } else if (_settingModel.settingItemType == SettingItemType.devLog) {
          if (_isOpenDevLog) OXNavigator.pushPage(context, (context) => const LogsFilePage());
        } else if (_settingModel.settingItemType == SettingItemType.fileServer) {
          OXNavigator.pushPage(context, (context) => const FileServerPage());
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
  void didZapRecordsCallBack(ZapRecordsDB zapRecordsDB, {Function? onValue}) {
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
    await OXCacheManager.defaultOXCacheManager.saveForeverData(StorageSettingKey.KEY_OPEN_DEV_LOG.name, value);
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
      height: Adapt.px(52),
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
            trailing: devLogWidget ?? Row(
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

