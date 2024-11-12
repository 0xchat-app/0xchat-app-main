import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/throttle_utils.dart';
import 'package:ox_common/utils/user_config_tool.dart';

import 'ox_userinfo_manager.dart';

enum SoundType { Message_Received, Message_Sent, Zap_Received, Zap_Sent }

enum SoundTheme {
  classic(1, 'classic', 'Default'),
  ostrich(2, 'ostrich', 'Ostrich');

  final int id;
  final String name;
  final String symbol;

  const SoundTheme(this.id, this.name, this.symbol);
}

class PromptToneManager {
  bool Function(MessageDBISAR msg)? isCurrencyChatPage;
  bool isAppPaused = false;

  static final PromptToneManager sharedInstance = PromptToneManager._internal();

  final AudioPlayer _player;
  final _throttle = ThrottleUtils(delay: Duration(milliseconds: 3000));

  PromptToneManager._internal() : _player = AudioPlayer();

  SoundTheme _currentSoundTheme = SoundTheme.classic;

  SoundTheme get currentSoundTheme => _currentSoundTheme;

  set currentSoundTheme(SoundTheme theme) {
    _currentSoundTheme = theme;
  }

  static AudioContext get _defaultAudioContext => AudioContextConfig(
        respectSilence: Platform.isIOS ? true : false,
        stayAwake: false,
        focus:
            Platform.isIOS ? AudioContextConfigFocus.gain : AudioContextConfigFocus.mixWithOthers,
      ).build();

  Future setup() async {
    await AudioPlayer.global.setAudioContext(_defaultAudioContext);
  }

  initSoundTheme() {
    int index = UserConfigTool.getSetting(StorageSettingKey.KEY_SOUND_THEME.name, defaultValue: 0);
    currentSoundTheme = index == SoundTheme.classic.id
        ? SoundTheme.classic
        : SoundTheme.ostrich;
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
          source = 'sounds/${_currentSoundTheme.name}/message-receive.mp3';
        case SoundType.Message_Sent:
          source = 'sounds/${_currentSoundTheme.name}/message-send.mp3';
        case SoundType.Zap_Received:
          source = 'sounds/${_currentSoundTheme.name}/zap-receive.mp3';
        case SoundType.Zap_Sent:
          source = 'sounds/${_currentSoundTheme.name}/zap-send.mp3';
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
      AssetSource('sounds/${_currentSoundTheme.name}/calling.mp3'),
    );
  }

  void stopPlay() async {
    _player.stop();
  }
}
