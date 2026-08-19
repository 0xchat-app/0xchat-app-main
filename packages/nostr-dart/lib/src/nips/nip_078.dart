import 'package:nostr_core_dart/nostr.dart';

/// Arbitrary custom app data
/// https://github.com/nostr-protocol/nips/blob/master/78.md
class Nip78 {
  static String? dTag(List<List<String>> tags) {
    for (var tag in tags) {
      if (tag[0] == "d") return tag[1];
    }
    return null;
  }

  static AppData decodeAppData(Event event) {
    if (event.kind == 30078) {
      return AppData(
          dTag(event.tags), event.pubkey, event.createdAt, event.content);
    }
    throw Exception("${event.kind} is not nip1 compatible");
  }
}

class AppData {
  String? d;
  String pubkey;
  int createAt;
  String content;

  AppData(this.d, this.pubkey, this.createAt, this.content);
}
