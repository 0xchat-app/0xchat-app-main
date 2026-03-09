import 'dart:async';
import 'dart:convert';
import 'package:isar/isar.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:chatcore/chat-core.dart';

typedef BadgeAwardsCallBack = void Function(List<BadgeAward?>?);
typedef BadgeAwardDBsCallBack = void Function(List<BadgeAwardDBISAR?>?);

class BadgesHelper {
  /// singleton
  BadgesHelper._internal();
  factory BadgesHelper() => sharedInstance;
  static final BadgesHelper sharedInstance = BadgesHelper._internal();

  String badgeSubscription = '';
  final String serverPubkey =
      '093dff31a87bbf838c54fd39ff755e72b38bd6b7975c670c0f2633fa7c54ddd0';
  final String defaultBadgesString =
      '{\"code\":\"000000\",\"message\":\"Success\",\"data\":[{\"identifies\":\"aa330e14a58c5ada40ee0cea7f4c3121\",\"badgeId\":\"00003f2b93a5a3888fff0d251d270ca82f757a0d5efd556070a036ca8be8e820\",\"badgeName\":\"Egg\",\"badgeImageUrl\":\"https://www.0xchat.com/ipfs/QmWvaqDS5m35577sXZDae7m6fEU6SidznSwdbWndAEmUPe\",\"thumbUrl\":\"https://www.0xchat.com/ipfs/QmXgDVHfUcK5dXeQDKyX7R4DggTTkL9snEc61SXMqSNy4e\",\"creator\":\"0xchat\",\"description\":\"Earn the 0xchat Egg badge with cumulative donations of 2.1k sats. Your humble beginning sets the stage for a journey of a thousand miles.\",\"benefits\":[\"4-digit 0xchat DNS\"],\"benefitsIcon\":[\"https://www.0xchat.com/ipfs/QmU1CAcYjoVJq1DeeN66Yn4T2WSH8n1e1piHJ9BbQ1giyK\"],\"creatorAbout\":\"0xchat is a decentralized chatting app built on Nostr protocol. It prioritizes privacy with features like private key login, encrypted private chats and contacts, coupled with an open communication platform through public channels.\",\"howToGet\":\"Cumulative donations of 2.1k sats\"},{\"identifies\":\"fafec3cd6d8c04ad424ca82ed54e9afb\",\"badgeId\":\"00000f0951248ace7d69be0ed136a069f1d1021443b03e81ffbabda4e53bda9e\",\"badgeName\":\"Hatchling\",\"badgeImageUrl\":\"https://www.0xchat.com/ipfs/QmUTQT3djB92u4UEBtcjup7dhRhPAsGc3uLeEhRcforuDH\",\"thumbUrl\":\"https://www.0xchat.com/ipfs/QmTchyNpgxC4gFZ2P3UEHDKBwMrta9WV8Xp9uy4rwdyWNC\",\"creator\":\"0xchat\",\"description\":\"Garner the 0xchat Hatchling badge with cumulative donations of 4.2k sats. Your continued support hatches new opportunities and fosters breakthroughs.\",\"benefits\":[\"4-digit 0xchat DNS\"],\"benefitsIcon\":[\"https://www.0xchat.com/ipfs/QmU1CAcYjoVJq1DeeN66Yn4T2WSH8n1e1piHJ9BbQ1giyK\"],\"creatorAbout\":\"0xchat is a decentralized chatting app built on Nostr protocol. It prioritizes privacy with features like private key login, encrypted private chats and contacts, coupled with an open communication platform through public channels.\",\"howToGet\":\"Cumulative donations of 4.2k sats\"},{\"identifies\":\"115e7ac9cb28ccc172b9fde8b5ef4a50\",\"badgeId\":\"00002295d1ef76eee9a8d8d04cb2009483acedb452814e040a949555210f928e\",\"badgeName\":\"Chick\",\"badgeImageUrl\":\"https://www.0xchat.com/ipfs/QmaosfucQmDWt7hHnb1qgcgN8xREzwnHzYu9ysVeBweE4p\",\"thumbUrl\":\"https://www.0xchat.com/ipfs/QmWoyYV1DxK1A89M89YMSNSVgj2MgxipTL1ZASLyMJ7a8w\",\"creator\":\"0xchat\",\"description\":\"Attain the 0xchat Chick badge with cumulative donations of 21k sats. Like a chick learning to walk, your contributions enable steady progress.\",\"benefits\":[\"3-digit 0xchat DNS\"],\"benefitsIcon\":[\"https://www.0xchat.com/ipfs/QmU1CAcYjoVJq1DeeN66Yn4T2WSH8n1e1piHJ9BbQ1giyK\"],\"creatorAbout\":\"0xchat is a decentralized chatting app built on Nostr protocol. It prioritizes privacy with features like private key login, encrypted private chats and contacts, coupled with an open communication platform through public channels.\",\"howToGet\":\"Cumulative donations of 21k sats\"},{\"identifies\":\"8aeb9c5cd440dadbdeb6daa4fd97b763\",\"badgeId\":\"00001e93260c429660e39abd7cec733f9f3d9278bb7b2bbd8a3fff98d94a02bb\",\"badgeName\":\"Adolescent\",\"badgeImageUrl\":\"https://www.0xchat.com/ipfs/QmU5SUQu3dGrPE4jibkBYuXsE1YLjRJuFUPv894dkqDaVr\",\"thumbUrl\":\"https://www.0xchat.com/ipfs/QmXaP3fPLLtXS5a9iZrXgAvLmpjtY7FjdLj4VXRhKTgVCE\",\"creator\":\"0xchat\",\"description\":\"Acquire the 0xchat Adolescent badge with cumulative donations of 42k sats. Your speedy commitment propels us towards our mission.\",\"benefits\":[\"3-digit 0xchat DNS\"],\"benefitsIcon\":[\"https://www.0xchat.com/ipfs/QmU1CAcYjoVJq1DeeN66Yn4T2WSH8n1e1piHJ9BbQ1giyK\"],\"creatorAbout\":\"0xchat is a decentralized chatting app built on Nostr protocol. It prioritizes privacy with features like private key login, encrypted private chats and contacts, coupled with an open communication platform through public channels.\",\"howToGet\":\"Cumulative donations of 42k sats\"},{\"identifies\":\"ceba4defe16e22c5ca2d9bedcaec430e\",\"badgeId\":\"00000f7a835198691c5cd6f024fdfcf2ab82ef147160bf966ba5706271baa003\",\"badgeName\":\"Mature\",\"badgeImageUrl\":\"https://www.0xchat.com/ipfs/QmNuPsPojLxiBbPVEwYGCi8BqYQEkTemD9QLT4wWaBUP2u\",\"thumbUrl\":\"https://www.0xchat.com/ipfs/QmcKPMr6JX1ewUJzX6vPWPsuE9zDPg1ZiXhecryi57Tcgt\",\"creator\":\"0xchat\",\"description\":\"Receive the 0xchat Mature badge with cumulative donations of 210k sats. Your significant support, like a full-grown ostrich, matures into incredible growth.\",\"benefits\":[\"2-digit 0xchat DNS\"],\"benefitsIcon\":[\"https://www.0xchat.com/ipfs/QmU1CAcYjoVJq1DeeN66Yn4T2WSH8n1e1piHJ9BbQ1giyK\"],\"creatorAbout\":\"0xchat is a decentralized chatting app built on Nostr protocol. It prioritizes privacy with features like private key login, encrypted private chats and contacts, coupled with an open communication platform through public channels.\",\"howToGet\":\"Cumulative donations of 210k sats\"},{\"identifies\":\"1882297acefba82b14317c7c8e8fe28d\",\"badgeId\":\"000001a0ec0e7908caed173a82f68e93f8d791f7a045da0bf622c7bee0b72dee\",\"badgeName\":\"Geeky\",\"badgeImageUrl\":\"https://www.0xchat.com/ipfs/QmVKujbWMQCN6LfW2MvMo6B6XPrPAoA1nuwPf5YiCJeiuB\",\"thumbUrl\":\"https://www.0xchat.com/ipfs/Qme4TT55HCUbrx6SAZd9uwt5uotzekxFfmYJBNVhvFGEgN\",\"creator\":\"0xchat\",\"description\":\"Obtain the 0xchat Geeky badge with cumulative donations of 420k sats. You are not just a superhero, but a geeky one, powering innovation across our work.\",\"benefits\":[\"2-digit 0xchat DNS\"],\"benefitsIcon\":[\"https://www.0xchat.com/ipfs/QmU1CAcYjoVJq1DeeN66Yn4T2WSH8n1e1piHJ9BbQ1giyK\"],\"creatorAbout\":\"0xchat is a decentralized chatting app built on Nostr protocol. It prioritizes privacy with features like private key login, encrypted private chats and contacts, coupled with an open communication platform through public channels.\",\"howToGet\":\"Cumulative donations of 420k sats\"}]}';

  Map<String, BadgeDBISAR> badgeInfos = {};
  Map<String, BadgeDBISAR> chatBadges = {};

  Future<void> init() async {
    await _loadChatBadges();
    // _updateSubscriptions();
    // // subscript friend requests
    // Connect.sharedInstance.addConnectStatusListener((relay, status) async {
    //   if (status == 1 && Account.sharedInstance.me != null) {
    //     _updateSubscriptions(relay: relay);
    //   }
    // });
  }

  void _updateSubscriptions({String? relay}) {
    if (badgeSubscription.isNotEmpty) {
      Connect.sharedInstance.closeRequests(badgeSubscription, relay: relay);
    }

    Map<String, List<Filter>> subscriptions = {};

    if (relay == null) {
      for (String relayURL in Connect.sharedInstance.relays()) {
        int commonMessageUntil =
            Relays.sharedInstance.getCommonMessageUntil(relayURL);
        Filter f = Filter(
            kinds: [8], authors: [serverPubkey], since: commonMessageUntil);

        subscriptions[relayURL] = [f];
      }
    } else {
      int commonMessageUntil =
          Relays.sharedInstance.getCommonMessageUntil(relay);
      Filter f = Filter(
          kinds: [8], authors: [serverPubkey], since: commonMessageUntil);
      subscriptions[relay] = [f];
    }

    badgeSubscription = Connect.sharedInstance.addSubscriptions(subscriptions,
        eventCallBack: (event, relay) async {
      Relays.sharedInstance.setCommonMessageUntil(event.createdAt, relay);
      BadgeAward? badgeAward = Nip58.getBadgeAward(event);
      if (badgeAward != null) {
        BadgeDBISAR? badgeDB = _get0xchatBadgeInfo(badgeAward.identifies);
        if (badgeDB != null) {
          // save to DB
          BadgeAwardDBISAR badgeAwardDB = badgeAwardToBadgeAwardDB(badgeAward);
          badgeAwardDB.badgeId = badgeDB.badgeID;
          await saveBadgeAwardDB(badgeAwardDB);
          // cache to user DB
          await _addUserBadgeToDB(badgeAwardDB.badgeOwner, badgeDB.badgeID);
        }
      }
    });
  }

  BadgeDBISAR? _get0xchatBadgeInfo(String? d) {
    return chatBadges[d];
  }

  Future<void> _loadChatBadges() async {
    final List datas = json.decode(defaultBadgesString)['data'];
    for (var data in datas) {
      BadgeDBISAR badgeDB = BadgeDBISAR(
          badgeID: data['badgeId'],
          name: data['badgeName'],
          description: data['description'],
          image: data['badgeImageUrl'],
          thumb: data['thumbUrl'],
          creator: serverPubkey,
          d: data['identifies']);
      chatBadges[badgeDB.d] = badgeDB;
      badgeInfos[badgeDB.badgeID] = badgeDB;
      saveBadgeToDB(badgeDB);
    }
  }

  static BadgeDBISAR _badgeToBadgeDB(Badge badge) {
    return BadgeDBISAR(
        badgeID: badge.badgeId,
        d: badge.identifies,
        name: badge.name,
        description: badge.description,
        image: badge.image.url,
        thumb: badge.thumb.url,
        creator: badge.creator,
        createTime: badge.createTime);
  }

  static Future<List<BadgeDBISAR>> getBadgesInfoFromRelay(
      List<String> ids) async {
    Completer<List<BadgeDBISAR>> completer = Completer<List<BadgeDBISAR>>();

    Filter f = Filter(ids: ids);
    List<BadgeDBISAR> badges = [];
    Connect.sharedInstance.addSubscription([f],
        eventCallBack: (event, relay) async {
      if (event.kind == 30009) {
        Badge? badge = Nip58.getBadgeDefinition(event);
        if (badge != null) {
          BadgeDBISAR badgeDB = _badgeToBadgeDB(badge);
          badges.add(badgeDB);
          saveBadgeToDB(badgeDB);
        }
      } else if (event.kind == 8) {
        BadgeAward? badgeAward = Nip58.getBadgeAward(event);
        if (badgeAward != null) {
          BadgeAwardDBISAR badgeAwardDB = badgeAwardToBadgeAwardDB(badgeAward);
          saveBadgeAwardDB(badgeAwardDB);
          BadgeDBISAR? badgeDB =
              BadgesHelper.sharedInstance.chatBadges[badgeAward.identifies];
          if (badgeDB != null) {
            badges.add(badgeDB);
            saveBadgeToDB(badgeDB);
          }
        }
      }
    }, eoseCallBack: (requestId, status, relay, unRelays) {
      if (unRelays.isEmpty) {
        if (!completer.isCompleted) completer.complete(badges);
      }
    });
    return completer.future;
  }

  static Future<List<BadgeDBISAR>> searchBadgesInfoFromRelay(
      List<BadgeAward> awards) async {
    Completer<List<BadgeDBISAR>> completer = Completer<List<BadgeDBISAR>>();

    List<BadgeDBISAR> result = [];
    for (BadgeAward award in awards) {
      BadgeDBISAR? badgeDB =
          await _searchBadgeFromRelay(award.creator!, award.identifies!);
      if (badgeDB != null) {
        result.add(badgeDB);
        if (awards.last == award) {
          if (!completer.isCompleted) completer.complete(result);
        }
      }
    }
    return completer.future;
  }

  static Future<BadgeDBISAR?> _searchBadgeFromRelay(
      String creator, String identifies) async {
    Completer<BadgeDBISAR?> completer = Completer<BadgeDBISAR?>();

    Filter f = Filter(kinds: [30009], d: [identifies], authors: [creator]);
    Badge? badge;
    Connect.sharedInstance.addSubscription([f],
        eventCallBack: (event, relay) async {
      badge = Nip58.getBadgeDefinition(event);
    }, eoseCallBack: (requestId, status, relay, unRelays) {
      if (unRelays.isEmpty && badge != null) {
        BadgeDBISAR badgeDB = _badgeToBadgeDB(badge!);
        saveBadgeToDB(badgeDB);
        if (!completer.isCompleted) completer.complete(badgeDB);
      } else {
        if (!completer.isCompleted) completer.complete(null);
      }
    });
    return completer.future;
  }

  static Future<void> saveBadgeToDB(BadgeDBISAR badgeDB) async {
    await DBISAR.sharedInstance.saveToDB(badgeDB);
    BadgesHelper.sharedInstance.badgeInfos[badgeDB.badgeID] = badgeDB;
  }

  static Future<List<BadgeDBISAR?>> getBadgeInfosFromDB(
      List<String> badgeIds) async {
    List<BadgeDBISAR?> result = [];
    for (var badgeId in badgeIds) {
      if (BadgesHelper.sharedInstance.badgeInfos.containsKey(badgeId)) {
        result.add(BadgesHelper.sharedInstance.badgeInfos[badgeId]);
      } else {
        final isar = DBISAR.sharedInstance.isar;
        BadgeDBISAR? badgeDBISAR = await isar.badgeDBISARs
            .filter()
            .badgeIDEqualTo(badgeId)
            .findFirst();
        if (badgeDBISAR != null) {
          BadgesHelper.sharedInstance.badgeInfos[badgeId] = badgeDBISAR;
          result.add(badgeDBISAR);
        }
      }
    }
    return result;
  }

  static Future<List<BadgeAwardDBISAR?>> getBadgeAwardInfosFromDB(
      List<String> badgeIds, String owner) async {
    List<BadgeAwardDBISAR?> result = [];
    for (var badgeId in badgeIds) {
      final badgeAwardDB =
          await searchBadgeAwardDB(badgeId: badgeId, badgeOwner: owner);
      if (badgeAwardDB != null) result.add(badgeAwardDB);
    }
    return result;
  }

  static Future<List<BadgeDBISAR>> searchBadgeInfosFromDB(
      List<BadgeAward> awards) async {
    List<BadgeDBISAR> result = [];
    for (BadgeAward badgeAward in awards) {
      final isar = DBISAR.sharedInstance.isar;
      BadgeDBISAR? badgeDBISAR = await isar.badgeDBISARs
          .filter()
          .creatorEqualTo(badgeAward.creator ?? '')
          .dEqualTo(badgeAward.identifies ?? '')
          .findFirst();
      if (badgeDBISAR != null) {
        result.add(badgeDBISAR);
      }
    }
    return result;
  }

  /// badge award
  Future<List<BadgeAwardDBISAR?>?> getUserBadgeAwardsFromRelay(
      String userPubkey, BadgeAwardDBsCallBack? callback) async {
    Completer<List<BadgeAwardDBISAR?>?> completer =
        Completer<List<BadgeAwardDBISAR?>?>();
    List<BadgeAwardDBISAR> badgeAwardsDB =
        await getUserBadgesFromDB(userPubkey);
    Filter f = Filter(kinds: [8], p: [userPubkey]);
    Connect.sharedInstance.addSubscription([f],
        eventCallBack: (event, relay) async {
          BadgeAward? badgeAward = Nip58.getBadgeAward(event);
          if (badgeAward != null) {
            BadgeDBISAR? badgeDB = _get0xchatBadgeInfo(badgeAward.identifies);
            if (badgeDB != null) {
              // save to DB
              BadgeAwardDBISAR badgeAwardDB =
              badgeAwardToBadgeAwardDB(badgeAward);
              badgeAwardDB.badgeId = badgeDB.badgeID;
              var exists = badgeAwardsDB.any(
                      (badgeAward) => badgeAward.badgeId == badgeAwardDB.badgeId);
              if (!exists) {
                badgeAwardsDB.add(badgeAwardDB);
                saveBadgeAwardDB(badgeAwardDB);
                callback?.call(badgeAwardsDB);
              }
            }
          }
    }, eoseCallBack: (requestId, status, relay, unRelays) async {
      if (unRelays.isEmpty) {
        // cache to DB
        await syncUserBadgesToDB(
            userPubkey, badgeAwardsDB.map((e) => e.badgeId).toList());
        if (!completer.isCompleted) completer.complete(badgeAwardsDB);
      }
    });
    return completer.future;
  }

  static Future<BadgeAwardDBISAR?> getBadgeAwardFromDB(
      String identifies, String creator, String badgeOwner) async {
    return await searchBadgeAwardDB(
        identifies: identifies, creator: creator, badgeOwner: badgeOwner);
  }

  // return badge id list
  static Future<List<String>?> getProfileBadgesFromDB(String userPubkey) async {
    UserDBISAR? userDB = await Account.sharedInstance.getUserInfo(userPubkey);
    if (userDB != null && userDB.badges != null && userDB.badges!.isNotEmpty) {
      return jsonDecode(userDB.badges!);
    }
    return null;
  }

  static Future<void> syncProfileBadgesToDB(
      String userPubkey, List<String> profileBadges) async {
    UserDBISAR? userDB = await Account.sharedInstance.getUserInfo(userPubkey);
    if (userDB != null && profileBadges.isNotEmpty) {
      userDB.badges = jsonEncode(profileBadges);
      await Account.saveUserToDB(userDB);
    }
  }

  static Future<List<BadgeAwardDBISAR>> getUserBadgesFromDB(
      String userPubkey) async {
    final isar = DBISAR.sharedInstance.isar;
    var query = isar.badgeAwardDBISARs.filter().badgeOwnerEqualTo(userPubkey);
    return await query.findAll();
  }

  static BadgeAwardDBISAR badgeAwardToBadgeAwardDB(BadgeAward award) {
    return BadgeAwardDBISAR(
        awardId: award.awardId,
        awardTime: award.awardTime ?? 0,
        identifies: award.identifies ?? '',
        creator: award.creator ?? '',
        relay: award.relay ?? '',
        badgeOwner: award.users != null ? award.users![0].pubkey : '');
  }

  static Future<void> syncUserBadgesToDB(
      String userPubkey, List<String> badges) async {
    UserDBISAR? userDB = await Account.sharedInstance.getUserInfo(userPubkey);
    if (userDB != null && badges.isNotEmpty) {
      userDB.badgesList = badges;
      await Account.saveUserToDB(userDB);
    }
  }

  static Future<void> _addUserBadgeToDB(
      String userPubkey, String addBadge) async {
    UserDBISAR? userDB = await Account.sharedInstance.getUserInfo(userPubkey);
    if (userDB != null && addBadge.isNotEmpty) {
      if (userDB.badgesList != null && !userDB.badgesList!.contains(addBadge)) {
        userDB.badgesList!.add(addBadge);
        await Account.saveUserToDB(userDB);
      } else if (userDB.badgesList == null) {
        userDB.badgesList = [addBadge];
        await Account.saveUserToDB(userDB);
      }
    }
  }

  static Future<OKEvent> setProfileBadges(List<String> badgeIds) async {
    Completer<OKEvent> completer = Completer<OKEvent>();

    List<BadgeDBISAR?> badges = await getBadgeInfosFromDB(badgeIds);
    List<BadgeAward> badgeAwards = [];
    for (BadgeDBISAR? badgeDB in badges) {
      if (badgeDB != null) {
        BadgeAwardDBISAR? db = await getBadgeAwardFromDB(
            badgeDB.d, badgeDB.creator, Account.sharedInstance.currentPubkey);
        if (db != null) {
          BadgeAward badgeAward = BadgeAward(
              db.awardId,
              db.awardTime,
              db.identifies,
              db.creator,
              [People(db.badgeOwner, null, null, null)]);
          badgeAwards.add(badgeAward);
        }
      }
    }
    if (badgeAwards.isNotEmpty) {
      Event event = await Nip58.setProfileBadges(
          badgeAwards,
          Account.sharedInstance.currentPubkey,
          Account.sharedInstance.currentPrivkey);
      Connect.sharedInstance.sendEvent(event, sendCallBack: (ok, relay) async {
        if (ok.status) {
          addProfileBadgesToDB(badgeIds);
        }
        if (!completer.isCompleted) completer.complete(ok);
      });
    }
    return completer.future;
  }

  static Future<void> addProfileBadgesToDB(List<String> badgeIds) async {
    UserDBISAR? userDB = Account.sharedInstance.me;
    List<String> exitBadges;
    if(userDB!.badges == null || userDB.badges!.isEmpty){
      exitBadges = [];
    }
    else{
      exitBadges = List<String>.from(jsonDecode(userDB.badges!) as List<dynamic>);
    }
    Set<String> exitBadgesSet = Set.from(exitBadges);
    exitBadgesSet.addAll(badgeIds);
    userDB.badges = jsonEncode(exitBadgesSet.toList());
    await Account.saveUserToDB(userDB);
  }

  static Future<List<BadgeDBISAR?>?> getAllProfileBadgesFromRelay(
      String userPubkey) async {
    Completer<List<BadgeDBISAR?>?> completer = Completer<List<BadgeDBISAR?>?>();
    List<BadgeDBISAR?> result = [];

    Filter f =
        Filter(kinds: [30008], d: ['profile_badges'], authors: [userPubkey]);
    Connect.sharedInstance.addSubscription([f],
        eventCallBack: (event, relay) async {
      List<BadgeAward> profileBadges = Nip58.getProfileBadges(event);
      for (BadgeAward badgeAward in profileBadges) {
        List<BadgeDBISAR> badges = await searchBadgeInfosFromDB([badgeAward]);
        BadgeDBISAR? badgeDB;
        if (badges.isNotEmpty) badgeDB = badges.first;
        badgeDB ??= await _searchBadgeFromRelay(
            badgeAward.creator!, badgeAward.identifies!);
        if (badgeDB != null) {
          // save to DB
          BadgeAwardDBISAR badgeAwardDB = badgeAwardToBadgeAwardDB(badgeAward);
          badgeAwardDB.badgeId = badgeDB.badgeID;
          await saveBadgeAwardDB(badgeAwardDB);
          result.add(badgeDB);
        }
        if (profileBadges.last == badgeAward) {
          UserDBISAR? userDB =
              await Account.sharedInstance.getUserInfo(userPubkey);
          if (userDB != null) {
            userDB.badges = jsonEncode(result.map((e) => e?.badgeID).toList());
            await Account.saveUserToDB(userDB);
          }
          if (!completer.isCompleted) completer.complete(result);
        }
      }
    }, eoseCallBack: (requestId, ok, relay, unRelays) {
      if (unRelays.isEmpty) {
        if (!completer.isCompleted) completer.complete(result);
      }
    });
    return completer.future;
  }

  /// subscript Chat Badge Awards
  static void subscriptChatBadgeAwards(
      int since, String serverPubkey, BadgeAwardsCallBack? callBack) async {
    Filter f = Filter(kinds: [8], authors: [serverPubkey], since: since);
    Connect.sharedInstance.addSubscription([f],
        eventCallBack: (event, relay) async {
      BadgeAward? badgeAward = Nip58.getBadgeAward(event);
      if (badgeAward != null) {
        // cache to DB
        BadgeAwardDBISAR badgeAwardDB = badgeAwardToBadgeAwardDB(badgeAward);
        await saveBadgeAwardDB(badgeAwardDB);
        List<BadgeDBISAR> badges = await searchBadgeInfosFromDB([badgeAward]);
        if (badges.isEmpty) {
          badges = await searchBadgesInfoFromRelay([badgeAward]);
        }
        if (badges.isNotEmpty) {
          for (var p in badgeAward.users!) {
            UserDBISAR? userDB =
                await Account.sharedInstance.getUserInfo(p.pubkey);
            String badgeId = badges[0].badgeID;
            if (userDB != null && !userDB.badgesList!.contains(badgeId)) {
              userDB.badgesList!.add(badgeId);
              await Account.saveUserToDB(userDB);
            }
          }
          if (callBack != null) callBack([badgeAward]);
        }
      }
    }, eoseCallBack: (requestId, status, relay, unRelays) async {});
  }

  static Future<void> saveBadgeAwardDB(BadgeAwardDBISAR badgeAwardDB) async {
    await DBISAR.sharedInstance.saveToDB(badgeAwardDB);
  }

  static Future<BadgeAwardDBISAR?> searchBadgeAwardDB(
      {String? badgeId,
      String? badgeOwner,
      String? identifies,
      String? creator}) async {
    final isar = DBISAR.sharedInstance.isar;
    var query = isar.badgeAwardDBISARs.filter().idBetween(0, Isar.maxId);
    if (badgeOwner != null) query = query.badgeOwnerEqualTo(badgeOwner);
    if (badgeId != null) query = query.badgeIdEqualTo(badgeId);
    if (identifies != null) query = query.identifiesEqualTo(identifies);
    if (creator != null) query = query.creatorEqualTo(creator);
    return await query.findFirst();
  }
}
