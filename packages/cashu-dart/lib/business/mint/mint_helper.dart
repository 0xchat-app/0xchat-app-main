
import 'dart:convert';

import 'package:cashu_dart/business/proof/keyset_helper.dart';
import 'package:cashu_dart/utils/list_extension.dart';

import '../../core/keyset_store.dart';
import '../../core/mint_actions.dart';
import '../../core/nuts/define.dart';
import '../../core/nuts/v1/nut.dart' as v1;
import '../../model/keyset_info_isar.dart';
import '../../model/mint_model_isar.dart';
import '../../utils/log_util.dart';
import 'mint_info_store.dart';
import 'mint_store.dart';

class MintHelper {

  static String getMintURL(String url) {
    url = url.trim();
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      LogUtils.e(() => '[E][Cashu - getMintURL] mintURL must starts with https');
      url = 'https://$url';
    }

    if (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }
    return url;
  }

  static Future<bool> updateMintInfoFromRemote(IMintIsar mint) async {
    final response = await mint.requestMintInfoAction(mintURL: mint.mintURL);
    if (!response.isSuccess) return false;
    final info = response.data;
    mint.info = info;
    if (mint.name.isEmpty) {
      mint.name = info.name;
    }
    MintStore.updateMint(mint);
    MintInfoStore.addMintInfo(info);
    return true;
  }

  static Future updateMintKeysetFromRemote(IMintIsar mint) async {
    final keysets = await KeysetHelper.fetchKeysetFromRemote(mint);
    if (keysets.isEmpty) return ;

    mint.cleanKeysetId();
    _updateMintKeyset(mint, keysets);
  }

  static Future updateMintKeysetFromLocal(IMintIsar mint) async {
    final keysets = await KeysetStore.getKeyset(mintURL: mint.mintURL, active: true);
    if (keysets.isEmpty) return ;

    _updateMintKeyset(mint, keysets);
  }

  static void _updateMintKeyset(IMintIsar mint, List<KeysetInfoIsar> keysets) {
    if (keysets.isEmpty) return ;
    final newKeysets = keysets
        .groupBy((item) => item.unit)
        .entries.map((map) {
      final target = KeysetHelper.findBetterKeyset(map.value);
      return MapEntry(map.key, target);
    })
        .expand((map) => [map.value])
        .nonNulls;
    for (var keyset in newKeysets) {
      mint.updateKeysetId(keyset.keysetId, keyset.unit);
    }
  }

  static Future<int> getMaxNutsVersion(String mintURL) async {
    final response = await v1.Nut6.requestMintInfo(mintURL: mintURL);
    if (response.isSuccess) return 1;
    return 0;
  }
}

extension MintKeysPayloadEx on MintKeysPayload {
  KeysetInfoIsar asKeysetInfo(String mintURL) {
    var keysetRaw = '';
    try {
      keysetRaw = json.encode(keys);
    } catch (_) {}
    return KeysetInfoIsar(
      keysetId: id,
      mintURL: mintURL,
      unit: unit,
      active: true,
      keysetRaw: keysetRaw,
    );
  }
}