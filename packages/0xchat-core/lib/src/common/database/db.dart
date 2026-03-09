import 'dart:async';
import 'dart:io';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:reflectable/reflectable.dart';
import 'db_helper.dart';
import 'package:chatcore/chat-core.dart';
import 'package:path/path.dart' as p;

// Annotate with this class to enable reflection.
class Reflector extends Reflectable {
  const Reflector()
      : super(invokingCapability, typingCapability,
            reflectedTypeCapability); // Request the capability to invoke methods.
}

const reflector = Reflector();

class BatchOperation {
  String table;
  Map<String, Object?> values;
  String? nullColumnHack;
  ConflictAlgorithm? conflictAlgorithm;
  BatchOperation(
      this.table, this.values, this.nullColumnHack, this.conflictAlgorithm);
}

class DB {
  List<Type> schemes = [];
  List<String> allTablenames = [];
  bool deleteDBIfNeedMirgration = false;
  late Database _db;
  List<BatchOperation> insertOperations = [];
  Timer? timer;

  List<Function> migrationFunctions = [
    MessageDB.migrateToISAR,
    UserDB.migrateToISAR,
    BadgeAwardDB.migrateToISAR,
    BadgeDB.migrateToISAR,
    RelayDB.migrateToISAR,
    // ZapRecordsDB.migrateToISAR,
    ChannelDB.migrateToISAR,
    SecretSessionDB.migrateToISAR,
    GroupDB.migrateToISAR,
    JoinRequestDB.migrateToISAR,
    ModerationDB.migrateToISAR,
    RelayGroupDB.migrateToISAR,
    // NoteDB.migrateToISAR,
    // NotificationDB.migrateToISAR,
    ConfigDB.migrateToISAR
  ];

  static final DB sharedInstance = DB._internal();

  DB._internal();

  factory DB() {
    return sharedInstance;
  }

  void startHeartBeat() {
    if (timer == null || timer!.isActive == false) {
      timer = Timer.periodic(Duration(seconds: 5), (Timer t) async {
        await batchApply();
      });
    }
  }

  Future<bool> databaseExists(String path) async {
    if (!Platform.isIOS && !Platform.isAndroid) return false;
    return databaseFactory.databaseExists(path);
  }

  Future open(String dbPath, {int? version, String? password}) async {
    if (!Platform.isIOS && !Platform.isAndroid) return ;
    if (deleteDBIfNeedMirgration) {
      bool exists = await databaseExists(dbPath);
      if (exists) {
        LogUtils.v(() => "delete Table");
        await deleteDatabaseFile(dbPath);
      }
    }
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
            LogUtils.v(() => "create ${objectMirror.simpleName} failure");
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
      while (oldVersion <= newVersion) {
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
                LogUtils.v(() =>
                    "update ${objectMirror.simpleName} failure ==> ${updateSql.toString()}");
              }
            }
          }
        }
        await batch.commit();
        oldVersion++;
      }
    });
    List<Map<String, dynamic>> tables =
        await _db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    allTablenames = tables.map((item) => item["name"].toString()).toList();
  }

  Future<void> batchApply() async {
    try {
      List<BatchOperation> batchOperations = List.from(insertOperations);
      // insertOperations.clear();
      var batch = _db.batch();
      for (var batchOperation in batchOperations) {
        batch.insert(batchOperation.table, batchOperation.values,
            conflictAlgorithm: batchOperation.conflictAlgorithm);
      }
      List<Object?> result = await batch.commit(continueOnError: true);
      // if (result.length < batchOperations.length) {
      //   print('batchApply error: result: ${result.length}, expected: ${batchOperations.length}');
      //   insertOperations.addAll(batchOperations);
      // }
    } catch (e) {
      LogUtils.v(() => 'batchCommit error: $e');
    }
  }

  Future<void> cipherMigrate(
      String newPath, int version, String password) async {
    Completer<void> completer = Completer<void>();
    await openDatabase(newPath, version: version, password: password,
        onCreate: (newDb, version) async {
      // all table from oldDB
      List<Map> list = await _db
          .rawQuery('SELECT name FROM sqlite_master WHERE type="table"');
      await Future.forEach(list, (Map row) async {
        String tableName = row['name'];
        // create new table
        String createTableSql = await _db
            .query('sqlite_master',
                columns: ['sql'], where: 'name = ?', whereArgs: [tableName])
            .then((value) => value.first['sql'] as String);
        await newDb.execute(createTableSql);
        // copy all data to new DB
        List<Map<String, Object?>> tableData = await _db.query(tableName);
        await Future.forEach(tableData, (Map<String, Object?> row) async {
          await newDb.insert(tableName, row);
        });
      });
      String dbPath = _db.path;
      await _db.close();
      await deleteDatabaseFile(dbPath);
      _db = newDb;
      if (!completer.isCompleted) completer.complete();
    });
    return completer.future;
  }

  Future migrateToISAR() async {
    //migrate
    List<Function> functions = migrationFunctions;
    await Future.forEach(functions, (function) async {
      await function.call();
    });
  }

  Future<void> closDatabase() async {
    // allTablenames.clear();
    // await db.close();
    await DBISAR.sharedInstance.closeDatabase();
  }

  Future<void> deleteDatabaseFile(String path) async {
    await deleteDatabase(path);
  }

  Future<String> getDatabaseFilePath(String dbName) async {
    final String dbPath = await getDatabasesPath();
    return p.join(dbPath, dbName);
  }

  Future<void> execute(String sql, [List<Object?>? arguments]) async {
    await _db.execute(sql, arguments);
  }

  // Future<int> insert<T extends DBObject>(T object,
  //     {ConflictAlgorithm? conflictAlgorithm}) async {
  //   String tableName = DBHelper.getTableName(T);
  //   await createTableForDBObject<T>(tableName);
  //   return await db.insert(tableName, object.toMap(),
  //       conflictAlgorithm: conflictAlgorithm ?? ConflictAlgorithm.replace);
  // }
  //
  // Future<void> insertBatch<T extends DBObject>(T object,
  //     {ConflictAlgorithm? conflictAlgorithm}) async {
  //   String tableName = DBHelper.getTableName(T);
  //   await createTableForDBObject<T>(tableName);
  //   insertOperations.add(BatchOperation(tableName, object.toMap(), null,
  //       conflictAlgorithm ?? ConflictAlgorithm.replace));
  // }
  //
  // Future<int> insertObjects<T extends DBObject>(List<T> objects) async {
  //   String tableName = DBHelper.getTableName(T);
  //   await createTableForDBObject<T>(tableName);
  //   int successCount = 0;
  //   db.transaction((txn) async {
  //     for (int i = 0; i < objects.length; i++) {
  //       successCount += await txn.insert(tableName, objects[i].toMap(),
  //           conflictAlgorithm: ConflictAlgorithm.replace);
  //     }
  //   });
  //   return successCount;
  // }
  //
  // Future<int> rawInsert(String sql, [List<Object?>? arguments]) async {
  //   return await db.rawInsert(sql, arguments);
  // }
  //
  // Future<int> update<T extends DBObject>(T object) async {
  //   String tableName = DBHelper.getTableName(T);
  //   await createTableForDBObject<T>(tableName);
  //   return await db.update(tableName, object.toMap(),
  //       conflictAlgorithm: ConflictAlgorithm.ignore);
  // }
  //
  // Future<int> rawUpdate(String sql, [List<Object?>? arguments]) async {
  //   return await db.rawUpdate(sql, arguments);
  // }
  //
  // Future<int> delete<T extends DBObject>(
  //     {String? where, List<Object?>? whereArgs}) async {
  //   LogUtils.v(() => 'db delete: $where, ${jsonEncode(whereArgs)}');
  //   String tableName = DBHelper.getTableName(T);
  //   await createTableForDBObject<T>(tableName);
  //   return await db.delete(tableName, where: where, whereArgs: whereArgs);
  // }
  //
  // Future<int> rawDelete(String sql, [List<Object?>? arguments]) async {
  //   return await db.rawDelete(sql, arguments);
  // }

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
    List<Map<String, Object?>> maps = await _db.query(table,
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
    return _db.rawQuery(sql, arguments);
  }

  Future createTableForDBObject<T extends DBObject>(String tableName) async {
    if (!allTablenames.contains(tableName)) {
      bool result = await DBHelper.createTable(T, _db);
      if (result) allTablenames.add(tableName);
    }
  }
}
