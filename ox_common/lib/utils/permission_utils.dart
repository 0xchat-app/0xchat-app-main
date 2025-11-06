
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/business_interface/ox_chat/call_message_type.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/platform_utils.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
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

  static Future<bool> getPhotosPermission(BuildContext context, {int type = 1}) async {
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
    } else if(PlatformUtils.isDesktop) {
      permissionGranted = true;
    }else {
      PermissionStatus status = await Permission.photos.request();
      if (Platform.isAndroid && type == 2 ) {
        status = await Permission.videos.request();
      }
      if (status.isGranted || status.isLimited) {
        permissionGranted = true;
      } else if (status.isPermanentlyDenied) {
        await OXCommonHintDialog.show(context, content: Localized.text('ox_common.str_grant_permission_photo_hint'), actionList: [
          OXCommonHintAction(
              text: () => Localized.text('ox_chat.str_go_to_settings'),
              onTap: () {
                openAppSettings();
                OXNavigator.pop(context);
              }),
        ], isRowAction: true, showCancelButton: true,);
        permissionGranted = false;
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

  static Future<bool> getCallPermission(BuildContext context, {String? mediaType}) async {
    bool cmPermission = false;
    List<Permission> requestList = [];
    String permissionFailedContent = '';
    if (mediaType == CallMessageType.audio.text) {
      requestList = [Permission.microphone];
      permissionFailedContent = Localized.text('ox_common.str_permission_audio_call_hint');
    } else {
      requestList = [Permission.camera, Permission.microphone];
      permissionFailedContent = Localized.text('ox_common.str_permission_call_hint');
    }
    Map<Permission, PermissionStatus> statuses = await requestList.request();
    if ((mediaType == CallMessageType.audio.text && statuses[Permission.microphone]!.isGranted)
    || (mediaType == CallMessageType.video.text && statuses[Permission.camera]!.isGranted && statuses[Permission.microphone]!.isGranted)) {
      cmPermission = true;
    } else {
      OXCommonHintDialog.show(context,
          title: Localized.text('ox_common.tips'),
          content: permissionFailedContent,
          actionList: [
            OXCommonHintAction.cancel(onTap: () {
              OXNavigator.pop(context);
            }),
            OXCommonHintAction.sure(
                text: Localized.text('ox_common.confirm'),
                onTap: () async {
                  await openAppSettings();
                  OXNavigator.pop(context);
                }),
          ],
          isRowAction: true);
      cmPermission = false;
    }
    return cmPermission;
  }
}