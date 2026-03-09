import 'dart:convert';
import 'package:chatcore/chat-core.dart';

@reflector
class RelayDB extends DBObject {
  String url;
  String? name;
  String? pubkey;
  String? description;
  String? contact;
  String? supportedNips;
  String? supportedNipExtensions;
  String? software;
  String? version;
  String? limitation;
  String? paymentsUrl;
  String? fees;
  String? icon;

  // friend request, add, reject, delete
  int friendRequestSince;
  int friendRequestUntil;

  // private messages {friendPubkey1: time1, friendPubkey2: time2,...}
  Map<String, int>? friendMessageSince;
  Map<String, int>? friendMessageUntil;

  // channel messages {channelID1: time1, channelID2: time2,...}
  Map<String, int>? channelMessageSince;
  Map<String, int>? channelMessageUntil;

  // delete message, hide message, mute user
  int commonMessagesSince;
  int commonMessagesUntil;

  Map<String, int>? contactsNotesSince;
  Map<String, int>? contactsNotesUntil;

  // group messages {groupID1: time1, groupID2: time2,...}
  Map<String, int>? groupMessageSince;
  Map<String, int>? groupMessageUntil;

  Map<String, int>? momentSince;
  Map<String, int>? momentUntil;

  Map<String, int>? zapRecordSince;
  Map<String, int>? zapRecordUntil;

  RelayDB(
      {this.url = '',
      this.pubkey = '',
      this.description = '',
      this.contact = '',
      this.supportedNips = '',
      this.supportedNipExtensions = '',
      this.software = '',
      this.version = '',
      this.limitation = '',
      this.paymentsUrl = '',
      this.fees = '',
      this.icon = '',
      this.friendRequestSince = 0,
      this.friendRequestUntil = 0,
      this.friendMessageSince,
      this.friendMessageUntil,
      this.channelMessageSince,
      this.channelMessageUntil,
      this.commonMessagesSince = 0,
      this.commonMessagesUntil = 0,
      this.groupMessageSince,
      this.groupMessageUntil,
      this.contactsNotesUntil,
      this.contactsNotesSince,
      this.momentSince,
      this.momentUntil,
      this.zapRecordSince,
      this.zapRecordUntil});

  @override
  //Map
  Map<String, Object?> toMap() {
    return _relayDBInfoToMap(this);
  }

  int? get connectStatus {
    return Connect.sharedInstance.webSockets[url]?.connectStatus;
  }

  int getFriendMessageUntil(String relay) {
    friendMessageUntil ??= {};
    if (friendMessageUntil!.containsKey(relay)) {
      return friendMessageUntil![relay]!;
    }
    return 0;
  }

  int getFriendMessageSince(String relay) {
    friendMessageSince ??= {};
    if (friendMessageSince!.containsKey(relay)) {
      return friendMessageSince![relay]!;
    }
    return 0;
  }

  int getChannelMessageSince(String relay) {
    channelMessageSince ??= {};
    if (channelMessageSince!.containsKey(relay)) {
      return channelMessageSince![relay]!;
    }
    return 0;
  }

  int getChannelMessageUntil(String relay) {
    channelMessageUntil ??= {};
    if (channelMessageUntil!.containsKey(relay)) {
      return channelMessageUntil![relay]!;
    }
    return 0;
  }

  int getGroupMessageSince(String relay) {
    groupMessageSince ??= {};
    if (groupMessageSince!.containsKey(relay)) {
      return groupMessageSince![relay]!;
    }
    return 0;
  }

  int getGroupMessageUntil(String relay) {
    groupMessageUntil ??= {};
    if (groupMessageUntil!.containsKey(relay)) {
      return groupMessageUntil![relay]!;
    }
    return 0;
  }

  int getContactsNotesSince(String relay) {
    contactsNotesSince ??= {};
    if (contactsNotesSince!.containsKey(relay)) {
      return contactsNotesSince![relay]!;
    }
    return 0;
  }

  int getContactsNotesUntil(String relay) {
    contactsNotesUntil ??= {};
    if (contactsNotesUntil!.containsKey(relay)) {
      return contactsNotesUntil![relay]!;
    }
    return 0;
  }

  int getMomentSince(String relay) {
    momentSince ??= {};
    if (momentSince!.containsKey(relay)) {
      return momentSince![relay]!;
    }
    return 0;
  }

  int getMomentUntil(String relay) {
    momentUntil ??= {};
    if (momentUntil!.containsKey(relay)) {
      return momentUntil![relay]!;
    }
    return 0;
  }

  int getZapRecordSince(String relay) {
    zapRecordSince ??= {};
    if (zapRecordSince!.containsKey(relay)) {
      return zapRecordSince![relay]!;
    }
    return 0;
  }

  int getZapRecordUntil(String relay) {
    zapRecordUntil ??= {};
    if (zapRecordUntil!.containsKey(relay)) {
      return zapRecordUntil![relay]!;
    }
    return 0;
  }

  static RelayDB fromMap(Map<String, Object?> map) {
    return _relayDBInfoFromMap(map);
  }

  //primaryKey
  static List<String?> primaryKey() {
    return ['url'];
  }

  //'ALTER TABLE Company ADD description TEXT'
  static Map<String, String?> updateTable() {
    return {
      "4":
          '''alter table RelayDB add contactsNotesUntil TEXT; alter table RelayDB add contactsNotesSince TEXT;''',
      "7":
          '''alter table RelayDB add momentUntil TEXT; alter table RelayDB add momentSince TEXT;''',
      "8":
          '''alter table RelayDB add zapRecordSince TEXT; alter table RelayDB add zapRecordUntil TEXT;''',
    };
  }

  static Map<String, int> decodeMap(String map) {
    try {
      Map<String, dynamic> result = jsonDecode(map);
      return result
          .map((key, value) => MapEntry(key, int.parse(value.toString())));
    } catch (e) {
      return {};
    }
  }

  static RelayDB relayDBInfoFromJSON(String json, RelayDB relayDB) {
    Map map = jsonDecode(json);
    relayDB.pubkey = map.containsKey('pubkey') ? map['pubkey'].toString() : '';
    relayDB.description =
        map.containsKey('description') ? map['description'].toString() : '';
    relayDB.contact =
        map.containsKey('contact') ? map['contact'].toString() : '';
    relayDB.supportedNips = map.containsKey('supported_nips')
        ? map['supported_nips'].toString()
        : '';
    relayDB.supportedNipExtensions = map.containsKey('supported_nip_extensions')
        ? map['supported_nip_extensions'].toString()
        : '';
    relayDB.software =
        map.containsKey('software') ? map['software'].toString() : '';
    relayDB.version =
        map.containsKey('version') ? map['version'].toString() : '';
    relayDB.limitation =
        map.containsKey('limitation') ? map['limitation'].toString() : '';
    relayDB.paymentsUrl =
        map.containsKey('payments_url') ? map['payments_url'].toString() : '';
    relayDB.fees = map.containsKey('fees') ? map['fees'].toString() : '';
    relayDB.icon = map.containsKey('icon') ? map['icon'].toString() : '';

    return relayDB;
  }

  static Future<void> migrateToISAR() async {
    List<RelayDB> relayDBs = await DB.sharedInstance.objects<RelayDB>();
    List<RelayDBISAR> relayDBsISAR = [];
    for (var relayDB in relayDBs) {
      relayDBsISAR.add(RelayDBISAR.fromMap(relayDB.toMap()));
    }
    await DBISAR.sharedInstance.isar.writeTxn(() async {
      await DBISAR.sharedInstance.isar.relayDBISARs.putAll(relayDBsISAR);
    });
  }
}

RelayDB _relayDBInfoFromMap(Map<String, dynamic> map) {
  return RelayDB(
    url: map['url'].toString(),
    pubkey: map['pubkey'].toString(),
    description: map['description'].toString(),
    contact: map['contact'].toString(),
    supportedNips: map['supportedNips'].toString(),
    supportedNipExtensions: map['supportedNipExtensions'].toString(),
    software: map['software'].toString(),
    version: map['version'].toString(),
    limitation: map['limitation'].toString(),
    paymentsUrl: map['paymentsUrl'].toString(),
    fees: map['fees'].toString(),
    icon: map['icon'].toString(),
    friendRequestSince: map['friendRequestSince'],
    friendRequestUntil: map['friendRequestUntil'],
    friendMessageSince: RelayDB.decodeMap(map['friendMessageSince'].toString()),
    friendMessageUntil: RelayDB.decodeMap(map['friendMessageUntil'].toString()),
    channelMessageSince:
        RelayDB.decodeMap(map['channelMessageSince'].toString()),
    channelMessageUntil:
        RelayDB.decodeMap(map['channelMessageUntil'].toString()),
    commonMessagesSince: map['commonMessagesSince'],
    commonMessagesUntil: map['commonMessagesUntil'],
    groupMessageSince: RelayDB.decodeMap(map['groupMessageSince'].toString()),
    groupMessageUntil: RelayDB.decodeMap(map['groupMessageUntil'].toString()),
    // contactsNotesUntil: RelayDB.decodeMap(map['contactsNotesUntil'].toString()),
    // contactsNotesSince: RelayDB.decodeMap(map['contactsNotesSince'].toString()),
    momentUntil: RelayDB.decodeMap(map['momentUntil'].toString()),
    momentSince: RelayDB.decodeMap(map['momentSince'].toString()),
    zapRecordSince: RelayDB.decodeMap(map['zapRecordSince'].toString()),
    zapRecordUntil: RelayDB.decodeMap(map['zapRecordUntil'].toString()),
  );
}

Map<String, dynamic> _relayDBInfoToMap(RelayDB instance) => <String, dynamic>{
      'url': instance.url,
      'pubkey': instance.pubkey,
      'description': instance.description,
      'contact': instance.contact,
      'supportedNips': instance.supportedNips,
      'supportedNipExtensions': instance.supportedNipExtensions,
      'software': instance.software,
      'version': instance.version,
      'limitation': instance.limitation,
      'paymentsUrl': instance.paymentsUrl,
      'fees': instance.fees,
      'icon': instance.icon,
      'friendRequestSince': instance.friendRequestSince,
      'friendRequestUntil': instance.friendRequestUntil,
      'friendMessageSince': jsonEncode(instance.friendMessageSince),
      'friendMessageUntil': jsonEncode(instance.friendMessageUntil),
      'channelMessageSince': jsonEncode(instance.channelMessageSince),
      'channelMessageUntil': jsonEncode(instance.channelMessageUntil),
      'commonMessagesSince': instance.commonMessagesSince,
      'commonMessagesUntil': instance.commonMessagesUntil,
      'groupMessageSince': jsonEncode(instance.groupMessageSince),
      'groupMessageUntil': jsonEncode(instance.groupMessageUntil),
      // 'contactsNotesSince': jsonEncode(instance.contactsNotesSince),
      // 'contactsNotesUntil': jsonEncode(instance.contactsNotesUntil),
      'momentSince': jsonEncode(instance.momentSince),
      'momentUntil': jsonEncode(instance.momentUntil),
      'zapRecordSince': jsonEncode(instance.zapRecordSince),
      'zapRecordUntil': jsonEncode(instance.zapRecordUntil),
    };
