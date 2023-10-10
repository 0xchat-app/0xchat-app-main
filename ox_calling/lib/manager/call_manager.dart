import 'dart:async';
import 'dart:core';

import 'package:chatcore/chat-core.dart' as ChatCore;
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_calling/manager/signaling.dart';
import 'package:ox_calling/page/call_floating_draggable_overlay.dart';
import 'package:ox_calling/page/call_page.dart';
import 'package:ox_calling/utils/widget_util.dart';
import 'package:ox_common/business_interface/ox_chat/call_message_type.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/chat_prompt_tone.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';

class CallManager {
  static final CallManager instance = CallManager._internal();

  CallManager._internal();

  factory CallManager() {
    return instance;
  }

  static String tag = 'call_sample';
  String host = 'rtc.0xchat.com';
  int port = 8086;

  SignalingManager? _signaling;

  String? _selfId;
  final RTCVideoRenderer localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  bool _inCalling = false;
  CallState? callState;
  Session? _session;
  DesktopCapturerSource? selected_source_;
  bool _waitAccept = false;
  late BuildContext _context;
  ValueChanged<CallState?>? callStateHandler;
  CallMessageType callType = CallMessageType.video;
  String? callInitiator;
  String? callReceiver;
  Timer? _timer;
  int counter = 0;
  OverlayEntry? overlayEntry;
  final List<ValueChanged<int>> _valueChangedCallback = <ValueChanged<int>>[];
  bool initiativeHangUp = false;

  bool get getInCallIng{
    return _inCalling;
  }

  bool get getWaitAccept{
    return _waitAccept;
  }

  void initRTC({String? tHost}) async {
    if (tHost != null) {
      host = tHost;
    }
    _context = OXNavigator.navigatorKey.currentContext!;
    _signaling ??= SignalingManager(host, port, _context);
    ChatCore.Contacts.sharedInstance.onCallStateChange = (String friend, SignalingState state, String data, String? offerId) {
      LogUtil.e('core: onCallStateChange state=${state} ; data =${data};');
      _signaling?.onParseMessage(friend, state, data, offerId);
    };
    await initRenderers();
    _signaling?.onLocalStream = ((stream) {
      localRenderer.srcObject = stream;
      callStateHandler?.call(null);
    });

    _signaling?.onAddRemoteStream = ((_, stream) {
      remoteRenderer.srcObject = stream;
      callStateHandler?.call(null);
    });

    _signaling?.onRemoveRemoteStream = ((_, stream) {
      remoteRenderer.srcObject = null;
    });
    initListener();
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

  void connectServer() {
    _signaling?.connect();
  }

  void initListener() async {
    _signaling?.onSignalingStateChange = (SignalingStatus state) {
      switch (state) {
        case SignalingStatus.ConnectionClosed:
        case SignalingStatus.ConnectionError:
        case SignalingStatus.ConnectionOpen:
          break;
      }
    };

    _signaling?.onCallStateChange = (Session session, CallState state) async {
      if (_session == null || (_session != null && _session!.sid == session.sid) ) {
        callState = state;
      }
      switch (state) {
        case CallState.CallStateNew:
          _session ??= session;
          break;
        case CallState.CallStateRinging:
          _signaling?.isDisconnected(false);
          _signaling?.isStreamConnected(false);
          ///lack of speech type
          ChatCore.UserDB? userDB = await ChatCore.Account.sharedInstance.getUserInfo(session.pid);
          if (userDB == null) {
            break;
          } else {
            if (!_inCalling && (session.media == CallMessageType.audio.text || session.media == CallMessageType.video.text)) {
              if (session.media == CallMessageType.audio.text) {
                callType = CallMessageType.audio;
              } else if (session.media == CallMessageType.video.text) {
                callType = CallMessageType.video;
              }
              initiativeHangUp = false;
              callInitiator = userDB.pubKey;
              callReceiver = OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey;
              CallManager.instance.connectServer();
              OXNavigator.pushPage(_context,
                  (context) => CallPage(
                        userDB,
                        session.media,
                      ));
            }
          }
          break;
        case CallState.CallStateBye:
          if (callStateHandler != null && callState !=null) {
            callStateHandler!.call(callState!);
          }
          resetStatus(callInitiator == OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey ? true: false);
          break;
        case CallState.CallStateInvite:
          _waitAccept = true;
          break;
        case CallState.CallStateConnecting:
          if (callStateHandler != null && callState !=null) {
            callStateHandler!.call(callState!);
          }
          break;
        case CallState.CallStateConnected:
          if (_waitAccept) {
            _waitAccept = false;
          }
          _inCalling = true;
          PromptToneManager.sharedInstance.stopPlay();
          startTimer();
          if (callStateHandler != null && callState !=null) {
            callStateHandler!.call(callState!);
          }
          break;
      }
    };
  }

  Future<void> invitePeer(String peerId, {bool useScreen = false}) async {
    if (_signaling != null && peerId != _selfId) {
      _signaling?.invite(peerId, callType.text, useScreen);
      callInitiator = OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey;
      callReceiver = peerId;
    }
  }

  accept() {
    if (_session != null) {
      _inCalling = true;
      _signaling?.accept(_session!.sid, callType.text);
    }
  }

  reject() {
    if (_session != null) {
      _signaling?.reject(_session!.sid);
    }
    resetStatus(true);
  }

  hangUp() {
    if (_session != null) {
      _signaling?.bye(_session!.sid, _inCalling ? 'disconnect' : 'hangUp');
    }
    resetStatus(false);
  }

  timeOutAutoHangUp() {
    if (_session != null) {
      _signaling?.bye(_session!.sid, 'timeout');
    }
    resetStatus(false, isTomeOut: true);
  }

  switchCamera() {
    _signaling?.switchCamera();
  }

  setSpeaker(bool isSpeakerOn) async {
    Helper.setSpeakerphoneOn(isSpeakerOn);
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

  void resetStatus(bool isReceiverReject, {bool? isTomeOut}){
    // String content = _getCallHint(isReceiverReject, isTomeOut: isTomeOut);
    // CallManager.instance.sendLocalMessage(callInitiator, callReceiver, content);
    if (_waitAccept) {
      print('peer reject');
      _waitAccept = false;
    }
    _inCalling = false;
    stopTimer();
    localRenderer.srcObject = null;
    remoteRenderer.srcObject = null;
    _session = null;
    PromptToneManager.sharedInstance.stopPlay();
    if (overlayEntry != null && overlayEntry!.mounted) {
      overlayEntry?.remove();
      overlayEntry = null;
    }
    callInitiator = null;
    callReceiver = null;
    callState = null;
  }

  String _getCallHint(bool isReceiverReject, {bool? isTomeOut}){
    String content = '';
    if (CallManager.instance.counter > 0) {
      Duration duration = Duration(seconds: CallManager.instance.counter);
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(duration.inMinutes);
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      content = 'str_call_duration'.localized().replaceAll(r'${time}', '$twoDigitMinutes:$twoDigitSeconds');
    } else {
      if (callInitiator == OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey) {
        if (isTomeOut == null){
          if (isReceiverReject) {
            content = 'str_call_other_rejected'.localized();
          } else {
            content = 'str_call_canceled'.localized();
          }
        } else {
          content = 'str_call_other_not_answered'.localized();
        }
      } else {
        if (isTomeOut == null) {
          if (isReceiverReject) {
            content = 'str_call_rejected'.localized();
          } else {
            content = 'str_call_other_canceled'.localized();
          }
        } else {
          content = 'str_call_not_answered'.localized();
        }
      }
    }
    return content;
  }

  // Future<bool> sendLocalMessage(String? sender, String? receiver, String decryptContent) async {
  //   if (sender == null || receiver == null || sender.isEmpty || receiver.isEmpty) {
  //     return false;
  //   }
  //   ChatSessionModel? chatSessionModel = await OXChatBinding.sharedInstance.getChatSession(sender, receiver, '[${callType.text}]');
  //   if (chatSessionModel == null) {
  //     return false;
  //   }
  //   OXChatInterface.sendCallMessage(
  //       chatSessionModel,
  //       decryptContent,
  //       callType,
  //       sender);
  //   return true;
  // }

  void stopTimer() {
    counter = 0;
    _timer?.cancel();
    _timer = null;
  }

  void startTimer() async {
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