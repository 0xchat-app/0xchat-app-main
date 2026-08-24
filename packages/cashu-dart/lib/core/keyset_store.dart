
import 'package:cashu_dart/utils/database/db_isar.dart';

import '../model/keyset_info_isar.dart';

class KeysetStore {

  /// Adds a keyset collection
  static Future<bool> addOrReplaceKeysets(List<KeysetInfoIsar> keysets) async {
    if (keysets.isEmpty) return false;

    await CashuIsarDB.putAll(keysets);
    return true;
  }

  /// Returns a valid keyset object based on the parameters
  static Future<List<KeysetInfoIsar>> getKeyset({
    String? mintURL,
    String? id,
    String? unit, 
    bool? active,
  }) async {
    return CashuIsarDB.query<KeysetInfoIsar>().filter()
        .optional(mintURL != null && mintURL.isNotEmpty,
            (q) => q.mintURLEqualTo(mintURL!))
        .optional(id != null && id.isNotEmpty,
            (q) => q.keysetIdEqualTo(id!))
        .optional(unit != null && unit.isNotEmpty,
            (q) => q.unitEqualTo(unit!))
        .optional(active != null,
            (q) => q.activeEqualTo(active!))
        .findAll();
  }
}