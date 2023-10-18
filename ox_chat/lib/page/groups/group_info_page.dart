import 'dart:io';

import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:flutter/services.dart';
import 'package:ox_localizable/ox_localizable.dart';

import 'group_edit_page.dart';
import 'group_notice_page.dart';
import 'group_setting_qrcode_page.dart';

class GroupInfoPage extends StatefulWidget {
  @override
  _GroupInfoPageState createState() => new _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  // full follows
  List avatars = [1, 2, 1, 1, 1, 1, 1];
  bool _isMute = false;

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
        title: 'Group Info',
        backgroundColor: ThemeColor.color190,
        actions: [
          _appBarActionWidget(),
          SizedBox(
            width: Adapt.px(24),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: Adapt.px(24),
          ),
          child: Column(
            children: [
              _optionMemberWidget(),
              _groupBaseOptionView(),
              _groupLocationView(),
              _groupHistoryView(),
              _leaveBtnWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBarActionWidget() {
    return GestureDetector(
      onTap: () {},
      child: CommonImage(
        iconName: 'share_icon.png',
        width: Adapt.px(24),
        height: Adapt.px(24),
        useTheme: true,
      ),
    );
  }

  Widget _optionMemberWidget() {
    return Container(
      margin: EdgeInsets.only(
        top: Adapt.px(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _memberAvatarWidget(),
              _addOrDelMember(),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(
              vertical: Adapt.px(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: Adapt.px(20),
                  child: Text(
                    'View All 248 Members',
                    style: TextStyle(
                      fontSize: Adapt.px(14),
                      color: ThemeColor.color100,
                    ),
                  ),
                ),
                CommonImage(
                  iconName: 'icon_more.png',
                  width: Adapt.px(24),
                  height: Adapt.px(24),
                  package: 'ox_chat',
                  useTheme: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _memberAvatarWidget() {
    // return Container();
    return Container(
      margin: EdgeInsets.only(
        right: Adapt.px(0),
      ),
      constraints: BoxConstraints(
          maxWidth: Adapt.px(24 * avatars.length + 24), minWidth: Adapt.px(48)),
      child: AvatarStack(
        settings: RestrictedPositions(
            // maxCoverage: 0.1,
            // minCoverage: 0.2,
            align: StackAlign.left,
            laying: StackLaying.first),
        borderColor: ThemeColor.color180,
        height: Adapt.px(48),
        avatars: [
          for (var n = 0; n < avatars.length; n++)
            // if (avatars[n] != null && avatars[n]!.isNotEmpty)
            //   CachedNetworkImageProvider(avatars[n]!)
            // else
            const AssetImage('assets/images/user_image.png',
                package: 'ox_common'),
        ],
      ),
    );
  }

  Widget _addOrDelMember() {
    return Container(
      child: Row(
        children: [
          CommonImage(
            iconName: 'add_circle_icon.png',
            width: Adapt.px(48),
            height: Adapt.px(48),
            useTheme: true,
          ),
          Container(
            margin: EdgeInsets.only(
              left: Adapt.px(12),
            ),
            child: CommonImage(
              iconName: 'del_circle_icon.png',
              width: Adapt.px(48),
              height: Adapt.px(48),
              useTheme: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _groupBaseOptionView() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(16)),
        color: ThemeColor.color180,
      ),
      child: Column(
        children: [
          _topItemBuild(
            title: 'Group Name',
            subTitle: 'This is Group Name',
            onTap: () => OXNavigator.pushPage(
              context,
              (context) => GroupEditPage(pageType: EGroupEditType.groupName),
            ),
          ),
          _topItemBuild(
              title: 'Members', subTitle: '500', isShowMoreIcon: false),
          _topItemBuild(
            title: 'Group QR Code',
            actionWidget: CommonImage(
              iconName: 'qrcode_icon.png',
              width: Adapt.px(24),
              height: Adapt.px(24),
              useTheme: true,
            ),
            onTap: () => OXNavigator.pushPage(
              context,
              (context) => GroupSettingQrcodePage(),
            ),
          ),
          _topItemBuild(
            title: 'Group Notice',
            titleDes:
                '0xnoub1t0w642zyacycew3szjjhtszzarwf63mg62ehvj4zunn3gmcu4fqprypcuqpqpryrypc...',
            onTap: () => OXNavigator.pushPage(
              context,
              (context) => GroupNoticePage(),
            ),
          ),
          _topItemBuild(
            title: 'Join requests',
            isShowDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _groupLocationView() {
    return Container(
      margin: EdgeInsets.only(
        top: Adapt.px(12),
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(16)),
        color: ThemeColor.color180,
      ),
      child: Column(
        children: [
          _topItemBuild(
            title: 'Remark',
            subTitle: 'This is Remark',
            onTap: () => OXNavigator.pushPage(
              context,
              (context) => GroupEditPage(pageType: EGroupEditType.remark),
            ),
          ),
          _topItemBuild(
            title: 'My Alias in Group',
            subTitle: 'Painter',
            onTap: () => OXNavigator.pushPage(
              context,
              (context) => GroupEditPage(pageType: EGroupEditType.groupName),
            ),
          ),
          _topItemBuild(
            title: 'Mute',
            isShowDivider: false,
            actionWidget: _muteSwitchWidget(),
            isShowMoreIcon: false,
          ),
        ],
      ),
    );
  }

  Widget _muteSwitchWidget() {
    return Switch(
      value: _isMute,
      activeColor: Colors.white,
      activeTrackColor: ThemeColor.gradientMainStart,
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: ThemeColor.color160,
      onChanged: (value) => {
        setState(() {
          _isMute = value;
        })
      },
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
  }

  Widget _groupHistoryView() {
    return Container(
      margin: EdgeInsets.only(
        top: Adapt.px(12),
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(16)),
        color: ThemeColor.color180,
      ),
      child: Column(
        children: [
          _topItemBuild(
            title: 'Clear Chat History',
            onTap: () => _optionDialogView(
                title:
                    'Clear chat history? \n Chat history will be cleared on all of your devices.',
                optionContent: 'Clear',
                height: 192),
          ),
          _topItemBuild(title: 'Report', isShowDivider: false),
        ],
      ),
    );
  }

  Widget _topItemBuild({
    String? title,
    String? titleDes,
    String? subTitle,
    bool isShowMoreIcon = true,
    bool isShowDivider = true,
    Widget? actionWidget,
    GestureTapCallback? onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap != null ? onTap : () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: Adapt.px(16),
            ),
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: Adapt.px(12),
            ),
            // height: Adapt.px(52),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  // margin: EdgeInsets.only(left: Adapt.px(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title ?? '',
                        style: TextStyle(
                          color: ThemeColor.color0,
                          fontSize: Adapt.px(16),
                        ),
                      ),
                      titleDes != null
                          ? Container(
                              width: Adapt.px(280),
                              margin: EdgeInsets.only(
                                top: Adapt.px(4),
                              ),
                              child: Text(
                                titleDes,
                                style: TextStyle(
                                  fontSize: Adapt.px(14),
                                  fontWeight: FontWeight.w400,
                                  color: ThemeColor.color100,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      actionWidget != null ? actionWidget : Container(),
                      subTitle != null
                          ? Text(
                              subTitle,
                              style: TextStyle(
                                fontSize: Adapt.px(14),
                                fontWeight: FontWeight.w400,
                                color: ThemeColor.color100,
                              ),
                            )
                          : Container(),
                      isShowMoreIcon
                          ? CommonImage(
                              iconName: 'icon_arrow_more.png',
                              width: Adapt.px(24),
                              height: Adapt.px(24),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: isShowDivider,
            child: Divider(
              height: Adapt.px(0.5),
              color: ThemeColor.color160,
            ),
          ),
        ],
      ),
    );
  }

  Widget _leaveBtnWidget() {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(
          top: Adapt.px(16),
          bottom: Adapt.px(50),
        ),
        width: double.infinity,
        height: Adapt.px(48),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: ThemeColor.color180,
        ),
        alignment: Alignment.center,
        child: Text(
          'Leave',
          style: TextStyle(
            color: ThemeColor.red,
            fontSize: Adapt.px(16),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      onTap: () =>
          _optionDialogView(title: 'Leave this group?', optionContent: 'Leave'),
    );
  }

  void _optionDialogView(
      {String title = '', String optionContent = '', int height = 175}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: Opacity(
            opacity: 1,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: Adapt.px(height),
              decoration: BoxDecoration(
                color: ThemeColor.color180,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: Adapt.px(8),
                    ),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: Adapt.px(14),
                        fontWeight: FontWeight.w400,
                        color: ThemeColor.color100,
                      ),
                    ),
                  ),
                  Divider(
                    height: Adapt.px(0.5),
                    color: ThemeColor.color160,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: Adapt.px(17),
                    ),
                    child: Text(
                      optionContent,
                      style: TextStyle(
                        fontSize: Adapt.px(16),
                        fontWeight: FontWeight.w400,
                        color: ThemeColor.red,
                      ),
                    ),
                  ),
                  Container(
                    height: Adapt.px(8),
                    color: ThemeColor.color190,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      OXNavigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                        top: Adapt.px(17),
                      ),
                      width: double.infinity,
                      height: Adapt.px(80),
                      color: ThemeColor.color180,
                      child: Text(
                        Localized.text('ox_common.cancel'),
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 16, color: ThemeColor.color0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
