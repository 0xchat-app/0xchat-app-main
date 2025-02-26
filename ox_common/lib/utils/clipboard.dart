
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:ox_common/utils/list_extension.dart';

import '../ox_common.dart';

class OXClipboard {

  static MethodChannel get channel => OXCommon.channel;

  static Future<bool> hasImages() async {
    try {
      const hasImagesMethodName = 'hasImages';
      final result = await channel.invokeMethod(hasImagesMethodName);
      if (result is bool) return result;

      assert(false, '[invokeMethod - hasImages] result is not bool.');
      return false;
    } catch(e) {
      return false;
    }
  }

  static Future<List<File>> getImages() async {
    try {
      const getImagesMethodName = 'getImages';
      final result = await channel.invokeMethod(getImagesMethodName);

      if (result is List) {
        return result.map((filePath) {
          if (filePath is! String || filePath.isEmpty) return null;

          final file = File(filePath);
          if (!file.existsSync()) return null;

          return file;
        }).whereNotNull().toList();
      }

      return [];
    } catch(e) {
      return [];
    }
  }
}