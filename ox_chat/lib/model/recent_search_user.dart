
import 'package:chatcore/chat-core.dart';

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

