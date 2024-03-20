import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/theme_button.dart';
import 'package:ox_wallet/page/wallet_home_page.dart';
import 'package:ox_wallet/page/wallet_mint_management_add_page.dart';
import 'package:ox_wallet/services/ecash_manager.dart';
import 'package:ox_wallet/services/ecash_service.dart';
import 'package:ox_wallet/widget/ecash_common_button.dart';
import 'package:ox_wallet/widget/privacy_policy_widget.dart';
import 'package:ox_localizable/ox_localizable.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final _defaultMintURL = 'https://mint.0xchat.com';
  final ValueNotifier<bool> _hasAgreedToPrivacyPolicy = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ThemeColor.color190,
        appBar: CommonAppBar(
        centerTitle: true,
        useLargeTitle: false,
    ),
    body:SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonImage(
              iconName: 'icon_wallet_logo.png',
              size: 100.px,
              package: 'ox_wallet',
            ).setPaddingOnly(top: 44.px),
            CommonImage(
              iconName: 'icon_wallet_symbol.png',
              height: 25.px,
              width: 100.px,
              package: 'ox_wallet',
              useTheme: true,
            ).setPaddingOnly(top: 16.px),
            Text(
              Localized.text('ox_wallet.mint_guide_text'),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.px,
                  color: ThemeColor.color0,
                  height: 24.px / 16.px
              ),
            ).setPaddingOnly(top: 56.px),
            SizedBox(height: 200.px,),
            ThemeButton(height: 48.px,text: Localized.text('ox_wallet.use_default_mint_text'),onTap: _useDefaultMint,),
            EcashCommonButton(text: Localized.text('ox_wallet.add_mint_url_text'),onTap: _addMint).setPaddingOnly(top: 18.px),
            EcashCommonButton(text: Localized.text('ox_wallet.import_mint_text'),onTap: _importWallet).setPaddingOnly(top: 18.px),
            PrivacyPolicyWidget(controller: _hasAgreedToPrivacyPolicy,).setPaddingOnly(top: 18.px),
            SizedBox(height: 40.px,)
            ],
          ).setPadding(EdgeInsets.symmetric(horizontal: 30.px)),
        ),
      ),
    );
  }

  void _addMint() {
    if (!_checkPrivacyPolicyAgreement()) return;
    OXNavigator.pushPage(
      context,
      (context) => WalletMintManagementAddPage(
        action: ImportAction.add,
        scenarioType: ScenarioType.activate,
        callback: () => OXNavigator.pushPage(context!, (context) => const WalletHomePage()),
      ),
    );
  }

  void _useDefaultMint() {
    if(!_checkPrivacyPolicyAgreement()) return;
    OXLoading.show();
    EcashService.addMint(_defaultMintURL).then((mint) {
      OXLoading.dismiss();
      if (mint != null || EcashManager.shared.mintList.any((mint) => mint.mintURL.toLowerCase() == _defaultMintURL.toLowerCase())) {
        EcashManager.shared.setWalletAvailable();
        OXNavigator.pushPage(context, (context) => const WalletHomePage());
      } else {
        CommonToast.instance.show(context, Localized.text('ox_wallet.add_default_mint_failed_tips'));
      }
    });
  }

  void _importWallet(){
    if(!_checkPrivacyPolicyAgreement()) return;
    OXNavigator.pushPage(context, (context) => WalletMintManagementAddPage(
        action: ImportAction.import,
        scenarioType: ScenarioType.activate,
        callback: () => OXNavigator.pushPage(context!, (context) => const WalletHomePage()),
      ),
    );
  }

  bool _checkPrivacyPolicyAgreement() {
    final hasAgreedToPrivacyPolicy = _hasAgreedToPrivacyPolicy.value;
    if (!hasAgreedToPrivacyPolicy) {
      CommonToast.instance.show(context, Localized.text('ox_wallet.accept_privacy_policy_tips'));
    }
    return hasAgreedToPrivacyPolicy;
  }

  @override
  void dispose() {
    _hasAgreedToPrivacyPolicy.dispose();
    super.dispose();
  }
}