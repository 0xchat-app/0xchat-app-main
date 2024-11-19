import 'package:ox_common/utils/chat_prompt_tone.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_theme/ox_theme.dart';

///Title: setting_model
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/12/11 15:30
class SettingModel {
  final String iconName;
  final String title;
  String rightContent;
  final SettingItemType settingItemType;

  SettingModel({
    this.iconName = '',
    this.title = '',
    this.rightContent = '',
    this.settingItemType = SettingItemType.none,
  });

  static List<SettingModel> getItemData(List<SettingModel> settingModelList){
    settingModelList.clear();
    settingModelList.add(SettingModel(
      iconName: 'icon_settings_notification.png',
      title: 'ox_usercenter.notifications',
      rightContent: '',
      settingItemType: SettingItemType.messageNotification,
    ));
    settingModelList.add(SettingModel(
      iconName: 'icon_settings_privacy.png',
      title: 'ox_usercenter.privacy',
      rightContent: '',
      settingItemType: SettingItemType.privacy,
    ));
    // settingModelList.add(SettingModel(
    //   iconName: 'icon_settings_database.png',
    //   title: 'ox_usercenter.str_database',
    //   rightContent: '',
    //   settingItemType: SettingItemType.database,
    // ));
    // settingModelList.add(SettingModel(
    //   iconName: 'icon_settings_relays.png',
    //   title: 'ox_usercenter.relays',
    //   rightContent: '',
    //   settingItemType: SettingItemType.relays,
    // ));
    // settingModelList.add(SettingModel(
    //   iconName: 'icon_settings_zaps.png',
    //   title: 'ox_usercenter.zaps',
    //   rightContent: '',
    //   settingItemType: SettingItemType.zaps,
    // ));
    // settingModelList.add(SettingModel(
    //   iconName: 'icon_settings_nuts.png',
    //   title: 'ox_usercenter.nuts_zaps',
    //   rightContent: '',
    //   settingItemType: SettingItemType.nutsZaps,
    // ));
    settingModelList.add(SettingModel(
      iconName: 'icon_settings_keys.png',
      title: 'ox_usercenter.keys',
      rightContent: '',
      settingItemType: SettingItemType.keys,
    ));
    settingModelList.add(SettingModel(
      iconName: 'icon_settings_file_server.png',
      title: 'ox_usercenter.str_file_server_title',
      rightContent: '',
      settingItemType: SettingItemType.fileServer,
    ));
    settingModelList.add(SettingModel(
      iconName: 'icon_settings_ice_server.png',
      title: 'ox_usercenter.ice_server_title',
      rightContent: '',
      settingItemType: SettingItemType.ice,
    ));
    settingModelList.add(SettingModel(
        iconName: 'icon_settings_chat.png',
        title: 'ox_usercenter.str_settings_chat',
        rightContent: '',
        settingItemType: SettingItemType.chats
    ));
    settingModelList.add(SettingModel(
      iconName: 'icon_settings_language.png',
      title: 'ox_usercenter.language',
      rightContent: Localized.getCurrentLanguage().languageText,
      settingItemType: SettingItemType.language,
    ));
    settingModelList.add(SettingModel(
        iconName: 'icon_settings_Theme.png',
        title: 'ox_usercenter.theme',
        rightContent: ThemeManager.getCurrentThemeStyle().value(),
        settingItemType: SettingItemType.theme
    ));
    settingModelList.add(SettingModel(
        iconName: 'icon_settings_sound.png',
        title: 'ox_usercenter.sound_feedback',
        rightContent: PromptToneManager.sharedInstance.currentSoundTheme.symbol,
        settingItemType: SettingItemType.sound
    ));
    settingModelList.add(SettingModel(
        iconName: 'icon_database_import.png',
        title: 'ox_usercenter.str_data_revovery',
        rightContent: '',
        settingItemType: SettingItemType.dataRevovery
    ));
    settingModelList.add(SettingModel(
        iconName: 'icon_settings_dev_log.png',
        title: 'ox_usercenter.str_dev_log',
        rightContent: '',
        settingItemType: SettingItemType.devLog
    ));
    return settingModelList;
  }
}

enum SettingItemType {
  messageNotification,
  relays,
  zaps,
  nutsZaps,
  keys,
  privacy,
  database,
  fileServer,
  ice,
  language,
  theme,
  sound,
  chats,
  dataRevovery,
  devLog,
  none,
}