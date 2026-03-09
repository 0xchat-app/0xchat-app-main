import 'package:isar/isar.dart';
import 'package:chatcore/chat-core.dart';

part 'notificationDB_isar.g.dart';

@collection
class NotificationDBISAR {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String notificationId; //event id
  int kind; // 1：reply 2:quoteRepost 6:repost 7:reaction 9735:zap
  String author;
  int createAt;
  String content;
  int zapAmount;
  String associatedNoteId;

  NotificationDBISAR(
      {this.notificationId = '',
        this.kind = 0,
        this.author = '',
        this.createAt = 0,
        this.content = '',
        this.zapAmount = 0,
        this.associatedNoteId = ''});

  static NotificationDBISAR fromMap(Map<String, Object?> map) {
    return _notificationInfoFromMap(map);
  }

  static NotificationDBISAR notificationDBFromZapRecordsDB(
      ZapRecordsDBISAR zapRecordsDB, String eventId) {
    int amount = Zaps.getPaymentRequestAmount(zapRecordsDB.bolt11);
    return NotificationDBISAR(
        notificationId: eventId,
        kind: 9735,
        author: zapRecordsDB.sender,
        createAt: zapRecordsDB.paidAt,
        content: zapRecordsDB.content,
        zapAmount: amount,
        associatedNoteId: zapRecordsDB.eventId);
  }

  static NotificationDBISAR notificationDBFromNoteDB(NoteDBISAR note) {
    int kind = 0;
    String associatedNoteId = '';
    if (note.repostId != null && note.repostId!.isNotEmpty) {
      kind = 6;
      associatedNoteId = note.repostId!;
    } else if (note.quoteRepostId != null && note.quoteRepostId!.isNotEmpty) {
      kind = 2;
      associatedNoteId = note.quoteRepostId!;
    } else if (note.reactedId != null && note.reactedId!.isNotEmpty) {
      kind = 7;
      associatedNoteId = note.reactedId!;
    } else if (note.reply != null && note.reply!.isNotEmpty) {
      kind = 1;
      associatedNoteId = note.reply!;
    } else if (note.root != null && note.root!.isNotEmpty) {
      kind = 1;
      associatedNoteId = note.root!;
    }
    return NotificationDBISAR(
        notificationId: note.noteId,
        kind: kind,
        author: note.author,
        createAt: note.createAt,
        content: note.content,
        zapAmount: 0,
        associatedNoteId: associatedNoteId);
  }
}

NotificationDBISAR _notificationInfoFromMap(Map<String, dynamic> map) {
  return NotificationDBISAR(
    notificationId: map['notificationId'].toString(),
    kind: map['kind'],
    author: map['author'].toString(),
    createAt: map['createAt'],
    content: map['content'].toString(),
    zapAmount: map['zapAmount'],
    associatedNoteId: map['associatedNoteId'].toString(),
  );
}
