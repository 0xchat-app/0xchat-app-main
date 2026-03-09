import 'dart:convert';
import 'package:nostr_core_dart/nostr.dart';
import 'package:chatcore/chat-core.dart';
import 'package:isar/isar.dart';

part 'userDB_isar.g.dart';

extension UserDBISARExtensions on UserDBISAR {
  UserDBISAR withGrowableLevels() => this
    ..channelsList = channelsList?.toList()
    ..groupsList = groupsList?.toList()
    ..relayGroupsList = relayGroupsList?.toList()
    ..badgesList = badgesList?.toList()
    ..blockedList = blockedList?.toList()
    ..followingList = followingList?.toList()
    ..followersList = followersList?.toList()
    ..relayList = relayList?.toList()
    ..dmRelayList = dmRelayList?.toList()
    ..inboxRelayList = inboxRelayList?.toList()
    ..outboxRelayList = outboxRelayList?.toList();
}

@collection
class UserDBISAR {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String pubKey;

  String? encryptedPrivKey;
  String? privkey;
  String? defaultPassword;

  String? name;
  String? nickName;
  String? mainRelay;

  /// dns, example@0xchat.com
  String? dns;

  /// zap url
  String? lnurl;

  /// profile badges
  String? badges;

  /// metadata infos
  String? gender;
  String? area;
  String? about;
  String? picture;

  String? banner;

  /// private chat
  String? aliasPubkey;
  String? toAliasPubkey;
  String? toAliasPrivkey;

  /// lists for me
  String? friendsList;
  List<String>? channelsList;
  List<String>? groupsList; // private group list
  List<String>? relayGroupsList;
  List<String>? badgesList;

  List<String>? blockedList; // blocked users list
  List<String>? blockedHashTags; // blocked hash tags
  List<String>? blockedWords; // blocked words
  List<String>? blockedThreads; // blocked threads

  List<String>? followingList;
  List<String>? followersList;
  List<String>? relayList; // relay list
  List<String>? dmRelayList; // relay list
  List<String>? inboxRelayList; // inbox relay list
  List<String>? outboxRelayList; // outbox relay list
  List<String>? searchRelayList; // search relay list (multiple selection)

  /// list updated time
  int lastFriendsListUpdatedTime;
  int lastChannelsListUpdatedTime;
  int lastGroupsListUpdatedTime;
  int lastRelayGroupsListUpdatedTime;
  int lastBadgesListUpdatedTime;
  int lastBlockListUpdatedTime;
  int lastRelayListUpdatedTime;
  int lastFollowingListUpdatedTime;
  int lastDMRelayListUpdatedTime;

  bool? mute;

  int lastUpdatedTime;

  // banner, website, display_name
  String? otherField;
  // nostr wallet connect URI
  String? nwcURI;

  // nip46
  String? remoteSignerURI;
  String? clientPrivateKey;
  String? remotePubkey;

  String? encodedKeyPackage;

  String? settings;

  UserDBISAR({
    this.pubKey = '',
    this.encryptedPrivKey = '',
    this.privkey = '',
    this.defaultPassword = '',
    this.name = '',
    this.nickName = '',
    this.mainRelay = '',
    this.dns = '',
    this.lnurl = '',
    this.badges = '',
    this.gender = '',
    this.area = '',
    this.about = '',
    this.picture = '',
    this.banner = '',
    this.aliasPubkey = '',
    this.toAliasPubkey = '',
    this.toAliasPrivkey = '',
    this.friendsList,
    this.channelsList,
    this.groupsList,
    this.relayGroupsList,
    this.badgesList,
    this.blockedList,
    this.blockedHashTags,
    this.blockedThreads,
    this.blockedWords,
    this.followersList,
    this.followingList,
    this.relayList,
    this.dmRelayList,
    this.inboxRelayList,
    this.outboxRelayList,
    this.searchRelayList,
    this.mute = false,
    this.lastUpdatedTime = 0,
    this.lastBadgesListUpdatedTime = 0,
    this.lastBlockListUpdatedTime = 0,
    this.lastChannelsListUpdatedTime = 0,
    this.lastFriendsListUpdatedTime = 0,
    this.lastGroupsListUpdatedTime = 0,
    this.lastRelayGroupsListUpdatedTime = 0,
    this.lastRelayListUpdatedTime = 0,
    this.lastFollowingListUpdatedTime = 0,
    this.lastDMRelayListUpdatedTime = 0,
    this.otherField = '{}',
    this.nwcURI,
    this.settings,
    this.clientPrivateKey,
    this.remoteSignerURI,
    this.remotePubkey,
    this.encodedKeyPackage
  });

  static UserDBISAR fromMap(Map<String, Object?> map) {
    return _userInfoFromMap(map);
  }

  static String? decodePubkey(String pubkey) {
    try {
      return Nip19.decodePubkey(pubkey);
    } catch (e) {
      return null;
    }
  }

  static String? decodePrivkey(String privkey) {
    try {
      return Nip19.decodePrivkey(privkey);
    } catch (e) {
      return null;
    }
  }

  /// nip19 encode
  @ignore
  String get encodedPubkey {
    return Nip19.encodePubkey(pubKey);
  }

  @ignore
  String get encodedPrivkey {
    if (pubKey == Account.sharedInstance.currentPubkey) {
      return Nip19.encodePrivkey(Account.sharedInstance.currentPrivkey);
    }
    return '';
  }

  @ignore
  String get shortEncodedPubkey {
    String k = encodedPubkey;
    if (k.length < 7) return k;
    final String start = k.substring(0, 6);
    final String end = k.substring(k.length - 6);

    return '$start:$end';
  }

  @ignore
  String get lnAddress {
    return lnurl?.isNotEmpty == true ? lnurl! : NpubCash.address(pubKey);
  }

  @ignore
  NostrWalletConnection? get nwc {
    return NostrWalletConnection.fromURI(nwcURI);
  }

  static List<String> decodeStringList(String list) {
    try {
      if (list.isNotEmpty && list != 'null' && list != '[]') {
        List<dynamic> result = jsonDecode(list);
        return result.map((e) => e.toString()).toList();
      }
    } catch (e) {
      return [];
    }
    return [];
  }
}

class NostrWalletConnection {
  String server; // server pubkey
  List<String> relays;
  String secret;
  String? lud16;

  NostrWalletConnection(this.server, this.relays, this.secret, this.lud16);

  static NostrWalletConnection? fromURI(String? uri) {
    if (uri != null && uri.startsWith('nostr+walletconnect://')) {
      var decodedUri = Uri.parse(uri);
      var server = decodedUri.host;
      var queryParams = decodedUri.queryParametersAll;
      var relays = queryParams['relay'] ?? [];
      var secret = queryParams['secret']?.first ?? '';
      var lud16 = queryParams['lud16']?.first;
      return NostrWalletConnection(server, relays, secret, lud16);
    }
    return null;
  }
}

UserDBISAR _userInfoFromMap(Map<String, dynamic> map) {
  return UserDBISAR(
    pubKey: map['pubKey'].toString(),
    encryptedPrivKey: map['encryptedPrivKey'].toString(),
    defaultPassword: map['defaultPassword'].toString(),
    name: map['name'].toString(),
    nickName: map['nickName'].toString(),
    mainRelay: map['mainRelay'].toString(),
    dns: map['dns'].toString(),
    lnurl: map['lnurl'].toString(),
    badges: map['badges'].toString(),
    gender: map['gender'].toString(),
    area: map['area'].toString(),
    about: map['about'].toString(),
    picture: map['picture'].toString(),
    banner: map['banner'].toString(),
    friendsList: map['friendsList'].toString(),
    channelsList: UserDBISAR.decodeStringList(map['channelsList'].toString()),
    groupsList: UserDBISAR.decodeStringList(map['groupsList'].toString()),
    relayGroupsList: UserDBISAR.decodeStringList(map['relayGroupsList'].toString()),
    badgesList: UserDBISAR.decodeStringList(map['badgesList'].toString()),
    blockedList: UserDBISAR.decodeStringList(map['blockedList'].toString()),
    followingList: UserDBISAR.decodeStringList(map['followingList'].toString()),
    followersList: UserDBISAR.decodeStringList(map['followersList'].toString()),
    relayList: UserDBISAR.decodeStringList(map['relayList'].toString()),
    dmRelayList: UserDBISAR.decodeStringList(map['dmRelayList'].toString()),
    aliasPubkey: map['aliasPubkey'],
    mute: map['mute'],
    lastUpdatedTime: map['lastUpdatedTime'],
    lastBadgesListUpdatedTime: map['lastBadgesListUpdatedTime'] ?? 0,
    lastBlockListUpdatedTime: map['lastBlockListUpdatedTime'] ?? 0,
    lastChannelsListUpdatedTime: map['lastChannelsListUpdatedTime'] ?? 0,
    lastFriendsListUpdatedTime: map['lastFriendsListUpdatedTime'] ?? 0,
    lastGroupsListUpdatedTime: map['lastGroupsListUpdatedTime'] ?? 0,
    lastRelayGroupsListUpdatedTime: map['lastRelayGroupsListUpdatedTime'] ?? 0,
    lastRelayListUpdatedTime: map['lastRelayListUpdatedTime'] ?? 0,
    lastFollowingListUpdatedTime: map['lastRelayListUpdatedTime'] ?? 0,
    lastDMRelayListUpdatedTime: map['lastDMRelayListUpdatedTime'] ?? 0,
    otherField: map['otherField']?.toString(),
    nwcURI: map['nwcURI']?.toString(),
    settings: map['settings']?.toString(),
  );
}
