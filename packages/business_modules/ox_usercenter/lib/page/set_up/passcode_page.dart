import 'package:flutter/material.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/user_config_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_usercenter/utils/widget_tool.dart';
import 'package:ox_usercenter/widget/secure_keypad.dart';

///Title: passcode_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/12/7 16:58
class PasscodePage extends StatefulWidget {
  int? type; // create 0, confirm 1
  String? passcode;

  PasscodePage({
    Key? key,
    this.type = 0,
    this.passcode = '',
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PasscodePageState();
  }
}

class _PasscodePageState extends State<PasscodePage> {
  String _inputPwd = '';
  final GlobalKey _globalKeySecureKeypad = GlobalKey();

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
    final minHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: ThemeColor.color200,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: minHeight),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonAppBar(
                title: 'str_passcode'.localized(),
                centerTitle: true,
                useLargeTitle: false,
                backgroundColor: Colors.transparent,
              ),
              SizedBox(height: 36.px),
              abbrText(widget.type == 0 ? 'str_create_passcode'.localized() : 'str_confirm_passcode'.localized(), 24, ThemeColor.color0),
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
              SizedBox(height: 24.px),
              SecureKeypad(
                key: _globalKeySecureKeypad,
                onChanged: _keypadValue,
              ),
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

  void _keypadValue(value) async {
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
      if (widget.type == 0) {
        OXNavigator.pushPage(context, (context) => PasscodePage(type: 1, passcode: _inputPwd)).then((value) {
          if (value != null && value is bool && value) {
            SecureKeypadState secureKeypadState = _globalKeySecureKeypad.currentState as SecureKeypadState;
            secureKeypadState.resetCurrentIndex();
            setState(() {
              _inputPwd = '';
            });
          }
        });
      } else if (widget.type == 1) {
        if (_inputPwd == widget.passcode) {
          UserConfigTool.saveSetting(StorageSettingKey.KEY_PASSCODE.name, _inputPwd);
          OXNavigator.popToPage(context, pageType: 'PrivacyPage');
        } else {
          inputError();
        }
      }
    }
  }

  void inputError() {
    OXCommonHintDialog.show(
      context,
      title: 'str_mismatch_title'.localized(),
      content: 'str_mismatch_try_hint'.localized(),
      actionList: [
        OXCommonHintAction(
            text: () => 'OK',
            onTap: () {
              OXNavigator.pop(context, true);
            }),
      ],
    ).then((value) {
      if (value ?? false) {
        OXNavigator.pop(context, true);
      }
    });
  }
}
