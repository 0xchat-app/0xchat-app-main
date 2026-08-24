// Regression test for https://github.com/0xchat-app/0xchat-app-main/issues/61.
//
// Adding another account closes the running session before the new login is
// known to work, and the stored pubkey is the only pointer back to the account
// that is logged in. Clearing it during that teardown is what left the app
// looking like a fresh install when the second login never finished.

import 'package:flutter_test/flutter_test.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const String loggedInPubkey = 'b1a2c3d4e5f60718293a4b5c6d7e8f90';

  Future<dynamic> storedPubkey() =>
      OXCacheManager.defaultOXCacheManager.getForeverData(StorageKeyTool.KEY_PUBKEY);

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await OXCacheManager.defaultOXCacheManager
        .saveForeverData(StorageKeyTool.KEY_PUBKEY, loggedInPubkey);
  });

  test('closing the session to prepare another login keeps the stored account',
      () async {
    OXUserInfoManager.sharedInstance
        .resetData(needObserver: false, clearPersistedPubkey: false);

    expect(await storedPubkey(), loggedInPubkey);
  });

  test('logging out clears the stored account', () async {
    OXUserInfoManager.sharedInstance.resetData(needObserver: false);

    expect(await storedPubkey(), isNull);
  });
}
