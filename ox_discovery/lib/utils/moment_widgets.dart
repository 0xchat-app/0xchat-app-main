import 'package:flutter/cupertino.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/widgets/common_image.dart';

class MomentWidgets {
  static Widget clipImage({
    required String imageName,
    required double borderRadius,
    double imageHeight = 20,
    double imageWidth = 20,
    double? imageSize,
    package = 'ox_discovery',
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        borderRadius,
      ),
      child: CommonImage(
        iconName: imageName,
        width: imageSize ?? imageWidth,
        height: imageSize ?? imageHeight,
        package: package,
      ),
    );
  }
}
