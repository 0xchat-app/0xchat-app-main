
// plugin
import 'dart:io';

import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_common/const/common_constant.dart';
// ox_common
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/nip46_status_notifier.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/took_kit.dart';
import 'package:ox_common/utils/user_config_tool.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
// ox_login
import 'package:ox_login/page/account_key_login_page.dart';
import 'package:ox_login/page/create_account_page.dart';
import 'package:ox_login/page/login_with_qrcode_page.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:rich_text_widget/rich_text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {

  const LoginPage();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
    return GestureDetector(
      onTap: () => OXNavigator.pop(context),
      child: CommonImage(
        iconName: 'close_icon_white.png',
        fit: BoxFit.contain,
        width: Adapt.px(24),
        height: Adapt.px(24),
        useTheme: true,
      ),
    );
  }

  Widget _body() {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          buildLogoIcon(),
          buildTips(),
          Column(
            children: [
              buildCreateAccountButton().setPaddingOnly(bottom: 18.px),
              buildLoginButton().setPaddingOnly(bottom: 18.px),
              buildQrCodeLoginWidget().setPaddingOnly(bottom: 18.px),
              buildPrivacyWidget().setPaddingOnly(bottom: 18.px),
              Platform.isAndroid ? buildAmberLoginWidget() : Container(),
            ],
          ),
        ],
      ).setPadding(EdgeInsets.symmetric(horizontal: 30.px)),
    );
  }

  Widget buildLogoIcon() => CommonImage(
    iconName: 'logo_icon.png',
    fit: BoxFit.contain,
    width: Adapt.px(180),
    height: Adapt.px(180),
    useTheme: true,
  );

  Widget buildTips() => Container(
    child: Text(
      Localized.text('ox_login.login_tips'),
      style: TextStyle(color: ThemeColor.titleColor, fontSize: 18.sp),
      textAlign: TextAlign.center,
    ),
  );

  Widget buildCreateAccountButton() => GestureDetector(
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
          fontWeight: FontWeight.bold,
          fontSize: 16.sp,
        ),
      ),
    ),
  );

  Widget buildLoginButton() => GestureDetector(
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
          fontWeight: FontWeight.bold,
          fontSize: 16.sp,
        ),
      ),
    ),
  );

  Widget buildQrCodeLoginWidget() =>
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _loginWithQRCode,
        child: Container(
          height: Adapt.px(48),
          alignment: Alignment.center,
          child: Text(
            Localized.text('ox_login.str_login_with_qrcode'),
            style: TextStyle(
              color: ThemeColor.gradientMainStart,
              fontWeight: FontWeight.bold,
              fontSize: Adapt.px(16),
            ),
          ),
        ),
      );

  Widget buildPrivacyWidget() => Container(
    margin: EdgeInsets.symmetric(horizontal: 24.px),
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
            fontWeight: FontWeight.bold,
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
            fontWeight: FontWeight.bold,
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
  );

  Widget buildAmberLoginWidget() {
    bool isAndroid = Platform.isAndroid;
    String text = isAndroid ? Localized.text('ox_login.login_with_amber') : Localized.text('ox_login.login_with_aegis');
    GestureTapCallback? onTap = isAndroid ? _loginWithAmber : _loginWithNostrAegis;
    String iconName = isAndroid ? "icon_login_amber.png" : "icon_login_aegis.png";
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        height: 70.px,
        child: Stack(
          children: [
            Positioned(top: 24.px, left: 0, right: 0, child: Container(width: double.infinity, height: 0.5.px, color: ThemeColor.color160)),
            Align(alignment: Alignment.topCenter, child: CommonImage(iconName: iconName, width: 48.px, height: 48.px, package: 'ox_login')),
            Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  text,
                  style: TextStyle(
                      color: ThemeColor.color120,
                      fontSize: Adapt.px(12)
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }

  void _createAccount() {
    Keychain keychain = Account.generateNewKeychain();
    OXNavigator.pushPage(context, (context) => CreateAccountPage(keychain: keychain));
  }

  void _login() {
    OXNavigator.pushPage(context, (context) => AccountKeyLoginPage());
  }

  void _loginWithNostrAegis() async{
    bool result = await NIP46StatusNotifier.remoteSignerTips(Localized.text('ox_login.wait_link_service'));
    if(!result) return;
    String loginQRCodeUrl = AccountNIP46.createNostrConnectURI(relays:['ws://127.0.0.1:8081']);
    loginWithNostrConnect(loginQRCodeUrl);
    final appScheme = '${CommonConstant.APP_SCHEME}://';
    final uri = Uri.tryParse('aegis://${Uri.encodeComponent("${loginQRCodeUrl}&scheme=${appScheme}")}');
    await _launchAppOrSafari(uri!);
  }

  Future<void> _launchAppOrSafari(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      final Uri fallbackUri = Uri.parse('https://testflight.apple.com/join/DUzVMDMK');
      await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
    }
  }

  void loginWithNostrConnect(String loginQRCodeUrl)async{
    String pubkey = "";
    UserDBISAR? userDB;
    String currentUserPubKey = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '';
    pubkey = await Account.getPublicKeyWithNIP46URI(loginQRCodeUrl);
    await OXUserInfoManager.sharedInstance.initDB(pubkey);
    userDB = await Account.sharedInstance.loginWithNip46URI(loginQRCodeUrl);
    userDB = await OXUserInfoManager.sharedInstance.handleSwitchFailures(userDB, currentUserPubKey);
    if (userDB == null) {
      CommonToast.instance.show(context, Localized.text('ox_login.private_key_regular_failed'));
      return;
    }
    Account.sharedInstance.reloadProfileFromRelay(userDB.pubKey).then((value) {
      UserConfigTool.saveUser(value);
      UserConfigTool.updateSettingFromDB(value.settings);
    });

    OXUserInfoManager.sharedInstance.loginSuccess(userDB);
    OXNavigator.popToRoot(context);
  }

  void _loginWithAmber() async {
    bool isInstalled = await CoreMethodChannel.isInstalledAmber();
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
    String decodeSignature = signature;
    if (signature.startsWith('npub')) {
      decodeSignature = UserDBISAR.decodePubkey(signature) ?? '';
    }
    String currentUserPubKey = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '';
    await OXUserInfoManager.sharedInstance.initDB(decodeSignature);
    UserDBISAR? userDB = await Account.sharedInstance.loginWithPubKey(decodeSignature, SignerApplication.androidSigner);
    userDB = await OXUserInfoManager.sharedInstance.handleSwitchFailures(userDB, currentUserPubKey);
    if (userDB == null) {
      await OXLoading.dismiss();
      CommonToast.instance.show(context, Localized.text('ox_login.pub_key_regular_failed'));
      return;
    }
    Account.sharedInstance.reloadProfileFromRelay(userDB.pubKey).then((value) {
      UserConfigTool.saveUser(value);
      UserConfigTool.updateSettingFromDB(value.settings);
    });
    OXUserInfoManager.sharedInstance.loginSuccess(userDB, isAmber: true);
    await OXLoading.dismiss();
    OXNavigator.popToRoot(context);
  }

  void _serviceWebView() {
    OXModuleService.invoke('ox_common', 'gotoWebView', [context, 'https://www.0xchat.com/protocols/0xchat_terms_of_use.html', null, null, null, null]);
  }

  void _privacyPolicyWebView() {
    OXModuleService.invoke('ox_common', 'gotoWebView', [context, 'https://www.0xchat.com/protocols/0xchat_privacy_policy.html', null, null, null, null]);
  }

  void _loginWithQRCode() {
    OXNavigator.presentPage(context, (context) => LoginWithQRCodePage(), fullscreenDialog: true);
  }
}
