import 'package:chatcore/chat-core.dart';

import '../enum/moment_enum.dart';

extension ENoteDBEx on NoteDB {
  bool get isRepost => getNoteKind() == ENotificationsMomentType.repost.kind;

  bool get isReaction => getNoteKind() == ENotificationsMomentType.like.kind;

  bool get isReply => getNoteKind() == ENotificationsMomentType.reply.kind;

  bool get isRoot => getReplyLevel() == 0;

  bool get isFirstLevelReply => getReplyLevel() == 1;

  bool get isSecondLevelReply => getReplyLevel() == 2;

  String? get getReplyId {
    String? replyId = reply;
    if(replyId != null && replyId.isNotEmpty) return replyId;
    return root;
  }
}

extension ENotificationDBEX on NotificationDB {
  bool get isLike => kind == ENotificationsMomentType.like.kind;
}
