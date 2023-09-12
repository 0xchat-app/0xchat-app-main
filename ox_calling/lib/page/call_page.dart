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

  Timer? _timer;
  int _counter = 0;
  bool _isMicOn = true;
  bool _isSpeakerOn = true;
  bool _isVideoOn = true;
  late double _aspectRatio;
  String? callInitiator;
  String? callReceiver;

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
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    CallManager.instance.callState = null;
    CallManager.instance.inCalling = false;
    super.dispose();
  }

  void _initData() async {
    CallManager.instance.callStateHandler = _callStateUpdate;
    LogUtil.e('Michael: calling---1---state=${CallManager.instance.callState}-----_initData---${CallManager.instance.callType.text}');
    if (CallManager.instance.callState == CallState.CallStateInvite) {
      LogUtil.e('Michael: calling---2--state=${CallManager.instance.callState}-----_initData---');
      CallManager.instance.invitePeer(widget.userDB!.pubKey!);
    }
    _aspectRatio = CallManager.instance.computeAspectRatio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            CallManager.instance.inCalling && _isVideoOn
                ? OrientationBuilder(builder: (context, orientation) {
                    return Container(
                      child: Stack(children: <Widget>[
                        Positioned(
                            left: 0.0,
                            right: 0.0,
                            top: 0.0,
                            bottom: 0.0,
                            child: Container(
                              margin: EdgeInsets.zero,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              decoration: const BoxDecoration(color: Colors.black54),
                              child: AspectRatio(
                                aspectRatio: _aspectRatio,
                                child: RTCVideoView(CallManager.instance.remoteRenderer, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),
                              ),
                            )),
                        Positioned(
                          left: 20.0,
                          top: 120.0,
                          child: Container(
                            width: orientation == Orientation.portrait ? 90.0 : 120.0,
                            height: orientation == Orientation.portrait ? 120.0 : 90.0,
                            decoration: const BoxDecoration(color: Colors.black54),
                            child: RTCVideoView(CallManager.instance.localRenderer, mirror: true),
                          ),
                        ),
                      ]),
                    );
                  })
                : Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ThemeColor.gradientMainEnd.withOpacity(0.4),
                          ThemeColor.gradientMainStart.withOpacity(0.4),
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
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: CommonImage(
                      iconName: "appbar_back.png",
                      color: Colors.white,
                      width: Adapt.px(24),
                      height: Adapt.px(24),
                      useTheme: false,
                    ),
                    onPressed: () {
                      OXNavigator.pop(context);
                    },
                  ),
                ),
                SizedBox(
                  height: Adapt.px(24),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: Adapt.px(190),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildHeadImage(),
                        _buildHeadName(),
                        _buildHint(),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: ThemeColor.color180.withOpacity(0.2),
                    borderRadius: BorderRadius.all(Radius.circular(Adapt.px(24))),
                  ),
                  width: double.infinity,
                  height: Adapt.px(80),
                  margin: EdgeInsets.symmetric(horizontal: Adapt.px(24), vertical: Adapt.px(10)),
                  padding: EdgeInsets.symmetric(horizontal: Adapt.px(12), vertical: Adapt.px(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: _buildRowChild(),
                  ),
                ),
              ],
            ),
          ],
        ),
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
            });
          },
          child: _buildItemImg(_isVideoOn ? 'icon_call_video_on.png' : 'icon_call_video_off.png', 24),
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

        ///TODO add end_call message
        OXNavigator.pop(context);
      },
      child: _buildItemImg('icon_call_end.png', 60),
    ));
    if (CallManager.instance.callState != CallState.CallStateRinging) {
      showButtons.insert(
        0,
        InkWell(
          onTap: () {
            _isMicOn = !_isMicOn;
            CallManager.instance.muteMic();
            setState(() {});
          },
          child: _buildItemImg(_isMicOn ? 'icon_call_mic_on.png' : 'icon_call_mic_off.png', 24),
        ),
      );
      if (widget.mediaType == 'video') {
        showButtons.add(
          InkWell(
            onTap: () {
              CallManager.instance.switchCamera();
            },
            child: _buildItemImg('icon_call_camera_flip.png', 24),
          ),
        );
      }
      showButtons.add(
        InkWell(
          onTap: () {
            _isSpeakerOn = !_isSpeakerOn;
            setState(() {
              CallManager.instance.setSpeaker(_isSpeakerOn);
            });
          },
          child: _buildItemImg(_isSpeakerOn ? 'icon_call_speaker_on.png' : 'icon_call_speaker_off.png', 26),
        ),
      );
    } else {
      showButtons.add(
        InkWell(
          onTap: () {
            CallManager.instance.accept();
          },
          child: _buildItemImg('icon_call_accept.png', 60),
        ),
      );
    }
    return showButtons;
  }

  Widget _buildItemImg(String icon, int wh) {
    return SizedBox(
      width: Adapt.px(60),
      height: Adapt.px(60),
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
          style: TextStyle(color: ThemeColor.titleColor, fontSize: 20),
        ),
      ],
    );
  }

  Widget _buildHint() {
    String showHint = 'Calling...';
    if (CallManager.instance.callState == CallState.CallStateRinging) {
      showHint = widget.mediaType == 'audio' ? 'Invites you to a call...' : 'Invites you to a video call...';
    } else if (CallManager.instance.callState == CallState.CallStateConnected) {
      Duration duration = Duration(seconds: _counter);
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(duration.inMinutes);
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      showHint = '$twoDigitMinutes:$twoDigitSeconds';
      LogUtil.e('Michael: update _counter =${_counter};  showHint =${showHint}');
    }
    return Text(
      showHint,
      style: TextStyle(color: ThemeColor.titleColor, fontSize: 20),
    );
  }

  void _callStateUpdate(CallState callState) {
    LogUtil.e('Michael: calling---- _callStateUpdate CallState =${callState.name}-----mounted =$mounted-----');
    if (!mounted) {
      return;
    }
    if (callState == CallState.CallStateConnected) {
      startTimer();
    } else if (callState == CallState.CallStateBye) {
      stopTimer();
      String content = '';
      if (_counter > 0) {
        Duration duration = Duration(seconds: _counter);
        String twoDigits(int n) => n.toString().padLeft(2, "0");
        String twoDigitMinutes = twoDigits(duration.inMinutes);
        String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
        content = 'str_call_duration'.localized().replaceAll(r'${time}', '$twoDigitMinutes:$twoDigitSeconds');
      } else {
        if (callInitiator == OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey) {
          content = 'str_call_canceled'.localized();
        } else {
          content = 'str_call_rejected'.localized();
        }
      }
      CallManager.instance.sendLocalMessage(callInitiator, callReceiver, content);
      OXNavigator.pop(context);
    } else if (callState == CallState.CallStateRinging) {
      callInitiator = widget.userDB.pubKey;
      callReceiver = OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey;
    } else if (callState == CallState.CallStateInvite) {
      callInitiator = OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey;
      callReceiver = widget.userDB.pubKey;
    }
    setState(() {});
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void startTimer() async {
    _counter = 0;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _counter++;
        });
      }
    });
  }
}
