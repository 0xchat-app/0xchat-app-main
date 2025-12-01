import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/platform_utils.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/user_config_tool.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_usercenter/widget/bottom_sheet_dialog.dart';

enum TranslateService {
  libreTranslate,
}

class TranslateSettingsPage extends StatefulWidget {
  const TranslateSettingsPage({super.key});

  @override
  State<TranslateSettingsPage> createState() => _TranslateSettingsPageState();
}

class _TranslateSettingsPageState extends State<TranslateSettingsPage> {
  TranslateService _selectedService = TranslateService.libreTranslate;
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _apiKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    // Load saved settings
    final serviceIndex = UserConfigTool.getSetting(
      StorageSettingKey.KEY_TRANSLATE_SERVICE.name,
      defaultValue: 0,
    ) as int;
    _selectedService = TranslateService.values[serviceIndex.clamp(0, TranslateService.values.length - 1)];

    final savedUrl = UserConfigTool.getSetting(
      StorageSettingKey.KEY_TRANSLATE_URL.name,
      defaultValue: '',
    ) as String;
    _urlController.text = savedUrl;

    _apiKeyController.text = UserConfigTool.getSetting(
      StorageSettingKey.KEY_TRANSLATE_API_KEY.name,
      defaultValue: '',
    ) as String;

    setState(() {});
  }

  void _saveSettings() {
    UserConfigTool.saveSetting(
      StorageSettingKey.KEY_TRANSLATE_SERVICE.name,
      _selectedService.index,
    );
    UserConfigTool.saveSetting(
      StorageSettingKey.KEY_TRANSLATE_URL.name,
      _urlController.text,
    );
    UserConfigTool.saveSetting(
      StorageSettingKey.KEY_TRANSLATE_API_KEY.name,
      _apiKeyController.text,
    );
  }

  String _getServiceName(TranslateService service) {
    switch (service) {
      case TranslateService.libreTranslate:
        return Localized.text('ox_usercenter.translate_service_libretranslate');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        useLargeTitle: false,
        centerTitle: true,
        title: Localized.text('ox_usercenter.translate'),
        backgroundColor: ThemeColor.color190,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: PlatformUtils.listWidth,
          ),
          child: _buildBody().setPadding(
            EdgeInsets.symmetric(horizontal: Adapt.px(24), vertical: Adapt.px(12)),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Localized.text('ox_usercenter.translate'),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: Adapt.px(14),
              color: ThemeColor.color0,
            ),
          ),
          SizedBox(height: Adapt.px(12)),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Adapt.px(16)),
              color: ThemeColor.color180,
            ),
            child: Column(
              children: [
                _buildSelectableItem(
                  Localized.text('ox_usercenter.translate_select_service'),
                  _getServiceName(_selectedService),
                  () => _showServiceSelector(),
                ),
                Divider(height: Adapt.px(0.5), color: ThemeColor.color160),
                _buildTextField(
                  Localized.text('ox_usercenter.translate_url'),
                  _urlController,
                  hintText: '',
                ),
                Divider(height: Adapt.px(0.5), color: ThemeColor.color160),
                _buildTextField(
                  Localized.text('ox_usercenter.translate_api_key'),
                  _apiKeyController,
                  hintText: Localized.text('ox_usercenter.translate_api_key_optional'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectableItem(String title, String content, VoidCallback onTap) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Adapt.px(16), vertical: Adapt.px(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: Adapt.px(16),
                fontWeight: FontWeight.w400,
                color: ThemeColor.color0,
              ),
            ),
            Row(
              children: [
                Text(
                  content,
                  style: TextStyle(
                    fontSize: Adapt.px(16),
                    fontWeight: FontWeight.w400,
                    color: ThemeColor.color100,
                  ),
                ),
                SizedBox(width: Adapt.px(8)),
                CommonImage(
                  iconName: 'icon_arrow_more.png',
                  width: Adapt.px(24),
                  height: Adapt.px(24),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {String? hintText}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(16), vertical: Adapt.px(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: Adapt.px(16),
              fontWeight: FontWeight.w400,
              color: ThemeColor.color0,
            ),
          ),
          SizedBox(height: Adapt.px(8)),
          TextField(
            controller: controller,
            style: TextStyle(
              fontSize: Adapt.px(16),
              color: ThemeColor.color0,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: ThemeColor.color100,
                fontSize: Adapt.px(16),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (value) {
              _saveSettings();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchItem(String title, bool value, ValueChanged<bool> onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(16), vertical: Adapt.px(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: Adapt.px(16),
              fontWeight: FontWeight.w400,
              color: ThemeColor.color0,
            ),
          ),
          Switch(
            value: value,
            activeColor: Colors.white,
            activeTrackColor: ThemeColor.gradientMainStart,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: ThemeColor.color160,
            onChanged: onChanged,
            materialTapTargetSize: MaterialTapTargetSize.padded,
          ),
        ],
      ),
    );
  }

  void _showServiceSelector() {
    List<BottomSheetItem> items = TranslateService.values
        .map((service) => BottomSheetItem(
              title: _getServiceName(service),
              onTap: () {
                setState(() {
                  _selectedService = service;
                  _saveSettings();
                });
              },
            ))
        .toList();
    BottomSheetDialog.showBottomSheet(context, items);
  }

  @override
  void dispose() {
    _urlController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }
}

