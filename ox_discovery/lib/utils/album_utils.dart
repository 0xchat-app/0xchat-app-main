import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ox_common/utils/uplod_aliyun_utils.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';
import 'package:ox_common/utils/image_picker_utils.dart';

class AlbumUtils {
  // 1 image 2 video
  static Future<void> openAlbum(BuildContext context,
      {int type = 1,
      int selectCount = 9,
      Function(List<String>)? callback}) async {
    final isVideo = type == 2;
    final messageSendHandler = isVideo ? dealWithVideo : dealWithPicture;

    final res = await ImagePickerUtils.pickerPaths(
      galleryMode: isVideo ? GalleryMode.video : GalleryMode.image,
      selectCount: selectCount,
      showGif: false,
      compressSize: 1024,
    );

    List<File> fileList = [];
    await Future.forEach(res, (element) async {
      final entity = element;
      final file = File(entity.path ?? '');
      fileList.add(file);
    });

    messageSendHandler(context, fileList, callback);
  }

  static Future<void> openCamera(
      BuildContext context, Function(List<String>)? callback) async {
    Media? res = await ImagePickerUtils.openCamera(
      cameraMimeType: CameraMimeType.photo,
      compressSize: 1024,
    );
    if (res == null) return;
    final file = File(res.path ?? '');
    dealWithPicture(context, [file], callback);
  }

  static Future dealWithPicture(
    BuildContext context,
    List<File> images,
    Function(List<String>)? callback,
  ) async {
    List<String> imageList = [];
    for (final result in images) {
      String fileName = Path.basename(result.path);
      fileName = fileName.substring(13);
      imageList.add(result.path.toString());
    }

    callback?.call(imageList);
  }

  static Future dealWithVideo(BuildContext context, List<File> images,
      Function(List<String>)? callback) async {
    for (final result in images) {
      // OXLoading.show();
      final uint8list = await VideoCompress.getByteThumbnail(
        result.path,
        quality: 50, // default(100)
        position: -1, // default(-1)
      );
      final image = await decodeImageFromList(uint8list!);
      Directory directory = await getTemporaryDirectory();
      String thumbnailDirPath = '${directory.path}/thumbnails';
      await Directory(thumbnailDirPath).create(recursive: true);

      // Save the thumbnail to a file
      String thumbnailPath = '$thumbnailDirPath/thumbnail.jpg';
      File thumbnailFile = File(thumbnailPath);
      await thumbnailFile.writeAsBytes(uint8list);

      callback?.call([result.path.toString(), thumbnailPath]);
    }
  }

  static Future<List<String>> uploadMultipleFiles(
    BuildContext? context, {
    required List<String> filePathList,
    required UplodAliyunType fileType,
  }) async {
    List<String> uploadedUrls = [];

    for (String filePath in filePathList) {
      final currentTime = DateTime.now().microsecondsSinceEpoch.toString();
      String fileName = '$currentTime${Path.basename(filePath)}';
      File imageFile = File(filePath);
      String uploadedUrl = await UplodAliyun.uploadFileToAliyun(
        context: context,
        fileType: fileType,
        file: imageFile,
        filename: fileName,
      );
      if (uploadedUrl.isNotEmpty) {
        uploadedUrls.add(uploadedUrl);
      }
    }
    return uploadedUrls;
  }
}
