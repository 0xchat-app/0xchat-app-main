import 'package:chatcore/chat-core.dart';

@reflector
class ConfigDB extends DBObject {
  String d;
  String eventId;
  int time;
  String configJson;

  ConfigDB({
    this.d = '',
    this.eventId = '',
    this.time = 0,
    this.configJson = '',
  });

  @override
  //Map
  Map<String, Object?> toMap() {
    return _configDBInfoToMap(this);
  }

  static ConfigDB fromMap(Map<String, Object?> map) {
    return _configInfoFromMap(map);
  }

  //primaryKey
  static List<String?> primaryKey() {
    return ['d'];
  }

  static Future<void> migrateToISAR() async {
    List<ConfigDB> configs = await DB.sharedInstance.objects<ConfigDB>();
    List<ConfigDBISAR> configsISAR = [];
    for (var config in configs) {
      configsISAR.add(ConfigDBISAR.fromMap(config.toMap()));
    }
    await DBISAR.sharedInstance.isar.writeTxn(() async {
      await DBISAR.sharedInstance.isar.configDBISARs.putAll(configsISAR);
    });
  }
}

ConfigDB _configInfoFromMap(Map<String, dynamic> map) {
  return ConfigDB(
    d: map['d'].toString(),
    time: map['time'],
    eventId: map['eventId'].toString(),
    configJson: map['configJson'].toString(),
  );
}

Map<String, dynamic> _configDBInfoToMap(ConfigDB instance) => <String, dynamic>{
      'd': instance.d,
      'time': instance.time,
      'eventId': instance.eventId,
      'configJson': instance.configJson,
    };
