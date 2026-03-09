import 'package:chatcore/chat-core.dart';

@reflector
class ChannelDB extends DBObject {
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

  ChannelDB({
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

  @override
  Map<String, Object?> toMap() {
    return _channelInfoToMap(this);
  }

  static ChannelDB fromMap(Map<String, Object?> map) {
    return _channelInfoFromMap(map);
  }

  static String? tableName() {
    return "ChannelDB";
  }

  //primaryKey
  static List<String?> primaryKey() {
    return ['channelId'];
  }

  //'ALTER TABLE Company ADD description TEXT'
  static Map<String, String?> updateTable() {
    return {
      "8": '''alter table ChannelDB add updateTime INT;''',
    };
  }

  String get shortChannelId {
    String k = channelId;
    if (k.length < 12) return k;
    final String start = k.substring(0, 6);
    final String end = k.substring(k.length - 6);
    return '$start:$end';
  }

  static Future<void> migrateToISAR() async {
    List<ChannelDB> channels = await DB.sharedInstance.objects<ChannelDB>();
    List<ChannelDBISAR> channelsISAR = [];
    for (var channel in channels) {
      channelsISAR.add(ChannelDBISAR.fromMap(channel.toMap()));
    }
    await DBISAR.sharedInstance.isar.writeTxn(() async {
      await DBISAR.sharedInstance.isar.channelDBISARs.putAll(channelsISAR);
    });
  }
}

Map<String, dynamic> _channelInfoToMap(ChannelDB instance) => <String, dynamic>{
      'channelId': instance.channelId,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
      'creator': instance.creator,
      'name': instance.name,
      'about': instance.about,
      'picture': instance.picture,
      'badges': instance.badges,
      'relayURL': instance.relayURL,
      'mute': instance.mute,
    };

ChannelDB _channelInfoFromMap(Map<String, dynamic> map) {
  return ChannelDB(
    channelId: map['channelId'].toString(),
    createTime: map['createTime'],
    updateTime: map['updateTime'] ?? 0,
    creator: map['creator'].toString(),
    name: map['name'].toString(),
    about: map['about'],
    picture: map['picture'].toString(),
    badges: map['badges'].toString(),
    relayURL: map['relayURL'].toString(),
    mute: (map['mute'] ?? 0) > 0 ? true : false,
  );
}
