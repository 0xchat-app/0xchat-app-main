import 'dart:convert';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';

@reflector
class ModerationDB extends DBObject {
  String moderationId;
  String groupId;
  String author;
  int createdAt;
  String content;
  List<String>? previous;
  int actionKind;

  List<String>? users;
  List<String>? permissions;
  String permission;
  String eventId;
  bool private;
  bool closed;
  String name;
  String about;
  String picture;
  String pinned;

  ModerationDB({
    this.moderationId = '',
    this.groupId = '',
    this.author = '',
    this.createdAt = 0,
    this.content = '',
    this.previous,
    this.actionKind = 0,
    this.users,
    this.permissions,
    this.permission = '',
    this.eventId = '',
    this.private = false,
    this.closed = false,
    this.name = '',
    this.about = '',
    this.picture = '',
    this.pinned = '',
  });

  @override
  Map<String, Object?> toMap() {
    return _moderationInfoToMap(this);
  }

  static ModerationDB fromMap(Map<String, Object?> map) {
    return _moderationDBInfoFromMap(map);
  }

  static String? tableName() {
    return "ModerationDB";
  }

  //primaryKey
  static List<String?> primaryKey() {
    return ['moderationId'];
  }

  //'ALTER TABLE Company ADD description TEXT'
  static Map<String, String?> updateTable() {
    return {
      "9": '''alter table ModerationDB add permissions TEXT;''',
    };
  }

  static ModerationDB toModerationDB(GroupModeration moderation) {
    return ModerationDB(
        moderationId: moderation.moderationId,
        groupId: moderation.groupId,
        author: moderation.pubkey,
        createdAt: moderation.createdAt,
        content: moderation.content,
        previous: moderation.previous,
        actionKind: moderation.actionKind.kind,
        users: moderation.users,
        permissions: moderation.permissions,
        eventId: moderation.eventId,
        private: moderation.private,
        closed: moderation.closed,
        name: moderation.name,
        about: moderation.about,
        picture: moderation.picture,
        pinned: moderation.pinned);
  }

  static Future<void> migrateToISAR() async {
    List<ModerationDB> moderations =
        await DB.sharedInstance.objects<ModerationDB>();
    List<ModerationDBISAR> moderationsISAR = [];
    for (var moderation in moderations) {
      moderationsISAR.add(ModerationDBISAR.fromMap(moderation.toMap()));
    }
    await DBISAR.sharedInstance.isar.writeTxn(() async {
      await DBISAR.sharedInstance.isar.moderationDBISARs
          .putAll(moderationsISAR);
    });
  }
}

Map<String, dynamic> _moderationInfoToMap(ModerationDB instance) =>
    <String, dynamic>{
      'moderationId': instance.moderationId,
      'groupId': instance.groupId,
      'author': instance.author,
      'createdAt': instance.createdAt,
      'content': instance.content,
      'previous':
          instance.previous == null ? null : jsonEncode(instance.previous),
      'actionKind': instance.actionKind,
      'user': instance.users,
      'permissions': instance.permissions,
      'permission': instance.permission,
      'eventId': instance.eventId,
      'private': instance.private,
      'closed': instance.closed,
      'name': instance.name,
      'about': instance.about,
      'picture': instance.picture,
      'pinned': instance.pinned,
    };

ModerationDB _moderationDBInfoFromMap(Map<String, dynamic> map) {
  return ModerationDB(
    moderationId: map['moderationId'].toString(),
    groupId: map['groupId'].toString(),
    author: map['author'].toString(),
    createdAt: map['createdAt'],
    content: map['content'].toString(),
    previous: UserDBISAR.decodeStringList(map['previous'].toString()),
    actionKind: map['actionKind'],
    users: UserDBISAR.decodeStringList(map['users'].toString()),
    permissions: UserDBISAR.decodeStringList(map['permissions'].toString()),
    permission: map['permission'].toString(),
    eventId: map['eventId'].toString(),
    private: (map['private'] ?? 0) > 0 ? true : false,
    closed: (map['private'] ?? 0) > 0 ? true : false,
    name: map['name'].toString(),
    about: map['about'].toString(),
    picture: map['picture'].toString(),
    pinned: map['pinned'].toString(),
  );
}
