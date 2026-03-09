import 'package:isar/isar.dart';
import 'package:nostr_core_dart/nostr.dart';

part 'joinRequestDB_isar.g.dart';

@collection
class JoinRequestDBISAR {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String requestId;

  String groupId;
  String author;
  int createdAt;
  String content;

  JoinRequestDBISAR({
    this.requestId = '',
    this.groupId = '',
    this.author = '',
    this.createdAt = 0,
    this.content = '',
  });

  static JoinRequestDBISAR fromMap(Map<String, Object?> map) {
    return _joinRequestInfoFromMap(map);
  }

  static JoinRequestDBISAR toJoinRequestDB(GroupJoinRequest joinRequest) {
    return JoinRequestDBISAR(
        requestId: joinRequest.requestId,
        groupId: joinRequest.groupId,
        author: joinRequest.pubkey,
        createdAt: joinRequest.createdAt,
        content: joinRequest.content);
  }
}

JoinRequestDBISAR _joinRequestInfoFromMap(Map<String, dynamic> map) {
  return JoinRequestDBISAR(
    requestId: map['requestId'].toString(),
    groupId: map['groupId'].toString(),
    author: map['author'].toString(),
    createdAt: map['createdAt'],
    content: map['content'].toString(),
  );
}
