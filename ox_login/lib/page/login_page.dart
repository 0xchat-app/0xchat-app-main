import 'package:flutter/material.dart';

// ox_common
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
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
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Adapt.px(30),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            color: ThemeColor.color200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonImage(
                  iconName: 'logo_icon.png',
                  fit: BoxFit.contain,
                  width: Adapt.px(180),
                  height: Adapt.px(180),
                ),
                SizedBox(
                  height: Adapt.px(36),
                ),
                Container(
                  child: Text(
                    Localized.text('ox_usercenter.login_tips'),
                    style: TextStyle(color: ThemeColor.titleColor, fontSize: Adapt.px(18)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: ThemeColor.color200,
            child: Column(
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
                SizedBox(
                  height: Adapt.px(18),
                ),
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
                SizedBox(
                  height: Adapt.px(18),
                ),
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Adapt.px(8),
                      ),
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
              ],
            ),
          ),
        ],
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
