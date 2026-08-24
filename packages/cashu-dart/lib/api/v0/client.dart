
import 'package:bolt11_decoder/bolt11_decoder.dart';

import '../../business/proof/proof_helper.dart';
import '../../business/transaction/transaction_helper.dart';
import '../../business/wallet/cashu_manager.dart';
import '../../core/nuts/v0/nut_05.dart';
import '../../core/nuts/v0/nut_08.dart';
import '../../model/mint_model_isar.dart';
import '../../utils/network/response.dart';

class CashuAPIV0Client {

  /// Processes payment of a Lightning invoice.
  /// [mint]: The mint to use for payment.
  /// [pr]: The payment request string of the Lightning invoice.
  /// [amount]: The amount to pay.
  /// Returns true if payment is successful.
  static Future<CashuResponse> payingLightningInvoice({
    required IMintIsar mint,
    required String pr,
    String paymentKey = '',
  }) async {

    await CashuManager.shared.setupFinish.future;

    // Get fee
    final checkResponse = await Nut5.checkingLightningFees(mintURL: mint.mintURL, pr: pr);
    if (!checkResponse.isSuccess) return checkResponse;
    final fee = checkResponse.data;

    // Get amount
    final req = Bolt11PaymentRequest(pr);
    final amount = (req.amount.toDouble() * 100000000).toInt();

    final proofsResponse = await ProofHelper.getProofsForMelt(
      mint: mint,
      proofRequest: ProofRequest.amount(amount + fee),
    );
    if (!proofsResponse.isSuccess) return proofsResponse;

    final proofs = proofsResponse.data;
    final payingResponse = await TransactionHelper.payingTheQuote(
      mint: mint,
      paymentId: pr,
      historyValue: pr,
      amount: amount,
      proofs: proofs,
      fee: fee,
      meltAction: Nut8.payingTheInvoice,
      paymentKey: paymentKey,
    );

    if (payingResponse.isSuccess) {
      await CashuManager.shared.updateMintBalance(mint);
    }

    return payingResponse;
  }
}