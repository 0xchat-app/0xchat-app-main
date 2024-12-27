import 'dart:ui';

import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/app_relay_hint_dialog.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/user_config_tool.dart';
import 'package:ox_common/widgets/base_page_state.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

///Title: login_with_qrcode_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/12/23 16:39
class LoginWithQRCodePage extends StatefulWidget {
  LoginWithQRCodePage();

  @override
  State<StatefulWidget> createState() {
    return _LoginWithQRCodePageState();
  }
}

class _LoginWithQRCodePageState extends BasePageState<LoginWithQRCodePage> {
  String _loginQRCodeUrl = '';
  GlobalKey _globalKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    _initData();
    _loginWithNip46();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: '',
        canBack: false,
        backgroundColor: ThemeColor.color200,
        actions: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: CommonImage(
              iconName: "title_close.png",
              size: 24.px,
              useTheme: true,
            ),
            onTap: () {
              OXNavigator.pop(context);
            },
          )
        ],
      ),
      backgroundColor: ThemeColor.color200,
      body: _body(),
    );
  }

  @override
  String get routeName => 'MyIdCardDialog';

  void _initData() async {
    _loginQRCodeUrl = AccountNIP46.createNostrConnectURI();
    LogUtil.e('Michael:------nostrUrl = ${_loginQRCodeUrl}');
    setState(() {});

  }

  Widget _body() {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: 80.px),
      child: Column(
        children: [
          Container(
            width: Adapt.px(310),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: Adapt.px(260),
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 25.px),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(
                    Adapt.px(8),
                  ),
                  child:
                  _loginQRCodeUrl.isEmpty ? Container() : _qrCodeWidget(),
                ),
                Container(
                  margin: EdgeInsets.only(top: 36.px),
                  alignment: Alignment.center,
                  child: Text('Please scan the QR Code'),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 36.px),
            child: Text('1 Open 0xchat on your phone\n2 Go to Add > Scan\n3 Point your phone at this screen to confirm login'),
          ),
        ],
      ),
    );
  }

  Widget _qrCodeWidget() {
    return PrettyQr(
      size: 240.px,
      data: _loginQRCodeUrl,
      errorCorrectLevel: QrErrorCorrectLevel.M,
      typeNumber: null,
      roundEdges: true,
    );
  }

  Future<void> _loginWithNip46() async {
    String pubkey = "";
    UserDBISAR? userDB;
    String currentUserPubKey =
        OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '';
    pubkey = await Account.getPublicKeyWithNIP46URI(_loginQRCodeUrl);
    await OXUserInfoManager.sharedInstance.initDB(pubkey);
    userDB = await Account.sharedInstance.loginWithNip46URI(_loginQRCodeUrl);
    userDB = await OXUserInfoManager.sharedInstance
        .handleSwitchFailures(userDB, currentUserPubKey);
    if (userDB == null) {
      CommonToast.instance
          .show(context, Localized.text('ox_login.private_key_regular_failed'));
      return;
    }
    Account.sharedInstance.reloadProfileFromRelay(userDB.pubKey).then((value) {
      LogUtil.e(
          'Michael:---reloadProfileFromRelay--name = ${value.name}; pic =${value.picture}}');
      UserConfigTool.saveUser(value);
      UserConfigTool.updateSettingFromDB(value.settings);
    });

    OXUserInfoManager.sharedInstance.loginSuccess(userDB);
    OXNavigator.popToRoot(context);
  }
}
