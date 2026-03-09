// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userDB_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserDBISARCollection on Isar {
  IsarCollection<UserDBISAR> get userDBISARs => this.collection();
}

const UserDBISARSchema = CollectionSchema(
  name: r'UserDBISAR',
  id: 3624421458299562443,
  properties: {
    r'about': PropertySchema(
      id: 0,
      name: r'about',
      type: IsarType.string,
    ),
    r'aliasPubkey': PropertySchema(
      id: 1,
      name: r'aliasPubkey',
      type: IsarType.string,
    ),
    r'area': PropertySchema(
      id: 2,
      name: r'area',
      type: IsarType.string,
    ),
    r'badges': PropertySchema(
      id: 3,
      name: r'badges',
      type: IsarType.string,
    ),
    r'badgesList': PropertySchema(
      id: 4,
      name: r'badgesList',
      type: IsarType.stringList,
    ),
    r'banner': PropertySchema(
      id: 5,
      name: r'banner',
      type: IsarType.string,
    ),
    r'blockedHashTags': PropertySchema(
      id: 6,
      name: r'blockedHashTags',
      type: IsarType.stringList,
    ),
    r'blockedList': PropertySchema(
      id: 7,
      name: r'blockedList',
      type: IsarType.stringList,
    ),
    r'blockedThreads': PropertySchema(
      id: 8,
      name: r'blockedThreads',
      type: IsarType.stringList,
    ),
    r'blockedWords': PropertySchema(
      id: 9,
      name: r'blockedWords',
      type: IsarType.stringList,
    ),
    r'channelsList': PropertySchema(
      id: 10,
      name: r'channelsList',
      type: IsarType.stringList,
    ),
    r'clientPrivateKey': PropertySchema(
      id: 11,
      name: r'clientPrivateKey',
      type: IsarType.string,
    ),
    r'defaultPassword': PropertySchema(
      id: 12,
      name: r'defaultPassword',
      type: IsarType.string,
    ),
    r'dmRelayList': PropertySchema(
      id: 13,
      name: r'dmRelayList',
      type: IsarType.stringList,
    ),
    r'dns': PropertySchema(
      id: 14,
      name: r'dns',
      type: IsarType.string,
    ),
    r'encodedKeyPackage': PropertySchema(
      id: 15,
      name: r'encodedKeyPackage',
      type: IsarType.string,
    ),
    r'encryptedPrivKey': PropertySchema(
      id: 16,
      name: r'encryptedPrivKey',
      type: IsarType.string,
    ),
    r'followersList': PropertySchema(
      id: 17,
      name: r'followersList',
      type: IsarType.stringList,
    ),
    r'followingList': PropertySchema(
      id: 18,
      name: r'followingList',
      type: IsarType.stringList,
    ),
    r'friendsList': PropertySchema(
      id: 19,
      name: r'friendsList',
      type: IsarType.string,
    ),
    r'gender': PropertySchema(
      id: 20,
      name: r'gender',
      type: IsarType.string,
    ),
    r'groupsList': PropertySchema(
      id: 21,
      name: r'groupsList',
      type: IsarType.stringList,
    ),
    r'inboxRelayList': PropertySchema(
      id: 22,
      name: r'inboxRelayList',
      type: IsarType.stringList,
    ),
    r'lastBadgesListUpdatedTime': PropertySchema(
      id: 23,
      name: r'lastBadgesListUpdatedTime',
      type: IsarType.long,
    ),
    r'lastBlockListUpdatedTime': PropertySchema(
      id: 24,
      name: r'lastBlockListUpdatedTime',
      type: IsarType.long,
    ),
    r'lastChannelsListUpdatedTime': PropertySchema(
      id: 25,
      name: r'lastChannelsListUpdatedTime',
      type: IsarType.long,
    ),
    r'lastDMRelayListUpdatedTime': PropertySchema(
      id: 26,
      name: r'lastDMRelayListUpdatedTime',
      type: IsarType.long,
    ),
    r'lastFollowingListUpdatedTime': PropertySchema(
      id: 27,
      name: r'lastFollowingListUpdatedTime',
      type: IsarType.long,
    ),
    r'lastFriendsListUpdatedTime': PropertySchema(
      id: 28,
      name: r'lastFriendsListUpdatedTime',
      type: IsarType.long,
    ),
    r'lastGroupsListUpdatedTime': PropertySchema(
      id: 29,
      name: r'lastGroupsListUpdatedTime',
      type: IsarType.long,
    ),
    r'lastRelayGroupsListUpdatedTime': PropertySchema(
      id: 30,
      name: r'lastRelayGroupsListUpdatedTime',
      type: IsarType.long,
    ),
    r'lastRelayListUpdatedTime': PropertySchema(
      id: 31,
      name: r'lastRelayListUpdatedTime',
      type: IsarType.long,
    ),
    r'lastUpdatedTime': PropertySchema(
      id: 32,
      name: r'lastUpdatedTime',
      type: IsarType.long,
    ),
    r'lnurl': PropertySchema(
      id: 33,
      name: r'lnurl',
      type: IsarType.string,
    ),
    r'mainRelay': PropertySchema(
      id: 34,
      name: r'mainRelay',
      type: IsarType.string,
    ),
    r'mute': PropertySchema(
      id: 35,
      name: r'mute',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 36,
      name: r'name',
      type: IsarType.string,
    ),
    r'nickName': PropertySchema(
      id: 37,
      name: r'nickName',
      type: IsarType.string,
    ),
    r'nwcURI': PropertySchema(
      id: 38,
      name: r'nwcURI',
      type: IsarType.string,
    ),
    r'otherField': PropertySchema(
      id: 39,
      name: r'otherField',
      type: IsarType.string,
    ),
    r'outboxRelayList': PropertySchema(
      id: 40,
      name: r'outboxRelayList',
      type: IsarType.stringList,
    ),
    r'picture': PropertySchema(
      id: 41,
      name: r'picture',
      type: IsarType.string,
    ),
    r'privkey': PropertySchema(
      id: 42,
      name: r'privkey',
      type: IsarType.string,
    ),
    r'pubKey': PropertySchema(
      id: 43,
      name: r'pubKey',
      type: IsarType.string,
    ),
    r'relayGroupsList': PropertySchema(
      id: 44,
      name: r'relayGroupsList',
      type: IsarType.stringList,
    ),
    r'relayList': PropertySchema(
      id: 45,
      name: r'relayList',
      type: IsarType.stringList,
    ),
    r'remotePubkey': PropertySchema(
      id: 46,
      name: r'remotePubkey',
      type: IsarType.string,
    ),
    r'remoteSignerURI': PropertySchema(
      id: 47,
      name: r'remoteSignerURI',
      type: IsarType.string,
    ),
    r'searchRelayList': PropertySchema(
      id: 48,
      name: r'searchRelayList',
      type: IsarType.stringList,
    ),
    r'settings': PropertySchema(
      id: 49,
      name: r'settings',
      type: IsarType.string,
    ),
    r'toAliasPrivkey': PropertySchema(
      id: 50,
      name: r'toAliasPrivkey',
      type: IsarType.string,
    ),
    r'toAliasPubkey': PropertySchema(
      id: 51,
      name: r'toAliasPubkey',
      type: IsarType.string,
    )
  },
  estimateSize: _userDBISAREstimateSize,
  serialize: _userDBISARSerialize,
  deserialize: _userDBISARDeserialize,
  deserializeProp: _userDBISARDeserializeProp,
  idName: r'id',
  indexes: {
    r'pubKey': IndexSchema(
      id: -1355330614492892055,
      name: r'pubKey',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'pubKey',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _userDBISARGetId,
  getLinks: _userDBISARGetLinks,
  attach: _userDBISARAttach,
  version: '3.1.0+1',
);

int _userDBISAREstimateSize(
  UserDBISAR object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.about;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.aliasPubkey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.area;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.badges;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.badgesList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final value = object.banner;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.blockedHashTags;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final list = object.blockedList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final list = object.blockedThreads;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final list = object.blockedWords;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final list = object.channelsList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final value = object.clientPrivateKey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.defaultPassword;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.dmRelayList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final value = object.dns;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.encodedKeyPackage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.encryptedPrivKey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.followersList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final list = object.followingList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final value = object.friendsList;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.gender;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.groupsList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final list = object.inboxRelayList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final value = object.lnurl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.mainRelay;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.nickName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.nwcURI;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.otherField;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.outboxRelayList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final value = object.picture;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.privkey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.pubKey.length * 3;
  {
    final list = object.relayGroupsList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final list = object.relayList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final value = object.remotePubkey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.remoteSignerURI;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.searchRelayList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final value = object.settings;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.toAliasPrivkey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.toAliasPubkey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _userDBISARSerialize(
  UserDBISAR object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.about);
  writer.writeString(offsets[1], object.aliasPubkey);
  writer.writeString(offsets[2], object.area);
  writer.writeString(offsets[3], object.badges);
  writer.writeStringList(offsets[4], object.badgesList);
  writer.writeString(offsets[5], object.banner);
  writer.writeStringList(offsets[6], object.blockedHashTags);
  writer.writeStringList(offsets[7], object.blockedList);
  writer.writeStringList(offsets[8], object.blockedThreads);
  writer.writeStringList(offsets[9], object.blockedWords);
  writer.writeStringList(offsets[10], object.channelsList);
  writer.writeString(offsets[11], object.clientPrivateKey);
  writer.writeString(offsets[12], object.defaultPassword);
  writer.writeStringList(offsets[13], object.dmRelayList);
  writer.writeString(offsets[14], object.dns);
  writer.writeString(offsets[15], object.encodedKeyPackage);
  writer.writeString(offsets[16], object.encryptedPrivKey);
  writer.writeStringList(offsets[17], object.followersList);
  writer.writeStringList(offsets[18], object.followingList);
  writer.writeString(offsets[19], object.friendsList);
  writer.writeString(offsets[20], object.gender);
  writer.writeStringList(offsets[21], object.groupsList);
  writer.writeStringList(offsets[22], object.inboxRelayList);
  writer.writeLong(offsets[23], object.lastBadgesListUpdatedTime);
  writer.writeLong(offsets[24], object.lastBlockListUpdatedTime);
  writer.writeLong(offsets[25], object.lastChannelsListUpdatedTime);
  writer.writeLong(offsets[26], object.lastDMRelayListUpdatedTime);
  writer.writeLong(offsets[27], object.lastFollowingListUpdatedTime);
  writer.writeLong(offsets[28], object.lastFriendsListUpdatedTime);
  writer.writeLong(offsets[29], object.lastGroupsListUpdatedTime);
  writer.writeLong(offsets[30], object.lastRelayGroupsListUpdatedTime);
  writer.writeLong(offsets[31], object.lastRelayListUpdatedTime);
  writer.writeLong(offsets[32], object.lastUpdatedTime);
  writer.writeString(offsets[33], object.lnurl);
  writer.writeString(offsets[34], object.mainRelay);
  writer.writeBool(offsets[35], object.mute);
  writer.writeString(offsets[36], object.name);
  writer.writeString(offsets[37], object.nickName);
  writer.writeString(offsets[38], object.nwcURI);
  writer.writeString(offsets[39], object.otherField);
  writer.writeStringList(offsets[40], object.outboxRelayList);
  writer.writeString(offsets[41], object.picture);
  writer.writeString(offsets[42], object.privkey);
  writer.writeString(offsets[43], object.pubKey);
  writer.writeStringList(offsets[44], object.relayGroupsList);
  writer.writeStringList(offsets[45], object.relayList);
  writer.writeString(offsets[46], object.remotePubkey);
  writer.writeString(offsets[47], object.remoteSignerURI);
  writer.writeStringList(offsets[48], object.searchRelayList);
  writer.writeString(offsets[49], object.settings);
  writer.writeString(offsets[50], object.toAliasPrivkey);
  writer.writeString(offsets[51], object.toAliasPubkey);
}

UserDBISAR _userDBISARDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserDBISAR(
    about: reader.readStringOrNull(offsets[0]),
    aliasPubkey: reader.readStringOrNull(offsets[1]),
    area: reader.readStringOrNull(offsets[2]),
    badges: reader.readStringOrNull(offsets[3]),
    badgesList: reader.readStringList(offsets[4]),
    banner: reader.readStringOrNull(offsets[5]),
    blockedHashTags: reader.readStringList(offsets[6]),
    blockedList: reader.readStringList(offsets[7]),
    blockedThreads: reader.readStringList(offsets[8]),
    blockedWords: reader.readStringList(offsets[9]),
    channelsList: reader.readStringList(offsets[10]),
    clientPrivateKey: reader.readStringOrNull(offsets[11]),
    defaultPassword: reader.readStringOrNull(offsets[12]),
    dmRelayList: reader.readStringList(offsets[13]),
    dns: reader.readStringOrNull(offsets[14]),
    encodedKeyPackage: reader.readStringOrNull(offsets[15]),
    encryptedPrivKey: reader.readStringOrNull(offsets[16]),
    followersList: reader.readStringList(offsets[17]),
    followingList: reader.readStringList(offsets[18]),
    friendsList: reader.readStringOrNull(offsets[19]),
    gender: reader.readStringOrNull(offsets[20]),
    groupsList: reader.readStringList(offsets[21]),
    inboxRelayList: reader.readStringList(offsets[22]),
    lastBadgesListUpdatedTime: reader.readLongOrNull(offsets[23]) ?? 0,
    lastBlockListUpdatedTime: reader.readLongOrNull(offsets[24]) ?? 0,
    lastChannelsListUpdatedTime: reader.readLongOrNull(offsets[25]) ?? 0,
    lastDMRelayListUpdatedTime: reader.readLongOrNull(offsets[26]) ?? 0,
    lastFollowingListUpdatedTime: reader.readLongOrNull(offsets[27]) ?? 0,
    lastFriendsListUpdatedTime: reader.readLongOrNull(offsets[28]) ?? 0,
    lastGroupsListUpdatedTime: reader.readLongOrNull(offsets[29]) ?? 0,
    lastRelayGroupsListUpdatedTime: reader.readLongOrNull(offsets[30]) ?? 0,
    lastRelayListUpdatedTime: reader.readLongOrNull(offsets[31]) ?? 0,
    lastUpdatedTime: reader.readLongOrNull(offsets[32]) ?? 0,
    lnurl: reader.readStringOrNull(offsets[33]),
    mainRelay: reader.readStringOrNull(offsets[34]),
    mute: reader.readBoolOrNull(offsets[35]),
    name: reader.readStringOrNull(offsets[36]),
    nickName: reader.readStringOrNull(offsets[37]),
    nwcURI: reader.readStringOrNull(offsets[38]),
    otherField: reader.readStringOrNull(offsets[39]),
    outboxRelayList: reader.readStringList(offsets[40]),
    picture: reader.readStringOrNull(offsets[41]),
    privkey: reader.readStringOrNull(offsets[42]),
    pubKey: reader.readStringOrNull(offsets[43]) ?? '',
    relayGroupsList: reader.readStringList(offsets[44]),
    relayList: reader.readStringList(offsets[45]),
    remotePubkey: reader.readStringOrNull(offsets[46]),
    remoteSignerURI: reader.readStringOrNull(offsets[47]),
    searchRelayList: reader.readStringList(offsets[48]),
    settings: reader.readStringOrNull(offsets[49]),
    toAliasPrivkey: reader.readStringOrNull(offsets[50]),
    toAliasPubkey: reader.readStringOrNull(offsets[51]),
  );
  object.id = id;
  return object;
}

P _userDBISARDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringList(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringList(offset)) as P;
    case 7:
      return (reader.readStringList(offset)) as P;
    case 8:
      return (reader.readStringList(offset)) as P;
    case 9:
      return (reader.readStringList(offset)) as P;
    case 10:
      return (reader.readStringList(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readStringList(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readStringList(offset)) as P;
    case 18:
      return (reader.readStringList(offset)) as P;
    case 19:
      return (reader.readStringOrNull(offset)) as P;
    case 20:
      return (reader.readStringOrNull(offset)) as P;
    case 21:
      return (reader.readStringList(offset)) as P;
    case 22:
      return (reader.readStringList(offset)) as P;
    case 23:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 24:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 25:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 26:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 27:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 28:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 29:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 30:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 31:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 32:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 33:
      return (reader.readStringOrNull(offset)) as P;
    case 34:
      return (reader.readStringOrNull(offset)) as P;
    case 35:
      return (reader.readBoolOrNull(offset)) as P;
    case 36:
      return (reader.readStringOrNull(offset)) as P;
    case 37:
      return (reader.readStringOrNull(offset)) as P;
    case 38:
      return (reader.readStringOrNull(offset)) as P;
    case 39:
      return (reader.readStringOrNull(offset)) as P;
    case 40:
      return (reader.readStringList(offset)) as P;
    case 41:
      return (reader.readStringOrNull(offset)) as P;
    case 42:
      return (reader.readStringOrNull(offset)) as P;
    case 43:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 44:
      return (reader.readStringList(offset)) as P;
    case 45:
      return (reader.readStringList(offset)) as P;
    case 46:
      return (reader.readStringOrNull(offset)) as P;
    case 47:
      return (reader.readStringOrNull(offset)) as P;
    case 48:
      return (reader.readStringList(offset)) as P;
    case 49:
      return (reader.readStringOrNull(offset)) as P;
    case 50:
      return (reader.readStringOrNull(offset)) as P;
    case 51:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userDBISARGetId(UserDBISAR object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userDBISARGetLinks(UserDBISAR object) {
  return [];
}

void _userDBISARAttach(IsarCollection<dynamic> col, Id id, UserDBISAR object) {
  object.id = id;
}

extension UserDBISARByIndex on IsarCollection<UserDBISAR> {
  Future<UserDBISAR?> getByPubKey(String pubKey) {
    return getByIndex(r'pubKey', [pubKey]);
  }

  UserDBISAR? getByPubKeySync(String pubKey) {
    return getByIndexSync(r'pubKey', [pubKey]);
  }

  Future<bool> deleteByPubKey(String pubKey) {
    return deleteByIndex(r'pubKey', [pubKey]);
  }

  bool deleteByPubKeySync(String pubKey) {
    return deleteByIndexSync(r'pubKey', [pubKey]);
  }

  Future<List<UserDBISAR?>> getAllByPubKey(List<String> pubKeyValues) {
    final values = pubKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'pubKey', values);
  }

  List<UserDBISAR?> getAllByPubKeySync(List<String> pubKeyValues) {
    final values = pubKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'pubKey', values);
  }

  Future<int> deleteAllByPubKey(List<String> pubKeyValues) {
    final values = pubKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'pubKey', values);
  }

  int deleteAllByPubKeySync(List<String> pubKeyValues) {
    final values = pubKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'pubKey', values);
  }

  Future<Id> putByPubKey(UserDBISAR object) {
    return putByIndex(r'pubKey', object);
  }

  Id putByPubKeySync(UserDBISAR object, {bool saveLinks = true}) {
    return putByIndexSync(r'pubKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPubKey(List<UserDBISAR> objects) {
    return putAllByIndex(r'pubKey', objects);
  }

  List<Id> putAllByPubKeySync(List<UserDBISAR> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'pubKey', objects, saveLinks: saveLinks);
  }
}

extension UserDBISARQueryWhereSort
    on QueryBuilder<UserDBISAR, UserDBISAR, QWhere> {
  QueryBuilder<UserDBISAR, UserDBISAR, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserDBISARQueryWhere
    on QueryBuilder<UserDBISAR, UserDBISAR, QWhereClause> {
  QueryBuilder<UserDBISAR, UserDBISAR, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterWhereClause> pubKeyEqualTo(
      String pubKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'pubKey',
        value: [pubKey],
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterWhereClause> pubKeyNotEqualTo(
      String pubKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pubKey',
              lower: [],
              upper: [pubKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pubKey',
              lower: [pubKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pubKey',
              lower: [pubKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pubKey',
              lower: [],
              upper: [pubKey],
              includeUpper: false,
            ));
      }
    });
  }
}

extension UserDBISARQueryFilter
    on QueryBuilder<UserDBISAR, UserDBISAR, QFilterCondition> {
  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> aboutIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'about',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> aboutIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'about',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> aboutEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'about',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> aboutGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'about',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> aboutLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'about',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> aboutBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'about',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> aboutStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'about',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> aboutEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'about',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> aboutContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'about',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> aboutMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'about',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> aboutIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'about',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      aboutIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'about',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      aliasPubkeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'aliasPubkey',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      aliasPubkeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'aliasPubkey',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      aliasPubkeyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aliasPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      aliasPubkeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'aliasPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      aliasPubkeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'aliasPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      aliasPubkeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'aliasPubkey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      aliasPubkeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'aliasPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      aliasPubkeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'aliasPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      aliasPubkeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'aliasPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      aliasPubkeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'aliasPubkey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      aliasPubkeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aliasPubkey',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      aliasPubkeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'aliasPubkey',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> areaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'area',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> areaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'area',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> areaEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'area',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> areaGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'area',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> areaLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'area',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> areaBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'area',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> areaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'area',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> areaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'area',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> areaContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'area',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> areaMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'area',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> areaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'area',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> areaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'area',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> badgesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'badges',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      badgesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'badges',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> badgesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'badges',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> badgesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'badges',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> badgesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'badges',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> badgesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'badges',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> badgesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'badges',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> badgesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'badges',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> badgesContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'badges',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> badgesMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'badges',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> badgesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'badges',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      badgesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'badges',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      badgesListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'badgesList',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      badgesListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'badgesList',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      badgesListElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'badgesList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      badgesListElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'badgesList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      badgesListElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'badgesList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      badgesListElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'badgesList',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      badgesListElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'badgesList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      badgesListElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'badgesList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      badgesListElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'badgesList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      badgesListElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'badgesList',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      badgesListElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'badgesList',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      badgesListElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'badgesList',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      badgesListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'badgesList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      badgesListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'badgesList',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      badgesListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'badgesList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      badgesListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'badgesList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      badgesListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'badgesList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      badgesListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'badgesList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> bannerIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'banner',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      bannerIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'banner',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> bannerEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'banner',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> bannerGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'banner',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> bannerLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'banner',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> bannerBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'banner',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> bannerStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'banner',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> bannerEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'banner',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> bannerContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'banner',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> bannerMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'banner',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> bannerIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'banner',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      bannerIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'banner',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedHashTagsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'blockedHashTags',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedHashTagsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'blockedHashTags',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedHashTagsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'blockedHashTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedHashTagsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'blockedHashTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedHashTagsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'blockedHashTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedHashTagsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'blockedHashTags',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedHashTagsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'blockedHashTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedHashTagsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'blockedHashTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedHashTagsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'blockedHashTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedHashTagsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'blockedHashTags',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedHashTagsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'blockedHashTags',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedHashTagsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'blockedHashTags',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedHashTagsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blockedHashTags',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedHashTagsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blockedHashTags',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedHashTagsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blockedHashTags',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedHashTagsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blockedHashTags',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedHashTagsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blockedHashTags',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedHashTagsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blockedHashTags',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'blockedList',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'blockedList',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedListElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'blockedList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedListElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'blockedList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedListElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'blockedList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedListElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'blockedList',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedListElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'blockedList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedListElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'blockedList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedListElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'blockedList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedListElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'blockedList',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedListElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'blockedList',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedListElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'blockedList',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blockedList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blockedList',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blockedList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blockedList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blockedList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blockedList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedThreadsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'blockedThreads',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedThreadsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'blockedThreads',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedThreadsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'blockedThreads',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedThreadsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'blockedThreads',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedThreadsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'blockedThreads',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedThreadsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'blockedThreads',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedThreadsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'blockedThreads',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedThreadsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'blockedThreads',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedThreadsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'blockedThreads',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedThreadsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'blockedThreads',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedThreadsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'blockedThreads',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedThreadsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'blockedThreads',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedThreadsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blockedThreads',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedThreadsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blockedThreads',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedThreadsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blockedThreads',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedThreadsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blockedThreads',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedThreadsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blockedThreads',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedThreadsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blockedThreads',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedWordsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'blockedWords',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedWordsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'blockedWords',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedWordsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'blockedWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedWordsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'blockedWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedWordsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'blockedWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedWordsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'blockedWords',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedWordsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'blockedWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedWordsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'blockedWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedWordsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'blockedWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedWordsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'blockedWords',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedWordsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'blockedWords',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedWordsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'blockedWords',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedWordsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blockedWords',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedWordsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blockedWords',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedWordsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blockedWords',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedWordsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blockedWords',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedWordsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blockedWords',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      blockedWordsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blockedWords',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      channelsListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'channelsList',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      channelsListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'channelsList',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      channelsListElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'channelsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      channelsListElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'channelsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      channelsListElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'channelsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      channelsListElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'channelsList',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      channelsListElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'channelsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      channelsListElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'channelsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      channelsListElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'channelsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      channelsListElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'channelsList',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      channelsListElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'channelsList',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      channelsListElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'channelsList',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      channelsListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'channelsList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      channelsListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'channelsList',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      channelsListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'channelsList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      channelsListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'channelsList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      channelsListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'channelsList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      channelsListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'channelsList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      clientPrivateKeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'clientPrivateKey',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      clientPrivateKeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'clientPrivateKey',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      clientPrivateKeyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clientPrivateKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      clientPrivateKeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'clientPrivateKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      clientPrivateKeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'clientPrivateKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      clientPrivateKeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'clientPrivateKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      clientPrivateKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'clientPrivateKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      clientPrivateKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'clientPrivateKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      clientPrivateKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'clientPrivateKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      clientPrivateKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'clientPrivateKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      clientPrivateKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clientPrivateKey',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      clientPrivateKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'clientPrivateKey',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      defaultPasswordIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'defaultPassword',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      defaultPasswordIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'defaultPassword',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      defaultPasswordEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultPassword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      defaultPasswordGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'defaultPassword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      defaultPasswordLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'defaultPassword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      defaultPasswordBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'defaultPassword',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      defaultPasswordStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'defaultPassword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      defaultPasswordEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'defaultPassword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      defaultPasswordContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'defaultPassword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      defaultPasswordMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'defaultPassword',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      defaultPasswordIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultPassword',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      defaultPasswordIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'defaultPassword',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      dmRelayListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dmRelayList',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      dmRelayListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dmRelayList',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      dmRelayListElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dmRelayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      dmRelayListElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dmRelayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      dmRelayListElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dmRelayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      dmRelayListElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dmRelayList',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      dmRelayListElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dmRelayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      dmRelayListElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dmRelayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      dmRelayListElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dmRelayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      dmRelayListElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dmRelayList',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      dmRelayListElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dmRelayList',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      dmRelayListElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dmRelayList',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      dmRelayListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dmRelayList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      dmRelayListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dmRelayList',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      dmRelayListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dmRelayList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      dmRelayListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dmRelayList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      dmRelayListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dmRelayList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      dmRelayListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dmRelayList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> dnsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dns',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> dnsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dns',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> dnsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dns',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> dnsGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dns',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> dnsLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dns',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> dnsBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dns',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> dnsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dns',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> dnsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dns',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> dnsContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dns',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> dnsMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dns',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> dnsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dns',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> dnsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dns',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      encodedKeyPackageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'encodedKeyPackage',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      encodedKeyPackageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'encodedKeyPackage',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      encodedKeyPackageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'encodedKeyPackage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      encodedKeyPackageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'encodedKeyPackage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      encodedKeyPackageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'encodedKeyPackage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      encodedKeyPackageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'encodedKeyPackage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      encodedKeyPackageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'encodedKeyPackage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      encodedKeyPackageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'encodedKeyPackage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      encodedKeyPackageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'encodedKeyPackage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      encodedKeyPackageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'encodedKeyPackage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      encodedKeyPackageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'encodedKeyPackage',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      encodedKeyPackageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'encodedKeyPackage',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      encryptedPrivKeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'encryptedPrivKey',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      encryptedPrivKeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'encryptedPrivKey',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      encryptedPrivKeyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'encryptedPrivKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      encryptedPrivKeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'encryptedPrivKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      encryptedPrivKeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'encryptedPrivKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      encryptedPrivKeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'encryptedPrivKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      encryptedPrivKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'encryptedPrivKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      encryptedPrivKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'encryptedPrivKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      encryptedPrivKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'encryptedPrivKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      encryptedPrivKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'encryptedPrivKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      encryptedPrivKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'encryptedPrivKey',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      encryptedPrivKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'encryptedPrivKey',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followersListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'followersList',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followersListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'followersList',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followersListElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'followersList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followersListElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'followersList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followersListElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'followersList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followersListElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'followersList',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followersListElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'followersList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followersListElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'followersList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followersListElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'followersList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followersListElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'followersList',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followersListElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'followersList',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followersListElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'followersList',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followersListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'followersList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followersListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'followersList',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followersListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'followersList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followersListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'followersList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followersListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'followersList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followersListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'followersList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followingListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'followingList',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followingListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'followingList',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followingListElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'followingList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followingListElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'followingList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followingListElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'followingList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followingListElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'followingList',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followingListElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'followingList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followingListElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'followingList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followingListElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'followingList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followingListElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'followingList',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followingListElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'followingList',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followingListElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'followingList',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followingListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'followingList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followingListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'followingList',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followingListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'followingList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followingListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'followingList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followingListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'followingList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      followingListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'followingList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      friendsListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'friendsList',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      friendsListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'friendsList',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      friendsListEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'friendsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      friendsListGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'friendsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      friendsListLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'friendsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      friendsListBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'friendsList',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      friendsListStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'friendsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      friendsListEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'friendsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      friendsListContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'friendsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      friendsListMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'friendsList',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      friendsListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'friendsList',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      friendsListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'friendsList',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> genderIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'gender',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      genderIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'gender',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> genderEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> genderGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> genderLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> genderBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gender',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> genderStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> genderEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> genderContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> genderMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'gender',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> genderIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gender',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      genderIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'gender',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      groupsListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'groupsList',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      groupsListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'groupsList',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      groupsListElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      groupsListElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'groupsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      groupsListElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'groupsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      groupsListElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'groupsList',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      groupsListElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'groupsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      groupsListElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'groupsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      groupsListElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'groupsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      groupsListElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'groupsList',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      groupsListElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupsList',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      groupsListElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'groupsList',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      groupsListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'groupsList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      groupsListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'groupsList',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      groupsListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'groupsList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      groupsListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'groupsList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      groupsListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'groupsList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      groupsListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'groupsList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      inboxRelayListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'inboxRelayList',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      inboxRelayListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'inboxRelayList',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      inboxRelayListElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'inboxRelayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      inboxRelayListElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'inboxRelayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      inboxRelayListElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'inboxRelayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      inboxRelayListElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'inboxRelayList',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      inboxRelayListElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'inboxRelayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      inboxRelayListElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'inboxRelayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      inboxRelayListElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'inboxRelayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      inboxRelayListElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'inboxRelayList',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      inboxRelayListElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'inboxRelayList',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      inboxRelayListElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'inboxRelayList',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      inboxRelayListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'inboxRelayList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      inboxRelayListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'inboxRelayList',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      inboxRelayListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'inboxRelayList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      inboxRelayListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'inboxRelayList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      inboxRelayListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'inboxRelayList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      inboxRelayListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'inboxRelayList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastBadgesListUpdatedTimeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastBadgesListUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastBadgesListUpdatedTimeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastBadgesListUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastBadgesListUpdatedTimeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastBadgesListUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastBadgesListUpdatedTimeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastBadgesListUpdatedTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastBlockListUpdatedTimeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastBlockListUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastBlockListUpdatedTimeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastBlockListUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastBlockListUpdatedTimeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastBlockListUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastBlockListUpdatedTimeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastBlockListUpdatedTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastChannelsListUpdatedTimeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastChannelsListUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastChannelsListUpdatedTimeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastChannelsListUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastChannelsListUpdatedTimeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastChannelsListUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastChannelsListUpdatedTimeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastChannelsListUpdatedTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastDMRelayListUpdatedTimeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastDMRelayListUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastDMRelayListUpdatedTimeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastDMRelayListUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastDMRelayListUpdatedTimeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastDMRelayListUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastDMRelayListUpdatedTimeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastDMRelayListUpdatedTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastFollowingListUpdatedTimeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastFollowingListUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastFollowingListUpdatedTimeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastFollowingListUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastFollowingListUpdatedTimeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastFollowingListUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastFollowingListUpdatedTimeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastFollowingListUpdatedTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastFriendsListUpdatedTimeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastFriendsListUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastFriendsListUpdatedTimeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastFriendsListUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastFriendsListUpdatedTimeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastFriendsListUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastFriendsListUpdatedTimeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastFriendsListUpdatedTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastGroupsListUpdatedTimeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastGroupsListUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastGroupsListUpdatedTimeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastGroupsListUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastGroupsListUpdatedTimeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastGroupsListUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastGroupsListUpdatedTimeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastGroupsListUpdatedTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastRelayGroupsListUpdatedTimeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastRelayGroupsListUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastRelayGroupsListUpdatedTimeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastRelayGroupsListUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastRelayGroupsListUpdatedTimeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastRelayGroupsListUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastRelayGroupsListUpdatedTimeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastRelayGroupsListUpdatedTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastRelayListUpdatedTimeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastRelayListUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastRelayListUpdatedTimeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastRelayListUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastRelayListUpdatedTimeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastRelayListUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastRelayListUpdatedTimeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastRelayListUpdatedTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastUpdatedTimeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastUpdatedTimeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastUpdatedTimeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lastUpdatedTimeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastUpdatedTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> lnurlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lnurl',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> lnurlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lnurl',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> lnurlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lnurl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> lnurlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lnurl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> lnurlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lnurl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> lnurlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lnurl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> lnurlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lnurl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> lnurlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lnurl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> lnurlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lnurl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> lnurlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lnurl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> lnurlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lnurl',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      lnurlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lnurl',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      mainRelayIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mainRelay',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      mainRelayIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mainRelay',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> mainRelayEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mainRelay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      mainRelayGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mainRelay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> mainRelayLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mainRelay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> mainRelayBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mainRelay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      mainRelayStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mainRelay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> mainRelayEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mainRelay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> mainRelayContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mainRelay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> mainRelayMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mainRelay',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      mainRelayIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mainRelay',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      mainRelayIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mainRelay',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> muteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mute',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> muteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mute',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> muteEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mute',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> nameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> nameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> nameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> nameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> nickNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nickName',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      nickNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nickName',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> nickNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nickName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      nickNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nickName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> nickNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nickName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> nickNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nickName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      nickNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nickName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> nickNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nickName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> nickNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nickName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> nickNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nickName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      nickNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nickName',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      nickNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nickName',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> nwcURIIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nwcURI',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      nwcURIIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nwcURI',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> nwcURIEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nwcURI',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> nwcURIGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nwcURI',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> nwcURILessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nwcURI',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> nwcURIBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nwcURI',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> nwcURIStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nwcURI',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> nwcURIEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nwcURI',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> nwcURIContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nwcURI',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> nwcURIMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nwcURI',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> nwcURIIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nwcURI',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      nwcURIIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nwcURI',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      otherFieldIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'otherField',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      otherFieldIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'otherField',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> otherFieldEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'otherField',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      otherFieldGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'otherField',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      otherFieldLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'otherField',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> otherFieldBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'otherField',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      otherFieldStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'otherField',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      otherFieldEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'otherField',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      otherFieldContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'otherField',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> otherFieldMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'otherField',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      otherFieldIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'otherField',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      otherFieldIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'otherField',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      outboxRelayListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'outboxRelayList',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      outboxRelayListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'outboxRelayList',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      outboxRelayListElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'outboxRelayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      outboxRelayListElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'outboxRelayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      outboxRelayListElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'outboxRelayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      outboxRelayListElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'outboxRelayList',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      outboxRelayListElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'outboxRelayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      outboxRelayListElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'outboxRelayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      outboxRelayListElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'outboxRelayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      outboxRelayListElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'outboxRelayList',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      outboxRelayListElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'outboxRelayList',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      outboxRelayListElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'outboxRelayList',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      outboxRelayListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'outboxRelayList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      outboxRelayListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'outboxRelayList',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      outboxRelayListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'outboxRelayList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      outboxRelayListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'outboxRelayList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      outboxRelayListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'outboxRelayList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      outboxRelayListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'outboxRelayList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> pictureIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'picture',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      pictureIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'picture',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> pictureEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'picture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      pictureGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'picture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> pictureLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'picture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> pictureBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'picture',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> pictureStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'picture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> pictureEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'picture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> pictureContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'picture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> pictureMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'picture',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> pictureIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'picture',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      pictureIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'picture',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> privkeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'privkey',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      privkeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'privkey',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> privkeyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'privkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      privkeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'privkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> privkeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'privkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> privkeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'privkey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> privkeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'privkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> privkeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'privkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> privkeyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'privkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> privkeyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'privkey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> privkeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'privkey',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      privkeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'privkey',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> pubKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pubKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> pubKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pubKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> pubKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pubKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> pubKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pubKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> pubKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pubKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> pubKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pubKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> pubKeyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pubKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> pubKeyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pubKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> pubKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pubKey',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      pubKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pubKey',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayGroupsListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'relayGroupsList',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayGroupsListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'relayGroupsList',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayGroupsListElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relayGroupsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayGroupsListElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'relayGroupsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayGroupsListElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'relayGroupsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayGroupsListElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'relayGroupsList',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayGroupsListElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'relayGroupsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayGroupsListElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'relayGroupsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayGroupsListElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'relayGroupsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayGroupsListElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'relayGroupsList',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayGroupsListElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relayGroupsList',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayGroupsListElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'relayGroupsList',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayGroupsListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'relayGroupsList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayGroupsListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'relayGroupsList',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayGroupsListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'relayGroupsList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayGroupsListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'relayGroupsList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayGroupsListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'relayGroupsList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayGroupsListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'relayGroupsList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'relayList',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'relayList',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayListElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayListElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'relayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayListElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'relayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayListElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'relayList',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayListElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'relayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayListElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'relayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayListElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'relayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayListElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'relayList',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayListElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relayList',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayListElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'relayList',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'relayList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'relayList',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'relayList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'relayList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'relayList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      relayListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'relayList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      remotePubkeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'remotePubkey',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      remotePubkeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'remotePubkey',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      remotePubkeyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remotePubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      remotePubkeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'remotePubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      remotePubkeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'remotePubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      remotePubkeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'remotePubkey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      remotePubkeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'remotePubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      remotePubkeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'remotePubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      remotePubkeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'remotePubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      remotePubkeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'remotePubkey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      remotePubkeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remotePubkey',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      remotePubkeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'remotePubkey',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      remoteSignerURIIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'remoteSignerURI',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      remoteSignerURIIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'remoteSignerURI',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      remoteSignerURIEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remoteSignerURI',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      remoteSignerURIGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'remoteSignerURI',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      remoteSignerURILessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'remoteSignerURI',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      remoteSignerURIBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'remoteSignerURI',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      remoteSignerURIStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'remoteSignerURI',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      remoteSignerURIEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'remoteSignerURI',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      remoteSignerURIContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'remoteSignerURI',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      remoteSignerURIMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'remoteSignerURI',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      remoteSignerURIIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remoteSignerURI',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      remoteSignerURIIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'remoteSignerURI',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      searchRelayListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'searchRelayList',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      searchRelayListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'searchRelayList',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      searchRelayListElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'searchRelayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      searchRelayListElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'searchRelayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      searchRelayListElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'searchRelayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      searchRelayListElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'searchRelayList',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      searchRelayListElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'searchRelayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      searchRelayListElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'searchRelayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      searchRelayListElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'searchRelayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      searchRelayListElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'searchRelayList',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      searchRelayListElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'searchRelayList',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      searchRelayListElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'searchRelayList',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      searchRelayListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'searchRelayList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      searchRelayListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'searchRelayList',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      searchRelayListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'searchRelayList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      searchRelayListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'searchRelayList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      searchRelayListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'searchRelayList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      searchRelayListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'searchRelayList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> settingsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'settings',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      settingsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'settings',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> settingsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'settings',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      settingsGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'settings',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> settingsLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'settings',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> settingsBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'settings',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      settingsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'settings',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> settingsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'settings',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> settingsContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'settings',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> settingsMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'settings',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      settingsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'settings',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      settingsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'settings',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      toAliasPrivkeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'toAliasPrivkey',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      toAliasPrivkeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'toAliasPrivkey',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      toAliasPrivkeyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'toAliasPrivkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      toAliasPrivkeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'toAliasPrivkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      toAliasPrivkeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'toAliasPrivkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      toAliasPrivkeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'toAliasPrivkey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      toAliasPrivkeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'toAliasPrivkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      toAliasPrivkeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'toAliasPrivkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      toAliasPrivkeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'toAliasPrivkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      toAliasPrivkeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'toAliasPrivkey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      toAliasPrivkeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'toAliasPrivkey',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      toAliasPrivkeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'toAliasPrivkey',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      toAliasPubkeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'toAliasPubkey',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      toAliasPubkeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'toAliasPubkey',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      toAliasPubkeyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'toAliasPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      toAliasPubkeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'toAliasPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      toAliasPubkeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'toAliasPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      toAliasPubkeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'toAliasPubkey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      toAliasPubkeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'toAliasPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      toAliasPubkeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'toAliasPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      toAliasPubkeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'toAliasPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      toAliasPubkeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'toAliasPubkey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      toAliasPubkeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'toAliasPubkey',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      toAliasPubkeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'toAliasPubkey',
        value: '',
      ));
    });
  }
}

extension UserDBISARQueryObject
    on QueryBuilder<UserDBISAR, UserDBISAR, QFilterCondition> {}

extension UserDBISARQueryLinks
    on QueryBuilder<UserDBISAR, UserDBISAR, QFilterCondition> {}

extension UserDBISARQuerySortBy
    on QueryBuilder<UserDBISAR, UserDBISAR, QSortBy> {
  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByAbout() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'about', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByAboutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'about', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByAliasPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aliasPubkey', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByAliasPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aliasPubkey', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByArea() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'area', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByAreaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'area', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByBadges() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'badges', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByBadgesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'badges', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByBanner() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'banner', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByBannerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'banner', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByClientPrivateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientPrivateKey', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      sortByClientPrivateKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientPrivateKey', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByDefaultPassword() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPassword', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      sortByDefaultPasswordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPassword', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByDns() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dns', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByDnsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dns', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByEncodedKeyPackage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encodedKeyPackage', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      sortByEncodedKeyPackageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encodedKeyPackage', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByEncryptedPrivKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedPrivKey', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      sortByEncryptedPrivKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedPrivKey', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByFriendsList() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'friendsList', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByFriendsListDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'friendsList', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByGender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByGenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      sortByLastBadgesListUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBadgesListUpdatedTime', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      sortByLastBadgesListUpdatedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBadgesListUpdatedTime', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      sortByLastBlockListUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBlockListUpdatedTime', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      sortByLastBlockListUpdatedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBlockListUpdatedTime', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      sortByLastChannelsListUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastChannelsListUpdatedTime', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      sortByLastChannelsListUpdatedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastChannelsListUpdatedTime', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      sortByLastDMRelayListUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDMRelayListUpdatedTime', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      sortByLastDMRelayListUpdatedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDMRelayListUpdatedTime', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      sortByLastFollowingListUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFollowingListUpdatedTime', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      sortByLastFollowingListUpdatedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFollowingListUpdatedTime', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      sortByLastFriendsListUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFriendsListUpdatedTime', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      sortByLastFriendsListUpdatedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFriendsListUpdatedTime', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      sortByLastGroupsListUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastGroupsListUpdatedTime', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      sortByLastGroupsListUpdatedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastGroupsListUpdatedTime', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      sortByLastRelayGroupsListUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastRelayGroupsListUpdatedTime', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      sortByLastRelayGroupsListUpdatedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastRelayGroupsListUpdatedTime', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      sortByLastRelayListUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastRelayListUpdatedTime', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      sortByLastRelayListUpdatedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastRelayListUpdatedTime', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByLastUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdatedTime', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      sortByLastUpdatedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdatedTime', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByLnurl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lnurl', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByLnurlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lnurl', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByMainRelay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mainRelay', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByMainRelayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mainRelay', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByMute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mute', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByMuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mute', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByNickName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nickName', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByNickNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nickName', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByNwcURI() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nwcURI', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByNwcURIDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nwcURI', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByOtherField() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'otherField', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByOtherFieldDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'otherField', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByPicture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'picture', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByPictureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'picture', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByPrivkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'privkey', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByPrivkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'privkey', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByPubKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubKey', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByPubKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubKey', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByRemotePubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remotePubkey', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByRemotePubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remotePubkey', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByRemoteSignerURI() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteSignerURI', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      sortByRemoteSignerURIDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteSignerURI', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortBySettings() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'settings', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortBySettingsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'settings', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByToAliasPrivkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toAliasPrivkey', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      sortByToAliasPrivkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toAliasPrivkey', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByToAliasPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toAliasPubkey', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByToAliasPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toAliasPubkey', Sort.desc);
    });
  }
}

extension UserDBISARQuerySortThenBy
    on QueryBuilder<UserDBISAR, UserDBISAR, QSortThenBy> {
  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByAbout() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'about', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByAboutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'about', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByAliasPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aliasPubkey', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByAliasPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aliasPubkey', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByArea() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'area', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByAreaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'area', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByBadges() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'badges', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByBadgesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'badges', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByBanner() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'banner', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByBannerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'banner', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByClientPrivateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientPrivateKey', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      thenByClientPrivateKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientPrivateKey', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByDefaultPassword() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPassword', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      thenByDefaultPasswordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPassword', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByDns() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dns', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByDnsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dns', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByEncodedKeyPackage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encodedKeyPackage', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      thenByEncodedKeyPackageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encodedKeyPackage', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByEncryptedPrivKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedPrivKey', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      thenByEncryptedPrivKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedPrivKey', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByFriendsList() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'friendsList', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByFriendsListDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'friendsList', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByGender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByGenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      thenByLastBadgesListUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBadgesListUpdatedTime', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      thenByLastBadgesListUpdatedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBadgesListUpdatedTime', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      thenByLastBlockListUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBlockListUpdatedTime', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      thenByLastBlockListUpdatedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBlockListUpdatedTime', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      thenByLastChannelsListUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastChannelsListUpdatedTime', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      thenByLastChannelsListUpdatedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastChannelsListUpdatedTime', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      thenByLastDMRelayListUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDMRelayListUpdatedTime', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      thenByLastDMRelayListUpdatedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDMRelayListUpdatedTime', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      thenByLastFollowingListUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFollowingListUpdatedTime', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      thenByLastFollowingListUpdatedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFollowingListUpdatedTime', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      thenByLastFriendsListUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFriendsListUpdatedTime', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      thenByLastFriendsListUpdatedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFriendsListUpdatedTime', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      thenByLastGroupsListUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastGroupsListUpdatedTime', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      thenByLastGroupsListUpdatedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastGroupsListUpdatedTime', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      thenByLastRelayGroupsListUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastRelayGroupsListUpdatedTime', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      thenByLastRelayGroupsListUpdatedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastRelayGroupsListUpdatedTime', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      thenByLastRelayListUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastRelayListUpdatedTime', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      thenByLastRelayListUpdatedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastRelayListUpdatedTime', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByLastUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdatedTime', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      thenByLastUpdatedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdatedTime', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByLnurl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lnurl', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByLnurlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lnurl', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByMainRelay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mainRelay', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByMainRelayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mainRelay', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByMute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mute', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByMuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mute', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByNickName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nickName', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByNickNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nickName', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByNwcURI() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nwcURI', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByNwcURIDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nwcURI', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByOtherField() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'otherField', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByOtherFieldDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'otherField', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByPicture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'picture', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByPictureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'picture', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByPrivkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'privkey', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByPrivkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'privkey', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByPubKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubKey', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByPubKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubKey', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByRemotePubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remotePubkey', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByRemotePubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remotePubkey', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByRemoteSignerURI() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteSignerURI', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      thenByRemoteSignerURIDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteSignerURI', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenBySettings() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'settings', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenBySettingsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'settings', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByToAliasPrivkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toAliasPrivkey', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      thenByToAliasPrivkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toAliasPrivkey', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByToAliasPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toAliasPubkey', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByToAliasPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toAliasPubkey', Sort.desc);
    });
  }
}

extension UserDBISARQueryWhereDistinct
    on QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> {
  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByAbout(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'about', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByAliasPubkey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'aliasPubkey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByArea(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'area', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByBadges(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'badges', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByBadgesList() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'badgesList');
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByBanner(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'banner', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByBlockedHashTags() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'blockedHashTags');
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByBlockedList() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'blockedList');
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByBlockedThreads() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'blockedThreads');
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByBlockedWords() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'blockedWords');
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByChannelsList() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'channelsList');
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByClientPrivateKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clientPrivateKey',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByDefaultPassword(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultPassword',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByDmRelayList() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dmRelayList');
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByDns(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dns', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByEncodedKeyPackage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'encodedKeyPackage',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByEncryptedPrivKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'encryptedPrivKey',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByFollowersList() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'followersList');
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByFollowingList() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'followingList');
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByFriendsList(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'friendsList', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByGender(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gender', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByGroupsList() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'groupsList');
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByInboxRelayList() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'inboxRelayList');
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct>
      distinctByLastBadgesListUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastBadgesListUpdatedTime');
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct>
      distinctByLastBlockListUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastBlockListUpdatedTime');
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct>
      distinctByLastChannelsListUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastChannelsListUpdatedTime');
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct>
      distinctByLastDMRelayListUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastDMRelayListUpdatedTime');
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct>
      distinctByLastFollowingListUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastFollowingListUpdatedTime');
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct>
      distinctByLastFriendsListUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastFriendsListUpdatedTime');
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct>
      distinctByLastGroupsListUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastGroupsListUpdatedTime');
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct>
      distinctByLastRelayGroupsListUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastRelayGroupsListUpdatedTime');
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct>
      distinctByLastRelayListUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastRelayListUpdatedTime');
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByLastUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdatedTime');
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByLnurl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lnurl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByMainRelay(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mainRelay', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByMute() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mute');
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByNickName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nickName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByNwcURI(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nwcURI', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByOtherField(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'otherField', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByOutboxRelayList() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'outboxRelayList');
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByPicture(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'picture', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByPrivkey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'privkey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByPubKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pubKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByRelayGroupsList() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'relayGroupsList');
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByRelayList() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'relayList');
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByRemotePubkey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remotePubkey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByRemoteSignerURI(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remoteSignerURI',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctBySearchRelayList() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'searchRelayList');
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctBySettings(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'settings', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByToAliasPrivkey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'toAliasPrivkey',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByToAliasPubkey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'toAliasPubkey',
          caseSensitive: caseSensitive);
    });
  }
}

extension UserDBISARQueryProperty
    on QueryBuilder<UserDBISAR, UserDBISAR, QQueryProperty> {
  QueryBuilder<UserDBISAR, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserDBISAR, String?, QQueryOperations> aboutProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'about');
    });
  }

  QueryBuilder<UserDBISAR, String?, QQueryOperations> aliasPubkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'aliasPubkey');
    });
  }

  QueryBuilder<UserDBISAR, String?, QQueryOperations> areaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'area');
    });
  }

  QueryBuilder<UserDBISAR, String?, QQueryOperations> badgesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'badges');
    });
  }

  QueryBuilder<UserDBISAR, List<String>?, QQueryOperations>
      badgesListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'badgesList');
    });
  }

  QueryBuilder<UserDBISAR, String?, QQueryOperations> bannerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'banner');
    });
  }

  QueryBuilder<UserDBISAR, List<String>?, QQueryOperations>
      blockedHashTagsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'blockedHashTags');
    });
  }

  QueryBuilder<UserDBISAR, List<String>?, QQueryOperations>
      blockedListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'blockedList');
    });
  }

  QueryBuilder<UserDBISAR, List<String>?, QQueryOperations>
      blockedThreadsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'blockedThreads');
    });
  }

  QueryBuilder<UserDBISAR, List<String>?, QQueryOperations>
      blockedWordsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'blockedWords');
    });
  }

  QueryBuilder<UserDBISAR, List<String>?, QQueryOperations>
      channelsListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'channelsList');
    });
  }

  QueryBuilder<UserDBISAR, String?, QQueryOperations>
      clientPrivateKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clientPrivateKey');
    });
  }

  QueryBuilder<UserDBISAR, String?, QQueryOperations>
      defaultPasswordProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultPassword');
    });
  }

  QueryBuilder<UserDBISAR, List<String>?, QQueryOperations>
      dmRelayListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dmRelayList');
    });
  }

  QueryBuilder<UserDBISAR, String?, QQueryOperations> dnsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dns');
    });
  }

  QueryBuilder<UserDBISAR, String?, QQueryOperations>
      encodedKeyPackageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encodedKeyPackage');
    });
  }

  QueryBuilder<UserDBISAR, String?, QQueryOperations>
      encryptedPrivKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedPrivKey');
    });
  }

  QueryBuilder<UserDBISAR, List<String>?, QQueryOperations>
      followersListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'followersList');
    });
  }

  QueryBuilder<UserDBISAR, List<String>?, QQueryOperations>
      followingListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'followingList');
    });
  }

  QueryBuilder<UserDBISAR, String?, QQueryOperations> friendsListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'friendsList');
    });
  }

  QueryBuilder<UserDBISAR, String?, QQueryOperations> genderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gender');
    });
  }

  QueryBuilder<UserDBISAR, List<String>?, QQueryOperations>
      groupsListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'groupsList');
    });
  }

  QueryBuilder<UserDBISAR, List<String>?, QQueryOperations>
      inboxRelayListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'inboxRelayList');
    });
  }

  QueryBuilder<UserDBISAR, int, QQueryOperations>
      lastBadgesListUpdatedTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastBadgesListUpdatedTime');
    });
  }

  QueryBuilder<UserDBISAR, int, QQueryOperations>
      lastBlockListUpdatedTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastBlockListUpdatedTime');
    });
  }

  QueryBuilder<UserDBISAR, int, QQueryOperations>
      lastChannelsListUpdatedTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastChannelsListUpdatedTime');
    });
  }

  QueryBuilder<UserDBISAR, int, QQueryOperations>
      lastDMRelayListUpdatedTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastDMRelayListUpdatedTime');
    });
  }

  QueryBuilder<UserDBISAR, int, QQueryOperations>
      lastFollowingListUpdatedTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastFollowingListUpdatedTime');
    });
  }

  QueryBuilder<UserDBISAR, int, QQueryOperations>
      lastFriendsListUpdatedTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastFriendsListUpdatedTime');
    });
  }

  QueryBuilder<UserDBISAR, int, QQueryOperations>
      lastGroupsListUpdatedTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastGroupsListUpdatedTime');
    });
  }

  QueryBuilder<UserDBISAR, int, QQueryOperations>
      lastRelayGroupsListUpdatedTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastRelayGroupsListUpdatedTime');
    });
  }

  QueryBuilder<UserDBISAR, int, QQueryOperations>
      lastRelayListUpdatedTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastRelayListUpdatedTime');
    });
  }

  QueryBuilder<UserDBISAR, int, QQueryOperations> lastUpdatedTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdatedTime');
    });
  }

  QueryBuilder<UserDBISAR, String?, QQueryOperations> lnurlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lnurl');
    });
  }

  QueryBuilder<UserDBISAR, String?, QQueryOperations> mainRelayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mainRelay');
    });
  }

  QueryBuilder<UserDBISAR, bool?, QQueryOperations> muteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mute');
    });
  }

  QueryBuilder<UserDBISAR, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<UserDBISAR, String?, QQueryOperations> nickNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nickName');
    });
  }

  QueryBuilder<UserDBISAR, String?, QQueryOperations> nwcURIProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nwcURI');
    });
  }

  QueryBuilder<UserDBISAR, String?, QQueryOperations> otherFieldProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'otherField');
    });
  }

  QueryBuilder<UserDBISAR, List<String>?, QQueryOperations>
      outboxRelayListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'outboxRelayList');
    });
  }

  QueryBuilder<UserDBISAR, String?, QQueryOperations> pictureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'picture');
    });
  }

  QueryBuilder<UserDBISAR, String?, QQueryOperations> privkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'privkey');
    });
  }

  QueryBuilder<UserDBISAR, String, QQueryOperations> pubKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pubKey');
    });
  }

  QueryBuilder<UserDBISAR, List<String>?, QQueryOperations>
      relayGroupsListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'relayGroupsList');
    });
  }

  QueryBuilder<UserDBISAR, List<String>?, QQueryOperations>
      relayListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'relayList');
    });
  }

  QueryBuilder<UserDBISAR, String?, QQueryOperations> remotePubkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remotePubkey');
    });
  }

  QueryBuilder<UserDBISAR, String?, QQueryOperations>
      remoteSignerURIProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remoteSignerURI');
    });
  }

  QueryBuilder<UserDBISAR, List<String>?, QQueryOperations>
      searchRelayListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'searchRelayList');
    });
  }

  QueryBuilder<UserDBISAR, String?, QQueryOperations> settingsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'settings');
    });
  }

  QueryBuilder<UserDBISAR, String?, QQueryOperations> toAliasPrivkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'toAliasPrivkey');
    });
  }

  QueryBuilder<UserDBISAR, String?, QQueryOperations> toAliasPubkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'toAliasPubkey');
    });
  }
}
