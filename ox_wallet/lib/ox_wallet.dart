import 'package:flutter/material.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:ox_wallet/page/wallet_home_page.dart';
import 'package:ox_wallet/page/wallet_page.dart';
import 'package:ox_common/navigator/navigator.dart';

class OXWallet extends OXFlutterModule {
  @override
  // TODO: implement moduleName
  String get moduleName => 'ox_wallet';

  @override
  navigateToPage(BuildContext context, String pageName, Map<String, dynamic>? params) {
    switch (pageName) {
      case 'WalletHomePage':
        return OXNavigator.pushPage(context, (context) => const WalletHomePage(),
        );
    }
    return null;
  }

  @override
  // TODO: implement interfaces
  Map<String, Function> get interfaces => {
    'walletPageWidget': walletPageWidget,
  };

  @override
  Future<void> setup() {
    // TODO: implement setup
    return super.setup();
  }

  Widget walletPageWidget(BuildContext context) {
    return const WalletPage();
  }

}