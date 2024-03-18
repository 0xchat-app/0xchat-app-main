import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:flutter/services.dart';
import 'package:ox_common/widgets/common_image.dart';

import '../../model/moment_model.dart';
import '../../utils/moment_rich_text.dart';
import '../../utils/moment_widgets.dart';

class MomentsPage extends StatefulWidget {
  const MomentsPage({Key? key}) : super(key: key);

  @override
  State<MomentsPage> createState() => _MomentsPageState();
}

class _MomentsPageState extends State<MomentsPage> {
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
              _momentItemWidget(),
              _showRepliesWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _momentItemWidget() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              MomentWidgets.clipImage(
                imageName: 'moment_avatar.png',
                borderRadius: 40.px,
                imageSize: 40.px,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 4.px,
                  ),
                  width: 1.0,
                  color: ThemeColor.color160,
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(8.px),
              padding: EdgeInsets.only(
                bottom: 16.px,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _momentUserInfoWidget(),
                  MomentRichText(
                    text: "#0xchat it's worth noting that Satoshi Nakamoto's true identity remains unknown, and there is no publicly @Satoshi \nhttps://www.0xchat.com \nRead More",
                  ),
                  _quoteMomentWidget(),
                  MomentWidgets.momentOption(showMomentOptionData),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showRepliesWidget(){
    return Container(
      padding: EdgeInsets.only(
        left: 12.px,
      ),
      child: Row(
        children: [
          CommonImage(
            iconName: 'more_vertical_icon.png',
            size: 16.px,
            package: 'ox_discovery',
          ),
          SizedBox(
            width: 20.px,
          ),
          Text(
            'Show replies',
            style: TextStyle(
              color: ThemeColor.purple2,
              fontSize: 12.px,
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
              Container(
                margin: EdgeInsets.only(
                  left: 10.px,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Satoshi',
                      style: TextStyle(
                        color: ThemeColor.color0,
                        fontSize: 14.px,
                        fontWeight: FontWeight.w500,
                      ),
                    ).setPaddingOnly(
                      right: 4.px,
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

  Widget _quoteMomentWidget() {
    return Container(
      margin: EdgeInsets.only(
        bottom: 8.px,
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
      // height: 250.px,
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
                  padding: EdgeInsets.only(
                    bottom: 4.px,
                  ),
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
                  child: Text(
                    "#0xchat it's worth noting that Satoshi Nakamoto's true identity remains unknown, and there is no publicly...",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: ThemeColor.color0,
                      fontSize: 12.px,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ninePalaceGridPictureWidget() {
    return Container(
      width: 248.px,
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
    );
  }
}
