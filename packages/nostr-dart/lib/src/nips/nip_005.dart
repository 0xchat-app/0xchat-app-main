import 'dart:convert';
import 'package:nostr_core_dart/nostr.dart';

/// Mapping Nostr keys to DNS-based internet identifiers
class Nip5 {
  /// decode setmetadata event
  /// {
  ///   "pubkey": "b0635d6a9851d3aed0cd6c495b282167acf761729078d975fc341b22650b07b9",
  ///   "kind": 0,
  ///   "content": "{\"name\": \"bob\", \"nip05\": \"bob@example.com\"}"
  /// }
  static Future<DNS?> decode(Event event) async {
    if (event.kind == 0) {
      try {
        Map map = jsonDecode(event.content);
        String dns = map['nip05'];
        List<dynamic> relays = map['relays'];
        if (dns.isNotEmpty) {
          List<dynamic> parts = dns.split('@');
          String name = parts[0];
          String domain = parts[1];
          return DNS(name, domain, event.pubkey, relays.map((e) => e.toString()).toList());
        }
      } catch (e) {
        throw Exception(e.toString());
      }
    }
    throw Exception("${event.kind} is not nip1 compatible");
  }

  /// encode set metadata event
  static Future<Event> encode(
      String name, String domain, List<String> relays, String pubkey, String privkey) async {
    if (isValidName(name) && isValidDomain(domain)) {
      String content = generateContent(name, domain, relays);
      return await Nip1.setMetadata(content, pubkey, privkey);
    } else {
      throw Exception("not a valid name or domain!");
    }
  }

  static bool isValidName(String input) {
    RegExp regExp = RegExp(r'^[a-z0-9_]+$');
    return regExp.hasMatch(input);
  }

  static bool isValidDomain(String domain) {
    RegExp regExp = RegExp(
      r'^([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}$',
      caseSensitive: false,
    );
    return regExp.hasMatch(domain);
  }

  static String generateContent(
      String name, String domain, List<String> relays) {
    Map<String, dynamic> map = {
      'name': name,
      'nip05': '$name@$domain',
      'relays': relays,
    };
    return jsonEncode(map);
  }
}

///
class DNS {
  String name;

  String domain;

  String pubkey;

  List<String> relays;

  /// Default constructor
  DNS(this.name, this.domain, this.pubkey, this.relays);
}
