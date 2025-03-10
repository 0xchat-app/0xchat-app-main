import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/ox_common.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/file_utils.dart';
import 'package:ox_common/utils/image_picker_utils.dart';
import 'package:ox_common/utils/permission_utils.dart';
import 'package:ox_common/utils/platform_utils.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:device_info_plus/device_info_plus.dart';

class SelectAssetDialog extends StatefulWidget {
  const SelectAssetDialog({Key? key}) : super(key: key);

  @override
  State<SelectAssetDialog> createState() => _SelectAssetDialogState();
}

enum SelectAssetAction {Gallery, Camera, Remove, Cancel}

class _SelectAssetDialogState extends State<SelectAssetDialog> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(12)),
        color: ThemeColor.color180,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildItem('str_album'.commonLocalized(), onTap: () async {
            File? imgFile;
            if(PlatformUtils.isDesktop){
              List<Media>? list = await FileUtils.importClientFile(1);
              if(list != null){
                imgFile = File(list[0].path ?? '');
              }
            }else{
              imgFile = await openGallery();
            }
            OXNavigator.pop(context, {'action': SelectAssetAction.Gallery, 'result': imgFile});
          }),
          Divider(
            color: ThemeColor.color160,
            height: Adapt.px(0.5),
          ),
          if(PlatformUtils.isMobile)
          _buildItem(Localized.text('ox_usercenter.camera'), onTap: () async {
            File? imgFile = await openCamera();
            OXNavigator.pop(context, {'action': SelectAssetAction.Camera, 'result': imgFile});
          }),
          Divider(
            color: ThemeColor.color160,
            height: Adapt.px(0.5),
          ),
          _buildItem(Localized.text('ox_usercenter.removePhoto'), onTap: () async {
            OXNavigator.pop(context, {'action': SelectAssetAction.Remove, 'result': null});
          }),
          Container(
            height: Adapt.px(8),
            color: ThemeColor.color190,
          ),
          _buildItem(Localized.text('ox_usercenter.cancel'), onTap: () => OXNavigator.pop(context, {'action': SelectAssetAction.Cancel, 'result': null})),
        ],
      ),
    );
  }

  Widget _buildItem(String title,{GestureTapCallback? onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: Adapt.px(56),
        child: Text(
          title,
          style: TextStyle(
            color: ThemeColor.color0,
            fontSize: Adapt.px(16),
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      onTap: onTap,
    );
  }

  Future<File?> openGallery() async {
    File? imgFile;
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    bool storagePermission = false;
    if (Platform.isAndroid && (await plugin.androidInfo).version.sdkInt >= 34) {
      Map<String, bool> result = await OXCommon.request34MediaPermission(1);
      bool readMediaImagesGranted = result['READ_MEDIA_IMAGES'] ?? false;
      bool readMediaVisualUserSelectedGranted = result['READ_MEDIA_VISUAL_USER_SELECTED'] ?? false;
      if (readMediaImagesGranted) {
        storagePermission = true;
      } else if (readMediaVisualUserSelectedGranted) {
        final filePaths = await OXCommon.select34MediaFilePaths(1);
        return File(filePaths[0]);
      }
    } else {
      storagePermission = await PermissionUtils.getPhotosPermission(context);
    }
    if(storagePermission){
      OXLoading.show();
      final res = await ImagePickerUtils.pickerPaths(
        galleryMode: GalleryMode.image,
        selectCount: 1,
        showGif: false,
        compressSize: 2048,
      );
      imgFile = (res[0].path == null) ? null : File(res[0].path ?? '');
      OXLoading.dismiss();
    } else {
      CommonToast.instance.show(context, Localized.text('ox_common.str_grant_permission_photo_hint'));
    }
    return imgFile;
  }

  Future<File?> openCamera() async {
    File? imgFile;
    Map<Permission, PermissionStatus> statuses = await [Permission.camera].request();
    if (statuses[Permission.camera]!.isGranted) {
      OXLoading.show();
      Media? res = await ImagePickerUtils.openCamera(
        cameraMimeType: CameraMimeType.photo,
        compressSize: 1024,
      );
      if(res == null) return imgFile;
      imgFile = File(res.path ?? '');
      OXLoading.dismiss();
    } else {
      PermissionUtils.showPermission(context, statuses);
    }
    return imgFile;
  }
}
