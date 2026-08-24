
import 'package:cashu_dart/utils/database/db_isar.dart';

import '../../model/unblinding_data_isar.dart';

class UnblindingDataStore {
  static Future add(List<UnblindingDataIsar> list) async {
    await CashuIsarDB.putAll(list);
  }

  static Future<List<UnblindingDataIsar>> getData() async {
    return CashuIsarDB.query<UnblindingDataIsar>().findAll();
  }

  static Future<bool> delete(List<UnblindingDataIsar> delData) async {
    if (delData.isEmpty) return true;

    final deleted = await CashuIsarDB.delete<UnblindingDataIsar>((collection) =>
        collection.filter()
            .anyOf(delData,
                (q, delProof) => q
                    .secretEqualTo(delProof.secret)
                    .and()
                    .keysetIdEqualTo(delProof.keysetId))
            .deleteAll()
    );
    return deleted > 0;
  }
}