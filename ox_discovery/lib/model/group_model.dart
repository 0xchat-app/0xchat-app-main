import 'package:chatcore/chat-core.dart';

import '../enum/group_type.dart';

class GroupModel {
  String? groupId;
  String? name;
  String? owner;
  String? about;
  String? picture;
  String? createTime;
  int? createTimeMs;
  List<String>? members;
  GroupType type;
  int? msgCount;


  GroupModel({this.groupId,
    this.name,
    this.owner,
    this.about,
    this.picture,
    this.createTime,
    this.createTimeMs,
    this.members,
    this.type = GroupType.channel,
    this.msgCount,
  });

  ChannelDBISAR toChannelDB() {
    return ChannelDBISAR(
      channelId: groupId!,
      name: name,
      picture: picture,
      about: about,
      creator: owner ?? '',
      createTime: createTimeMs ?? 0,
    );
  }

  factory GroupModel.fromChannelDB(ChannelDBISAR channelDB){
    return GroupModel(
      groupId: channelDB.channelId,
      name: channelDB.name,
      owner: channelDB.creator,
      about: channelDB.about,
      picture: channelDB.picture,
      createTimeMs: channelDB.createTime,
      type: GroupType.channel,
    );
  }

  factory GroupModel.fromRelayGroupDB(RelayGroupDBISAR relayGroupDB) {
    GroupType type = GroupType.openGroup;
    if(relayGroupDB.private) {
      type = GroupType.privateGroup;
    }

    return GroupModel(
        groupId: relayGroupDB.groupId,
        name: relayGroupDB.name,
        owner: relayGroupDB.author,
        about: relayGroupDB.about,
        picture: relayGroupDB.picture,
        members: relayGroupDB.members,
        createTimeMs: relayGroupDB.lastUpdatedTime,
        type: type
    );
  }

  @override
  String toString() {
    return 'ChannelModel{groupId: $groupId, name: $name, owner: $owner, about: $about, picture: $picture, createTime: $createTime, createTimeMs: $createTimeMs, members: $members}';
  }
}