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

extension ENotificationDBEX on NotificationDBISAR {
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

  Map<String,ValueNotifier<NotedUIModel?>> notedUIModelCache = {};

  Map<String,PreviewData?> urlPreviewDataCache = {};

  CreateMomentDraft? createMomentMediaDraft;
  CreateMomentDraft? createMomentContentDraft;

  CreateMomentDraft? createGroupMomentMediaDraft;
  CreateMomentDraft? createGroupMomentContentDraft;

  List<ValueNotifier<NotedUIModel?>> saveValueNotifierNote(List<NoteDBISAR> noteList){
    List<ValueNotifier<NotedUIModel?>> list = noteList.map((note) {

      ValueNotifier<NotedUIModel?>? noteNotifier = notedUIModelCache[note.noteId];

      if(noteNotifier == null){
        notedUIModelCache[note.noteId] = ValueNotifier(NotedUIModel(noteDB: note));
      }

      notedUIModelCache[note.noteId]!.value = NotedUIModel(noteDB: note);

     return notedUIModelCache[note.noteId]!;
    }).toList();
    return list;
  }

  static Future<ValueNotifier<NotedUIModel?>> getValueNotifierNoted(
      String noteId,
      {
        bool isUpdateCache = false,
        String? rootRelay,
        String? replyRelay,
        List<String>? setRelay,
        NotedUIModel? notedUIModel,
      }) async {
    final notedUIModelCache = OXMomentCacheManager.sharedInstance.notedUIModelCache;
    ValueNotifier<NotedUIModel?>? noteNotifier = notedUIModelCache[noteId];

    if(!isUpdateCache && noteNotifier != null && noteNotifier.value != null){
      return noteNotifier;
    }

    if(noteNotifier == null){
      notedUIModelCache[noteId] = ValueNotifier(null);
    }

    List<String>? relaysList = setRelay;
    if(relaysList == null){
      String? relayStr = (notedUIModel?.noteDB.replyRelay ?? replyRelay) ?? (notedUIModel?.noteDB.rootRelay ?? rootRelay);
      relaysList = relayStr != null ? [relayStr] : null;
    }

    NoteDBISAR? note = await Moment.sharedInstance.loadNoteWithNoteId(noteId, relays: relaysList);
    if(note == null) return notedUIModelCache[noteId]!;
    notedUIModelCache[noteId]!.value = NotedUIModel(noteDB: note);

    return notedUIModelCache[noteId]!;
  }

  static ValueNotifier<NotedUIModel?> getValueNotifierNoteToCache(String noteId){
    Map<String, NoteDBISAR> notesCache = Moment.sharedInstance.notesCache;
    final notedUIModelCache = OXMomentCacheManager.sharedInstance.notedUIModelCache;

    if(notedUIModelCache[noteId] == null){
      notedUIModelCache[noteId] = ValueNotifier(null);
    }

    if(notesCache[noteId] != null){
      NotedUIModel notedUIModel = NotedUIModel(noteDB: notesCache[noteId]!);

      notedUIModelCache[noteId]!.value = notedUIModel;
    }

    return notedUIModelCache[noteId]!;

  }
}