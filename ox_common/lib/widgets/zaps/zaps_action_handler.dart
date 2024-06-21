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
import 'package:ox_common/widgets/zaps/zaps_assisted_page.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:cashu_dart/cashu_dart.dart';
import 'package:ox_module_service/ox_module_service.dart';

class ZapsActionHandler {
  final UserDB userDB;
  final bool isAssistedProcess;
  final bool? privateZap;
  Function(Map<String,dynamic> zapsInfo)? zapsInfoCallback;
  Function()? preprocessCallback;

  late bool isDefaultEcashWallet;

  int get defaultZapAmount => OXUserInfoManager.sharedInstance.defaultZapAmount;

  ZapsActionHandler({
    required this.userDB,
    this.privateZap,
    this.zapsInfoCallback,
    this.preprocessCallback,
    bool? isAssistedProcess,
  }) : isAssistedProcess = isAssistedProcess ?? false;

  static Future<ZapsActionHandler> create({
    required UserDB userDB,
    bool? privateZap,
    Function(Map<String, dynamic>)? zapsInfoCallback,
    Function()? preprocessCallback,
    bool? isAssistedProcess,
  }) async {
    ZapsActionHandler handler = ZapsActionHandler(
      userDB: userDB,
      privateZap: privateZap,
      zapsInfoCallback: zapsInfoCallback,
      preprocessCallback: preprocessCallback,
      isAssistedProcess: isAssistedProcess,
    );
    await handler.initialize();
    return handler;
  }

  Future<void> initialize() async {
    Map<String, dynamic> defaultWalletInfo = await getDefaultWalletInfo();
    isDefaultEcashWallet = defaultWalletInfo['isDefaultEcashWallet'];
  }

  Future<Map<String, dynamic>> getDefaultWalletInfo() async {
    String? pubkey = Account.sharedInstance.me?.pubKey;
    if (pubkey == null) return {};
    bool isShowWalletSelector = await OXCacheManager.defaultOXCacheManager.getForeverData('$pubkey.isShowWalletSelector') ?? true;
    String defaultWalletName = await OXCacheManager.defaultOXCacheManager.getForeverData('$pubkey.defaultWallet') ?? '';
    final ecashWalletName = WalletModel.walletsWithEcash.first.title;

    final isDefaultEcashWallet = !isShowWalletSelector && defaultWalletName == ecashWalletName;
    final isDefaultThirdPartyWallet = !isShowWalletSelector && defaultWalletName != ecashWalletName;

    return {
      'isShowWalletSelector': isShowWalletSelector,
      'defaultWalletName': defaultWalletName,
      'isDefaultEcashWallet': isDefaultEcashWallet,
      'isDefaultThirdPartyWallet': isDefaultThirdPartyWallet,
      'ecashWalletName': ecashWalletName,
    };
  }

  void setZapsInfoCallback(Function(Map<String, dynamic>) callback) {
    zapsInfoCallback = callback;
  }

  void removeZapsInfoCallback() {
    zapsInfoCallback = null;
  }

  void setPreprocessCallback(Function() callback){
    preprocessCallback = callback;
  }

  void removeCPreprocessCallback() {
    preprocessCallback = null;
  }

  Future<void> handleZap({
    required BuildContext context,
    int? zapAmount,
    String? eventId,
    String? description,
    bool? privateZap,
  }) async {
    String lnurl = userDB.lnAddress;

    if (lnurl.isEmpty || lnurl == 'null') {
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
        (context) => ZapsAssistedPage(
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
        showLoading: false
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
      preprocessCallback?.call();
      if(showLoading) OXLoading.show();
      Map<String, dynamic> zapsInfo = await getInvoice(
          sats: zapAmount,
          recipient: recipient,
          lnurl: lnurl,
          eventId: eventId,
          description: description,
          privateZap: privateZap ?? false);
      await handleZapWithEcash(mint: mint!, zapsInfo: zapsInfo, context: context);
      if(showLoading) OXLoading.dismiss();
      if(context.widget is ZapsAssistedPage) OXNavigator.pop(context);
      zapsInfoCallback?.call(zapsInfo);
    } else {
      if(showLoading) OXLoading.show();
      Map<String, dynamic> zapsInfo = await getInvoice(
          sats: zapAmount,
          recipient: recipient,
          lnurl: lnurl,
          eventId: eventId,
          description: description,
          privateZap: privateZap ?? false);
      preprocessCallback?.call();
      if(showLoading) OXLoading.dismiss();
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
    required Map<String,dynamic> zapsInfo,
    required BuildContext context,
  }) async {
    final isTapOnWallet = await _jumpToWalletSelectionPage(context,zapsInfo);
    if (isTapOnWallet) {
      if(context.widget is ZapsAssistedPage) OXNavigator.pop(context);
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

  Future<bool> _jumpToWalletSelectionPage(BuildContext context,Map<String,dynamic> result) async {
    var isConfirm = false;
    await OXModuleService.pushPage(context, 'ox_usercenter', 'ZapsInvoiceDialog', {
      'invoice': result['invoice'] ?? '',
      'walletOnPress': (WalletModel wallet) async {
        zapsInfoCallback?.call(result);
        isConfirm = true;
        return true;
      },
    });
    return isConfirm;
  }
}
