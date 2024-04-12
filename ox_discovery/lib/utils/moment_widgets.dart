import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_discovery/page/widgets/moment_rich_text_widget.dart';
import 'package:ox_module_service/ox_module_service.dart';


class MomentWidgets {
  static Widget clipImage({
    required double borderRadius,
    String? imageName,
    Widget? child,
    double imageHeight = 20,
    double imageWidth = 20,
    double? imageSize,
    package = 'ox_discovery',
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        borderRadius,
      ),
      child: child ??
          CommonImage(
            iconName: imageName ?? '',
            width: imageSize ?? imageWidth,
            height: imageSize ?? imageHeight,
            package: package,
          ),
    );
  }

  static Widget quoteMoment() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.px,
          color: ThemeColor.color160,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(
            11.5.px,
          ),
        ),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(11.5.px),
              topRight: Radius.circular(11.5.px),
            ),
            child: Container(
              height: 172.px,
              color: ThemeColor.color100,
            ),
          ),
          Container(
            padding: EdgeInsets.all(12.px),
            child: Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      MomentWidgets.clipImage(
                        imageName: 'moment_avatar.png',
                        borderRadius: 20.px,
                        imageSize: 20.px,
                      ),
                      Text(
                        'Satoshi',
                        style: TextStyle(
                          fontSize: 12.px,
                          fontWeight: FontWeight.w500,
                          color: ThemeColor.color0,
                        ),
                      ).setPadding(
                        EdgeInsets.symmetric(
                          horizontal: 4.px,
                        ),
                      ),
                      Text(
                        'Satosh@0xchat.com· 45s ago',
                        style: TextStyle(
                          fontSize: 12.px,
                          fontWeight: FontWeight.w400,
                          color: ThemeColor.color120,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  child: MomentRichTextWidget(
                    text:
                        "#0xchat it's worth noting that Satoshi Nakamoto's true identity remains unknown, and there is no publicly...",
                    textSize: 12.px,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget videoMoment(context, String videoUrl, String? videoImagePath) {
    return GestureDetector(
      onTap: () {
        OXModuleService.pushPage(context, 'ox_chat', 'ChatVideoPlayPage', {
          'videoUrl': videoUrl,
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              bottom: 12.px,
            ),
            decoration: BoxDecoration(
              color: ThemeColor.color100,
              borderRadius: BorderRadius.all(
                Radius.circular(
                  Adapt.px(12),
                ),
              ),
            ),
            width: 210.px,
            height: 154.px,
          ),
          MomentWidgets.clipImage(
            borderRadius: 16,
            child: videoImagePath != null
                ? Image.asset(
                    videoImagePath,
                    width: 210.px,
                    fit: BoxFit.fill,
                  )
                : const SizedBox(),
          ),
          CommonImage(
            iconName: 'play_moment_icon.png',
            package: 'ox_discovery',
            size: 60.0.px,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
