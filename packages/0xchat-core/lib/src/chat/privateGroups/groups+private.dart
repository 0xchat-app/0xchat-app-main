import 'dart:async';
import 'dart:convert';

import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:sqflite_sqlcipher/sqlite_api.dart';

extension PrivateGroups on Groups {
  // Future<void> connectToGroupRelays(String groupId) async {
  //   GroupDB? groupDB = myGroups[groupId];
  //   if (groupDB != null) {
  //     Map<String, UserDB> users =
  //         await Account.sharedInstance.getUserInfos(groupDB.members ?? []);
  //     Set<String> relays = {};
  //     for (var user in users.values) {
  //       relays.addAll(user.relayList ?? []);
  //     }
  //     currentGroupRelays[groupId] = relays.toList();
  //     await Connect.sharedInstance.connectRelays(currentGroupRelays[groupId]!,
  //         relayKind: RelayKind.relayGroup);
  //   }
  // }

  Future<void> closeGroupConnects(String groupId) async {
    await Connect.sharedInstance
        .closeConnects(currentGroupRelays[groupId] ?? [], RelayKind.relayGroup);
  }

  Future<GroupDBISAR?> createPrivateGroup(
      String sender, String groupId, String? name, List<String>? members,
      {int createAt = 0}) async {
    if (members == null || members.isEmpty) return null;
    if (!members.contains(pubkey)) return null;
    members = members.toSet().toList();
    if (groupId.isEmpty) groupId = ChatRoom.generateChatRoomID(members);
    if (myGroups.containsKey(groupId)) {
      myGroups[groupId]?.value.members = members;
      if (name != null && name.isNotEmpty && name != myGroups[groupId]?.value.name) {
        updatePrivateGroupName(sender, groupId, name, createAt: createAt);
      }
    } else {
      // add group
      GroupDBISAR groupDB = GroupDBISAR(
          groupId: groupId,
          updateTime: currentUnixTimestampSeconds(),
          name: name ?? '',
          members: members);
      groups[groupId] = ValueNotifier(groupDB);
      myGroups[groupId] = ValueNotifier(groupDB);
      // update my group list
      await syncGroupToDB(groupDB);
      await syncMyGroupListToDB();
    }
    myGroupsUpdatedCallBack?.call();
    return myGroups[groupId]?.value;
  }

  Future<GroupDBISAR?> addMembersToPrivateGroup(String groupId, List<String> members) async {
    GroupDBISAR? groupDB = myGroups[groupId]?.value;
    if (groupDB == null) return null;
    List<String> existingMembers = groupDB.members ?? [];
    Set<String> uniqueMembersSet = {...existingMembers, ...members};
    if (groupDB.isMLSGroup) {
      return await addMembersToMLSGroup(groupDB, members);
    } else {
      return await createPrivateGroup(pubkey, '', groupDB.name, uniqueMembersSet.toList());
    }
  }

  Future<GroupDBISAR?> removeMembersFromPrivateGroup(
      String groupId, List<String> membersToRemove) async {
    GroupDBISAR? groupDB = myGroups[groupId]?.value;
    if (groupDB == null) return null;
    List<String> existingMembers = groupDB.members ?? [];
    Set<String> updatedMembersSet = existingMembers.toSet();
    for (String member in membersToRemove) {
      updatedMembersSet.remove(member);
    }
    if (groupDB.isMLSGroup) {
      return await removeMembersFromMLSGroup(groupDB, membersToRemove);
    } else {
      return await createPrivateGroup(pubkey, '', groupDB.name, updatedMembersSet.toList());
    }
  }

  Future<OKEvent> updatePrivateGroupName(String sender, String groupId, String name,
      {int createAt = 0}) async {
    GroupDBISAR? groupDB = myGroups[groupId]?.value;
    if (groupDB != null) {
      groupDB.name = name;
      syncGroupToDB(groupDB);
      UserDBISAR? user = await Account.sharedInstance.getUserInfo(sender);
      sendPrivateGroupMessage(
          groupId, MessageType.system, "${user?.name} update group name to $name",
          local: true, createAt: createAt);
      return OKEvent(groupId, true, '');
    } else {
      return OKEvent(groupId, false, 'group not exit');
    }
  }

  Future<Event?> getSendPrivateGroupMessageEvent(String privateGroupId, MessageType type, String content,
      {String? source,
      String? replyMessage,
      String? replyUser,
      EncryptedFile? encryptedFile,
      int createAt = 0}) async {
    GroupDBISAR? groupDB = myGroups[privateGroupId]?.value;
    if (groupDB == null) return null;
    List<String>? members = groupDB.members;
    if (members == null) return null;
    late Event event;
    if (groupDB.isMLSGroup) {
      event = await Nip29.encodeGroupMessageReply(
          groupDB.groupId, MessageDBISAR.getContent(type, content, source), [], pubkey, privkey,
          replyEvent: replyMessage,
          replyUser: replyUser,
          subContent: MessageDBISAR.getSubContent(type, content));
    } else {
      event = await Nip17.encodeInnerEvent(
        '',
        MessageDBISAR.getContent(type, content, source),
        replyMessage ?? '',
        replyUser ?? '',
        pubkey,
        privkey,
        subContent: MessageDBISAR.getSubContent(type, content),
        members: members,
        subject: groupDB.name,
        createAt: createAt,
        encryptedFile: encryptedFile,
      );
    }
    return event;
  }

  Future<OKEvent> sendPrivateGroupMessage(String privateGroupId, MessageType type, String content,
      {String? source,
      String? replyMessage,
      Event? event,
      bool local = false,
      EncryptedFile? encryptedFile,
      int createAt = 0,
      String? replaceMessageId}) async {
    Completer<OKEvent> completer = Completer<OKEvent>();
    event ??= await getSendPrivateGroupMessageEvent(privateGroupId, type, content,
        source: source,
        replyMessage: replyMessage,
        encryptedFile: encryptedFile,
        createAt: createAt);

    late MessageDBISAR messageDB;
    if (replaceMessageId != null) {
      final replaceMessageDB = await Messages.sharedInstance.loadMessageDBFromDB(replaceMessageId);
      if (replaceMessageDB == null) {
        return Future.value(OKEvent(
          event?.innerEvent?.id ?? event!.id,
          false,
          'The message to be replaced was not found',
        ));
      }
      replaceMessageDB.messageId = event!.id;
      replaceMessageDB.content = event.content;
      groupMessageUpdateCallBack?.call(replaceMessageDB, replaceMessageId);
      messageDB = replaceMessageDB;
    } else {
      messageDB = MessageDBISAR(
        messageId: event!.id,
        sender: event.pubkey,
        receiver: '',
        groupId: privateGroupId,
        kind: event.kind,
        tags: jsonEncode(event.tags),
        replyId: replyMessage ?? '',
        content: event.content,
        decryptContent: content,
        type: MessageDBISAR.messageTypeToString(type),
        createTime: event.createdAt,
        status: 0,
        plaintEvent: jsonEncode(event),
        chatType: 1,
        decryptSecret: encryptedFile?.secret,
        decryptNonce: encryptedFile?.nonce,
        decryptAlgo: encryptedFile?.algorithm,
      );
      groupMessageCallBack?.call(messageDB);
    }
    var map = await MessageDBISAR.decodeContent(
        MessageDBISAR.getSubContent(type, content) ?? messageDB.content);
    messageDB.decryptContent = map['content'];
    messageDB.type = map['contentType'];
    if (encryptedFile?.mimeType != null &&
        (messageDB.type == 'image' ||
            messageDB.type == 'video' ||
            messageDB.type == 'audio' ||
            messageDB.type == 'file')) {
      messageDB.type = MessageDBISAR.mimeTypeToTpyeString(encryptedFile!.mimeType);
    }

    if (replaceMessageId != null) {
      groupMessageUpdateCallBack?.call(messageDB, replaceMessageId);
    } else {
      groupMessageCallBack?.call(messageDB);
    }

    await Messages.saveMessageToDB(messageDB);
    EventCache.sharedInstance.receiveEvent(event, '');

    if (local) {
      if (!completer.isCompleted) {
        completer.complete(OKEvent(event.id, true, ''));
      }
    } else {
      OKEvent ok = await sendToGroup(privateGroupId, event);
      messageDB.status = ok.status ? 1 : 2;
      groupMessageUpdateCallBack?.call(messageDB, messageDB.messageId);
      await Messages.saveMessageToDB(messageDB, conflictAlgorithm: ConflictAlgorithm.replace);
      if (!completer.isCompleted) completer.complete(ok);
    }

    return completer.future;
  }
}
