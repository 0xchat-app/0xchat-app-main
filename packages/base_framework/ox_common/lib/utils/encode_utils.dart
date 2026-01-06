
import 'dart:io';
import 'package:crypto/crypto.dart';

class EncodeUtils {
  static Future<String> generatePartialFileMd5(File file, {int numBytes = 1024}) async {
    final fileSize = await file.length();
    final fileStream = file.openRead(fileSize - numBytes, fileSize);
    final bytes = await fileStream.fold<List<int>>([],
            (previous, element) => previous..addAll(element));
    final digest = md5.convert(bytes);
    return digest.toString();
  }
}