import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_discovery/utils/album_utils.dart';
import '../../utils/moment_widgets_utils.dart';

class NinePalaceGridPictureWidget extends StatefulWidget {
  final int crossAxisCount;
  final double? width;
  final bool isEdit;
  final List<String> imageList;
  final int axisSpacing;
  final Function(List<String> imageList)? addImageCallback;

  const NinePalaceGridPictureWidget({
    super.key,
    required this.imageList,
    this.addImageCallback,
    this.width,
    this.axisSpacing = 10,
    this.isEdit = false,
    this.crossAxisCount = 3
  });

  @override
  _NinePalaceGridPictureWidgetState createState() =>
      _NinePalaceGridPictureWidgetState();
}

class _NinePalaceGridPictureWidgetState extends State<NinePalaceGridPictureWidget> {

  double get _getPicSize{
    if(widget.crossAxisCount == 1) return 50;
    if(widget.crossAxisCount == 2) return 30;
    return 20;
  }

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
      onTap: () => _photoOption(false),
      child: MomentWidgetsUtils.clipImage(
        borderRadius: 8.px,
        child: OXCachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: imgPath,
          width: _getPicSize.px,
          height: _getPicSize.px,
          placeholder: (context, url) => MomentWidgetsUtils.badgePlaceholderContainer(),
          errorWidget: (context, url, error) => MomentWidgetsUtils.badgePlaceholderContainer(),
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
          width: _getPicSize.px,
          height: _getPicSize.px,
          fit: BoxFit.cover,
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
    if(widget.crossAxisCount == 1) return 1.0;
    if(widget.crossAxisCount == 2) {
      return length > 2 ? 1 : 2;
    }
    if(widget.crossAxisCount == 3) {
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

}
