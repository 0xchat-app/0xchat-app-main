import 'dart:async';
import 'package:chatcore/chat-core.dart';
import 'package:isar/isar.dart';
import 'package:nostr_core_dart/nostr.dart';

extension EAdmin on RelayGroup {
  bool hasPermissions(List<GroupAdmin> admins, String user, List<GroupActionKind> permissions) {
    if (admins.isNotEmpty && admins.any((admin) => admin.pubkey == user)) {
      var admin = admins.firstWhere((admin) => admin.pubkey == user);
      return permissions.every((permission) => admin.permissions.contains(permission));
    }
    return false;
  }

  Future<void> saveJoinRequestDBToDB(JoinRequestDBISAR joinRequestDB) async {
    await DBISAR.sharedInstance.saveToDB(joinRequestDB);
  }

  Future<void> handleJoinRequest(Event event, String relay) async {
    GroupJoinRequest joinRequest = Nip29.decodeJoinRequest(event);
    RelayGroupDBISAR? groupDB = groups[joinRequest.groupId]?.value;
    if (groupDB == null || !groupDB.private) return;
    if (hasPermissions(groupDB.admins, pubkey, [GroupActionKind.addUser])) {
      JoinRequestDBISAR joinRequestDB = JoinRequestDBISAR.toJoinRequestDB(joinRequest);
      await saveJoinRequestDBToDB(joinRequestDB);
      joinRequestCallBack?.call(joinRequestDB);
    }
  }

  Future<List<JoinRequestDBISAR>> getRequestList(String groupId) async {
    final isar = DBISAR.sharedInstance.isar;
    return await isar.joinRequestDBISARs.filter().groupIdEqualTo(groupId).findAll();
  }

  Future<OKEvent> acceptJoinRequest(JoinRequestDBISAR joinRequest) async {
    RelayGroupDBISAR? groupDB = groups[joinRequest.groupId]?.value;
    if (groupDB == null || !groupDB.private) {
      return OKEvent(joinRequest.groupId, false, 'group not exit');
    }
    if (hasPermissions(groupDB.admins, pubkey, [GroupActionKind.addUser])) {
      return await addUser(groupDB.groupId, [joinRequest.author], '');
    } else {
      return OKEvent(joinRequest.groupId, false, 'no permissions');
    }
  }

  Future<bool> ignoreJoinRequest(JoinRequestDBISAR joinRequest) async {
    final isar = DBISAR.sharedInstance.isar;
    await isar.writeTxn(() async {
      await isar.joinRequestDBISARs.deleteByRequestId(joinRequest.requestId);
    });
    return true;
  }

  Future<OKEvent> sendModeration(GroupModeration moderation) async {
    String groupId = moderation.groupId;
    RelayGroupDBISAR? groupDB = myGroups[groupId]?.value;
    if (groupDB == null) return OKEvent(groupId, false, 'group not exit');
    if (groupDB.admins.isEmpty) {
      return OKEvent(groupId, false, 'group admins not exit');
    }
    if (moderation.actionKind == GroupActionKind.removeUser &&
        moderation.users.singleOrNull == pubkey) {
      LogUtils.v(() => 'sendModeration: leave group');
    } else if (!hasPermissions(groupDB.admins, pubkey, [moderation.actionKind])) {
      return OKEvent(groupId, false, 'permission not met');
    }

    Completer<OKEvent> completer = Completer<OKEvent>();
    List<String> previous = await getPrevious(moderation.groupId);
    moderation.previous = previous;
    Event event = await Nip29.encodeGroupModeration(moderation, pubkey, privkey);
    Connect.sharedInstance.sendEvent(event, toRelays: [groupDB.relay],
        sendCallBack: (ok, relay) async {
      if (!completer.isCompleted) completer.complete(ok);
      if (ok.status == true) {
        ModerationDBISAR moderationDB = ModerationDBISAR.toModerationDB(moderation);
        await saveModerationToDB(moderationDB);
      }
    });
    return completer.future;
  }

  Future<OKEvent> addUser(String groupId, List<String> addUsers, String reason) async {
    RelayGroupDBISAR? groupDB = myGroups[groupId]?.value;
    if (groupDB == null) return OKEvent(groupId, false, 'group not exit');
    GroupModeration moderation = GroupModeration.addUser(groupId, addUsers, reason);
    OKEvent ok = await sendModeration(moderation);
    if (ok.status) {
      groupDB.members ??= [];
      groupDB.members = groupDB.members!.toSet().union(addUsers.toSet()).toList();
      syncGroupToDB(groupDB);
    }
    return ok;
  }

  Future<OKEvent> removeUser(String groupId, List<String> removeUsers, String reason) async {
    RelayGroupDBISAR? groupDB = myGroups[groupId]?.value;
    if (groupDB == null) return OKEvent(groupId, false, 'group not exit');
    GroupModeration moderation = GroupModeration.removeUser(groupId, removeUsers, reason);
    OKEvent ok = await sendModeration(moderation);
    if (ok.status) {
      groupDB.members?.removeWhere((e) => removeUsers.contains(e));
      syncGroupToDB(groupDB);
    }
    return ok;
  }

  Future<OKEvent> deleteGroup(String groupId, String reason) async {
    RelayGroupDBISAR? groupDB = myGroups[groupId]?.value;
    if (groupDB == null) return OKEvent(groupId, false, 'group not exit');
    GroupModeration moderation = GroupModeration.deleteGroup(groupId, reason);
    OKEvent ok = await sendModeration(moderation);
    if (ok.status) {
      myGroups.remove(groupId);
      groups.remove(groupId);
      await deleteGroupFromDB(groupId);
    }
    return ok;
  }

  Future<OKEvent> editMetadata(
      String groupId, String name, String about, String picture, bool closed, bool private, String reason) async {
    RelayGroupDBISAR? groupDB = myGroups[groupId]?.value;
    if (groupDB == null) return OKEvent(groupId, false, 'group not exit');
    GroupModeration moderation =
        GroupModeration.editMetadata(groupId, name, about, picture, closed, private, reason);
    OKEvent ok = await sendModeration(moderation);
    if (ok.status) {
      groupDB.name = name;
      groupDB.about = about;
      groupDB.picture = picture;
      groupDB.closed = closed;
      groupDB.private = private;
      syncGroupToDB(groupDB);
    }
    return ok;
  }

  Future<OKEvent> addAdmin(String groupId, String user, String reason) async {
    RelayGroupDBISAR? groupDB = myGroups[groupId]?.value;
    if (groupDB == null) return OKEvent(groupId, false, 'group not exit');

    return _addPermissions(groupId, user, GroupActionKind.bishop(), reason);
  }

  Future<OKEvent> removeAdmin(String groupId, String user, String reason) async {
    RelayGroupDBISAR? groupDB = myGroups[groupId]?.value;
    if (groupDB == null) return OKEvent(groupId, false, 'group not exit');

    return _removePermissions(groupId, user, GroupActionKind.bishop(), reason);
  }

  Future<OKEvent> setPermissions(
      String groupId, String user, List<GroupActionKind> permissions, String reason) async {
    RelayGroupDBISAR? groupDB = myGroups[groupId]?.value;
    if (groupDB == null) return OKEvent(groupId, false, 'group not exit');
    List<GroupAdmin>? admins = groupDB.admins.where((admin) => admin.pubkey == user).toList();
    if (admins.isNotEmpty) {
      List<GroupActionKind> oldList = admins.first.permissions;
      List<GroupActionKind> addList = [];
      List<GroupActionKind> removeList = [];

      for (var newItem in permissions) {
        if (!oldList.contains(newItem)) {
          addList.add(newItem);
        }
      }

      for (var oldItem in oldList) {
        if (!permissions.contains(oldItem)) {
          removeList.add(oldItem);
        }
      }

      OKEvent okEvent = OKEvent(groupId, true, '');
      if (addList.isNotEmpty) {
        okEvent = await _addPermissions(groupId, user, addList, reason);
      }
      if (removeList.isNotEmpty) {
        okEvent = await _removePermissions(groupId, user, removeList, reason);
      }
      return okEvent;
    }
    return _addPermissions(groupId, user, permissions, reason);
  }

  Future<OKEvent> _addPermissions(
      String groupId, String user, List<GroupActionKind> permissions, String reason) async {
    RelayGroupDBISAR? groupDB = groups[groupId]?.value;
    if (groupDB == null) return OKEvent(groupId, false, 'group not exit');
    GroupModeration moderation = GroupModeration.addPermission(
        groupId, [user], permissions.map((e) => e.name).toList(), reason);
    OKEvent ok = await sendModeration(moderation);
    if (ok.status) {
      bool exit = false;
      for (GroupAdmin admin in groupDB.admins) {
        if (admin.pubkey == user) {
          exit = true;
          admin.permissions.addAll(permissions);
          break;
        }
      }
      if (!exit) {
        GroupAdmin admin = GroupAdmin(user, 'bishop', permissions);
        List<GroupAdmin> admins = List.from(groupDB.admins);
        admins.add(admin);
        groupDB.admins = admins;
      }
      syncGroupToDB(groupDB);
    }
    return ok;
  }

  Future<OKEvent> _removePermissions(
      String groupId, String user, List<GroupActionKind> permissions, String reason) async {
    RelayGroupDBISAR? groupDB = myGroups[groupId]?.value;
    if (groupDB == null) return OKEvent(groupId, false, 'group not exit');
    GroupModeration moderation = GroupModeration.removePermission(
        groupId, [user], permissions.map((e) => e.name).toList(), reason);
    OKEvent ok = await sendModeration(moderation);
    if (ok.status) {
      for (GroupAdmin admin in groupDB.admins) {
        if (admin.pubkey == user) {
          admin.permissions.removeWhere(
              (permission) => permissions.any((element) => element.name == permission.name));
          if (admin.permissions.isEmpty) {
            List<GroupAdmin> admins = List.from(groupDB.admins);
            admins.removeWhere((admin) => admin.pubkey == user);
            groupDB.admins = admins;
          }
          break;
        }
      }
      syncGroupToDB(groupDB);
    }
    return ok;
  }

  bool hasDeletePermission(String groupId) {
    RelayGroupDBISAR? groupDB = myGroups[groupId]?.value;
    if (groupDB == null) return false;
    return hasPermissions(groupDB.admins, pubkey, [GroupActionKind.deleteEvent]);
  }

  Future<OKEvent> deleteMessageFromRelay(String groupId, String messageId, String reason) async {
    OKEvent ok = await deleteEvent(groupId, messageId, reason);
    if (ok.status) {
      ok = await deleteMessageFromLocal(messageId);
    }
    return ok;
  }

  Future<OKEvent> deleteMessageFromLocal(String messageId) async {
    await Messages.deleteMessagesFromDB(messageIds: [messageId]);
    return OKEvent(messageId, true, '');
  }

  Future<OKEvent> deleteNoteFromRelay(String groupId, String noteId, String reason) async {
    OKEvent ok = await deleteEvent(groupId, noteId, reason);
    if (ok.status) {
      ok = await deleteNoteFromLocal(noteId);
    }
    return ok;
  }

  Future<OKEvent> deleteNoteFromLocal(String noteId) async {
    final isar = DBISAR.sharedInstance.isar;
    await isar.writeTxn(() async {
      await isar.noteDBISARs.deleteByNoteId(noteId);
    });
    return OKEvent(noteId, true, '');
  }

  Future<OKEvent> deleteEvent(String groupId, String eventId, String reason) async {
    GroupModeration moderation = GroupModeration.deleteEvent(groupId, eventId, reason);
    return sendModeration(moderation);
  }

  // Future<OKEvent> editGroupStatus(String groupId, bool closed, bool private, String reason) async {
  //   RelayGroupDBISAR? groupDB = myGroups[groupId]?.value;
  //   if (groupDB == null) return OKEvent(groupId, false, 'group not exit');
  //   GroupModeration moderation = GroupModeration.editGroupStatus(groupId, closed, private, reason);
  //   OKEvent ok = await sendModeration(moderation);
  //   if (ok.status) {
  //     groupDB.private = private;
  //     groupDB.closed = closed;
  //     syncGroupToDB(groupDB);
  //   }
  //   return ok;
  // }
}
