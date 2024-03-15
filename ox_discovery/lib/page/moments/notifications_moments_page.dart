import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:flutter/services.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_theme/ox_theme.dart';

import '../../utils/moment_widgets.dart';



class NotificationsMomentsPage extends StatefulWidget {
  const NotificationsMomentsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsMomentsPage> createState() => _NotificationsMomentsPageState();
}

class _NotificationsMomentsPageState extends State<NotificationsMomentsPage> {


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
        title: 'Notifications',
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _notificationsItemWidget(),
              _notificationsItemWidget(),
              _notificationsItemWidget(),
              _notificationsItemWidget(),
              _notificationsItemWidget(),
              _notificationsItemWidget(),

            ],
          ),
        ),
      ),
    );
  }

  Widget _notificationsItemWidget(){
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24.px,
        vertical: 12.px,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1.px,
            color: ThemeColor.color180,
          )
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              MomentWidgets.clipImage(
                imageName: 'moment_avatar.png',
                borderRadius: 40.px,
                imageSize: 40.px,
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 8.px,
                ),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                    ).setPaddingOnly(bottom: 2.px),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            right: 8.px,
                          ),
                          child: CommonImage(
                            iconName: "quote_moment_icon.png",
                            size: 16.px,
                            package: 'ox_discovery',
                            color: ThemeColor.gradientMainStart,
                          ),
                        ),
                        Text(
                          'Satoshi',
                          style: TextStyle(
                            color: ThemeColor.color0,
                            fontSize: 12.px,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'Sato12312312312312shi',
                          style: TextStyle(
                            color: ThemeColor.color0,
                            fontSize: 12.px,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          Container(
            width: 60.px,
            height: 60.px,
            decoration: BoxDecoration(
              color: ThemeColor.color100,
              borderRadius: BorderRadius.all(
                Radius.circular(
                  Adapt.px(8.px),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
