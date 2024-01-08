import 'package:cashu_dart/cashu_dart.dart';
import 'package:ox_common/log_util.dart';

class EcashService {

  static Future<Receipt?> createLightningInvoice({required IMint mint, required int amount}) async {
    Receipt? receipt;
    try {
      receipt = await Cashu.createLightningInvoice(mint: mint, amount: amount);
    } catch (e, s) {
      LogUtil.e('Create Lightning Invoice Failed: $e\r\n$s');
    }
    return receipt;
  }

  static Future<String?> sendEcash({required IMint mint, required int amount, String memo = ''}) async {
    String? token;
    try {
      token = await Cashu.sendEcash(mint: mint, amount: amount, memo: memo);
    } catch (e, s) {
      LogUtil.e('Send Ecash Failed: $e\r\n$s');
    }
    return token;
  }

  static Future<(String memo, int amount)?> redeemEcash(String ecashString) async {
    (String memo, int amount)? result;
    try {
      result = await Cashu.redeemEcash(ecashString);
    }catch(e,s){
      LogUtil.e('Create Lightning Invoice Failed: $e\r\n$s');
    }
    return result;
  }
}
