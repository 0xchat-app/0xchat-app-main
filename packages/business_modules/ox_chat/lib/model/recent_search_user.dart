
import 'package:chatcore/chat-core.dart';
import 'package:ox_chat/model/recent_search_user_isar.dart';

@reflector
class RecentSearchUser extends DBObject {
  String pubKey;

  RecentSearchUser({required this.pubKey});

  static List<String?> primaryKey() {
    return ['pubKey'];
  }

  @override
  Map<String, Object?> toMap() {
    return _recentSearchUserToMap(this);
  }

  static RecentSearchUser fromMap(Map<String, Object?> map) {
    return _recentSearchUserFromMap(map);
  }

  static Future<void> migrateToISAR() async {
    List<RecentSearchUser> recentSearchUsers = await DB.sharedInstance.objects<RecentSearchUser>();
    List<RecentSearchUserISAR> recentSearchUsersISAR = [];
    for(var recentSearchUser in recentSearchUsers){
      recentSearchUsersISAR.add(RecentSearchUserISAR.fromMap(recentSearchUser.toMap()));
    }
    await DBISAR.sharedInstance.isar.writeTxn(() async {
      await DBISAR.sharedInstance.isar.recentSearchUserISARs
          .putAll(recentSearchUsersISAR);
    });
  }
}

Map<String, dynamic> _recentSearchUserToMap(RecentSearchUser instance){
  return <String, dynamic>{
    'pubKey': instance.pubKey,
  };
}

RecentSearchUser _recentSearchUserFromMap(Map<String, dynamic> map) {
  return RecentSearchUser(
    pubKey: map['pubKey'],
  );
}

