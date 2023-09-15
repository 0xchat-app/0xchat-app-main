import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/image_picker_utils.dart';
import 'package:ox_common/utils/permission_utils.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/common_loading.dart';

class SelectAssetDialog extends StatefulWidget {
  const SelectAssetDialog({Key? key}) : super(key: key);

  @override
  State<SelectAssetDialog> createState() => _SelectAssetDialogState();
}

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
          _buildItem(Localized.text('ox_usercenter.gallery'), onTap: () async {
            File? imgFile = await openGallery();
            OXNavigator.pop(context, imgFile);
          }),
          Divider(
            color: ThemeColor.color160,
            height: Adapt.px(0.5),
          ),
          _buildItem(Localized.text('ox_usercenter.camera'), onTap: () async {
            File? imgFile = await openCamera();
            OXNavigator.pop(context, imgFile);
          }),
          Container(
            height: Adapt.px(8),
            color: ThemeColor.color190,
          ),
          _buildItem(Localized.text('ox_usercenter.cancel'), onTap: () => OXNavigator.pop(context)),
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
    final storagePermission = await PermissionUtils.getPhotosPermission();
    if(storagePermission){
      OXLoading.show();
      imgFile = await ImagePickerUtils.getImageFromGallery();
      OXLoading.dismiss();
    } else {
      CommonToast.instance.show(context, 'Please grant permission to access the photo');
    }
    return imgFile;
  }

  Future<File?> openCamera() async {
    File? imgFile;
    Map<Permission, PermissionStatus> statuses = await [Permission.camera].request();
    if (statuses[Permission.camera]!.isGranted) {
      OXLoading.show();
      imgFile = await ImagePickerUtils.getImageFromCamera();
      OXLoading.dismiss();
    } else {
      PermissionUtils.showPermission(context, statuses);
    }
    return imgFile;
  }
}
