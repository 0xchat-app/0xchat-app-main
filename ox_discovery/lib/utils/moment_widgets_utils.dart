import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_discovery/model/moment_extension_model.dart';
import 'package:ox_discovery/page/widgets/moment_rich_text_widget.dart';
import 'package:ox_discovery/utils/moment_content_analyze_utils.dart';
import 'package:ox_module_service/ox_module_service.dart';


class MomentWidgetsUtils {
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

  static Widget quoteMoment(UserDB userDB,NoteDB noteDB) {

    Widget _getImageWidget(){
      List<String> _getImagePathList = MomentContentAnalyzeUtils(noteDB.content).getMediaList(1);
      if(_getImagePathList.isEmpty) return const SizedBox();
      return ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(11.5.px),
          topRight: Radius.circular(11.5.px),
        ),
        child: Container(
          height: 172.px,
          color: ThemeColor.color100,
          child: OXCachedNetworkImage(
            imageUrl: _getImagePathList[0],
            fit: BoxFit.cover,
            // placeholder: (context, url) => badgePlaceholderImage,
            // errorWidget: (context, url, error) => badgePlaceholderImage,
            height: 172.px,
          ),
        ),
      );
    }
    return Container(
      margin: EdgeInsets.only(
        bottom: 10.px,
      ),
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
          _getImageWidget(),
          Container(
            padding: EdgeInsets.all(12.px),
            child: Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      MomentWidgetsUtils.clipImage(
                        borderRadius: 40.px,
                        imageSize: 40.px,
                        child: OXCachedNetworkImage(
                          imageUrl: userDB.picture ?? '',
                          fit: BoxFit.cover,
                          width: 20.px,
                          height: 20.px,
                        ),
                      ),
                      Text(
                        userDB.name ?? '--',
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
                        '${userDB.dns ?? ''}· ${noteDB.createAtStr}',
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
                    text: noteDB.content,
                    textSize: 12.px,
                    maxLines: 2,
                    isShowMoreTextBtn: false,
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
          MomentWidgetsUtils.clipImage(
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
