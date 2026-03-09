import 'db.dart';

/// key
/// "add","all","alter","and","as",
/// "autoincrement","between","case","check","collate",
/// "commit","constraint","create","default","deferrable",
/// "delete","distinct","drop","else","escape",
/// "except","exists","foreign","from","group",
/// "having","if","in","index","insert",
/// "intersect","into","is","isnull","join",
/// "limit","not","notnull","null","on",
/// "or","order","primary","references","select",
/// "set","table","then","to","transaction","union",
/// "unique","update","using","values","when","where"

@reflector
abstract class DBObject {
  //Map convert
  Map<String, Object?> toMap();

  static DBObject fromMap(Map<String, Object?> map) {
    throw UnimplementedError('updateTable() has not been implemented.');
  }

  //'ALTER TABLE Company ADD description TEXT'
  static Map<String, String?> updateTable() {
    return {};
  }

  static String? tableName() {
    return null;
  }

  //primaryKey
  static List<String?> primaryKey() {
    return [];
  }

  //ignoreKey
  static List<String?> ignoreKey() {
    return [];
  }

  // NOT NULL, autoincrement, UNQIU
  static Map<String, String> columnExtras() {
    return {};
  }

  static bool isBlobColumn(String key) {
    return false;
  }
}
