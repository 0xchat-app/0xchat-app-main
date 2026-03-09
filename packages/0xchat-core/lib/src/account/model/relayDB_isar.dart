import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:chatcore/chat-core.dart';

part 'relayDB_isar.g.dart';

@collection
class RelayDBISAR {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
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

  int friendRequestSince;
  int friendRequestUntil;

  int friendMessageSince;
  int friendMessageUntil;

  int channelMessageSince;
  int channelMessageUntil;

  int commonMessagesSince;
  int commonMessagesUntil;

  int groupMessageSince;
  int groupMessageUntil;

  int mlsGroupMessageSince;
  int mlsGroupMessageUntil;

  int momentSince;
  int momentUntil;

  int zapRecordSince;
  int zapRecordUntil;

  RelayDBISAR(
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
      this.friendMessageSince = 0,
      this.friendMessageUntil = 0,
      this.channelMessageSince = 0,
      this.channelMessageUntil = 0,
      this.commonMessagesSince = 0,
      this.commonMessagesUntil = 0,
      this.groupMessageSince = 0,
      this.groupMessageUntil = 0,
      this.mlsGroupMessageSince = 0,
      this.mlsGroupMessageUntil = 0,
      this.momentSince = 0,
      this.momentUntil = 0,
      this.zapRecordSince = 0,
      this.zapRecordUntil = 0});

  @ignore
  int? get connectStatus {
    return Connect.sharedInstance.webSockets[url]?.connectStatus;
  }

  static RelayDBISAR fromMap(Map<String, Object?> map) {
    return _relayDBInfoFromMap(map);
  }

  static Map<String, int> decodeMap(String map) {
    try {
      Map<String, dynamic> result = jsonDecode(map);
      return result.map((key, value) => MapEntry(key, int.parse(value.toString())));
    } catch (e) {
      return {};
    }
  }

  static RelayDBISAR relayDBInfoFromJSON(String json, RelayDBISAR relayDB) {
    Map map = jsonDecode(json);
    relayDB.pubkey = map.containsKey('pubkey') ? map['pubkey'].toString() : '';
    relayDB.description = map.containsKey('description') ? map['description'].toString() : '';
    relayDB.contact = map.containsKey('contact') ? map['contact'].toString() : '';
    relayDB.supportedNips =
        map.containsKey('supported_nips') ? map['supported_nips'].toString() : '';
    relayDB.supportedNipExtensions = map.containsKey('supported_nip_extensions')
        ? map['supported_nip_extensions'].toString()
        : '';
    relayDB.software = map.containsKey('software') ? map['software'].toString() : '';
    relayDB.version = map.containsKey('version') ? map['version'].toString() : '';
    relayDB.limitation = map.containsKey('limitation') ? map['limitation'].toString() : '';
    relayDB.paymentsUrl = map.containsKey('payments_url') ? map['payments_url'].toString() : '';
    relayDB.fees = map.containsKey('fees') ? map['fees'].toString() : '';
    relayDB.icon = map.containsKey('icon') ? map['icon'].toString() : '';

    return relayDB;
  }
}

RelayDBISAR _relayDBInfoFromMap(Map<String, dynamic> map) {
  return RelayDBISAR(
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
    commonMessagesSince: map['commonMessagesSince'],
    commonMessagesUntil: map['commonMessagesUntil'],
  );
}
