import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_discovery/utils/album_utils.dart';
import '../../utils/moment_widgets_utils.dart';

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
            crossAxisCount: 3,
            crossAxisSpacing: 10.px,
            mainAxisSpacing: 10.px,
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
      onTap: () => _photoOption(false),
      child: MomentWidgetsUtils.clipImage(
        borderRadius: 8.px,
        child: MomentWidgetsUtils.clipImage(
          borderRadius: 8.px,
          child: OXCachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: imgPath,
            width: 20.px,
            height: 20.px,
          ),
        ),
      ),
    );
  }

  Widget _showEditImageWidget(
      BuildContext context, int index, List<String> imageList) {
    bool isShowAddIcon = imageList[index] == 'add_moment.png';
    String imgPath =
        isShowAddIcon ? 'assets/images/add_moment.png' : imageList[index];
    return GestureDetector(
      onTap: () => _photoOption(isShowAddIcon),
      child: MomentWidgetsUtils.clipImage(
        borderRadius: 8.px,
        child: Image.asset(
          imgPath,
          width: 20.px,
          fit: BoxFit.cover,
          height: 20.px,
          package: isShowAddIcon ? 'ox_discovery' : null,
        ),
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
    if (!widget.isEdit) return widget.imageList;
    List<String> showImageList = widget.imageList;
    if (widget.isEdit && widget.imageList.length < 9) {
      showImageList.add('add_moment.png');
    }
    return showImageList;
  }
}
