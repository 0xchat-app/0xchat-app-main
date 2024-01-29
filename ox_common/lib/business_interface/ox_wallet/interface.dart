
import 'package:cashu_dart/cashu_dart.dart';
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
}