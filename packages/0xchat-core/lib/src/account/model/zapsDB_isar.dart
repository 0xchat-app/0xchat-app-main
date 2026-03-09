import 'package:isar/isar.dart';

part 'zapsDB_isar.g.dart';

@collection
class ZapsDBISAR {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String lnAddr;

  @Index(unique: true, replace: true)
  String lnURL;

  bool allowsNostr;
  String callback;
  int minSendable;
  int maxSendable;
  String nostrPubkey;

  ZapsDBISAR(
      {this.lnAddr = '',
        this.lnURL = '',
        this.allowsNostr = false,
        this.callback = '',
        this.minSendable = 0,
        this.maxSendable = 0,
        this.nostrPubkey = ''});

  static ZapsDBISAR fromMap(Map<String, Object?> map) {
    return _zapsDBInfoFromMap(map);
  }
}

ZapsDBISAR _zapsDBInfoFromMap(Map<String, dynamic> map) {
  return ZapsDBISAR(
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
