import 'package:chatcore/chat-core.dart';
import 'package:isar/isar.dart';

part 'recent_search_user_isar.g.dart';

@collection
class RecentSearchUserISAR {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String pubKey;

  RecentSearchUserISAR({required this.pubKey});

  static List<String?> primaryKey() {
    return ['pubKey'];
  }

  static RecentSearchUserISAR fromMap(Map<String, Object?> map) {
    return _recentSearchUserFromMap(map);
  }
}

RecentSearchUserISAR _recentSearchUserFromMap(Map<String, dynamic> map) {
  return RecentSearchUserISAR(
    pubKey: map['pubKey'],
  );
}

