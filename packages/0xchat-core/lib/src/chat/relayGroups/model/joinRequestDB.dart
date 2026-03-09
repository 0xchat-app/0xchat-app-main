import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';

@reflector
class JoinRequestDB extends DBObject {
  String requestId;
  String groupId;
  String author;
  int createdAt;
  String content;

  JoinRequestDB({
    this.requestId = '',
    this.groupId = '',
    this.author = '',
    this.createdAt = 0,
    this.content = '',
  });

  @override
  Map<String, Object?> toMap() {
    return _joinRequestInfoToMap(this);
  }

  static JoinRequestDB fromMap(Map<String, Object?> map) {
    return _joinRequestInfoFromMap(map);
  }

  static String? tableName() {
    return "JoinRequestDB";
  }

  //primaryKey
  static List<String?> primaryKey() {
    return ['requestId'];
  }

  static JoinRequestDB toJoinRequestDB(GroupJoinRequest joinRequest) {
    return JoinRequestDB(
        requestId: joinRequest.requestId,
        groupId: joinRequest.groupId,
        author: joinRequest.pubkey,
        createdAt: joinRequest.createdAt,
        content: joinRequest.content);
  }

  static Future<void> migrateToISAR() async {
    List<JoinRequestDB> joinRequests =
        await DB.sharedInstance.objects<JoinRequestDB>();
    List<JoinRequestDBISAR> joinRequestsISAR = [];
    for (var joinRequest in joinRequests) {
      joinRequestsISAR.add(JoinRequestDBISAR.fromMap(joinRequest.toMap()));
    }
    await DBISAR.sharedInstance.isar.writeTxn(() async {
      await DBISAR.sharedInstance.isar.joinRequestDBISARs
          .putAll(joinRequestsISAR);
    });
  }
}

Map<String, dynamic> _joinRequestInfoToMap(JoinRequestDB instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
      'groupId': instance.groupId,
      'author': instance.author,
      'createdAt': instance.createdAt,
      'content': instance.content,
    };

JoinRequestDB _joinRequestInfoFromMap(Map<String, dynamic> map) {
  return JoinRequestDB(
    requestId: map['requestId'].toString(),
    groupId: map['groupId'].toString(),
    author: map['author'].toString(),
    createdAt: map['createdAt'],
    content: map['content'].toString(),
  );
}
