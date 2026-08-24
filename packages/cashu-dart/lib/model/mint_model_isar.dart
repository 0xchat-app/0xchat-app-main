
import 'package:isar/isar.dart';

import '../business/mint/mint_helper.dart';
import 'mint_info_isar.dart';

part 'mint_model_isar.g.dart';

@collection
class IMintIsar {

  IMintIsar({
    required String mintURL,
    this.maxNutsVersion = 0,
    this.name = '',
    this.balance = 0,
  }) : mintURL = MintHelper.getMintURL(mintURL);

  Id id = Isar.autoIncrement;

  @Index(unique: true)
  final String mintURL;

  String name;

  int balance;

  int maxNutsVersion;

  /// key: unit, value: keysetId
  @Ignore()
  final Map<String, String> _keysetIds = {};

  @Ignore()
  MintInfoIsar? info;

  String? keysetId(String unit) => _keysetIds[unit];
  void updateKeysetId(String keysetId, String unit) {
    if (keysetId.isEmpty) return ;
    _keysetIds[unit] = keysetId;
  }
  void cleanKeysetId() => _keysetIds.clear();

  @override
  String toString() {
    return '${super.toString()}, url: $mintURL, maxNutsVersion: $maxNutsVersion, balance: $balance, info: $info';
  }
}