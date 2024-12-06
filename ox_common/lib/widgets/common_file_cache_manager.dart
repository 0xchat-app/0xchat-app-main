import 'dart:async';
import 'dart:io' as io;
import 'package:encrypt/encrypt.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:ox_common/utils/aes_encrypt_utils.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:path/path.dart' as path;

class OXFileCacheManager {
  static CacheManager get({
    String? encryptKey,
    String? encryptNonce,
  }) {
    if (encryptKey != null && encryptKey.isNotEmpty) {
      return DecryptedCacheManager(encryptKey, encryptNonce ?? '');
    }
    return OXDefaultCacheManager();
  }

  static Future emptyCache() async {
    await OXDefaultCacheManager().emptyCache();
    await DecryptedCacheManager('','').emptyCache();
  }
}

class OXDefaultCacheManager extends CacheManager with ImageCacheManager {
  static const key = 'libCachedImageData';

  static final OXDefaultCacheManager _instance = OXDefaultCacheManager._();

  factory OXDefaultCacheManager() {
    return _instance;
  }

  OXDefaultCacheManager._() : super(Config(key, repo: JsonCacheInfoRepository(databaseName: key)));
}

class DecryptedCacheManager extends CacheManager {
  static const key = "decryptCache";
  static Config config = Config(
    key,
    repo: JsonCacheInfoRepository(databaseName: key),
  );
  static final decryptedStore = CacheManager(config).store;
  static final decryptedWebHelper = CacheManager(config).webHelper;

  final String decryptKey;
  final String decryptNonce;

  DecryptedCacheManager(this.decryptKey, this.decryptNonce) : super.custom(
    config,
    cacheStore: decryptedStore,
    webHelper: decryptedWebHelper,
  );

  @override
  Future<File> getSingleFile(String url, {
    String? key,
    Map<String, String>? headers,
  }) async {
    key ??= url;
    final fileInfo = await _fetchAndDecryptFile(url, key, headers);
    return fileInfo.file;
  }

  @override
  Future<FileInfo> downloadFile(String url, {String? key, Map<String, String>? authHeaders, bool force = false}) {
    final tempKey = '${url}_temp';
    return super.downloadFile(url, key: tempKey, authHeaders: authHeaders, force: force);
  }

  // This method is work for Image Widget.
  @override
  Stream<FileResponse> getFileStream(String url,
      {String? key, Map<String, String>? headers, bool withProgress = false}) {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      return Stream.empty();
    }
    if (!url.isRemoteURL) {
      return _localFileStream(uri);
    } else {
      return Stream.fromFuture(_fetchAndDecryptFile(url, key, headers)).map((fileInfo) => fileInfo);
    }
  }

  Future<FileInfo> _fetchAndDecryptFile(String url, String? key, Map<String, String>? headers) async {
    key ??= url;

    // Try fetching from cache
    final cacheFile = await getFileFromCache(key);
    if (cacheFile != null && cacheFile.file.existsSync()) {
      return cacheFile;
    }

    // If not in cache, download and decrypt
    final tempKey = '${url}_temp';
    final downloadResponse = await super.downloadFile(url, key: tempKey, authHeaders: headers);

    final encryptFile = downloadResponse.file;
    final fileExtension = encryptFile.path.getFileExtension();
    final decryptedTempFile = await store.fileSystem.createFile(encryptFile.basename + '_temp');

    await decryptFile(
      encryptFile,
      decryptKey,
      decryptedFile: decryptedTempFile,
      nonce: decryptNonce,
    );

    final validTill = const Duration(days: 30);
    final newCacheFile = await super.putFile(
      url,
      decryptedTempFile.readAsBytesSync(),
      key: key,
      maxAge: validTill,
      fileExtension: fileExtension,
    );

    // Cleanup temporary files
    super.removeFile(tempKey);
    encryptFile.delete();
    decryptedTempFile.delete();

    return FileInfo(
      newCacheFile,
      FileSource.Cache,
      DateTime.now().add(validTill),
      Uri.parse(url).path,
    );
  }

  Stream<FileResponse> _localFileStream(Uri uri) async* {
    final fileResponse = FileInfo(
      LocalFileSystem().file(io.File(uri.path).path),
      FileSource.Cache,
      DateTime.now().add(Duration(days: 365 * 100)),
      uri.path,
    );

    yield fileResponse;
  }

  static Future<File> decryptFile(io.File file, String decryptKey,
      {File? decryptedFile, String? nonce, AESMode mode = AESMode.gcm}) async {
    String fileName = path.basename(file.path);
    decryptedFile ??= await DecryptedCacheManager(decryptKey, nonce ?? '').store.fileSystem.createFile(fileName);
    await AesEncryptUtils.decryptFileInIsolate(
      file,
      decryptedFile,
      decryptKey,
      nonce: nonce,
      mode: mode,
    );
    return decryptedFile;
  }
}
