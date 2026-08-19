import 'dart:convert';
import 'package:nostr_core_dart/nostr.dart';

/// Reposts & Quote Reposts
class Nip18 {
  static Future<Reposts> decodeReposts(Event event) async {
    if (event.kind == 6) {
      String repostId = '';
      Note? repostNote;
      for (var tag in event.tags) {
        if (tag[0] == "e") repostId = tag[1];
      }
      try {
        var repostJson = jsonDecode(event.content);
        Event repostEvent = await Event.fromJson(repostJson);
        repostNote = Nip1.decodeNote(repostEvent);
        repostId = repostNote.nodeId;
      } catch (_) {}

      return Reposts(event.id, event.pubkey, event.createdAt, event.content,
          repostId, repostNote, Nip10.fromTags(event.tags));
    }
    throw Exception("${event.kind} is not nip18 compatible");
  }

  static Future<Event> encodeReposts(
      String repostId,
      String? repostEventRelay,
      List<String> repostPubkeys,
      String? rawEvent,
      String pubkey,
      String privkey,
      {String? relayGroupId}) {
    List<List<String>> tags = [];
    tags.add(['e', repostId, repostEventRelay ?? '']);
    if (relayGroupId != null) tags.add(["h", relayGroupId]);
    for (var p in repostPubkeys) {
      tags.add(["p", p]);
    }
    String content = rawEvent ?? '';
    return Event.from(
        kind: 6,
        tags: tags,
        content: content,
        pubkey: pubkey,
        privkey: privkey);
  }

  static bool hasQTag(Event event) {
    for (var tag in event.tags) {
      if (tag[0] == "q") return true;
    }
    return false;
  }

  static QuoteReposts decodeQuoteReposts(Event event) {
    if (event.kind == 1) {
      String quoteRepostId = '';
      List<String> hashTags = [];
      Map<String, String> emojiMap = {};
      for (var tag in event.tags) {
        if (tag[0] == "q") quoteRepostId = tag[1];
        if (tag[0] == 't') hashTags.add(tag[1]);
        // Extract emoji tags (NIP-30)
        if (tag[0] == 'emoji' && tag.length >= 3) {
          emojiMap[tag[1]] = tag[2];
        }
      }

      return QuoteReposts(event.id, event.pubkey, event.createdAt,
          event.content, quoteRepostId, Nip10.fromTags(event.tags), hashTags, emojiMap);
    }
    throw Exception("${event.kind} is not nip18 compatible");
  }

  static Future<Event> encodeQuoteReposts(
      String quoteRepostId,
      List<String> quoteRepostPubkeys,
      String content,
      List<String>? hashTags,
      String pubkey,
      String privkey,
      {String? relayGroupId,
      Map<String, String>? emojiShortcodes}) {
    List<List<String>> tags = [];
    tags.add(['q', quoteRepostId]);
    if (relayGroupId != null) tags.add(["h", relayGroupId]);
    for (var p in quoteRepostPubkeys) {
      tags.add(["p", p]);
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
    return Event.from(
        kind: 1,
        tags: tags,
        content: content,
        pubkey: pubkey,
        privkey: privkey);
  }
}

class Reposts {
  String eventId;
  String pubkey;
  int createAt;
  String content;
  String repostId;
  Note? repostNote;
  Thread thread;

  Reposts(this.eventId, this.pubkey, this.createAt, this.content, this.repostId,
      this.repostNote, this.thread);
}

class QuoteReposts {
  String eventId;
  String pubkey;
  int createAt;
  String content;
  String quoteRepostsId;
  Thread thread;
  List<String>? hashTags;
  Map<String, String>? emojiShortcodes; // Custom emoji shortcode to URL map (NIP-30)

  QuoteReposts(this.eventId, this.pubkey, this.createAt, this.content,
      this.quoteRepostsId, this.thread, this.hashTags, [this.emojiShortcodes]);
}
