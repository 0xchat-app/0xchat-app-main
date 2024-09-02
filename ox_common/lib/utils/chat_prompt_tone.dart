import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:chatcore/chat-core.dart';

class PromptToneManager {

  bool Function(MessageDBISAR msg)? isCurrencyChatPage;

  static final PromptToneManager sharedInstance = PromptToneManager._internal();

  final AudioPlayer _player;

  PromptToneManager._internal() : _player = AudioPlayer();

  static AudioContext get _defaultAudioContext => AudioContextConfig(
    respectSilence: Platform.isIOS ? true : false,
    stayAwake: false,
    focus: AudioContextConfigFocus.duckOthers
  ).build();

  Future setup() async {
    await AudioPlayer.global.setAudioContext(_defaultAudioContext);
  }

  void play() async {
    if (_player.state != PlayerState.playing) {
      _player.setReleaseMode(ReleaseMode.release);
      await AudioPlayer.global.setAudioContext(_defaultAudioContext);
      _player.play(
        AssetSource('sounds/message_notice_sound.mp3'),
        ctx: _defaultAudioContext,
      );
    }
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
      AssetSource('sounds/sound_calling_3d.mp3'),
    );
  }

  void stopPlay() async {
    _player.stop();
  }
}