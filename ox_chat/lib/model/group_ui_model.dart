import 'package:ox_common/model/chat_type.dart';
import 'package:chatcore/chat-core.dart';

///Title: group_ui_model
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/6/26 11:28
class GroupUIModel {
  String groupId; //group pubkey
  String owner; // group creator pubkey
  int updateTime;
  bool mute;
  String name;
  List<String>? members;
  List<String>? pinned;
  String? about;
  String? picture;
  String? relay;
  bool private;
  int chatType;

  GroupUIModel({
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
    this.private = false,
    this.chatType = ChatType.chatRelayGroup
  });

  static GroupUIModel groupdbToUIModel(GroupDB groupDB){
    return GroupUIModel(
      name: groupDB.name,
      groupId: groupDB.groupId,
      about: groupDB.about,
      members: groupDB.members,
      mute: groupDB.mute,
      owner: groupDB.owner,
      picture: groupDB.picture,
      pinned: groupDB.pinned,
      relay: groupDB.relay,
      updateTime: groupDB.updateTime,
      private: false,
      chatType: ChatType.chatGroup,
    );
  }

  static GroupUIModel relayGroupdbToUIModel(RelayGroupDB groupDB){
    return GroupUIModel(
      name: groupDB.name,
      groupId: groupDB.groupId,
      about: groupDB.about,
      members: groupDB.members,
      mute: groupDB.mute,
      owner: groupDB.author,
      picture: groupDB.picture,
      pinned: groupDB.pinned,
      relay: groupDB.relay,
      updateTime: groupDB.lastUpdatedTime,
      private: groupDB.private,
      chatType: ChatType.chatRelayGroup,
    );
  }
}
