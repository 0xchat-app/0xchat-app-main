import 'package:isar/isar.dart';
import 'package:nostr_core_dart/nostr.dart';

part 'secretSessionDB_isar.g.dart';

@collection
class SecretSessionDBISAR {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String sessionId;

  /// my keys
  String? myPubkey;
  String? myAliasPubkey;
  String? myAliasPrivkey;

  /// counterparty keys
  String? toPubkey;
  String? toAliasPubkey;

  /// shared keys
  String? shareSecretKey;
  String? sharePubkey;

  /// additional info
  int? interval;
  int? expiration;
  String? relay;
  String? otherFields;

  /// status
  int lastUpdateTime;

  /// 0: send request, waiting for accept 1: receive request 2: accept 3: reject 4: close 5: update 6: expired
  int? status;

  SecretSessionDBISAR(
      {this.sessionId = '',
        this.myPubkey = '',
        this.myAliasPubkey = '',
        this.myAliasPrivkey = '',
        this.toPubkey = '',
        this.toAliasPubkey = '',
        this.shareSecretKey = '',
        this.sharePubkey = '',
        this.interval = 0,
        this.expiration = 0,
        this.relay = '',
        this.otherFields = '',
        this.lastUpdateTime = 0,
        this.status = 0});

  static SecretSessionDBISAR fromMap(Map<String, Object?> map) {
    return _secretSessionInfoFromMap(map);
  }

  @ignore
  int get currentStatus {
    if ((status == 0 || status == 1) &&
        expiration != null &&
        expiration! > 0 &&
        (currentUnixTimestampSeconds() > expiration!)) return 6;
    return status ?? 0;
  }
}

SecretSessionDBISAR _secretSessionInfoFromMap(Map<String, dynamic> map) {
  return SecretSessionDBISAR(
    sessionId: map['sessionId'].toString(),
    myPubkey: map['myPubkey'].toString(),
    myAliasPubkey: map['myAliasPubkey'].toString(),
    myAliasPrivkey: map['myAliasPrivkey'].toString(),
    toPubkey: map['toPubkey'].toString(),
    toAliasPubkey: map['toAliasPubkey'].toString(),
    shareSecretKey: map['shareSecretKey'].toString(),
    sharePubkey: map['sharePubkey'].toString(),
    interval: map['interval'],
    expiration: map['expiration'],
    relay: map['relay'].toString(),
    otherFields: map['otherFields'].toString(),
    lastUpdateTime: map['lastUpdateTime'],
    status: map['status'],
  );
}
