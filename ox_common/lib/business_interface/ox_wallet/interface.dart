
import 'package:cashu_dart/cashu_dart.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';

class OXWalletInterface {

  static const moduleName = 'ox_wallet';

  static IMint? getDefaultMint() {
    return OXModuleService.invoke<IMint?>(
      moduleName,
      'getDefaultMint',
      [],
      {},
    );
  }

  static bool? isWalletAvailable() {
    return OXModuleService.invoke<bool>(
      moduleName,
      'isWalletAvailable',
      [],
      {},
    );
  }

  static Widget buildMintIndicatorItem({
    required IMint? mint,
    required ValueChanged<IMint>? selectedMintChange,
  }) {
    return OXModuleService.invoke<Widget>(
      moduleName,
      'buildMintIndicatorItem',
      [],
      {
        #mint: mint,
        #selectedMintChange: selectedMintChange,
      },
    ) ?? SizedBox();
  }

  static bool checkWalletActivate() {
    return OXModuleService.invoke<bool>(
      moduleName,
      'checkWalletActivate',
      [],
      {},
    ) ?? false;
  }

  static bool openWalletHomePage() {
    return OXModuleService.invoke<bool>(
      moduleName,
      'openWalletHomePage',
      [],
      {},
    ) ?? false;
  }

  static walletSendLightningPage({String? invoice, String? amount}) {
    return OXModuleService.invoke(
      'ox_wallet',
      'walletSendLightningPage',
      [], {
        #invoice: invoice,
        #amount: amount,
      },
    );
  }

  static bool checkAndShowDialog(BuildContext context, CashuResponse response, IMint mint) {
    if (response.code == ResponseCode.tokenAlreadySpentError) {
      OXCommonHintDialog.show(
        context,
        title: Localized.text('ox_common.pull_failed'),
        content: 'Some proofs have already been used. Do you want to check the status of proofs in the assets? '
            '(This operation will delete the proofs that have already been used.)',
        isRowAction: true,
        actionList: [
          OXCommonHintAction.cancel(),
          OXCommonHintAction(text: () => 'Check', onTap: () async {
            OXLoading.show();
            final invalidProofCount = await Cashu.checkProofsAvailable(mint);
            OXLoading.dismiss();
            if(invalidProofCount == null){
              CommonToast.instance.show(context, 'Request failed, Please try again later');
              return;
            }
            await CommonToast.instance.show(context, 'Delete $invalidProofCount proofs');
            OXNavigator.pop(context);
          }),
        ],
      );
      return true;
    } else {
      return false;
    }
  }
}