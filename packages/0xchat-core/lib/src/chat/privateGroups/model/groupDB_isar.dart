import 'package:chatcore/chat-core.dart';
import 'package:isar/isar.dart';

part 'groupDB_isar.g.dart';

extension GroupDBISARExtensions on GroupDBISAR {
  GroupDBISAR withGrowableLevels() => this
    ..members = members?.toList()
    ..pinned = pinned?.toList();
}

@collection
class GroupDBISAR {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String groupId; //group nostr pubkey

  String owner; // pubkey
  int updateTime;
  bool mute;
  String name;
  List<String>? members;
  List<String>? pinned;
  String? about;
  String? picture;
  String? relay;

  /// MLS GROUP
  bool isMLSGroup;
  bool isDirectMessage;
  List<int>? mlsGroupId;
  int epoch;
  List<String>? adminPubkeys;
  String? welcomeWrapperEventId;
  String? welcomeEventString;

  GroupDBISAR({
    this.groupId = '',
    this.owner = '',
    this.updateTime = 0,
    this.mute = false,
    this.name = '',
    this.members,
    this.pinned,
    this.about,
    this.picture,
    this.relay,
    this.isMLSGroup = false,
    this.isDirectMessage = false,
    this.mlsGroupId,
    this.epoch = 0,
    this.adminPubkeys,
    this.welcomeWrapperEventId,
    this.welcomeEventString,
  });

  static GroupDBISAR fromMap(Map<String, Object?> map) {
    return _groupInfoFromMap(map);
  }

  @ignore
  String get privateGroupId {
    return mlsGroupId == null ? groupId : toHexString(mlsGroupId!);
  }

  @ignore
  String get shortGroupId {
    String k = privateGroupId;
    if (k.length < 12) return k;
    final String start = k.substring(0, 6);
    final String end = k.substring(k.length - 6);

    return '$start:$end';
  }

  @ignore
  String get otherPubkey {
    if (members != null && members!.isNotEmpty) {
      return members!.firstWhere((m) => m != Account.sharedInstance.currentPubkey,
          orElse: () => Account.sharedInstance.currentPubkey);
    }
    return '';
  }
}

GroupDBISAR _groupInfoFromMap(Map<String, dynamic> map) {
  return GroupDBISAR(
    groupId: map['groupId'].toString(),
    owner: map['owner'],
    updateTime: map['updateTime'],
    mute: map['mute'],
    name: map['name'].toString(),
    members: UserDBISAR.decodeStringList(map['members'].toString()),
    pinned: UserDBISAR.decodeStringList(map['pinned'].toString()),
    about: map['about'].toString(),
    picture: map['picture'].toString(),
    relay: map['relay'].toString(),
  );
}
