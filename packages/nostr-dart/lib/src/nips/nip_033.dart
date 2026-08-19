import 'package:nostr_core_dart/nostr.dart';

///Parameterized Replaceable Events
class Nip33 {
  //["a", "<kind>:<pubkey>:<d-identifier>", "<relay url>"]
  static EventCoordinates getEventCoordinates(List<String> tag) {
    if (tag[0] == 'a') {
      List<dynamic> parts = tag[1].split(':');
      int kind = int.parse(parts[0]);
      String pubkey = parts[1];
      String identifier = parts[2];
      String? relay;
      if (tag.length > 2) relay = tag[2];
      return EventCoordinates(kind, pubkey, identifier, relay);
    } else {
      throw Exception("not a 'a' tag");
    }
  }

  static List<String> coordinatesToTag(EventCoordinates eventCoordinates){
    return ['a', '${eventCoordinates.kind}:${eventCoordinates.pubkey}:${eventCoordinates.identifier}', eventCoordinates.relay ?? ''];
  }
}

class EventCoordinates {
  int kind;
  String pubkey;
  String identifier;
  String? relay;

  EventCoordinates(this.kind, this.pubkey, this.identifier, this.relay);
}
