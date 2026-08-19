/// nip 104 - MLS
import 'package:nostr_core_dart/nostr.dart';
import 'dart:typed_data';

class Nip104 {
  static Future<Event> encodeKeyPackageEvent(
      String encoded_key_package, List<List<String>> tags, String myPubkey, String privkey, {int kind = 443}) async {
    return await Event.from(
        kind: kind, tags: tags, content: encoded_key_package, pubkey: myPubkey, privkey: privkey);
  }

  static KeyPackageEvent decodeKeyPackageEvent(Event event) {
    if (event.kind != 443 && event.kind != 10443) {
      throw Exception("${event.kind} is not nip104 compatible");
    }

    String pubkey;
    int createTime;
    String? mls_protocol_version;
    String? ciphersuite;
    List<String>? extensions;
    List<String>? relays;
    String? client;
    String eventId = event.id;
    for (var tag in event.tags) {
      if (tag[0] == 'mls_protocol_version') mls_protocol_version = tag[1];
      if (tag[0] == 'mls_ciphersuite') ciphersuite = tag[1];
      if (tag[0] == 'mls_extensions') extensions = tag.sublist(1);
      if (tag[0] == 'relays') relays = tag.sublist(1);
      if (tag[0] == 'client') client = tag[1];
    }
    pubkey = event.pubkey;
    createTime = event.createdAt;
    return KeyPackageEvent(pubkey, createTime, mls_protocol_version ?? '', ciphersuite ?? '',
        extensions ?? [], relays ?? [], client ?? '', event.content, eventId);
  }

  static Future<Event> encodeWelcomeEvent(List<int> serializedWelcomeMessage, List<String> relays,
      String myPubkey, String privkey) async {
    var tags = [
      ['relays', ...relays],
    ];
    Event event = await Event.from(
        kind: 444,
        tags: tags,
        content: bytesToHex(Uint8List.fromList(serializedWelcomeMessage)),
        pubkey: myPubkey,
        privkey: privkey);
    event.sig = '';
    return event;
  }

  static WelcomeEvent decodeWelcomeEvent(Event event) {
    if (event.kind != 444) {
      throw Exception("${event.kind} is not nip104 compatible");
    }

    String pubkey;
    int createTime;
    List<int> serializedWelcomeMessage;
    late List<String> relays;
    for (var tag in event.tags) {
      if (tag[0] == 'relays') relays = tag.sublist(1);
    }
    pubkey = event.pubkey;
    createTime = event.createdAt;
    serializedWelcomeMessage = hexToBytes(event.content);
    return WelcomeEvent(pubkey, createTime, relays, serializedWelcomeMessage);
  }

  static Future<Event> encodeGroupEvent(
      String content, String groupId, String myPubkey, String privkey) async {
    var tags = [
      ['h', groupId],
    ];
    Event event = await Event.from(
        kind: 445, tags: tags, content: content, pubkey: myPubkey, privkey: privkey);
    return event;
  }

  static GroupEvent decodeGroupEvent(Event event) {
    if (event.kind != 445) {
      throw Exception("${event.kind} is not nip104 compatible");
    }

    String pubkey;
    int createTime;
    late String groupId;
    String message;
    for (var tag in event.tags) {
      if (tag[0] == 'h') groupId = tag[1];
    }
    pubkey = event.pubkey;
    createTime = event.createdAt;
    message = event.content;
    return GroupEvent(pubkey, createTime, groupId, message);
  }

  static Future<Event> encodeKeypackageRelayEvent(
      List<String> relays, String myPubkey, String privkey) async {
    List<List<String>> tags = [];
    for (var relay in relays) {
      tags.add(['relay', relay]);
    }
    Event event =
        await Event.from(kind: 10051, tags: tags, content: '', pubkey: myPubkey, privkey: privkey);
    return event;
  }

  static KeypackageRelayEvent decodeKeypackageRelayEvent(Event event) {
    if (event.kind != 10051) {
      throw Exception("${event.kind} is not nip104 compatible");
    }

    List<String> relays = [];
    for (var tag in event.tags) {
      if (tag[0] == 'relay') relays.add(tag[1]);
    }
    var pubkey = event.pubkey;
    var createTime = event.createdAt;
    return KeypackageRelayEvent(pubkey, createTime, relays);
  }
}

class KeyPackageEvent {
  String pubkey;
  int createTime;
  String mls_protocol_version;
  String ciphersuite;
  List<String> extensions;
  List<String> relays;
  String client;
  String encoded_key_package;
  String eventId; // Add eventId field

  KeyPackageEvent(this.pubkey, this.createTime, this.mls_protocol_version, this.ciphersuite,
      this.extensions, this.relays, this.client, this.encoded_key_package, this.eventId);

  Map<String, dynamic> toJson() {
    return {
      'pubkey': pubkey,
      'createTime': createTime,
      'mls_protocol_version': mls_protocol_version,
      'ciphersuite': ciphersuite,
      'extensions': extensions,
      'relays': relays,
      'client': client,
      'encoded_key_package': encoded_key_package,
      'eventId': eventId,
    };
  }

  factory KeyPackageEvent.fromJson(Map<String, dynamic> json) {
    return KeyPackageEvent(
      json['pubkey'] ?? '',
      json['createTime'] ?? 0,
      json['mls_protocol_version'] ?? '',
      json['ciphersuite'] ?? '',
      List<String>.from(json['extensions'] ?? []),
      List<String>.from(json['relays'] ?? []),
      json['client'] ?? '',
      json['encoded_key_package'] ?? '',
      json['eventId'] ?? '',
    );
  }
}

class WelcomeEvent {
  String pubkey;
  int createTime;
  List<String> relays;
  List<int> serializedWelcomeMessage;

  WelcomeEvent(this.pubkey, this.createTime, this.relays, this.serializedWelcomeMessage);
}

class GroupEvent {
  String pubkey;
  int createTime;
  String groupId;
  String message;

  GroupEvent(this.pubkey, this.createTime, this.groupId, this.message);
}

class KeypackageRelayEvent {
  String pubkey;
  int createTime;
  List<String> relays;

  KeypackageRelayEvent(this.pubkey, this.createTime, this.relays);
}
