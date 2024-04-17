import 'package:chatcore/chat-core.dart';

import '../utils/discovery_utils.dart';

extension NoteDBEx on NoteDB {
  String get createAtStr {
    return DiscoveryUtils.formatTimeAgo(createAt);
  }
}
