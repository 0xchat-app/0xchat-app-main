import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:chatcore/chat-core.dart';

extension AccountProfile on Account {
  Future<void> loginSuccess() async {
    Connect.sharedInstance.addConnectStatusListener((relay, status, relayKinds) async {
      if (status == 1 &&
          Account.sharedInstance.me != null &&
          relayKinds.contains(RelayKind.general)) {
        reloadMyProfileFromRelay(relay: relay);
      }
    });
    await Future.delayed(Duration(seconds: 1));
    reloadMyProfileFromRelay();
  }

  Future<UserDBISAR> reloadMyProfileFromRelay({String? relay}) async {
    Completer<UserDBISAR> completer = Completer<UserDBISAR>();
    Filter f = Filter(kinds: ChatCoreManager().myProfileKinds(), authors: [currentPubkey]);
    List<Event> events = [];
    Connect.sharedInstance.addSubscription([f], relays: relay == null ? null : [relay],
        eventCallBack: (event, relay) async {
      events.add(event);
    }, eoseCallBack: (requestId, ok, relay, unRelays) async {
      if (unRelays.isEmpty) {
        for (var event in events) {
          switch (event.kind) {
            case 0:
              me = _handleKind0Event(me, event);
              break;
            case 3:
              me = _handleKind3Event(me, event);
              break;
            case 10000:
              me = await _handleKind10000Event(me, event);
              break;
            case 10002:
              me = _handleKind10002Event(me, event);
              break;
            case 10005:
              me = await _handleKind10005Event(me, event);
              break;
            case 10009:
              me = await _handleKind10009Event(me, event);
              break;
            case 10050:
              me = _handleKind10050Event(me, event);
              break;
            case 30000:
              me = await _handleKind30000Event(me, event);
              break;
            case 30001:
              me = await _handleKind30001Event(me, event);
              break;
            case 30003:
              me = await _handleKind30003Event(me, event);
              break;
            case 30008:
              me = _handleKind30008Event(me, event);
              break;
          }
        }
        userCache[currentPubkey] = ValueNotifier<UserDBISAR>(me!);
        syncMe();
        if (!completer.isCompleted) completer.complete(me);
      }
    });
    return completer.future;
  }

  Future<UserDBISAR> reloadProfileFromRelay(String pubkey) async {
    Completer<UserDBISAR> completer = Completer<UserDBISAR>();
    UserDBISAR? db = await getUserInfo(pubkey);
    Filter f = Filter(kinds: ChatCoreManager().userProfileKinds(), authors: [pubkey]);
    Connect.sharedInstance.addSubscription([f], eventCallBack: (event, relay) async {
      switch (event.kind) {
        case 0:
          db = _handleKind0Event(db, event);
          break;
        case 10002:
          db = _handleKind10002Event(db, event);
          break;
        case 10050:
          db = _handleKind10050Event(db, event);
          break;
        case 30008:
          db = _handleKind30008Event(db, event);
          break;
      }
    }, eoseCallBack: (requestId, ok, relay, unRelays) async {
      if (unRelays.isEmpty) {
        userCache[pubkey] = ValueNotifier<UserDBISAR>(db!);
        if (pubkey == currentPubkey) me = db;
        Account.saveUserToDB(db!);
        if (!completer.isCompleted) completer.complete(db);
      }
    });
    return completer.future;
  }

  /// sync profile from relays
  Future<void> syncProfilesFromRelay() async {
    if (pQueue.isEmpty) return;
    Completer<void> completer = Completer<void>();

    Map<String, UserDBISAR> users = {};
    // init users from cache & DB
    List<String> pQueueTemp = List.from(pQueue);
    for (var key in pQueueTemp) {
      UserDBISAR? db = userCache[key]?.value;
      db ??= await getUserFromDB(pubkey: key);
      if (db != null && db.lastUpdatedTime > 0) {
        pQueue.remove(db.pubKey);
        continue;
      }
      if (db == null) {
        db = UserDBISAR();
        db.pubKey = key;
      }
      if (db.name == null || db.name!.isEmpty) {
        db.name = db.shortEncodedPubkey;
      }
      users[key] = db;
    }

    Filter f = Filter(
      kinds: ChatCoreManager().userProfileKinds(),
      authors: users.keys.toList(),
    );

    Connect.sharedInstance.addSubscription([f], eventCallBack: (event, relay) async {
      String p = event.pubkey;
      UserDBISAR db = users[p] ?? UserDBISAR(pubKey: p);
      if (event.kind == 0) {
        users[p] = _handleKind0Event(db, event)!;
      }
      if (event.kind == 10050) {
        users[p] = _handleKind10050Event(db, event)!;
      }
      if (event.kind == 10002) {
        users[p] = _handleKind10002Event(db, event)!;
      }
      if (event.kind == 30008) {
        users[p] = _handleKind30008Event(db, event)!;
      }
      userCache[p]?.value = users[p]!;
      userCache[p]?.notifyListeners();
      pQueue.remove(p);
      Account.saveUserToDB(users[p]!);
    }, eoseCallBack: (requestId, ok, relay, unRelays) async {
      if (unRelays.isEmpty) {
        pQueue.removeWhere((key) => users.keys.contains(key));
        if (!completer.isCompleted) completer.complete();
      }
    });
    return completer.future;
  }

  Future<UserDBISAR?> updateProfile(UserDBISAR updateDB) async {
    Completer<UserDBISAR?> completer = Completer<UserDBISAR?>();

    UserDBISAR db = await getUserFromDB(pubkey: currentPubkey) ?? UserDBISAR();
    db.name = updateDB.name;
    db.gender = updateDB.gender;
    db.area = updateDB.area;
    db.about = updateDB.about;
    db.picture = updateDB.picture;
    db.banner = updateDB.banner;
    db.dns = updateDB.dns;
    db.lnurl = updateDB.lnurl;
    db.mute = updateDB.mute;
    await Account.saveUserToDB(db);

    /// send metadata event
    Map map = {
      'name': updateDB.name ?? '',
      'about': updateDB.about ?? '',
      'gender': updateDB.gender ?? '',
      'area': updateDB.area ?? '',
      'picture': updateDB.picture ?? '',
      'banner': updateDB.banner ?? '',
      'nip05': updateDB.dns ?? '',
      'lud16': updateDB.lnurl ?? ''
    };
    Map additionMap = jsonDecode(db.otherField ?? '{}');
    map.addAll(additionMap);
    Event event = await Nip1.setMetadata(jsonEncode(map), currentPubkey, currentPrivkey);
    
    // Get available relays before sending
    List<String> availableRelays = Connect.sharedInstance.relays(
      relayKinds: [RelayKind.general, RelayKind.outbox],
    );
    
    // If no relays available, complete with null immediately
    if (availableRelays.isEmpty) {
      LogUtils.w(() => 'No relays available for updateProfile, completing with null');
      completer.complete(null);
      return completer.future;
    }
    
    Connect.sharedInstance.sendEvent(event, sendCallBack: (ok, relay) {
      if (ok.status) {
        completer.complete(db);
      } else {
        completer.complete(null);
      }
    });
    
    // Add timeout to ensure completer always completes
    Future.delayed(Duration(seconds: 15), () {
      if (!completer.isCompleted) {
        LogUtils.w(() => 'updateProfile completer timeout, completing with null');
        completer.complete(null);
      }
    });
    
    return completer.future;
  }

  UserDBISAR? _handleKind0Event(UserDBISAR? db, Event event) {
    if (event.content.isEmpty) return db;
    Map map = jsonDecode(event.content);
    if (db != null && db.lastUpdatedTime < event.createdAt) {
      db.name = map['name']?.toString();
      db.gender = map['gender']?.toString();
      db.area = map['area']?.toString();
      db.about = map['about']?.toString();
      db.picture = map['picture']?.toString();
      db.banner = map['banner']?.toString();
      db.dns = map['nip05']?.toString();
      db.lnurl = map['lnurl']?.toString();
      if (db.lnurl == null || db.lnurl == 'null' || db.lnurl!.isEmpty) {
        db.lnurl = null;
      }
      db.lnurl ??= map['lud06']?.toString();
      db.lnurl ??= map['lud16']?.toString();
      db.lastUpdatedTime = event.createdAt;
      if (db.name == null || db.name!.isEmpty) {
        db.name = map['display_name']?.toString();
      }
      if (db.name == null || db.name!.isEmpty) {
        db.name = map['username']?.toString();
      }
      if (db.name == null || db.name!.isEmpty) {
        db.name = db.shortEncodedPubkey;
      }
      var keysToRemove = {
        'name',
        'display_name',
        'username',
        'gender',
        'area',
        'about',
        'picture',
        'banner',
        'nip05',
        'lnurl',
        'lud16',
        'lud06'
      };
      Map filteredMap = Map.from(map)..removeWhere((key, value) => keysToRemove.contains(key));
      db.otherField = jsonEncode(filteredMap);
    } else {
      if (db?.lnurl == null || db?.lnurl == 'null' || db!.lnurl!.isEmpty) {
        db?.lnurl = null;
      }
      db?.lnurl ??= map['lud16'];
      db?.lnurl ??= map['lud06'];
    }
    return db;
  }

  // following list
  UserDBISAR? _handleKind3Event(UserDBISAR? db, Event event) {
    if (db != null && db.lastFollowingListUpdatedTime < event.createdAt) {
      db.lastFollowingListUpdatedTime = event.createdAt;
      // following list
      List<Profile> profiles = Nip2.decode(event);
      db.followingList = profiles.map((e) => e.key).toList();
      // // relay list
      // if(event.content.isNotEmpty){
      //   Map map = jsonDecode(event.content);
      //   db.relayList ??= [];
      //   Set<String> relaySet = Set.from(db.relayList!);
      //   relaySet.addAll(map.keys.map((e) => e.toString()).toList());
      //   db.relayList = relaySet.toList();
      //   relayListUpdateCallback?.call();
      // }
    }
    return db;
  }

  // mute&block list
  Future<UserDBISAR?> _handleKind10000Event(UserDBISAR? db, Event event) async {
    if (db != null && db.lastBlockListUpdatedTime < event.createdAt) {
      db.lastBlockListUpdatedTime = event.createdAt;
      Lists result = await Nip51.getLists(event, currentPubkey, currentPrivkey);
      Set<String> blockedList = Set.from(db.blockedList ?? []);
      blockedList.addAll(result.people.map((p) => p.pubkey).toList());
      db.blockedList = blockedList.toList();
      db.blockedWords = result.words;
      db.blockedHashTags = result.hashTags;
      db.blockedThreads = result.bookmarks;
    }
    return db;
  }

  // relay list
  UserDBISAR? _handleKind10002Event(UserDBISAR? db, Event event) {
    if (db != null) {
      // Only process if event is newer than current data
      if (db.lastRelayListUpdatedTime >= event.createdAt) {
        return db;
      }
      
      db.lastRelayListUpdatedTime = event.createdAt;
      List<Relay> result = Nip65.decode(event);
      
      // Completely replace lists instead of appending
      List<String> newInboxRelays = [];
      List<String> newOutboxRelays = [];
      
      for (var relay in result) {
        // Handle inbox relays (read or no read/write marker)
        if (relay.r == 'read' || relay.r == null) {
          if (!newInboxRelays.contains(relay.url)) {
            newInboxRelays.add(relay.url);
          }
        }
        // Handle outbox relays (write or no read/write marker)
        if (relay.r == 'write' || relay.r == null) {
          if (!newOutboxRelays.contains(relay.url)) {
            newOutboxRelays.add(relay.url);
          }
        }
      }
      
      // Replace the lists completely
      db.inboxRelayList = newInboxRelays;
      db.outboxRelayList = newOutboxRelays;
      
      if (db.pubKey == currentPubkey) {
        Relays.sharedInstance.connectInboxOutboxRelays();
        relayListUpdateCallback?.call();
      }
    }
    return db;
  }

  // channel list
  Future<UserDBISAR?> _handleKind10005Event(UserDBISAR? db, Event event) async {
    if (db != null && db.lastChannelsListUpdatedTime < event.createdAt) {
      db.lastChannelsListUpdatedTime = event.createdAt;
      Lists result = await Nip51.getLists(event, currentPubkey, currentPrivkey);
      db.channelsList = result.bookmarks;
      channelListUpdateCallback?.call();
    }
    return db;
  }

  // relay group list
  Future<UserDBISAR?> _handleKind10009Event(UserDBISAR? db, Event event) async {
    if (db != null && db.lastRelayGroupsListUpdatedTime < event.createdAt) {
      db.lastRelayGroupsListUpdatedTime = event.createdAt;
      Lists result = await Nip51.getLists(event, currentPubkey, currentPrivkey);
      List<String> relayGroupsList = [];
      for (var g in result.groups) {
        relayGroupsList.add('${g.relay}\'${g.groupId}');
      }
      db.relayGroupsList = relayGroupsList;
      relayGroupListUpdateCallback?.call();
    }
    return db;
  }

  // dm relay list
  UserDBISAR? _handleKind10050Event(UserDBISAR? db, Event event) {
    if (db != null && db.lastDMRelayListUpdatedTime < event.createdAt) {
      db.lastDMRelayListUpdatedTime = event.createdAt;
      List<String> relayList = Nip17.decodeDMRelays(event);
      db.dmRelayList = relayList;
      Relays.sharedInstance.connectDMRelays();
      if (db.pubKey == currentPubkey) dmRelayListUpdateCallback?.call();
    }
    return db;
  }

  // contact list
  Future<UserDBISAR?> _handleKind30000Event(UserDBISAR? db, Event event) async {
    if (db == null) return null;
    if (db.lastFriendsListUpdatedTime >= event.createdAt) return db;
    Lists result = await Nip51.getLists(event, currentPubkey, currentPrivkey);
    if (result.identifier == Contacts.identifier) {
      // contact list
      db.lastFriendsListUpdatedTime = event.createdAt;
      db.friendsList = await Nip51.peoplesToContent(result.people, currentPrivkey, currentPubkey);
      contactListUpdateCallback?.call();
    }
    return db;
  }

  // old list
  Future<UserDBISAR?> _handleKind30001Event(UserDBISAR? db, Event event) async {
    if (db == null) return null;
    if (db.lastChannelsListUpdatedTime >= event.createdAt) return db;
    Lists result = await Nip51.getLists(event, currentPubkey, currentPrivkey);
    if (result.identifier == Channels.identifier) {
      db.lastChannelsListUpdatedTime = event.createdAt;
      db.channelsList = result.bookmarks;
      channelListUpdateCallback?.call();
    }
    return db;
  }

  // bookmark list
  Future<UserDBISAR?> _handleKind30003Event(UserDBISAR? db, Event event) async {
    if (db == null) return null;
    if (db.lastGroupsListUpdatedTime >= event.createdAt) return db;
    Lists result = await Nip51.getLists(event, currentPubkey, currentPrivkey);
    if (result.identifier == Groups.identifier) {
      // private group list
      db.lastGroupsListUpdatedTime = event.createdAt;
      db.groupsList = result.bookmarks;
      groupListUpdateCallback?.call();
    }
    return db;
  }

  // profile badge
  UserDBISAR? _handleKind30008Event(UserDBISAR? db, Event event) {
    if (db != null && db.lastUpdatedTime < event.createdAt) {
      try {
        List<BadgeAward> profileBadges = Nip58.getProfileBadges(event);
        db.badges = jsonEncode(profileBadges.map((e) => e.awardId).toList());
      } catch (e) {
        LogUtils.d(e);
      }
    }
    return db;
  }
}
