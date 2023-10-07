
import 'package:flutter/material.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'dart:ui' as ui;


extension OXLanguageType on LocaleType {
  String get languageText {
    switch (this) {
      case LocaleType.en:
        return 'English';
      case LocaleType.zh:
        return '简体中文';
      case LocaleType.ru:
        return 'русский';
      case LocaleType.fr:
        return 'Français';
      case LocaleType.de:
        return 'Deutsch';
      case LocaleType.es:
        return 'Español';
      case LocaleType.ja:
        return '日本語';
      case LocaleType.ko:
        return '한국어';
      case LocaleType.pt:
        return 'Português';
      case LocaleType.vi:
        return 'Tiếng việt';
      case LocaleType.ar:
        return 'عربي';
      case LocaleType.th:
        return 'ภาษาไทย';
      case LocaleType.zh_tw:
        return '繁體中文(中國台灣)';
      case LocaleType.it:
        return 'Italiano';
      case LocaleType.tu:
        return 'Türkçe';
      case LocaleType.sw:
        return 'Svenska';
      case LocaleType.hu:
        return 'Magyar';
      case LocaleType.du:
        return 'Nederlands';
      case LocaleType.po:
        return 'Polski';
      case LocaleType.gr:
        return 'Ελληνικά';
      case LocaleType.cz:
        return 'čeština';
      case LocaleType.la:
        return 'latviski';
      case LocaleType.az:
        return 'Azərbaycan';
      case LocaleType.uk:
        return 'украї́нська мо́ва';
      case LocaleType.bu:
        return 'български';
      case LocaleType.ind:
        return 'Bahasa Indonesia';
      case LocaleType.est:
        return 'Eesti keel';
      case LocaleType.ta:
        return 'தமிழ்';
      case LocaleType.da:
        return 'Dansk';//
      case LocaleType.ca:
        return 'Català';
    }
  }
}

class LanguageSettingsPage extends StatefulWidget {
  const LanguageSettingsPage({super.key});

  @override
  State<LanguageSettingsPage> createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends State<LanguageSettingsPage> with SingleTickerProviderStateMixin{

  int _selectedIndex = 0;

  late AnimationController _controller;

  bool _isShowLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this,duration: const Duration(milliseconds: 500));
    _getCurrentLocaleType();
  }

  void _getCurrentLocaleType() async {
    String defaultLanguage = ui.window.locale.languageCode;
    String currentLanguage = await OXCacheManager.defaultOXCacheManager.getData('userLanguage',defaultValue: defaultLanguage) as String;
    LocaleType localeType = Localized.getLocaleTypeByString(currentLanguage);
    setState(() {
      _selectedIndex = localeType.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        useLargeTitle: false,
        centerTitle: true,
        title: Localized.text('ox_usercenter.language'),
        backgroundColor: ThemeColor.color190,
      ),
      body: _buildBody().setPadding(EdgeInsets.symmetric(horizontal: Adapt.px(24),vertical: Adapt.px(12))),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Localized.text('ox_usercenter.language_title'),
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: Adapt.px(14)),
        ),
        SizedBox(height: Adapt.px(12),),
        Expanded(child: _buildLanguageList()),
      ],
    );
  }

  Widget _buildLanguageList() {

    final List<String> list = LocaleType.values.map((item) => item.languageText).toList();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(16)),
        color: ThemeColor.color180,
      ),
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: 0),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return _buildItem(list[index],index: index);
        },
        separatorBuilder: (BuildContext context, int index) => Divider(height: Adapt.px(0.5), color: ThemeColor.color160,),
        itemCount: list.length,
      ),
    );
  }

  Widget _buildItem(String label,{int? index}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        final selectedIndex = index ?? 0;
        setState(() {
          _isShowLoading = true;
          _selectedIndex = selectedIndex;
        });
        _controller.repeat();
        await Localized.changeLocale(LocaleType.values[selectedIndex]);
        setState(() {
          _isShowLoading = false;
          _controller.stop();
        });
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
            _isShowLoading && _selectedIndex == index ? RotationTransition(
              turns: _controller,
              child: CommonImage(
                iconName: 'icon_switch_loading.png',
                width: Adapt.px(24),
                height: Adapt.px(24),
                package: 'ox_usercenter',
              ),
            ) : _selectedIndex == index ? CommonImage(
              iconName: 'icon_item_selected.png',
              width: Adapt.px(24),
              height: Adapt.px(24),
              package: 'ox_usercenter',
            ) : Container(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
