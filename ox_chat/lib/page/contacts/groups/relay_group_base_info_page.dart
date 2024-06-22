import 'package:flutter/cupertino.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/widgets/common_image.dart';

///Title: relay_group_base_info_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/6/21 18:06
class RelayGroupBaseInfoPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _RelayGroupBaseInfoPageState();
  }

}

class _RelayGroupBaseInfoPageState extends State<RelayGroupBaseInfoPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}


class RelayGroupBaseInfoView extends StatelessWidget{
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
      child: Row(
        children: [
          OXRelayGroupAvatar(
            relayGroup: relayGroup,
            size: 56.px,
          ),
          SizedBox(width: 10.px),
          Expanded(child: Column(
            children: [
              MyText(relayGroup?.name??'', 16.sp, ThemeColor.color0, fontWeight: FontWeight.w400),
              SizedBox(height: 2.px),
              MyText(relayGroup?.relayPubkey??'', 14.sp, ThemeColor.color100, fontWeight: FontWeight.w400, overflow: TextOverflow.ellipsis),
            ],
          ),),
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