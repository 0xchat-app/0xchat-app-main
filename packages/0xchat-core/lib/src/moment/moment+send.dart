import 'dart:async';

import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';

typedef SendMessageProgressCallBack = void Function(int progress);

extension Send on Moment {
  Future<OKEvent> sendPublicNote(String content,
      {String? rootEvent,
      String? rootEventRelay,
      String? replyEvent,
      String? replyEventRelay,
      List<String>? mentions,
      List<String>? mentionsRelays,
      List<String>? hashTags,
      Map<String, String>? emojiShortcodes,
      List<RelayKind>? relayKinds}) async {
    Completer<OKEvent> completer = Completer<OKEvent>();
    Event event = await Nip1.encodeNote(content, pubkey, privkey,
        rootEvent: rootEvent,
        rootEventRelay: rootEventRelay,
        replyEvent: replyEvent,
        replyEventRelay: replyEventRelay,
        replyUsers: mentions,
        replyUserRelays: mentionsRelays,
        hashTags: hashTags,
        emojiShortcodes: emojiShortcodes);
    Connect.sharedInstance.sendEvent(
      event,
      relayKinds: relayKinds ?? [RelayKind.general, RelayKind.outbox],
      sendCallBack: (ok, relay) async {
        if (!completer.isCompleted) {
          await handleNoteEvent(event, relay, false);
          completer.complete(ok);
        }
      },
    );

    return completer.future;
  }

  Future<OKEvent> _sendPrivateNote(String content, List<String> pubkeys,
      {String? rootEvent,
      String? rootEventRelay,
      String? replyEvent,
      String? replyEventRelay,
      List<String>? mentions,
      List<String>? mentionsRelays,
      List<String>? hashTags,
      Map<String, String>? emojiShortcodes,
      SendMessageProgressCallBack? sendMessageProgressCallBack}) async {
    Event event = await Nip1.encodeNote(content, pubkey, privkey,
        rootEvent: rootEvent,
        rootEventRelay: rootEventRelay,
        replyEvent: replyEvent,
        replyEventRelay: replyEventRelay,
        replyUsers: mentions,
        replyUserRelays: mentionsRelays,
        hashTags: hashTags,
        emojiShortcodes: emojiShortcodes);
    await handleNoteEvent(event, '', true);
    int sendedMessagesCount = 0;
    return await sendPrivateMessage(pubkeys, event, sendMessageCallBack: () {
      sendMessageProgressCallBack?.call(++sendedMessagesCount);
    });
  }

  Future<OKEvent> sendPrivateMessage(List<String>? receivers, Event event,
      {SendMessageCallBack? sendMessageCallBack}) async {
    return Groups.sharedInstance
        .sendMessageEvent(receivers, event, sendMessageCallBack: sendMessageCallBack);
  }

  Future<OKEvent> sendNoteContacts(String content,
      {String? rootEvent,
      String? rootEventRelay,
      String? replyEvent,
      String? replyEventRelay,
      List<String>? mentions,
      List<String>? mentionsRelays,
      List<String>? hashTags,
      SendMessageProgressCallBack? sendMessageProgressCallBack}) async {
    List<String> toPubkeys = Contacts.sharedInstance.allContacts.keys.toList();
    toPubkeys.add(pubkey);
    return await _sendPrivateNote(content, toPubkeys,
        rootEvent: rootEvent,
        rootEventRelay: rootEventRelay,
        replyEvent: replyEvent,
        replyEventRelay: replyEventRelay,
        mentions: mentions,
        mentionsRelays: mentionsRelays,
        hashTags: hashTags,
        sendMessageProgressCallBack: sendMessageProgressCallBack);
  }

  Future<OKEvent> sendNoteCloseFriends(List<String> toPubkeys, String content,
      {String? rootEvent,
      String? rootEventRelay,
      String? replyEvent,
      String? replyEventRelay,
      List<String>? mentions,
      List<String>? mentionsRelays,
      List<String>? hashTags,
      SendMessageProgressCallBack? sendMessageProgressCallBack}) async {
    toPubkeys.add(pubkey);
    return await _sendPrivateNote(content, toPubkeys,
        rootEvent: rootEvent,
        rootEventRelay: rootEventRelay,
        replyEvent: replyEvent,
        replyEventRelay: replyEventRelay,
        mentions: mentions,
        mentionsRelays: mentionsRelays,
        hashTags: hashTags,
        sendMessageProgressCallBack: sendMessageProgressCallBack);
  }

  Future<OKEvent> sendNoteJustMe(String content,
      {String? rootEvent,
      String? rootEventRelay,
      String? replyEvent,
      String? replyEventRelay,
      List<String>? mentions,
      List<String>? mentionsRelays,
      List<String>? hashTags}) async {
    return await _sendPrivateNote(content, [pubkey],
        rootEvent: rootEvent,
        rootEventRelay: rootEventRelay,
        replyEvent: replyEvent,
        replyEventRelay: replyEventRelay,
        mentions: mentions,
        mentionsRelays: mentionsRelays,
        hashTags: hashTags);
  }

  Future<OKEvent> sendReply(String replyNoteId, String content,
      {List<String>? hashTags, List<String>? mentions}) async {
    NoteDBISAR? note = await loadNoteWithNoteId(replyNoteId);
    if (note != null) {
      String? rootEventId = note.root;
      note.pTags ??= [];
      if (rootEventId == null || rootEventId.isEmpty) {
        if (!note.pTags!.contains(note.author)) note.pTags!.add(note.author);
        for (var mention in mentions ?? []) {
          if (!note.pTags!.contains(mention)) {
            note.pTags!.add(mention);
          }
        }
        return note.private
            ? await _sendPrivateNote(content, [...note.pTags!, pubkey],
                rootEvent: replyNoteId, mentions: note.pTags, hashTags: hashTags)
            : await sendPublicNote(content,
                rootEvent: replyNoteId, mentions: note.pTags, hashTags: hashTags);
      } else {
        NoteDBISAR? rootNote = await loadNoteWithNoteId(rootEventId);
        if (rootNote?.author.isNotEmpty == true && !note.pTags!.contains(rootNote?.author)) {
          note.pTags!.add(rootNote!.author);
        }
        if (!note.pTags!.contains(note.author)) note.pTags!.add(note.author);
        return note.private
            ? await _sendPrivateNote(content, [...note.pTags!, pubkey],
                rootEvent: rootEventId,
                mentions: note.pTags,
                replyEvent: replyNoteId,
                hashTags: hashTags)
            : await sendPublicNote(content,
                rootEvent: rootEventId,
                mentions: note.pTags,
                replyEvent: replyNoteId,
                hashTags: hashTags);
      }
    } else {
      return OKEvent(replyNoteId, false, 'reply note DB == null');
    }
  }

  Future<OKEvent> sendReaction(String reactedNoteId,
      {bool like = true, String? content, String? emojiShotCode, String? emojiURL}) async {
    NoteDBISAR? note = await loadNoteWithNoteId(reactedNoteId);
    if (note != null) {
      Completer<OKEvent> completer = Completer<OKEvent>();
      if (!note.pTags!.contains(note.author)) {
        note.pTags!.add(note.author);
      }
      Event event = await Nip25.encode(reactedNoteId, note.pTags ?? [], '1', like, pubkey, privkey,
          content: content, emojiShotCode: emojiShotCode, emojiURL: emojiURL);

      NoteDBISAR noteDB = NoteDBISAR.noteDBFromReactions(Nip25.decode(event));
      saveNoteToDB(noteDB, null);

      note.reactionEventIds ??= [];
      note.reactionEventIds!.add(event.id);
      note.reactionCount++;
      note.reactionCountByMe++;
      saveNoteToDB(note, null);

      if (note.private) {
        OKEvent ok = await sendPrivateMessage([note.author, pubkey], event);
        if (!completer.isCompleted) completer.complete(ok);
      } else {
        Connect.sharedInstance.sendEvent(event, sendCallBack: (ok, relay) async {
          if (!completer.isCompleted) completer.complete(ok);
        });
      }
      return completer.future;
    } else {
      return OKEvent(reactedNoteId, false, 'reacted note DB == null');
    }
  }

  Future<OKEvent> sendRepost(String repostNoteId, String? repostNoteRelay) async {
    NoteDBISAR? note = await loadNoteWithNoteId(repostNoteId);
    if (note != null) {
      Completer<OKEvent> completer = Completer<OKEvent>();
      if (!note.pTags!.contains(note.author)) {
        note.pTags!.add(note.author);
      }
      Event event = await Nip18.encodeReposts(
          repostNoteId, repostNoteRelay, note.pTags ?? [], note.rawEvent, pubkey, privkey);
      Reposts r = await Nip18.decodeReposts(event);
      NoteDBISAR noteDB = NoteDBISAR.noteDBFromReposts(r);
      await saveNoteToDB(noteDB, null);

      note.repostEventIds ??= [];
      note.repostEventIds!.add(event.id);
      note.repostCount++;
      note.repostCountByMe++;
      saveNoteToDB(note, null);

      if (note.private) {
        OKEvent ok = await sendPrivateMessage([note.author, pubkey], event);
        if (!completer.isCompleted) completer.complete(ok);
      } else {
        Connect.sharedInstance.sendEvent(event, sendCallBack: (ok, relay) async {
          if (!completer.isCompleted) completer.complete(ok);
        });
      }

      return completer.future;
    } else {
      return OKEvent(repostNoteId, false, 'repost note DB == null');
    }
  }

  Future<OKEvent> sendQuoteRepost(String quoteRepostNoteId, String content,
      {List<String>? hashTags, 
      List<String>? mentions,
      Map<String, String>? emojiShortcodes,
      List<RelayKind>? relayKinds}) async {
    NoteDBISAR? note = await loadNoteWithNoteId(quoteRepostNoteId);
    if (note != null) {
      Completer<OKEvent> completer = Completer<OKEvent>();
      if (!note.pTags!.contains(note.author)) note.pTags!.add(note.author);
      String nostrNote = Nip21.encode(Nip19.encodeNote(quoteRepostNoteId));
      content = '$content\n$nostrNote';
      Event event = await Nip18.encodeQuoteReposts(
          quoteRepostNoteId, note.pTags ?? [], content, hashTags, pubkey, privkey,
          emojiShortcodes: emojiShortcodes);
      for (var mention in mentions ?? []) {
        if (!note.pTags!.contains(mention)) {
          note.pTags!.add(mention);
        }
      }
      NoteDBISAR noteDB = NoteDBISAR.noteDBFromQuoteReposts(Nip18.decodeQuoteReposts(event));
      await saveNoteToDB(noteDB, null);

      note.quoteRepostEventIds ??= [];
      note.quoteRepostEventIds!.add(event.id);
      note.quoteRepostCount++;
      note.quoteRepostCountByMe++;
      saveNoteToDB(note, null);

      if (note.private) {
        OKEvent ok = await sendPrivateMessage([note.author, pubkey], event);
        if (!completer.isCompleted) completer.complete(ok);
      } else {
        Connect.sharedInstance.sendEvent(
          event,
          relayKinds: relayKinds ?? [RelayKind.general, RelayKind.outbox],
          sendCallBack: (ok, relay) async {
            if (!completer.isCompleted) completer.complete(ok);
          },
        );
      }

      return completer.future;
    } else {
      return OKEvent(quoteRepostNoteId, false, 'quoteRepost note DB == null');
    }
  }
}
