import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_chat_ui/ox_chat_ui.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_image_gallery.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_discovery/utils/album_utils.dart';
import '../../utils/moment_widgets_utils.dart';
import 'package:extended_image/extended_image.dart';

class NinePalaceGridPictureWidget extends StatefulWidget {
  final int crossAxisCount;
  final double? width;
  final bool isEdit;
  final List<String> imageList;
  final int axisSpacing;
  final Function(List<String> imageList)? addImageCallback;
  final Function(int index)? delImageCallback;

  const NinePalaceGridPictureWidget(
      {
        super.key,
        required this.imageList,
        this.addImageCallback,
        this.width,
        this.axisSpacing = 10,
        this.isEdit = false,
        this.crossAxisCount = 3,
        this.delImageCallback,
      });

  @override
  _NinePalaceGridPictureWidgetState createState() =>
      _NinePalaceGridPictureWidgetState();
}

class _NinePalaceGridPictureWidgetState extends State<NinePalaceGridPictureWidget> {
  PageController? _galleryPageController;

  String tag = DateTime.now().millisecondsSinceEpoch.toString();

  @override
  void initState() {
    super.initState();
  }


  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageList != oldWidget.imageList) {
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    List<String> _imageList = _getShowImageList();
    return SizedBox(
      width: widget.width ?? double.infinity,
      child: AspectRatio(
        aspectRatio: _getAspectRatio(_imageList.length),
        child: GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _imageList.length,
          itemBuilder: (context, index) {
            return widget.isEdit
                ? _showEditImageWidget(context, index, _imageList)
                : _showImageWidget(context, index, _imageList);
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.crossAxisCount,
            crossAxisSpacing: widget.axisSpacing.px,
            mainAxisSpacing: widget.axisSpacing.px,
            childAspectRatio: 1,
          ),
        ),
      ),
    );
  }

  Widget _showImageWidget(
      BuildContext context, int index, List<String> imageList) {
    String imgPath = imageList[index];
    return GestureDetector(
      onTap: () {
        List<PreviewImage> previewImageList = _getPreviewImageList(imageList);
        final initialPage = previewImageList.indexWhere(
          (element) => element.id == index.toString() && element.uri == imgPath,
        );
        _galleryPageController = PageController(initialPage: initialPage);
        CommonImageGallery.show(
          context: context,
          imageList: imageList.map((url) => ImageEntry(id: url + tag, url: url)).toList(),
          initialPage:index,
        );
        _photoOption(false);
      },
      child: Hero(
        tag: imgPath + tag,
        child: MomentWidgetsUtils.clipImage(
          borderRadius: 8.px,
          child: ExtendedImage(
            image:OXCachedImageProviderEx.create(
              imgPath,
              width: 200,
              height: 200,
            ),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }

  List<PreviewImage> _getPreviewImageList(List<String> imageList) {
    return imageList.map((String path) {
      int findIndex = imageList.indexOf(path);
      return PreviewImage(id: findIndex.toString(), uri: path);
    }).toList();
  }

  Widget _showEditImageWidget(
      BuildContext context, int index, List<String> imageList) {
    bool isShowAddIcon = imageList[index] == 'add_moment.png';
    String imgPath =
        isShowAddIcon ? 'add_moment.png' : imageList[index];

    Widget imageWidget = Image.file(
      File(imgPath),
      fit: BoxFit.cover,
      // package: isShowAddIcon ? 'ox_discovery' : null,
    );

    if(isShowAddIcon){
      imageWidget = CommonImage(
        iconName: imgPath,
        fit: BoxFit.cover,
        package: 'ox_discovery',
        useTheme: true,
      );
    }

    return GestureDetector(
      onTap: () => _photoOption(isShowAddIcon),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: MomentWidgetsUtils.clipImage(
              borderRadius: 8.px,
              child: imageWidget,
            ),
          ),
          isShowAddIcon ? const SizedBox() : Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
              onTap: () {
                widget.delImageCallback?.call(index);
              },
              child: Container(
                width: 30.px,
                height: 30.px,
                decoration: BoxDecoration(
                  color: ThemeColor.color180,
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.px),
                  ),
                ),
                child: Center(
                  child: CommonImage(
                    iconName: 'close_icon.png',
                    size: 20.px,
                    color: Colors.red,
                    package: 'ox_discovery',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _photoOption(bool isShowAddIcon) {
    if (!isShowAddIcon) return;
    AlbumUtils.openAlbum(context,
        type: 1, selectCount: 9 - widget.imageList.length,
        callback: (List<String> imageList) {
      widget.addImageCallback?.call(imageList);
    });
  }

  double _getAspectRatio(int length) {
    if (widget.crossAxisCount == 1) return 1.0;
    if (widget.crossAxisCount == 2) {
      return length > 2 ? 1 : 2;
    }
    if (widget.crossAxisCount == 3) {
      if (length >= 1 && length <= 3) {
        return 3.0;
      } else if (length >= 4 && length <= 6) {
        return 1.5;
      } else if (length >= 7 && length <= 9) {
        return 1.0;
      }
    }
    return 1.0;
  }

  List<String> _getShowImageList() {
    if (!widget.isEdit) return widget.imageList;
    List<String> showImageList = widget.imageList;
    if (widget.isEdit && widget.imageList.length < 9) {
      showImageList.add('add_moment.png');
    }
    return showImageList;
  }

  void _onCloseGalleryPressed() {
    OXNavigator.pop(context);
    _galleryPageController?.dispose();
    _galleryPageController = null;
  }
}
