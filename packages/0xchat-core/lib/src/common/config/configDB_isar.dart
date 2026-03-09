import 'package:isar/isar.dart';

part 'configDB_isar.g.dart';

@collection
class ConfigDBISAR {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String d;

  String eventId;
  int time;
  String configJson;
  String proxyJson;

  ConfigDBISAR({
    this.d = '',
    this.eventId = '',
    this.time = 0,
    this.configJson = '',
    this.proxyJson = '',
  });

  static ConfigDBISAR fromMap(Map<String, Object?> map) {
    return _configInfoFromMap(map);
  }
}

ConfigDBISAR _configInfoFromMap(Map<String, dynamic> map) {
  return ConfigDBISAR(
    d: map['d'].toString(),
    time: map['time'],
    eventId: map['eventId'].toString(),
    configJson: map['configJson'].toString(),
  );
}
