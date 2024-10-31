import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:chatcore/chat-core.dart';

///Title: relay_info_widget
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/8/5 19:56
class RelayInfoWidget extends StatefulWidget {
  bool showRelayIcon;
  double? iconSize;
  double? fontSize;
  FontWeight? fontWeight;
  Color? fontColor;
  double? padding;
  RelayInfoWidget({Key? key, this.showRelayIcon = true, this.iconSize, this.fontSize, this.fontWeight, this.fontColor, this.padding}) : super(key: key);

  @override
  RelayInfoWidgetState createState() => RelayInfoWidgetState();
}

class RelayInfoWidgetState extends State<RelayInfoWidget> {
  @override
  void initState() {
    super.initState();
    Connect.sharedInstance.addConnectStatusListener(connectStatusListener);
  }

  void connectStatusListener(relay, status, relayKinds) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Adapt.px(24),
      child: GestureDetector(
        onTap: () {
          OXModuleService.invoke('ox_usercenter', 'showRelayPage', [context]);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: widget.showRelayIcon,
              child: CommonImage(
                iconName: 'icon_relay_connected_amount.png',
                size: widget.iconSize ?? 24.px,
                fit: BoxFit.fill,
              ),
            ),
            Visibility(
              visible: widget.showRelayIcon,
              child: SizedBox(width: widget.padding ?? 4.px),
            ),
            Text(
              '${Account.sharedInstance.getConnectedRelaysCount()}/${Account.sharedInstance.getAllRelaysCount()}',
              style: TextStyle(
                fontSize: widget.fontSize ?? 14.sp,
                color: widget.fontColor ?? ThemeColor.color100,
                fontWeight: widget.fontWeight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    Connect.sharedInstance.removeConnectStatusListener(connectStatusListener);
    super.dispose();
  }
}
