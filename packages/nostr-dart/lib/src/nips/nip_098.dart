import 'dart:convert';
import 'package:nostr_core_dart/nostr.dart';

/// HTTP Auth
class Nip98 {
  static Future<Event> encode(
      String url, String myPubkey, String privkey) async {
    List<List<String>> tags = [];
    tags.add(['u', url]);
    tags.add(['method', 'GET']);
    return await Event.from(
        kind: 27235,
        tags: tags,
        content: '',
        pubkey: myPubkey,
        privkey: privkey);
  }

  static Future<String> base64Event(String url, String myPubkey, String privkey) async {
    Event event = await encode(url, myPubkey, privkey);
    String jsonString = jsonEncode(event.toJson());
    List<int> bytes = utf8.encode(jsonString);
    return base64Encode(bytes);
  }
}
