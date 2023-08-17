
import 'dart:async';
import 'dart:io' as io;
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:ox_common/utils/aes_encrypt_utils.dart';
import 'package:ox_common/utils/file_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class DecryptedCacheManager extends CacheManager with ImageCacheManager {
  static const key = "encryptedCache";
  final String pubkey;

  DecryptedCacheManager(this.pubkey) : super(Config(key));

  @override
  Stream<FileResponse> getFileStream(String url,
      {String? key, Map<String, String>? headers, bool withProgress = false}) {

    final uri = Uri.tryParse(url);
    if (uri == null) {
      return Stream.empty();
    }

    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return _localFileStream(uri);
    } else {
      return super.getFileStream(url, key: key, headers: headers, withProgress: withProgress).asyncMap((fileInfo) async {
        if (fileInfo is FileInfo) {
          File decryptedFile = await decryptFile(fileInfo.file, pubkey);
          return FileInfo(
            decryptedFile,
            FileSource.Cache,
            DateTime.now().add(Duration(days: 365*100)),
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
      DateTime.now().add(Duration(days: 365*100)),
      uri.path,
    );

    yield fileResponse;
  }

  static Future<File> decryptFile(io.File file, String pubkey) async {
    String directoryPath = (await getTemporaryDirectory()).path;
    String fileName = path.basename(file.path);
    final decryptedFile = LocalFileSystem().file(FileUtils.createFolderAndFile(directoryPath + '/decryptCache', fileName).path);

    AesEncryptUtils.decryptFile(file, decryptedFile, pubkey);

    return decryptedFile;
  }
}