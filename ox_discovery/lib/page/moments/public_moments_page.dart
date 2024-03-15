import 'dart:ui';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:flutter/services.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_discovery/enum/moment_enum.dart';

import '../../utils/moment_rich_text.dart';
import '../../utils/moment_widgets.dart';


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
          MomentRichText(),
          // _ninePalaceGridPictureWidget(),
          _quoteMomentWidget(),
          _momentOptionWidget(),
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

  Widget _quoteMomentWidget() {
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
      height: 250.px,
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

  Widget _momentContentWidget() {
    return Container();
  }

  Widget _momentMediaWidget() {
    return Container();
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
          crossAxisCount: 3, // 每行四项
          crossAxisSpacing: 10.px, // 水平间距
          mainAxisSpacing: 10.px, // 垂直间距
          childAspectRatio: 1, // 网格项的宽高比
        ),
      ),
    );
  }

  Widget _momentOptionWidget() {
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
        children: [
          _iconTextWidget(
              type:EMomentOptionType.reply
          ),
          _iconTextWidget(
              type:EMomentOptionType.repost
          ),
          _iconTextWidget(
              type:EMomentOptionType.like
          ),
          _iconTextWidget(
              type:EMomentOptionType.zaps
          ),
        ],
      ),
    );
  }

  Widget _iconTextWidget({required EMomentOptionType type }) {
    return Container(
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
            type.text,
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
}
