import 'package:nostr_core_dart/nostr.dart';

/// Relay List Metadata
class Nip65 {
  static Future<Event> encode(List<Relay> relays, String pubkey,  String privkey) async {
    return await Event.from(
        kind: 10002, tags: toTags(relays), content: '', pubkey: pubkey, privkey: privkey);
  }

  static List<Relay> decode(Event event) {
    if (event.kind == 10002) {
      return toRelays(event.tags);
    }
    throw Exception("${event.kind} is not nip65 compatible");
  }

  static List<Relay> toRelays(List<List<String>> tags) {
    List<Relay> result = [];
    for (var tag in tags) {
      if (tag[0] == "r") {
        tag.length > 2
            ? result.add(Relay(tag[1], tag[2]))
            : result.add(Relay(tag[1], null));
      }
    }
    return result;
  }

  static List<List<String>> toTags(List<Relay> relays) {
    List<List<String>> result = [];
    for (var relay in relays) {
      relay.r != null
          ? result.add(["r", relay.url, relay.r!])
          : result.add(["r", relay.url]);
    }
    return result;
  }
}

class Relay {
  String url;
  String? r;

  Relay(this.url, this.r);
}
