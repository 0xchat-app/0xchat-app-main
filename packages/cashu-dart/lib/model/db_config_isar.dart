
import 'package:isar/isar.dart';

part 'db_config_isar.g.dart';

@collection
class DBConfigIsar {
  DBConfigIsar(this.key, this.value);
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String key;
  String value;
}