import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/utils/throttle_utils.dart';

import 'ox_userinfo_manager.dart';

enum SoundType { Message_Received, Message_Sent, Zap_Received, Zap_Sent }

class PromptToneManager {
  bool Function(MessageDBISAR msg)? isCurrencyChatPage;
  bool isAppPaused = false;

  static final PromptToneManager sharedInstance = PromptToneManager._internal();

  final AudioPlayer _player;
  final _throttle = ThrottleUtils(delay: Duration(milliseconds: 3000));

  PromptToneManager._internal() : _player = AudioPlayer();

  static AudioContext get _defaultAudioContext => AudioContextConfig(
        respectSilence: Platform.isIOS ? true : false,
        stayAwake: false,
        focus:
            Platform.isIOS ? AudioContextConfigFocus.gain : AudioContextConfigFocus.mixWithOthers,
      ).build();

  Future setup() async {
    await AudioPlayer.global.setAudioContext(_defaultAudioContext);
  }

  void playMessageReceived() async {
    _playSound(SoundType.Message_Received);
  }

  void playMessageSent() async {
    _playSound(SoundType.Message_Sent);
  }

  void playZapReceived() async {
    _playSound(SoundType.Zap_Received);
  }

  void playZapSent() async {
    _playSound(SoundType.Zap_Sent);
  }

  void _playSound(SoundType type) async {
    if (isAppPaused || !OXUserInfoManager.sharedInstance.canSound) return;
    _throttle(() async {
      String source = '';
      switch (type) {
        case SoundType.Message_Received:
          source = 'sounds/message-receive.mp3';
        case SoundType.Message_Sent:
          source = 'sounds/message-send.mp3';
        case SoundType.Zap_Received:
          source = 'sounds/zap-receive.mp3';
        case SoundType.Zap_Sent:
          source = 'sounds/zap-send.mp3';
      }
      if (_player.state != PlayerState.playing) {
        _player.setReleaseMode(ReleaseMode.release);
        await AudioPlayer.global.setAudioContext(_defaultAudioContext);
        _player.play(
          AssetSource(source),
          ctx: _defaultAudioContext,
        );
      }
    });
  }

  void playCalling() async {
    _player.stop();
    // final audioContext = AudioContextConfig(
    //   forceSpeaker: false,
    //   duckAudio: true,
    //   respectSilence: false,
    //   stayAwake: false,
    // ).build();
    _player.setReleaseMode(ReleaseMode.loop);
    // There is no need to set AudioContext because WebRTC has its own playback type control
    // await AudioPlayer.global.setGlobalAudioContext(audioContext);
    _player.play(
      AssetSource('sounds/calling.mp3'),
    );
  }

  void stopPlay() async {
    _player.stop();
  }
}
