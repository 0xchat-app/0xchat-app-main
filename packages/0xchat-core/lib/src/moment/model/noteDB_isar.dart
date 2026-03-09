import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:nostr_core_dart/nostr.dart';

part 'noteDB_isar.g.dart';

extension NoteDBISARExtensions on NoteDBISAR {
  NoteDBISAR withGrowableLevels() => this
    ..mentions = mentions?.toList()
    ..pTags = pTags?.toList()
    ..hashTags = hashTags?.toList()
    ..replyEventIds = replyEventIds?.toList()
    ..repostEventIds = repostEventIds?.toList()
    ..quoteRepostEventIds = quoteRepostEventIds?.toList()
    ..reactionEventIds = reactionEventIds?.toList()
    ..zapEventIds = zapEventIds?.toList()
    ..relayList = relayList?.toList();
}

@collection
class NoteDBISAR {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String noteId; //event id

  String groupId; // group/community note
  String author;
  int createAt;
  String content;
  String? root;
  String? rootRelay;
  String? reply;
  String? replyRelay;
  List<String>? mentions;
  List<String>? pTags;
  List<String>? hashTags;

  /// private or public notes
  bool private;
  bool read;
  String? warning;

  /// repost & quote repost
  String? repostId;
  String? quoteRepostId;

  /// reaction
  String? reactedId;
  String? reactedKind;
  String? emojiShortcode;
  String? emojiURL;
  bool findEvent;

  /// Custom emojis in note content (NIP-30)
  /// Stored as JSON string: {"shortcode1": "url1", "shortcode2": "url2"}
  String? emojiShortcodesJson;

  /// actions count
  int replyCount;
  int repostCount;
  int quoteRepostCount;
  int reactionCount;
  int zapCount;
  int zapAmount;

  /// actions count by me
  int replyCountByMe;
  int repostCountByMe;
  int quoteRepostCountByMe;
  int reactionCountByMe;
  int zapCountByMe;
  int zapAmountByMe;

  String? rawEvent;

  /// actions event ids
  List<String>? replyEventIds;
  List<String>? repostEventIds;
  List<String>? quoteRepostEventIds;
  List<String>? reactionEventIds;
  List<String>? zapEventIds;

  /// relay list that this note comes from
  List<String>? relayList;

  String? lastUpdatedTimeString;

  NoteDBISAR({
    this.noteId = '',
    this.groupId = '',
    this.author = '',
    this.createAt = 0,
    this.content = '',
    this.root = '',
    this.rootRelay,
    this.reply,
    this.replyRelay,
    this.mentions,
    this.pTags,
    this.hashTags,
    this.private = false,
    this.read = false,
    this.warning,
    this.repostId = '',
    this.quoteRepostId = '',
    this.reactedId = '',
    this.reactedKind = '',
    this.emojiShortcode = '',
    this.emojiURL = '',
    this.findEvent = false,
    this.replyCount = 0,
    this.repostCount = 0,
    this.quoteRepostCount = 0,
    this.reactionCount = 0,
    this.zapCount = 0,
    this.zapAmount = 0,
    this.replyCountByMe = 0,
    this.repostCountByMe = 0,
    this.quoteRepostCountByMe = 0,
    this.reactionCountByMe = 0,
    this.zapCountByMe = 0,
    this.zapAmountByMe = 0,
    this.rawEvent = '',
    this.replyEventIds,
    this.repostEventIds,
    this.quoteRepostEventIds,
    this.reactionEventIds,
    this.zapEventIds,
    this.relayList,
    this.lastUpdatedTimeString,
    this.emojiShortcodesJson,
  });

  int getNoteKind() {
    if (repostId != null && repostId!.isNotEmpty) return 6;
    if (reactedId != null && reactedId!.isNotEmpty) return 7;
    if (quoteRepostId != null && quoteRepostId!.isNotEmpty) return 2;
    if (root != null && root!.isNotEmpty) return 1;
    return 0;
  }

  int getReplyLevel(String? noteId) {
    root ??= '';
    reply ??= '';
    if (root!.isNotEmpty && reply!.isEmpty) return 1;
    if (root == noteId && reply == noteId) return 1;
    if (root == noteId && reply!.isNotEmpty) return 2;
    if (reply == noteId || root == noteId) return 1;
    return 0;
  }

  String get encodedNoteId {
    return Nip19.encodeNote(noteId);
  }

  // Get emoji shortcodes as Map (NIP-30)
  @ignore
  Map<String, String> get emojiShortcodes {
    if (emojiShortcodesJson == null || emojiShortcodesJson!.isEmpty) {
      return {};
    }
    try {
      final decoded = jsonDecode(emojiShortcodesJson!);
      if (decoded is Map) {
        return Map<String, String>.from(decoded);
      }
    } catch (e) {
      // Invalid JSON, return empty map
    }
    return {};
  }

  set lastUpdatedTime(Map<String, int> attributes) {
    lastUpdatedTimeString = jsonEncode(attributes);
  }

  @ignore
  Map<String, int> get lastUpdatedTime {
    return lastUpdatedTimeString != null
        ? Map<String, int>.from(jsonDecode(lastUpdatedTimeString!))
        : {};
  }

  static NoteDBISAR fromMap(Map<String, Object?> map) {
    return _noteInfoFromMap(map);
  }

  static List<String>? decodeStringList(String? list) {
    if (list == null) return null;
    try {
      List<dynamic> result = jsonDecode(list);
      return result.map((e) => e.toString()).toList();
    } catch (e) {
      return null;
    }
  }

  static Map<String, dynamic>? decodeNote(String encodedNote) {
    if (encodedNote.startsWith('nostr:')) {
      encodedNote = Nip21.decode(encodedNote)!;
    }
    if (encodedNote.startsWith('nevent')) {
      Map result = Nip19.decodeShareableEntity(encodedNote);
      if (result['prefix'] == 'nevent') {
        return {
          'channelId': result['special'],
          'relays': result['relays'],
          'author': result['author'],
          'kind': result['kind']
        };
      }
    } else if (encodedNote.startsWith('note')) {
      return {
        'channelId': Nip19.decodeNote(encodedNote),
        'relays': [],
        'author': null,
        'kind': 40
      };
    }
    return null;
  }

  static NoteDBISAR noteDBFromNote(Note note) {
    Thread? thread = note.thread;
    String root = thread?.root.eventId ?? '';
    String rootRelay = thread?.root.relayURL ?? '';
    String? reply = thread?.reply?.eventId;
    String? replyRelay = thread?.reply?.relayURL;
    List<String>? mentions = thread?.mentions?.map((e) => e.eventId).toList();
    List<String>? pTags = thread?.ptags?.map((e) => e.pubkey).toList();
    // Encode emoji shortcodes to JSON string for storage (NIP-30)
    String? emojiJson;
    if (note.emojiShortcodes != null && note.emojiShortcodes!.isNotEmpty) {
      emojiJson = jsonEncode(note.emojiShortcodes);
    }
    return NoteDBISAR(
        noteId: note.nodeId,
        author: note.pubkey,
        createAt: note.createdAt,
        content: note.content,
        root: root,
        rootRelay: rootRelay,
        reply: reply,
        replyRelay: replyRelay,
        mentions: mentions,
        pTags: pTags,
        hashTags: note.hashTags,
        quoteRepostId: note.quoteRepostId,
        emojiShortcodesJson: emojiJson);
  }

  static NoteDBISAR noteDBFromReposts(Reposts reposts) {
    List<String>? pTags = reposts.thread.ptags?.map((e) => e.pubkey).toList();
    return NoteDBISAR(
        noteId: reposts.eventId,
        author: reposts.pubkey,
        createAt: reposts.createAt,
        content: reposts.content,
        repostId: reposts.repostId,
        pTags: pTags);
  }

  static NoteDBISAR noteDBFromQuoteReposts(QuoteReposts quoteReposts) {
    List<String>? pTags =
        quoteReposts.thread.ptags?.map((e) => e.pubkey).toList();
    // Encode emoji shortcodes to JSON string for storage (NIP-30)
    String? emojiJson;
    if (quoteReposts.emojiShortcodes != null && quoteReposts.emojiShortcodes!.isNotEmpty) {
      emojiJson = jsonEncode(quoteReposts.emojiShortcodes);
    }
    return NoteDBISAR(
        noteId: quoteReposts.eventId,
        author: quoteReposts.pubkey,
        createAt: quoteReposts.createAt,
        content: quoteReposts.content,
        quoteRepostId: quoteReposts.quoteRepostsId,
        pTags: pTags,
        hashTags: quoteReposts.hashTags,
        emojiShortcodesJson: emojiJson);
  }

  static NoteDBISAR noteDBFromReactions(Reactions reactions) {
    List<String>? pTags = reactions.thread.ptags?.map((e) => e.pubkey).toList();
    return NoteDBISAR(
        noteId: reactions.id,
        author: reactions.pubkey,
        createAt: reactions.createAt,
        content: reactions.content,
        reactedId: reactions.reactedEventId,
        reactedKind: reactions.reactedKind,
        emojiShortcode: reactions.emojiReaction?.shortcode,
        emojiURL: reactions.emojiReaction?.url,
        pTags: pTags);
  }

  int getLastUpdatedTime(String relay) {
    if (lastUpdatedTime.containsKey(relay)) {
      return lastUpdatedTime[relay]!;
    }
    return 0;
  }
}

NoteDBISAR _noteInfoFromMap(Map<String, dynamic> map) {
  return NoteDBISAR(
    noteId: map['noteId'].toString(),
    groupId: map['groupId'].toString(),
    author: map['author'].toString(),
    createAt: map['createAt'],
    content: map['content'].toString(),
    root: map['root'].toString(),
    rootRelay: map['rootRelay']?.toString(),
    reply: map['reply']?.toString(),
    replyRelay: map['replyRelay']?.toString(),
    mentions: NoteDBISAR.decodeStringList(map['mentions']?.toString()),
    pTags: NoteDBISAR.decodeStringList(map['pTags']?.toString()),
    hashTags: NoteDBISAR.decodeStringList(map['hashTags']?.toString()),
    private: map['private'],
    read: map['read'],
    warning: map['warning']?.toString(),
    repostId: map['repostId']?.toString(),
    quoteRepostId: map['quoteRepostId']?.toString(),
    reactedId: map['reactedId']?.toString(),
    reactedKind: map['reactedKind']?.toString(),
    emojiShortcode: map['emojiShortcode']?.toString(),
    emojiURL: map['emojiURL']?.toString(),
    replyCount: map['replyCount'],
    repostCount: map['repostCount'],
    quoteRepostCount: map['quoteRepostCount'],
    reactionCount: map['reactionCount'],
    zapCount: map['zapCount'],
    zapAmount: map['zapAmount'],
    replyCountByMe: map['replyCountByMe'],
    repostCountByMe: map['repostCountByMe'],
    quoteRepostCountByMe: map['quoteRepostCountByMe'],
    reactionCountByMe: map['reactionCountByMe'],
    zapCountByMe: map['zapCountByMe'],
    zapAmountByMe: map['zapAmountByMe'],
    rawEvent: map['rawEvent']?.toString(),
    replyEventIds:
        NoteDBISAR.decodeStringList(map['replyEventIds']?.toString()),
    repostEventIds:
        NoteDBISAR.decodeStringList(map['repostEventIds']?.toString()),
    quoteRepostEventIds:
        NoteDBISAR.decodeStringList(map['quoteRepostEventIds']?.toString()),
    reactionEventIds:
        NoteDBISAR.decodeStringList(map['reactionEventIds']?.toString()),
    zapEventIds: NoteDBISAR.decodeStringList(map['zapEventIds']?.toString()),
    relayList: NoteDBISAR.decodeStringList(map['relayList']?.toString()),
    lastUpdatedTimeString: map['lastUpdatedTime'].toString(),
  );
}
