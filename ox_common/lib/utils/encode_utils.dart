
import 'dart:io';
import 'package:crypto/crypto.dart';

class EncodeUtils {
  static Future<String> generatePartialFileMd5(File file, {int numBytes = 1024}) async {
    final fileStream = file.openRead(0, numBytes);
    final bytes = await fileStream.fold<List<int>>([],
            (previous, element) => previous..addAll(element));
    final digest = md5.convert(bytes);
    return digest.toString();
  }
}