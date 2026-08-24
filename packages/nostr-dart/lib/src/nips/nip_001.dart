import 'package:nostr_core_dart/nostr.dart';

/// Basic Event Kinds
/// 0: set_metadata: the content is set to a stringified JSON object {name: <username>, about: <string>, picture: <url, string>} describing the user who created the event. A relay may delete past set_metadata events once it gets a new one for the same pubkey.
/// 1: text_note: the content is set to the plaintext content of a note (anything the user wants to say). Do not use Markdown! Clients should not have to guess how to interpret content like [](). Use different event kinds for parsable content.
/// 2: recommend_server: the content is set to the URL (e.g., wss://somerelay.com) of a relay the event creator wants to recommend to its followers.
class Nip1 {
  static Future<Event> setMetadata(
      String content, String pubkey, String privkey) async {
    return await Event.from(
        kind: 0, tags: [], content: content, pubkey: pubkey, privkey: privkey);
  }

  static Future<Event> encodeNote(String content, String pubkey, String privkey,
      {String? rootEvent,
      String? rootEventRelay,
      String? replyEvent,
      String? replyEventRelay,
      List<String>? replyUsers,
      List<String>? replyUserRelays,
      List<String>? hashTags,
      Map<String, String>? emojiShortcodes}) async {
    List<List<String>> tags = [];
    if (rootEvent != null) {
      ETag root = Nip10.rootTag(rootEvent, rootEventRelay ?? '');
      ETag? reply = replyEvent == null
          ? null
          : Nip10.replyTag(replyEvent, replyEventRelay ?? '');
      Thread thread = Thread(root, reply, null, null);
      tags = Nip10.toTags(thread);
    }
    List<PTag> pTags = Nip10.pTags(replyUsers ?? [], replyUserRelays ?? []);
    for (var pTag in pTags) {
      tags.add(["p", pTag.pubkey, pTag.relayURL]);
    }
    if (hashTags != null) {
      for (var t in hashTags) {
        tags.add(['t', t]);
      }
    }
    // Add emoji tags for custom emojis (NIP-30)
    if (emojiShortcodes != null) {
      emojiShortcodes.forEach((shortcode, url) {
        tags.add(['emoji', shortcode, url]);
      });
    }

    return await Event.from(
        kind: 1,
        tags: tags,
        content: content,
        pubkey: pubkey,
        privkey: privkey);
  }

  static List<String>? hashTags(List<List<String>> tags) {
    List<String> hashTags = [];
    for (var tag in tags) {
      if (tag[0] == 't') hashTags.add(tag[1]);
    }
    return hashTags;
  }

  // Extract custom emoji tags (NIP-30)
  static Map<String, String> emojiTags(List<List<String>> tags) {
    Map<String, String> emojiMap = {};
    for (var tag in tags) {
      if (tag[0] == 'emoji' && tag.length >= 3) {
        emojiMap[tag[1]] = tag[2];
      }
    }
    return emojiMap;
  }

  static String? quoteRepostId(List<List<String>> tags) {
    for (var tag in tags) {
      if (tag[0] == 'q') return tag[1];
    }
    return null;
  }

  static String groupId(List<List<String>> tags) {
    for (var tag in tags) {
      if (tag[0] == 'h') return tag[1];
    }
    return '';
  }

  static Note decodeNote(Event event) {
    if (event.kind == 1 || event.kind == 11 || event.kind == 12) {
      return Note(
          event.id,
          event.pubkey,
          event.createdAt,
          Nip10.fromTags(event.tags),
          event.content,
          hashTags(event.tags),
          quoteRepostId(event.tags),
          groupId(event.tags),
          emojiTags(event.tags));
    }
    throw Exception("${event.kind} is not nip1 compatible");
  }

  static Future<Event> recommendServer(
      String content, String pubkey, String privkey) async {
    return await Event.from(
        kind: 2, tags: [], content: content, pubkey: pubkey, privkey: privkey);
  }
}

class Note {
  String nodeId;
  String pubkey;
  int createdAt;
  Thread? thread;
  String content;
  List<String>? hashTags;
  String? quoteRepostId;
  String groupId;
  Map<String, String>? emojiShortcodes; // Custom emoji shortcode to URL map (NIP-30)

  Note(this.nodeId, this.pubkey, this.createdAt, this.thread, this.content,
      this.hashTags, this.quoteRepostId, this.groupId, [this.emojiShortcodes]);
}
