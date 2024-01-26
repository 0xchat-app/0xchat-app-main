import 'package:sqflite/sqflite.dart';

///Title: db_tools
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author George
///CreateTime: 2021/4/22 4:28 PM
class DBTools {
  static DBTools get instance => _singleton;

  static final DBTools _singleton = DBTools._init();

  factory DBTools() {
    return _singleton;
  }

  int versionCode = 1;

  late String path = 'network.db';
  late String tableName = 'networkcache';
  late Database _db;
  late Batch batch;

  DBTools._init();

  Future<Database> openDataDB(String path, String tableName) async {
    _db = await openDatabase(path, version: versionCode);
    batch = _db.batch();
    return _db;
  }

  void createTable(String columnKey, String columnContent) async {
    await _db.execute(
        '''CREATE TABLE IF NOT EXISTS $tableName ($columnKey TEXT NOT NULL PRIMARY KEY,$columnContent TEXT NOT NULL)''');
  }

  void insert(String tableName, Map<String, Object?> values) async {
    batch.insert(tableName, values, conflictAlgorithm: ConflictAlgorithm.replace);
    batch.commit(noResult: true);
  }

  void update(String tableName, Map<String, Object?> values) async {
    batch.update(tableName, values);
    batch.commit(noResult: true);
  }

  Future<List<Map<String, Object?>>> query(
      String tableName, String columnKey, String columnContent, String cacheKey) async {
    List<Map<String, Object?>> result = await _db.query(tableName,
        columns: [columnKey, columnContent], where: '$columnKey = ?', whereArgs: [cacheKey]);

    return result;
  }

  void delete(String tableName, {String? where, List<Object?>? whereArgs}) async {
    batch.delete(tableName, where: where, whereArgs: whereArgs);
    batch.commit(noResult: true);
  }

  bool isOpen() {
    if (_db != null) {
      return _db.isOpen;
    }
    return false;
  }

  void closDatabase() async {
    await _db.close();
  }
}
