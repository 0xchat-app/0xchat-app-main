import 'dart:convert';

import 'package:nostr_core_dart/nostr.dart';

///https://github.com/nostr-protocol/nips/blob/master/42.md
///Authentication of clients to relays
class Nip42 {
  static Future<Event> encode(
      String challenge, String relay, String pubkey, String privkey) async {
    return await Event.from(
        kind: 22242,
        tags: [
          ["relay", relay],
          ["challenge", challenge]
        ],
        content: "",
        pubkey: pubkey,
        privkey: privkey);
  }

  static String authString(Event event) {
    var auth = ["AUTH", event.toJson()];
    return jsonEncode(auth);
  }

  static bool authRequired(String message) {
    return message.startsWith('auth-required: ');
  }

  static bool restricted(String message) {
    return message.startsWith('restricted: ');
  }
}
