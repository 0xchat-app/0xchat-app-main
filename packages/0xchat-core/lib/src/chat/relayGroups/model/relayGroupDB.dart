import 'dart:convert';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/foundation.dart';
import 'package:nostr_core_dart/nostr.dart';

@reflector
class RelayGroupDB extends DBObject {
  String groupId;
  String id; //<relay>'<group-id>
  String author; // group creator
  String relay;
  String relayPubkey;
  bool private;
  bool closed;
  int lastUpdatedTime;
  bool mute;
  List<GroupAdmin>? admins;
  String name;
  String about;
  String picture;
  List<String>? pinned;
  List<String>? members;
  int level; // group level
  int point; // group point

  RelayGroupDB(
      {this.groupId = '',
      this.id = '',
      this.author = '',
      this.relay = '',
      this.relayPubkey = '',
      this.private = false,
      this.closed = false,
      this.lastUpdatedTime = 0,
      this.mute = false,
      this.admins,
      this.name = '',
      this.about = '',
      this.picture = '',
      this.pinned,
      this.members,
      this.level = 0,
      this.point = 0});

  @override
  Map<String, Object?> toMap() {
    return _groupInfoToMap(this);
  }

  static RelayGroupDB fromMap(Map<String, Object?> map) {
    return _groupInfoFromMap(map);
  }

  static String? tableName() {
    return "RelayGroupDB";
  }

  //primaryKey
  static List<String?> primaryKey() {
    return ['groupId'];
  }

  String get shortGroupId {
    String k = groupId;
    if (k.length < 12) return k;
    final String start = k.substring(0, 6);
    final String end = k.substring(k.length - 6);
    return '$start:$end';
  }

  static String groupAdminsToString(List<GroupAdmin> admins) {
    List<List<dynamic>> adminsString =
        admins.map((admin) => admin.toJson()).toList();
    return jsonEncode(adminsString);
  }

  static List<GroupAdmin> stringToGroupAdmins(String json) {
    if (json.isEmpty || json == 'null') return [];
    try {
      List<dynamic> groupAdminsJson = [];
      groupAdminsJson = jsonDecode(json);
      List<GroupAdmin> admins =
          groupAdminsJson.map((json) => GroupAdmin.fromJson(json)).toList();
      return admins;
    } catch (e) {
      LogUtils.v(() => 'stringToGroupAdmins error: $e');
      return [];
    }
  }

  static Future<void> migrateToISAR() async {
    List<RelayGroupDB> groups = await DB.sharedInstance.objects<RelayGroupDB>();
    List<RelayGroupDBISAR> groupsISAR = [];
    for (var group in groups) {
      groupsISAR.add(RelayGroupDBISAR.fromMap(group.toMap()));
    }
    await DBISAR.sharedInstance.isar.writeTxn(() async {
      await DBISAR.sharedInstance.isar.relayGroupDBISARs.putAll(groupsISAR);
    });
  }
}

Map<String, dynamic> _groupInfoToMap(RelayGroupDB instance) =>
    <String, dynamic>{
      'groupId': instance.groupId,
      'id': instance.id,
      'author': instance.author,
      'relay': instance.relay,
      'relayPubkey': instance.relayPubkey,
      'private': instance.private,
      'closed': instance.closed,
      'lastUpdatedTime': instance.lastUpdatedTime,
      'mute': instance.mute,
      'admins': instance.admins == null
          ? null
          : RelayGroupDB.groupAdminsToString(instance.admins!),
      'name': instance.name,
      'about': instance.about,
      'picture': instance.picture,
      'pinned': instance.pinned == null ? null : jsonEncode(instance.pinned),
      'members': instance.members == null ? null : jsonEncode(instance.members),
      'level': instance.level,
      'point': instance.point,
    };

RelayGroupDB _groupInfoFromMap(Map<String, dynamic> map) {
  return RelayGroupDB(
    groupId: map['groupId'].toString(),
    id: map['id'].toString(),
    author: map['author'].toString(),
    relay: map['relay'].toString(),
    relayPubkey: map['relayPubkey'].toString(),
    private: map['private'] == null
        ? false
        : map['private'] > 0
            ? true
            : false,
    closed: map['closed'] == null
        ? false
        : map['private'] > 0
            ? true
            : false,
    lastUpdatedTime: map['lastUpdatedTime'],
    mute: map['mute'] > 0 ? true : false,
    admins: RelayGroupDB.stringToGroupAdmins(map['admins'].toString()),
    name: map['name'].toString(),
    about: map['about'].toString(),
    picture: map['picture'].toString(),
    pinned: UserDBISAR.decodeStringList(map['pinned'].toString()),
    members: UserDBISAR.decodeStringList(map['members'].toString()),
    level: map['level'],
    point: map['point'],
  );
}
