import 'package:chatcore/chat-core.dart';

class AggregatedNotification {
  int kind;
  String author;
  int createAt;
  String content;
  int zapAmount;
  String associatedNoteId;
  int likeCount;

  AggregatedNotification({
    this.kind = 0,
    this.author = '',
    this.createAt = 0,
    this.content = '',
    this.zapAmount = 0,
    this.associatedNoteId = '',
    this.likeCount = 0,
  });

  factory AggregatedNotification.fromNotificationDB(NotificationDB notificationDB) {
    return AggregatedNotification(
      kind: notificationDB.kind,
      author: notificationDB.author,
      createAt: notificationDB.createAt,
      content: notificationDB.content,
      zapAmount: notificationDB.zapAmount,
      associatedNoteId: notificationDB.associatedNoteId,
    );
  }
}