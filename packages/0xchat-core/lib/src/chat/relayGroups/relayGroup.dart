import 'dart:async';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:nostr_core_dart/nostr.dart';

typedef GroupsJoinRequestCallBack = void Function(JoinRequestDBISAR);
typedef GroupsModerationCallBack = void Function(ModerationDBISAR);
typedef GroupsNoteCallBack = void Function(NoteDBISAR);
typedef GroupMetadataUpdatedCallBack = void Function(RelayGroupDBISAR);
typedef OfflineGroupMessageFinishCallBack = void Function();
typedef GroupSearchCallBack = void Function(List<RelayGroupDBISAR>);

class RelayGroup {
  /// singleton
  RelayGroup._internal();
  factory RelayGroup() => sharedInstance;
  static final RelayGroup sharedInstance = RelayGroup._internal();

  String groupMessageSubscription = '';

  // memory storage
  String pubkey = '';
  String privkey = '';
  Map<String, ValueNotifier<RelayGroupDBISAR>> groups = {};
  Map<String, ValueNotifier<RelayGroupDBISAR>> myGroups = {};
  Map<String, bool> offlineGroupMessageFinish = {};
  List<String> groupRelays = [];

  GroupsUpdatedCallBack? myGroupsUpdatedCallBack;
  GroupMetadataUpdatedCallBack? groupMetadataUpdatedCallBack;
  GroupMessageCallBack? groupMessageCallBack;
  GroupMessageUpdateCallBack? groupMessageUpdateCallBack;
  GroupsJoinRequestCallBack? joinRequestCallBack;
  GroupsModerationCallBack? moderationCallBack;
  GroupsNoteCallBack? noteCallBack;
  OfflineGroupMessageFinishCallBack? offlineGroupMessageFinishCallBack;

  Future<void> init({GroupsUpdatedCallBack? callBack}) async {
    privkey = Account.sharedInstance.currentPrivkey;
    pubkey = Account.sharedInstance.currentPubkey;
    myGroupsUpdatedCallBack = callBack;

    Account.sharedInstance.relayGroupListUpdateCallback = () {
      groupListUpdated();
    };
    Connect.sharedInstance.addConnectStatusListener((relay, status, relayKinds) async {
      if (status == 1 && Account.sharedInstance.me != null) {
        if (groupRelays.contains(relay)) {
          _udpateGroupInfos(relay: relay);
          updateGroupSubscription(relay: relay);
        }
      }
    });
    await _loadAllGroupsFromDB();
    updateGroupSubscription();
  }

  /// 0, not in the group, 1, in the group & not joined, 2. joined
  int getInGroupStatus(String groupId) {
    SimpleGroups simpleGroups = getHostAndGroupId(groupId);
    groupId = simpleGroups.groupId;
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

  void groupListUpdated() {
    myGroups = _myGroups();
    myGroupsUpdatedCallBack?.call();
    updateGroupSubscription();
  }

  ValueNotifier<RelayGroupDBISAR> getRelayGroupNotifier(String groupId) {
    if (groups.containsKey(groupId)) return groups[groupId]!;
    groups[groupId] = ValueNotifier(RelayGroupDBISAR(groupId: groupId));
    return groups[groupId]!;
  }

  Future<void> _loadAllGroupsFromDB() async {
    final isar = DBISAR.sharedInstance.isar;
    List<RelayGroupDBISAR> maps = await isar.relayGroupDBISARs.where().findAll();
    for (RelayGroupDBISAR e in maps) {
      RelayGroupDBISAR groupDB = e.withGrowableLevels();
      if (groupDB.groupId.isNotEmpty) {
        if (groupDB.name.isEmpty) groupDB.name = groupDB.groupId;
        groups[groupDB.groupId] = ValueNotifier(groupDB);
      }
    }
    myGroups = _myGroups();
    _udpateGroupInfos();
    myGroupsUpdatedCallBack?.call();
  }

  SimpleGroups getHostAndGroupId(String input) {
    RegExp exp = RegExp(r"(.*?)'(.*)");
    Match? match = exp.firstMatch(input);

    if (match != null) {
      String? host = match.group(1);
      if (host?.isNotEmpty == true) {
        if (!host!.contains('wss://') && !host.contains('ws://')) {
          host = 'wss://$host';
        }
      }
      String? groupId = match.group(2);
      return SimpleGroups(groupId ?? '', host ?? '');
    } else {
      return SimpleGroups(input, '');
    }
  }

  Map<String, ValueNotifier<RelayGroupDBISAR>> _myGroups() {
    Map<String, ValueNotifier<RelayGroupDBISAR>> result = {};
    UserDBISAR? me = Account.sharedInstance.me;
    if (me != null && me.relayGroupsList != null && me.relayGroupsList!.isNotEmpty) {
      List<String> groupList = me.relayGroupsList!;
      groupRelays.clear();
      for (String id in groupList) {
        SimpleGroups simpleGroups = getHostAndGroupId(id);
        String groupId = simpleGroups.groupId;
        if (groupId.isEmpty) continue;
        if (!groups.containsKey(groupId)) {
          groups[groupId] =
              ValueNotifier(RelayGroupDBISAR(groupId: groupId, relay: simpleGroups.relay));
          getGroupMetadataFromRelay(groupId);
          loadGroupMessages(groupId, null, null, 200);
        }
        result[groupId] = groups[groupId]!;
        if (!groupRelays.contains(groups[groupId]!.value.relay)) {
          groupRelays.add(groups[groupId]!.value.relay);
        }
      }
      connectToRelays(groupRelays);
    }
    return result;
  }

  void connectToRelays(List<String> groupRelays) {
    for (var relay in groupRelays) {
      Connect.sharedInstance.connect(relay, relayKind: RelayKind.relayGroup);
    }
  }

  Future<void> _udpateGroupInfos({String? relay}) async {
    if (myGroups.isEmpty) return;
    List<ValueNotifier<RelayGroupDBISAR>> values = List.from(myGroups.values);
    for (var value in values) {
      var group = value.value;
      if (group.lastUpdatedTime == 0 && (relay == null || group.relay == relay)) {
        RelayGroupDBISAR? relayGroupDB = await getGroupMetadataFromRelay(group.groupId);
        if (relayGroupDB != null) myGroups[group.groupId] = ValueNotifier(relayGroupDB);
      }
    }
  }

  void updateGroupSubscription({String? relay}) {
    if (myGroups.isEmpty) {
      offlineGroupMessageFinishCallBack?.call();
      if (!Messages.sharedInstance.groupMessageCompleter.isCompleted) {
        Messages.sharedInstance.groupMessageCompleter.complete();
      }
      return;
    }
    if (groupMessageSubscription.isNotEmpty) {
      Connect.sharedInstance.closeRequests(groupMessageSubscription, relay: relay);
    }

    Map<String, List<Filter>> subscriptions = {};
    List<String> groupList = [];
    for (var g in myGroups.values) {
      if (g.value.members?.contains(pubkey) == true) groupList.add(g.value.groupId);
    }
    if(groupList.isEmpty) return;
    if (relay == null) {
      for (String relayURL in groupRelays) {
        int groupMessageUntil = Relays.sharedInstance.getGroupMessageUntil(relayURL);
        Filter f = Filter(
            h: groupList,
            kinds: [
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
              9008,
              9021,
              9022,
              9735,
              // 39000,
              // 39001,
              // 39002
            ],
            since: (groupMessageUntil + 1));
        subscriptions[relayURL] = [f];
      }
    } else {
      int groupMessageUntil = Relays.sharedInstance.getGroupMessageUntil(relay);
      Filter f = Filter(
          h: groupList,
          kinds: [
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
            9008,
            9021,
            9022,
            9735,
            // 39000,
            // 39001,
            // 39002
          ],
          since: (groupMessageUntil + 1));
      subscriptions[relay] = [f];
    }

    groupMessageSubscription = Connect.sharedInstance.addSubscriptions(subscriptions,
        closeSubscription: false, eventCallBack: (event, relay) async {
      _updateGroupMessageTime(event.createdAt, relay);
      handleGroupEvents(event, relay);
    }, eoseCallBack: (requestId, ok, relay, unCompletedRelays) async {
      offlineGroupMessageFinish[relay] = true;
      if (ok.status) {
        _updateGroupMessageTime(currentUnixTimestampSeconds() - 1, relay);
      } else if (Nip29.restricted(ok.message)) {
        await Future.forEach(groupList, (g) async {
          await getGroupMetadataFromRelay(g);
        });
        updateGroupSubscription(relay: relay);
      }
      if (unCompletedRelays.isEmpty) {
        offlineGroupMessageFinishCallBack?.call();
        if (!Messages.sharedInstance.groupMessageCompleter.isCompleted) {
          Messages.sharedInstance.groupMessageCompleter.complete();
        }
      }
    });
  }

  void handleGroupEvents(Event event, String relay) {
    switch (event.kind) {
      case 7:
        handleGroupReaction(event, relay);
        break;
      case 9:
      case 10:
        handleGroupMessage(event, relay);
        break;
      case 11:
      case 12:
        handleGroupNotes(event, relay);
        break;
      case 9000:
      case 9001:
      case 9002:
      case 9003:
      case 9004:
      case 9005:
      case 9006:
      case 9008:
        handleModeration(event, relay);
        break;
      case 9021:
        handleJoinRequest(event, relay);
        break;
      case 9022:
        handleLeaveGroup(event, relay);
        break;
      case 9735:
        handleGroupZaps(event, relay);
        break;
      case 39000:
        handleGroupMetadata(event, relay);
        break;
      case 39001:
        handleGroupAdmins(event, relay);
        break;
      case 39002:
        handleGroupMembers(event, relay);
        break;
      default:
        LogUtils.v(() => 'relaygroup unhandled message ${event.toJson()}');
        break;
    }
  }

  void _updateGroupMessageTime(int eventTime, String relay) {
    if (Relays.sharedInstance.relays.containsKey(relay)) {
      Relays.sharedInstance.setGroupMessageUntil(eventTime, relay);
      Relays.sharedInstance.setGroupMessageSince(eventTime, relay);
    } else {
      Relays.sharedInstance.relays[relay] =
          RelayDBISAR(url: relay, groupMessageUntil: eventTime, groupMessageSince: eventTime);
    }
    if (offlineGroupMessageFinish[relay] == true) {
      Relays.sharedInstance.syncRelaysToDB(r: relay);
    }
  }

  Future<void> saveGroupToDB(RelayGroupDBISAR groupDB) async {
    await DBISAR.sharedInstance.saveToDB(groupDB);
  }

  Future<void> deleteGroupFromDB(String groupId) async {
    await DBISAR.sharedInstance.isar.writeTxn(() async {
      await DBISAR.sharedInstance.isar.relayGroupDBISARs
          .where()
          .groupIdEqualTo(groupId)
          .deleteAll();
    });
  }

  void _setGroup(RelayGroupDBISAR groupDB){
    if (groups.containsKey(groupDB.groupId)) {
      groups[groupDB.groupId]?.value = groupDB;
    } else {
      groups[groupDB.groupId] = ValueNotifier(groupDB);
    }
    if (myGroups.containsKey(groupDB.groupId)) {
      myGroups[groupDB.groupId]?.value = groupDB;
    }
  }

  Future<void> syncGroupToDB(RelayGroupDBISAR groupDB) async {
    _setGroup(groupDB);
    await saveGroupToDB(groupDB);
  }

  Future<void> _syncMyGroupListToDB() async {
    UserDBISAR? me = Account.sharedInstance.me;
    me!.relayGroupsList =
        myGroups.values.map((e) => '${e.value.relay}\'${e.value.groupId}').toList();
    await Account.sharedInstance.syncMe();
    groupListUpdated();
  }

  Future<OKEvent> syncMyGroupListToRelay() async {
    Completer<OKEvent> completer = Completer<OKEvent>();
    List<SimpleGroups> list = [];
    for (var group in myGroups.values) {
      list.add(SimpleGroups(group.value.groupId, group.value.relay));
    }
    Event event = await Nip51.createSimpleGroupList([], list, privkey, pubkey);
    Connect.sharedInstance.sendEvent(event, sendCallBack: (ok, relay) {
      if (ok.status) {
        Account.sharedInstance.me!.lastGroupsListUpdatedTime = event.createdAt;
        _syncMyGroupListToDB();
      }
      if (!completer.isCompleted) completer.complete(ok);
    });
    return completer.future;
  }

  bool isWebSocketUrl(String url) {
    final regex = RegExp(r'^(ws|wss)://');
    return regex.hasMatch(url);
  }

  bool isGroupIdentifier(String url) {
    return url.contains('\'');
  }

  Future<List<RelayGroupDBISAR>?> fuzzySearch(String keyword) async {
    if (keyword.isNotEmpty) {
      if (isWebSocketUrl(keyword)) {
        return await searchGroupsMetadataFromRelays([keyword], null);
      }
      if (isGroupIdentifier(keyword)) {
        RelayGroupDBISAR? group = await searchGroupsMetadataWithGroupID(keyword, null);
        if (group != null) return [group];
      }
      RegExp regex = RegExp(keyword, caseSensitive: false);
      List<RelayGroupDBISAR> result = groups.values
          .where((group) => regex.hasMatch(group.value.name) || regex.hasMatch(group.value.about))
          .map((e) => e.value)
          .toList();
      return result;
    }
    return null;
  }

  Future<List<String>> getPrevious(String groupId) async {
    List<String> previous = [];
    final isar = DBISAR.sharedInstance.isar;
    List<MessageDBISAR> messages = await isar.messageDBISARs
        .filter()
        .groupIdEqualTo(groupId)
        .sortByCreateTimeDesc()
        .limit(3)
        .findAll();
    for (var message in messages) {
      previous.add(message.messageId.substring(0, 8));
    }
    return previous;
  }

  List<String> getAllUnMuteGroups() {
    return myGroups.entries
        .where((e) => e.value.value.mute == false)
        .map((e) => e.value.value.identifier)
        .toList();
  }

  String? encodeGroup(String groupId) {
    RelayGroupDBISAR? groupDB = groups[groupId]?.value;
    if (groupDB == null) return null;
    String nevent =
        Nip19.encodeShareableEntity('naddr', groupId, [groupDB.relay], groupDB.author, 39000);
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
          'author': result['author'],
          'kind': result['kind']
        };
      }
    } else if (encodedGroup.startsWith('note')) {
      return {'groupId': Nip19.decodeNote(encodedGroup), 'relays': [], 'author': null};
    }
    return null;
  }
}
