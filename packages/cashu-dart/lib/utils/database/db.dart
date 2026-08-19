
import 'dart:async';
import 'dart:io';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:reflectable/reflectable.dart';
import '../log_util.dart';
import 'db_helper.dart';
import 'db_object.dart';

// Annotate with this class to enable reflection.
class Reflector extends Reflectable {
  const Reflector()
      : super(invokingCapability, typingCapability,
            reflectedTypeCapability); // Request the capability to invoke methods.
}

const reflector = Reflector();

class CashuDB {
  List<Type> schemes = [];
  List<String> allTablenames = [];
  bool deleteDBIfNeedMirgration = false;
  Database? _db;
  Database get db => _db!;

  static final CashuDB sharedInstance = CashuDB._internal();

  CashuDB._internal();

  factory CashuDB() {
    return sharedInstance;
  }

  Future<bool> isExistsDB(String dbPath) async {
    if (!Platform.isIOS && !Platform.isAndroid) return false;
    return databaseExists(dbPath);
  }

  Future open(String dbPath, {int? version, String? password}) async {
    if (!Platform.isIOS && !Platform.isAndroid) return ;

    if (deleteDBIfNeedMirgration) {
      bool exists = await isExistsDB(dbPath);
      if (exists) {
        LogUtils.e(() => "delete Table");
        await deleteDatabase(dbPath);
      }
    }

    ({int newVersion, int oldVersion})? downgrade;
    _db = await openDatabase(dbPath, version: version, password: password,
        onCreate: (db, version) async {
      var batch = db.batch();
      for (var type in schemes) {
        TypeMirror objectMirror = reflector.reflectType(type);
        String sql = DBHelper.generatorTableSql(type);
        if (sql.isNotEmpty) {
          try {
            batch.execute(sql);
          } catch (_) {
            LogUtils.e(() => "create ${objectMirror.simpleName} failure");
          }
        }
      }
      await batch.commit();
    }, onUpgrade: (db, oldVersion, newVersion) async {

      // Update Table
      List<Map<String, dynamic>> tables = await db
          .rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
      List<String> tableNames =
          tables.map((item) => item["name"].toString()).toList();
      while (oldVersion < newVersion) {
        oldVersion++;
        var batch = db.batch();
        for (int i = 0; i < schemes.length; i++) {
          Type type = schemes[i];
          String tableName = DBHelper.getTableName(type);
          TypeMirror objectMirror = reflector.reflectType(type);
          ClassMirror classMirror = reflector.reflectType(type) as ClassMirror;
          if (!tableNames.contains(tableName)) {
            DBHelper.createTable(type, db);
            continue;
          }
          if (objectMirror.isSubtypeOf(reflector.reflectType(DBObject)) &&
              classMirror.staticMembers.keys.contains("updateTable")) {
            Map<String, String?> updateTableMap =
                classMirror.invoke("updateTable", []) as Map<String, String?>;
            var updateSql = updateTableMap["$oldVersion"];

            if (updateSql != null && updateSql.isNotEmpty) {
              var sqlList = updateSql.split(";");
              try {
                for (var sql in sqlList) {
                  if (sql.trim().length > 1) {
                    batch.execute("${sql.trim()};");
                  }
                }
              } catch (_) {
                LogUtils.e(() => 
                    "update ${objectMirror.simpleName} failure ==> ${updateSql.toString()}");
              }
            }
          }
        }
        await batch.commit();
      }
    }, onDowngrade: (db, oldVersion, newVersion) async {
      downgrade = (newVersion: newVersion, oldVersion: oldVersion);
    });

    if (downgrade != null) {
      final currentVersion = await db.getVersion();
      if (currentVersion == downgrade!.newVersion) {
        await db.setVersion(downgrade!.oldVersion);
      }
    }

    List<Map<String, dynamic>> tables =
        await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    allTablenames = tables.map((item) => item["name"].toString()).toList();
  }

  Future<void> cipherMigrate(
      String newPath, int version, String password) async {
    Completer<void> completer = Completer<void>();
    await openDatabase(newPath, version: version, password: password,
        onCreate: (newDb, version) async {
      // all table from oldDB
      List<Map> list = await db
          .rawQuery('SELECT name FROM sqlite_master WHERE type="table"');
      await Future.forEach(list, (Map row) async {
        String tableName = row['name'];
        // create new table
        String createTableSql = await db
            .query('sqlite_master',
                columns: ['sql'], where: 'name = ?', whereArgs: [tableName])
            .then((value) => value.first['sql'] as String);
        await newDb.execute(createTableSql);
        // copy all data to new DB
        List<Map<String, Object?>> tableData = await db.query(tableName);
        await Future.forEach(tableData, (Map<String, Object?> row) async {
          await newDb.insert(tableName, row);
        });
      });
      String dbPath = db.path;
      await db.close();
      await deleteDatabase(dbPath);
      _db = newDb;
      if (!completer.isCompleted) completer.complete();
    });
    return completer.future;
  }

  Future<void> closeDatabase() async {
    allTablenames.clear();
    if (_db != null) {
      await db.close();
    }
  }

  Future<void> execute(String sql, [List<Object?>? arguments]) async {
    await db.execute(sql, arguments);
  }

  Future<int> insert<T extends DBObject>(T object,
      {ConflictAlgorithm? conflictAlgorithm}) async {
    String tableName = DBHelper.getTableName(T);
    await createTableForDBObject<T>(tableName);
    return await db.insert(tableName, object.toMap(),
        conflictAlgorithm: conflictAlgorithm ?? ConflictAlgorithm.replace);
  }

  Future<int> insertObjects<T extends DBObject>(List<T> objects) async {
    String tableName = DBHelper.getTableName(T);
    await createTableForDBObject<T>(tableName);
    int successCount = 0;
    await db.transaction((txn) async {
      for (int i = 0; i < objects.length; i++) {
        int rowId = await txn.insert(tableName, objects[i].toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
        if (rowId > 0) {
          successCount++;
        }
      }
    });
    return successCount;
  }

  Future<int> rawInsert(String sql, [List<Object?>? arguments]) async {
    return await db.rawInsert(sql, arguments);
  }

  Future<int> update<T extends DBObject>(T object) async {
    String tableName = DBHelper.getTableName(T);
    await createTableForDBObject<T>(tableName);
    return await db.update(tableName, object.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<int> rawUpdate(String sql, [List<Object?>? arguments]) async {
    return await db.rawUpdate(sql, arguments);
  }

  Future<int> delete<T extends DBObject>(
      {String? where, List<Object?>? whereArgs}) async {
    String tableName = DBHelper.getTableName(T);
    await createTableForDBObject<T>(tableName);
    return await db.delete(tableName, where: where, whereArgs: whereArgs);
  }

  Future<int> rawDelete(String sql, [List<Object?>? arguments]) async {
    return await db.rawDelete(sql, arguments);
  }

  Future<List<Object?>> rawObjects(
      {required String table,
      bool? distinct,
      List<String>? columns,
      String? where,
      List<Object?>? whereArgs,
      String? groupBy,
      String? having,
      String? orderBy,
      int? limit,
      int? offset}) async {
    List<Map<String, Object?>> maps = await db.query(table,
        distinct: distinct,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset);
    return maps;
  }

  Future<List<T>> objects<T extends DBObject>({
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    String tableName = DBHelper.getTableName(T);
    await createTableForDBObject<T>(tableName);
    List<Object?> maps = await rawObjects(
      table: tableName,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );

    ClassMirror classMirror = reflector.reflectType(T) as ClassMirror;
    if (!DBHelper.isSubclassOfDBObject(T) ||
        !classMirror.staticMembers.containsKey("fromMap")) {
      return [];
    }
    List<T> dbObjectList = maps.map((map) {
      T object = classMirror.invoke("fromMap", [map]) as T;
      return object;
    }).toList();
    return dbObjectList;
  }

  Future<List<Map<String, Object?>>> rawQuery(String sql,
      [List<Object?>? arguments]) async {
    return db.rawQuery(sql, arguments);
  }

  Future createTableForDBObject<T extends DBObject>(String tableName) async {
    if (!allTablenames.contains(tableName)) {
      bool result = await DBHelper.createTable(T, db);
      if (result) allTablenames.add(tableName);
    }
  }
}
