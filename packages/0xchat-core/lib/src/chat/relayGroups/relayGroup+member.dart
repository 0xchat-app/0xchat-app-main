import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';

extension EMember on RelayGroup {
  Future<RelayGroupDBISAR?> createGroup(String relay,
      {String name = '', bool closed = false, String picture = '', String about = ''}) async {
    // if (relay == 'wss://groups.fiatjaf.com') {
    //   return await createGroup2(relay,
    //       name: name, closed: closed, picture: picture, about: about);
    // }

    await Connect.sharedInstance.connectRelays([relay], relayKind: RelayKind.relayGroup);
    Completer<RelayGroupDBISAR?> completer = Completer<RelayGroupDBISAR?>();
    String groupId = generate64RandomHexChars();
    Event event = await Nip29.encodeCreateGroup(groupId, pubkey, privkey);
    Connect.sharedInstance.sendEvent(event, toRelays: [relay], sendCallBack: (ok, relay) async {
      if (ok.status) {
        RelayGroupDBISAR relayGroupDB = RelayGroupDBISAR(
            groupId: groupId,
            relay: relay,
            author: pubkey,
            members: [pubkey],
            adminsString: RelayGroupDB.groupAdminsToString(
                [GroupAdmin(pubkey, 'Admin', GroupActionKind.all())]),
            closed: closed,
            private: closed,
            name: name,
            picture: picture,
            about: about,
            lastUpdatedTime: event.createdAt);
        myGroups[groupId] = ValueNotifier(relayGroupDB) ;
        await syncGroupToDB(relayGroupDB);
        await editMetadata(groupId, name, about, picture, closed, closed, '');
        syncMyGroupListToRelay();
        if (!completer.isCompleted) completer.complete(relayGroupDB);
      } else {
        if (!completer.isCompleted) completer.complete(null);
      }
    });
    return completer.future;
  }

  Future<RelayGroupDBISAR?> createGroup2(String relay,
      {String name = '', bool closed = false, String picture = '', String about = ''}) async {
    Completer<RelayGroupDBISAR?> completer = Completer<RelayGroupDBISAR?>();
    var uri = Uri.parse(relay);
    var hostWithPort = uri.hasPort ? '${uri.host}:${uri.port}' : uri.host;
    final url = Uri.parse('https://$hostWithPort/create');
    final body = {
      'pubkey': pubkey,
      'name': name,
    };
    final response = await http.post(url, body: body);
    if (response.statusCode == 200) {
      if (!completer.isCompleted) {
        final regex = RegExp(r'naddr[0-9a-zA-Z]+');
        final match = regex.firstMatch(response.body);
        if (match != null) {
          final naddr = Nip19.decodeShareableEntity(match.group(0)!);
          String groupId = naddr['special'];
          String relay = naddr['relays']?.first;
          String author = naddr['author'];
          RelayGroupDBISAR relayGroupDB = RelayGroupDBISAR(
              groupId: groupId,
              relay: relay,
              author: author,
              members: [author],
              adminsString: RelayGroupDB.groupAdminsToString(
                  [GroupAdmin(author, 'Admin', GroupActionKind.all())]),
              closed: closed,
              private: closed,
              name: name,
              picture: picture,
              about: about,
              lastUpdatedTime: currentUnixTimestampSeconds());
          myGroups[groupId] = ValueNotifier(relayGroupDB);
          await syncGroupToDB(relayGroupDB);
          await editMetadata(groupId, name, about, picture, closed, closed, '');
          syncMyGroupListToRelay();
          if (!completer.isCompleted) completer.complete(relayGroupDB);
        } else {
          if (!completer.isCompleted) completer.complete(null);
        }
      }
    } else {
      if (!completer.isCompleted) completer.complete(null);
    }
    return completer.future;
  }

  Future<OKEvent> leaveGroup(String groupId, String reason) async {
    RelayGroupDBISAR? groupDB = myGroups[groupId]?.value;
    if (groupDB == null) return OKEvent(groupId, false, 'group not exit');
    OKEvent ok = await sendLeaveRequest(groupId, reason);
    if (ok.status) {
      groupDB.members?.remove(pubkey);
      syncGroupToDB(groupDB);
    }
    myGroups.remove(groupId);
    return await syncMyGroupListToRelay();
  }

  Future<OKEvent> sendLeaveRequest(String groupId, String content) async {
    RelayGroupDBISAR? groupDB = myGroups[groupId]?.value;
    if (groupDB == null || groupDB.relay.isEmpty) return OKEvent(groupId, false, 'group not found');
    Completer<OKEvent> completer = Completer<OKEvent>();
    Event event = await Nip29.encodeLeaveRequest(groupId, content, pubkey, privkey);
    Connect.sharedInstance.sendEvent(event, toRelays: [groupDB.relay],
        sendCallBack: (ok, relay) async {
      if (!completer.isCompleted) completer.complete(ok);
    });
    return completer.future;
  }

  Future<OKEvent> joinGroup(String id, String content) async {
    SimpleGroups simpleGroups = getHostAndGroupId(id);
    String groupId = simpleGroups.groupId;
    if (groups.containsKey(groupId) && !myGroups.containsKey(groupId)) {
      myGroups[groupId] = groups[groupId]!;
      OKEvent okEvent = await syncMyGroupListToRelay();
      return okEvent;
    }
    return OKEvent(groupId, false, 'group not found');
  }

  Future<OKEvent> sendJoinRequest(String input, String content) async {
    SimpleGroups simpleGroups = getHostAndGroupId(input);
    String groupId = simpleGroups.groupId;
    String relay = simpleGroups.relay;
    RelayGroupDBISAR? groupDB = groups[groupId]?.value;
    if (groupDB != null) relay = groupDB.relay;
    if (relay.isEmpty) return OKEvent(input, false, 'empty relay');
    if (groupDB == null) {
      groupDB = RelayGroupDBISAR(groupId: groupId, relay: relay);
      groups[groupId] = ValueNotifier(groupDB);
    }
    if (groupDB.lastUpdatedTime > 0 && groupDB.closed == false) {
      //open group, auto join
      groupDB.members ??= [];
      if (!groupDB.members!.contains(pubkey)) {
        groupDB.members!.add(pubkey);
      }
    }
    syncGroupToDB(groupDB);

    if (!myGroups.containsKey(groupId)) {
      myGroups[groupId] = ValueNotifier(groupDB);
      syncMyGroupListToRelay();
    }

    await Connect.sharedInstance.connectRelays([relay], relayKind: RelayKind.relayGroup);
    Completer<OKEvent> completer = Completer<OKEvent>();
    Event event = await Nip29.encodeJoinRequest(groupId, content, pubkey, privkey);
    Connect.sharedInstance.sendEvent(event, toRelays: [relay], sendCallBack: (ok, relay) async {
      if(!ok.status && ok.message == "duplicate: already a member"){
        groupDB!.members ??= [];
        if (!groupDB.members!.contains(pubkey)) {
          groupDB.members!.add(pubkey);
        }
        syncGroupToDB(groupDB);
        if (!myGroups.containsKey(groupId)) {
          myGroups[groupId] = ValueNotifier(groupDB);
          syncMyGroupListToRelay();
        }
      }
      if (!completer.isCompleted) completer.complete(ok);
    });
    return completer.future;
  }

  Future<void> saveModerationToDB(ModerationDBISAR moderationDB) async {
    await DBISAR.sharedInstance.saveToDB(moderationDB);
  }

  Future<void> handleLeaveGroup(Event event, String relay) async {
    String? groupId = Nip29.getGroupIdFromEvent(event);
    if (groupId == null) return;
    UserDBISAR? user = await Account.sharedInstance.getUserInfo(event.pubkey);
    String content = '${user?.name} left the group';

    RelayGroupDBISAR? groupDB = groups[groupId]?.value;
    if (groupDB != null) {
      groupDB.members ??= [];
      if (groupDB.members!.contains(event.pubkey)) {
        groupDB.members!.remove(event.pubkey);
        syncGroupToDB(groupDB);
      }
    }
    sendGroupMessage(groupId, MessageType.system, content, [],
        local: true, createAt: event.createdAt);
  }

  Future<void> handleModeration(Event event, String relay) async {
    GroupModeration moderation = Nip29.decodeModeration(event);
    ModerationDBISAR db = ModerationDBISAR.toModerationDB(moderation);
    await saveModerationToDB(db);
    String content = '';
    Map<String, UserDBISAR> users = await Account.sharedInstance.getUserInfos(moderation.users);
    switch (moderation.actionKind) {
      case GroupActionKind.addUser:
        for (var user in users.values) {
          content = '${user.name} $content ';
        }
        content = '${content}joined the group';

        RelayGroupDBISAR? groupDB = groups[db.groupId]?.value;
        if (groupDB != null) {
          groupDB.members ??= [];
          if (!groupDB.members!.contains(pubkey) && moderation.users.contains(pubkey)) {
            groupDB.members!.add(pubkey);
            syncGroupToDB(groupDB);
          }
          else{
            return;
          }
        }
        break;
      case GroupActionKind.removeUser:
        // for (var user in users.values) {
        //   content = '${user.name} $content ';
        // }
        // content = 'Admin remove ${content}from the group';

        RelayGroupDBISAR? groupDB = groups[db.groupId]?.value;
        if (groupDB != null) {
          groupDB.members ??= [];
          if (groupDB.members!.contains(pubkey) && moderation.users.contains(pubkey)) {
            groupDB.members!.remove(pubkey);
            syncGroupToDB(groupDB);
          }
        }
        return;
      case GroupActionKind.editMetadata:
        await handleGroupMetadataFromModeration(moderation, relay);
        return;
      case GroupActionKind.addPermission:
      case GroupActionKind.removePermission:
        return;
      case GroupActionKind.deleteEvent:
        deleteMessageFromLocal(moderation.eventId);
        deleteNoteFromLocal(moderation.eventId);
        return;
      case GroupActionKind.editGroupStatus:
        String private = moderation.private ? 'PRIVATE' : 'PUBLIC';
        String closed = moderation.closed ? 'CLOSED' : 'OPEN';
        content = 'Admin changed group status to $closed, $private';
        break;
      case GroupActionKind.deleteGroup:
        content = 'Admin deleted the group';
        break;
      default:
        return;
    }
    sendGroupMessage(moderation.groupId, MessageType.system, content, [],
        local: true, createAt: event.createdAt);
    moderationCallBack?.call(db);
  }

  Future<void> muteGroup(String groupId) async {
    _setMuteGroup(groupId, true);
  }

  Future<void> unMuteGroup(String groupId) async {
    _setMuteGroup(groupId, false);
  }

  Future<void> _setMuteGroup(String groupId, bool mute) async {
    if (myGroups.containsKey(groupId)) {
      RelayGroupDBISAR groupDB = myGroups[groupId]!.value;
      groupDB.mute = mute;
      await syncGroupToDB(groupDB);
    }
  }

  Future<bool> checkInGroupFromRelay(String groupId, String user) async {
    SimpleGroups simpleGroups = getHostAndGroupId(groupId);
    groupId = simpleGroups.groupId;
    String relay = simpleGroups.relay;
    RelayGroupDBISAR? relayGroupDB = groups[groupId]?.value;
    relayGroupDB ??= RelayGroupDBISAR(groupId: groupId, relay: relay);
    relayGroupDB.members ??= [];
    if(relayGroupDB.relay.isEmpty) return false;
    Filter f = Filter(kinds: [9000, 9001], p: [user], h: [groupId], limit: 1);

    Completer<bool> completer = Completer<bool>();
    Connect.sharedInstance.addSubscription([f], relays: [relayGroupDB.relay],
        eventCallBack: (event, relay) {
      GroupModeration moderation = Nip29.decodeModeration(event);
      if (moderation.actionKind == GroupActionKind.addUser) {
        relayGroupDB!.members?.add(user);
        syncGroupToDB(relayGroupDB);
        if (!completer.isCompleted) completer.complete(true);
      } else if (moderation.actionKind == GroupActionKind.removeUser) {
        relayGroupDB!.members?.remove(user);
        syncGroupToDB(relayGroupDB);
        if (!completer.isCompleted) completer.complete(false);
      }
    }, eoseCallBack: (String requestId, OKEvent ok, String relay, List<String> unCompletedRelays) {
      if (!completer.isCompleted) {
        completer.complete(relayGroupDB!.members?.contains(user));
      }
    });
    return completer.future;
  }
}
