import 'package:isar/isar.dart';

part 'circleDB_isar.g.dart';

@collection
class CircleDBISAR  {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String circleId;

  String name;
  String description;
  String image; 
  List<String> relayList;
  List<String> fileserverList;
  List<String> iceserverList;
  List<String> pushserverList;
  String? groupId;

  CircleDBISAR({
    required this.circleId,
    this.name = '',
    this.description = '',
    this.image = '',
    this.relayList = const [],
    this.fileserverList = const [],
    this.iceserverList = const [],
    this.pushserverList = const [],
    this.groupId,
  });
}