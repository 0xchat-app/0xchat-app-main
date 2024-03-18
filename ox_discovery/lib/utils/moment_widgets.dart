import 'package:flutter/cupertino.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';

import '../enum/moment_enum.dart';
import '../model/moment_model.dart';

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

  static Widget momentOption(List<MomentOption> options) {
    Widget _iconTextWidget({
      required EMomentOptionType type,
      GestureTapCallback? onTap,
      int? clickNum,
    }) {
      final content = clickNum == null ? type.text : clickNum.toString();
      return GestureDetector(
        onTap: () => onTap?.call(),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(
                right: 4.px,
              ),
              child: CommonImage(
                iconName: type.getIconName,
                size: 16.px,
                package: 'ox_discovery',
              ),
            ),
            Text(
              content,
              style: TextStyle(
                color: ThemeColor.color80,
                fontSize: 12.px,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(
            Adapt.px(8),
          ),
        ),
        color: ThemeColor.color180,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 12.px,
        vertical: 12.px,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: options
            .map((MomentOption option) => _iconTextWidget(
                  type: option.type,
                  onTap: option.onTap,
                  clickNum: option.clickNum,
                ))
            .toList(),
      ),
    );
  }
}
