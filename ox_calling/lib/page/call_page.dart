import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatcore/chat-core.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter/material.dart';
import 'package:ox_calling/manager/call_manager.dart';
import 'package:ox_calling/manager/signaling.dart';
import 'package:ox_calling/utils/widget_util.dart';
import 'package:ox_common/business_interface/ox_chat/call_message_type.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/chat_prompt_tone.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_toast.dart';

///Title: call_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/7/27 16:36
class CallPage extends StatefulWidget {
  final UserDB userDB;
  final String mediaType; // audio;  video.

  const CallPage(this.userDB, this.mediaType, {super.key});

  @override
  State<StatefulWidget> createState() {
    return CallPageState();
  }
}

class CallPageState extends State<CallPage> {
  final Image _avatarPlaceholderImage = Image.asset(
    'assets/images/icon_user_default.png',
    fit: BoxFit.contain,
    width: Adapt.px(60),
    height: Adapt.px(60),
    package: 'ox_chat',
  );

  bool _isMicOn = true;
  bool _isSpeakerOn = true;
  bool _isVideoOn = true;
  double top = 120.0;
  double left = 20;

  @override
  void initState() {
    super.initState();
    if (widget.userDB.pubKey == OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey) {
      Future.delayed(
        const Duration(milliseconds: 300),
        () {
          CommonToast.instance.show(context, "Don't call yourself");
        },
      );
      return;
    }
    _initData();
    Future.delayed(const Duration(seconds: 60), (){
      if (!CallManager.instance.getInCallIng) {
        CallManager.instance.timeOutAutoHangUp();
        if (mounted) {
          OXNavigator.pop(context);
        }
      }
    });
  }

  @override
  void dispose() {
    CallManager.instance.removeObserver(counterValueChange);
    if (CallManager.instance.getInCallIng || CallManager.instance.getWaitAccept) {
      Future.delayed(const Duration(milliseconds: 10), () {
        CallManager.instance.toggleFloatingWindow(widget.userDB);
      });
    }
    super.dispose();
  }

  void _initData() async {
    CallManager.instance.callStateHandler = _callStateUpdate;
    CallManager.instance.connectServer();
    if (CallManager.instance.callType == CallMessageType.audio) {
      _isVideoOn = false;
    }
    if (!CallManager.instance.getInCallIng && !CallManager.instance.getWaitAccept) {
      CallManager.instance.setSpeaker(true);
      PromptToneManager.sharedInstance.playCalling();
      if (CallManager.instance.callState == CallState.CallStateInvite) {
        CallManager.instance.invitePeer(widget.userDB!.pubKey!);
      }
    }
    CallManager.instance.addObserver(counterValueChange);
  }

  void counterValueChange(value) {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      extendBody: true,
      body: Stack(
        children: [
          _isVideoOn
              ? Positioned(
                  left: 0.0,
                  right: 0.0,
                  top: 0.0,
                  bottom: 0.0,
                  child: Container(
                    margin: EdgeInsets.zero,
                    width: Adapt.screenW(),
                    height: Adapt.screenH(),
                    child: RTCVideoView(CallManager.instance.callState == CallState.CallStateConnected ? CallManager.instance.remoteRenderer : CallManager.instance.localRenderer, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        ThemeColor.gradientMainEnd.withOpacity(0.7),
                        ThemeColor.gradientMainStart.withOpacity(0.7),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: Adapt.px(56),
                margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon: CommonImage(
                          iconName: "icon_back_left_arrow.png",
                          color: Colors.white,
                          width: Adapt.px(24),
                          height: Adapt.px(24),
                          useTheme: true,
                        ),
                        onPressed: () {
                          OXNavigator.pop(context);
                        },
                      ),
                    ),
                    if (CallManager.instance.callType == CallMessageType.video && CallManager.instance.callState == CallState.CallStateConnected)
                      Align(alignment: Alignment.center, child: _buildHint()),
                  ],
                ),
              ),
              SizedBox(
                height: Adapt.px(24),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: Adapt.px(190),
                  child: (CallManager.instance.callType == CallMessageType.audio ||
                          (CallManager.instance.callType == CallMessageType.video && CallManager.instance.callState != CallState.CallStateConnected))
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildHeadImage(),
                            SizedBox(
                              height: Adapt.px(16),
                            ),
                            _buildHeadName(),
                            SizedBox(
                              height: Adapt.px(7),
                            ),
                            _buildHint(),
                          ],
                        )
                      : SizedBox(),
                ),
              ),
              SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.all(Radius.circular(Adapt.px(24))),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33000000),
                        offset: Offset(
                          3.0,
                          1.0,
                        ),
                        blurRadius: 20.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                  width: double.infinity,
                  height: Adapt.px(80),
                  margin: EdgeInsets.symmetric(horizontal: Adapt.px(24), vertical: Adapt.px(10)),
                  padding: EdgeInsets.symmetric(horizontal: Adapt.px(24), vertical: Adapt.px(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: _buildRowChild(),
                  ),
                ),
              ),
            ],
          ),
          if (_isVideoOn && CallManager.instance.callState == CallState.CallStateConnected)
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
                child: Container(
                  width: 90.0,
                  height: 120.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: RTCVideoView(CallManager.instance.localRenderer, mirror: true, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildRowChild() {
    List<Widget> showButtons = [];
    if (widget.mediaType == CallMessageType.video.text) {
      showButtons.add(
        InkWell(
          onTap: () {
            setState(() {
              _isVideoOn = !_isVideoOn;
              CallManager.instance.videoOnOff();
            });
          },
          child: _buildItemImg(_isVideoOn ? 'icon_call_video_on.png' : 'icon_call_video_off.png', 26, 48),
        ),
      );
    }
    showButtons.add(InkWell(
      onTap: () {
        if (CallManager.instance.callState == CallState.CallStateRinging) {
          CallManager.instance.reject();
        } else {
          CallManager.instance.hangUp();
        }
        OXNavigator.pop(context);
      },
      child: _buildItemImg('icon_call_end.png', 56, 56),
    ));
    if ((CallManager.instance.callType == CallMessageType.audio && CallManager.instance.callState != CallState.CallStateRinging)
        ||(CallManager.instance.callType == CallMessageType.video && CallManager.instance.callState == CallState.CallStateConnected)) {
      showButtons.insert(
        0,
        InkWell(
          onTap: () {
            _isMicOn = !_isMicOn;
            CallManager.instance.muteMic();
            setState(() {});
          },
          child: _buildItemImg(_isMicOn ? 'icon_call_mic_on.png' : 'icon_call_mic_off.png', 24, 48),
        ),
      );
    }
    if (CallManager.instance.callState == CallState.CallStateRinging) {
      showButtons.add(
        InkWell(
          onTap: () {
            CallManager.instance.accept();
            setState(() {});
          },
          child: _buildItemImg('icon_call_accept.png', 56, 56),
        ),
      );
    }
    if (widget.mediaType == CallMessageType.video.text) {
      showButtons.add(
        InkWell(
          onTap: () {
            CallManager.instance.switchCamera();
          },
          child: _buildItemImg('icon_call_camera_flip.png', 24, 48),
        ),
      );
    }
    if ((CallManager.instance.callType == CallMessageType.audio && CallManager.instance.callState != CallState.CallStateRinging)
        ||(CallManager.instance.callType == CallMessageType.video && CallManager.instance.callState == CallState.CallStateConnected)) {
      showButtons.add(
        InkWell(
          onTap: () {
            _isSpeakerOn = !_isSpeakerOn;
            setState(() {
              CallManager.instance.setSpeaker(_isSpeakerOn);
            });
          },
          child: _buildItemImg(_isSpeakerOn ? 'icon_call_speaker_on.png' : 'icon_call_speaker_off.png', 26, 48),
        ),
      );
    }
    return showButtons;
  }

  Widget _buildItemImg(String icon, int wh, int outsideWH) {
    return SizedBox(
      width: Adapt.px(outsideWH),
      height: Adapt.px(outsideWH),
      child: Center(
        child: CommonImage(
          iconName: icon,
          fit: BoxFit.contain,
          width: Adapt.px(wh),
          height: Adapt.px(wh),
          package: 'ox_calling',
        ),
      ),
    );
  }

  Widget _buildHeadImage() {
    return SizedBox(
      width: Adapt.px(100),
      height: Adapt.px(100),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Adapt.px(100)),
              child: CachedNetworkImage(
                imageUrl: widget.userDB.picture ?? '',
                fit: BoxFit.cover,
                placeholder: (context, url) => _avatarPlaceholderImage,
                errorWidget: (context, url, error) => _avatarPlaceholderImage,
                width: Adapt.px(100),
                height: Adapt.px(100),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Container(
                width: Adapt.px(91),
                height: Adapt.px(91),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(Adapt.px(91)),
                  border: Border.all(
                    width: Adapt.px(3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeadName() {
    String showName = widget.userDB.getUserShowName();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          showName,
          style: TextStyle(color: ThemeColor.color10, fontSize: Adapt.px(20), fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildHint() {
    String showHint = 'Calling...';
    if (CallManager.instance.callState == CallState.CallStateRinging) {
      showHint = widget.mediaType == CallMessageType.audio.text ? 'Invites you to a call...' : 'Invites you to a video call...';
    } else if (CallManager.instance.callState == CallState.CallStateConnected) {
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

  void _callStateUpdate(CallState callState) {
    if (callState == CallState.CallStateBye) {
      if (mounted) {
        OXNavigator.pop(context);
      }
    }
    if (mounted) {
      setState(() {});
    }

  }
}
