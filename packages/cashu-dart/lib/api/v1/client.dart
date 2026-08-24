
import 'package:bolt11_decoder/bolt11_decoder.dart';
import 'package:cashu_dart/utils/third_party_extensions.dart';

import '../../business/proof/proof_helper.dart';
import '../../business/transaction/transaction_helper.dart';
import '../../business/wallet/cashu_manager.dart';
import '../../core/nuts/v1/nut_05.dart';
import '../../core/nuts/v1/nut_08.dart';
import '../../model/mint_model_isar.dart';
import '../../utils/network/response.dart';

class CashuAPIV1Client {

  /// Processes payment of a Lightning invoice.
  /// [mint]: The mint to use for payment.
  /// [pr]: The payment request string of the Lightning invoice.
  /// [amount]: The amount to pay.
  /// Returns true if payment is successful.
  static Future<CashuResponse> payingLightningInvoice({
    required IMintIsar mint,
    required String pr,
    String paymentKey = '',
    CashuProgressCallback? processCallback,
  }) async {

    await CashuManager.shared.setupFinish.future;

    if (pr.isEmpty) return CashuResponse.fromErrorMsg('pr is empty');

    // Get quote ID.
    processCallback?.call('Getting the quoteId...');
    final quoteResponse = await Nut5.requestMeltQuote(
      mintURL: mint.mintURL,
      request: pr,
    );
    if (!quoteResponse.isSuccess || quoteResponse.data.quote.isEmpty) return quoteResponse;
    final quoteID = quoteResponse.data.quote;

    // Get fee.
    processCallback?.call('Getting the quote info...');
    final quoteInfoResponse = await Nut5.checkMintQuoteState(
      mintURL: mint.mintURL,
      quoteID: quoteID,
    );
    if (!quoteInfoResponse.isSuccess) return quoteInfoResponse;
    final fee = int.tryParse(quoteInfoResponse.data.fee) ?? 0;

    // Get proofs for pay.
    final amount = Bolt11PaymentRequest(pr).satsAmount;

    processCallback?.call('Looking for proof for payment...');
    final response = await ProofHelper.getProofsForMelt(
      mint: mint,
      proofRequest: ProofRequest.amount(amount + fee),
    );
    if (!response.isSuccess) return response;

    processCallback?.call('Paying...');
    final proofs = response.data;
    final payingResponse = await TransactionHelper.payingTheQuote(
      mint: mint,
      paymentId: quoteID,
      historyValue: pr,
      amount: amount,
      proofs: proofs,
      fee: fee.toInt(),
      meltAction: Nut8.payingTheQuote,
      paymentKey: paymentKey,
    );
    if (payingResponse.isSuccess) {
      await CashuManager.shared.updateMintBalance(mint);
    }
    return payingResponse;
  }
}