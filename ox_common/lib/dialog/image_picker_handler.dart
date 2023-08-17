import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ox_common/dialog/image_picker.dart';
import 'package:ox_common/utils/file_size_utl.dart';
import 'package:ox_common/utils/image_picker_utils.dart';

class ImagePickerHandler {
  late ImagePicker picker;
  late AnimationController _controller;
  Function(File? originalFile, File? compressFile)? imageSelectedCallback;
  late bool pickerShowing = false;
  bool isNeedTailor = false;

  ImagePickerHandler(TickerProvider vsync, {bool isNeedTailor = false}) {
    _controller = new AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );
    if (isNeedTailor != null) this.isNeedTailor = isNeedTailor;
    init();
  }

  void init() {
    picker = new ImagePicker(this, _controller);
    picker.initState();
  }

  openCamera() async {
    if (pickerShowing) {
      picker.dismissDialog();
    }

    File? imageFile = await ImagePickerUtils.getImageFromCamera(isNeedTailor: isNeedTailor);

    print("openCamera_imageFile.path: ${imageFile != null && imageFile.path.isNotEmpty ? imageFile.path.toString() : 'null'}");
    if (imageFile != null) {
      //Upload the original image slightly compressed
      print("Camera Upload original image - Initial image size: " + FileSizeUtil.getRollupSize(imageFile.lengthSync()));
      File? originalFile = await ImagePickerUtils.getCompressionImg(imageFile.path, 80);
      print("Camera Upload original image - Compressed image size: " + (originalFile != null ? FileSizeUtil.getRollupSize(originalFile.lengthSync()) : '0'));

      //Thumbnails are heavily compressed
      print("Camera Upload original image - Initial image size: " + FileSizeUtil.getRollupSize(imageFile.lengthSync()));
      File? compressFile = await ImagePickerUtils.getCompressionImg(imageFile.path, 30);
      if (compressFile != null) {
        int quality = 80;
        while (compressFile!.lengthSync() > 204800) {
          quality -= 10;
          compressFile = await ImagePickerUtils.getCompressionImg(imageFile.path, quality);
        }

        print("Camera Upload original image - Compressed image size: " + FileSizeUtil.getRollupSize(compressFile.lengthSync()));
      }
      if (imageSelectedCallback != null) {
        imageSelectedCallback!(originalFile, compressFile);
        imageSelectedCallback = null;
      }
    } else {
      print("No operation-openCamera");
    }
  }

  openGallery() async {
    if (pickerShowing) {
      picker.dismissDialog();
    }

    File? imageFile = await ImagePickerUtils.getImageFromGallery(isNeedTailor: isNeedTailor);
    if (imageFile != null) {
      //Upload the original image slightly compressed
      print("Gallery original image - Initial image size: " + FileSizeUtil.getRollupSize(imageFile.lengthSync()));
      File? originalFile = await ImagePickerUtils.getCompressionImg(imageFile.path, 60);
      print("Gallery original image - Compressed image size: " + (originalFile != null ? FileSizeUtil.getRollupSize(originalFile.lengthSync()) : '0'));

      //Thumbnails are heavily compressed
      print("Gallery original image - Initial image size: " + FileSizeUtil.getRollupSize(imageFile.lengthSync()));
      File? compressFile = await ImagePickerUtils.getCompressionImg(imageFile.path, 20);
      print("Gallery original image - Compressed image size: " + (compressFile != null ? FileSizeUtil.getRollupSize(compressFile.lengthSync()) : '0'));
      if (imageSelectedCallback != null) {
        imageSelectedCallback!(originalFile, compressFile);
        imageSelectedCallback = null;
      }
    } else {
      print("No operation-openCamera");
    }
  }

//  Future cropImage(File image) async {
//    File croppedFile = await ImageCropper.cropImage(
//      sourcePath: image.path,
//      ratioX: 1.0,
//      ratioY: 1.0,
//      maxWidth: 1024,
//      maxHeight: 1024,
//    );
//
//  }

  showDialog(BuildContext context, Function(File?, File?) callback) {
    imageSelectedCallback = callback;
    picker.getImage(context);
  }
}
