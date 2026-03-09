import 'package:chatcore/chat-core.dart';

@reflector
class BadgeDB extends DBObject {
  String id;
  String d;
  String name;
  String description;
  String image;
  String thumb;
  String creator;
  int createTime;

  BadgeDB(
      {this.id = '',
      this.d = '',
      this.name = '',
      this.description = '',
      this.image = '',
      this.thumb = '',
      this.creator = '',
      this.createTime = 0});

  @override
  //Map
  Map<String, Object?> toMap() {
    return _badgeInfoToMap(this);
  }

  static BadgeDB fromMap(Map<String, Object?> map) {
    return _badgeInfoFromMap(map);
  }

  //primaryKey
  static List<String?> primaryKey() {
    return ['id'];
  }

  static Future<void> migrateToISAR() async {
    List<BadgeDB> badgeDBs = await DB.sharedInstance.objects<BadgeDB>();
    List<BadgeDBISAR> badgeDBsISAR = [];
    for (var badgeDB in badgeDBs) {
      badgeDBsISAR.add(BadgeDBISAR.fromMap(badgeDB.toMap()));
    }
    await DBISAR.sharedInstance.isar.writeTxn(() async {
      await DBISAR.sharedInstance.isar.badgeDBISARs.putAll(badgeDBsISAR);
    });
  }
}

BadgeDB _badgeInfoFromMap(Map<String, dynamic> map) {
  return BadgeDB(
    id: map['id'].toString(),
    d: map['d'].toString(),
    name: map['name'].toString(),
    description: map['description'].toString(),
    image: map['image'].toString(),
    thumb: map['thumb'].toString(),
    creator: map['creator'].toString(),
    createTime: map['createTime'],
  );
}

Map<String, dynamic> _badgeInfoToMap(BadgeDB instance) => <String, dynamic>{
      'id': instance.id,
      'd': instance.d,
      'name': instance.name,
      'description': instance.description,
      'image': instance.image,
      'thumb': instance.thumb,
      'creator': instance.creator,
      'createTime': instance.createTime,
    };
