import 'dart:async';

import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';

extension ENote on RelayGroup {
  Future<void> handleGroupNotes(Event event, String relay) async {
    GroupNote groupNote = Nip29.decodeGroupNote(event);
    NoteDBISAR noteDB = NoteDBISAR.noteDBFromNote(groupNote.note);
    noteDB.groupId = groupNote.groupId;
    // reply
    if (noteDB.getNoteKind() == 1) {
      await Moment.sharedInstance.addReplyToNote(event, noteDB.reply ?? noteDB.root!);
    }
    // quote repost
    else if (noteDB.getNoteKind() == 2) {
      await Moment.sharedInstance.addQuoteRepostToNote(event, noteDB.quoteRepostId!);
    }
    noteCallBack?.call(noteDB);
    Moment.sharedInstance.handleNewNotes(noteDB);
  }

  Future<OKEvent> sendGroupNotes(String groupId, String content, List<String> previous,
      {String? rootEvent,
      String? replyEvent,
      List<String>? mentions,
      List<String>? hashTags}) async {
    RelayGroupDBISAR? groupDB = myGroups[groupId]?.value;
    if (groupDB == null) return OKEvent(groupId, false, 'group not exit');
    Completer<OKEvent> completer = Completer<OKEvent>();
    Event event;
    List<String> previous = await getPrevious(groupId);
    if (rootEvent == null) {
      event = await Nip29.encodeGroupNote(groupId, content, pubkey, privkey, previous);
    } else {
      event = await Nip29.encodeGroupNoteReply(groupId, content, pubkey, privkey, previous,
          rootEvent: rootEvent, replyEvent: replyEvent, replyUsers: mentions, hashTags: hashTags);
    }
    handleGroupNotes(event, groupDB.relay);
    Connect.sharedInstance.sendEvent(event, toRelays: [groupDB.relay],
        sendCallBack: (ok, relay) async {
      if (!completer.isCompleted) completer.complete(ok);
    });
    return completer.future;
  }

  Future<OKEvent> sendGroupNoteReply(String replyNoteId, String content, List<String> previous,
      {List<String>? hashTags, List<String>? mentions}) async {
    NoteDBISAR? note = await Moment.sharedInstance.loadNoteWithNoteId(replyNoteId);
    if (note == null) {
      return OKEvent(replyNoteId, false, 'reacted note DB == null');
    }
    String groupId = note.groupId;
    if (groupId.isEmpty) {
      return OKEvent(replyNoteId, false, 'group not exit');
    }
    RelayGroupDBISAR? groupDB = groups[groupId]?.value;
    if (groupDB == null) {
      return OKEvent(replyNoteId, false, 'group not exit');
    }

    String? rootEventId = note.root;
    note.pTags ??= [];
    late OKEvent okEvent;
    if (rootEventId == null || rootEventId.isEmpty) {
      if (!note.pTags!.contains(note.author)) {
        note.pTags!.add(note.author);
      }
      for (var mention in mentions ?? []) {
        if (!note.pTags!.contains(mention)) {
          note.pTags!.add(mention);
        }
      }
      okEvent = await sendGroupNotes(note.groupId, content, previous,
          rootEvent: replyNoteId, mentions: note.pTags, hashTags: hashTags);
    } else {
      NoteDBISAR? rootNote = await Moment.sharedInstance.loadNoteWithNoteId(rootEventId);
      if (rootNote?.author.isNotEmpty == true && !note.pTags!.contains(rootNote?.author)) {
        note.pTags!.add(rootNote!.author);
      }
      if (!note.pTags!.contains(note.author)) {
        note.pTags!.add(note.author);
      }
      okEvent = await sendGroupNotes(note.groupId, content, previous,
          rootEvent: rootEventId,
          mentions: note.pTags,
          replyEvent: replyNoteId,
          hashTags: hashTags);
    }
    return okEvent;
  }

  Future<OKEvent> sendGroupNoteReaction(String reactedNoteId,
      {bool like = true, String? content, String? emojiShotCode, String? emojiURL}) async {
    NoteDBISAR? note = await Moment.sharedInstance.loadNoteWithNoteId(reactedNoteId);
    if (note == null) {
      return OKEvent(reactedNoteId, false, 'reacted note DB == null');
    }
    String groupId = note.groupId;
    if (groupId.isEmpty) {
      return OKEvent(reactedNoteId, false, 'group not exit');
    }
    RelayGroupDBISAR? groupDB = groups[groupId]?.value;
    if (groupDB == null) {
      return OKEvent(reactedNoteId, false, 'group not exit');
    }

    Completer<OKEvent> completer = Completer<OKEvent>();
    if (!note.pTags!.contains(note.author)) {
      note.pTags!.add(note.author);
    }
    Event event = await Nip25.encode(reactedNoteId, note.pTags ?? [], '1', like, pubkey, privkey,
        content: content, emojiShotCode: emojiShotCode, emojiURL: emojiURL, relayGroupId: groupId);

    Connect.sharedInstance.sendEvent(event, toRelays: [groupDB.relay],
        sendCallBack: (ok, relay) async {
      if (ok.status) {
        NoteDBISAR noteDB = NoteDBISAR.noteDBFromReactions(Nip25.decode(event));
        noteDB.groupId = groupId;
        Moment.sharedInstance.saveNoteToDB(noteDB, null);

        note.reactionEventIds ??= [];
        if (!note.reactionEventIds!.contains(event.id)) {
          note.reactionEventIds!.add(event.id);
          note.reactionCount++;
          note.reactionCountByMe++;
          Moment.sharedInstance.saveNoteToDB(note, null);
        }
      }
      if (!completer.isCompleted) completer.complete(ok);
    });
    return completer.future;
  }

  Future<OKEvent> sendRepost(String repostNoteId, String? repostNoteRelay) async {
    NoteDBISAR? note = await Moment.sharedInstance.loadNoteWithNoteId(repostNoteId);
    if (note == null) {
      return OKEvent(repostNoteId, false, 'reacted note DB == null');
    }
    String groupId = note.groupId;
    if (groupId.isEmpty) {
      return OKEvent(repostNoteId, false, 'group not exit');
    }
    RelayGroupDBISAR? groupDB = groups[groupId]?.value;
    if (groupDB == null) {
      return OKEvent(repostNoteId, false, 'group not exit');
    }

    Completer<OKEvent> completer = Completer<OKEvent>();
    if (!note.pTags!.contains(note.author)) {
      note.pTags!.add(note.author);
    }
    Event event = await Nip18.encodeReposts(
        repostNoteId, repostNoteRelay, note.pTags ?? [], note.rawEvent, pubkey, privkey,
        relayGroupId: groupId);

    Reposts r = await Nip18.decodeReposts(event);
    NoteDBISAR noteDB = NoteDBISAR.noteDBFromReposts(r);
    noteDB.groupId = groupId;
    await Moment.sharedInstance.saveNoteToDB(noteDB, null);

    note.repostEventIds ??= [];
    note.repostEventIds!.add(event.id);
    note.repostCount++;
    note.repostCountByMe++;
    Moment.sharedInstance.saveNoteToDB(note, null);

    Connect.sharedInstance.sendEvent(event, toRelays: [groupDB.relay],
        sendCallBack: (ok, relay) async {
      if (!completer.isCompleted) completer.complete(ok);
    });

    return completer.future;
  }

  Future<OKEvent> sendQuoteRepost(String quoteRepostNoteId, String content,
      {List<String>? hashTags, List<String>? mentions}) async {
    NoteDBISAR? note = await Moment.sharedInstance.loadNoteWithNoteId(quoteRepostNoteId);
    if (note == null) {
      return OKEvent(quoteRepostNoteId, false, 'reacted note DB == null');
    }
    String groupId = note.groupId;
    if (groupId.isEmpty) {
      return OKEvent(quoteRepostNoteId, false, 'group not exit');
    }
    RelayGroupDBISAR? groupDB = groups[groupId]?.value;
    if (groupDB == null) {
      return OKEvent(quoteRepostNoteId, false, 'group not exit');
    }

    Completer<OKEvent> completer = Completer<OKEvent>();
    if (!note.pTags!.contains(note.author)) {
      note.pTags!.add(note.author);
    }
    String nostrNote = Nip21.encode(Nip19.encodeNote(quoteRepostNoteId));
    content = '$content\n$nostrNote';
    Event event = await Nip18.encodeQuoteReposts(
        quoteRepostNoteId, note.pTags ?? [], content, hashTags, pubkey, privkey,
        relayGroupId: groupId);
    for (var mention in mentions ?? []) {
      if (!note.pTags!.contains(mention)) {
        note.pTags!.add(mention);
      }
    }
    NoteDBISAR noteDB = NoteDBISAR.noteDBFromQuoteReposts(Nip18.decodeQuoteReposts(event));
    noteDB.groupId = groupId;
    await Moment.sharedInstance.saveNoteToDB(noteDB, null);

    note.quoteRepostEventIds ??= [];
    note.quoteRepostEventIds!.add(event.id);
    note.quoteRepostCount++;
    note.quoteRepostCountByMe++;
    Moment.sharedInstance.saveNoteToDB(note, null);

    Connect.sharedInstance.sendEvent(event, toRelays: [groupDB.relay],
        sendCallBack: (ok, relay) async {
      if (!completer.isCompleted) completer.complete(ok);
    });

    return completer.future;
  }

  Future<List<NoteDBISAR>?> loadGroupNotesFromDB(String id, {int limit = 50, int? until}) async {
    until ??= currentUnixTimestampSeconds() + 1;
    List<NoteDBISAR>? notes =
        await Moment.sharedInstance.searchNotesFromDB(groupId: id, until: until, limit: limit);
    for (var note in notes) {
      Moment.sharedInstance.notesCache[note.noteId] = note;
    }
    return notes;
  }
}
