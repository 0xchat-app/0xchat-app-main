

import '../../model/db_config_isar.dart';
import 'db_isar.dart';

class DBConfigHelper {

  static const String _migrationKey = 'dbMigrationCompleted';

  static Future<bool> isSqliteToIsarFinish() async {
    final config = await CashuIsarDB.query<DBConfigIsar>()
        .keyEqualTo(_migrationKey)
        .findFirst();
    return config != null && config.value.isNotEmpty;
  }

  static Future<void> setSqliteToIsarFinish() async {
    final config = DBConfigIsar(
      _migrationKey,
      '1',
    );
    await CashuIsarDB.put<DBConfigIsar>(config);
  }
}