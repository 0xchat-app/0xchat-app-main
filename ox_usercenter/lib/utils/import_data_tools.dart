
import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/log_util.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class ImportDataTools {

  static Future<bool> unzipAndProcessFile(File file) async {
    final bytes = file.readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);

    final directory = await getTemporaryDirectory();

    final dbInfoFile = archive.where((archiveFile) => archiveFile.name == 'dbInfo.txt').firstOrNull;
    if (dbInfoFile == null) return false;

    final data = dbInfoFile.content as List<int>;
    final content = utf8.decode(data);
    final Map<String, dynamic> dbInfo = jsonDecode(content);

    var result = true;
    for (final archiveFile in archive) {
      final filename = archiveFile.name;
      if (archiveFile.isFile) {
        final data = archiveFile.content as List<int>;
        final file = File('${directory.path}/$filename')
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);

        if (filename.endsWith('.db') || filename.endsWith('.db2')) {
          result = result && await processDbFile(file, dbInfo);
        }
        await file.delete();
      }
    }

    return result;
  }

  static Future<bool> processDbFile(File dbFile, Map dbInfo) async {
    final dbFileName = basename(dbFile.path);
    final directory = await getApplicationDocumentsDirectory();
    final newPath = join(directory.path, dbFileName);
    final File newDbFile = File(newPath);

    final localKey = parseFileNameToLocalKey(dbFileName);
    if (!await newDbFile.exists()) {
      await dbFile.rename(newPath);

      final value = dbInfo[dbFileName];
      await OXCacheManager.defaultOXCacheManager.saveForeverData(localKey, value);
      return true;
    } else {
      final sourceDBPwd = dbInfo[dbFileName];
      final targetDBPwd = await OXCacheManager.defaultOXCacheManager.getForeverData(localKey);
      return await importTableData(
        sourceDBPath: dbFile.path,
        sourceDBPwd: sourceDBPwd,
        targetDBPath: newDbFile.path,
        targetDBPwd: targetDBPwd,
      );
    }
  }

  static String parseFileNameToLocalKey(String fileName) {
    var fileBaseName = basenameWithoutExtension(fileName);

    if (fileBaseName.startsWith('cashu-')) {
      final pubkey = fileBaseName.substring('cashu-'.length);
      return 'cashuDBpwd' + pubkey;
    } else {
      final pubkey = fileBaseName;
      return 'dbpw+' + pubkey;
    }
  }

  static Future<bool> importTableData({
    required String sourceDBPath,
    String? sourceDBPwd,
    required String targetDBPath,
    String? targetDBPwd,
  }) async {
    Database? sourceDB;
    Database? targetDB;
    try {
      sourceDB = await openDatabase(sourceDBPath, password: sourceDBPwd, readOnly: true);
      targetDB = await openDatabase(targetDBPath, password: targetDBPwd);

      List<Map> tables = await sourceDB.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';",
      );

      await targetDB.transaction((txn) async {
        for (var table in tables) {
          final tableName = table['name'];
          final rows = await sourceDB?.query(tableName) ?? [];
          for (var row in rows) {
            await txn.insert(tableName, row, conflictAlgorithm: ConflictAlgorithm.ignore);
          }
        }
      });

      return true;
    } catch (e) {
      return false;
    } finally {
      await sourceDB?.close();
      await targetDB?.close();
    }
  }
}