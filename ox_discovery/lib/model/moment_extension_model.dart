import 'package:chatcore/chat-core.dart';

import '../enum/moment_enum.dart';

extension ENoteDBEx on NoteDB {
  bool get isRepost => getNoteKind() == ENotificationsMomentType.repost.kind;

  bool get isReaction => getNoteKind() == ENotificationsMomentType.like.kind;

  bool get isReply => getNoteKind() == ENotificationsMomentType.reply.kind;
}
