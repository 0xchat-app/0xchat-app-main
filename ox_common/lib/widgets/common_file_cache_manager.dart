import 'dart:async';
import 'dart:io' as io;
import 'package:encrypt/encrypt.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:ox_common/utils/aes_encrypt_utils.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:path/path.dart' as path;

class OXDefaultCacheManager extends CacheManager with ImageCacheManager {
  static const key = 'libCachedImageData';

  static final OXDefaultCacheManager _instance = OXDefaultCacheManager._();

  factory OXDefaultCacheManager() {
    return _instance;
  }

  OXDefaultCacheManager._() : super(Config(key, repo: JsonCacheInfoRepository(databaseName: key)));
}

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

class DecryptedCacheManager extends CacheManager {
  static const key = "decryptCache";
  final String decryptKey;
  final String decryptNonce;

  DecryptedCacheManager(this.decryptKey, this.decryptNonce)
      : super(Config(key, repo: JsonCacheInfoRepository(databaseName: key)));

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
      return super
          .getFileStream(url, key: key, headers: headers, withProgress: withProgress)
          .asyncMap((fileInfo) async {
        if (fileInfo is FileInfo) {
          if (fileInfo.source == FileSource.Cache) {
            return fileInfo;
          }
          final validTill = const Duration(days: 30);
          File decryptedFile = await decryptFile(
            fileInfo.file,
            decryptKey,
            nonce: decryptNonce,
          );

          final fileBytes = decryptedFile.readAsBytesSync();
          super.putFile(url, fileBytes, key: key, maxAge: validTill);

          return FileInfo(
            decryptedFile,
            FileSource.Cache,
            DateTime.now().add(validTill),
            uri.path,
          );
        } else {
          return fileInfo;
        }
      });
    }
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
