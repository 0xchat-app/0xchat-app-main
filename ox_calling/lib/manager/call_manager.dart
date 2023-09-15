import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ox_calling/ox_calling_platform_interface.dart';
import 'package:ox_calling/page/call_floating_draggable_overlay.dart';
import 'package:ox_calling/page/call_page.dart';
import 'package:ox_calling/manager/signaling.dart';
import 'package:ox_calling/utils/widget_util.dart';
import 'package:ox_calling/widgets/screen_select_dialog.dart';
import 'package:ox_common/business_interface/ox_chat/call_message_type.dart';
import 'package:ox_common/business_interface/ox_chat/interface.dart';
import 'package:ox_common/log_util.dart';
import 'dart:core';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:chatcore/chat-core.dart' as ChatCore;

class CallManager {
  static final CallManager instance = CallManager._internal();

  CallManager._internal();

  factory CallManager() {
    return instance;
  }

  static String tag = 'call_sample';
  String host = 'rtc.0xchat.com';

  SignalingManager? _signaling;

  String? _selfId;
  final RTCVideoRenderer localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  bool inCalling = false;
  CallState? callState;
  Session? _session;
  DesktopCapturerSource? selected_source_;
  bool _waitAccept = false;
  late BuildContext _context;
  ValueChanged<CallState>? callStateHandler;
  CallMessageType callType = CallMessageType.video;
  String? callInitiator;
  String? callReceiver;
  Timer? _timer;
  int counter = 0;
  OverlayEntry? overlayEntry;

  final List<ValueChanged<int>> _valueChangedCallback = <ValueChanged<int>>[];

  void initRTC({String? tHost}) {
    if (tHost != null) {
      host = tHost;
    }
    _context = OXNavigator.navigatorKey.currentContext!;
    initRenderers();
    _connect(_context);
  }

  Future<void> initRenderers() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
  }

  closeRTC() {
    _signaling?.close();
    localRenderer.dispose();
    remoteRenderer.dispose();
    _timer?.cancel();
    _timer = null;
  }

  void _connect(BuildContext context) async {
    _signaling ??= SignalingManager(host, context)..connect();
    _signaling?.onSignalingStateChange = (SignalingStatus state) {
      switch (state) {
        case SignalingStatus.ConnectionClosed:
        case SignalingStatus.ConnectionError:
        case SignalingStatus.ConnectionOpen:
          break;
      }
    };

    _signaling?.onCallStateChange = (Session session, CallState state) async {
      callState = state;
      switch (state) {
        case CallState.CallStateNew:
          _session = session;
          break;
        case CallState.CallStateRinging:
          if (CallManager.instance._waitAccept || CallManager.instance.inCalling) {
            return;
          }
          ///lack of speech type
          ChatCore.UserDB? userDB = await ChatCore.Account.sharedInstance.getUserInfo(session.pid);
          if (userDB == null) {
            break;
          } else {
            if (!inCalling && (session.media == CallMessageType.audio.text || session.media == CallMessageType.video.text)) {
              if (session.media == CallMessageType.audio.text) {
                callType = CallMessageType.audio;
              } else if (session.media == CallMessageType.video.text) {
                callType = CallMessageType.video;
              }
              OXNavigator.pushPage(_context,
                  (context) => CallPage(
                        userDB,
                        session.media,
                      ));
            }
          }
          break;
        case CallState.CallStateBye:
          calledBye();
          break;
        case CallState.CallStateInvite:
          _waitAccept = true;
          break;
        case CallState.CallStateConnected:
          if (_waitAccept) {
            _waitAccept = false;
          }
          startTimer();
          inCalling = true;
          break;
      }
      if (callStateHandler != null && callState !=null) {
        callStateHandler!(callState!);
      }
    };

    // _signaling?.onPeersUpdate = ((event) {
    //   // setState(() {
    //     _selfId = event['self'];
    //     _peers = event['peers'];
    //   // });
    // });

    _signaling?.onLocalStream = ((stream) {
      localRenderer.srcObject = stream;
      // setState(() {});
    });

    _signaling?.onAddRemoteStream = ((_, stream) {
      remoteRenderer.srcObject = stream;
      // setState(() {});
    });

    _signaling?.onRemoveRemoteStream = ((_, stream) {
      remoteRenderer.srcObject = null;
    });
  }

  invitePeer(String peerId, {bool useScreen = false}) async {
    if (_signaling != null && peerId != _selfId) {
      _signaling?.invite(peerId, callType.text, useScreen);
    }
  }

  accept() {
    if (_session != null) {
      inCalling = true;
      _signaling?.accept(_session!.sid, callType.text);
    }
  }

  reject() {
    if (_session != null) {
      _signaling?.reject(_session!.sid);
    }
    calledBye();
  }

  hangUp() {
    if (_session != null) {
      _signaling?.bye(_session!.sid);
    }
    calledBye();
  }

  switchCamera() {
    _signaling?.switchCamera();
  }

  setSpeaker(bool isSpeakerOn) async {
    final bool setResult = await OxCallingPlatform.instance.setSpeakerStatus(isSpeakerOn);
  }

  muteMic() {
    _signaling?.muteMic();
  }

  videoOnOff() {
    _signaling?.videoOnOff();
  }

  double computeAspectRatio() {
    double aspectRatio = 16 / 9;
    if (localRenderer.srcObject != null && localRenderer.srcObject!.getVideoTracks().isNotEmpty) {
      final videoTrack = localRenderer.srcObject!.getVideoTracks()[0];
      final settings = videoTrack.getSettings();
      if (settings['width'] != null && settings['height'] != null) {
        aspectRatio = settings['width']! / settings['height']!;
      }
    }
    return aspectRatio;
  }

  void calledBye(){
    if (_waitAccept) {
      print('peer reject');
      _waitAccept = false;
    }
    stopTimer();
    localRenderer.srcObject = null;
    remoteRenderer.srcObject = null;
    inCalling = false;
    _session = null;
    if (overlayEntry != null && overlayEntry!.mounted) {
      overlayEntry?.remove();
      overlayEntry = null;
    }

    String content = '';
    if (CallManager.instance.counter > 0) {
      Duration duration = Duration(seconds: CallManager.instance.counter);
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
  }

  Future<bool> sendLocalMessage(String? sender, String? receiver, String decryptContent) async {
    if (sender == null || receiver == null || sender.isEmpty || receiver.isEmpty) {
      return false;
    }
    ChatSessionModel? chatSessionModel = await OXChatBinding.sharedInstance.getChatSession(sender, receiver, '[${callType.text}]');
    if (chatSessionModel == null) {
      return false;
    }
    OXChatInterface.sendCallMessage(
        chatSessionModel,
        decryptContent,
        callType);
    return true;
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void startTimer() async {
    counter = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      counter++;
      notifyAllObserverValueChanged();
    });
  }

  void toggleFloatingWindow(ChatCore.UserDB userDB) {
    overlayEntry ??= OverlayEntry(
        builder: (context) => CallFloatingDraggableOverlay(userDB: userDB),
      );
    Overlay.of(OXNavigator.navigatorKey.currentContext!)!.insert(overlayEntry!);
  }
}

extension CallCacheObserverEx on CallManager {
  void addObserver(ValueChanged<int> valueChangedCallback) => _valueChangedCallback.add(valueChangedCallback);
  bool removeObserver(ValueChanged<int> valueChangedCallback) => _valueChangedCallback.remove(valueChangedCallback);

  Future<void> notifyAllObserverValueChanged() async {
    final valueChangedCallback = _valueChangedCallback;
    for (var callback in valueChangedCallback) {
      callback(counter);
    }
  }
}