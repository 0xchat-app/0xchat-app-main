import 'package:flutter/material.dart';
import 'package:cashu_dart/cashu_dart.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:ox_wallet/page/wallet_home_page.dart';
import 'package:ox_wallet/page/wallet_page.dart';
import 'package:ox_common/business_interface/ox_wallet/interface.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_wallet/page/wallet_send_lightning_page.dart';
import 'package:ox_wallet/page/wallet_successful_page.dart';
import 'package:ox_wallet/page/wallet_transaction_record.dart';
import 'package:ox_wallet/services/ecash_manager.dart';
import 'package:ox_wallet/widget/mint_indicator_item.dart';

class OXWallet extends OXFlutterModule {
  @override
  // TODO: implement moduleName
  String get moduleName => OXWalletInterface.moduleName;

  @override
  navigateToPage(BuildContext context, String pageName, Map<String, dynamic>? params) {
    switch (pageName) {
      case 'WalletPage':
        return OXNavigator.pushPage(context, (context) => const WalletPage(),);
      case 'WalletHomePage':
        return OXNavigator.pushPage(context, (context) => const WalletHomePage(),);
      case 'WalletSuccessfulRedeemClaimedPage':
        return OXNavigator.pushPage(
          context,
          (context) => WalletSuccessfulPage.redeemClaimed(
            amount: params?['amount'] ?? '',
            onTap: () => OXNavigator.pop(context!),
          ),
        );
      case 'WalletSendLightningPage':
        return OXNavigator.pushPage(
          context,
          (context) => WalletSendLightningPage(
            external: {
              'invoice': params?['invoice'],
              'amount': params?['amount']
            },
          ),
        );
      case 'WalletTransactionRecord':
        return OXNavigator.pushPage(context, (context) => WalletTransactionRecord(
          entry: params?['historyEntry'],
        ));
    }
    return null;
  }

  @override
  // TODO: implement interfaces
  Map<String, Function> get interfaces => {
    'walletPageWidget': walletPageWidget,
    'getDefaultMint': getDefaultMint,
    'isWalletAvailable': isWalletAvailable,
    'buildMintIndicatorItem': buildMintIndicatorItem,
    'checkWalletActivate': checkWalletActivate,
  };

  @override
  Future<void> setup() async {
    super.setup();
    OXUserInfoManager.sharedInstance.initDataActions.add(() async {
      await EcashManager.shared.setup();
    });
  }

  Widget walletPageWidget(BuildContext context) {
    return const WalletPage();
  }

  IMint? getDefaultMint() {
    return EcashManager.shared.defaultIMint;
  }

  bool isWalletAvailable() {
    return EcashManager.shared.isWalletAvailable;
  }

  Widget buildMintIndicatorItem({
    required IMint? mint,
    required ValueChanged<IMint>? selectedMintChange,
  }) {
    return MintIndicatorItem(
      mint: mint,
      onChanged: selectedMintChange,
    );
  }

  bool checkWalletActivate() {
    if (EcashManager.shared.isWalletAvailable) return true;
    final context = OXNavigator.navigatorKey.currentContext;
    if (context == null) return false;

    OXCommonHintDialog.show(context,
        title: Localized.text('ox_common.tips'),
        content: 'Please activate your ecash wallet before claim',
        actionList: [
          OXCommonHintAction.cancel(onTap: () {
            OXNavigator.pop(context);
          }),
          OXCommonHintAction.sure(
              text: 'Activate',
              onTap: () {
                OXNavigator.pushReplacement(context, WalletPage());
              }),
        ],
        isRowAction: true);

    return false;
  }
}