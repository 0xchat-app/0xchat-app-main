import 'dart:async';

import 'package:nostr_core_dart/nostr.dart';
import 'package:chatcore/chat-core.dart';

extension AccountRelay on Account {
  List<RelayDBISAR> getMyDMRelayList() {
    List<String> dmRelays = me?.dmRelayList ?? [];
    List<RelayDBISAR> result = [];
    for (var relay in dmRelays) {
      relay = relay.endsWith('/') ? relay.substring(0, relay.length - 1) : relay;
      result.add(Relays.sharedInstance.relays[relay] ?? RelayDBISAR(url: relay));
    }
    return result;
  }

  List<RelayDBISAR> getMyInboxRelayList() {
    List<String> inboxRelays = me?.inboxRelayList ?? [];
    List<RelayDBISAR> result = [];
    for (var relay in inboxRelays) {
      relay = relay.endsWith('/') ? relay.substring(0, relay.length - 1) : relay;
      result.add(Relays.sharedInstance.relays[relay] ?? RelayDBISAR(url: relay));
    }
    return result;
  }

  List<RelayDBISAR> getMyOutboxRelayList() {
    List<String> outboxRelays = me?.outboxRelayList ?? [];
    List<RelayDBISAR> result = [];
    for (var relay in outboxRelays) {
      relay = relay.endsWith('/') ? relay.substring(0, relay.length - 1) : relay;
      result.add(Relays.sharedInstance.relays[relay] ?? RelayDBISAR(url: relay));
    }
    return result;
  }

  List<RelayDBISAR> getMyGeneralRelayList() {
    List<String> generalRelays = me?.relayList ?? [];
    List<RelayDBISAR> result = [];
    for (var relay in generalRelays) {
      relay = relay.endsWith('/') ? relay.substring(0, relay.length - 1) : relay;
      result.add(Relays.sharedInstance.relays[relay] ?? RelayDBISAR(url: relay));
    }
    return result;
  }

  List<RelayDBISAR> getMyRecommendGeneralRelaysList() {
    List<String> dmRelays = Relays.sharedInstance.recommendGeneralRelays;
    List<RelayDBISAR> result = [];
    for (var relay in dmRelays) {
      relay = relay.endsWith('/') ? relay.substring(0, relay.length - 1) : relay;
      result.add(Relays.sharedInstance.relays[relay] ?? RelayDBISAR(url: relay));
    }
    return result;
  }

  List<RelayDBISAR> getMyRecommendDMRelaysList() {
    List<String> dmRelays = Relays.sharedInstance.recommendDMRelays;
    List<RelayDBISAR> result = [];
    for (var relay in dmRelays) {
      relay = relay.endsWith('/') ? relay.substring(0, relay.length - 1) : relay;
      result.add(Relays.sharedInstance.relays[relay] ?? RelayDBISAR(url: relay));
    }
    return result;
  }

  List<RelayDBISAR> getMySearchRelayList() {
    List<String> searchRelays = me?.searchRelayList ?? [];
    List<RelayDBISAR> result = [];
    for (var relay in searchRelays) {
      relay = relay.endsWith('/') ? relay.substring(0, relay.length - 1) : relay;
      result.add(Relays.sharedInstance.relays[relay] ?? RelayDBISAR(url: relay));
    }
    return result;
  }

  List<RelayDBISAR> getMyRecommendSearchRelaysList() {
    List<String> searchRelays = Relays.sharedInstance.recommendSearchRelays;
    List<RelayDBISAR> result = [];
    for (var relay in searchRelays) {
      relay = relay.endsWith('/') ? relay.substring(0, relay.length - 1) : relay;
      result.add(Relays.sharedInstance.relays[relay] ?? RelayDBISAR(url: relay));
    }
    return result;
  }

  List<String> getCurrentCircleRelay() {
    return Connect.sharedInstance.relays(relayKinds: [RelayKind.circleRelay]);
  }

  Future<List<String>> getUserDMRelayList(String pubkey) async {
    UserDBISAR? userDB = await getUserInfo(pubkey);
    if (userDB != null) {
      return userDB.dmRelayList ?? [];
    }
    return [];
  }

  Future<List<String>> getUserGeneralRelayList(String pubkey) async {
    UserDBISAR? userDB = await getUserInfo(pubkey);
    if (userDB != null) {
      return userDB.relayList ?? [];
    }
    return [];
  }

  Future<OKEvent> setDMRelayListToRelay(List<String> relays) async {
    me!.dmRelayList = relays;
    me!.lastDMRelayListUpdatedTime = currentUnixTimestampSeconds();
    Relays.sharedInstance.connectDMRelays();
    syncMe();
    Completer<OKEvent> completer = Completer<OKEvent>();
    Event event = await Nip17.encodeDMRelays(relays, currentPubkey, currentPrivkey);
    Connect.sharedInstance.sendEvent(event, sendCallBack: (ok, relay) {
      if (!completer.isCompleted) {
        completer.complete(ok);
      }
    });
    return completer.future;
  }

  Future<OKEvent> addGeneralRelay(String relay) async {
    if (relay.isEmpty) return OKEvent(relay, false, 'empty relay');
    List<String> relays = me?.relayList ?? [];
    if (relays.contains(relay)) return OKEvent(relay, false, 'already exit');
    relays.add(relay);
    Connect.sharedInstance.connectRelays([relay], relayKind: RelayKind.general);
    return await setGeneralRelayListToLocal(relays);
  }

  Future<OKEvent> removeGeneralRelay(String relay) async {
    if (relay.isEmpty) return OKEvent(relay, false, 'empty relay');
    List<String> relays = List.from(me!.relayList ?? []);
    if (!relays.contains(relay)) return OKEvent(relay, false, 'not exit');
    relays.remove(relay);
    Connect.sharedInstance.closeConnects([relay], RelayKind.general);
    OKEvent result = await setGeneralRelayListToLocal(relays);
    await DBISAR.sharedInstance.flushBuffers();
    return result;
  }

  Future<OKEvent> addInboxRelay(String relay) async {
    if (relay.isEmpty) return OKEvent(relay, false, 'empty relay');
    List<String> relays = me?.inboxRelayList ?? [];
    if (relays.contains(relay)) return OKEvent(relay, false, 'already exit');
    relays.add(relay);
    Connect.sharedInstance.connectRelays([relay], relayKind: RelayKind.inbox);
    return await setInboxRelayListToRelay(relays);
  }

  Future<OKEvent> removeInboxRelay(String relay) async {
    if (relay.isEmpty) return OKEvent(relay, false, 'empty relay');
    List<String> relays = List.from(me!.inboxRelayList ?? []);
    if (!relays.contains(relay)) return OKEvent(relay, false, 'not exit');
    relays.remove(relay);
    Connect.sharedInstance.closeConnects([relay], RelayKind.inbox);
    OKEvent result = await setInboxRelayListToRelay(relays);
    await DBISAR.sharedInstance.flushBuffers();
    return result;
  }

  Future<OKEvent> addOutboxRelay(String relay) async {
    if (relay.isEmpty) return OKEvent(relay, false, 'empty relay');
    List<String> relays = me?.outboxRelayList ?? [];
    if (relays.contains(relay)) return OKEvent(relay, false, 'already exit');
    relays.add(relay);
    Connect.sharedInstance.connectRelays([relay], relayKind: RelayKind.outbox);
    return await setOutboxRelayListToRelay(relays);
  }

  Future<OKEvent> removeOutboxRelay(String relay) async {
    if (relay.isEmpty) return OKEvent(relay, false, 'empty relay');
    List<String> relays = List.from(me!.outboxRelayList ?? []);
    if (!relays.contains(relay)) return OKEvent(relay, false, 'not exit');
    relays.remove(relay);
    Connect.sharedInstance.closeConnects([relay], RelayKind.outbox);
    OKEvent result = await setOutboxRelayListToRelay(relays);
    await DBISAR.sharedInstance.flushBuffers();
    return result;
  }

  Future<OKEvent> addDMRelay(String relay) async {
    if (relay.isEmpty) return OKEvent(relay, false, 'empty relay');
    List<String> relays = List.from(me?.dmRelayList ?? []);
    if (relays.contains(relay)) return OKEvent(relay, false, 'already exit');
    relays.add(relay);
    Connect.sharedInstance.connectRelays([relay], relayKind: RelayKind.dm);
    return await setDMRelayListToRelay(relays);
  }

  Future<OKEvent> removeDMRelay(String relay) async {
    if (relay.isEmpty) return OKEvent(relay, false, 'empty relay');
    List<String> relays = me?.dmRelayList ?? [];
    if (!relays.contains(relay)) return OKEvent(relay, false, 'not exit');
    relays.remove(relay);
    Connect.sharedInstance.closeConnects([relay], RelayKind.dm);
    OKEvent result = await setDMRelayListToRelay(relays);
    await DBISAR.sharedInstance.flushBuffers();
    return result;
  }

  Future<OKEvent> addSearchRelay(String relay) async {
    if (relay.isEmpty) return OKEvent(relay, false, 'empty relay');
    relay = relay.endsWith('/') ? relay.substring(0, relay.length - 1) : relay;
    List<String> relays = List.from(me?.searchRelayList ?? []);
    if (relays.contains(relay)) return OKEvent(relay, false, 'already exit');
    relays.add(relay);
    Connect.sharedInstance.connectRelays([relay], relayKind: RelayKind.search);
    return await setSearchRelayListToLocal(relays);
  }

  Future<OKEvent> removeSearchRelay(String relay) async {
    if (relay.isEmpty) return OKEvent(relay, false, 'empty relay');
    relay = relay.endsWith('/') ? relay.substring(0, relay.length - 1) : relay;
    List<String> relays = List.from(me?.searchRelayList ?? []);
    if (!relays.contains(relay)) return OKEvent(relay, false, 'not exit');
    relays.remove(relay);
    Connect.sharedInstance.closeConnects([relay], RelayKind.search);
    OKEvent result = await setSearchRelayListToLocal(relays);
    await DBISAR.sharedInstance.flushBuffers();
    return result;
  }

  Future<OKEvent> setSearchRelayListToLocal(List<String> relays) async {
    me!.searchRelayList = relays;
    Relays.sharedInstance.connectSearchRelays();
    syncMe();
    return OKEvent('', true, '');
  }

  Future<void> closeAllRelays() async {
    await Connect.sharedInstance.closeAllConnects();
  }

  Future<void> resumeAllRelays() async {
    await Relays.sharedInstance.connectGeneralRelays();
    await Relays.sharedInstance.connectDMRelays();
    await Contacts.sharedInstance.syncSecretSessionFromDB();
    RelayGroup.sharedInstance.groupListUpdated();
  }

  int getConnectedRelaysCount() {
    Set<RelayDBISAR> myRelays = Set.from(getMyGeneralRelayList());
    myRelays.addAll(getMyDMRelayList());
    myRelays.addAll(getMyInboxRelayList());
    myRelays.addAll(getMyOutboxRelayList());
    int connected = 0;
    for (var relay in myRelays) {
      if (relay.connectStatus == 1) ++connected;
    }
    return connected;
  }

  int getAllRelaysCount() {
    Set<RelayDBISAR> allRelays = Set.from(getMyGeneralRelayList());
    allRelays.addAll(getMyDMRelayList());
    allRelays.addAll(getMyInboxRelayList());
    allRelays.addAll(getMyOutboxRelayList());
    return allRelays.length;
  }

  Future<OKEvent> setGeneralRelayListToLocal(List<String> relays) async {
    me!.relayList = relays;
    me!.lastRelayListUpdatedTime = currentUnixTimestampSeconds();
    Relays.sharedInstance.connectGeneralRelays();
    syncMe();
    return OKEvent('', true, '');
  }

  Future<OKEvent> setInboxRelayListToRelay(List<String> relays) async {
    me!.inboxRelayList = relays;
    me!.lastRelayListUpdatedTime = currentUnixTimestampSeconds();
    Relays.sharedInstance.connectInboxOutboxRelays();
    syncMe();
    return setInboxOutboxToRelay();
  }

  Future<OKEvent> setOutboxRelayListToRelay(List<String> relays) async {
    me!.outboxRelayList = relays;
    me!.lastRelayListUpdatedTime = currentUnixTimestampSeconds();
    Relays.sharedInstance.connectInboxOutboxRelays();
    syncMe();
    return setInboxOutboxToRelay();
  }

  Future<OKEvent> setInboxOutboxToRelay() async {
    Completer<OKEvent> completer = Completer<OKEvent>();
    List<Relay> list = [];
    for (var relay in me!.inboxRelayList ?? []) {
      list.add(Relay(relay, 'read'));
    }
    for (var relay in me!.outboxRelayList ?? []) {
      list.add(Relay(relay, 'write'));
    }
    Event event = await Nip65.encode(list, currentPubkey, currentPrivkey);
    Connect.sharedInstance.sendEvent(event, sendCallBack: (ok, relay) {
      if (!completer.isCompleted) completer.complete(ok);
    });
    return completer.future;
  }
}
