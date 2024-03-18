import 'dart:ui';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:flutter/services.dart';
import 'package:ox_common/widgets/common_image.dart';

import '../../model/moment_model.dart';
import '../../utils/moment_rich_text.dart';
import '../../utils/moment_widgets.dart';
import '../widgets/horizontal_scroll_widget.dart';
import '../widgets/nine_palace_grid_picture_widget.dart';


class PublicMomentsPage extends StatefulWidget {
  const PublicMomentsPage({Key? key}) : super(key: key);

  @override
  State<PublicMomentsPage> createState() => _PublicMomentsPageState();
}

class _PublicMomentsPageState extends State<PublicMomentsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color200,
      appBar: CommonAppBar(
        backgroundColor: ThemeColor.color200,
        actions: [
          GestureDetector(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: Adapt.px(24)),
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: [
                      ThemeColor.gradientMainEnd,
                      ThemeColor.gradientMainStart,
                    ],
                  ).createShader(Offset.zero & bounds.size);
                },
                child: Text(
                  'Clear',
                  style: TextStyle(
                    fontSize: 16.px,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            onTap: () {},
          ),
        ],
        title: 'Moment',
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 24.px,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _momentItemWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _momentItemWidget() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _momentUserInfoWidget(),
          MomentRichText(
            text: "#0xchat it's worth noting that Satoshi Nakamoto's true identity remains unknown, and there is no publicly @Satoshi \nhttps://www.0xchat.com \nRead More",
          ),
          NinePalaceGridPictureWidget(
            width: 248.px,
          ),
          HorizontalScrollWidget(),
          MomentWidgets.momentOption(showMomentOptionData),
          // _momentOptionWidget(),
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
              MomentWidgets.clipImage(
                imageName: 'moment_avatar.png',
                borderRadius: 40.px,
                imageSize: 40.px,
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
        CommonImage(
          iconName: 'more_moment_icon.png',
          size: 20.px,
          package: 'ox_discovery',
        )
      ],
    ));
  }

}
