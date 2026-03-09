import 'dart:async';
import 'dart:convert';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:sqflite_sqlcipher/sqlite_api.dart';

typedef GroupsUpdatedCallBack = void Function();
typedef GroupMessageCallBack = void Function(MessageDBISAR);
typedef GroupMessageUpdateCallBack = void Function(MessageDBISAR, String);
typedef SendMessageCallBack = void Function();

class Groups {
  /// singleton
  Groups._internal();
  factory Groups() => sharedInstance;
  static final Groups sharedInstance = Groups._internal();

  static final String identifier = 'Chat-Groups';
  // {relay1:subscriptionID1, relay2:subscriptionID2, ...}
  String groupMessageSubscription = '';

  // memory storage
  String pubkey = '';
  String privkey = '';
  Map<String, ValueNotifier<GroupDBISAR>> groups = {};
  Map<String, ValueNotifier<GroupDBISAR>> myGroups = {};

  List<Event> mlsGroupEventCache = [];

  Map<String, List<String>> currentGroupRelays = {};
  Map<String, bool> offlineGroupMessageFinish = {};
  OfflineGroupMessageFinishCallBack? offlineGroupMessageFinishCallBack;

  GroupsUpdatedCallBack? myGroupsUpdatedCallBack;
  GroupMessageCallBack? groupMessageCallBack;
  GroupMessageUpdateCallBack? groupMessageUpdateCallBack;

  Future<void> init({GroupsUpdatedCallBack? callBack}) async {
    privkey = Account.sharedInstance.currentPrivkey;
    pubkey = Account.sharedInstance.currentPubkey;
    myGroupsUpdatedCallBack = callBack;

    Account.sharedInstance.groupListUpdateCallback = () async {
      myGroups = _myGroups();
      myGroupsUpdatedCallBack?.call();
    };

    // await initMLS();
    await _loadAllGroupsFromDB();
  }

  /// 0, not in the group, 1, in the group & not joined, 2. joined
  int getInGroupStatus(String groupId) {
    return !checkInGroup(groupId)
        ? 0
        : !checkInMyGroupList(groupId)
            ? 1
            : 2;
  }

  bool checkInGroup(String groupId) {
    return groups[groupId]?.value.members?.contains(pubkey) == true;
  }

  bool checkInMyGroupList(String groupId) {
    return myGroups.containsKey(groupId);
  }

  String _shortGroupId(String groupId) {
    final String start = groupId.substring(0, 6);
    final String end = groupId.substring(groupId.length - 6);
    return '$start:$end';
  }

  Future<void> _loadAllGroupsFromDB() async {
    List<GroupDBISAR> maps = await DBISAR.sharedInstance.isar.groupDBISARs.where().findAll();
    for (GroupDBISAR e in maps) {
      GroupDBISAR groupDB = e.withGrowableLevels();
      if (groupDB.name.isEmpty) groupDB.name = _shortGroupId(groupDB.privateGroupId);
      groups[groupDB.privateGroupId] = ValueNotifier(groupDB);
    }
    myGroups = _myGroups();
  }

  Map<String, ValueNotifier<GroupDBISAR>> _myGroups() {
    Map<String, ValueNotifier<GroupDBISAR>> result = {};
    UserDBISAR? me = Account.sharedInstance.me;
    if (me != null && me.groupsList != null && me.groupsList!.isNotEmpty) {
      List<String> groupList = me.groupsList!;
      for (String groupId in groupList) {
        if (!groups.containsKey(groupId)) {
          groups[groupId] = ValueNotifier(GroupDBISAR(groupId: groupId));
        }
        result[groupId] = groups[groupId]!;
      }
    }
    return result;
  }

  Future<void> _handleGroupCreation(Event event) async {
    if (!groups.containsKey(event.id) ||
        (groups.containsKey(event.id) && groups[event.id]?.value.owner != event.pubkey)) {
      Channel group = Nip28.getChannelCreation(event);
      GroupDBISAR groupDB = _channelToGroupDB(group, event.createdAt);
      await syncGroupToDB(groupDB);
    }
  }

  Future<void> _handleGroupMetadata(Event event) async {
    Channel group = Nip28.getChannelMetadata(event);
    if (groups.containsKey(group.channelId) &&
        groups[group.channelId]?.value.owner.isNotEmpty == true &&
        groups[group.channelId]?.value.owner != group.owner) {
      return;
    }
    GroupDBISAR groupDB = _channelToGroupDB(group, event.createdAt);
    await syncGroupToDB(groupDB);
  }

  Future<void> _handleGroupMessage(Event event) async {
    ChannelMessage groupMessage = Nip28.getChannelMessage(event);
    String subType =
        groupMessage.actionsType != null ? Nip28.actionToType(groupMessage.actionsType!) : '';
    GroupDBISAR? groupDB = myGroups[groupMessage.channelId]?.value;
    if (groupDB == null) return;
    switch (subType) {
      case 'invite':
        break;
      case 'request':
        if (groupDB.owner != pubkey && groupDB.members?.contains(groupMessage.sender) == false) {
          return;
        }
        break;
      case 'add':
      case 'remove':
      case 'updateName':
      case 'updatePinned':
        if (groupDB.owner != groupMessage.sender) return;
        break;
      case 'join':
      case 'leave':
      default:
        if (groupDB.members?.contains(groupMessage.sender) == false) return;
    }

    MessageDBISAR messageDB = MessageDBISAR(
        messageId: event.id,
        sender: groupMessage.sender,
        receiver: '',
        groupId: groupMessage.channelId,
        kind: event.kind,
        tags: jsonEncode(event.tags),
        content: groupMessage.content,
        replyId: groupMessage.thread.reply?.eventId ?? '',
        createTime: event.createdAt,
        plaintEvent: jsonEncode(event),
        chatType: 1,
        subType: subType);
    var map = await MessageDBISAR.decodeContent(groupMessage.content);
    messageDB.decryptContent = map['content'];
    messageDB.type = map['contentType'];
    messageDB.decryptSecret = map['decryptSecret'];
    await Messages.saveMessageToDB(messageDB);
    groupMessageCallBack?.call(messageDB);
  }

  Future<void> receiveGroupEvents(Event event, String relay, String giftWrappedEventId) async {
    MessageDBISAR messageDB = MessageDBISAR(messageId: giftWrappedEventId);
    await Messages.saveMessageToDB(messageDB);
    switch (event.kind) {
      case 40:
        _handleGroupCreation(event);
        break;
      case 41:
        _handleGroupMetadata(event);
        break;
      case 42:
        _handleGroupMessage(event);
        break;
      default:
        LogUtils.v(() => 'unknown event: ${event.kind}');
        break;
    }
  }

  GroupDBISAR _channelToGroupDB(Channel group, int updateTime) {
    GroupDBISAR? groupDB = groups[group.channelId]?.value;
    if (groupDB != null && groupDB.updateTime < updateTime) {
      groupDB.name = group.name;
      groupDB.about = group.about;
      groupDB.picture = group.picture;
      groupDB.pinned = [group.pinned ?? ''];
      groupDB.owner = group.owner;
      groupDB.relay = group.relay;
      groupDB.members = group.members;
      groupDB.updateTime = updateTime;
    }
    groupDB ??= GroupDBISAR(
        groupId: group.channelId,
        owner: group.owner,
        name: group.name,
        members: group.members,
        pinned: [group.pinned ?? ''],
        about: group.about,
        picture: group.picture,
        relay: group.relay,
        updateTime: updateTime);
    return groupDB;
  }

  Future<void> syncGroupToDB(GroupDBISAR groupDB) async {
    String groupId = groupDB.privateGroupId;

    groups[groupId]?.value = groupDB;
    groups[groupId]?.notifyListeners();
    groups.putIfAbsent(groupId, () => ValueNotifier(groupDB));

    if (myGroups.containsKey(groupId)) {
      myGroups[groupId]?.value = groupDB;
    }

    await saveGroupToDB(groupDB);
  }

  static Future<void> saveGroupToDB(GroupDBISAR groupDB) async {
    await DBISAR.sharedInstance.saveToDB(groupDB);
  }

  Future<void> syncMyGroupListToDB() async {
    List<String> list = myGroups.keys.toList();
    UserDBISAR? me = Account.sharedInstance.me;
    me!.groupsList = list;
    await Account.sharedInstance.syncMe();
  }

  ValueNotifier<GroupDBISAR> getPrivateGroupNotifier(String groupId) {
    if (groups.containsKey(groupId)) return groups[groupId]!;
    groups[groupId] = ValueNotifier(GroupDBISAR(groupId: groupId));
    return groups[groupId]!;
  }

  Future<OKEvent> syncMyGroupListToRelay() async {
    Completer<OKEvent> completer = Completer<OKEvent>();
    List<String> list = myGroups.keys.toList();
    Event event = await Nip51.createCategorizedBookmarks(identifier, [], list, privkey, pubkey);
    Connect.sharedInstance.sendEvent(event, sendCallBack: (ok, relay) {
      if (ok.status) {
        Account.sharedInstance.me!.lastGroupsListUpdatedTime = event.createdAt;
        syncMyGroupListToDB();
      }
      if (!completer.isCompleted) completer.complete(ok);
    });
    return completer.future;
  }

  List<GroupDBISAR>? fuzzySearch(String keyword) {
    if (keyword.isNotEmpty) {
      RegExp regex = RegExp(keyword, caseSensitive: false);
      List<GroupDBISAR> filteredFriends = myGroups.values
          .where((channel) =>
              regex.hasMatch(channel.value.name) || regex.hasMatch(channel.value.about ?? ''))
          .map((e) => e.value)
          .toList();
      return filteredFriends;
    }
    return null;
  }

  List<String> getAllUnMuteGroups() {
    return myGroups.entries.where((e) => e.value.value.mute == false).map((e) => e.key).toList();
  }

  Future<Event?> getSendGroupMessageEvent(String groupId, MessageType type, String content,
      {String? source,
      String? groupRelay,
      String? replyMessage,
      String? replyMessageRelay,
      String? replyUser,
      String? replyUserRelay,
      String? actionsType,
      String? decryptSecret}) async {
    Event event = await Nip28.sendChannelMessage(
        groupId, MessageDBISAR.getContent(type, content, source), pubkey, privkey,
        channelRelay: groupRelay,
        replyMessage: replyMessage,
        replyMessageRelay: replyMessageRelay,
        replyUser: replyUser,
        replyUserRelay: replyUserRelay,
        subContent: MessageDBISAR.getSubContent(type, content),
        actionsType: actionsType);
    return event;
  }

  Future<OKEvent> sendGroupMessage(String privateGroupId, MessageType type, String content,
      {String? source,
      String? groupRelay,
      String? replyMessage,
      String? replyMessageRelay,
      String? replyUser,
      String? replyUserRelay,
      Event? event,
      String? actionsType,
      bool local = false,
      List<String>? inviteUsers,
      String? decryptSecret}) async {
    Completer<OKEvent> completer = Completer<OKEvent>();
    GroupDBISAR? groupDB = groups[privateGroupId]?.value;
    if (groupDB == null) return OKEvent(privateGroupId, false, 'group not exit');
    event ??= await Nip28.sendChannelMessage(
        groupDB.groupId, MessageDBISAR.getContent(type, content, source), pubkey, privkey,
        channelRelay: groupRelay,
        replyMessage: replyMessage,
        replyMessageRelay: replyMessageRelay,
        replyUser: replyUser,
        replyUserRelay: replyUserRelay,
        subContent: MessageDBISAR.getSubContent(type, content),
        actionsType: actionsType);

    MessageDBISAR messageDB = MessageDBISAR(
        messageId: event.id,
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
        subType: actionsType ?? '',
        decryptSecret: decryptSecret);
    groupMessageCallBack?.call(messageDB);
    await Messages.saveMessageToDB(messageDB);

    if (local) {
      if (!completer.isCompleted) {
        completer.complete(OKEvent(event.id, true, ''));
      }
    } else {
      OKEvent ok;
      switch (actionsType) {
        case 'invite':
          ok = await sendMessageEvent(inviteUsers, event);
          break;
        case 'request':
          ok = await sendToOwner(privateGroupId, event);
          break;
        case 'join':
        case 'add':
        case 'leave':
        case 'remove':
        case 'updateName':
        case 'updatePinned':
        default:
          ok = await sendToGroup(privateGroupId, event);
      }
      messageDB.status = ok.status ? 1 : 2;
      await Messages.saveMessageToDB(messageDB, conflictAlgorithm: ConflictAlgorithm.replace);
      if (!completer.isCompleted) completer.complete(ok);
    }

    return completer.future;
  }

  Future<OKEvent> sendToGroup(String privateGroupId, Event event) async {
    GroupDBISAR? groupDB = groups[privateGroupId]?.value;
    if (groupDB != null) {
      if (groupDB.isMLSGroup) {
        return await sendMessageToMLSGroup(groupDB, event);
      } else {
        return await sendMessageEvent(groupDB.members, event);
      }
    } else {
      return OKEvent(event.id, false, 'group not found');
    }
  }

  Future<OKEvent> sendToOwner(String groupId, Event event) async {
    GroupDBISAR? groupDB = groups[groupId]?.value;
    if (groupDB != null) {
      return await sendMessageEvent([groupDB.owner], event);
    } else {
      return OKEvent(event.id, false, 'group not found');
    }
  }

  Future<OKEvent> sendMessageEvent(List<String>? receivers, Event event,
      {SendMessageCallBack? sendMessageCallBack}) async {
    Completer<OKEvent> completer = Completer<OKEvent>();
    if (receivers != null) {
      await Future.forEach(receivers, (receiver) async {
        if (receiver.isNotEmpty) {
          Event? e = await Contacts.sharedInstance.encodeNip17Event(event, receiver);
          if (e != null) {
            UserDBISAR? user = await Account.sharedInstance.getUserInfo(receiver);
            List<String> relays = [
              ...user?.inboxRelayList ?? [],
              ...user?.dmRelayList ?? [],
            ];
            bool hasConnected = false;
            for (var relay in relays) {
              if (Connect.sharedInstance.webSockets[relay]?.connectStatus == 1) {
                hasConnected = true;
                break;
              }
            }
            if (!hasConnected) {
              await Connect.sharedInstance.connectRelays(relays, relayKind: RelayKind.temp);
              for (var relay in relays) {
                if (Connect.sharedInstance.webSockets[relay]?.connectStatus == 1) {
                  hasConnected = true;
                  break;
                }
              }
              if (!hasConnected) {
                relays = [...(Account.sharedInstance.me?.relayList ?? [])];
              }
            }
            Connect.sharedInstance.sendEvent(e, toRelays: relays);
            sendMessageCallBack?.call();
          }
        }
      });
      if (!completer.isCompleted) {
        EventCache.sharedInstance.receiveEvent(event, '');
        completer.complete(OKEvent(event.id, true, ''));
      }
    } else {
      if (!completer.isCompleted) {
        completer.complete(OKEvent(event.id, false, 'no receivers'));
      }
    }
    return completer.future;
  }

  static Future<void> encodeNip17InIsolate(Map<String, dynamic> params) async {
    BackgroundIsolateBinaryMessenger.ensureInitialized(params['token']);
    Event event = await Event.fromJson(params['event']);
    String receiver = params['receiver'] ?? '';
    Event sealedEvent =
        await Nip17.encode(event, receiver, params['pubkey'] ?? '', params['privkey'] ?? '');
    params['sendPort'].send({'receiver': receiver, 'event': sealedEvent.toJson()});
  }

  static String encodeGroup(String groupId, List<String>? relays, String? author) {
    String nevent = Nip19.encodeShareableEntity('nevent', groupId, relays, author, null);
    return Nip21.encode(nevent);
  }

  static Map<String, dynamic>? decodeGroup(String encodedGroup) {
    if (encodedGroup.startsWith('nostr:')) {
      encodedGroup = Nip21.decode(encodedGroup)!;
    }
    if (encodedGroup.startsWith('nevent')) {
      Map result = Nip19.decodeShareableEntity(encodedGroup);
      if (result['prefix'] == 'nevent') {
        return {
          'groupId': result['special'],
          'relays': result['relays'],
          'author': result['author']
        };
      }
    } else if (encodedGroup.startsWith('note')) {
      return {'groupId': Nip19.decodeNote(encodedGroup), 'relays': [], 'author': null};
    }
    return null;
  }
}
