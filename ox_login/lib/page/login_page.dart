import 'dart:io';

import 'package:flutter/material.dart';

// ox_common
import 'package:ox_common/log_util.dart';
import 'package:ox_common/model/user_config_tool.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/app_initialization_manager.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/common_webview.dart';
import 'package:ox_common/widgets/common_loading.dart';

// ox_login
import 'package:ox_login/page/account_key_login_page.dart';
import 'package:ox_login/page/create_account_page.dart';

// plugin
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:rich_text_widget/rich_text_widget.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';

class LoginPage extends StatefulWidget {
  final bool? isLoginShow;

  LoginPage({this.isLoginShow});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _displayUri = '';
  String address = '';
  int groupValue = 1;
  String loginSchema = 'wc';
  String? platformUniqueKey;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: '',
        useLargeTitle: false,
        centerTitle: true,
        backgroundColor: ThemeColor.color200,
        leading: Container(),
        actions: [_appBarActions()],
      ),
      backgroundColor: ThemeColor.color200,
      body: _body(),
    );
  }

  Widget _appBarActions() {
    return Container(
      margin: EdgeInsets.only(right: Adapt.px(24)),
      child: GestureDetector(
        onTap: () => OXNavigator.pop(context),
        child: CommonImage(
          iconName: 'close_icon_white.png',
          fit: BoxFit.contain,
          width: Adapt.px(24),
          height: Adapt.px(24),
          useTheme: true,
        ),
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Adapt.px(30),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SizedBox(height: Adapt.px(12)),
            CommonImage(
              iconName: 'logo_icon.png',
              fit: BoxFit.contain,
              width: Adapt.px(180),
              height: Adapt.px(180),
              useTheme: true,
            ),
            SizedBox(height: Adapt.px(36)),
            Container(
              child: Text(
                Localized.text('ox_login.login_tips'),
                style: TextStyle(color: ThemeColor.titleColor, fontSize: Adapt.px(18)),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: Adapt.px(110)),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _createAccount,
                  child: Container(
                    width: double.infinity,
                    height: Adapt.px(48),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: ThemeColor.color180,
                      gradient: LinearGradient(
                        colors: [
                          ThemeColor.gradientMainEnd,
                          ThemeColor.gradientMainStart,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      Localized.text('ox_login.create_account'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Adapt.px(16),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Adapt.px(18)),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _login,
                  child: Container(
                    width: double.infinity,
                    height: Adapt.px(48),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: ThemeColor.color180,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      Localized.text('ox_login.login_button'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Adapt.px(16),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Adapt.px(18)),
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: Adapt.px(8)),
                      Container(
                        width: Adapt.screenW() - Adapt.px(20 + 8 * 2 + 30 * 2),
                        child: RichTextWidget(
                          // default Text
                          Text(
                            Localized.text('ox_login.terms_of_service_privacy_policy'),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: Adapt.px(14),
                              color: ThemeColor.titleColor,
                              height: 1.5,
                            ),
                          ),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          // rich text list
                          richTexts: [
                            BaseRichText(
                              Localized.text("ox_login.terms_of_service"),
                              style: TextStyle(
                                fontSize: Adapt.px(14),
                                foreground: Paint()
                                  ..shader = LinearGradient(
                                    colors: [ThemeColor.gradientMainEnd, ThemeColor.gradientMainStart],
                                  ).createShader(
                                    Rect.fromLTWH(0.0, 0.0, 550.0, 70.0),
                                  ),
                              ),
                              onTap: _serviceWebView,
                            ),
                            BaseRichText(
                              Localized.text("ox_login.privacy_policy"),
                              style: TextStyle(
                                fontSize: Adapt.px(14),
                                foreground: Paint()
                                  ..shader = LinearGradient(
                                    colors: [ThemeColor.gradientMainEnd, ThemeColor.gradientMainStart],
                                  ).createShader(
                                    Rect.fromLTWH(0.0, 0.0, 350.0, 70.0),
                                  ),
                              ),
                              onTap: _privacyPolicyWebView,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: Platform.isAndroid,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: _loginWithAmber,
                    child: Container(
                      width: double.infinity,
                      height: Adapt.px(48),
                      margin: EdgeInsets.only(top: 40.px),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(width: double.infinity, height: 0.5.px, color: ThemeColor.color160),
                          CommonImage(iconName: 'icon_login_amber.png', width: 48.px, height: 48.px, package: 'ox_login'),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: Platform.isAndroid,
                  child: Container(
                    margin: EdgeInsets.only(top: 4.px),
                    child: Text(
                      Localized.text('ox_login.login_with_amber'),
                      style: TextStyle(
                        color: ThemeColor.color120,
                        fontSize: Adapt.px(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    if (_displayUri.length > 0) {
      // final uri = loginSchema + "://wc?uri=" + _displayUri;
      print("_displayUri ==== $_displayUri");
    }
  }

  void _createAccount() async {

    await OXLoading.show();
    Keychain keychain = Account.generateNewKeychain();
    await OXUserInfoManager.sharedInstance.initDB(keychain.public);
    UserDB? userDB = await Account.newAccount(user: keychain);
    userDB = await Account.sharedInstance.loginWithPriKey(keychain.private);
    LogUtil.e('Michael: pubKey =${userDB?.pubKey}');
    await OXLoading.dismiss();
    if(userDB != null)
    OXNavigator.pushPage(context, (context) => CreateAccountPage(userDB: userDB!));
  }

  void _login() {
    OXNavigator.pushPage(context, (context) => AccountKeyLoginPage());
  }

  void _loginWithAmber() async {
    bool isInstalled = await CoreMethodChannel.isAppInstalled('com.greenart7c3.nostrsigner');
    if (mounted && !isInstalled) {
      CommonToast.instance.show(context, Localized.text('ox_login.str_not_installed_amber'));
      return;
    }
    String? signature = await ExternalSignerTool.getPubKey();
    if (signature == null) {
      CommonToast.instance.show(context, Localized.text('ox_login.sign_request_rejected'));
      return;
    }
    await OXLoading.show();
    String decodeSignature = UserDB.decodePubkey(signature) ?? '';
    await OXUserInfoManager.sharedInstance.initDB(decodeSignature);
    UserDB? userDB = await Account.sharedInstance.loginWithPubKey(decodeSignature);
    if (userDB == null) {
      CommonToast.instance.show(context, Localized.text('ox_common.pub_key_regular_failed'));
      return;
    }
    Account.sharedInstance.reloadProfileFromRelay(userDB.pubKey).then((value) {
      UserConfigTool.saveUser(value);
      UserConfigTool.updateSettingFromDB(value.settings);
    });
    OXUserInfoManager.sharedInstance.loginSuccess(userDB);
    OXCacheManager.defaultOXCacheManager.saveForeverData('${userDB.pubKey}${StorageKeyTool.KEY_IS_LOGIN_AMBER}', true);
    await OXLoading.dismiss();
    OXNavigator.popToRoot(context);
    AppInitializationManager.shared.showInitializationLoading();
  }

  void _serviceWebView() {
    OXNavigator.presentPage(
      context,
      (context) => CommonWebView(
        'https://www.0xchat.com/protocols/0xchat_terms_of_use.html',
        title: Localized.text("ox_login.terms_of_service"),
      ),
    );
  }

  void _privacyPolicyWebView() {
    OXNavigator.presentPage(
      context,
          (context) => CommonWebView(
            'https://www.0xchat.com/protocols/0xchat_privacy_policy.html',
        title: Localized.text("ox_login.privacy_policy"),
      ),
    );
  }
}
