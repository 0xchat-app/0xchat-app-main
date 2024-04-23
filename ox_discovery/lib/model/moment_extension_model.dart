import 'package:chatcore/chat-core.dart';

import '../utils/discovery_utils.dart';

extension NoteDBEx on NoteDB {
  String get createAtStr {
    return DiscoveryUtils.formatTimeAgo(createAt);
  }

  static List<NoteDB> getNoteToMomentList(List<NoteDB> noteList) {
    List<NoteDB> list = [];
    for (NoteDB note in noteList) {
      if (note.root.isEmpty) {
        list.add(note);
      }
    }
    return list;
  }
}
