import 'dart:async';

import 'package:chatcore/chat-core.dart';
import 'package:isar/isar.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

extension Member on Groups {
  // Future<OKEvent> inviteGroup(
  //     String groupId, List<String> inviteUsers, String content) async {
  //   if (groups.containsKey(groupId)) {
  //     OKEvent okEvent = await sendGroupMessage(
  //         groupId, MessageType.system, content,
  //         actionsType: 'invite', inviteUsers: inviteUsers);
  //     return okEvent;
  //   }
  //   return OKEvent(groupId, false, 'group not found');
  // }

  Future<OKEvent> requestGroup(
      String groupId, String groupOwner, String groupName, String content) async {
    content = "${Account.sharedInstance.me?.name} request to join the group";
    GroupDBISAR? groupDB = groups[groupId]?.value;
    groupDB ??= GroupDBISAR(groupId: groupId, owner: groupOwner, name: groupName);
    if (groupDB.owner.isEmpty) groupDB.owner = groupOwner;
    if (groupDB.name.isEmpty) groupDB.name = groupName;
    await Groups.saveGroupToDB(groupDB);
    OKEvent? okEvent;
    if (!checkInGroup(groupId)) {
      groups[groupId]?.value = groupDB;
      myGroups[groupId]?.value = groupDB;
      okEvent =
          await sendGroupMessage(groupId, MessageType.system, content, actionsType: 'request');
      okEvent = await syncMyGroupListToRelay();
    } else {
      okEvent = OKEvent(groupId, false, 'already in group');
    }
    return okEvent;
  }

  Future<OKEvent> joinGroup(String groupId, String content) async {
    if (groups.containsKey(groupId) && groups[groupId]?.value.members?.contains(pubkey) == true) {
      var group = groups[groupId]!.value;
      if (group.isMLSGroup) return await joinMLSGroup(group);
      myGroups[groupId] = groups[groupId]!;
      OKEvent ok = await syncMyGroupListToRelay();
      if (ok.status) {
        sendGroupMessage(groupId, MessageType.system, content, actionsType: 'join');
      }
      return ok;
    }
    return OKEvent(groupId, false, 'group not found');
  }

  Future<OKEvent> leaveGroup(String groupId, String content) async {
    GroupDBISAR? groupDB = myGroups[groupId]?.value;
    if (groupDB?.isMLSGroup == true) {
      OKEvent result = await leaveMLSGroup(groupDB!);
      if (result.status) {
        await deleteGroup(groupId);
      }
      return result;
    }

    myGroups.remove(groupId);
    OKEvent ok = await syncMyGroupListToRelay();
    if (ok.status) {
      sendGroupMessage(groupId, MessageType.system, content, actionsType: 'leave');
    }
    return ok;
  }

  Future<void> deleteGroup(String groupId) async {
    final isar = DBISAR.sharedInstance.isar;
    await isar.writeTxn(() async {
      await isar.groupDBISARs.deleteByGroupId(groupId);
    });
  }

  Future<void> muteGroup(String groupId) async {
    _setMuteGroup(groupId, true);
  }

  Future<void> unMuteGroup(String groupId) async {
    _setMuteGroup(groupId, false);
  }

  Future<void> _setMuteGroup(String groupId, bool mute) async {
    if (myGroups.containsKey(groupId)) {
      GroupDBISAR groupDB = myGroups[groupId]!.value;
      groupDB.mute = mute;
      await syncGroupToDB(groupDB);
    }
  }

  Future<List<UserDBISAR>> getAllGroupMembers(String groupId) async {
    GroupDBISAR? groupDB = groups[groupId]?.value;
    List<UserDBISAR> result = [];
    if (groupDB != null && groupDB.members != null) {
      await Future.forEach(groupDB.members!, (member) async {
        UserDBISAR? userDB = await Account.sharedInstance.getUserInfo(member);
        if (userDB != null) {
          if (groupDB.owner == member) {
            result.insert(0, userDB);
          } else {
            result.add(userDB);
          }
        }
      });
    }
    return result;
  }
}
