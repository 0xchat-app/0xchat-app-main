import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ox_chat_ui/ox_chat_ui.dart' show InputFacePage;
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:flutter/services.dart';
import 'package:ox_common/widgets/common_image.dart';

import '../../utils/album_utils.dart';
import '../../utils/moment_rich_text.dart';
import '../../utils/moment_widgets.dart';
import '../widgets/Intelligent_input_box_widget.dart';

import 'package:flutter/cupertino.dart';

class ReplyMomentsPage extends StatefulWidget {
  const ReplyMomentsPage({Key? key}) : super(key: key);

  @override
  State<ReplyMomentsPage> createState() => _ReplyMomentsPageState();
}

class _ReplyMomentsPageState extends State<ReplyMomentsPage> {
  final TextEditingController _textController = TextEditingController();

  String? _showImage;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
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
          actions: [
            GestureDetector(
              onTap: _postMoment,
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
                    'Post',
                    style: TextStyle(
                      fontSize: 16.px,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
          title: 'Reply',
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
                IntelligentInputBoxWidget(
                  imageUrl: _showImage,
                  textController: _textController,
                  hintText: 'Post your reply',
                ).setPaddingOnly(top: 12.px),
                _mediaWidget(),
              ],
            ),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _momentUserInfoWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _momentUserInfoWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: 226.px,
          child: Column(
            children: [
              Row(
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
              MomentRichText(
                text:
                    "#0xchat it's worth noting that Satoshi Nakamoto's true identity ",
                textSize: 12.px,
              ),
            ],
          ),
        ),
        CommonImage(
          iconName: 'moment_avatar.png',
          size: 60.px,
          package: 'ox_discovery',
        ),
      ],
    );
  }

  Widget _mediaWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.px),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              AlbumUtils.openAlbum(
                context,
                type: 1,
                selectCount: 1,
                callback: (List<String> imageList) {
                  _showImage = imageList[0];
                  setState(() {});
                },
              );
            },
            child: CommonImage(
              iconName: 'chat_image_icon.png',
              size: 24.px,
              package: 'ox_discovery',
            ),
          ),
          SizedBox(
            width: 12.px,
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => _buildEmojiDialog(),
              );
            },
            child: CommonImage(
              iconName: 'chat_emoti_icon.png',
              size: 24.px,
              package: 'ox_discovery',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiDialog() {
    return Container(
      padding: EdgeInsets.all(6.px),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(12)),
        color: ThemeColor.color190,
      ),
      child: SafeArea(
        child: SizedBox(
          height: 250.px,
          child: InputFacePage(
            textController: _textController,
          ),
        ),
      ),
    );
  }

  void _postMoment() {
    OXNavigator.pop(context);
  }
}
