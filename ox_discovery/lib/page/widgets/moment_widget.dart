import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_discovery/page/moments/moments_page.dart';
import 'package:ox_module_service/ox_module_service.dart';
import '../../enum/moment_enum.dart';
import '../../model/moment_model.dart';
import '../../utils/moment_rich_text.dart';
import '../../utils/moment_widgets.dart';
import 'horizontal_scroll_widget.dart';
import 'moment_option_widget.dart';
import 'nine_palace_grid_picture_widget.dart';

class MomentWidget extends StatefulWidget {
  final EMomentType type;
  final String momentContent;
  final List<MomentOption>? momentOptionList;
  MomentWidget({super.key, required this.type, required this.momentContent,this.momentOptionList});

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
      onTap: () {
        OXNavigator.pushPage(context, (context) => MomentsPage());
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 12.px,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _momentUserInfoWidget(),
            MomentRichText(
              text: widget.momentContent,
            ).setPadding(EdgeInsets.symmetric(vertical: 12.px)),
            _momentTypeWidget(widget.type),
            MomentOptionWidget(momentOptionList: widget.momentOptionList,),
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
        ).setPadding(EdgeInsets.only(bottom: 12.px));
        break;
      case EMomentType.quote:
        contentWidget = HorizontalScrollWidget();
        break;
      case EMomentType.video:
        contentWidget = MomentWidgets.videoMoment();
        break;
      case EMomentType.content:
        break;
    }
    return contentWidget;
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
