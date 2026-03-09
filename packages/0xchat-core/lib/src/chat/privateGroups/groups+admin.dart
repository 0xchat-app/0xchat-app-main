import 'dart:async';

import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:nostr_core_dart/nostr.dart';

extension Admin on Groups {
  Future<GroupDBISAR?> createGroup(String name, List<String> members, String content,
      {String? about, String? picture, String? relay}) async {
    members = members.toSet().toList();
    Event event = await Nip28.createChannel(name, about ?? '', picture ?? '', {}, pubkey, privkey);
    OKEvent ok = await sendMessageEvent(members, event);
    if (ok.status == true) {
      // update group
      GroupDBISAR groupDB = GroupDBISAR(
          groupId: event.id,
          updateTime: event.createdAt,
          owner: pubkey,
          name: name,
          about: about,
          picture: picture,
          relay: relay,
          members: members);

      ok = await updateGroup(groupDB);
      if (ok.status == true) {
        sendGroupMessage(groupDB.privateGroupId, MessageType.system, content, actionsType: 'add');
        myGroups[groupDB.privateGroupId] = ValueNotifier(groupDB);
        // update my group list
        await syncMyGroupListToRelay();
        myGroupsUpdatedCallBack?.call();
        return groupDB;
      }
    }
    return null;
  }

  Future<OKEvent> updateGroup(GroupDBISAR groupDB, {List<String>? removedMembers}) async {
    Event event = await Nip28.setChannelMetaData(
        groupDB.name,
        groupDB.about ?? '',
        groupDB.picture ?? '',
        groupDB.pinned,
        groupDB.members,
        null,
        groupDB.privateGroupId,
        groupDB.relay ?? '',
        pubkey,
        privkey);
    List<String> members = List.from(groupDB.members ?? []);
    members.addAll(removedMembers ?? []);
    OKEvent ok = await sendMessageEvent(members, event);
    if (ok.status) {
      await syncGroupToDB(groupDB);
    }
    return ok;
  }

  Future<OKEvent> addGroupMembers(String groupId, String content, List<String> members) async {
    members = members.toSet().toList();
    GroupDBISAR? groupDB = myGroups[groupId]?.value;
    if (groupDB != null && groupDB.owner == pubkey) {
      List<String>? groupMembers = groupDB.members;
      if (groupMembers != null) {
        List<String> uniqueMembers =
            members.where((element) => !groupMembers.contains(element)).toList();
        groupDB.members!.addAll(uniqueMembers);
      } else {
        groupDB.members = members;
      }
      OKEvent okEvent = await updateGroup(groupDB);
      if (okEvent.status) {
        sendGroupMessage(groupId, MessageType.system, content, actionsType: 'add');
      }
      return okEvent;
    } else {
      return OKEvent(groupId, false, 'Not the owner of group');
    }
  }

  Future<OKEvent> removeGroupMembers(String groupId, String content, List<String> members) async {
    members = members.toSet().toList();
    GroupDBISAR? groupDB = myGroups[groupId]?.value;
    if (groupDB != null && groupDB.owner == pubkey) {
      if (groupDB.members != null) {
        OKEvent okEvent =
            await sendGroupMessage(groupId, MessageType.system, content, actionsType: 'remove');
        if (okEvent.status) {
          List<String> removedMembers = [];
          List<String> ms = List.from(members);
          for (var m in ms) {
            if (groupDB.members?.contains(m) == true) {
              groupDB.members?.remove(m);
              removedMembers.add(m);
            }
          }
          groupDB.members!.removeWhere((element) => members.contains(element));
          okEvent = await updateGroup(groupDB, removedMembers: removedMembers);
        }
        return okEvent;
      } else {
        return OKEvent(groupId, true, 'success');
      }
    } else {
      return OKEvent(groupId, false, 'Not the owner of group');
    }
  }

  Future<OKEvent> updateGroupName(String groupId, String content, String name) async {
    GroupDBISAR? groupDB = myGroups[groupId]?.value;
    if (groupDB != null && groupDB.owner == pubkey) {
      groupDB.name = name;
      OKEvent okEvent = await updateGroup(groupDB);
      if (okEvent.status) {
        sendGroupMessage(groupId, MessageType.system, content, actionsType: 'updateName');
      }
      return okEvent;
    } else {
      return OKEvent(groupId, false, 'Not the owner of group');
    }
  }

  Future<OKEvent> updateGroupPinned(String groupId, String content, String pinned) async {
    GroupDBISAR? groupDB = myGroups[groupId]?.value;
    if (groupDB != null && groupDB.owner == pubkey) {
      groupDB.pinned = [pinned];
      OKEvent okEvent = await updateGroup(groupDB);
      if (okEvent.status) {
        sendGroupMessage(groupId, MessageType.system, content, actionsType: 'updatePinned');
      }
      return okEvent;
    } else {
      return OKEvent(groupId, false, 'Not the owner of group');
    }
  }

  Future<List<MessageDBISAR>> getRequestList({String? groupId}) async {
    List<MessageDBISAR> messages;
    final isar = DBISAR.sharedInstance.isar;
    if (groupId == null) {
      messages = await isar.messageDBISARs
          .filter()
          .chatTypeEqualTo(1)
          .typeEqualTo('system')
          .subTypeEqualTo('request')
          .findAll();
    } else {
      messages = await isar.messageDBISARs
          .filter()
          .groupIdEqualTo(groupId)
          .chatTypeEqualTo(1)
          .typeEqualTo('system')
          .subTypeEqualTo('request')
          .findAll();
    }
    return messages;
  }

  Future<void> ignoreRequest(MessageDBISAR messageDB) async {
    await Messages.deleteMessagesFromDB(messageIds: [messageDB.messageId]);
  }

  Future<void> acceptRequest(MessageDBISAR messageDB, String content) async {
    String groupId = messageDB.groupId;
    String sender = messageDB.sender;
    GroupDBISAR? groupDB = myGroups[groupId]?.value;
    if (groupDB != null && groupDB.owner == pubkey) {
      await addGroupMembers(groupId, content, [sender]);
    }
    await Messages.deleteMessagesFromDB(messageIds: [messageDB.messageId]);
  }

  Future<OKEvent> deleteAndLeave(String groupId, String content) async {
    GroupDBISAR? groupDB = myGroups[groupId]?.value;
    if (groupDB?.isMLSGroup == true) {
      OKEvent result = await leaveMLSGroup(groupDB!);
      if (result.status) {
        await deleteGroup(groupId);
      }
      return result;
    }

    if (groupDB != null && groupDB.owner == pubkey) {
      OKEvent okEvent = await removeGroupMembers(groupId, content, groupDB.members ?? []);
      if (okEvent.status) {
        okEvent = await leaveGroup(groupId, content);
      }
      if (okEvent.status) await deleteGroup(groupId);
      return okEvent;
    } else {
      return OKEvent(groupId, false, 'Not the owner of group');
    }
  }
}
