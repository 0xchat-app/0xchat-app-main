import 'package:cashu_dart/utils/tools.dart';

import 'proof_isar.dart';

class Token {
  Token({
    this.entries = const [],
    this.memo = '',
    this.unit = '',
  });

  /// token entries
  final List<TokenEntry> entries;

  /// a message to send along with the token
  final String memo;

  final String unit;

  BigInt get sumProofsValue => entries.fold(BigInt.zero, (pre, entry) => pre + entry.sumProofsValue);

  factory Token.fromJson(Map json) {
    final tokenJson = json['token'] ?? [];
    List<TokenEntry> token = [];
    if (tokenJson is List) {
      token = tokenJson.map((e) {
        if (e is Map<String, Object?>) {
          return TokenEntry.fromJson(e);
        }
        return null;
      }).where((element) => element != null).cast<TokenEntry>().toList();
    }
    return Token(
      entries: token,
      memo: json['memo']?.toString() ?? '',
      unit: json['unit']?.toString() ?? 'sat',
    );
  }

  factory Token.fromV4Json(Map json) {
    final mintURL = json['m'];
    final unit = json['u']?.toString() ?? 'sat';
    final memo = json['d']?.toString() ?? '';
    final tokenJson = json['t'] ?? [];
    return Token(
      entries: [TokenEntry.fromV4Json(mintURL, tokenJson)],
      memo: memo,
      unit: unit,
    );
  }

  Map toJson() => {
    'token': entries.map((e) => e.toJson()).toList(),
    'memo': memo,
    'unit': unit,
  };

  Map toV4Json() {
    if (entries.length != 1) return {};
    final entry = entries.first;

    final mintURL = entry.mint;
    return {
      'm': mintURL,
      'u': unit,
      if (memo.isNotEmpty)
        'd': memo,
      't': entry.toV4Json(),
    };
  }

  @override
  String toString() {
    return '${super.toString()}, memo: $memo, unit: $unit, token: $entries';
  }
}

class TokenEntry {
  TokenEntry({
    this.proofs = const [],
    this.mint = '',
  });

  /// list of proofs
  final List<ProofIsar> proofs;

  /// the mints URL
  final String mint;

  BigInt get sumProofsValue => proofs.fold(
      BigInt.zero, (pre, proof) => pre + proof.amount.asBigInt()
  );

  factory TokenEntry.fromJson(Map json) {
    final proofsJson = json['proofs'] ?? [];
    List<ProofIsar> proofs = [];
    if (proofsJson is List) {
      proofs = proofsJson.map((e) {
        if (e is Map<String, Object?>) {
          return ProofIsar.fromServerJson(e);
        }
        return null;
      }).where((element) => element != null).cast<ProofIsar>().toList();
    }
    return TokenEntry(
      proofs: proofs,
      mint: json['mint'] ?? '',
    );
  }

  factory TokenEntry.fromV4Json(String mintURL, List json) {
    List<ProofIsar> proofs = [];
    for (var tokenMap in json) {
      if (tokenMap is! Map) continue;

      final keysetId = (tokenMap['i']?.toString() ?? '').toLowerCase();
      final proofsJson = tokenMap['p'] ?? [];

      if (keysetId.isEmpty || proofsJson is! List) continue;

      for (var proofMap in proofsJson) {
        if (proofMap is! Map) continue;

        final proof = ProofIsar.fromV4Json(keysetId, proofMap);
        proofs.add(proof);
      }
    }

    return TokenEntry(
      proofs: proofs,
      mint: mintURL,
    );
  }

  Map toJson() => {
    'proofs': proofs.map((e) => e.toJson()).toList(),
    'mint': mint,
  };

  List toV4Json() {
    // key: keysetId, value: proof list
    Map<String, List<Map>> allProofs = <String, List<Map>>{};

    for (var proof in proofs) {
      final keysetId = proof.keysetId;
      final proofMaps = allProofs.putIfAbsent(keysetId, () => <Map>[]);
      proofMaps.add(proof.toV4Json());
    }

    return allProofs.entries.map((entry) => {
      "i": entry.key.hexToBytes(),
      "p": entry.value,
    }).toList();
  }

  @override
  String toString() {
    return '${super.toString()}, mint: $mint, proofs: $proofs';
  }
}