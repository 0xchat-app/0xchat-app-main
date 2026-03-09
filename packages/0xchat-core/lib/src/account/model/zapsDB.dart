import 'package:chatcore/chat-core.dart';

@reflector
class ZapsDB extends DBObject {
  String lnAddr;
  String lnURL;
  bool allowsNostr;
  String callback;
  int minSendable;
  int maxSendable;
  String nostrPubkey;

  ZapsDB(
      {this.lnAddr = '',
      this.lnURL = '',
      this.allowsNostr = false,
      this.callback = '',
      this.minSendable = 0,
      this.maxSendable = 0,
      this.nostrPubkey = ''});

  @override
  //Map
  Map<String, Object?> toMap() {
    return _zapsDBInfoToMap(this);
  }

  static ZapsDB fromMap(Map<String, Object?> map) {
    return _zapsDBInfoFromMap(map);
  }

  //primaryKey
  static List<String?> primaryKey() {
    return ['lnAddr', 'lnURL'];
  }

  //'ALTER TABLE Company ADD description TEXT'
  static Map<String, String?> updateTable() {
    return {"2": '''alter table ZapsDB add nostrPubkey TEXT;'''};
  }
}

ZapsDB _zapsDBInfoFromMap(Map<String, dynamic> map) {
  return ZapsDB(
    lnAddr: map['lnAddr'].toString(),
    lnURL: map['lnURL'].toString(),
    allowsNostr:
        (map['allowsNostr'] == true || map['allowsNostr'] == 1) ? true : false,
    callback: map['callback'].toString(),
    minSendable: map['minSendable'],
    maxSendable: map['maxSendable'],
    nostrPubkey: map['nostrPubkey'].toString(),
  );
}

Map<String, dynamic> _zapsDBInfoToMap(ZapsDB instance) => <String, dynamic>{
      'lnAddr': instance.lnAddr,
      'lnURL': instance.lnURL,
      'allowsNostr': instance.allowsNostr,
      'callback': instance.callback,
      'minSendable': instance.minSendable,
      'maxSendable': instance.maxSendable,
      'nostrPubkey': instance.nostrPubkey,
    };
