
import '../../model/mint_info_isar.dart';
import '../../utils/database/db_isar.dart';

class MintInfoStore {

  static Future<MintInfoIsar?> getMintInfo(String mintURL) async {
    return CashuIsarDB.query<MintInfoIsar>()
        .mintURLEqualTo(mintURL)
        .findFirst();
  }

  static Future<bool> addMintInfo(MintInfoIsar info) async {
    await CashuIsarDB.put(info);
    return true;
  }

  static Future<bool> deleteMint(String mintURL) async {
    final deleted = await CashuIsarDB.delete<MintInfoIsar>((collection) =>
        collection.where()
            .mintURLEqualTo(mintURL)
            .deleteAll()
    );
    return deleted > 0;
  }
}