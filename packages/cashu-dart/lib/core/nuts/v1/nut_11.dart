
import 'nut_10.dart';

enum P2PKSecretSigFlag {
  inputs('SIG_INPUTS'),
  all('SIG_ALL');

  const P2PKSecretSigFlag(this.value);
  final String value;

  static P2PKSecretSigFlag? fromValue(dynamic value) {
    return P2PKSecretSigFlag.values.where((element) => element.value == value).firstOrNull;
  }
}

enum P2PKSecretTagKey {

  sigflag('sigflag'),
  nSigs('n_sigs'),
  lockTime('locktime'),
  refund('refund'),
  pubkeys('pubkeys');

  const P2PKSecretTagKey(this.name);
  final String name;

  List<String> appendValues(List<String> values) {
    return [name, ...values];
  }
}

class P2PKSecret with Nut10Secret {
  P2PKSecret._({
    required String data,
    this.tags = const [],
    String? nonce,
  }) {
    this.nonce = nonce ?? this.nonce;

    // pubkey
    final pubkey = data;
    if (pubkey.isNotEmpty) {
      _receivePubKeys.add(pubkey);
    }

    // tags
    for (final tag in tags) {
      if (tag.length < 2) continue ;

      if (tag.first == P2PKSecretTagKey.pubkeys.name) {
        final value = tag.sublist(1).where((e) => e.isNotEmpty).toList();
        _receivePubKeys.addAll(value);
      } else if (tag.first == P2PKSecretTagKey.refund.name) {
        final value = tag.sublist(1);
        refundPubKeys = value;
      } else if (tag.first == P2PKSecretTagKey.lockTime.name) {
        final value = tag[1];
        final timestamp = int.tryParse(value);
        if (timestamp != null) {
          lockTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
        }
      } else if (tag.first == P2PKSecretTagKey.nSigs.name) {
        final value = tag[1];
        signNumRequired = int.tryParse(value);
      } else if (tag.first == P2PKSecretTagKey.sigflag.name) {
        sigFlag = P2PKSecretSigFlag.fromValue(tag[1]);
      }
    }
  }

  @override
  ConditionType get type => ConditionType.p2pk;

  @override
  String get data => _receivePubKeys.firstOrNull ?? '';

  @override
  final List<List<String>> tags;

  final List<String> _receivePubKeys = [];
  List<String> get receivePubKeys => _receivePubKeys.isEmpty ? [] : _receivePubKeys.sublist(1);

  List<String> refundPubKeys = [];

  DateTime? lockTime;

  int? signNumRequired;

  P2PKSecretSigFlag? sigFlag;

  // Timestamp in seconds
  String? get lockTimeTimestamp {
    if (lockTime == null) return null;
    return (lockTime!.millisecondsSinceEpoch ~/ 1000).toString();
  }

  static P2PKSecret fromNut10Data(Nut10Data nut10Data) {
    final (_, String nonce, String data, List<List<String>> tags) = nut10Data;
    return P2PKSecret._(nonce: nonce, data: data, tags: tags);
  }

  static P2PKSecret? fromOptions({
    List<String>? receivePubKeys,
    List<String>? refundPubKeys,
    DateTime? lockTime,
    int? signNumRequired,
    P2PKSecretSigFlag? sigFlag,
  }) {
    final publicKeys = <String>{...receivePubKeys ?? []}.toList();
    if (publicKeys.isEmpty) return null;

    refundPubKeys = refundPubKeys?.toSet().toList();
    final lockTimeTimestamp = lockTime != null ? (lockTime.millisecondsSinceEpoch ~/ 1000).toString() : null;

    final p2pkSecretData = publicKeys.removeAt(0);
    final p2pkSecretTags = [
      if (publicKeys.isNotEmpty) P2PKSecretTagKey.pubkeys.appendValues(publicKeys),
      if (refundPubKeys != null && refundPubKeys.isNotEmpty) P2PKSecretTagKey.refund.appendValues(refundPubKeys),
      if (signNumRequired != null && signNumRequired > 0) P2PKSecretTagKey.nSigs.appendValues(['$signNumRequired']),
      if (lockTimeTimestamp != null) P2PKSecretTagKey.lockTime.appendValues([lockTimeTimestamp]),
      if (sigFlag != null) P2PKSecretTagKey.sigflag.appendValues([sigFlag.value]),
    ];

    if (p2pkSecretData.isEmpty && p2pkSecretTags.isEmpty) return null;

    return P2PKSecret._(data: p2pkSecretData, tags: p2pkSecretTags);
  }
}

class P2PKWitness {
  P2PKWitness({
    required this.signatures,
  });
  final List<String> signatures;
}