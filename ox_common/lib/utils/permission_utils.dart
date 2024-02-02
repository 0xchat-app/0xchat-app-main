
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';

///Title: permission_utils
///Copyright: Copyright (c) 2018
///CreateTime: 2021-4-24 14:40
///@author john
///@CheckItem Fill in by oneself
///@since Dart 2.3

class PermissionUtils{
 
  static void showPermission(BuildContext? context, Map<Permission, PermissionStatus> permissionMap){
    if(permissionMap.containsKey(Permission.storage) && !permissionMap[Permission.storage]!.isGranted && permissionMap.containsKey(Permission.camera) && !permissionMap[Permission.camera]!.isGranted && permissionMap.containsKey(Permission.microphone) && !permissionMap[Permission.microphone]!.isGranted){
      CommonToast.instance.show(context, Localized.text('ox_common.permiss_storage_camera_microphone_refuse'));
    }else if(permissionMap.containsKey(Permission.storage) && !permissionMap[Permission.storage]!.isGranted && permissionMap.containsKey(Permission.camera) && !permissionMap[Permission.camera]!.isGranted) {
      CommonToast.instance.show(context,Localized.text('ox_common.permiss_storage_camera_refuse'));
    }else if(permissionMap.containsKey(Permission.storage) && !permissionMap[Permission.storage]!.isGranted && permissionMap.containsKey(Permission.microphone) && !permissionMap[Permission.microphone]!.isGranted) {
      CommonToast.instance.show(context,Localized.text('ox_common.permiss_storage_microphone_refuse'));
    }else if(permissionMap.containsKey(Permission.camera) && !permissionMap[Permission.camera]!.isGranted && permissionMap.containsKey(Permission.microphone) && !permissionMap[Permission.microphone]!.isGranted) {
      CommonToast.instance.show(context,Localized.text('ox_common.permiss_camera_microphone_refuse'));
    }else if(permissionMap.containsKey(Permission.storage) && !permissionMap[Permission.storage]!.isGranted){
      CommonToast.instance.show(context,Localized.text('ox_common.permiss_storage_refuse'));
    }else if(permissionMap.containsKey(Permission.camera) && !permissionMap[Permission.camera]!.isGranted){
      CommonToast.instance.show(context,Localized.text('ox_common.permiss_camera_refuse'));
    }else if(permissionMap.containsKey(Permission.microphone) && !permissionMap[Permission.microphone]!.isGranted){
      CommonToast.instance.show(context,Localized.text('ox_common.permiss_microphone_refuse'));
    }
  }

  static Future<bool> getPhotosPermission({int type = 1}) async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    bool permissionGranted = false;
    if (Platform.isAndroid && (await plugin.androidInfo).version.sdkInt < 33) {
      PermissionStatus storageStatus =await Permission.storage.request();
      if (storageStatus.isGranted) {
        permissionGranted = true;
      } else if (storageStatus.isPermanentlyDenied) {
        await openAppSettings();
      } else if (storageStatus.isDenied) {
        permissionGranted = false;
      }
    } else {
      PermissionStatus status = await Permission.photos.request();
      if (Platform.isAndroid && type == 2 ) {
        status = await Permission.videos.request();
      }
      if (status.isGranted || status.isLimited) {
        permissionGranted = true;
      } else if (status.isPermanentlyDenied) {
        await openAppSettings();
      } else if (status.isDenied) {
        permissionGranted = false;
      }
    }
    return permissionGranted;
  }

  static Future<bool> getAudioFilesPermission() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    bool permissionGranted = false;
    if (Platform.isIOS){
      return true;
    } else if (Platform.isAndroid) {
      if ((await plugin.androidInfo).version.sdkInt < 33) {
        PermissionStatus storageStatus = await Permission.storage.request();
        if (storageStatus.isGranted) {
          permissionGranted = true;
        } else if (storageStatus.isPermanentlyDenied) {
          await openAppSettings();
        } else if (storageStatus.isDenied) {
          permissionGranted = false;
        }
      } else {
        PermissionStatus status = await Permission.audio.request();
        if (status.isGranted || status.isLimited) {
          permissionGranted = true;
        } else if (status.isPermanentlyDenied) {
          await openAppSettings();
        } else if (status.isDenied) {
          permissionGranted = false;
        }
      }
    }
    return permissionGranted;
  }

  static void requestPermission(Permission permission) async {
    final status = await permission.request();
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }
}