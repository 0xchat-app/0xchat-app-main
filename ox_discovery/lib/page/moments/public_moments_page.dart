import 'dart:ui';
import 'dart:io';
import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:flutter/services.dart';

import '../../enum/moment_enum.dart';
import '../../utils/moment_widgets.dart';
import '../widgets/moment_widget.dart';
import 'notifications_moments_page.dart';

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
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 24.px,
        ),
        margin: EdgeInsets.only(
          bottom: 100.px,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _newMomentTipsWidget(),
            MomentWidget(type:EMomentType.picture),
            MomentWidget(type:EMomentType.content),
            MomentWidget(type:EMomentType.video),
            MomentWidget(type:EMomentType.quote),
          ],
        ),
      ),
    );
  }

  Widget _newMomentTipsWidget() {
    Widget _wrapContainerWidget(
        {required Widget leftWidget,
        required String rightContent,
        required GestureTapCallback onTap}) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40.px,
          padding: EdgeInsets.symmetric(
            horizontal: 12.px,
          ),
          decoration: BoxDecoration(
            color: ThemeColor.color180,
            borderRadius: BorderRadius.all(
              Radius.circular(
                Adapt.px(22),
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              leftWidget,
              SizedBox(
                width: 8.px,
              ),
              Text(
                rightContent,
                style: TextStyle(
                  color: ThemeColor.color0,
                  fontSize: 14.px,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.px),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _wrapContainerWidget(
            onTap: () {
              OXNavigator.pushPage(
                  context, (context) => NotificationsMomentsPage());
            },
            leftWidget: _memberAvatarWidget(),
            rightContent: '10 new pots',
          ),
          SizedBox(
            width: 20.px,
          ),
          _wrapContainerWidget(
            onTap: () {
              OXNavigator.pushPage(
                  context, (context) => NotificationsMomentsPage());
            },
            leftWidget: MomentWidgets.clipImage(
              imageName: 'moment_avatar.png',
              borderRadius: 26.px,
              imageSize: 26.px,
            ),
            rightContent: '2 replies',
          ),
        ],
      ),
    );
  }

  Widget _memberAvatarWidget() {
    int groupMemberNum = 4;
    if (groupMemberNum == 0) return Container();
    int renderCount = groupMemberNum > 8 ? 8 : groupMemberNum;
    return Container(
      margin: EdgeInsets.only(
        right: Adapt.px(0),
      ),
      constraints: BoxConstraints(
          maxWidth: Adapt.px(8 * renderCount + 8), minWidth: Adapt.px(26)),
      child: AvatarStack(
        settings: RestrictedPositions(
            // maxCoverage: 0.1,
            // minCoverage: 0.2,
            align: StackAlign.left,
            laying: StackLaying.first),
        borderColor: ThemeColor.color180,
        height: Adapt.px(26),
        avatars: _showMemberAvatarWidget(3),
      ),
    );
  }

  List<ImageProvider<Object>> _showMemberAvatarWidget(int renderCount) {
    List<ImageProvider<Object>> avatarList = [];
    for (var n = 0; n < renderCount; n++) {
      avatarList.add(const AssetImage('assets/images/moment_avatar.png',
          package: 'ox_discovery'));
    }
    return avatarList;
  }
}
