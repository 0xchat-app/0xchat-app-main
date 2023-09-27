import 'dart:async';
import 'dart:convert';

import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_calling/widgets/screen_select_dialog.dart';
import 'package:ox_common/business_interface/ox_chat/call_message_type.dart';
import 'package:ox_common/log_util.dart';

import '../utils/turn.dart' if (dart.library.js) '../utils/turn_web.dart';

enum SignalingStatus {
  ConnectionOpen,
  ConnectionClosed,
  ConnectionError,
}

enum CallState {
  CallStateNew,
  CallStateRinging,
  CallStateInvite,
  CallStateConnecting,
  CallStateConnected,
  CallStateBye,
}

enum VideoSource {
  Camera,
  Screen,
}

class Session {
  Session({required this.sid, required this.pid, required this.media, required this.offerId});
  String pid;
  String sid;
  String media;
  String offerId;
  RTCPeerConnection? pc;
  RTCDataChannel? dc;
  List<RTCIceCandidate> remoteCandidates = [];
}

class SignalingManager {
  SignalingManager(this._host, this._port, this._context);

  String _selfId = Contacts.sharedInstance.pubkey;
  BuildContext? _context;
  var _host = '0.0.0.0';
  var _port = 8086;
  var _turnCredential;
  Map<String, Session> _sessions = {};
  MediaStream? _localStream;
  List<MediaStream> _remoteStreams = <MediaStream>[];
  List<RTCRtpSender> _senders = <RTCRtpSender>[];
  VideoSource _videoSource = VideoSource.Camera;

  Function(SignalingStatus state)? onSignalingStateChange;
  Function(Session session, CallState state)? onCallStateChange;
  Function(MediaStream stream)? onLocalStream;
  Function(Session session, MediaStream stream)? onAddRemoteStream;
  Function(Session session, MediaStream stream)? onRemoveRemoteStream;
  Function(dynamic event)? onPeersUpdate;
  Function(Session session, RTCDataChannel dc, RTCDataChannelMessage data)?
      onDataChannelMessage;
  Function(Session session, RTCDataChannel dc)? onDataChannel;
  bool _isDisconnected = false;
  bool _isStreamConnected = false;

  String get sdpSemantics => 'unified-plan';


  void isDisconnected(bool value) {
    _isDisconnected = value;
  }

  void isStreamConnected(bool value) {
    _isStreamConnected = value;
  }

  Map<String, dynamic> _iceServers = {
    'iceServers': [
      {'url': 'stun:stun.l.google.com:19302'},
    ]
  };

  final Map<String, dynamic> _config = {
    'mandatory': {},
    'optional': [
      {'DtlsSrtpKeyAgreement': true},
    ]
  };

  final Map<String, dynamic> _dcConstraints = {
    'mandatory': {
      'OfferToReceiveAudio': false,
      'OfferToReceiveVideo': false,
    },
    'optional': [],
  };

  close() async {
    await _cleanSessions();
  }

  void switchCamera() {
    if (_localStream != null) {
      if (_videoSource != VideoSource.Camera) {
        _senders.forEach((sender) {
          if (sender.track!.kind == 'video') {
            sender.replaceTrack(_localStream!.getVideoTracks()[0]);
          }
        });
        _videoSource = VideoSource.Camera;
        onLocalStream?.call(_localStream!);
      } else {
        Helper.switchCamera(_localStream!.getVideoTracks()[0]);
      }
    }
  }

  void switchToScreenSharing(MediaStream stream) {
    if (_localStream != null && _videoSource != VideoSource.Screen) {
      _senders.forEach((sender) {
        if (sender.track!.kind == 'video') {
          sender.replaceTrack(stream.getVideoTracks()[0]);
        }
      });
      onLocalStream?.call(stream);
      _videoSource = VideoSource.Screen;
    }
  }

  void videoOnOff() {
    if (_localStream != null) {
      bool enabled = _localStream!.getVideoTracks()[0].enabled;
      _localStream!.getVideoTracks()[0].enabled = !enabled;
    }
  }

  void muteMic() {
    if (_localStream != null) {
      bool enabled = _localStream!.getAudioTracks()[0].enabled;
      _localStream!.getAudioTracks()[0].enabled = !enabled;
    }
  }

  Future<void> invite(String peerId, String media, bool useScreen) async {
    var sessionId = _selfId + '-' + peerId;
    Session session = await _createSession(null,
        peerId: peerId,
        sessionId: sessionId,
        media: media,
        screenSharing: useScreen);
    _sessions[sessionId] = session;
    if (media == 'data') {
      _createDataChannel(session);
    }
    if (media == CallMessageType.audio.text) {
      if (_localStream != null && _localStream!.getVideoTracks().isNotEmpty) {
        _localStream!.getVideoTracks()[0].enabled = false;
      }
    }
    String? offerId = await _createOffer(session, media);
    if (offerId != null) {
      session.offerId = offerId;
      _isDisconnected = false;
      _isStreamConnected = false;
      onCallStateChange?.call(session, CallState.CallStateNew);
      onCallStateChange?.call(session, CallState.CallStateInvite);
    }
  }

  void bye(String sessionId, String reason) {
    var sess = _sessions[sessionId];
    if (sess != null) {
      Map map = {'session_id': sessionId, 'reason': reason};
      Contacts.sharedInstance
          .sendDisconnect(sess.offerId, sess.pid, jsonEncode(map));
      _closeSession(sess);
    }
  }

  void accept(String sessionId, String media) {
    var session = _sessions[sessionId];
    if (session == null) {
      return;
    }
    if (media == CallMessageType.audio.text) {
      if (_localStream != null) {
        _localStream!.getVideoTracks()[0].enabled = false;
      }
    }
    _createAnswer(session, media);
    onCallStateChange?.call(session, CallState.CallStateConnecting);
  }

  void reject(String sessionId) {
    var session = _sessions[sessionId];
    if (session == null) {
      return;
    }
    bye(session.sid, 'reject');
  }

  void inCalling(String sessionId) {
    var session = _sessions[sessionId];
    if (session == null) {
      return;
    }
    bye(session.sid, 'inCalling');
  }

  void onParseMessage(String friend, SignalingState state, String content,
      String? offerId) async {
    var data = jsonDecode(content);
    switch (state) {
      // case 'peers':
      //   {
      //     List<dynamic> peers = data;
      //     if (onPeersUpdate != null) {
      //       Map<String, dynamic> event = Map<String, dynamic>();
      //       event['self'] = _selfId;
      //       event['peers'] = peers;
      //       onPeersUpdate?.call(event);
      //     }
      //   }
      //   break;
      case SignalingState.offer:
        {
          var peerId = friend;
          var description = data['description'];
          var media = data['media'];
          var sessionId = data['session_id'];
          var session = _sessions[sessionId];
          var newSession = await _createSession(session,
              peerId: peerId,
              sessionId: sessionId,
              media: media,
              screenSharing: false);
          newSession.offerId = offerId ?? '';
          print('newSession.offerId: ${newSession.offerId}');
          _sessions[sessionId] = newSession;

          await newSession.pc?.setRemoteDescription(
              RTCSessionDescription(description['sdp'], description['type']));
          // await _createAnswer(newSession, media);

          if (newSession.remoteCandidates.length > 0) {
            newSession.remoteCandidates.forEach((candidate) async {
              await newSession.pc?.addCandidate(candidate);
            });
            newSession.remoteCandidates.clear();
          }
          onCallStateChange?.call(newSession, CallState.CallStateNew);
          onCallStateChange?.call(newSession, CallState.CallStateRinging);
        }
        break;
      case SignalingState.answer:
        {
          var description = data['description'];
          var sessionId = data['session_id'];
          var session = _sessions[sessionId];
          session?.pc?.setRemoteDescription(
              RTCSessionDescription(description['sdp'], description['type']));
          onCallStateChange?.call(session!, CallState.CallStateConnecting);
        }
        break;
      case SignalingState.candidate:
        {
          var peerId = friend;
          var candidateMap = data['candidate'];
          var sessionId = data['session_id'];
          var media = data['media'];
          var session = _sessions[sessionId];
          RTCIceCandidate candidate = RTCIceCandidate(candidateMap['candidate'],
              candidateMap['sdpMid'], candidateMap['sdpMLineIndex']);

          if (session != null) {
            if (session.pc != null) {
              await session.pc?.addCandidate(candidate);
            } else {
              session.remoteCandidates.add(candidate);
            }
          } else {
            if (media != null) {
              _sessions[sessionId] =
                  Session(pid: peerId, sid: sessionId, media: media, offerId: offerId ?? '')
                    ..remoteCandidates.add(candidate);
            }
          }
        }
        break;
      // case 'leave':
      //   {
      //     var peerId = data as String;
      //     _closeSessionByPeerId(peerId);
      //   }
      //   break;
      case SignalingState.disconnect:
        {
          if (!_isDisconnected) {
            _isDisconnected = true;
            var sessionId = data['session_id'];
            var session = _sessions.remove(sessionId);
            if (session != null) {
              onCallStateChange?.call(session, CallState.CallStateBye);
              _closeSession(session);
            }
          }
        }
        break;
      // case 'keepalive':
      //   {
      //     print('keepalive response!');
      //   }
      //   break;
      default:
        break;
    }
  }

  Future<void> connect() async {
    if (_turnCredential == null) {
      try {
        // _turnCredential = await getTurnCredential(_host, _port);
        /*{
            "username": "1584195784:mbzrxpgjys",
            "password": "isyl6FF6nqMTB9/ig5MrMRUXqZg",
            "ttl": 86400,
            "uris": ["turn:127.0.0.1:19302?transport=udp"]
          }
          {"username":"1689161060:flutter-webrtc","password":"8AEbjPEDBbvplBGO0V/c+H0uQGg","ttl":86400,"uris":["turn:127.0.0.1:19302?transport=udp"]}
        */
        _iceServers = {
          'iceServers': [
            {'url': 'stun:stun.l.google.com:19302'},
            // {
            //   'urls': _turnCredential['uris'][0],
            //   'username': _turnCredential['username'],
            //   'credential': _turnCredential['password']
            // },
            {'url': 'stun:rtc.0xchat.com:5349'},
            {
              'urls': 'turn:rtc.0xchat.com:5349',
              'username': '0xchat',
              'credential': 'Prettyvs511'
            },
          ]
        };
      } catch (e) {}
    }
  }

  Future<MediaStream> createStream(String media, bool userScreen,
      {BuildContext? context}) async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': userScreen ? false : true,
      'video': userScreen
          ? true
          : {
              'mandatory': {
                'minWidth':
                    '640', // Provide your own width, height and frame rate here
                'minHeight': '480',
                'minFrameRate': '30',
              },
              'facingMode': 'user',
              'optional': [],
            }
    };
    late MediaStream stream;
    if (userScreen) {
      if (WebRTC.platformIsDesktop) {
        final source = await showDialog<DesktopCapturerSource>(
          context: context!,
          builder: (context) => ScreenSelectDialog(),
        );
        stream = await navigator.mediaDevices.getDisplayMedia(<String, dynamic>{
          'video': source == null
              ? true
              : {
                  'deviceId': {'exact': source.id},
                  'mandatory': {'frameRate': 30.0}
                }
        });
      } else {
        stream = await navigator.mediaDevices.getDisplayMedia(mediaConstraints);
      }
    } else {
      stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    }

    onLocalStream?.call(stream);
    return stream;
  }

  Future<Session> _createSession(
    Session? session, {
    required String peerId,
    required String sessionId,
    required String media,
    required bool screenSharing,
  }) async {
    var newSession =
        session ?? Session(sid: sessionId, pid: peerId, media: media, offerId: '');
    if (media != 'data')
      _localStream =
          await createStream(media, screenSharing, context: _context);
    RTCPeerConnection pc = await createPeerConnection({
      ..._iceServers,
      ...{'sdpSemantics': sdpSemantics}
    }, _config);
    if (media != 'data') {
      switch (sdpSemantics) {
        case 'plan-b':
          pc.onAddStream = (MediaStream stream) {
            onAddRemoteStream?.call(newSession, stream);
            _remoteStreams.add(stream);
          };
          await pc.addStream(_localStream!);
          break;
        case 'unified-plan':
          // Unified-Plan
          pc.onTrack = (event) {
            if (event.track.kind == 'video') {
              onAddRemoteStream?.call(newSession, event.streams[0]);
            }
          };
          _localStream!.getTracks().forEach((track) async {
            _senders.add(await pc.addTrack(track, _localStream!));
          });
          break;
      }
    }
    pc.onIceCandidate = (candidate) async {
      if (candidate == null) {
        print('onIceCandidate: complete!');
        return;
      }
      // This delay is needed to allow enough time to try an ICE candidate
      // before skipping to the next one. 1 second is just an heuristic value
      // and should be thoroughly tested in your own environment.
      await Future.delayed(
          const Duration(seconds: 1),
          () => Contacts.sharedInstance.sendCandidate(
              _sessions[sessionId]!.offerId,
              peerId,
              jsonEncode({
                'candidate': {
                  'sdpMLineIndex': candidate.sdpMLineIndex,
                  'sdpMid': candidate.sdpMid,
                  'candidate': candidate.candidate,
                },
                'session_id': sessionId
              })));
    };

    pc.onIceConnectionState = (state) {
      print('onIceConnectionState: $state }');
      if (!_isStreamConnected && state == RTCIceConnectionState.RTCIceConnectionStateConnected) {
        _isStreamConnected = true;
        var session = _sessions[sessionId];
        if (session != null) {
          onCallStateChange?.call(session, CallState.CallStateConnected);
        }
      }
      if (!_isDisconnected && state == RTCIceConnectionState.RTCIceConnectionStateDisconnected) {
        _isDisconnected = true;
        var session = _sessions.remove(sessionId);
        if (session != null) {
          onCallStateChange?.call(session, CallState.CallStateBye);
          _closeSession(session);
        }
      }
    };

    pc.onRemoveStream = (stream) {
      onRemoveRemoteStream?.call(newSession, stream);
      _remoteStreams.removeWhere((it) {
        return (it.id == stream.id);
      });
    };

    pc.onDataChannel = (channel) {
      _addDataChannel(newSession, channel);
    };

    newSession.pc = pc;
    return newSession;
  }

  void _addDataChannel(Session session, RTCDataChannel channel) {
    channel.onDataChannelState = (e) {};
    channel.onMessage = (RTCDataChannelMessage data) {
      onDataChannelMessage?.call(session, channel, data);
    };
    session.dc = channel;
    onDataChannel?.call(session, channel);
  }

  Future<void> _createDataChannel(Session session,
      {label: 'fileTransfer'}) async {
    RTCDataChannelInit dataChannelDict = RTCDataChannelInit()
      ..maxRetransmits = 30;
    RTCDataChannel channel =
        await session.pc!.createDataChannel(label, dataChannelDict);
    _addDataChannel(session, channel);
  }

  Future<String?> _createOffer(Session session, String media) async {
    try {
      RTCSessionDescription s =
          await session.pc!.createOffer(media == 'data' ? _dcConstraints : {});
      await session.pc!.setLocalDescription(_fixSdp(s));
      Map map = {
        'description': {'sdp': s.sdp, 'type': s.type},
        'session_id': session.sid,
        'media': media
      };
      String jsonOfOfferContent = jsonEncode(map);
      OKEvent okEvent = await Contacts.sharedInstance
          .sendOffer(session.pid, jsonOfOfferContent);
      return okEvent.eventId;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  RTCSessionDescription _fixSdp(RTCSessionDescription s) {
    var sdp = s.sdp;
    s.sdp =
        sdp!.replaceAll('profile-level-id=640c1f', 'profile-level-id=42e032');
    return s;
  }

  Future<void> _createAnswer(Session session, String media) async {
    try {
      RTCSessionDescription s =
          await session.pc!.createAnswer(media == 'data' ? _dcConstraints : {});
      await session.pc!.setLocalDescription(_fixSdp(s));
      Map map = {
        'description': {'sdp': s.sdp, 'type': s.type},
        'session_id': session.sid
      };
      Contacts.sharedInstance
          .sendAnswer(session.offerId, session.pid, jsonEncode(map));
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _cleanSessions() async {
    if (_localStream != null) {
      _localStream!.getTracks().forEach((element) async {
        await element.stop();
      });
      await _localStream!.dispose();
      _localStream = null;
    }
    _sessions.forEach((key, sess) async {
      await sess.pc?.close();
      await sess.dc?.close();
    });
    _sessions.clear();
  }

  void _closeSessionByPeerId(String peerId) {
    var session;
    _sessions.removeWhere((String key, Session sess) {
      var ids = key.split('-');
      session = sess;
      return peerId == ids[0] || peerId == ids[1];
    });
    if (session != null) {
      _closeSession(session);
      onCallStateChange?.call(session, CallState.CallStateBye);
    }
  }

  Future<void> _closeSession(Session session) async {
    _localStream?.getTracks().forEach((element) async {
      await element.stop();
    });
    await _localStream?.dispose();
    _localStream = null;

    await session.pc?.close();
    await session.dc?.close();
    _senders.clear();
    _videoSource = VideoSource.Camera;
  }

}
