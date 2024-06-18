import 'package:chatcore/chat-core.dart';
import 'package:ox_common/utils/web_url_helper.dart';

import '../enum/moment_enum.dart';
import 'moment_ui_model.dart';

extension ENoteDBEx on NoteDB {
  bool get isRepost => getNoteKind() == ENotificationsMomentType.repost.kind;

  bool get isReaction => getNoteKind() == ENotificationsMomentType.like.kind;

  bool get isReply => getNoteKind() == ENotificationsMomentType.reply.kind;

  bool get isQuoteRepost => getNoteKind() == ENotificationsMomentType.quote.kind;


  isRoot (String? noteId) {
   return getReplyLevel(noteId) == 0;
  }

  isFirstLevelReply (String? noteId) {
    return getReplyLevel(noteId) == 1;
  }

  isSecondLevelReply (String? noteId) {
    return getReplyLevel(noteId) == 2;
  }

  String? get getReplyId {
    String? replyId = reply;
    if(replyId != null && replyId.isNotEmpty) return replyId;
    return root;
  }
}

extension ENotificationDBEX on NotificationDB {
  bool get isLike => kind == ENotificationsMomentType.like.kind;
}

class NaddrCache{
  static Map<String,Map<String,dynamic>?> map = {};
}

class NotedUIModelCache{
  static Map<String,NotedUIModel?> map = {};
}

class ExternalLinkCache{
  static Map<String,PreviewData?> map = {};
}