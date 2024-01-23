import 'package:flutter/material.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/model/user_config_db.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_theme/ox_theme.dart';
import 'dart:ui' as ui;

enum ThemeSettingType { defaultTheme, dark, light }

extension ThemeSettingTypeText on ThemeSettingType {
  String get text {
    switch (this) {
      case ThemeSettingType.defaultTheme:
        final platformBrightness = ui.window.platformBrightness;
        return Localized.text('ox_usercenter.theme_color_default').replaceAll(r'${theme}', Localized.text(platformBrightness == Brightness.dark ? 'ox_usercenter.theme_color_dart' : 'ox_usercenter.theme_color_light'));
      case ThemeSettingType.dark:
        return Localized.text('ox_usercenter.theme_color_dart');
      case ThemeSettingType.light:
        return Localized.text('ox_usercenter.theme_color_light');
    }
  }

  ThemeStyle get themeStyle {
    switch (this) {
      case ThemeSettingType.defaultTheme:;
        return ui.window.platformBrightness == Brightness.dark ? ThemeStyle.dark : ThemeStyle.light;
      case ThemeSettingType.dark:
        return ThemeStyle.dark;
      case ThemeSettingType.light:
        return ThemeStyle.light;
    }
  }

  String get saveText {
    switch (this) {
      case ThemeSettingType.defaultTheme:
        return '';
      case ThemeSettingType.dark:
        return 'dark';
      case ThemeSettingType.light:
        return 'light';
    }
  }
}

class ThemeSettingsPage extends StatefulWidget {
  const ThemeSettingsPage({super.key});

  @override
  State<ThemeSettingsPage> createState() => _ThemeSettingsPage();
}

class _ThemeSettingsPage extends State<ThemeSettingsPage> {
  ThemeStyle? themeStyle;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _getSelectIndex();
  }

  void _getSelectIndex ()async{
    var getStyle = await OXCacheManager.defaultOXCacheManager.getForeverData('themeSetting',defaultValue: ThemeSettingType.dark.saveText);
    if(getStyle == '') {
      _selectedIndex = 0;
    }
    if(getStyle == 'dark'){
      _selectedIndex = 1;
    }
    if(getStyle == 'light'){
      _selectedIndex = 2;
    }
    setState(() {});

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        useLargeTitle: false,
        centerTitle: true,
        title: Localized.text('ox_usercenter.theme'),
        backgroundColor: ThemeColor.color190,
      ),
      body: _buildBody().setPadding(EdgeInsets.symmetric(
          horizontal: Adapt.px(24), vertical: Adapt.px(12))),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Localized.text('ox_usercenter.theme_color_title'),
            style:
                TextStyle(fontWeight: FontWeight.w600, fontSize: Adapt.px(14)),
          ),
          SizedBox(
            height: Adapt.px(12),
          ),
          _buildLanguageList(),
        ],
      ),
    );
  }

  Widget _buildLanguageList() {
    final List<String> list =
    ThemeSettingType.values.map((item) => item.text).toList();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(16)),
        color: ThemeColor.color180,
      ),
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: 0),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return _buildItem(list[index], index: index);
        },
        separatorBuilder: (BuildContext context, int index) => Divider(
          height: Adapt.px(0.5),
          color: ThemeColor.color160,
        ),
        itemCount: list.length,
      ),
    );
  }

  Widget _buildItem(String label, {int? index}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        final selectedIndex = index ?? 0;
        ThemeManager.changeTheme(ThemeSettingType.values[selectedIndex].themeStyle);
        OXCacheManager.defaultOXCacheManager.saveForeverData('themeSetting', ThemeSettingType.values[selectedIndex].saveText);
        _selectedIndex = selectedIndex;
        UserConfigDB? userConfigDB = await UserConfigTool.getUserConfigFromDB();
        if (userConfigDB != null) {
          userConfigDB.themeIndex = selectedIndex;
          UserConfigTool.updateUserConfigDB(userConfigDB);
        }
        if (mounted) setState(() { });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Adapt.px(16)),
        height: Adapt.px(52),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: Adapt.px(16),
                fontWeight: FontWeight.w400,
                color: ThemeColor.color0,
              ),
            ),
            const Spacer(),
            _selectedIndex == index
                ? CommonImage(
                    iconName: 'icon_item_selected.png',
                    width: Adapt.px(24),
                    height: Adapt.px(24),
                    package: 'ox_usercenter',
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
