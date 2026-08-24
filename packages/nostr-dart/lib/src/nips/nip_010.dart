///This NIP describes how to use "e" and "p" tags in text events,
///especially those that are replies to other text events.
///It helps clients thread the replies into a tree rooted at the original event.

class Nip10 {
  ///{
  ///     "tags": [
  ///         ["e", <kind_40_event_id>, <relay-url>, "root"],
  ///         ["e", <kind_42_event_id>, <relay-url>, "reply"],
  ///         ["p", <pubkey>, <relay-url>],
  ///         ...
  ///     ],
  ///     ...
  /// }
  static Thread fromTags(List<List<String>> tags) {
    ETag root = ETag('', '', '');
    ETag reply = ETag('', '', '');
    List<ETag> mention = [];
    List<PTag> ptags = [];
    for (var tag in tags) {
      if (tag[0] == "p") ptags.add(PTag(tag[1], tag.length > 2 ? tag[2] : ''));
      if (tag[0] == "e") {
        //Marked "e" tags (PREFERRED)
        if (tag.length > 3 && tag[3] == 'root') {
          root = ETag(tag[1], tag[2], tag[3]);
        } else if (tag.length > 3 && tag[3] == 'reply') {
          reply = ETag(tag[1], tag[2], tag[3]);
        } else if (tag.length > 3 && tag[3] == 'mention') {
          mention.add(ETag(tag[1], '', tag[3]));
        } else {
          // Positional "e" tags (DEPRECATED)
          if (root.eventId.isEmpty) {
            root = ETag(tag[1], '', 'root');
          } else {
            reply = ETag(tag[1], '', 'reply');
          }
        }
      }
    }
    // only reply, no root
    if(root.eventId.isEmpty && reply.eventId.isNotEmpty){
      root = ETag(reply.eventId, reply.relayURL, 'root');
      return Thread(root, null, mention, ptags);
    }
    return Thread(root, reply, mention, ptags);
  }

  static ETag rootTag(String eventId, String relay) {
    return ETag(eventId, relay, 'root');
  }

  static ETag replyTag(String eventId, String relay) {
    return ETag(eventId, relay, 'reply');
  }

  static List<PTag> pTags(List<String> pubkeys, List<String> relays) {
    List<PTag> result = [];
    for (int i = 0; i < pubkeys.length; ++i) {
      result.add(PTag(pubkeys[i], relays.length > i ? relays[i] : ''));
    }
    return result;
  }

  static List<List<String>> toTags(Thread thread) {
    List<List<String>> result = [];
    result.add(
        ["e", thread.root.eventId, thread.root.relayURL, thread.root.marker]);
    if (thread.reply != null && thread.reply!.eventId.isNotEmpty) {
      result.add([
        "e",
        thread.reply!.eventId,
        thread.reply!.relayURL,
        thread.reply!.marker
      ]);
    }
    if (thread.mentions != null) {
      for (var etag in thread.mentions!) {
        result.add(["e", etag.eventId, etag.relayURL, etag.marker]);
      }
    }
    if (thread.ptags != null) {
      for (var ptag in thread.ptags!) {
        result.add(["p", ptag.pubkey, ptag.relayURL]);
      }
    }
    return result;
  }
}

class ETag {
  String eventId;
  String relayURL;
  String marker; // root, reply, mention

  ETag(this.eventId, this.relayURL, this.marker);
}

class PTag {
  String pubkey;
  String relayURL;

  PTag(this.pubkey, this.relayURL);
}

class Thread {
  ETag root;
  ETag? reply;
  List<ETag>? mentions;
  List<PTag>? ptags;
  Thread(this.root, this.reply, this.mentions, this.ptags);
}
