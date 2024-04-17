import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:flutter/services.dart';
import 'package:ox_common/widgets/common_image.dart';

import '../widgets/moment_rich_text_widget.dart';
import '../../utils/moment_widgets_utils.dart';
import '../widgets/moment_option_widget.dart';
import '../widgets/moment_widget.dart';
import '../widgets/simple_moment_reply_widget.dart';

class MomentsPage extends StatefulWidget {
  const MomentsPage({Key? key}) : super(key: key);

  @override
  State<MomentsPage> createState() => _MomentsPageState();
}

class _MomentsPageState extends State<MomentsPage> {
  bool _isShowMask = false;

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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: ThemeColor.color200,
        appBar: CommonAppBar(
          backgroundColor: ThemeColor.color200,
          title: 'Moment',
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  left: 24.px,
                  right: 24.px,
                  bottom: 100.px,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MomentWidget(
                      momentContent:
                          "#0xchat it's worth noting that Satoshi Nakamoto's true identity remains unknown, and there is no publicly @Satoshi \nhttps://www.0xchat.com",
                    ),
                    _momentItemWidget(),
                    _momentItemWidget(),
                    _showRepliesWidget(),
                  ],
                ),
              ),
            ),
            _isShowMaskWidget(),
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: SimpleMomentReplyWidget(isFocusedCallback: (focusStatus) {
                if (focusStatus == _isShowMask) return;
                setState(() {
                  _isShowMask = focusStatus;
                });
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _isShowMaskWidget() {
    if (!_isShowMask) return const SizedBox();
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.transparent,
    );
  }

  Widget _momentItemWidget() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              MomentWidgetsUtils.clipImage(
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
                  MomentRichTextWidget(
                    text:
                        "#0xchat it's worth noting that Satoshi Nakamoto's true identity remains unknown, and there is no publicly @Satoshi \nhttps://www.0xchat.com",
                  ),
                  _quoteMomentWidget(),
                  MomentOptionWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showRepliesWidget() {
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
          // CommonImage(
          //   iconName: 'more_moment_icon.png',
          //   size: 20.px,
          //   package: 'ox_discovery',
          // ),
        ],
      ),
    );
  }

  Widget _quoteMomentWidget() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 8.px,
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
                      MomentWidgetsUtils.clipImage(
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
}
