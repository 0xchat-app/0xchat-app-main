
import '../../core/DHKE_helper.dart';
import '../../core/mint_actions.dart';
import '../../core/nuts/define.dart';
import '../../core/nuts/nut_00.dart';
import '../../core/nuts/token/proof_isar.dart';
import '../../model/history_entry_isar.dart';
import '../../model/invoice_isar.dart';
import '../../model/mint_model_isar.dart';
import '../../model/unblinding_data_isar.dart';
import '../../utils/network/response.dart';
import '../mint/mint_helper.dart';
import '../proof/keyset_helper.dart';
import '../proof/proof_helper.dart';
import '../wallet/cashu_manager.dart';
import '../wallet/proof_blinding_manager.dart';
import 'hitstory_store.dart';
import 'invoice_store.dart';

typedef PayingTheInvoiceResponse = (
  bool paid,
  String preimage,
);

class TransactionHelper {

  static Future<Receipt?> requestCreateInvoice({
    required IMintIsar mint,
    required int amount,
  }) async {
    final response = await mint.createQuoteAction(
      mintURL: mint.mintURL,
      amount: amount,
    );
    if (!response.isSuccess) return null;
    await InvoiceStore.addInvoice(response.data);
    CashuManager.shared.invoiceHandler.addInvoice(response.data);
    return response.data;
  }

  static Future<CashuResponse<List<ProofIsar>>> requestTokensFromMint({
    required IMintIsar mint,
    required String quoteID,
    required int amount,
    String invoice = '',
    String unit = 'sat',
    bool tryUpdateKeysetsIfNeeded = true,
  }) async {
    // // check quote state
    // final quoteInfo = await Nut4.checkMintQuoteState(
    //   mintURL: mint.mintURL,
    //   quoteID: quoteID,
    // );
    // if (quoteInfo == null) return null;
    // final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    // final isTimeout = quoteInfo.expiry > 0 && quoteInfo.expiry < now;
    // if (isTimeout || quoteInfo.paid) return null;

    // get keyset
    final keysetInfo = await KeysetHelper.tryGetMintKeysetInfo(mint, unit);
    final keyset = keysetInfo?.keyset ?? {};
    if (keysetInfo == null || keyset.isEmpty) {
      return CashuResponse.fromErrorMsg('Keyset is empty.');
    }

    // create blinded messages
    final ( blindedMessages, secrets, rs, _ ) =
    DHKEHelper.createBlindedMessages(
      keysetId: keysetInfo.keysetId,
      amount: amount,
    );

    // request token
    final response = await mint.requestTokensAction(
      mintURL: mint.mintURL,
      quote: quoteID,
      blindedMessages: blindedMessages,
    );
    if (!response.isSuccess) {
      if (tryUpdateKeysetsIfNeeded && response.errorMsg.contains('keyset id unknown') || response.errorMsg.contains('keyset id inactive')) {
        await MintHelper.updateMintKeysetFromRemote(mint);
        return requestTokensFromMint(
          mint: mint,
          quoteID: quoteID,
          amount: amount,
          invoice: invoice,
          unit: unit,
          tryUpdateKeysetsIfNeeded: false,
        );
      } else if (response.errorMsg.contains('quote already issued')) {
        return CashuResponse.fromSuccessData([]);
      }
      return response.cast();
    }

    // unblinding
    final unblindingResponse = await ProofBlindingManager.shared.unblindingBlindedSignature((
      mint,
      unit,
      response.data,
      secrets,
      rs,
      [],
      ProofBlindingAction.minting,
      invoice,
    ));
    if (!unblindingResponse.isSuccess) {
      return unblindingResponse;
    }

    return CashuResponse.fromSuccessData(unblindingResponse.data);
  }

  static Future<CashuResponse<MeltResponse>> payingTheQuote({
    required IMintIsar mint,
    String paymentId = '',
    required String historyValue,
    required int amount,
    required List<ProofIsar> proofs,
    String unit = 'sat',
    required int fee,
    required Future<CashuResponse<MeltResponse>> Function({
      required String mintURL,
      required String quote,
      required List<ProofIsar> inputs,
      required List<BlindedMessage> outputs,
    }) meltAction,
    String paymentKey = '',
  }) async {

    proofs = [...proofs];

    // get keyset
    final keysetInfo = await KeysetHelper.tryGetMintKeysetInfo(mint, unit);
    final keyset = keysetInfo?.keyset ?? {};
    if (keysetInfo == null || keyset.isEmpty) return CashuResponse.fromErrorMsg('Keyset is empty');

    // create outputs
    final ( blindedMessages, secrets, rs, _ ) =
    DHKEHelper.createBlankOutputs(
      keysetId: keysetInfo.keysetId,
      amount: proofs.totalAmount - amount,
    );

    // melt token
    final meltResponse = await meltAction(
      mintURL: mint.mintURL,
      quote: paymentId,
      inputs: proofs,
      outputs: blindedMessages,
    );
    if (!meltResponse.isSuccess) return meltResponse;

    // unbinding
    final ( _, _, change ) = meltResponse.data;

    // unblinding
    final unblindingResponse = await ProofBlindingManager.shared.unblindingBlindedSignature((
      mint,
      unit,
      change,
      secrets,
      rs,
      [],
      ProofBlindingAction.melt,
      historyValue,
    ));
    if (!unblindingResponse.isSuccess) {
      return CashuResponse.fromErrorMsg('Unblinding error: ${unblindingResponse.errorMsg}');
    }
    final newProofs = unblindingResponse.data;

    await ProofHelper.deleteProofs(proofs: proofs, mint: mint);

    final consumedAmount = newProofs.totalAmount - proofs.totalAmount;
    await HistoryStore.addToHistory(
      amount: consumedAmount,
      type: IHistoryType.lnInvoice,
      value: historyValue,
      mints: [mint.mintURL],
      fee: -consumedAmount - amount,
    );

    if (paymentKey.isNotEmpty) {
      CashuManager.shared.notifyListenerForPaymentCompleted(paymentKey);
    }

    return meltResponse;
  }
}