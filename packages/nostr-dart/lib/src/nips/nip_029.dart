import 'dart:math';

import 'package:nostr_core_dart/nostr.dart';

/// Relay-based Groups
class Nip29 {
  static bool restricted(String message) {
    return message.startsWith('restricted: ');
  }

  static Group decodeMetadata(Event event, String fromRelay) {
    if (event.kind != 39000) {
      throw Exception("${event.kind} is not nip29 compatible");
    }

    String groupId = '', name = '', picture = '', about = '';
    bool private = true, closed = true;
    for (var tag in event.tags) {
      if (tag[0] == "d") {
        groupId = tag[1];
      }
      if (tag[0] == "name") {
        name = tag[1];
      }
      if (tag[0] == "picture") {
        picture = tag[1];
      }
      if (tag[0] == "about") {
        about = tag[1];
      }
      if (tag[0] == "public") {
        private = false;
      }
      if (tag[0] == "open") {
        closed = false;
      }
    }
    String id = '$fromRelay\'$groupId';
    return Group(id, fromRelay, event.pubkey, groupId, private, closed, [], name, about, picture,
        null, [], 0, 0, null);
  }

  static String? getGroupIdFromEvent(Event event) {
    for (var tag in event.tags) {
      if (tag[0] == "d") {
        return tag[1];
      }
      if (tag[0] == "h") {
        return tag[1];
      }
    }
    return null;
  }

  static List<GroupAdmin> decodeGroupAdmins(Event event) {
    if (event.kind != 39001) {
      throw Exception("${event.kind} is not nip29 compatible");
    }

    List<GroupAdmin> admins = [];
    for (var tag in event.tags) {
      if (tag[0] == "p" && isHexadecimalString(tag[1])) {
        if (tag[2] == "king") {
          admins.add(GroupAdmin(tag[1], tag[2], GroupActionKind.king()));
        } else if (tag[2] == "bishop") {
          admins.add(GroupAdmin(tag[1], tag[2], GroupActionKind.bishop()));
        } else {
          List<GroupActionKind> permissions = [];
          for (int i = 3; i < tag.length; ++i) {
            permissions.add(GroupActionKind.fromString(tag[i]));
          }
          admins.add(GroupAdmin(tag[1], tag[2], permissions));
        }
      }
    }
    return admins;
  }

  static bool isHexadecimalString(String input) {
    final regex = RegExp(r'^[a-fA-F0-9]{64}$');
    return regex.hasMatch(input);
  }

  static List<String> decodeGroupMembers(Event event) {
    if (event.kind != 39002) {
      throw Exception("${event.kind} is not nip29 compatible");
    }

    List<String> members = [];
    for (var tag in event.tags) {
      if (tag[0] == "p" && isHexadecimalString(tag[1])) members.add(tag[1]);
    }
    return members;
  }

  static List<String> getPrevious(List<List<String>> tags) {
    List<String> previous = [];
    for (var tag in tags) {
      if (tag[0] == 'previous') {
        for (int i = 1; i < tag.length - 1; ++i) {
          previous.add(tag[i]);
        }
        break;
      }
    }
    return previous;
  }

  static GroupNote decodeGroupNote(Event event) {
    if (event.kind != 11 && event.kind != 12) {
      throw Exception("${event.kind} is not nip29 compatible");
    }
    Note note = Nip1.decodeNote(event);
    return GroupNote(note.groupId, note.nodeId, note, getPrevious(event.tags));
  }

  static GroupNote decodeGroupNoteReply(Event event) {
    if (event.kind != 12) {
      throw Exception("${event.kind} is not nip29 compatible");
    }
    Note note = Nip1.decodeNote(event);
    return GroupNote(note.groupId, note.nodeId, note, getPrevious(event.tags));
  }

  static GroupMessage decodeGroupMessage(Event event) {
    if (event.kind != 9 && event.kind != 10) {
      throw Exception("${event.kind} is not nip29 compatible");
    }
    var content = event.content;
    String groupId = '';
    String? replyId, replyUser;
    for (var tag in event.tags) {
      if (tag[0] == "subContent") content = tag[1];
      if (tag[0] == "h") groupId = tag[1];
      if (tag[0] == "q") replyId = tag[1];
      if (tag[0] == "p") replyUser = tag[1];
    }
    List<String> previous = getPrevious(event.tags);
    return GroupMessage(
        groupId, event.id, event.pubkey, event.createdAt, replyId, replyUser, content, previous);
  }

  static GroupJoinRequest decodeJoinRequest(Event event) {
    if (event.kind != 9021) {
      throw Exception("${event.kind} is not nip29 compatible");
    }
    var content = event.content;
    String groupId = '';
    for (var tag in event.tags) {
      if (tag[0] == "h") groupId = tag[1];
    }
    return GroupJoinRequest(event.id, groupId, event.pubkey, event.createdAt, content);
  }

  static GroupModeration decodeModeration(Event event) {
    if (event.kind < 9000 || event.kind > 9008) {
      throw Exception("${event.kind} is not nip29 compatible");
    }
    List<String> users = [], permissions = [];
    String groupId = '', name = '', about = '', picture = '', eventId = '';
    bool private = false, closed = false;
    for (var tag in event.tags) {
      if (tag[0] == "h") groupId = tag[1];
      if (tag[0] == "p") users.add(tag[1]);
      if (tag[0] == "name") name = tag[1];
      if (tag[0] == "about") about = tag[1];
      if (tag[0] == "picture") picture = tag[1];
      if (tag[0] == "permission") permissions.add(tag[1]);
      if (tag[0] == "e") eventId = tag[1];
      if (tag[0] == "private") private = true;
      if (tag[0] == "closed") closed = true;
    }
    List<String> previous = getPrevious(event.tags);
    return GroupModeration(
        moderationId: event.id,
        groupId: groupId,
        pubkey: event.pubkey,
        createdAt: event.createdAt,
        content: event.content,
        actionKind: GroupActionKind.fromKind(event.kind),
        previous: previous,
        users: users,
        permissions: permissions,
        eventId: eventId,
        private: private,
        closed: closed,
        name: name,
        about: about,
        picture: picture,
        pinned: '');
  }

  static Future<Event> encodeGroupNote(
      String groupId, String content, String pubkey, String privkey, List<String> previous,
      {List<String>? hashTags}) async {
    List<List<String>> tags = [];
    tags.add(['h', groupId]);
    // if (previous.isNotEmpty) tags.add(['previous', ...previous]);
    if (hashTags != null) {
      for (var t in hashTags) {
        tags.add(['t', t]);
      }
    }
    return await Event.from(
        kind: 11, tags: tags, content: content, pubkey: pubkey, privkey: privkey);
  }

  static Future<Event> encodeGroupNoteReply(
      String groupId, String content, String pubkey, String privkey, List<String> previous,
      {String? rootEvent,
      String? replyEvent,
      List<String>? replyUsers,
      List<String>? hashTags}) async {
    List<List<String>> tags = [];
    if (rootEvent != null) {
      ETag root = Nip10.rootTag(rootEvent, '');
      ETag? reply = replyEvent == null ? null : Nip10.replyTag(replyEvent, '');
      Thread thread = Thread(root, reply, null, null);
      tags = Nip10.toTags(thread);
    }
    List<PTag> pTags = Nip10.pTags(replyUsers ?? [], []);
    for (var pTag in pTags) {
      tags.add(["p", pTag.pubkey, pTag.relayURL]);
    }
    tags.add(['h', groupId]);
    // if (previous.isNotEmpty) tags.add(['previous', ...previous]);
    if (hashTags != null) {
      for (var t in hashTags) {
        tags.add(['t', t]);
      }
    }

    return await Event.from(
        kind: 12, tags: tags, content: content, pubkey: pubkey, privkey: privkey);
  }

  static Future<Event> encodeGroupMessage(
      String groupId, String content, List<String> previous, String pubkey, String privkey,
      {String? subContent}) async {
    List<List<String>> tags = [];
    tags.add(['h', groupId]);
    // if (previous.isNotEmpty) tags.add(['previous', ...previous]);
    if (subContent != null && subContent.isNotEmpty) {
      tags.add(['subContent', subContent]);
    }
    Event event =
        await Event.from(kind: 9, tags: tags, content: content, pubkey: pubkey, privkey: privkey);
    return event;
  }

  static Future<Event> encodeGroupMessageReply(
      String groupId, String content, List<String> previous, String pubkey, String privkey,
      {String? replyEvent, String? replyUser, String? subContent, int createAt = 0}) async {
    List<List<String>> tags = [];
    int kind = 9; // normal message
    tags.add(['h', groupId]);
    if (replyEvent != null) {
      tags.add(["q", replyEvent, '', '']);
    }
    if (replyUser != null) {
      tags.add(["p", replyUser]);
    }
    // if (previous.isNotEmpty) tags.add(['previous', ...previous]);

    if (subContent != null && subContent.isNotEmpty) {
      tags.add(['subContent', subContent]);
    }
    Event event = await Event.from(
        kind: kind,
        tags: tags,
        content: content,
        pubkey: pubkey,
        privkey: privkey,
        createdAt: createAt);
    return event;
  }

  static Future<Event> encodeJoinRequest(
      String groupId, String content, String pubkey, String privkey) async {
    List<List<String>> tags = [];
    tags.add(['h', groupId]);
    Event event = await Event.from(
        kind: 9021, tags: tags, content: content, pubkey: pubkey, privkey: privkey);
    return event;
  }

  static Future<Event> encodeLeaveRequest(
      String groupId, String content, String pubkey, String privkey) async {
    List<List<String>> tags = [];
    tags.add(['h', groupId]);
    Event event = await Event.from(
        kind: 9022, tags: tags, content: content, pubkey: pubkey, privkey: privkey);
    return event;
  }

  static Future<Event> encodeCreateGroup(String groupId, String pubkey, String privkey) async {
    List<List<String>> tags = [];
    tags.add(['h', groupId]);
    Event event =
        await Event.from(kind: 9007, tags: tags, content: '', pubkey: pubkey, privkey: privkey);
    return event;
  }

  static Future<Event> _encodeGroupAction(
      String groupId,
      GroupActionKind actionKind,
      String content,
      List<List<String>> tags,
      List<String> previous,
      String pubkey,
      String privkey) async {
    tags.add(['h', groupId]);
    // if (previous.isNotEmpty) tags.add(['previous', ...previous]);
    Event event = await Event.from(
        kind: actionKind.kind, tags: tags, content: content, pubkey: pubkey, privkey: privkey);
    return event;
  }

  static Future<Event> encodeAddUser(String groupId, List<String> addUser, String content,
      List<String> previous, String pubkey, String privkey) async {
    List<List<String>> tags = [];
    for (var p in addUser) {
      tags.add(['p', p]);
    }
    return _encodeGroupAction(
        groupId, GroupActionKind.addUser, content, tags, previous, pubkey, privkey);
  }

  static Future<Event> encodeRemoveUser(String groupId, List<String> removeUsers, String content,
      List<String> previous, String pubkey, String privkey) async {
    List<List<String>> tags = [];
    for (var p in removeUsers) {
      tags.add(['p', p]);
    }
    return _encodeGroupAction(
        groupId, GroupActionKind.removeUser, content, tags, previous, pubkey, privkey);
  }

  static Future<Event> encodeEditMetadata(
      String groupId,
      String name,
      String about,
      String picture,
      String content,
      bool closed,
      bool private,
      List<String> previous,
      String pubkey,
      String privkey) async {
    List<List<String>> tags = [];
    tags.add(['name', name]);
    tags.add(['about', about]);
    tags.add(['picture', picture]);
    private ? tags.add(['private']) : tags.add(['public']);
    closed ? tags.add(['closed']) : tags.add(['open']);
    return _encodeGroupAction(
        groupId, GroupActionKind.editMetadata, content, tags, previous, pubkey, privkey);
  }

  static Future<Event> encodeAddPermission(
      String groupId,
      List<String> users,
      List<String> permissions,
      String content,
      List<String> previous,
      String pubkey,
      String privkey) async {
    List<List<String>> tags = [];
    for (var p in users) {
      tags.add(['p', p, 'bishop']);
    }

    return _encodeGroupAction(
        groupId, GroupActionKind.addUser, content, tags, previous, pubkey, privkey);
  }

  static Future<Event> encodeRemovePermission(
      String groupId,
      List<String> users,
      List<String> permissions,
      String content,
      List<String> previous,
      String pubkey,
      String privkey) async {
    List<List<String>> tags = [];
    for (var p in users) {
      tags.add(['p', p]);
    }
    return _encodeGroupAction(
        groupId, GroupActionKind.addUser, content, tags, previous, pubkey, privkey);
  }

  static Future<Event> encodeDeleteEvent(String groupId, String eventId, String content,
      List<String> previous, String pubkey, String privkey) async {
    List<List<String>> tags = [];
    tags.add(['e', eventId]);
    return _encodeGroupAction(
        groupId, GroupActionKind.deleteEvent, content, tags, previous, pubkey, privkey);
  }

  static Future<Event> encodeEditGroupStatus(String groupId, bool private, bool closed,
      String content, List<String> previous, String pubkey, String privkey) async {
    List<List<String>> tags = [];
    private ? tags.add(['private']) : tags.add(['public']);
    closed ? tags.add(['closed']) : tags.add(['open']);
    return _encodeGroupAction(
        groupId, GroupActionKind.editGroupStatus, content, tags, previous, pubkey, privkey);
  }

  static Future<Event> encodeDeleteGroupStatus(
      String groupId, String content, List<String> previous, String pubkey, String privkey) async {
    List<List<String>> tags = [];
    return _encodeGroupAction(
        groupId, GroupActionKind.deleteGroup, content, tags, previous, pubkey, privkey);
  }

  static Future<Event> encodeCreateInvite(
      String groupId, String code, List<String> previous, String pubkey, String privkey) async {
    List<List<String>> tags = [
      ['code', code]
    ];
    return _encodeGroupAction(
        groupId, GroupActionKind.createInvite, '', tags, previous, pubkey, privkey);
  }

  static Future<Event> encodeGroupModeration(
      GroupModeration moderation, String pubkey, String privkey) {
    switch (moderation.actionKind) {
      case GroupActionKind.addUser:
        return encodeAddUser(moderation.groupId, moderation.users, moderation.content,
            moderation.previous, pubkey, privkey);
      case GroupActionKind.removeUser:
        return encodeRemoveUser(moderation.groupId, moderation.users, moderation.content,
            moderation.previous, pubkey, privkey);
      case GroupActionKind.editMetadata:
        return encodeEditMetadata(
            moderation.groupId,
            moderation.name,
            moderation.about,
            moderation.picture,
            moderation.content,
            moderation.closed,
            moderation.private,
            moderation.previous,
            pubkey,
            privkey);
      case GroupActionKind.addPermission:
        return encodeAddPermission(moderation.groupId, moderation.users, moderation.permissions,
            moderation.content, moderation.previous, pubkey, privkey);
      case GroupActionKind.removePermission:
        return encodeRemovePermission(moderation.groupId, moderation.users, moderation.permissions,
            moderation.content, moderation.previous, pubkey, privkey);
      case GroupActionKind.deleteEvent:
        return encodeDeleteEvent(moderation.groupId, moderation.eventId, moderation.content,
            moderation.previous, pubkey, privkey);
      case GroupActionKind.editGroupStatus:
        return encodeEditGroupStatus(moderation.groupId, moderation.private, moderation.closed,
            moderation.content, moderation.previous, pubkey, privkey);
      case GroupActionKind.deleteGroup:
        return encodeDeleteGroupStatus(
            moderation.groupId, moderation.content, moderation.previous, pubkey, privkey);
      case GroupActionKind.createInvite:
        return encodeCreateInvite(
            moderation.groupId, moderation.inviteCode, moderation.previous, pubkey, privkey);
        break;
    }
  }
}

enum GroupActionKind {
  addUser(9000, 'put-user'),
  removeUser(9001, 'remove-user'),
  editMetadata(9002, 'edit-metadata'),
  addPermission(9003, 'add-permission'),
  removePermission(9004, 'remove-permission'),
  deleteEvent(9005, 'delete-event'),
  editGroupStatus(9006, 'edit-group-status'),
  deleteGroup(9008, 'delete-group'),
  createInvite(9009, 'create-invite');

  final int kind;
  final String name;

  const GroupActionKind(this.kind, this.name);

  static GroupActionKind fromString(String name) {
    if (name == 'delete-group-status') return GroupActionKind.deleteGroup;
    return GroupActionKind.values.firstWhere((element) => element.name == name,
        orElse: () => throw ArgumentError('Invalid permission name: $name'));
  }

  static GroupActionKind fromKind(int kind) {
    return GroupActionKind.values.firstWhere((element) => element.kind == kind,
        orElse: () => throw ArgumentError('Invalid permission name: $kind'));
  }

  static List<GroupActionKind> all() {
    return [
      GroupActionKind.addUser,
      GroupActionKind.removeUser,
      GroupActionKind.editMetadata,
      GroupActionKind.addPermission,
      GroupActionKind.removePermission,
      GroupActionKind.editGroupStatus,
      GroupActionKind.deleteEvent,
      GroupActionKind.deleteGroup
    ];
  }

  static List<GroupActionKind> king() {
    return [
      GroupActionKind.addUser,
      GroupActionKind.removeUser,
      GroupActionKind.editMetadata,
      GroupActionKind.addPermission,
      GroupActionKind.removePermission,
      GroupActionKind.editGroupStatus,
      GroupActionKind.deleteEvent,
      GroupActionKind.deleteGroup
    ];
  }

  static List<GroupActionKind> bishop() {
    return [
      GroupActionKind.addUser,
      GroupActionKind.removeUser,
      GroupActionKind.deleteEvent,
    ];
  }
}

class GroupAdmin {
  String pubkey;
  String role;
  List<GroupActionKind> permissions;

  GroupAdmin(this.pubkey, this.role, this.permissions);

  factory GroupAdmin.fromJson(List<dynamic> json) {
    String pubkey = json[0];
    String role = json[1];
    List<GroupActionKind> permissions =
        (json.sublist(2).cast<String>()).map((p) => GroupActionKind.fromString(p)).toList();
    return GroupAdmin(pubkey, role, permissions);
  }

  List<dynamic> toJson() {
    return [pubkey, role, ...permissions.map((p) => p.name)];
  }
}

/// groups info
class Group {
  String id; //<host>'<group-id>
  String relay;
  String relayPubkey;
  String groupId;
  bool private;
  bool closed;
  List<GroupAdmin> mods;
  String name;
  String about;
  String picture;
  String? pinned;
  List<String> members;
  int level; // group level
  int point; // group point
  /// Clients MAY add additional metadata fields.
  Map<String, dynamic>? additional;

  /// Default constructor
  Group(
      this.id,
      this.relay,
      this.relayPubkey,
      this.groupId,
      this.private,
      this.closed,
      this.mods,
      this.name,
      this.about,
      this.picture,
      this.pinned,
      this.members,
      this.level,
      this.point,
      this.additional);
}

class GroupNote {
  String groupId;
  String nodeId;
  Note note;
  List<String>? previous;

  GroupNote(this.groupId, this.nodeId, this.note, this.previous);
}

class GroupMessage {
  String groupId;
  String messageId;
  String pubkey;
  int createAt;
  String? replyId;
  String? replyUser;
  String content;
  List<String>? previous;

  GroupMessage(this.groupId, this.messageId, this.pubkey, this.createAt, this.replyId,
      this.replyUser, this.content, this.previous);
}

class GroupJoinRequest {
  String requestId;
  String groupId;
  String pubkey;
  int createdAt;
  String content;

  GroupJoinRequest(this.requestId, this.groupId, this.pubkey, this.createdAt, this.content);
}

class GroupModeration {
  String moderationId;
  String groupId;
  String pubkey;
  int createdAt;
  String content;
  GroupActionKind actionKind;
  List<String> previous;

  List<String> users;
  List<String> permissions;
  String eventId;
  bool private;
  bool closed;
  String name;
  String about;
  String picture;
  String pinned;
  String inviteCode;

  GroupModeration(
      {this.moderationId = '',
      this.groupId = '',
      this.pubkey = '',
      this.createdAt = 0,
      this.content = '',
      this.actionKind = GroupActionKind.addUser,
      this.previous = const [],
      this.users = const [],
      this.permissions = const [],
      this.eventId = '',
      this.private = false,
      this.closed = false,
      this.name = '',
      this.about = '',
      this.picture = '',
      this.pinned = '',
      this.inviteCode = ''});

  factory GroupModeration.addUser(String groupId, List<String> addUser, String reason) {
    return GroupModeration(
        groupId: groupId, users: addUser, content: reason, actionKind: GroupActionKind.addUser);
  }

  factory GroupModeration.removeUser(String groupId, List<String> removeUsers, String reason) {
    return GroupModeration(
        groupId: groupId,
        users: removeUsers,
        content: reason,
        actionKind: GroupActionKind.removeUser);
  }

  factory GroupModeration.editMetadata(String groupId, String name, String about, String picture,
      bool closed, bool private, String reason) {
    return GroupModeration(
        groupId: groupId,
        name: name,
        about: about,
        picture: picture,
        content: reason,
        closed: closed,
        private: private,
        actionKind: GroupActionKind.editMetadata);
  }

  factory GroupModeration.addPermission(
      String groupId, List<String> user, List<String> permissions, String reason) {
    return GroupModeration(
        groupId: groupId,
        users: user,
        permissions: permissions,
        content: reason,
        actionKind: GroupActionKind.addPermission);
  }

  factory GroupModeration.removePermission(
      String groupId, List<String> user, List<String> permissions, String reason) {
    return GroupModeration(
        groupId: groupId,
        users: user,
        permissions: permissions,
        content: reason,
        actionKind: GroupActionKind.removePermission);
  }

  factory GroupModeration.deleteEvent(String groupId, String eventId, String reason) {
    return GroupModeration(
        groupId: groupId,
        eventId: eventId,
        content: reason,
        actionKind: GroupActionKind.deleteEvent);
  }

  factory GroupModeration.editGroupStatus(
      String groupId, bool closed, bool private, String reason) {
    return GroupModeration(
        groupId: groupId,
        closed: closed,
        private: private,
        content: reason,
        actionKind: GroupActionKind.editGroupStatus);
  }

  factory GroupModeration.deleteGroup(String groupId, String reason) {
    return GroupModeration(
        groupId: groupId, content: reason, actionKind: GroupActionKind.deleteGroup);
  }
}
