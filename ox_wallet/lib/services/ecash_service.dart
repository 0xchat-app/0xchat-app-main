import 'package:cashu_dart/cashu_dart.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_wallet/services/ecash_manager.dart';

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

  static Future<String?> sendEcash({required IMint mint, required int amount, String? memo, List<Proof>? proofs}) async {
    String? token;
    try {
      token = await Cashu.sendEcash(mint: mint, amount: amount, memo: memo ?? '',proofs: proofs);
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

  static int? decodeLightningInvoice({required String invoice}) {
    int? amount;
    try{
      amount = Cashu.amountOfLightningInvoice(invoice);
    }catch(e,s){
      LogUtil.e('decode Lightning Invoice Failed: $e\r\n$s');
    }
    return amount;
  }

  static Future<bool?> payingLightningInvoice({required String amount}) async {
    bool? result;
    try{
      result = await Cashu.payingLightningInvoice(mint: EcashManager.shared.defaultIMint, pr: amount);
    }catch(e,s){
      LogUtil.e('decode Lightning Invoice Failed: $e\r\n$s');
    }
    return result;
  }

  static Future<List<Proof>> getAllUseProofs() async {
    List<Proof> proofs = [];
    try{
      proofs = await Cashu.getAllUseProofs(EcashManager.shared.defaultIMint);
    }catch(e,s){
      LogUtil.e('decode Lightning Invoice Failed: $e\r\n$s');
    }
    return proofs;
  }

  static bool isLnInvoice(String invoice){
    return Cashu.isLnInvoice(invoice);
  }

  static bool isCashuToken(String token){
    return Cashu.isCashuToken(token);
  }

  static getHistoryList() async {
    List<IHistoryEntry> historyEntry = await Cashu.getHistoryList();
  }

  static Future<IMint?> addMint(String mintURL) async {

  }

  static Future<bool> deleteMint(IMint mint) async {
    try {
      return await Cashu.deleteMint(mint);
    } catch (e, s) {
      LogUtil.e('Delete Mint Failed: $e\r\n$s');
      return false;
    }
  }

  static Future<int?> checkProofsAvailable(IMint mint) async {
    int? result;
    try {
      result = await Cashu.checkProofsAvailable(mint);
    } catch (e, s) {
      LogUtil.e('Check Proofs Available Failed: $e\r\n$s');
    }
    return result;
  }

  static Future<void> editMintName(IMint mint, String name) async {
    return await Cashu.editMintName(mint, name);
  }
}
