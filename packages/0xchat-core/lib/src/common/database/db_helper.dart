import 'dart:core';
import 'package:chatcore/chat-core.dart';
import 'package:reflectable/mirrors.dart';
import 'package:sqflite_sqlcipher/sqlite_api.dart';
import 'db.dart';
import 'db_object.dart';

class DBHelper {
  static DateTime createDateTime(int milSeconds) {
    return DateTime.fromMillisecondsSinceEpoch(milSeconds, isUtc: true);
  }

  static getTableName(Type type) {
    if (!isSubclassOfDBObject(type)) {
      TypeMirror typeMirror = reflector.reflectType(type);
      return typeMirror.simpleName;
    }

    ClassMirror classMirror = reflector.reflectType(type) as ClassMirror;
    if (classMirror.staticMembers.keys.contains("tableName")) {
      try {
        var tableName = classMirror.invoke("tableName", []);
        String tableName0 = classMirror.simpleName;
        if (tableName != null && tableName.toString().isNotEmpty) {
          tableName0 = tableName.toString();
        }
        return tableName0;
      } catch (_) {
        return classMirror.simpleName;
      }
    }
    return classMirror.simpleName;
  }

  static bool isSubclassOfDBObject(Type type) {
    TypeMirror objectMirror = reflector.reflectType(type);
    if (objectMirror.isSubtypeOf(reflector.reflectType(DBObject))) {
      return true;
    }
    return false;
  }

  static generatorTableSql(Type type) {
    TypeMirror typeMirror = reflector.reflectType(type);
    if (!typeMirror.isSubtypeOf(reflector.reflectType(DBObject))) {
      return "";
    }
    String sql = "CREATE TABLE IF NOT EXISTS ";
    sql = "${sql + DBHelper.getTableName(type)}(";

    ClassMirror classMirror = typeMirror as ClassMirror;
    List<String?> primaryKeys = [];
    if (classMirror.staticMembers.keys.contains("primaryKey")) {
      try {
        var pKeys = classMirror.invoke("primaryKey", []);
        if (pKeys != null) {
          primaryKeys.addAll(pKeys as List<String?>);
        }
      } catch (_) {}
    }

    String primaryKey = "";
    if (primaryKeys.isNotEmpty) {
      primaryKey = "PRIMARY KEY (";
      for (var element in primaryKeys) {
        primaryKey = "$primaryKey$element,";
      }
      primaryKey = primaryKey.substring(0, primaryKey.length - 1);
      primaryKey = "$primaryKey)";
    }
    LogUtils.v(() => "primaryKey===>$primaryKey");
    List<String?> ignoreList = [];
    if (classMirror.staticMembers.keys.contains("ignoreKey")) {
      try {
        var igKeys = classMirror.invoke("ignoreKey", []);
        if (igKeys != null) {
          ignoreList.addAll(igKeys as List<String?>);
        }
      } catch (_) {}
    }

    Map<String, String> columnExtras = {};
    if (classMirror.staticMembers.keys.contains("columnExtras")) {
      try {
        var extras = classMirror.invoke("columnExtras", []);
        if (extras != null) {
          columnExtras.addAll(extras as Map<String, String>);
        }
      } catch (_) {}
    }

    final declarations = classMirror.declarations;
    declarations.forEach((key, value) {
      if (!ignoreList.contains(key)) {
        if (value is VariableMirror) {
          var columnType = tableColumnType(value, classMirror);
          if (columnType != null) {
            if (columnExtras.containsKey(key)) {
              sql = "$sql$key $columnType ${columnExtras[key].toString()},";
            } else {
              sql = "$sql$key $columnType,";
            }
          }
        }
      }
    });
    if (primaryKey.isNotEmpty) {
      sql = "$sql$primaryKey,";
    }
    sql = sql.substring(0, sql.length - 1);
    sql = "$sql)";
    LogUtils.v(() => "sql=====>$sql");
    return sql;
  }

  static String? tableColumnType(
      VariableMirror variableMirror, ClassMirror classMirror) {
    var typename = variableMirror.reflectedType;
    if (typename == int || typename == bool) {
      return "INTEGER";
    }
    if (typename == double || typename == num) {
      return "REAL";
    }
    if (typename == String) {
      return "TEXT";
    }
    if (typename.toString().startsWith('Map') ||
        typename.toString().startsWith('List')) {
      return "TEXT";
    }
    if (classMirror.staticMembers.keys.contains("isBlobColumn")) {
      var isBlobColumn =
          classMirror.invoke("isBlobColumn", [variableMirror.simpleName]);
      if (isBlobColumn != null) {
        isBlobColumn = isBlobColumn as bool;
        return isBlobColumn ? "BLOB" : null;
      }
    }
    return null;
  }

  static Future<bool> createTable(Type type, Database db) async {
    TypeMirror objectMirror = reflector.reflectType(type);
    List<Map<String, dynamic>> tables =
        await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    List<String> tableNames =
        tables.map((item) => item["name"].toString()).toList();
    String tableName = getTableName(type);
    if (tableNames.contains(tableName)) {
      return false;
    }
    String sql = DBHelper.generatorTableSql(type);
    LogUtils.v(() => "sql");
    if (sql.isNotEmpty) {
      try {
        await db.execute(sql);
        return true;
      } catch (_) {
        LogUtils.v(() => "create ${objectMirror.simpleName} failure");
        return false;
      }
    }
    return false;
  }
}
