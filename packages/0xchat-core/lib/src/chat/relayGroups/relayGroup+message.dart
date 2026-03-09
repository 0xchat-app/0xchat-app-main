import 'dart:async';
import 'dart:convert';

import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:sqflite_sqlcipher/sqlite_api.dart';

extension EMessage on RelayGroup {
  Future<void> handleGroupMessage(Event event, String relay) async {
    if (Contacts.sharedInstance.inBlockList(event.pubkey)) return;
    GroupMessage groupMessage = Nip29.decodeGroupMessage(event);
    RelayGroupDBISAR? groupDB = groups[groupMessage.groupId]?.value;
    if (groupDB == null) return;

    // Extract emoji tags (NIP-30)
    Map<String, String> emojiMap = {};
    for (var tag in event.tags) {
      if (tag.isNotEmpty && tag[0] == 'emoji' && tag.length >= 3) {
        emojiMap[tag[1]] = tag[2];
      }
    }
    String? emojiJson;
    if (emojiMap.isNotEmpty) {
      emojiJson = jsonEncode(emojiMap);
    }

    MessageDBISAR messageDB = MessageDBISAR(
        messageId: event.id,
        sender: groupMessage.pubkey,
        receiver: '',
        groupId: groupMessage.groupId,
        kind: event.kind,
        tags: jsonEncode(event.tags),
        content: groupMessage.content,
        replyId: groupMessage.replyId ?? '',
        createTime: event.createdAt,
        plaintEvent: jsonEncode(event),
        chatType: 4,
        emojiShortcodesJson: emojiJson);
    var map = await MessageDBISAR.decodeContent(groupMessage.content);
    messageDB.decryptContent = map['content'];
    messageDB.type = map['contentType'];
    messageDB.decryptSecret = map['decryptSecret'];
    await Messages.saveMessageToDB(messageDB);
    groupMessageCallBack?.call(messageDB);
  }

  Future<void> handleGroupReaction(Event event, String relay) async {
    await Messages.sharedInstance.handleReactionEvent(event);
  }

  Future<void> handleGroupZaps(Event event, String relay) async {
    await Messages.sharedInstance.handleZapRecordEvent(event);
  }

  Future<Event?> getSendGroupMessageEvent(
      String id, MessageType type, String content, List<String> previous,
      {String? source,
      String? replyEvent,
      List<String>? replyUsers,
      Event? event,
      bool local = false,
      String? decryptSecret}) async {
    Event event = await Nip29.encodeGroupMessageReply(
        id, MessageDBISAR.getContent(type, content, source), previous, pubkey, privkey,
        replyUser: replyUsers?.firstOrNull,
        replyEvent: replyEvent,
        subContent: MessageDBISAR.getSubContent(type, content));
    return event;
  }

  Future<OKEvent> sendGroupMessage(
      String groupId, MessageType type, String content, List<String> previous,
      {String? source,
      String? replyEvent,
      List<String>? replyUsers,
      Event? event,
      bool local = false,
      String? decryptSecret,
      int createAt = 0,
      String? replaceMessageId}) async {
    Completer<OKEvent> completer = Completer<OKEvent>();
    RelayGroupDBISAR? groupDB = groups[groupId]?.value;
    if (groupDB == null) return OKEvent(groupId, false, 'group not exit');
    event ??= await Nip29.encodeGroupMessageReply(
        groupId, MessageDBISAR.getContent(type, content, source), previous, pubkey, privkey,
        replyEvent: replyEvent,
        replyUser: replyUsers?.firstOrNull,
        subContent: MessageDBISAR.getSubContent(type, content),
        createAt: createAt);

    late MessageDBISAR messageDB;
    if (replaceMessageId != null) {
      final replaceMessageDB = await Messages.sharedInstance.loadMessageDBFromDB(replaceMessageId);
      if (replaceMessageDB == null) {
        return Future.value(OKEvent(
          event.innerEvent?.id ?? event.id,
          false,
          'The message to be replaced was not found',
        ));
      }
      replaceMessageDB.messageId = event.id;
      replaceMessageDB.content = event.content;
      messageDB = replaceMessageDB;
    } else {
      messageDB = MessageDBISAR(
          messageId: event.id,
          sender: event.pubkey,
          receiver: '',
          groupId: groupId,
          kind: event.kind,
          tags: jsonEncode(event.tags),
          replyId: replyEvent ?? '',
          content: event.content,
          decryptContent: content,
          type: MessageDBISAR.messageTypeToString(type),
          createTime: event.createdAt,
          status: 0,
          plaintEvent: jsonEncode(event),
          chatType: 4,
          decryptSecret: decryptSecret);
    }
    var map = await MessageDBISAR.decodeContent(
        MessageDBISAR.getSubContent(type, content) ?? event.content);
    messageDB.decryptContent = map['content'];
    messageDB.type = map['contentType'];

    if (replaceMessageId != null) {
      groupMessageUpdateCallBack?.call(messageDB, replaceMessageId);
    } else {
      groupMessageCallBack?.call(messageDB);
    }

    await Messages.saveMessageToDB(messageDB);

    if (local) {
      if (!completer.isCompleted) {
        completer.complete(OKEvent(event.id, true, ''));
      }
    } else {
      Connect.sharedInstance.sendEvent(event, toRelays: [groupDB.relay],
          sendCallBack: (ok, relay) async {
        messageDB.status = ok.status ? 1 : 2;
        groupMessageUpdateCallBack?.call(messageDB, messageDB.messageId);
        await Messages.saveMessageToDB(messageDB, conflictAlgorithm: ConflictAlgorithm.replace);
        if (!completer.isCompleted) completer.complete(ok);
      });
    }
    return completer.future;
  }

  Future<OKEvent> sendToGroup(String groupId, Event event) async {
    RelayGroupDBISAR? groupDB = myGroups[groupId]?.value;
    if (groupDB != null) {
      Completer<OKEvent> completer = Completer<OKEvent>();
      Connect.sharedInstance.sendEvent(event, toRelays: [groupDB.relay],
          sendCallBack: (ok, relay) async {
        if (!completer.isCompleted) completer.complete(ok);
      });
      return completer.future;
    } else {
      return OKEvent(event.id, false, 'relay group not found');
    }
  }

  Future<void> loadGroupMessages(String groupId, int? since, int? until, int? limit) async {
    RelayGroupDBISAR? groupDB = groups[groupId]?.value;
    if (groupDB == null || groupDB.relay.isEmpty) return;
    if (groupDB.relay.isNotEmpty) {
      await Connect.sharedInstance.connectRelays([groupDB.relay], relayKind: RelayKind.temp);
    }
    Filter f = Filter(h: [
      groupDB.groupId
    ], kinds: [
      7,
      9,
      10,
      11,
      12,
      9000,
      9001,
      9002,
      9003,
      9004,
      9005,
      9006,
      9021,
      9735,
    ], limit: limit, until: until, since: since);
    Connect.sharedInstance.addSubscription([f], relays: [groupDB.relay],
        eventCallBack: (event, relay) async {
      handleGroupEvents(event, relay);
    });
  }
}
