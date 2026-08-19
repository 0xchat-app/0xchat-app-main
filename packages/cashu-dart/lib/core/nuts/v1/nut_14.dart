
import 'dart:typed_data';

import 'package:cashu_dart/utils/crypto_utils.dart';
import 'package:cashu_dart/utils/tools.dart';
import 'package:crypto/crypto.dart';

import 'nut_10.dart';

enum HTLCSecretTagKey {

  pubkeys('pubkeys'),
  lockTime('locktime'),
  refund('refund');

  const HTLCSecretTagKey(this.name);
  final String name;

  List<String> appendValues(List<String> values) {
    return [name, ...values];
  }
}

class HTLCSecret with Nut10Secret {
  HTLCSecret._({
    required this.data,
    this.tags = const [],
    String? nonce,
  }) {
    this.nonce = nonce ?? this.nonce;

    // tags
    for (final tag in tags) {
      if (tag.length < 2) continue ;

      if (tag.first == HTLCSecretTagKey.pubkeys.name) {
        final value = tag.sublist(1).where((e) => e.isNotEmpty).toList();
        receivePubKeys.addAll(value);
      } else if (tag.first == HTLCSecretTagKey.refund.name) {
        final value = tag.sublist(1);
        refundPubKeys = value;
      } else if (tag.first == HTLCSecretTagKey.lockTime.name) {
        final value = tag[1];
        final timestamp = int.tryParse(value);
        if (timestamp != null) {
          lockTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
        }
      }
    }
  }

  @override
  ConditionType get type => ConditionType.htlc;

  @override
  final String data;

  @override
  final List<List<String>> tags;

  List<String> receivePubKeys = [];
  List<String> refundPubKeys = [];
  DateTime? lockTime;

  // Timestamp in seconds
  String? get lockTimeTimestamp {
    if (lockTime == null) return null;
    return (lockTime!.millisecondsSinceEpoch ~/ 1000).toString();
  }

  static HTLCSecret fromNut10Data(Nut10Data nut10Data) {
    final (_, String nonce, String data, List<List<String>> tags) = nut10Data;
    return HTLCSecret._(nonce: nonce, data: data, tags: tags);
  }

  static HTLCSecret? fromOptions({
    required String hash,
    List<String>? receivePubKeys,
    List<String>? refundPubKeys,
    DateTime? lockTime,
  }) {
    if (hash.isEmpty) return null;

    final publicKeys = <String>{...receivePubKeys ?? []}.toList();
    refundPubKeys = refundPubKeys?.toSet().toList();

    final lockTimeTimestamp = lockTime != null ? (lockTime.millisecondsSinceEpoch ~/ 1000).toString() : null;

    final htlcSecretTags = [
      if (publicKeys.isNotEmpty) HTLCSecretTagKey.pubkeys.appendValues(publicKeys),
      if (refundPubKeys != null && refundPubKeys.isNotEmpty) HTLCSecretTagKey.refund.appendValues(refundPubKeys),
      if (lockTimeTimestamp != null) HTLCSecretTagKey.lockTime.appendValues([lockTimeTimestamp]),
    ];

    return HTLCSecret._(data: hash, tags: htlcSecretTags);
  }
}

class HTLCWitness {
  HTLCWitness({
    required this.preimage,
    this.signature,
  });
  final String preimage;
  String? signature;

  HTLCWitness.fromJson(Map<String, dynamic> json)
      : preimage = json['preimage'],
        signature = json['signature'];

  Map<String, dynamic> toJson() {
    final preimage = this.preimage;
    final signature = this.signature;
    return {
      'preimage': preimage,
      if (signature != null && signature.isNotEmpty)
        'signature': signature,
    };
  }
}

class HTLC {
  static (String preimage, String hashString) createHashData([String? preimage]) {
    if (preimage != null && !preimage.isHexString()) {
      preimage = preimage.generateToHex();
    }
    preimage ??= CryptoUtils.randomPrivateKey().asHex();
    final hashBytes = sha256.convert(preimage.hexToBytes()).bytes;
    final hashString = Uint8List.fromList(hashBytes).asHex();
    return (preimage, hashString);
  }
}