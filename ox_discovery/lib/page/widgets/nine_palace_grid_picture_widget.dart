import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/widgets/common_image.dart';

import '../../utils/moment_widgets.dart';

class NinePalaceGridPictureWidget extends StatefulWidget {
  final double? width;
  final bool isEdit;

  NinePalaceGridPictureWidget({super.key, this.width, this.isEdit = false});

  @override
  _NinePalaceGridPictureWidgetState createState() =>
      _NinePalaceGridPictureWidgetState();
}

class _NinePalaceGridPictureWidgetState extends State<NinePalaceGridPictureWidget> {

  final int picNum = 7;

  @override
  Widget build(BuildContext context) {
    int itemCount = widget.isEdit ? picNum + 1 : picNum;
    return Container(
      width: widget.width ?? double.infinity,
      child: AspectRatio(
        aspectRatio: 1,
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            if (widget.isEdit && index + 1 == itemCount ) {
              return Container(
                child: CommonImage(
                  iconName: "add_moment.png",
                  package: 'ox_discovery',
                ),
              );
            }
            return MomentWidgets.clipImage(
              imageName: 'moment_avatar.png',
              borderRadius: 8.px,
              imageSize: 20.px,
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
}
