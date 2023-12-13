import 'package:flutter/material.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_usercenter/utils/widget_tool.dart';
import 'package:ox_usercenter/widget/secure_keypad.dart';

///Title: verify_passcode_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/12/7 18:38
class VerifyPasscodePage extends StatefulWidget {

  const VerifyPasscodePage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _VerifyPasscodePageState();
  }
}

class _VerifyPasscodePageState extends State<VerifyPasscodePage> {
  String _inputPwd = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ThemeColor.gradientMainStart,
              ThemeColor.gradientMainEnd,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            CommonAppBar(
              title: '',
              backgroundColor: Colors.transparent,
            ),
            CommonImage(iconName: 'icon_logo_ox_login.png', width: 80.px, height: 80.px, package: 'kd_wallet_home'),
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
            SecureKeypad(onChanged: _keypadValue),
            SizedBox(height: 89.px),
          ],
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

  void _keypadValue(value) async {
    LogUtil.e('Michael: ======value =${value}');
    setState(() {
      _inputPwd = value;
    });
    if (_inputPwd.length == 6) {
      String localPasscode = await OXCacheManager.defaultOXCacheManager.getForeverData(StorageKeyTool.KEY_PASSCODE, defaultValue: '');
      if (_inputPwd == localPasscode) {
        if (mounted) OXNavigator.pop(context);
      } else {
        inputError();
      }
    }
  }

  void inputError() {
    OXCommonHintDialog.show(
      context,
      title: 'Authentication Failed',
      content: 'This wallet is secured. The entered passcode is invalid.',
      actionList: [
        OXCommonHintAction(
            text: () => 'OK',
            onTap: () {
              OXNavigator.pop(context, true);
            }),
      ],
    );
  }
}
