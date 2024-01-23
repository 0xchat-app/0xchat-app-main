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

  static Future<String?> sendEcash({required IMint mint, required int amount, String? memo, List<Proof>? proofs}) async {
    String? token;
    try {
      token = await Cashu.sendEcash(mint: mint, amount: amount, memo: memo ?? '',proofs: proofs);
    } catch (e, s) {
      LogUtil.e('Send Ecash Failed: $e\r\n$s');
    }
    return token;
  }

  static Future<CashuResponse<(String memo, int amount)>> redeemEcash(String ecashString) async {
    try {
      return await Cashu.redeemEcash(ecashString);
    } catch(e, s) {
      final msg = 'Create Lightning Invoice Failed: $e\r\n$s';
      return CashuResponse.fromErrorMsg(msg);
    }
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

  static Future<bool?> payingLightningInvoice({required IMint mint, required String amount}) async {
    bool? result;
    try{
      result = await Cashu.payingLightningInvoice(mint: mint, pr: amount);
    }catch(e,s){
      LogUtil.e('decode Lightning Invoice Failed: $e\r\n$s');
    }
    return result;
  }

  static Future<List<Proof>> getAllUseProofs({required IMint mint}) async {
    List<Proof> proofs = [];
    try{
      proofs = await Cashu.getAllUseProofs(mint);
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

  static Future<List<IHistoryEntry>> getHistoryList() async {
    List<IHistoryEntry> historyEntry = [];
    try {
      historyEntry = await Cashu.getHistoryList();
    } catch (e, s) {
      LogUtil.e('Get History List Failed: $e\r\n$s');
    }
    return historyEntry;
  }

  static Future<IMint?> addMint(String mintURL) async {
    if(!mintURL.startsWith('https://')){
      mintURL = 'https://$mintURL';
    }
    return await Cashu.addMint(mintURL);
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

  static Future<bool?> checkEcashTokenSpendable({required IHistoryEntry entry}) async {
    bool? result;
    try {
      result = await Cashu.isEcashTokenSpendableFromHistory(entry);
    } catch (e, s) {
      LogUtil.e('Check Ecash Token Spendable: $e\r\n$s');
    }
    return result;
  }

  static Future<void> editMintName(IMint mint, String name) async {
    return await Cashu.editMintName(mint, name);
  }

  static int totalBalance() {
    return Cashu.totalBalance();
  }
}
