import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/web_url_helper.dart';

import '../enum/moment_enum.dart';
import '../enum/visible_type.dart';
import 'moment_ui_model.dart';

extension ENoteDBEx on NoteDBISAR {
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

class CreateMomentDraft{
  List<String>? imageList;
  String? videoPath;
  String? videoImagePath;
  String content;
  EMomentType type;
  Map<String,UserDBISAR>? draftCueUserMap;

  VisibleType visibleType;
  List<UserDBISAR>? selectedContacts;

  CreateMomentDraft({
    required this.type,
    required this.visibleType,
    this.imageList,
    this.videoPath,
    this.content = '',
    this.draftCueUserMap,
    this.selectedContacts,
    this.videoImagePath,
  });
}

class OXMomentCacheManager {
  static final OXMomentCacheManager sharedInstance = OXMomentCacheManager._internal();

  OXMomentCacheManager._internal();

  Map<String,Map<String,dynamic>?> naddrAnalysisCache = {};

  Map<String,NotedUIModel?> notedUIModelCache = {};

  Map<String,PreviewData?> urlPreviewDataCache = {};

  CreateMomentDraft? createMomentMediaDraft;
  CreateMomentDraft? createMomentContentDraft;

  CreateMomentDraft? createGroupMomentMediaDraft;
  CreateMomentDraft? createGroupMomentContentDraft;
}