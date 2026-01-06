
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_common/log_util.dart';

class CashuHelper {

  static String dbpwdKeyPre = 'cashuDBpwd';

  static String dbPasswordKey(String pubkey) {
    return '$dbpwdKeyPre$pubkey';
  }

  static _saveDBPassword(String pubkey, String pwd) async {
    await OXCacheManager.defaultOXCacheManager.saveForeverData(dbPasswordKey(pubkey), pwd);
  }

  static Future<String> getDBPassword(String pubkey) async {
    var pwd = await OXCacheManager.defaultOXCacheManager.getForeverData(dbPasswordKey(pubkey));
    if (pwd == null || pwd is! String || pwd.isEmpty) {
      // Compatible code
      final oldPwd = await OXCacheManager.defaultOXCacheManager.getForeverData('dbpw+$pubkey');
      if (oldPwd is String && oldPwd.isNotEmpty) {
        pwd = oldPwd;
      } else {
        pwd = generateStrongPassword(16);
      }
      await _saveDBPassword(pubkey, pwd);
    }

    LogUtil.d('[CashuDB init] dbpw: $pwd');
    return pwd;
  }
}