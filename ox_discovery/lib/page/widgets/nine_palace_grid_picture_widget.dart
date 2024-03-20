import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/widgets/common_image.dart';

import '../../utils/moment_widgets.dart';

class NinePalaceGridPictureWidget extends StatefulWidget {
  final double? width;

  NinePalaceGridPictureWidget({super.key, this.width});

  @override
  _NinePalaceGridPictureWidgetState createState() =>
      _NinePalaceGridPictureWidgetState();
}

class _NinePalaceGridPictureWidgetState
    extends State<NinePalaceGridPictureWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      child: AspectRatio(
        aspectRatio: 1,
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 9,
          itemBuilder: (context, index) {
            if (index == 8) {
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
