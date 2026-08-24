
import 'package:cashu_dart/utils/database/db_isar.dart';

import '../../model/mint_model_isar.dart';

class MintStore {

  static Future<List<IMintIsar>> getMints() async {
    return CashuIsarDB.query<IMintIsar>().findAll();
  }

  static Future<bool> updateMint(IMintIsar mint) async {
    await CashuIsarDB.put(mint);
    return true;
  }

  static Future<bool> addMints(List<IMintIsar> mints) async {
    await CashuIsarDB.putAll(mints);
    return true;
  }

  static Future<bool> deleteMint(String mintURL) async {
    final deleted = await CashuIsarDB.delete<IMintIsar>((collection) =>
        collection.where()
            .mintURLEqualTo(mintURL)
            .deleteAll()
    );
    return deleted > 0;
  }
}