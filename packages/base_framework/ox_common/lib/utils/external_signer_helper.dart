import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/utils/storage_key_tool.dart';

/// Answer of a NIP-55 `get_public_key` call.
class ExternalSignerSession {
  const ExternalSignerSession({required this.pubKey, required this.packageName});

  /// Account pubkey the signer answered with, hex encoded.
  final String pubKey;

  /// Package name of the signer that answered the call, every following request
  /// of this account has to be addressed to it.
  final String packageName;
}

/// Keeps track of the NIP-55 signer app an account signs with.
///
/// NIP-55 (https://github.com/nostr-protocol/nips/blob/master/55.md#initiating-a-connection):
/// `get_public_key` answers with the account pubkey *and the package name of the
/// signer*. The client stores both, addresses every following request to that
/// package name and does not call `get_public_key` again while the user stays
/// logged in - that call initiates a connection, so repeating it on every app
/// start makes the signer ask for a connection again.
///
/// So the package name is always read back from storage, no code assumes a
/// particular signer app.
class ExternalSignerHelper {
  ExternalSignerHelper._();

  /// Signer of accounts that were logged in before the package name was
  /// persisted: [StorageKeyTool.KEY_IS_LOGIN_AMBER] was the only marker back
  /// then and Amber the only signer 0xchat talked to. Used to migrate those
  /// accounts, never as a default for a new login.
  static const String legacySignerPackageName = 'com.greenart7c3.nostrsigner';

  /// Asks the signer [packageName] for the account pubkey, NIP-55
  /// `get_public_key`. Returns null when the request was rejected or answered
  /// without a usable pubkey.
  static Future<ExternalSignerSession?> requestPubKey(String packageName) async {
    if (packageName.isEmpty) return null;
    await ExternalSignerTool.setSignerByPackageName(packageName);
    final String? response = await ExternalSignerTool.getPubKey();
    if (response == null || response.isEmpty) return null;
    final String? pubKey = decodePubKey(response);
    if (pubKey == null || pubKey.isEmpty) return null;
    // NIP-55 wants the package name the signer answered `get_public_key` with.
    // The request is addressed to a single package, so the app that answered is
    // the one the current signer config points at - ExternalSignerTool hands
    // back the pubkey of the answer only, not its `package` field.
    final String signerPackageName =
        ExternalSignerTool.getCurrentConfig()?.packageName ?? packageName;
    return ExternalSignerSession(pubKey: pubKey, packageName: signerPackageName);
  }

  /// Signers answer with an npub or with a hex pubkey, take both.
  static String? decodePubKey(String response) {
    if (response.startsWith('npub')) return UserDBISAR.decodePubkey(response);
    return response;
  }

  /// Package name of the signer [pubKey] signs with, null when the account does
  /// not use an external signer.
  static Future<String?> signerPackageName(String pubKey) async {
    if (pubKey.isEmpty) return null;
    final dynamic savedPackageName = await OXCacheManager.defaultOXCacheManager
        .getForeverData('$pubKey${StorageKeyTool.KEY_SIGNER_PACKAGE_NAME}');
    if (savedPackageName is String && savedPackageName.isNotEmpty) {
      return savedPackageName;
    }
    final dynamic legacySignerFlag = await OXCacheManager.defaultOXCacheManager
        .getForeverData('$pubKey${StorageKeyTool.KEY_IS_LOGIN_AMBER}');
    return legacySignerFlag == true ? legacySignerPackageName : null;
  }

  /// Remembers the signer of [pubKey], so following app starts address the same
  /// app instead of asking for a connection again.
  static Future<void> saveSigner(String pubKey, String packageName) async {
    if (pubKey.isEmpty || packageName.isEmpty) return;
    await OXCacheManager.defaultOXCacheManager.saveForeverData(
        '$pubKey${StorageKeyTool.KEY_SIGNER_PACKAGE_NAME}', packageName);
    // The old flag only ever meant "this account signs with an external signer",
    // so it is set for every signer app and not for Amber alone.
    await OXCacheManager.defaultOXCacheManager
        .saveForeverData('$pubKey${StorageKeyTool.KEY_IS_LOGIN_AMBER}', true);
  }

  /// Forgets the signer of [pubKey], for accounts that log in with a key.
  static Future<void> clearSigner(String pubKey) async {
    if (pubKey.isEmpty) return;
    await OXCacheManager.defaultOXCacheManager
        .saveForeverData('$pubKey${StorageKeyTool.KEY_SIGNER_PACKAGE_NAME}', null);
    await OXCacheManager.defaultOXCacheManager
        .saveForeverData('$pubKey${StorageKeyTool.KEY_IS_LOGIN_AMBER}', false);
  }
}
