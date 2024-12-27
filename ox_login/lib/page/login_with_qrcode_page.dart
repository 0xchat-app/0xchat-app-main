import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/took_kit.dart';
import 'package:ox_common/utils/user_config_tool.dart';
import 'package:ox_common/widgets/base_page_state.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_login/page/account_key_login_page.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:ox_localizable/ox_localizable.dart';
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
  List<String> _relayUrls = [];

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
  String get routeName => 'LoginWithQRCodePage';

  void _initData() async {
    _loginQRCodeUrl = AccountNIP46.createNostrConnectURI();
    LogUtil.e('Michael:------nostrUrl = ${_loginQRCodeUrl}');
    setState(() {});

  }

  Widget _body() {
    return Container(
      margin: EdgeInsets.only(top: 80.px),
      padding: EdgeInsets.symmetric(horizontal: 24.px),
      child: Column(
        children: [
          Container(
            width: Adapt.px(310),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 220.px,
                  height: 220.px,
                  alignment: Alignment.center,
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
                  child: Text(
                    Localized.text('ox_login.str_login_with_qrcode_hint'),
                    style: TextStyle(
                      color: ThemeColor.color0,
                      fontSize: 14.px,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 32.px),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    _showRelayPage();
                  },
                  child: Container(
                    width: 120.px,
                    height: 48.px,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: ThemeColor.color180,
                      borderRadius: BorderRadius.circular(12.px),
                    ),
                    child: Text(
                      Localized.text('ox_usercenter.relays') + '(${_relayUrls.length})',
                      style: TextStyle(
                        color: ThemeColor.color0,
                        fontSize: 14.px,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    _copyUrl();
                  },
                  child: Container(
                    width: 120.px,
                    height: 48.px,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: ThemeColor.color180,
                      borderRadius: BorderRadius.circular(12.px),
                    ),
                    child: Text(
                      Localized.text('ox_login.str_login_with_copy_url'),
                      style: TextStyle(
                        color: ThemeColor.color0,
                        fontSize: 14.px,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 32.px),
            alignment: Alignment.centerLeft,
            child: Text(
              Localized.text('ox_login.str_login_with_qrcode_description'),
              style: TextStyle(
                color: ThemeColor.color0,
                fontSize: 14.px,
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              OXNavigator.pushPage(context, (context) => AccountKeyLoginPage());
            },
            child: Container(
              margin: EdgeInsets.only(top: 25.px),
              alignment: Alignment.center,
              height: 48.px,
              child: Text(
                Localized.text('ox_login.str_login_with_account'),
                style: TextStyle(
                  color: ThemeColor.gradientMainStart,
                  fontSize: 14.px,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _qrCodeWidget() {
    return PrettyQr(
      size: 200.px,
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
      UserConfigTool.saveUser(value);
      UserConfigTool.updateSettingFromDB(value.settings);
    });

    OXUserInfoManager.sharedInstance.loginSuccess(userDB);
    OXNavigator.popToRoot(context);
  }

  Future<void> _showRelayPage() async {
    final result = await OXModuleService.pushPage(context, 'ox_usercenter', 'RelaysForLoginPage', {'relayUrls': _relayUrls});
    if (result != null && result is List<String> && mounted) {
      setState(() {
        _relayUrls = result;
      });
    }
  }

  Future<void> _copyUrl() async {
    await TookKit.copyKey(context, _loginQRCodeUrl);
  }
}
