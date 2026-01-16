
import '../../core/DHKE_helper.dart';
import '../../core/keyset_store.dart';
import '../../core/mint_actions.dart';
import '../../core/nuts/define.dart';
import '../../core/nuts/nut_00.dart';
import '../../core/nuts/token/proof_isar.dart';
import '../../core/nuts/v1/nut.dart';
import '../../model/keyset_info_isar.dart';
import '../../model/mint_model_isar.dart';
import '../../model/unblinding_data_isar.dart';
import '../../utils/network/response.dart';
import '../wallet/proof_blinding_manager.dart';
import 'keyset_helper.dart';
import 'proof_store.dart';
import 'witness_helper.dart';

class ProofRequest {
  final int amount;
  final List<ProofIsar>? proofs;

  ProofRequest.amount(this.amount)
      : proofs = null;

  ProofRequest.proofs(this.proofs, this.amount);

  @override
  String toString() {
    return '${super.toString()}, amount: $amount, proofs: $proofs';
  }
}

class ProofResponse {
  final bool isSuccess;
  final int targetAmount;
  final int inputFee;
  final List<ProofIsar> proofs;

  int get overAmount => proofs.totalAmount - targetAmount - inputFee;
  bool get isOverProofs => overAmount > 0;

  // Success constructor
  ProofResponse.success({
    required this.targetAmount,
    required this.inputFee,
    required this.proofs,
  }) : isSuccess = true;

  // Failure constructor
  ProofResponse.failure({
    required this.targetAmount,
    this.inputFee = 0,
  })  : isSuccess = false,
        proofs = [];
}

class ProofHelper {

  static Future<List<ProofIsar>> getProofs(
    String mintURL,
    [bool orderAsc = false]
  ) async {
    final keysets = await KeysetStore.getKeyset(mintURL: mintURL);
    final usableProofs = await ProofStore.getProofs(ids: keysets.map((e) => e.keysetId).toList());
    // Drop burned proofs when state is known
    usableProofs.removeWhere((p) => p.state == TokenState.burned);
    if (orderAsc) {
      usableProofs.sort((a, b) => a.amount.compareTo(b.amount));
    } else {
      usableProofs.sort((a, b) => b.amount.compareTo(a.amount));
    }
    return usableProofs;
  }

  /// Persist proof states (live / pending) back to local DB.
  static Future<void> saveProofStates(List<ProofIsar> proofs) async {
    if (proofs.isEmpty) return;
    await ProofStore.addProofs(proofs);
  }

  static Future<ProofResponse> _getProofsWithRequest({
    required IMintIsar mint,
    required KeysetInfoIsar keysetInfo,
    required ProofRequest proofRequest,
    bool canIgnoreInputFee = false,
  }) async {
    List<ProofIsar> result = <ProofIsar>[];
    final amount = proofRequest.amount;
    var totalProofs = proofRequest.proofs ?? await getProofs(mint.mintURL, true);
    // Prioritize stored live proofs over pending without extra network call
    totalProofs.sort((a, b) {
      int priority(ProofIsar p) => p.state == TokenState.inFlight ? 1 : 0;
      final diff = priority(a) - priority(b);
      if (diff != 0) return diff;
      return b.amountNum.compareTo(a.amountNum); // keep larger amounts first (existing behavior)
    });

    // Try find available proofs can be combined to match the requested amount without considering input fee
    if (canIgnoreInputFee) {
      result = _findOneSubsetWithSum(totalProofs, amount, 0) ?? [];
      if (result.isNotEmpty) {
        return ProofResponse.success(
          targetAmount: proofRequest.amount,
          inputFee: 0,
          proofs: result,
        );
      }
    }

    // Try find available proofs can be combined to match the requested amount
    result = _findOneSubsetWithSum(totalProofs, amount, keysetInfo.inputFeePPK) ?? [];
    if (result.isNotEmpty) {
      return ProofResponse.success(
        targetAmount: proofRequest.amount,
        inputFee: _getInputFee(result, keysetInfo.inputFeePPK),
        proofs: result,
      );
    }

    int amountAvailable = 0;
    for (final proof in totalProofs) {
      amountAvailable += proof.amountNum;
      result.add(proof);
      if (amountAvailable >= amount) {
        break;
      }
    }

    final inputFee = _getInputFee(result, keysetInfo.inputFeePPK);
    if (amountAvailable >= amount + inputFee) {
      return ProofResponse.success(
        targetAmount: proofRequest.amount,
        inputFee: inputFee,
        proofs: result,
      );
    } else {
      return ProofResponse.failure(
        targetAmount: proofRequest.amount,
      );
    }
  }

  static CashuResponse<List<ProofIsar>> _parseResponseByECashCheck(
    ProofRequest request,
    CashuResponse<List<ProofIsar>> response,
  ) {
    if (!response.isSuccess) return response;
    if (response.data.totalAmount != request.amount) return CashuResponse.fromErrorMsg('Invalid amount proofs.');
    return response;
  }

  static Future<CashuResponse<List<ProofIsar>>> getProofsForECash({
    required IMintIsar mint,
    required ProofRequest proofRequest,
    Nut10Secret? customSecret,
    String unit = 'sat',
  }) async {
    // Keyset info
    final keysetInfo = await KeysetHelper.tryGetMintKeysetInfo(mint, unit);
    final keyset = keysetInfo?.keyset ?? {};
    if (keysetInfo == null || keyset.isEmpty) {
      return _parseResponseByECashCheck(
        proofRequest,
        CashuResponse.fromErrorMsg('Keyset not found.'),
      );
    }

    final canUseProofDirectly = customSecret == null;
    final proofResponse = await _getProofsWithRequest(
      mint: mint,
      keysetInfo: keysetInfo,
      proofRequest: proofRequest,
      canIgnoreInputFee: canUseProofDirectly,
    );
    if (!proofResponse.isSuccess) {
      return _parseResponseByECashCheck(
        proofRequest,
        CashuResponse.fromErrorMsg('Insufficient proofs'),
      );
    }
    final proofs = proofResponse.proofs;

    // Can use directly
    if (canUseProofDirectly) {
      if (proofResponse.targetAmount == proofResponse.proofs.totalAmount) {
        return _parseResponseByECashCheck(
          proofRequest,
          CashuResponse.fromSuccessData(proofs),
        );
      }
    }
    List<BlindedMessage> blindedMessages = [];
    List<String> secrets = [];
    List<BigInt> rs = [];

    SecretCreator? secretCreator;
    if (customSecret != null) {
      secretCreator = (_) {
        customSecret.refreshNonce();
        return customSecret.toSecretString();
      };
    }

    {
      final ( $1, $2, $3, _ ) = DHKEHelper.createBlindedMessages(
        keysetId: keysetInfo.keysetId,
        amount: proofResponse.targetAmount,
        secretCreator: secretCreator,
      );
      blindedMessages.addAll($1);
      secrets.addAll($2);
      rs.addAll($3);
    }
    final targetProofsCount = secrets.length;

    {
      final overAmount = proofResponse.overAmount;
      if (overAmount > 0) {
        final ( $1, $2, $3, _ ) = DHKEHelper.createBlindedMessages(
          keysetId: keysetInfo.keysetId,
          amount: overAmount,
        );
        blindedMessages.addAll($1);
        secrets.addAll($2);
        rs.addAll($3);
      }
    }

    if (blindedMessages.isEmpty) {
      return _parseResponseByECashCheck(
        proofRequest,
        CashuResponse.fromErrorMsg('blindedMessages is empty.'),
      );
    }

    final response = await mint.swapAction(
      mintURL: mint.mintURL,
      proofs: proofs,
      outputs: blindedMessages,
    );
    if (!response.isSuccess) {
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
      ProofBlindingAction.multiMintSwap,
      '',
    ));
    if (!unblindingResponse.isSuccess) {
      return unblindingResponse;
    }

    await deleteProofs(proofs: proofs, mint: mint);

    return _parseResponseByECashCheck(
      proofRequest,
      CashuResponse.fromSuccessData(
        unblindingResponse.data.sublist(0, targetProofsCount),
      ),
    );
  }

  static Future<CashuResponse<List<ProofIsar>>> getProofsForMelt({
    required IMintIsar mint,
    required ProofRequest proofRequest,
    String unit = 'sat',
  }) async {
    // Keyset info
    final keysetInfo = await KeysetHelper.tryGetMintKeysetInfo(mint, unit);
    final keyset = keysetInfo?.keyset ?? {};
    if (keysetInfo == null || keyset.isEmpty) return CashuResponse.fromErrorMsg('Keyset not found.');

    final proofResponse = await _getProofsWithRequest(
      mint: mint,
      keysetInfo: keysetInfo,
      proofRequest: proofRequest,
    );
    if (!proofResponse.isSuccess) return CashuResponse.fromErrorMsg('Insufficient proofs');

    final proofs = proofResponse.proofs;

    return CashuResponse.fromSuccessData(proofs);
  }

  static Future<CashuResponse<List<List<ProofIsar>>>> getProofsWithAmountList({
    required IMintIsar mint,
    required List<int> amounts,
    Nut10Secret? customSecret,
    String unit = 'sat',
  }) async {
    // Keyset info
    final keysetInfo = await KeysetHelper.tryGetMintKeysetInfo(mint, unit);
    final keyset = keysetInfo?.keyset ?? {};
    if (keysetInfo == null || keyset.isEmpty) return CashuResponse.fromErrorMsg('Keyset not found.');

    final totalAmount = amounts.reduce((a, b) => a + b);
    final proofResponse = await _getProofsWithRequest(
      mint: mint,
      keysetInfo: keysetInfo,
      proofRequest: ProofRequest.amount(totalAmount),
    );

    if (!proofResponse.isSuccess) return CashuResponse.fromErrorMsg('Insufficient proofs');

    final proofs = proofResponse.proofs;
    List<List<BlindedMessage>> blindedMessages = [];
    List<List<String>> secrets = [];
    List<List<BigInt>> rs = [];
    List<List<UnblindingOption>> unblindingOptions = [];

    SecretCreator? secretCreator;
    if (customSecret != null) {
      secretCreator = (_) {
        customSecret.refreshNonce();
        return customSecret.toSecretString();
      };
    }

    for (var amount in amounts) {
      final ( $1, $2, $3, _ ) = DHKEHelper.createBlindedMessages(
        keysetId: keysetInfo.keysetId,
        amount: amount,
        secretCreator: secretCreator,
      );
      blindedMessages.add($1);
      secrets.add($2);
      rs.add($3);
      unblindingOptions.add(
        List.generate(
          $1.length,
          (index) => customSecret != null
            ? const UnblindingOption(isSaveToLocal: false)
            : const UnblindingOption()
        ),
      );
    }

    {
      final overAmount = proofResponse.overAmount;
      if (overAmount > 0) {
        final ( $1, $2, $3, _ ) = DHKEHelper.createBlindedMessages(
          keysetId: keysetInfo.keysetId,
          amount: overAmount,
        );
        blindedMessages.add($1);
        secrets.add($2);
        rs.add($3);
        unblindingOptions.add(
          List.generate($1.length, (index) => const UnblindingOption()),
        );
      }
    }

    List<BlindedMessage> blindedMessagesSet = blindedMessages.expand((e) => e).toList();
    List<String> secretsSet = secrets.expand((e) => e).toList();
    List<BigInt> rsSet = rs.expand((e) => e).toList();
    List<UnblindingOption> unblindingOptionSet = unblindingOptions.expand((e) => e).toList();
    if (blindedMessages.isEmpty) return CashuResponse.fromErrorMsg('blindedMessages is empty.');

    final response = await mint.swapAction(
      mintURL: mint.mintURL,
      proofs: proofs,
      outputs: blindedMessagesSet,
    );
    if (!response.isSuccess) {
      return response.cast();
    }

    // unblinding
    final unblindingResponse = await ProofBlindingManager.shared.unblindingBlindedSignature((
      mint,
      unit,
      response.data,
      secretsSet,
      rsSet,
      unblindingOptionSet,
      ProofBlindingAction.multiMintSwap,
      '',
    ));
    if (!unblindingResponse.isSuccess) {
      return unblindingResponse.cast();
    }

    await deleteProofs(proofs: proofs, mint: mint);

    final newProofs = unblindingResponse.data;
    final proofPackage = <List<ProofIsar>>[];
    int start = 0;
    for (var package in blindedMessages.sublist(0, amounts.length)) {
      final packageSize = package.length;
      proofPackage.add(newProofs.sublist(start, start + packageSize));
      start += packageSize;
    }

    return CashuResponse.fromSuccessData(proofPackage);
  }

  static Future<CashuResponse<List<ProofIsar>>> swapProofs({
    required IMintIsar mint,
    required List<ProofIsar> proofs,
    String unit = 'sat',
  }) async {
    // Keyset info
    final keysetInfo = await KeysetHelper.tryGetMintKeysetInfo(mint, unit);
    final keyset = keysetInfo?.keyset ?? {};
    if (keysetInfo == null || keyset.isEmpty) return CashuResponse.fromErrorMsg('Keyset not found.');

    final inputFee = _getInputFee(proofs, keysetInfo.inputFeePPK);
    final outputAmount = proofs.totalAmount - inputFee;
    List<BlindedMessage> blindedMessages = [];
    List<String> secrets = [];
    List<BigInt> rs = [];

    final ( $1, $2, $3, _ ) = DHKEHelper.createBlindedMessages(
      keysetId: keysetInfo.keysetId,
      amount: outputAmount,
    );
    blindedMessages.addAll($1);
    secrets.addAll($2);
    rs.addAll($3);

    if (blindedMessages.isEmpty) return CashuResponse.fromErrorMsg('blindedMessages is empty.');

    final response = await mint.swapAction(
      mintURL: mint.mintURL,
      proofs: proofs,
      outputs: blindedMessages,
    );
    if (!response.isSuccess) {
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
      ProofBlindingAction.multiMintSwap,
      '',
    ));
    if (!unblindingResponse.isSuccess) {
      return unblindingResponse;
    }

    await deleteProofs(proofs: proofs, mint: mint);

    return unblindingResponse;
  }

  static Future<bool> deleteProofs({
    required List<ProofIsar> proofs,
    IMintIsar? mint,
  }) async {
    final burnedProofs = <ProofIsar>[];
    final liveOrPending = <ProofIsar>[];
    if (mint != null) {
      final response = await mint.tokenCheckAction(mintURL: mint.mintURL, proofs: proofs);
      if (!response.isSuccess) return false;
      if (response.data.length != proofs.length) {
        throw Exception('[E][Cashu - checkProofsAvailable] '
            'The length of states(${response.data.length}) and proofs(${proofs.length}) is not consistent');
      }
      final nowMs = DateTime.now().millisecondsSinceEpoch;
      for (int i = 0; i < proofs.length; i++) {
        final state = response.data[i];
        final updated = proofs[i].copyWith(
          stateRaw: state.index,
          lastCheckedMs: nowMs,
        );
        if (state == TokenState.burned) {
          burnedProofs.add(updated);
        } else {
          liveOrPending.add(updated);
        }
      }
    } else {
      burnedProofs.addAll(proofs);
    }

    if (liveOrPending.isNotEmpty) {
      await saveProofStates(liveOrPending);
    }

    return await ProofStore.deleteProofs(burnedProofs);
  }

  static int _hammingWeight(int n) {
    int count = 0;
    while (n != 0) {
      count += n & 1;
      n >>= 1;
    }
    return count;
  }

  static List<ProofIsar>? _findOneSubsetWithSum(List<ProofIsar> proofs, int target, int inputFeePPK) {
    int adjustedTarget(int subsetLength) {
      return target + ((subsetLength * inputFeePPK + 999) ~/ 1000); // ceil(length * inputFee / 1000)
    }

    proofs = proofs.where((p) => p.state != TokenState.inFlight).toList();

    // Early exit if the total sum of nums is less than the adjusted target
    if (proofs.totalAmount < adjustedTarget(proofs.length)) {
      return null;
    }

    // Sort in ascending order so large elements aren't pruned too early (target grows with subset length due to fee)
    proofs.sort((p1, p2) => p1.amountNum.compareTo(p2.amountNum));

    // Use a map to store possible sums and corresponding subsets
    Map<int, List<ProofIsar>?> dp = {0: []};

    for (int i = 0; i < proofs.length; i++) {
      final proof = proofs[i];

      // Create a list of existing keys to avoid modifying the map during iteration
      List<int> keys = dp.keys.toList().reversed.toList();
      for (int t in keys) {
        int newSum = t + proof.amountNum;
        if (newSum <= adjustedTarget(dp[t]!.length + 1)) {
          List<ProofIsar> currentSubset = List.from(dp[t]!)..add(proof);
          int requiredSum = adjustedTarget(currentSubset.length);

          // Early return if the current subset matches the required sum
          if (currentSubset.totalAmount == requiredSum) {
            return currentSubset;
          }

          // Only update dp if it leads to a smaller or new subset for the given sum
          if (!dp.containsKey(newSum) || (dp[newSum]!.length > currentSubset.length)) {
            dp[newSum] = currentSubset;
          }
        }
      }
    }

    return null;
  }

  List<int>? _findOneSubsetWithNums(List<int> nums, int target, int inputFee) {
    int adjustedTarget(int subsetLength) {
      return target + ((subsetLength * inputFee + 999) ~/ 1000); // ceil(length * inputFee / 1000)
    }

    // Early exit if the total sum of nums is less than the adjusted target
    int totalSum = nums.fold(0, (sum, value) => sum + value);
    if (totalSum < adjustedTarget(nums.length)) {
      return null;
    }

    // Sort nums in descending order to try larger elements first for better efficiency
    nums.sort((a, b) => a.compareTo(b));

    // Use a map to store possible sums and corresponding subsets
    Map<int, List<int>?> dp = {0: []};

    for (int i = 0; i < nums.length; i++) {
      int num = nums[i];

      // Create a list of existing keys to avoid modifying the map during iteration
      List<int> keys = dp.keys.toList().reversed.toList();
      for (int t in keys) {
        int newSum = t + num;
        if (newSum <= adjustedTarget(dp[t]!.length + 1)) {
          List<int> currentSubset = List.from(dp[t]!)..add(num);
          int requiredSum = adjustedTarget(currentSubset.length);

          // Early return if the current subset matches the required sum
          if (currentSubset.fold<int>(0, (sum, value) => sum + value) == requiredSum) {
            return currentSubset;
          }

          // Only update dp if it leads to a smaller or new subset for the given sum
          if (!dp.containsKey(newSum) || (dp[newSum]!.length > currentSubset.length)) {
            dp[newSum] = currentSubset;
          }
        }
      }
    }

    return null;
  }

  static Future addWitnessToProof({
    required ProofIsar proof,
    ConditionType? conditionsType,
    Map<ConditionType, WitnessParam> exParams = const {},
  }) async {

    final nut10Data = Nut10Secret.dataFromSecretString(proof.secret);
    if (nut10Data == null) return ;

    final (kind, _, _, _) = nut10Data;

    switch (kind) {
      case ConditionType.p2pk: await WitnessHelper.addP2PKWitnessToProof(
        proof: proof,
        secret: P2PKSecret.fromNut10Data(nut10Data),
        param: exParams[kind] as P2PKWitnessParam?,
      );
      case ConditionType.htlc: await WitnessHelper.addHTLCWitnessToProof(
        proof: proof,
        secret: HTLCSecret.fromNut10Data(nut10Data),
        param: exParams[kind] as HTLCWitnessParam?,
      );
    }
  }

  static Future tryParseProofsToNewestVersion() async {
    final proofs = await ProofStore.getProofs();
    await _tryParseProofsToHexKeysetId(proofs);
  }

  static Future _tryParseProofsToHexKeysetId(List<ProofIsar> proofs) async {
    Map<String, String> keysetIdMap = {};

    List<ProofIsar> oldProofs = [];
    List<ProofIsar> newProofs = [];

    for (var proof in proofs) {
      final originId = proof.keysetId;
      if (Nut2.isHexKeysetId(originId)) continue;

      String? hexKeysetId = keysetIdMap[originId];
      if (hexKeysetId != null && hexKeysetId.isNotEmpty) {
        final newProof = proof.copyWith(id: hexKeysetId);
        if (newProof.keysetId != proof.keysetId || newProof.secret != proof.secret) {
          oldProofs.add(proof);
          newProofs.add(newProof);
        }
        continue;
      }

      final keyset = (await KeysetStore.getKeyset(id: originId)).firstOrNull;
      if (keyset == null) continue;

      hexKeysetId = Nut2.deriveKeySetId(keyset.keyset);
      if (hexKeysetId.isNotEmpty) {
        keysetIdMap[originId] = hexKeysetId;
        final newProof = proof.copyWith(id: hexKeysetId);
        if (newProof.keysetId != proof.keysetId || newProof.secret != proof.secret) {
          oldProofs.add(proof);
          newProofs.add(newProof);
        }
      }
    }

    await ProofStore.addProofs(newProofs);
    await ProofStore.deleteProofs(oldProofs);
  }

  static int _getInputFee(List<ProofIsar> proofs, int inputFeePPK) {
    return (proofs.length * inputFeePPK + 999) ~/ 1000;
  }
}