import 'package:flutter/material.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';


extension OXLanguageType on LocaleType {
  String get languageText {
    switch (this) {
      case LocaleType.zh:
        return Localized.text('ox_usercenter.language_zh');
      case LocaleType.en:
        return Localized.text('ox_usercenter.language_en');
      case LocaleType.es:
        return Localized.text('ox_usercenter.language_es');
      case LocaleType.ru:
        return Localized.text('ox_usercenter.language_ru');
      case LocaleType.pt:
        return Localized.text('ox_usercenter.language_pt');
      case LocaleType.vi:
        return Localized.text('ox_usercenter.language_vi');
      case LocaleType.ja:
        return Localized.text('ox_usercenter.language_ja');
      case LocaleType.fr:
        return Localized.text('ox_usercenter.language_fr');
      case LocaleType.de:
        return Localized.text('ox_usercenter.language_de');
      case LocaleType.ar:
        return Localized.text('ox_usercenter.language_ar');
      case LocaleType.th:
        return Localized.text('ox_usercenter.language_th');
      case LocaleType.ko:
        return Localized.text('ox_usercenter.language_ko');
      case LocaleType.zh_tw:
        return Localized.text('ox_usercenter.language_zh_tw');
    }
  }
}

class LanguageSettingsPage extends StatefulWidget {
  const LanguageSettingsPage({super.key});

  @override
  State<LanguageSettingsPage> createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends State<LanguageSettingsPage> {

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _getCurrentLocaleType();
  }

  void _getCurrentLocaleType() async {
    String currentLanguage = await OXCacheManager.defaultOXCacheManager.getData('userLanguage') as String;
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
          _selectedIndex = selectedIndex;
        });
        await Localized.changeLocale(LocaleType.values[selectedIndex]);
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
            _selectedIndex == index ? CommonImage(
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
}
