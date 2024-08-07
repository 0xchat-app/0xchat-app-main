import 'package:chatcore/chat-core.dart';

import '../enum/group_type.dart';

class GroupModel {
  final String groupId;
  final String name;
  final String creator;
  final String about;
  final String picture;
  final String createTime;
  final int createTimeMs;
  final List<String>? members;
  final GroupType type;
  final int? msgCount;

  GroupModel({
    this.groupId = '',
    this.name = '',
    this.creator = '',
    this.about = '',
    this.picture = '',
    this.createTime = '',
    this.createTimeMs = 0,
    this.members,
    this.type = GroupType.channel,
    this.msgCount,
  });

  ChannelDBISAR toChannelDB() {
    return ChannelDBISAR(
      channelId: groupId,
      name: name,
      picture: picture,
      about: about,
      creator: creator ?? '',
      createTime: createTimeMs ?? 0,
    );
  }

  factory GroupModel.fromChannelDB(ChannelDBISAR channelDB) {
    return GroupModel(
      groupId: channelDB.channelId,
      name: channelDB.name ?? '',
      creator: channelDB.creator,
      about: channelDB.about ?? '',
      picture: channelDB.picture ?? '',
      createTimeMs: channelDB.createTime,
      type: GroupType.channel,
    );
  }

  factory GroupModel.fromRelayGroupDB(RelayGroupDBISAR relayGroupDB) {
    GroupType type = GroupType.openGroup;
    if (relayGroupDB.private) {
      type = GroupType.privateGroup;
    }

    return GroupModel(
        groupId: relayGroupDB.groupId,
        name: relayGroupDB.name,
        creator: relayGroupDB.author,
        about: relayGroupDB.about,
        picture: relayGroupDB.picture,
        members: relayGroupDB.members,
        createTimeMs: relayGroupDB.lastUpdatedTime,
        type: type);
  }

  @override
  String toString() {
    return 'ChannelModel{groupId: $groupId, name: $name, creator: $creator, about: $about, picture: $picture, createTime: $createTime, createTimeMs: $createTimeMs, members: $members}';
  }
}