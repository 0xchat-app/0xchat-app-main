import 'dart:convert';

import 'package:chatcore/chat-core.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';

class Relays {
  /// singleton
  Relays._internal();
  factory Relays() => sharedInstance;
  static final Relays sharedInstance = Relays._internal();
  // ALL relays list
  Map<String, RelayDBISAR> relays = {};

  List<String> recommendGlobalRelays = [
    'wss://relay.nostr.band',
    'wss://relay.damus.io',
    'wss://nos.lol',
    'wss://yabu.me',
    'wss://relay.siamstr.com',
  ];

  List<String> recommendGeneralRelays = [
    'wss://relay.0xchat.com',
    'wss://yabu.me',
    'wss://relay.siamstr.com',
    'wss://relay.damus.io',
    'wss://relay.nostr.band',
    'wss://nos.lol',
    'wss://nostr.wine',
    'wss://eden.nostr.land',
    'wss://nostr.data.haus',
    'wss://relay.mostr.pub',
  ];

  List<String> recommendDMRelays = [
    'wss://auth.nostr1.com',
    'wss://relay.0xchat.com',
    'wss://inbox.nostr.wine',
  ];

  List<String> recommendGroupRelays = [
    'wss://groups.0xchat.com',
    'wss://relay.highlighter.com',
    'wss://relay.groups.nip29.com'
  ];

  List<String> recommendSecretChatRelays = [
    'wss://auth.nostr1.com',
    'wss://inbox.nostr.wine',
    'wss://relay.0xchat.com'
  ];

  List<String> recommendSearchRelays = [
    'wss://relay.nostr.band/',
    'wss://search.nos.today/',
    'wss://relay.noswhere.com/',
    'wss://filter.nostr.wine/',
  ];

  Future<void> init({String? circleRelay}) async {
    await Config.sharedInstance.initConfig();
    List<RelayDBISAR> result = await _loadRelaysFromDB() ?? [];
    if (result.isNotEmpty) {
      relays = {for (var item in result) item.url: item};
    }
    if (circleRelay != null) {
      Connect.sharedInstance.connectRelays([circleRelay], relayKind: RelayKind.circleRelay);
      return;
    }
    connectGeneralRelays();
    connectDMRelays();
    connectInboxOutboxRelays();
    connectSearchRelays();
  }

  Future<void> connectGeneralRelays() async {
    List<String> connectedGeneralRelays =
        Connect.sharedInstance.relays(relayKinds: [RelayKind.general]);
    List<String> generalRelays = Account.sharedInstance.me?.relayList ?? [];
    List<String> notInGeneralRelays =
        connectedGeneralRelays.where((relay) => !generalRelays.contains(relay)).toList();
    await Connect.sharedInstance.closeConnects(notInGeneralRelays, RelayKind.general);

    int updatedTime = Account.sharedInstance.me?.lastRelayListUpdatedTime ?? 0;
    if (updatedTime > 0 && generalRelays.isNotEmpty) {
      Connect.sharedInstance.connectRelays(generalRelays, relayKind: RelayKind.general);
    } else {
      // startup relays
      Connect.sharedInstance.connectRelays(recommendGeneralRelays, relayKind: RelayKind.general);
    }
  }

  Future<void> connectDMRelays() async {
    List<String> connectedDMRelays = Connect.sharedInstance.relays(relayKinds: [RelayKind.dm]);
    List<String> dmRelays = Account.sharedInstance.me?.dmRelayList ?? [];
    List<String> notInDMRelays =
        connectedDMRelays.where((relay) => !dmRelays.contains(relay)).toList();
    await Connect.sharedInstance.closeConnects(notInDMRelays, RelayKind.dm);

    Connect.sharedInstance.connectRelays(dmRelays, relayKind: RelayKind.dm);
  }

  Future<void> connectInboxOutboxRelays() async {
    List<String> connectedBoxRelays =
        Connect.sharedInstance.relays(relayKinds: [RelayKind.inbox, RelayKind.outbox]);
    List<String> inbox = Account.sharedInstance.me?.inboxRelayList ?? [];
    List<String> outbox = Account.sharedInstance.me?.outboxRelayList ?? [];
    var relays = [...inbox, ...outbox];
    List<String> notInRelays =
        connectedBoxRelays.where((relay) => !relays.contains(relay)).toList();
    await Connect.sharedInstance.closeConnects(notInRelays, RelayKind.inbox);
    await Connect.sharedInstance.closeConnects(notInRelays, RelayKind.outbox);
    Connect.sharedInstance.connectRelays(relays, relayKind: RelayKind.inbox);
    Connect.sharedInstance.connectRelays(relays, relayKind: RelayKind.outbox);
  }

  Future<void> connectSearchRelays() async {
    List<String> connectedSearchRelays =
        Connect.sharedInstance.relays(relayKinds: [RelayKind.search]);
    List<String> searchRelays = Account.sharedInstance.me?.searchRelayList ?? [];
    
    // Normalize relay URLs (remove trailing slash)
    searchRelays = searchRelays.map((relay) {
      return relay.endsWith('/') ? relay.substring(0, relay.length - 1) : relay;
    }).toList();
    
    // Close search relays that are not in use
    List<String> notInSearchRelays =
        connectedSearchRelays.where((relay) => !searchRelays.contains(relay)).toList();
    await Connect.sharedInstance.closeConnects(notInSearchRelays, RelayKind.search);
    
    // Connect the selected search relays
    if (searchRelays.isNotEmpty) {
      Connect.sharedInstance.connectRelays(searchRelays, relayKind: RelayKind.search);
    } else {
      // If no search relay is selected, connect all recommended search relays as default
      if (recommendSearchRelays.isNotEmpty) {
        List<String> defaultSearchRelays = recommendSearchRelays.map((relay) {
          return relay.endsWith('/') ? relay.substring(0, relay.length - 1) : relay;
        }).toList();
        Connect.sharedInstance.connectRelays(defaultSearchRelays, relayKind: RelayKind.search);
        // Also save them to user's search relay list
        Account.sharedInstance.me?.searchRelayList = defaultSearchRelays;
        Account.sharedInstance.syncMe();
      }
    }
  }

  Future<List<RelayDBISAR>?> _loadRelaysFromDB() async {
    final isar = DBISAR.sharedInstance.isar;
    return await isar.relayDBISARs.where().findAll();
  }

  Future<void> syncRelaysToDB({String? r}) async {
    if (r != null && relays[r] != null) {
      await DBISAR.sharedInstance.saveToDB(relays[r]!);
    } else {
      await Future.forEach(relays.values, (relay) async {
        await DBISAR.sharedInstance.saveToDB(relay);
      });
    }
  }

  Future<void> syncRelayToDB(RelayDBISAR db) async {
    await DBISAR.sharedInstance.saveToDB(db);
  }

  int getFriendMessageUntil(String relayURL) {
    return relays.containsKey(relayURL) ? relays[relayURL]!.friendMessageUntil : 0;
  }

  int getFriendMessageSince(String relayURL) {
    return relays.containsKey(relayURL) ? relays[relayURL]!.friendMessageSince : 0;
  }

  int getFriendRequestUntil(String relayURL) {
    return relays.containsKey(relayURL) ? relays[relayURL]!.friendRequestUntil : 0;
  }

  int getFriendRequestSince(String relayURL) {
    return relays.containsKey(relayURL) ? relays[relayURL]!.friendRequestSince : 0;
  }

  int getChannelMessageSince(String relayURL) {
    return relays.containsKey(relayURL) ? relays[relayURL]!.channelMessageSince : 0;
  }

  int getChannelMessageUntil(String relayURL) {
    return relays.containsKey(relayURL) ? relays[relayURL]!.channelMessageUntil : 0;
  }

  int getGroupMessageSince(String relayURL) {
    return relays.containsKey(relayURL) ? relays[relayURL]!.groupMessageSince : 0;
  }

  int getGroupMessageUntil(String relayURL) {
    return relays.containsKey(relayURL) ? relays[relayURL]!.groupMessageUntil : 0;
  }

  int getMLSGroupMessageSince(String relayURL) {
    return relays.containsKey(relayURL) ? relays[relayURL]!.mlsGroupMessageSince : 0;
  }

  int getMLSGroupMessageUntil(String relayURL) {
    return relays.containsKey(relayURL) ? relays[relayURL]!.mlsGroupMessageUntil : 0;
  }

  int getMomentSince(String relayURL) {
    return relays.containsKey(relayURL) ? relays[relayURL]!.momentSince : 0;
  }

  int getMomentUntil(String relayURL) {
    return relays.containsKey(relayURL) ? relays[relayURL]!.momentUntil : 0;
  }

  int getZapRecordSince(String relayURL) {
    return relays.containsKey(relayURL) ? relays[relayURL]!.zapRecordSince : 0;
  }

  int getZapRecordUntil(String relayURL) {
    return relays.containsKey(relayURL) ? relays[relayURL]!.zapRecordUntil : 0;
  }

  int getCommonMessageUntil(String relayURL) {
    return relays.containsKey(relayURL) ? relays[relayURL]!.commonMessagesUntil : 0;
  }

  int getCommonMessageSince(String relayURL) {
    return relays.containsKey(relayURL) ? relays[relayURL]!.commonMessagesSince : 0;
  }

  void setCommonMessageUntil(int updateTime, String relay) {
    int until = Relays.sharedInstance.getCommonMessageUntil(relay);
    if (!relays.containsKey(relay)) relays[relay] = RelayDBISAR(url: relay);
    relays[relay]!.commonMessagesUntil = updateTime > until ? updateTime : until;
  }

  void setFriendMessageUntil(int updateTime, String relay) {
    int until = Relays.sharedInstance.getFriendMessageUntil(relay);
    if (!relays.containsKey(relay)) relays[relay] = RelayDBISAR(url: relay);
    relays[relay]!.friendMessageUntil = updateTime > until ? updateTime : until;
  }

  void setFriendRequestUntil(int updateTime, String relay) {
    int until = Relays.sharedInstance.relays[relay]!.friendRequestUntil;
    if (!relays.containsKey(relay)) relays[relay] = RelayDBISAR(url: relay);
    Relays.sharedInstance.relays[relay]!.friendRequestUntil =
        updateTime > until ? updateTime : until;
  }

  void setChannelMessageUntil(int updateTime, String relay) {
    int until = Relays.sharedInstance.getChannelMessageUntil(relay);
    if (!relays.containsKey(relay)) relays[relay] = RelayDBISAR(url: relay);
    relays[relay]!.channelMessageUntil = updateTime > until ? updateTime : until;
  }

  void setMomentUntil(int updateTime, String relay) {
    int until = Relays.sharedInstance.getMomentUntil(relay);
    if (!relays.containsKey(relay)) relays[relay] = RelayDBISAR(url: relay);
    relays[relay]!.momentUntil = updateTime > until ? updateTime : until;
  }

  void setZapRecordUntil(int updateTime, String relay) {
    int until = Relays.sharedInstance.getZapRecordUntil(relay);
    if (!relays.containsKey(relay)) relays[relay] = RelayDBISAR(url: relay);
    relays[relay]!.zapRecordUntil = updateTime > until ? updateTime : until;
  }

  void setGroupMessageUntil(int updateTime, String relay) {
    int until = Relays.sharedInstance.getGroupMessageUntil(relay);
    if (!relays.containsKey(relay)) relays[relay] = RelayDBISAR(url: relay);
    relays[relay]!.groupMessageUntil = updateTime > until ? updateTime : until;
  }

  void setMLSGroupMessageUntil(int updateTime, String relay) {
    int until = Relays.sharedInstance.getMLSGroupMessageUntil(relay);
    if (!relays.containsKey(relay)) relays[relay] = RelayDBISAR(url: relay);
    relays[relay]!.mlsGroupMessageUntil = updateTime > until ? updateTime : until;
  }

  void setCommonMessageSince(int updateTime, String relay) {
    int since = Relays.sharedInstance.getCommonMessageSince(relay);
    if (!relays.containsKey(relay)) relays[relay] = RelayDBISAR(url: relay);
    relays[relay]!.commonMessagesSince = updateTime < since ? updateTime : since;
  }

  void setFriendMessageSince(int updateTime, String relay) {
    int since = Relays.sharedInstance.getFriendMessageSince(relay);
    if (!relays.containsKey(relay)) relays[relay] = RelayDBISAR(url: relay);
    relays[relay]!.friendMessageSince = updateTime < since ? updateTime : since;
  }

  void setFriendRequestSince(int updateTime, String relay) {
    int since = Relays.sharedInstance.relays[relay]!.friendRequestSince;
    if (!relays.containsKey(relay)) relays[relay] = RelayDBISAR(url: relay);
    Relays.sharedInstance.relays[relay]!.friendRequestSince =
        updateTime < since ? updateTime : since;
  }

  void setChannelMessageSince(int updateTime, String relay) {
    int since = Relays.sharedInstance.getChannelMessageSince(relay);
    if (!relays.containsKey(relay)) relays[relay] = RelayDBISAR(url: relay);
    relays[relay]!.channelMessageSince = updateTime < since ? updateTime : since;
  }

  void setMomentSince(int updateTime, String relay) {
    int since = Relays.sharedInstance.getMomentSince(relay);
    if (!relays.containsKey(relay)) relays[relay] = RelayDBISAR(url: relay);
    relays[relay]!.momentSince = updateTime < since ? updateTime : since;
  }

  void setZapRecordSince(int updateTime, String relay) {
    int since = Relays.sharedInstance.getZapRecordSince(relay);
    if (!relays.containsKey(relay)) relays[relay] = RelayDBISAR(url: relay);
    relays[relay]!.zapRecordSince = updateTime < since ? updateTime : since;
  }

  void setGroupMessageSince(int updateTime, String relay) {
    int since = Relays.sharedInstance.getGroupMessageSince(relay);
    if (!relays.containsKey(relay)) relays[relay] = RelayDBISAR(url: relay);
    relays[relay]!.groupMessageSince = updateTime < since ? updateTime : since;
  }

  void setMLSGroupMessageSince(int updateTime, String relay) {
    int since = Relays.sharedInstance.getMLSGroupMessageSince(relay);
    if (!relays.containsKey(relay)) relays[relay] = RelayDBISAR(url: relay);
    relays[relay]!.mlsGroupMessageSince = updateTime < since ? updateTime : since;
  }

  static Future<RelayDBISAR?> getRelayDetailsFromDB(String relayURL) async {
    final isar = DBISAR.sharedInstance.isar;
    return await isar.relayDBISARs.filter().urlEqualTo(relayURL).findFirst();
  }

  static Future<RelayDBISAR?> getRelayDetails(String relayURL, {bool? refresh}) async {
    if (refresh != true) {
      RelayDBISAR? relayDB = await getRelayDetailsFromDB(relayURL);
      if (relayDB?.pubkey?.isNotEmpty == true) return relayDB;
    }

    var url = Uri.parse(relayURL).replace(scheme: 'https');
    var response = await http.get(url, headers: {'Accept': 'application/nostr+json'});

    if (response.statusCode == 200) {
      RelayDBISAR? relayDB = Relays.sharedInstance.relays.containsKey(relayURL)
          ? Relays.sharedInstance.relays[relayURL]
          : RelayDBISAR(url: relayURL);
      relayDB = RelayDBISAR.relayDBInfoFromJSON(response.body, relayDB!);
      await Relays.sharedInstance.syncRelayToDB(relayDB);
      return relayDB;
    } else {
      LogUtils.v(() => 'Request failed with status: ${response.statusCode}.');
      return null;
    }
  }
}
