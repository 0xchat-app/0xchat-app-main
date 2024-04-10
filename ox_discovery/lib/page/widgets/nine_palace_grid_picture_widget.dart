import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/image_picker_utils.dart';
import 'package:path/path.dart' as Path;
import '../../utils/moment_widgets.dart';

class NinePalaceGridPictureWidget extends StatefulWidget {
  final double? width;
  final bool isEdit;
  final List<String> imageList;
  final Function(List<String> imageList)? addImageCallback;

  const NinePalaceGridPictureWidget({
    super.key,
    required this.imageList,
    this.addImageCallback,
    this.width,
    this.isEdit = false,
  });

  @override
  _NinePalaceGridPictureWidgetState createState() =>
      _NinePalaceGridPictureWidgetState();
}

class _NinePalaceGridPictureWidgetState
    extends State<NinePalaceGridPictureWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> imageList = _getShowImageList();
    return SizedBox(
      width: widget.width ?? double.infinity,
      child: AspectRatio(
        aspectRatio: _getAspectRatio(imageList.length),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: imageList.length,
          itemBuilder: (context, index) {
            bool isShowAddIcon = imageList[index] == 'add_moment.png';
            String imgPath = isShowAddIcon
                ? 'assets/images/add_moment.png'
                : imageList[index];
            return GestureDetector(
              onTap: isShowAddIcon ? _openPhoto : () {},
              child: MomentWidgets.clipImage(
                borderRadius: 8.px,
                child: Image.asset(
                  imgPath,
                  width: 20.px,
                  fit: BoxFit.fill,
                  height: 20.px,
                  package: isShowAddIcon ? 'ox_discovery' : null,
                ),
              ),
            );
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10.px,
            mainAxisSpacing: 10.px,
            childAspectRatio: 1,
          ),
        ),
      ),
    );
  }

  double _getAspectRatio(int length) {
    if (length >= 1 && length <= 3) {
      return 3.0;
    } else if (length >= 4 && length <= 6) {
      return 1.5;
    } else if (length >= 7 && length <= 9) {
      return 1.0;
    }
    return 1.0;
  }

  List<String> _getShowImageList() {
    List<String> showImageList = widget.imageList;
    if (widget.isEdit && widget.imageList.length < 9)
      showImageList.add('add_moment.png');
    return showImageList;
  }

  Future<void> _openPhoto() async {
    int selectCount = 9 - widget.imageList.length;
    final res = await ImagePickerUtils.pickerPaths(
      galleryMode: GalleryMode.image,
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

    _updateImage(fileList);
  }

  Future _updateImage(List<File> images) async {
    List<String> list = [];
    for (final result in images) {
      String fileName = Path.basename(result.path);
      fileName = fileName.substring(13);
      list.add(result.path.toString());
    }
    widget.addImageCallback?.call(list);
  }
}
