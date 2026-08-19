
import 'package:bolt11_decoder/bolt11_decoder.dart';

import '../business/proof/keyset_helper.dart';
import '../business/proof/proof_helper.dart';
import '../business/proof/proof_store.dart';
import '../business/proof/secret_helper.dart';
import '../business/proof/witness_helper.dart';
import '../business/transaction/hitstory_store.dart';
import '../business/wallet/cashu_manager.dart';
import '../core/mint_actions.dart';
import '../core/nuts/define.dart';
import '../core/nuts/nut_00.dart';
import '../core/nuts/token/proof_isar.dart';
import '../core/nuts/token/token_model.dart';
import '../core/nuts/v1/nut.dart';
import '../model/cashu_token_info.dart';
import '../model/history_entry_isar.dart';
import '../model/lightning_invoice_isar.dart';
import '../model/mint_model_isar.dart';
import '../utils/isolate_worker.dart';
import '../utils/log_util.dart';
import '../utils/network/response.dart';
import '../utils/third_party_extensions.dart';

class CashuAPIGeneralClient {

  static const _useProofDLEQVerify = false;

  static const _lnPrefix = [
    'lightning:',
    'lightning=',
    'lightning://',
    'lnurlp://',
    'lnurlp=',
    'lnurlp:',
    'lnurl:',
    'lnurl=',
    'lnurl://',
  ];

  static Future<CashuResponse<String>> sendEcash({
    required IMintIsar mint,
    required int amount,
    String memo = '',
    String unit = 'sat',
    List<ProofIsar>? proofs,
  }) async {

    await CashuManager.shared.setupFinish.future;

    // get proofs
    final response = await ProofHelper.getProofsForECash(
      mint: mint,
      proofRequest: ProofRequest.proofs(proofs, amount),
    );
    if (!response.isSuccess) return response.cast();

    final sendProofs = response.data;
    final encodedToken = Nut0.encodedToken(
      Token(
        entries: [TokenEntry(mint: mint.mintURL, proofs: sendProofs)],
        memo: memo,
        unit: unit,
      ),
    );

    await HistoryStore.addToHistory(
      amount: -(sendProofs.totalAmount),
      type: IHistoryType.eCash,
      value: encodedToken,
      mints: [mint.mintURL],
    );

    await ProofHelper.deleteProofs(proofs: sendProofs);
    await CashuManager.shared.updateMintBalance(mint);

    LogUtils.e(() => '[I][Cashu - sendEcash] Create Ecash: $encodedToken');
    return CashuResponse.fromSuccessData(encodedToken);
  }

  static Future<CashuResponse<List<String>>> sendEcashList({
    required IMintIsar mint,
    required List<int> amountList,
    Nut10Secret? customSecret,
    String memo = '',
    String unit = 'sat',
  }) async {

    await CashuManager.shared.setupFinish.future;

    final response = await ProofHelper.getProofsWithAmountList(
      mint: mint,
      amounts: amountList,
      customSecret: customSecret,
    );
    if (!response.isSuccess) return response.cast();

    final proofPackage = response.data;
    final tokenList = <String>[];

    for (var proofs in proofPackage) {
      final amount = proofs.totalAmount;
      final encodedToken = Nut0.encodedToken(
        Token(
          entries: [TokenEntry(mint: mint.mintURL, proofs: proofs)],
          memo: memo,
          unit: unit,
        ),
      );

      tokenList.add(encodedToken);
      await HistoryStore.addToHistory(
        amount: -amount,
        type: IHistoryType.eCash,
        value: encodedToken,
        mints: [mint.mintURL],
      );
      await ProofHelper.deleteProofs(proofs: proofs);
    }

    await CashuManager.shared.updateMintBalance(mint);

    return CashuResponse.fromSuccessData(tokenList);
  }

  static Future<CashuResponse<String>> sendEcashToPublicKeys({
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
  }) async {

    await CashuManager.shared.setupFinish.future;

    if (publicKeys.isEmpty) {
      return CashuResponse.fromErrorMsg('PublicKeys is empty.');
    }

    // get proofs
    final response = await ProofHelper.getProofsForECash(
      mint: mint,
      proofRequest: ProofRequest.proofs(proofs, amount),
      customSecret: P2PKSecret.fromOptions(
        receivePubKeys: publicKeys,
        refundPubKeys: refundPubKeys,
        lockTime: locktime,
        signNumRequired: signNumRequired,
        sigFlag: sigFlag,
      ),
    );
    if (!response.isSuccess) return response.cast();

    final p2pkProofs = response.data;
    final encodedToken = Nut0.encodedToken(
      Token(
        entries: [TokenEntry(mint: mint.mintURL, proofs: p2pkProofs)],
        memo: memo,
        unit: unit,
      ),
    );

    await HistoryStore.addToHistory(
      amount: -(p2pkProofs.totalAmount),
      type: IHistoryType.eCash,
      value: encodedToken,
      mints: [mint.mintURL],
    );

    await ProofHelper.deleteProofs(proofs: p2pkProofs);
    await CashuManager.shared.updateMintBalance(mint);

    LogUtils.e(() => '[I][Cashu - sendEcash] Create Ecash: $encodedToken');
    return CashuResponse.fromSuccessData(encodedToken);
  }

  static Future<CashuResponse<String>> createEcashWithHTLC({
    required IMintIsar mint,
    required int amount,
    required String hash,
    List<String>? receivePubKeys,
    List<String>? refundPubKeys,
    String memo = '',
    String unit = 'sat',
    List<ProofIsar>? proofs,
  }) async {
    await CashuManager.shared.setupFinish.future;

    if (hash.isEmpty) {
      return CashuResponse.fromErrorMsg('hash is empty.');
    }

    // get proofs
    final response = await ProofHelper.getProofsForECash(
      mint: mint,
      proofRequest: ProofRequest.proofs(proofs, amount),
      customSecret: HTLCSecret.fromOptions(
        hash: hash,
        receivePubKeys: receivePubKeys,
        refundPubKeys: refundPubKeys,
      ),
    );
    if (!response.isSuccess) return response.cast();

    final htlcProofs = response.data;
    final encodedToken = Nut0.encodedToken(
      Token(
        entries: [TokenEntry(mint: mint.mintURL, proofs: htlcProofs)],
        memo: memo,
        unit: unit,
      ),
    );

    await HistoryStore.addToHistory(
      amount: -(htlcProofs.totalAmount),
      type: IHistoryType.eCash,
      value: encodedToken,
      mints: [mint.mintURL],
    );

    await ProofHelper.deleteProofs(proofs: htlcProofs);
    await CashuManager.shared.updateMintBalance(mint);

    LogUtils.e(() => '[I][Cashu - sendEcash] Create Ecash: $encodedToken');
    return CashuResponse.fromSuccessData(encodedToken);
  }

  static Future<CashuResponse<(String memo, int amount)>> redeemEcash({
    required String ecashString,
    bool isUseSwap = true,
  }) async {

    await CashuManager.shared.setupFinish.future;

    final token = Nut0.decodedToken(ecashString);
    if (token == null) return CashuResponse.fromErrorMsg('Invalid token');
    if (token.entries.isEmpty) return CashuResponse.fromErrorMsg('Token entries is empty.');
    if (token.unit.isNotEmpty && token.unit != 'sat') return CashuResponse.fromErrorMsg('Unsupported unit');

    final memo = token.memo;
    var receiveAmount = 0;
    final mints = <String>{};

    final tokenEntry = token.entries;

    return Future<CashuResponse<(String memo, int amount)>>(() async {
      try {
        for (var entry in tokenEntry) {
          var proofs = [...entry.proofs];

          final mint = await CashuManager.shared.getMint(entry.mint);
          if (mint == null) continue;

          if (_useProofDLEQVerify) {
            // Keyset info
            final keysetInfo = await KeysetHelper.tryGetMintKeysetInfo(mint, token.unit);
            final keyset = keysetInfo?.keyset ?? {};
            if (keyset.isNotEmpty) {
              final newProofs = await IsolateWorker.cashuWorker.run(() async {
                final newProofs = <ProofIsar>[];
                for (var proof in proofs) {
                  final pk = keyset[proof.amount] ?? '';
                  if (pk.isEmpty) continue;

                  final result = Nut12.verifyProof(
                    proof: proof,
                    publicKey: pk,
                  );
                  if (result == false) {
                    LogUtils.i(() => '[DLEQ - verify] verification failed, proof: $proof, pk: $pk');
                  } else {
                    newProofs.add(proof);
                  }
                }
                return newProofs;
              });
              proofs = newProofs;
            }
          }

          if (isUseSwap) {
            for (var proof in proofs) {
              await ProofHelper.addWitnessToProof(
                proof: proof,
              );
            }

            mints.add(mint.mintURL);

            final response = await ProofHelper.swapProofs(
              mint: mint,
              proofs: proofs,
            );
            if (!response.isSuccess) return response.cast();

            proofs = response.data;
          } else {
            ProofStore.addProofs(proofs);
          }

          receiveAmount += proofs.totalAmount;
        }

        await CashuManager.shared.updateMintBalance();

        if (receiveAmount > 0) {
          return CashuResponse.fromSuccessData((memo, receiveAmount));
        } else {
          return CashuResponse.fromErrorMsg('No funds available proofs for redemption.');
        }
      } catch (e, stack) {
        return CashuResponse.fromErrorMsg('Error: $e. Details: $stack');
      }
    }).whenComplete(() async {
      if (receiveAmount > 0) {
        await HistoryStore.addToHistory(
          amount: receiveAmount,
          type: IHistoryType.eCash,
          value: ecashString,
          mints: mints.toList(),
        );
        // If it is a self-issued token, set its status to "Spent."
        (await HistoryStore.getHistory(values: [ecashString]))
            .where((history) => history.amount < 0)
            .forEach((history) {
          history.isSpent = true;
          HistoryStore.updateHistoryEntry(history);
        });
      }
    });
  }

  static Future<bool> redeemEcashFromInvoice({
    required IMintIsar mint,
    required String pr,
  }) async {

    final req = Bolt11PaymentRequest(pr);
    for (var tag in req.tags) {
      LogUtils.i(() => '[Cashu - invoice decode]${tag.type}: ${tag.data}');
    }
    final hash = req.tags.where((e) => e.type == 'payment_hash').firstOrNull?.data;
    if (hash == null) return false;

    final invoice = LightningInvoiceIsar(
      pr: pr,
      hash: hash,
      amount: req.satsAmount.toString(),
      mintURL: mint.mintURL,
    );
    return CashuManager.shared.invoiceHandler.checkInvoice(invoice, true);
  }

  static Future<CashuResponse<String>> getBackUpToken(List<IMintIsar> mints) async {
    List<TokenEntry> entryList = [];
    for (final mint in mints) {
      final proofs = await ProofHelper.getProofs(mint.mintURL);
      if (proofs.isNotEmpty) {
        entryList.add(
          TokenEntry(
            mint: mint.mintURL,
            proofs: proofs,
          ),
        );
      }
    }
    if (entryList.isEmpty) {
      return CashuResponse.fromErrorMsg('There is no valid proof');
    }
    return CashuResponse.fromSuccessData(
      Nut0.encodedToken(
        Token(
          entries: entryList,
        ),
        false,
      ),
    );
  }

  static Bolt11PaymentRequest? _tryConstructRequestFromPr(String pr) {
    pr = pr.trim();
    for (var prefix in _lnPrefix) {
      if (pr.startsWith(prefix)) {
        pr = pr.substring(prefix.length).trim();
        break; // Important to exit the loop once a match is found
      }
    }
    if (pr.isEmpty) return null;
    try {
      final req = Bolt11PaymentRequest(pr);
      for (var tag in req.tags) {
        LogUtils.i(() => '[Cashu - invoice decode]${tag.type}: ${tag.data}');
      }
      return req;
    } catch (e, s) {
      LogUtils.e(() => '[Cashu - invoice decode] error: $e, $s');
      return null;
    }
  }

  static int? amountOfLightningInvoice(String pr) {
    final request = _tryConstructRequestFromPr(pr);
    if (request == null) return null;
    return request.satsAmount;
  }

  static Future<String?> tryCreateSpendableEcashToken(String ecashToken) async {
    final originToken = Nut0.decodedToken(ecashToken);
    if (originToken == null) return null;

    final originEntries = originToken.entries;
    final newEntries = <TokenEntry>[];
    for (final entry in originEntries) {
      final mint = await CashuManager.shared.getMint(entry.mint);
      if (mint == null) continue ;

      final originProofs = [...entry.proofs];
      final response = await mint.tokenCheckAction(mintURL: mint.mintURL, proofs: originProofs);
      if (!response.isSuccess || response.data.length != originProofs.length) return null;

      final spendableProofs = <ProofIsar>[];
      final stateResult = response.data;
      for (var i = 0; i < stateResult.length; i++) {
        if (stateResult[i] == TokenState.live) {
          spendableProofs.add(originProofs[i]);
        }
      }
      if (spendableProofs.isEmpty) continue ;

      newEntries.add(
        TokenEntry(proofs: spendableProofs, mint: mint.mintURL)
      );
    }

    if (newEntries.isEmpty) return null;

    final newToken = Token(
      entries: newEntries,
      memo: originToken.memo,
      unit: originToken.unit,
    );

    return Nut0.encodedToken(newToken);
  }

  static CashuTokenInfo? infoOfToken(String ecashToken) {
    final token = Nut0.decodedToken(ecashToken);
    if (token == null) return null;

    final proofs = token.entries.fold(<ProofIsar>[], (pre, e) => pre..addAll(e.proofs));

    final firstProofsSecret = proofs.firstOrNull?.secret ?? '';

    return CashuTokenInfo(
      amount: token.sumProofsValue.toInt(),
      unit: token.unit,
      memo: token.memo,
      conditionInfo: SecretHelper.createSecretEntry(firstProofsSecret),
    );
  }

  static bool isLnInvoice(String str) {
    final request = _tryConstructRequestFromPr(str);
    return request != null;
  }

  static Future<String?> addP2PKSignatureToToken({
    required String ecashString,
    required List<String> pubkeyList,
  }) async {
    final tokenPackage = Nut0.decodedToken(ecashString);
    if (tokenPackage == null) return null;

    final tokenEntryList = tokenPackage.entries;
    for (var entry in tokenEntryList) {
      for (var proof in entry.proofs) {
        await ProofHelper.addWitnessToProof(
          proof: proof,
          conditionsType: ConditionType.p2pk,
          exParams: {
            ConditionType.p2pk: P2PKWitnessParam(pubkeyList: pubkeyList),
          },
        );
      }
    }
    return Nut0.encodedToken(tokenPackage);
  }
}