import 'package:flutter/material.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:ox_usercenter/utils/widget_tool.dart';
import 'package:ox_usercenter/widget/verify_secure_keypad.dart';

///Title: verify_passcode_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/12/7 18:38
class VerifyPasscodePage extends StatefulWidget {
  final bool needBack;
  const VerifyPasscodePage({
    Key? key,
    this.needBack = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _VerifyPasscodePageState();
  }
}

class _VerifyPasscodePageState extends State<VerifyPasscodePage> {
  String _inputPwd = '';
  String localPasscode = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    localPasscode = await OXCacheManager.defaultOXCacheManager.getForeverData(StorageSettingKey.KEY_PASSCODE.name, defaultValue: '');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: widget.needBack ? null : () async => false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/images/icon_verify_pw_bg.png',
                package: 'ox_usercenter',
              ),
            ),
          ),
          child: Column(
            children: [
              CommonAppBar(
                title: '',
                canBack: widget.needBack,
                backgroundColor: Colors.transparent,
              ),
              CommonImage(iconName: 'icon_logo_ox_login.png', width: 100.px, height: 100.px, package: 'ox_login'),
              SizedBox(height: 36.px),
              abbrText('Enter your Passcode', 24, ThemeColor.color0),
              SizedBox(height: 36.px),
              Container(
                height: 56.px,
                alignment: Alignment.topCenter,
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 0),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: _itemBuild,
                  itemCount: 6,
                ),
              ),
              const Expanded(
                child: SizedBox(),
              ),
              VerifySecureKeypad(
                  onChanged: _keypadValue,
                  onAuthResult: (value) {
                    if (value && mounted) {
                      if (widget.needBack) {
                        OXNavigator.pop(context, true);
                      } else {
                        OXModuleService.pushPage(context, 'ox_home', 'HomeTabBarPage', {});
                      }
                    }
                  }).setPadding(EdgeInsets.symmetric(horizontal: 24.px)),
              SizedBox(height: 89.px),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemBuild(BuildContext context, int index) {
    return Container(
      width: 46.px,
      height: 56.px,
      decoration: BoxDecoration(
        color: ThemeColor.color180.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16.px),
      ),
      margin: EdgeInsets.only(right: index == 5 ? 0 : 12.px),
      child: _inputPwd.length > index
          ? Center(
        child: CircleAvatar(
          radius: 6.px,
          backgroundColor: ThemeColor.color0,
        ),
      )
          : const SizedBox(),
    );
  }

  void _keypadValue(value) {
    setState(() {
      if (value == 'x') {
        if (_inputPwd.isNotEmpty) {
          _inputPwd = _inputPwd.substring(0, _inputPwd.length - 1);
        }
      } else {
        _inputPwd += value;
      }
    });
    if (_inputPwd.length == 6) {
      if (_inputPwd == localPasscode) {
        if (mounted) {
          if (widget.needBack) {
            OXNavigator.pop(context, true);
          } else {
            OXModuleService.pushPage(context, 'ox_home', 'HomeTabBarPage', {});
          }
        }
      } else {
        inputError();
      }
    }
  }

  void inputError() {
    OXCommonHintDialog.show(
      context,
      title: 'str_authentication_failed_title'.localized(),
      content: 'str_authentication_failed_hint'.localized(),
      actionList: [
        OXCommonHintAction(
            text: () => 'OK',
            onTap: () {
              _inputPwd = '';
              OXNavigator.pop(context);
            }),
      ],
    );
  }
}
