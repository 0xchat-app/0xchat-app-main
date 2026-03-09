import 'package:isar/isar.dart';

part 'channelDB_isar.g.dart';

@collection
class ChannelDBISAR {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String channelId; //event id

  int createTime;
  int updateTime;
  String creator; // pubkey
  String? name;
  String? about;
  String? picture;
  String? badges; // string list
  String? relayURL;
  bool? mute;

  ChannelDBISAR({
    this.channelId = '',
    this.createTime = 0,
    this.updateTime = 0,
    this.creator = '',
    this.name = '',
    this.about = '',
    this.picture = '',
    this.badges = '',
    this.relayURL = '',
    this.mute = false,
  });

  static ChannelDBISAR fromMap(Map<String, Object?> map) {
    return _channelInfoFromMap(map);
  }

  @ignore
  String get shortChannelId {
    String k = channelId;
    if(k.length < 12) return k;
    final String start = k.substring(0, 6);
    final String end = k.substring(k.length - 6);
    return '$start:$end';
  }
}

ChannelDBISAR _channelInfoFromMap(Map<String, dynamic> map) {
  return ChannelDBISAR(
    channelId: map['channelId'].toString(),
    createTime: map['createTime'],
    updateTime: map['updateTime'] ?? 0,
    creator: map['creator'].toString(),
    name: map['name'].toString(),
    about: map['about'],
    picture: map['picture'].toString(),
    badges: map['badges'].toString(),
    relayURL: map['relayURL'].toString(),
    mute: map['mute'],
  );
}
