import 'dart:convert';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';

@reflector
class NoteDB extends DBObject {
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

  Map<String, int>? lastUpdatedTime;

  NoteDB({
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
    this.lastUpdatedTime,
  });

  @override
  Map<String, Object?> toMap() {
    return _noteInfoToMap(this);
  }

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

  static NoteDB fromMap(Map<String, Object?> map) {
    return _noteInfoFromMap(map);
  }

  static String? tableName() {
    return "NoteDB";
  }

  //primaryKey
  static List<String?> primaryKey() {
    return ['noteId'];
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

  static NoteDB noteDBFromNote(Note note) {
    Thread? thread = note.thread;
    String root = thread?.root.eventId ?? '';
    String rootRelay = thread?.root.relayURL ?? '';
    String? reply = thread?.reply?.eventId;
    String? replyRelay = thread?.reply?.relayURL;
    List<String>? mentions = thread?.mentions?.map((e) => e.eventId).toList();
    List<String>? pTags = thread?.ptags?.map((e) => e.pubkey).toList();
    return NoteDB(
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
        quoteRepostId: note.quoteRepostId);
  }

  static NoteDB noteDBFromReposts(Reposts reposts) {
    List<String>? pTags = reposts.thread.ptags?.map((e) => e.pubkey).toList();
    return NoteDB(
        noteId: reposts.eventId,
        author: reposts.pubkey,
        createAt: reposts.createAt,
        content: reposts.content,
        repostId: reposts.repostId,
        pTags: pTags);
  }

  static NoteDB noteDBFromQuoteReposts(QuoteReposts quoteReposts) {
    List<String>? pTags =
        quoteReposts.thread.ptags?.map((e) => e.pubkey).toList();
    return NoteDB(
        noteId: quoteReposts.eventId,
        author: quoteReposts.pubkey,
        createAt: quoteReposts.createAt,
        content: quoteReposts.content,
        quoteRepostId: quoteReposts.quoteRepostsId,
        pTags: pTags,
        hashTags: quoteReposts.hashTags);
  }

  static NoteDB noteDBFromReactions(Reactions reactions) {
    List<String>? pTags = reactions.thread.ptags?.map((e) => e.pubkey).toList();
    return NoteDB(
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
    lastUpdatedTime ??= {};
    if (lastUpdatedTime!.containsKey(relay)) {
      return lastUpdatedTime![relay]!;
    }
    return 0;
  }

  static Future<void> migrateToISAR() async {
    List<NoteDB> notes = await DB.sharedInstance.objects<NoteDB>();
    List<NoteDBISAR> notesISAR = [];
    for (var note in notes) {
      notesISAR.add(NoteDBISAR.fromMap(note.toMap()));
    }
    await DBISAR.sharedInstance.isar.writeTxn(() async {
      await DBISAR.sharedInstance.isar.noteDBISARs.putAll(notesISAR);
    });
  }
}

Map<String, dynamic> _noteInfoToMap(NoteDB instance) => <String, dynamic>{
      'noteId': instance.noteId,
      'groupId': instance.groupId,
      'author': instance.author,
      'createAt': instance.createAt,
      'content': instance.content,
      'root': instance.root,
      'rootRelay': instance.rootRelay,
      'reply': instance.reply,
      'replyRelay': instance.replyRelay,
      'mentions': jsonEncode(instance.mentions),
      'pTags': jsonEncode(instance.pTags),
      'hashTags': jsonEncode(instance.hashTags),
      'private': instance.private,
      'read': instance.read,
      'warning': instance.warning,
      'repostId': instance.repostId,
      'quoteRepostId': instance.quoteRepostId,
      'reactedId': instance.reactedId,
      'reactedKind': instance.reactedKind,
      'emojiShortcode': instance.emojiShortcode,
      'emojiURL': instance.emojiURL,
      'replyCount': instance.replyCount,
      'repostCount': instance.repostCount,
      'quoteRepostCount': instance.quoteRepostCount,
      'reactionCount': instance.reactionCount,
      'zapCount': instance.zapCount,
      'zapAmount': instance.zapAmount,
      'replyCountByMe': instance.replyCountByMe,
      'repostCountByMe': instance.repostCountByMe,
      'quoteRepostCountByMe': instance.quoteRepostCountByMe,
      'reactionCountByMe': instance.reactionCountByMe,
      'zapCountByMe': instance.zapCountByMe,
      'zapAmountByMe': instance.zapAmountByMe,
      'rawEvent': instance.rawEvent,
      'replyEventIds': jsonEncode(instance.replyEventIds),
      'repostEventIds': jsonEncode(instance.repostEventIds),
      'quoteRepostEventIds': jsonEncode(instance.quoteRepostEventIds),
      'reactionEventIds': jsonEncode(instance.reactionEventIds),
      'zapEventIds': jsonEncode(instance.zapEventIds),
      'lastUpdatedTime': jsonEncode(instance.lastUpdatedTime),
    };

NoteDB _noteInfoFromMap(Map<String, dynamic> map) {
  return NoteDB(
    noteId: map['noteId'].toString(),
    groupId: map['groupId'].toString(),
    author: map['author'].toString(),
    createAt: map['createAt'],
    content: map['content'].toString(),
    root: map['root'].toString(),
    rootRelay: map['rootRelay']?.toString(),
    reply: map['reply']?.toString(),
    replyRelay: map['replyRelay']?.toString(),
    mentions: NoteDB.decodeStringList(map['mentions']?.toString()),
    pTags: NoteDB.decodeStringList(map['pTags']?.toString()),
    hashTags: NoteDB.decodeStringList(map['hashTags']?.toString()),
    private: (map['private'] ?? 0) > 0 ? true : false,
    read: (map['read'] ?? 0) > 0 ? true : false,
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
    replyEventIds: NoteDB.decodeStringList(map['replyEventIds']?.toString()),
    repostEventIds: NoteDB.decodeStringList(map['repostEventIds']?.toString()),
    quoteRepostEventIds:
        NoteDB.decodeStringList(map['quoteRepostEventIds']?.toString()),
    reactionEventIds:
        NoteDB.decodeStringList(map['reactionEventIds']?.toString()),
    zapEventIds: NoteDB.decodeStringList(map['zapEventIds']?.toString()),
    lastUpdatedTime: RelayDBISAR.decodeMap(map['lastUpdatedTime'].toString()),
  );
}
