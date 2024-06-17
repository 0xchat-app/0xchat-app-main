import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/business_interface/ox_usercenter/interface.dart';
import 'package:ox_common/business_interface/ox_wallet/interface.dart';
import 'package:ox_common/model/wallet_model.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_discovery/page/moments/moment_zap_page.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:cashu_dart/cashu_dart.dart';
import 'package:ox_module_service/ox_module_service.dart';

class ZapsActionHandler {
  final UserDB userDB;
  final bool isAssistedProcess;
  final bool? privateZap;
  final Function(Map result)? zapsInfoCallback;

  late bool isDefaultEcashWallet;

  ZapsActionHandler({
    required this.userDB,
    this.privateZap,
    this.zapsInfoCallback,
    bool? isAssistedProcess,
  }) : isAssistedProcess = isAssistedProcess ?? false;

  Future<void> initialize() async {
    String? pubkey = Account.sharedInstance.me?.pubKey;
    if (pubkey == null) return;
    bool isShowWalletSelector = await OXCacheManager.defaultOXCacheManager.getForeverData('$pubkey.isShowWalletSelector') ?? true;
    String defaultWalletName = await OXCacheManager.defaultOXCacheManager.getForeverData('$pubkey.defaultWallet') ?? '';
    final ecashWalletName = WalletModel.walletsWithEcash.first.title;

    isDefaultEcashWallet = !isShowWalletSelector && defaultWalletName == ecashWalletName;
  }


  Future<void> handleZap({
    required BuildContext context,
    int? zapAmount,
    String? eventId,
    String? description,
    bool? privateZap,
  }) async {
    String lnurl = userDB.lnAddress;
    final recipient = userDB.pubKey;
    zapAmount = zapAmount ?? OXUserInfoManager.sharedInstance.defaultZapAmount;

    if (lnurl.isEmpty) {
      await CommonToast.instance.show(context, Localized.text('ox_discovery.not_set_lnurl_tips'));
      return;
    }

    if (lnurl.contains('@')) {
      try {
        lnurl = await Zaps.getLnurlFromLnaddr(lnurl);
      } catch (error) {
        return;
      }
    }

    final invokeResult = await OXUserCenterInterface.getInvoice(
        sats: zapAmount,
        otherLnurl: lnurl,
        recipient: recipient,
        eventId: eventId,
        content: description,
        privateZap: privateZap ?? false,
    );
    final invoice = invokeResult['invoice'] ?? '';
    final zapper = invokeResult['zapper'] ?? '';

    final zapsInfo = {
      'zapper': zapper,
      'invoice': invoice,
      'amount': zapAmount.toString(),
      'description': description,
    };

    if (isAssistedProcess) {
      OXNavigator.presentPage(
        context,
        (context) => MomentZapPage(
          userDB: userDB,
          eventId: eventId,
        ),
      );
    } else {
      handleZapChannel(context: context, zapsInfo: zapsInfo);
    }
  }

  handleZapChannel({
    required BuildContext context,
    required Map zapsInfo,
  }) {
    if (isDefaultEcashWallet) {
      handleZapWithEcash(zapsInfo: zapsInfo, context: context);
    } else {
      handleZapWithThirdPartyWallet(zapsInfo: zapsInfo, context: context);
    }
  }

  handleZapWithEcash({
    IMint? mint,
    required Map zapsInfo,
    required BuildContext context,
  }) async {
    final isWalletAvailable = OXWalletInterface.isWalletAvailable() ?? false;
    mint = mint ?? OXWalletInterface.getDefaultMint();

    if (!isWalletAvailable) {
      showToast(context, message: 'Please open Ecash Wallet first');
      return;
    }

    if (mint == null) {
      showToast(context, message: Localized.text('ox_discovery.mint_empty_tips'));
      return;
    }

    final invoice = zapsInfo['invoice'];
    final sats = int.parse(zapsInfo['amount']);
    if (sats < 1) {
      showToast(context, message: Localized.text('ox_discovery.enter_amount_tips'));
      return ;
    }

    if (sats > mint.balance) {
      showToast(context, message: Localized.text('ox_discovery.insufficient_balance_tips'));
      return;
    }

    final response = await Cashu.payingLightningInvoice(mint: mint, pr: invoice);
    if (!response.isSuccess) {
      showToast(context, message: response.errorMsg);
      return;
    }
    // widget.zapsInfoCallback?.call(zapInfo);
    // OXLoading.dismiss();
    // OXNavigator.pop(context);
  }

  handleZapWithThirdPartyWallet({
    required Map zapsInfo,
    required BuildContext context,
  }) async {
    final isTapOnWallet = await _jumpToWalletSelectionPage(context,zapsInfo);
    if (isTapOnWallet) {
      OXNavigator.pop(context);
    }
  }

  Future<bool> _jumpToWalletSelectionPage(BuildContext context,Map result) async {
    var isConfirm = false;
    await OXModuleService.pushPage(context, 'ox_usercenter', 'ZapsInvoiceDialog', {
      'invoice': result['invoice'] ?? '',
      'walletOnPress': (WalletModel wallet) async {
        // widget.zapsInfoCallback?.call(result);
        isConfirm = true;
        return true;
      },
    });
    return isConfirm;
  }



  void showToast(BuildContext context, {required String message}) {
    CommonToast.instance.show(context, message);
  }

}
