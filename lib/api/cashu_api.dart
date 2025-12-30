
import 'dart:async';
import 'dart:math';

import '../business/mint/mint_helper.dart';
import '../business/proof/proof_helper.dart';
import '../business/proof/token_helper.dart';
import '../business/transaction/hitstory_store.dart';
import '../business/transaction/transaction_helper.dart';
import '../business/wallet/cashu_manager.dart';
import '../core/mint_actions.dart';
import '../core/nuts/define.dart';
import '../core/nuts/nut_00.dart';
import '../core/nuts/token/proof_isar.dart';
import '../core/nuts/v1/nut_11.dart';
import '../core/nuts/v1/nut_14.dart';
import '../model/cashu_token_info.dart';
import '../model/history_entry_isar.dart';
import '../model/invoice_isar.dart';
import '../model/invoice_listener.dart';
import '../model/mint_model_isar.dart';
import '../utils/network/response.dart';
import 'general_client.dart';
import 'v0/client.dart';
import 'v1/client.dart';

final CashuAPI Cashu = CashuAPI();

class CashuAPI {
  /**************************** Financial ****************************/
  /// Calculate the total balance across all mints.
  int totalBalance() {
    final mints = [...CashuManager.shared.mints];
    return mints.fold(0, (pre, mint) => pre + mint.balance);
  }

  /// Get a list of history entries with pagination support.
  ///
  /// [size]: Number of entries to return.
  /// [lastHistoryId]: The ID of the last history entry from the previous fetch.
  Future<List<IHistoryEntryIsar>> getHistoryList({
    int size = 10,
    int? lastHistoryId,
  }) async {
    await CashuManager.shared.setupFinish.future;
    final allHistory = await HistoryStore.getHistory();

    var startIndex = 0;
    if (lastHistoryId != null) {
      final index = allHistory.indexWhere((element) => element.id == lastHistoryId);
      if (index >= 0) {
        startIndex = index + 1;
      }
    }
    final end = min(allHistory.length, startIndex + size);
    return allHistory.sublist(startIndex, end);
  }

  Future<List<IHistoryEntryIsar>> getHistory({
    List<String> value = const [],
  }) async {
    await CashuManager.shared.setupFinish.future;
    return await HistoryStore.getHistory(values: value);
  }

  /// Check the availability of proofs for a given mint.
  /// Returns the amount of invalid proof, or null if the request fails.
  Future<int?> checkProofsAvailable(IMintIsar mint) async {

    await CashuManager.shared.setupFinish.future;

    final proofs = await ProofHelper.getProofs(mint.mintURL);
    final response = await mint.tokenCheckAction(mintURL: mint.mintURL, proofs: proofs);
    if (!response.isSuccess) return null;
    if (response.data.length != proofs.length) {
      throw Exception('[E][Cashu - checkProofsAvailable] '
          'The length of states(${response.data.length}) and proofs(${proofs.length}) is not consistent');
    }

    var burnedAmount = 0;
    final burnedProofs = <ProofIsar>[];
    final liveOrPendingProofs = <ProofIsar>[];
    final nowMs = DateTime.now().millisecondsSinceEpoch;

    for (int i = 0; i < response.data.length; i++) {
      final proof = proofs[i].copyWith(
        stateRaw: response.data[i].index,
        lastCheckedMs: nowMs,
      );
      switch (proof.state) {
        case TokenState.live:
          liveOrPendingProofs.add(proof);
          break;
        case TokenState.burned:
          burnedAmount += proof.amountNum;
          burnedProofs.add(proof);
          break ;
        case TokenState.inFlight:
          liveOrPendingProofs.add(proof);
          break ;
      }
    }

    // Delete the proofs before updating the assets; otherwise, the updated asset data will be inaccurate.
    await ProofHelper.deleteProofs(proofs: burnedProofs);
    if (liveOrPendingProofs.isNotEmpty) {
      await ProofHelper.saveProofStates(liveOrPendingProofs);
    }
    await CashuManager.shared.updateMintBalance(mint);

    return burnedAmount;
  }

  /// Retrieves all 'used' proofs for a given mint.
  Future<List<ProofIsar>> getAllUseProofs(IMintIsar mint) {
    return ProofHelper.getProofs(mint.mintURL);
  }

  /// Determines the spendability of an eCash token from a given history entry.
  ///
  /// Extracts the eCash token from [entry] and checks if it is spendable.
  /// Returns `true` if the token is spendable, `false` if not, or `null` if the status is indeterminable.
  Future<bool?> isEcashTokenSpendableFromHistory(IHistoryEntryIsar entry) async {
    if (entry.type != IHistoryType.eCash) return null;

    final spendable = await isEcashTokenSpendableFromToken(entry.value);
    if (spendable == null) return null;

    entry.isSpent = !spendable;
    if (entry.isSpent == true) {
      await HistoryStore.updateHistoryEntry(entry);
    }
    return spendable;
  }

  Future<bool?> isEcashTokenSpendableFromToken(String token) async {
    if (!isCashuToken(token)) return null;

    final spendable = await TokenHelper.isTokenSpendable(token);
    if (spendable == null) return null;

    return spendable;
  }

  Future<String?> tryCreateSpendableEcashToken(String token) =>
      CashuAPIGeneralClient.tryCreateSpendableEcashToken(token);

  Future<CashuResponse<Receipt>> checkReceiptCompleted(Receipt receipt) async {

    var isRedeemed = await HistoryStore.hasReceiptRedeemHistory(receipt);
    if (isRedeemed) return CashuResponse.fromSuccessData(receipt);

    final success = await CashuManager.shared.invoiceHandler.checkInvoice(receipt, true);
    if (success) return CashuResponse.fromSuccessData(receipt);

    // Fetch again
    isRedeemed = await HistoryStore.hasReceiptRedeemHistory(receipt);
    if (isRedeemed) return CashuResponse.fromSuccessData(receipt);

    return CashuResponse.generalError();
  }

  /**************************** Mint ****************************/
  /// Returns a list of all mints.
  Future<List<IMintIsar>> mintList() async {
    await CashuManager.shared.setupFinish.future;
    return CashuManager.shared.mints;
  }

  /// Adds a new mint with the given URL.
  /// Throws an exception if the URL does not start with 'https://'.
  /// Returns the newly added mint, or null if the operation fails.
  Future<IMintIsar?> addMint(String mintURL) async {
    await CashuManager.shared.setupFinish.future;
    return await CashuManager.shared.addMint(mintURL);
  }

  /// Deletes the specified mint.
  /// Returns true if the deletion is successful.
  Future<bool> deleteMint(IMintIsar mint) async {
    await CashuManager.shared.setupFinish.future;
    return CashuManager.shared.deleteMint(mint);
  }

  /// Edits the name of the specified mint.
  Future editMintName(IMintIsar mint, String name) async {
    await CashuManager.shared.setupFinish.future;
    if (mint.name == name) return ;
    mint.name = name;
    CashuManager.shared.updateMintName(mint);
  }

  /// Retrieves mint information from the specified mint.
  Future<bool> fetchMintInfo(IMintIsar mint) async {
    return MintHelper.updateMintInfoFromRemote(mint);
  }

  /**************************** Transaction ****************************/
  /// Sends e-cash using the provided mint and amount.
  ///
  /// [mint]: The mint object to use for sending e-cash.
  /// [amount]: The amount of e-cash to send.
  /// [memo]: An optional memo for the transaction.
  ///
  /// Returns the encoded token if successful, otherwise null.
  Future<CashuResponse<String>> sendEcash({
    required IMintIsar mint,
    required int amount,
    String memo = '',
    String unit = 'sat',
    List<ProofIsar>? proofs,
  }) => CashuAPIGeneralClient.sendEcash(
    mint: mint,
    amount: amount,
    memo: memo,
    unit: unit,
    proofs: proofs,
  );

  /// Sends a list of e-cash amounts using the provided mint.
  Future<CashuResponse<List<String>>> sendEcashList({
    required IMintIsar mint,
    required List<int> amountList,
    List<String> publicKeys = const [],
    List<String>? refundPubKeys,
    DateTime? locktime,
    int? signNumRequired,
    String memo = '',
    String unit = 'sat',
  }) => CashuAPIGeneralClient.sendEcashList(
    mint: mint,
    amountList: amountList,
    customSecret: P2PKSecret.fromOptions(
      receivePubKeys: publicKeys,
      refundPubKeys: refundPubKeys,
      lockTime: locktime,
      signNumRequired: signNumRequired,
    ),
    memo: memo,
    unit: unit,
  );

  /// Sends e-cash to specified recipients identified by their public keys.
  ///
  /// [mint]: The mint object to use for sending e-cash.
  /// [amount]: The amount of e-cash to send.
  /// [publicKeys]: A list of public keys representing the recipients of the e-cash.
  /// [refundPubKeys]: Optional public keys for refunds after [locktime].
  /// [locktime]: Optional timestamp (seconds) for when the e-cash becomes refundable.
  /// [memo]: An optional memo for the transaction.
  /// [unit]: The unit of the e-cash to be sent. Default is 'sat'.
  /// [proofs]: An optional list of proofs for transaction verification.
  ///
  /// Returns the encoded token if successful, otherwise null.
  Future<CashuResponse<String>> sendEcashToPublicKeys({
    required IMintIsar mint,
    required int amount,
    required List<String> publicKeys,
    List<String>? refundPubKeys,
    DateTime? locktime,
    int? signNumRequired,
    P2PKSecretSigFlag? sigFlag,
    String memo = '',
    String unit = 'sat',
    List<ProofIsar>? proofs,
  }) => CashuAPIGeneralClient.sendEcashToPublicKeys(
    mint: mint,
    amount: amount,
    publicKeys: publicKeys,
    refundPubKeys: refundPubKeys,
    locktime: locktime,
    signNumRequired: signNumRequired,
    sigFlag: sigFlag,
    memo: memo,
    unit: unit,
    proofs: proofs,
  );

  Future<CashuResponse<String>> createEcashWithHTLC({
    required IMintIsar mint,
    required int amount,
    required String hash,
    List<String>? receivePubKeys,
    List<String>? refundPubKeys,
    String memo = '',
    String unit = 'sat',
    List<ProofIsar>? proofs,
  }) => CashuAPIGeneralClient.createEcashWithHTLC(
    mint: mint,
    amount: amount,
    hash: hash,
    receivePubKeys: receivePubKeys,
    refundPubKeys: refundPubKeys,
    memo: memo,
    unit: unit,
    proofs: proofs,
  );

  /// Redeems e-cash from the given string.
  /// [ecashString]: The string representing the e-cash.
  /// Returns a tuple containing memo and amount if successful.
  Future<CashuResponse<(String memo, int amount)>> redeemEcash({
    required String ecashString,
  }) => CashuAPIGeneralClient.redeemEcash(
    ecashString: ecashString,
  );

  Future<bool> redeemEcashFromInvoice({
    required IMintIsar mint,
    required String pr,
  }) => CashuAPIGeneralClient.redeemEcashFromInvoice(mint: mint, pr: pr);

  /// Processes payment of a Lightning invoice.
  ///
  /// [mint]: The mint to use for payment.
  /// [pr]: The payment request string of the Lightning invoice.
  /// [amount]: The amount to pay.
  ///
  /// Returns true if payment is successful.
  Future<CashuResponse> payingLightningInvoice({
    required IMintIsar mint,
    required String pr,
    String paymentKey = '',
    CashuProgressCallback? processCallback,
  }) {
    if (mint.maxNutsVersion >= 1) {
      return CashuAPIV1Client.payingLightningInvoice(
        mint: mint,
        pr: pr,
        paymentKey: paymentKey,
        processCallback: processCallback,
      );
    }
    return CashuAPIV0Client.payingLightningInvoice(
      mint: mint,
      pr: pr,
      paymentKey: paymentKey,
    );
  }

  /// Creates a Lightning invoice with the given amount.
  ///
  /// [mint]: The mint to issue the invoice.
  /// [amount]: The amount for the invoice.
  ///
  /// Returns the created invoice object if successful, otherwise null.
  Future<Receipt?> createLightningInvoice({
    required IMintIsar mint,
    required int amount,
  }) {
    return TransactionHelper.requestCreateInvoice(
      mint: mint,
      amount: amount,
    );
  }

  Future<bool> deleteLightningInvoice(Receipt receipt) =>
      CashuManager.shared.invoiceHandler.deleteInvoice(receipt);

  /// Adds an invoice listener.
  void addInvoiceListener(CashuListener listener)  {
    CashuManager.shared.addListener(listener);
  }

  /// Removes an invoice listener.
  void removeInvoiceListener(CashuListener listener)  {
    CashuManager.shared.removeListener(listener);
  }

  /// Generates a backup token for the specified mints.
  ///
  /// This method retrieves the local proofs for the given mints and generates a backup token.
  /// The process does not involve any checks or validations on the state of the proofs;
  /// it simply gathers the local proofs as they are and constructs a token.
  ///
  /// Note:
  /// - This method does not validate the status or usability of the proofs.
  ///   It purely retrieves the existing local proofs and generates a token for backup purposes.
  ///
  Future<CashuResponse<String>> getBackUpToken(List<IMintIsar> mints) =>
      CashuAPIGeneralClient.getBackUpToken(mints);

  /// Imports a Cashu token.
  ///
  /// This method is used to import a Cashu token by redeeming e-cash from the token string.
  /// The token contains information about the mint, which needs to ensure a successful network
  /// connection to proceed. If the mint is unreachable or there are connectivity issues,
  /// the associated proofs cannot be added.
  ///
  /// Note:
  /// - The `proofs` included in the token are not processed or utilized in any way by this method.
  ///   They are directly stored locally as-is for future use.
  ///
  Future<CashuResponse> importCashuToken(String token) =>
      CashuAPIGeneralClient.redeemEcash(
        ecashString: token,
        isUseSwap: false,
      );

  String createHTLCHash(String preimage) {
    final (_, String hashString) = HTLC.createHashData(preimage);
    return hashString;
  }

  /**************************** Tools ****************************/
  /// Converts the amount in a Lightning Network payment request to satoshis.
  /// [pr]: BOLT11 encoded payment request string.
  /// Returns the amount from the payment request in satoshis as an integer, or null if the
  /// payment request is invalid or processing fails.
  int? amountOfLightningInvoice(String pr) =>
      CashuAPIGeneralClient.amountOfLightningInvoice(pr);

  /// Retrieves information of a token from its e-cash token string.
  ///
  /// [ecashToken]: The e-cash token string.
  ///
  /// Returns a tuple of memo and total amount if successful, otherwise null.
  CashuTokenInfo? infoOfToken(String ecashToken) =>
      CashuAPIGeneralClient.infoOfToken(ecashToken);

  /// Checks if a given string is a valid Cashu token.
  bool isCashuToken(String str) {
    return Nut0.isCashuToken(str);
  }

  /// Determines if a given string is a valid Lightning Network (LN) invoice.
  /// Strips common URI prefixes before validation.
  bool isLnInvoice(String str) => CashuAPIGeneralClient.isLnInvoice(str);

  Future<String?> addP2PKSignatureToToken({
    required String ecashString,
    required List<String> pukeyList,
  }) =>
      CashuAPIGeneralClient.addP2PKSignatureToToken(
        ecashString: ecashString,
        pubkeyList: pukeyList,
      );

  void startHighFrequencyDetection() async {
    await CashuManager.shared.setupFinish.future;
    CashuManager.shared.invoiceHandler.startHighFrequencyDetection();
  }

  void stopHighFrequencyDetection() async {
    await CashuManager.shared.setupFinish.future;
    CashuManager.shared.invoiceHandler.stopHighFrequencyDetection();
  }
}