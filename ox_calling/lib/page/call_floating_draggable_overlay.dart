import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:ox_calling/page/call_page.dart';
import 'package:ox_common/business_interface/ox_chat/call_message_type.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_calling/manager/call_manager.dart';
import 'package:ox_calling/manager/signaling.dart';
import 'package:ox_calling/utils/widget_util.dart';

///Title: call_floating_draggable_overlay
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/9/14 14:35
class CallFloatingDraggableOverlay extends StatefulWidget {
  final UserDB userDB;

  const CallFloatingDraggableOverlay({Key? key, required this.userDB}) : super(key: key);

  @override
  _CallFloatingDraggableOverlayState createState() => _CallFloatingDraggableOverlayState();
}

class _CallFloatingDraggableOverlayState extends State<CallFloatingDraggableOverlay> {
  late double top, left;

  @override
  void initState() {
    super.initState();
    top = 50;
    left = 50;
    CallManager.instance.addObserver(counterValueChange);
  }

  void counterValueChange(value) {
    if (CallManager.instance.overlayEntry != null && CallManager.instance.overlayEntry!.mounted){
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: top,
          left: left,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                top += details.delta.dy;
                left += details.delta.dx;
              });
            },
            onTap: () {
              if (CallManager.instance.overlayEntry != null && CallManager.instance.overlayEntry!.mounted) {
                CallManager.instance.overlayEntry!.remove();
              }
              CallManager.instance.removeObserver(counterValueChange);
              OXNavigator.pushPage(OXNavigator.navigatorKey.currentContext!, (context) => CallPage(widget.userDB, CallManager.instance.callType.text));
            },
            child: CallManager.instance.callType == CallMessageType.audio
                ? Container(
              width: 80.0,
              height: 104.0,
              decoration: BoxDecoration(color: ThemeColor.color180.withOpacity(0.72), borderRadius: BorderRadius.circular(Adapt.px(16))),
              child: _contentWidget(),
            )
                : Container(
              width: 144.0,
              height: 200.0,
              decoration: BoxDecoration(color: ThemeColor.color180.withOpacity(0.72), borderRadius: BorderRadius.circular(Adapt.px(16))),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: RTCVideoView(CallManager.instance.remoteRenderer, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),
                  ),
                  _contentWidget(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _contentWidget(){
    return Container(
      alignment: (CallManager.instance.callType == CallMessageType.video && CallManager.instance.getInCallIng) ? Alignment.bottomCenter : Alignment.center,
      padding: (CallManager.instance.callType == CallMessageType.video && CallManager.instance.getInCallIng) ? EdgeInsets.only(bottom: Adapt.px(12)) : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (CallManager.instance.callType != CallMessageType.video || !CallManager.instance.getInCallIng)
            ClipRRect(
              borderRadius: BorderRadius.circular(Adapt.px(60)),
              child: OXUserAvatar(
                user: widget.userDB,
                size: Adapt.px(56),
                isCircular: false,
                isClickable: false,
              ),
            ),
          SizedBox(
            height: Adapt.px(3),
          ),
          if (CallManager.instance.callType == CallMessageType.video && !CallManager.instance.getInCallIng)
            SizedBox(
              width: Adapt.px(121),
              child: Center(
                child: Text(
                  widget.userDB.getUserShowName(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: ThemeColor.color10, fontSize: Adapt.px(20), fontWeight: FontWeight.w600),
                ),
              ),
            ),
          SizedBox(
            height: Adapt.px(5),
          ),
          _buildHint(),
        ],
      ),
    );
  }

  Widget _buildHint() {
    String showHint = 'Calling...';
    if (CallManager.instance.callState == CallState.CallStateConnected) {
      Duration duration = Duration(seconds: CallManager.instance.counter);
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(duration.inMinutes);
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      showHint = '$twoDigitMinutes:$twoDigitSeconds';
    }
    return Text(
      showHint,
      style: TextStyle(color: ThemeColor.color10, fontSize: Adapt.px(14)),
    );
  }
}
