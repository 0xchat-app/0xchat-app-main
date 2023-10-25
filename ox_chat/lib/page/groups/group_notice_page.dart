import 'dart:io';

import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../utils/widget_tool.dart';
import 'group_edit_page.dart';

class GroupNoticePage extends StatefulWidget {
  @override
  _GroupNoticePageState createState() => new _GroupNoticePageState();
}

class _GroupNoticePageState extends State<GroupNoticePage> {
  TextEditingController _noticeNameController = TextEditingController();
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
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        useLargeTitle: false,
        centerTitle: true,
        title: 'Group Notice',
        backgroundColor: ThemeColor.color190,
        actions: [
          _appBarActionWidget(),
          SizedBox(
            width: Adapt.px(24),
          ),
        ],
      ),
      body: _EditGroupName(),
    );
  }

  Widget _appBarActionWidget() {
    return GestureDetector(
      onTap: () => OXNavigator.pushPage(
        context,
        (context) => GroupEditPage(
          pageType: EGroupEditType.notice,
        ),
      ),
      child: Center(
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
            'Edit',
            style: TextStyle(
              fontSize: Adapt.px(16),
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _EditGroupName() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Adapt.px(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: Adapt.px(48),
                margin: EdgeInsets.symmetric(
                  vertical: Adapt.px(24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: Adapt.px(48),
                      height: Adapt.px(48),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Adapt.px(48)),
                        child: Image.asset(
                          'assets/images/user_image.png',
                          fit: BoxFit.cover,
                          width: Adapt.px(76),
                          height: Adapt.px(76),
                          package: 'ox_common',
                        ),
                        // OXCachedNetworkImage(
                        //   imageUrl: _imgUrl,
                        //   fit: BoxFit.cover,
                        //   placeholder: (context, url) =>
                        //   placeholderImage,
                        //   errorWidget: (context, url, error) =>
                        //   placeholderImage,
                        //   width: Adapt.px(48),
                        //   height: Adapt.px(48),
                        // ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: Adapt.px(16), top: Adapt.px(2)),
                          child: MyText(
                            'Channel',
                            16,
                            ThemeColor.color10,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: Adapt.px(16), top: Adapt.px(2)),
                          child: MyText(
                            '12312',
                            16,
                            ThemeColor.color10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          _buildTextEditing(
            height: Adapt.px(110),
            controller: _noticeNameController,
            hintText: 'This is Group Name',
            maxLines: null,
          ),
        ],
      ),
    );
  }

  Widget _buildTextEditing({
    String? hintText,
    required TextEditingController controller,
    double? height,
    int? maxLines,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(16)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(
            Adapt.px(16),
          ),
        ),
        color: ThemeColor.color180,
      ),
      height: height,
      child: TextField(
        // focusNode: _focusNode,
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText ?? "Please enter...",
          hintStyle: TextStyle(
              color: ThemeColor.color0,
              fontWeight: FontWeight.w400,
              fontSize: Adapt.px(16)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
