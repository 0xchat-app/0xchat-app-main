
import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/log_util.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';
import 'package:chatcore/chat-core.dart';

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
    required String pubKey,
    required String sourceDBPath,
    String? sourceDBPwd,
    required String targetDBPath,
    String? targetDBPwd,
  }) async {
    late Isar sourceIsar;
    late Isar targetIsar;
    try {
      sourceIsar = await Isar.open(
            DBISAR.sharedInstance.schemas,
            directory: sourceDBPath,
            name: pubKey,
          );
      targetIsar = await Isar.open(
        DBISAR.sharedInstance.schemas,
        directory: targetDBPath,
        name: pubKey,
      );

      await targetIsar.writeTxn(() async {
        await targetIsar.messageDBISARs.putAll(sourceIsar.messageDBISARs.getAll(ids));
      });
      await targetIsar.writeTxn(() async {
        await targetIsar.userDBISARs.putAll(sourceIsar.usersISAR);
      });
      await targetIsar.writeTxn(() async {
        await targetIsar.badgeAwardDBISARs.putAll(sourceIsar.badgeAwardDBISARs);
      });
      await targetIsar.writeTxn(() async {
        await targetIsar.badgeDBISARs.putAll(sourceIsar.badgeDBISARs);
      });
      await targetIsar.writeTxn(() async {
        await targetIsar.relayDBISARs.putAll(sourceIsar.relayDBISARs);
      });
      await targetIsar.writeTxn(() async {
        await targetIsar.channelDBISARs.putAll(sourceIsar.channelDBISARs);
      });
      await targetIsar.writeTxn(() async {
        await targetIsar.secretSessionDBISARs.putAll(sourceIsar.secretSessionDBISARs);
      });
      await targetIsar.writeTxn(() async {
        await targetIsar.groupDBISARs.putAll(sourceIsar.groupDBISARs);
      });
      await targetIsar.writeTxn(() async {
        await targetIsar.joinRequestDBISARs.putAll(sourceIsar.joinRequestDBISARs);
      });
      await targetIsar.writeTxn(() async {
        await targetIsar.moderationDBISARs.putAll(sourceIsar.moderationDBISARs);
      });
      await targetIsar.writeTxn(() async {
        await targetIsar.relayGroupDBISARs.putAll(sourceIsar.relayGroupDBISARs);
      });
      await targetIsar.writeTxn(() async {
        await targetIsar.configDBISARs.putAll(sourceIsar.configDBISARs);
      });

      return true;
    } catch (e) {
      return false;
    } finally {
      await sourceIsar.close();
      await targetIsar.close();
    }
  }

}