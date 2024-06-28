import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_chat/page/contacts/groups/relay_group_qrcode_page.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_common/business_interface/ox_chat/interface.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';

///Title: relay_group_base_info_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/6/21 18:06
class RelayGroupBaseInfoPage extends StatefulWidget {
  final RelayGroupDB groupDB;

  RelayGroupBaseInfoPage({
    super.key,
    required this.groupDB,
  });

  @override
  State<StatefulWidget> createState() {
    return _RelayGroupBaseInfoPageState();
  }
}

class _RelayGroupBaseInfoPageState extends State<RelayGroupBaseInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.px),
            color: ThemeColor.color180,
          ),
          child: Column(
            children: [
              Container(
                height: 76.px,
                margin: EdgeInsets.symmetric(horizontal: 16.px),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MyText('Group Photo', 16.sp, ThemeColor.color0),
                    OXRelayGroupAvatar(relayGroup: widget.groupDB, size: 56.px),
                  ],
                ),
              ),
              GroupItemBuild(
                title: 'str_group_ID'.localized(),
                subTitle: widget.groupDB.groupId,
                isShowMoreIcon: false,
              ),
              GroupItemBuild(
                title: 'group_name'.localized(),
                subTitle: widget.groupDB.name,
                isShowMoreIcon: false,
              ),
              GroupItemBuild(
                title: 'description'.localized(),
                titleDes: widget.groupDB.about,
                isShowMoreIcon: false,
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.px),
            color: ThemeColor.color180,
          ),
          child: GroupItemBuild(
            title: Localized.text('ox_chat.group_qr_code'),
            actionWidget: CommonImage(
              iconName: 'qrcode_icon.png',
              width: Adapt.px(24),
              height: Adapt.px(24),
              useTheme: true,
            ),
            onTap: () {
              OXNavigator.pushPage(
                context,
                    (context) => RelayGroupQrcodePage(groupId: widget.groupDB.groupId),
              );
            },
          ),
        ),
      ],
    );
  }
}

class RelayGroupBaseInfoView extends StatelessWidget {
  final RelayGroupDB? relayGroup;

  RelayGroupBaseInfoView({this.relayGroup});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80.px,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.px),
        color: ThemeColor.color180,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 12.px),
      child: Row(
        children: [
          OXRelayGroupAvatar(
            relayGroup: relayGroup,
            size: 56.px,
          ),
          SizedBox(width: 10.px),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(relayGroup?.name ?? '', 16.sp, ThemeColor.color0, fontWeight: FontWeight.w400),
                if (relayGroup != null && relayGroup!.relayPubkey.isNotEmpty) SizedBox(height: 2.px),
                if (relayGroup != null && relayGroup!.relayPubkey.isNotEmpty)
                  MyText(relayGroup?.relayPubkey ?? '', 14.sp, ThemeColor.color100,
                      fontWeight: FontWeight.w400, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          SizedBox(width: 10.px),
          CommonImage(
            iconName: 'qrcode_icon.png',
            width: Adapt.px(24),
            height: Adapt.px(24),
            useTheme: true,
          ),
          CommonImage(
            iconName: 'icon_arrow_more.png',
            width: Adapt.px(24),
            height: Adapt.px(24),
          )
        ],
      ),
    );
  }
}

class GroupItemBuild extends StatelessWidget {
  final String? title;
  final String? titleDes;
  final String? subTitle;
  String? subTitleIcon;
  bool isShowMoreIcon;
  bool isShowDivider;
  final Widget? actionWidget;
  final GestureTapCallback? onTap;

  GroupItemBuild({
    this.title,
    this.titleDes,
    this.subTitle,
    this.subTitleIcon,
    this.isShowMoreIcon = true,
    this.isShowDivider = true,
    this.actionWidget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap != null ? onTap : () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 16.px,
            ),
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: 12.px,
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
                          fontSize: 16.px,
                        ),
                      ),
                      titleDes != null
                          ? Container(
                              width: 280.px,
                              margin: EdgeInsets.only(
                                top: 4.px,
                              ),
                              child: Text(
                                titleDes ?? '',
                                style: TextStyle(
                                  fontSize: 14.px,
                                  fontWeight: FontWeight.w400,
                                  color: ThemeColor.color100,
                                ),
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      actionWidget ?? SizedBox(),
                      subTitle != null
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (subTitleIcon != null)
                                  CommonImage(
                                      iconName: subTitleIcon ?? '', size: 24.px, package: OXChatInterface.moduleName),
                                MyText(subTitle ?? '', 14.sp, ThemeColor.color100, fontWeight: FontWeight.w400)
                              ],
                            )
                          : SizedBox(),
                      isShowMoreIcon
                          ? CommonImage(
                              iconName: 'icon_arrow_more.png',
                              size: 24.px,
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: isShowDivider,
            child: Divider(
              height: 0.5.px,
              color: ThemeColor.color160,
            ),
          ),
        ],
      ),
    );
  }
}
