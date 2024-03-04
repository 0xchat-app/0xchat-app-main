
import 'package:cashu_dart/cashu_dart.dart';
import 'package:flutter/material.dart';
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
}