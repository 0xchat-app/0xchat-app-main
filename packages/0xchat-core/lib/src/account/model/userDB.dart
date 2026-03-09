import 'dart:convert';

import 'package:nostr_core_dart/nostr.dart';
import 'package:chatcore/chat-core.dart';

@reflector
class UserDB extends DBObject {
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
  List<String>? followingList;
  List<String>? followersList;
  List<String>? relayList; // relay list
  List<String>? dmRelayList; // relay list

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

  String? settings;

  UserDB({
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
    this.followersList,
    this.followingList,
    this.relayList,
    this.dmRelayList,
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
  });

  @override
  //Map
  Map<String, Object?> toMap() {
    return _userInfoToMap(this);
  }

  static UserDB fromMap(Map<String, Object?> map) {
    return _userInfoFromMap(map);
  }

  static String? tableName() {
    return "userDB";
  }

  //primaryKey
  static List<String?> primaryKey() {
    return ['pubKey'];
  }

  //'ALTER TABLE Company ADD description TEXT'
  static Map<String, String?> updateTable() {
    return {
      "1": '''alter table userDB add otherField TEXT;''',
      "3":
          '''alter table userDB add lastBadgesListUpdatedTime INT; alter table userDB add lastBlockListUpdatedTime INT; alter table userDB add lastChannelsListUpdatedTime INT; alter table userDB add lastFriendsListUpdatedTime INT; alter table userDB add lastGroupsListUpdatedTime INT;''',
      "5": '''alter table userDB add nwcURI TEXT;''',
      "6":
          '''alter table userDB add banner TEXT; alter table userDB add followingList TEXT; alter table userDB add followersList TEXT; alter table userDB add relayList TEXT; alter table userDB add relayGroupsList TEXT; alter table userDB add lastRelayListUpdatedTime INT;''',
      "8":
          '''alter table userDB add lastFollowingListUpdatedTime INT; alter table userDB add dmRelayList TEXT; alter table userDB add lastDMRelayListUpdatedTime INT; alter table userDB add lastRelayGroupsListUpdatedTime INT;''',
      "9": '''alter table userDB add settings TEXT;''',
    };
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
  String get encodedPubkey {
    return Nip19.encodePubkey(pubKey);
  }

  String get encodedPrivkey {
    if (pubKey == Account.sharedInstance.currentPubkey) {
      return Nip19.encodePrivkey(Account.sharedInstance.currentPrivkey);
    }
    return '';
  }

  String get shortEncodedPubkey {
    String k = encodedPubkey;
    final String start = k.substring(0, 6);
    final String end = k.substring(k.length - 6);

    return '$start:$end';
  }

  String get lnAddress {
    return lnurl?.isNotEmpty == true ? lnurl! : NpubCash.address(pubKey);
  }

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

  static Future<void> migrateToISAR() async {
    List<UserDB> users = await DB.sharedInstance.objects<UserDB>();
    List<UserDBISAR> usersISAR = [];
    for (var user in users) {
      usersISAR.add(UserDBISAR.fromMap(user.toMap()));
    }
    await DBISAR.sharedInstance.isar.writeTxn(() async {
      await DBISAR.sharedInstance.isar.userDBISARs.putAll(usersISAR);
    });
  }
}

UserDB _userInfoFromMap(Map<String, dynamic> map) {
  return UserDB(
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
    channelsList: UserDB.decodeStringList(map['channelsList'].toString()),
    groupsList: UserDB.decodeStringList(map['groupsList'].toString()),
    relayGroupsList: UserDB.decodeStringList(map['relayGroupsList'].toString()),
    badgesList: UserDB.decodeStringList(map['badgesList'].toString()),
    blockedList: UserDB.decodeStringList(map['blockedList'].toString()),
    followingList: UserDB.decodeStringList(map['followingList'].toString()),
    followersList: UserDB.decodeStringList(map['followersList'].toString()),
    relayList: UserDB.decodeStringList(map['relayList'].toString()),
    dmRelayList: UserDB.decodeStringList(map['dmRelayList'].toString()),
    aliasPubkey: map['aliasPubkey'],
    mute: map['mute'] > 0 ? true : false,
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

Map<String, dynamic> _userInfoToMap(UserDB instance) => <String, dynamic>{
      'pubKey': instance.pubKey,
      'encryptedPrivKey': instance.encryptedPrivKey,
      'defaultPassword': instance.defaultPassword,
      'name': instance.name,
      'nickName': instance.nickName,
      'mainRelay': instance.mainRelay,
      'dns': instance.dns,
      'lnurl': instance.lnurl,
      'badges': instance.badges,
      'gender': instance.gender,
      'area': instance.area,
      'about': instance.about,
      'picture': instance.picture,
      'banner': instance.banner,
      'friendsList': instance.friendsList,
      'channelsList': jsonEncode(instance.channelsList),
      'groupsList': jsonEncode(instance.groupsList),
      'relayGroupsList': jsonEncode(instance.relayGroupsList),
      'badgesList': jsonEncode(instance.badgesList),
      'blockedList': jsonEncode(instance.blockedList),
      'followersList': jsonEncode(instance.followersList),
      'followingList': jsonEncode(instance.followingList),
      'relayList': jsonEncode(instance.relayList),
      'dmRelayList': jsonEncode(instance.dmRelayList),
      'aliasPubkey': instance.aliasPubkey,
      'mute': instance.mute,
      'lastUpdatedTime': instance.lastUpdatedTime,
      'lastBadgesListUpdatedTime': instance.lastBadgesListUpdatedTime,
      'lastBlockListUpdatedTime': instance.lastBlockListUpdatedTime,
      'lastChannelsListUpdatedTime': instance.lastChannelsListUpdatedTime,
      'lastFriendsListUpdatedTime': instance.lastFriendsListUpdatedTime,
      'lastGroupsListUpdatedTime': instance.lastGroupsListUpdatedTime,
      'lastRelayGroupsListUpdatedTime': instance.lastRelayGroupsListUpdatedTime,
      'lastRelayListUpdatedTime': instance.lastRelayListUpdatedTime,
      'lastFollowingListUpdatedTime': instance.lastFollowingListUpdatedTime,
      'lastDMRelayListUpdatedTime': instance.lastDMRelayListUpdatedTime,
      'otherField': instance.otherField,
      'nwcURI': instance.nwcURI,
      'settings': instance.settings
    };
