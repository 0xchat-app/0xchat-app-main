import 'package:nostr_core_dart/nostr.dart';

/// Long-form Content
class Nip23 {
  static LongFormContent decode(Event event) {
    if (event.kind == 30023) {
      String? d, title, summary, publishedAt, image;
      List<String> t = [];
      for (var tag in event.tags) {
        if (tag[0] == "d") d = tag[1];
        if (tag[0] == "title") title = tag[1];
        if (tag[0] == "published_at") publishedAt = tag[1];
        if (tag[0] == "image") image = tag[1];
        if (tag[0] == "t") t.add(tag[1]);
      }
      return LongFormContent(event.pubkey, event.createdAt, event.content, d,
          title, summary, image, publishedAt, t);
    }
    throw Exception("${event.kind} is not nip23 compatible");
  }
}

class LongFormContent {
  String pubkey;
  int createAt;
  String content;
  String? d;
  String? title;
  String? summary;
  String? image;
  String? publishedAt;
  List<String>? hashtags;

  LongFormContent(this.pubkey, this.createAt, this.content, this.d, this.title,
      this.summary, this.image, this.publishedAt, this.hashtags);
}
