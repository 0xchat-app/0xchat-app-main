import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';

@reflector
class SecretSessionDB extends DBObject {
  /// primary key
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

  SecretSessionDB(
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

  @override
  Map<String, Object?> toMap() {
    return _secretSessionInfoToMap(this);
  }

  static SecretSessionDB fromMap(Map<String, Object?> map) {
    return _secretSessionInfoFromMap(map);
  }

  static String? tableName() {
    return "SecretSessionDB";
  }

  int get currentStatus {
    if ((status == 0 || status == 1) &&
        expiration != null &&
        expiration! > 0 &&
        (currentUnixTimestampSeconds() > expiration!)) return 6;
    return status ?? 0;
  }

  //primaryKey
  static List<String?> primaryKey() {
    return ['sessionId'];
  }

  static Future<void> migrateToISAR() async {
    List<SecretSessionDB> secretSessions =
        await DB.sharedInstance.objects<SecretSessionDB>();
    List<SecretSessionDBISAR> secretSessionsISAR = [];
    for (var secretSession in secretSessions) {
      secretSessionsISAR
          .add(SecretSessionDBISAR.fromMap(secretSession.toMap()));
    }
    await DBISAR.sharedInstance.isar.writeTxn(() async {
      await DBISAR.sharedInstance.isar.secretSessionDBISARs
          .putAll(secretSessionsISAR);
    });
  }
}

Map<String, dynamic> _secretSessionInfoToMap(SecretSessionDB instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'myPubkey': instance.myPubkey,
      'myAliasPubkey': instance.myAliasPubkey,
      'myAliasPrivkey': instance.myAliasPrivkey,
      'toPubkey': instance.toPubkey,
      'toAliasPubkey': instance.toAliasPubkey,
      'shareSecretKey': instance.shareSecretKey,
      'sharePubkey': instance.sharePubkey,
      'interval': instance.interval,
      'expiration': instance.expiration,
      'relay': instance.relay,
      'otherFields': instance.otherFields,
      'lastUpdateTime': instance.lastUpdateTime,
      'status': instance.status
    };

SecretSessionDB _secretSessionInfoFromMap(Map<String, dynamic> map) {
  return SecretSessionDB(
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
