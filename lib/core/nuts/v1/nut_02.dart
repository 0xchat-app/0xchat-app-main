
import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import '../../../model/keyset_info_isar.dart';
import '../../../utils/network/http_client.dart';
import '../../../utils/tools.dart';
import '../define.dart';

/// NUT-02 Keyset ID version bytes.
const String _keysetIdVersionV1 = '00';
const String _keysetIdVersionV2 = '01';

/// V1 keyset ID length: version (2) + 14 hex = 16.
const int _keysetIdV1HexLength = 16;

/// V2 keyset ID length: version (2) + 32 bytes hex (64 chars) = 66.
const int _keysetIdV2HexLength = 66;

class Nut2 {
  static Future<CashuResponse<List<KeysetInfoIsar>>> requestKeysetsState({required String mintURL}) async {
    return HTTPClient.get(
      nutURLJoin(mintURL, 'keysets'),
      modelBuilder: (json) {
        if (json is! Map) return null;
        final keysets = Tools.getValueAs(json, 'keysets', []);
        return keysets.map((e) => KeysetInfoIsar.fromServerMap(e, mintURL)).toList();
      },
    );
  }

  /// Derives Keyset ID V2 per NUT-02 (33-byte hex, version byte 01).
  /// [keys] mint public keys (amount -> pubkey hex),
  /// [unit] e.g. "sat",
  /// [inputFeePpk] optional, omitted from preimage if null or 0,
  /// [finalExpiry] optional Unix timestamp, omitted if null or 0.
  static String deriveKeysetIdV2(
    MintKeys keys, {
    required String unit,
    int? inputFeePpk,
    int? finalExpiry,
  }) {
    final sortedKeys = keys.entries.toList()
      ..sort((a, b) {
        final aNum = BigInt.tryParse(a.key) ?? BigInt.zero;
        final bNum = BigInt.tryParse(b.key) ?? BigInt.zero;
        return aNum.compareTo(bNum);
      });

    final parts = <String>[];
    for (var i = 0; i < sortedKeys.length; i++) {
      final e = sortedKeys[i];
      parts.add('${e.key}:${e.value.toLowerCase()}');
    }
    var preimage = parts.join(',');
    preimage += '|unit:${unit.toLowerCase()}';
    if (inputFeePpk != null && inputFeePpk != 0) {
      preimage += '|input_fee_ppk:$inputFeePpk';
    }
    if (finalExpiry != null && finalExpiry != 0) {
      preimage += '|final_expiry:$finalExpiry';
    }

    final hash = sha256.convert(utf8.encode(preimage));
    final hexHash = Uint8List.fromList(hash.bytes).asHex();
    return _keysetIdVersionV2 + hexHash;
  }

  /*
  V1 (deprecated): 00 + first 14 hex chars of SHA256(concatenated pubkey bytes).
  1 - sort public keys by their amount in ascending order
  2 - concatenate all public keys to one byte array
  3 - HASH_SHA256 the concatenated public keys
  4 - take the first 14 characters of the hex-encoded hash
  5 - prefix it with a keyset ID version byte (00)
  */
  static String deriveKeysetIdV1(MintKeys keys) {
    final sortedKeys = keys.entries.toList()
      ..sort((a, b) {
        final aNum = BigInt.tryParse(a.key) ?? BigInt.zero;
        final bNum = BigInt.tryParse(b.key) ?? BigInt.zero;
        return aNum.compareTo(bNum);
      });

    final List<int> pubkeysConcat = [];
    for (var entry in sortedKeys) {
      pubkeysConcat.addAll(entry.value.hexToBytes());
    }
    final hash = sha256.convert(pubkeysConcat);
    final hexEncoded = Uint8List.fromList(hash.bytes).asHex().substring(0, 14);
    return _keysetIdVersionV1 + hexEncoded;
  }

  /// Prefer [deriveKeysetIdV2] for new code. This remains for backward compatibility.
  static String deriveKeySetId(MintKeys keys) => deriveKeysetIdV1(keys);

  @Deprecated('DEPRECATED 0.15.0')
  static String deriveKeySetIdDeprecated(MintKeys keys) {
    final sortedKeys = keys.entries.toList()
      ..sort((a, b) {
        final aNum = BigInt.tryParse(a.key) ?? BigInt.zero;
        final bNum = BigInt.tryParse(b.key) ?? BigInt.zero;
        return aNum.compareTo(bNum);
      });
    final pubKeysConcat = sortedKeys.map((entry) => entry.value).join('');
    final bytes = utf8.encode(pubKeysConcat);
    final hash = sha256.convert(bytes);
    return Uint8List.fromList(hash.bytes).asBase64String().substring(0, 12);
  }

  /// Returns true if [keysetId] is a valid hex keyset ID (V1 or V2).
  /// V1: 16 hex chars (00 + 14). V2: 66 hex chars (01 + 64).
  static bool isHexKeysetId(String keysetId) {
    if (keysetId.length == _keysetIdV1HexLength) {
      return _isValidHexKeysetId(keysetId, _keysetIdVersionV1, _keysetIdV1HexLength);
    }
    if (keysetId.length == _keysetIdV2HexLength) {
      return _isValidHexKeysetId(keysetId, _keysetIdVersionV2, _keysetIdV2HexLength);
    }
    return false;
  }

  /// Returns true if [keysetId] is a valid NUT-02 Keyset ID V2 (01 + 64 hex).
  static bool isKeysetIdV2(String keysetId) {
    return keysetId.length == _keysetIdV2HexLength &&
        _isValidHexKeysetId(keysetId, _keysetIdVersionV2, _keysetIdV2HexLength);
  }

  static bool _isValidHexKeysetId(String keysetId, String versionPrefix, int length) {
    if (keysetId.length != length || !keysetId.startsWith(versionPrefix)) return false;
    try {
      keysetId.hexToBytes();
      return true;
    } catch (_) {
      return false;
    }
  }
}