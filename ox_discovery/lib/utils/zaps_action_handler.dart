import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/business_interface/ox_usercenter/interface.dart';
import 'package:ox_common/business_interface/ox_wallet/interface.dart';
import 'package:ox_common/model/wallet_model.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_discovery/page/moments/moment_zap_page.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:cashu_dart/cashu_dart.dart';
import 'package:ox_module_service/ox_module_service.dart';

class ZapsActionHandler {
  final UserDB userDB;
  final bool isAssistedProcess;
  final bool? privateZap;
  Function(Map<String,dynamic> zapsInfo)? zapsInfoCallback;

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

  void addCallback(Function(Map<String, dynamic>) callback) {
    zapsInfoCallback = callback;
  }

  void removeCallback() {
    zapsInfoCallback = null;
  }

  Future<void> handleZap({
    required BuildContext context,
    int? zapAmount,
    String? eventId,
    String? description,
    bool? privateZap,
  }) async {
    String lnurl = userDB.lnAddress;

    if (lnurl.isEmpty) {
      await CommonToast.instance.show(context, Localized.text('ox_discovery.not_set_lnurl_tips'));
      return;
    }

    if (lnurl.contains('@')) {
      try {
        lnurl = await Zaps.getLnurlFromLnaddr(lnurl);
      } catch (error) {
        CommonToast.instance.show(context, Localized.text('ox_usercenter.enter_lnurl_address_toast'));
        return;
      }
    }

    if (isAssistedProcess) {
      OXNavigator.presentPage(
        context,
        (context) => MomentZapPage(
          userDB: userDB,
          eventId: eventId,
          lnurl: lnurl,
          handler: this,
        ),
      );
    } else {
      handleZapChannel(
        context,
        lnurl: lnurl,
        zapAmount: zapAmount,
        eventId: eventId,
        description: description,
        privateZap: privateZap,
      );
    }
  }

  handleZapChannel(BuildContext context,{
    required String lnurl,
    int? zapAmount,
    String? eventId,
    String? description,
    bool? privateZap,
    IMint? mint,
    bool showLoading = false,
  }) async {
    final recipient = userDB.pubKey;
    zapAmount = zapAmount ?? OXUserInfoManager.sharedInstance.defaultZapAmount;
    if (isDefaultEcashWallet) {
      mint = mint ?? OXWalletInterface.getDefaultMint();
      String errorMsg = preprocessHandleZapWithEcash(context, mint, zapAmount);
      if(errorMsg.isNotEmpty){
        await CommonToast.instance.show(context,errorMsg);
        return;
      }
      if(showLoading) OXLoading.show();
      // Map<String, dynamic> zapsInfo = await getInvoice(
      //     sats: zapAmount,
      //     recipient: recipient,
      //     lnurl: lnurl,
      //     eventId: eventId,
      //     description: description,
      //     privateZap: privateZap ?? false);
      // await handleZapWithEcash(mint: mint!, zapsInfo: zapsInfo, context: context);
      await Future.delayed(const Duration(seconds: 3));
      Map<String, dynamic> zapsInfo = {};
      if(showLoading) OXLoading.dismiss();
      zapsInfoCallback?.call(zapsInfo);
    } else {
      Map<String, dynamic> zapsInfo = await getInvoice(
          sats: zapAmount,
          recipient: recipient,
          lnurl: lnurl,
          eventId: eventId,
          description: description,
          privateZap: privateZap ?? false);
      await handleZapWithThirdPartyWallet(zapsInfo: zapsInfo, context: context);
    }
  }

  handleZapWithEcash({
    required IMint mint,
    required Map zapsInfo,
    required BuildContext context,
  }) async {
    final invoice = zapsInfo['invoice'];

    final response = await Cashu.payingLightningInvoice(mint: mint, pr: invoice);
    if (!response.isSuccess) {
      await CommonToast.instance.show(context, response.errorMsg);
      return;
    }
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

  Future<Map<String,dynamic>> getInvoice({
    required int sats,
    required String recipient,
    required String lnurl,
    String? description,
    String? eventId,
    bool privateZap = false,
  }) async {
    final invokeResult = await OXUserCenterInterface.getInvoice(
      sats: sats,
      otherLnurl: lnurl,
      recipient: recipient,
      eventId: eventId,
      content: description,
      privateZap: privateZap,
    );
    final invoice = invokeResult['invoice'] ?? '';
    final zapper = invokeResult['zapper'] ?? '';

    final zapsInfo = {
      'zapper': zapper,
      'invoice': invoice,
      'amount': sats.toString(),
      'description': description,
    };

    return zapsInfo;
  }

  String preprocessHandleZapWithEcash(
    BuildContext context,
    IMint? mint,
    int sats,
  ) {
    final isWalletAvailable = OXWalletInterface.isWalletAvailable() ?? false;
    if (!isWalletAvailable) return 'Please open Ecash Wallet first';
    if (mint == null) return Localized.text('ox_discovery.mint_empty_tips');
    if (sats < 1) return Localized.text('ox_discovery.enter_amount_tips');
    if (sats > mint.balance) return Localized.text('ox_discovery.insufficient_balance_tips');
    return '';
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
}
