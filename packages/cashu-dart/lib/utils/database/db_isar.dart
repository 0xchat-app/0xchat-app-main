import 'dart:async';
import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

export 'package:isar/isar.dart';

class CashuIsarDB {
  static final CashuIsarDB shared = CashuIsarDB._internal();
  CashuIsarDB._internal();
  factory CashuIsarDB() => shared;

  late Isar isar;

  bool get isOpen => isar.isOpen;

  List<CollectionSchema<dynamic>> schemas = [];

  Future open(String dbName) async {
    Directory directory;
    if (Platform.isAndroid) {
      directory = await getApplicationDocumentsDirectory();
    } else if (Platform.isIOS || Platform.isMacOS) {
      directory = await getApplicationSupportDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }
    final dbPath = directory.path;
    isar = Isar.getInstance(dbName) ?? await Isar.open(
      schemas,
      directory: dbPath,
      name: dbName,
    );
  }

  Future<void> closeDatabase() async {
    if (isar.isOpen) await isar.close();
  }

  static Future<Id> put<T>(T object) async {
    return await shared.isar.writeTxn(() async {
      return await shared.isar.collection<T>().put(object);
    });
  }

  static Future<List<Id>> putAll<T>(List<T> objects) async {
    return await shared.isar.writeTxn(() async {
      final collection = shared.isar.collection<T>();
      return await collection.putAll(objects);
    });
  }

  static Future<List<T>> getAll<T>() async {
    return shared.isar.collection<T>().where().findAll();
  }

  static QueryBuilder<T, T, QWhere> query<T>() => shared.isar.collection<T>().where();

  /// Delete a list of objects by their [ids].
  ///
  /// Returns the number of objects that have been deleted.
  static Future<int> delete<T>(Future<int> Function(IsarCollection<T> collection) handler) {
    return shared.isar.writeTxn(() async {
      return handler(shared.isar.collection<T>());
    });
  }
}
