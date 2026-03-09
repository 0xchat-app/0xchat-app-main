import 'package:isar/isar.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:chatcore/chat-core.dart';

part 'moderationDB_isar.g.dart';

extension ModerationDBISARExtensions on ModerationDBISAR {
  ModerationDBISAR withGrowableLevels() => this
    ..previous = previous?.toList()
    ..users = users?.toList()
    ..permissions = permissions?.toList();
}

@collection
class ModerationDBISAR {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
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

  ModerationDBISAR({
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

  static ModerationDBISAR fromMap(Map<String, Object?> map) {
    return _moderationDBInfoFromMap(map);
  }

  static ModerationDBISAR toModerationDB(GroupModeration moderation) {
    return ModerationDBISAR(
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
}

ModerationDBISAR _moderationDBInfoFromMap(Map<String, dynamic> map) {
  return ModerationDBISAR(
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
    private: map['private'],
    closed: map['private'],
    name: map['name'].toString(),
    about: map['about'].toString(),
    picture: map['picture'].toString(),
    pinned: map['pinned'].toString(),
  );
}
