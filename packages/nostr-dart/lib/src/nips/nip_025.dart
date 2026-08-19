import 'package:nostr_core_dart/nostr.dart';

/// Reactions
class Nip25 {
  static Future<Event> encode(String reactedId, List<String> reactedPubkeys,
      String reactedKind, bool upVote, String pubkey, String privkey,
      {String? content,
      String? emojiShotCode,
      String? emojiURL,
      String? relayGroupId}) async {
    content ??= upVote ? '+' : '-';
    List<List<String>> tags = [];
    tags.add(["e", reactedId]);
    tags.add(["k", reactedKind]);
    if (relayGroupId != null) tags.add(["h", relayGroupId]);
    for (var p in reactedPubkeys) {
      tags.add(["p", p]);
    }
    if (emojiShotCode != null && emojiURL != null) {
      content = ":$emojiShotCode:";
      tags.add(["emoji", emojiShotCode, emojiURL]);
    }
    return await Event.from(
        kind: 7,
        tags: tags,
        content: content,
        pubkey: pubkey,
        privkey: privkey);
  }

  static Reactions decode(Event event) {
    if (event.kind == 7) {
      String? reactedEventId, reactedPubkey, reactedKind;
      EmojiReaction? emojiReaction;
      for (var tag in event.tags) {
        if (tag[0] == "e") reactedEventId = tag[1];
        if (tag[0] == "p") reactedPubkey = tag[1];
        if (tag[0] == "k") reactedKind = tag[1];
        if (tag[0] == 'emoji' && tag.length > 2) {
          emojiReaction = EmojiReaction(tag[1], tag[2]);
        }
      }
      return Reactions(
          event.id,
          event.pubkey,
          event.createdAt,
          event.content,
          reactedEventId ?? '',
          reactedPubkey ?? '',
          reactedKind,
          emojiReaction,
          Nip10.fromTags(event.tags));
    }
    throw Exception("${event.kind} is not nip25 compatible");
  }
}

class Reactions {
  String id;
  String pubkey;
  int createAt;
  String content;
  String reactedEventId;
  String reactedPubkey;
  String? reactedKind;
  EmojiReaction? emojiReaction;
  Thread thread;

  Reactions(
      this.id,
      this.pubkey,
      this.createAt,
      this.content,
      this.reactedEventId,
      this.reactedPubkey,
      this.reactedKind,
      this.emojiReaction,
      this.thread);
}

class EmojiReaction {
  String shortcode;
  String url;

  EmojiReaction(this.shortcode, this.url);
}
