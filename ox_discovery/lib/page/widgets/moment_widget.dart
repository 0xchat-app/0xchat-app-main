import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_module_service/ox_module_service.dart';
import '../../enum/moment_enum.dart';
import '../../model/moment_model.dart';
import 'moment_rich_text_widget.dart';
import '../../utils/moment_widgets.dart';
import 'horizontal_scroll_widget.dart';
import 'moment_option_widget.dart';
import 'nine_palace_grid_picture_widget.dart';

class MomentWidget extends StatefulWidget {
  final EMomentType type;
  final String momentContent;
  final List<MomentOption>? momentOptionList;
  final GestureTapCallback? clickMomentCallback;
  const MomentWidget({
    super.key,
    required this.type,
    required this.momentContent,
    this.momentOptionList,
    this.clickMomentCallback,
  });

  @override
  _MomentWidgetState createState() => _MomentWidgetState();
}

class _MomentWidgetState extends State<MomentWidget> {
  @override
  Widget build(BuildContext context) {
    return _momentItemWidget();
  }

  Widget _momentItemWidget() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => widget.clickMomentCallback?.call(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 12.px,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _momentUserInfoWidget(),
            MomentRichTextWidget(
              clickBlankCallback: widget.clickMomentCallback,
              text: widget.momentContent,
            ).setPadding(EdgeInsets.symmetric(vertical: 12.px)),
            _momentTypeWidget(widget.type),
            // _momentReviewWidget(),
            MomentOptionWidget(
              momentOptionList: widget.momentOptionList,
            ),
          ],
        ),
      ),
    );
  }

  Widget _momentTypeWidget(EMomentType type) {
    Widget contentWidget = const SizedBox(width: 0);
    switch (type) {
      case EMomentType.picture:
        contentWidget = NinePalaceGridPictureWidget(
          width: 248.px,
          imageList: ['moment_avatar.png','moment_avatar.png','moment_avatar.png','moment_avatar.png'],
        ).setPadding(EdgeInsets.only(bottom: 12.px));
        break;
      case EMomentType.quote:
        contentWidget = HorizontalScrollWidget();
        break;
      case EMomentType.video:
        contentWidget = MomentWidgets.videoMoment(context, '', null);
        break;
      case EMomentType.content:
        break;
    }
    return contentWidget;
  }

  Widget _momentReviewWidget() {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColor.color190,
        borderRadius: BorderRadius.all(Radius.circular(8.px)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 6.px,
              horizontal: 8.px,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: ThemeColor.color200,
                  width: 0.5.px,
                ),
              ),
            ),
            child: Row(
              children: [
                CommonImage(
                  iconName: 'like_moment_icon.png',
                  size: 16.px,
                  package: 'ox_discovery',
                ).setPaddingOnly(right: 4.px),
                Text(
                  'Satoshi, ',
                  style: TextStyle(
                    color: ThemeColor.gradientMainStart,
                    fontSize: 11.px,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
          ...[1,2,3].map((int int) => _momentReviewItemWidget()),
        ],
      ),
    );
  }

  Widget _momentReviewItemWidget(){
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 6.px,
        horizontal: 8.px,
      ),
      child: Row(
        children: [
          Text(
            'Satoshi: ',
            style: TextStyle(
              color: ThemeColor.gradientMainStart,
              fontSize: 11.px,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'Thanks',
            style: TextStyle(
              color: ThemeColor.color0,
              fontSize: 11.px,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _momentUserInfoWidget() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    final pubKey = OXUserInfoManager
                            .sharedInstance.currentUserInfo?.pubKey ??
                        '';
                    OXModuleService.pushPage(
                        context, 'ox_chat', 'ContactUserInfoPage', {
                      'pubkey': pubKey,
                    });
                  },
                  child: MomentWidgets.clipImage(
                    imageName: 'moment_avatar.png',
                    borderRadius: 40.px,
                    imageSize: 40.px,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 10.px,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Satoshi',
                        style: TextStyle(
                          color: ThemeColor.color0,
                          fontSize: 14.px,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Satosh@0xchat.com· 45s ago',
                        style: TextStyle(
                          color: ThemeColor.color120,
                          fontSize: 12.px,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // CommonImage(
          //   iconName: 'more_moment_icon.png',
          //   size: 20.px,
          //   package: 'ox_discovery',
          // ),
        ],
      ),
    );
  }
}
