import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ox_common/utils/permission_utils.dart';
import 'package:ox_common/ox_common.dart';

///Title: image_picker_utils
///Description: TODO(Take a photo or select an image from an album)
///Copyright: Copyright (c) 2023
///@author john
///@CheckItem Fill in by oneself
///@since Dart 2.3

class ImagePickerUtils {
  static Future<File?> getImageFromCamera({bool isNeedTailor = false}) async {
    bool hasPermission = false;
    if (Platform.isAndroid) {
      Map<Permission, PermissionStatus> statuses = await [Permission.camera, Permission.storage].request();
      if (statuses[Permission.camera]!.isGranted && statuses[Permission.storage]!.isGranted) {
        hasPermission = true;
      } else {
        PermissionUtils.showPermission(null, statuses);
      }
    }
    String? cameraFilePath;
    if (Platform.isIOS || hasPermission) {
      cameraFilePath = await OXCommon.channel.invokeMethod('getImageFromCamera', {
        'isNeedTailor': isNeedTailor,
      });
    }
    return cameraFilePath == null ? null : File(cameraFilePath);
  }

  static Future<File?> getImageFromGallery({bool isNeedTailor = false}) async {
    bool hasPermission = false;
    if (Platform.isAndroid) {
      Map<Permission, PermissionStatus> statuses = await [Permission.camera, Permission.storage].request();
      if (statuses[Permission.camera]!.isGranted && statuses[Permission.storage]!.isGranted) {
        hasPermission = true;
      } else {
        PermissionUtils.showPermission(null, statuses);
      }
    }
    String? galleryFilePath;
    if (Platform.isIOS || hasPermission) {
      galleryFilePath = await OXCommon.channel.invokeMethod('getImageFromGallery', {
        'isNeedTailor': isNeedTailor,
      });
    }
    return galleryFilePath == null ? null : File(galleryFilePath);
  }

  static Future<File?> getVideoFromCamera({bool isNeedTailor = false}) async {
    final String? galleryFilePath = await OXCommon.channel.invokeMethod('getVideoFromCamera', {
      'isNeedTailor': isNeedTailor,
    });
    return galleryFilePath == null ? null : File(galleryFilePath);
  }

  static Future<File?> getCompressionImg(String filePath, int quality) async {
    final String? galleryFilePath = await OXCommon.channel.invokeMethod('getCompressionImg', {
      'filePath': filePath,
      'quality': quality,
    });
    return galleryFilePath == null ? null : File(galleryFilePath);
  }

  static Future<String?> saveImageToGallery({
    Uint8List? imageBytes,
    String? name,
    int quality = 80,
  }) async {
    final result = await OXCommon.channel.invokeMethod('saveImageToGallery', <String, dynamic>{
      'imageBytes': imageBytes,
      'name': name,
      'quality': quality,
    });
    return result;
  }
}
