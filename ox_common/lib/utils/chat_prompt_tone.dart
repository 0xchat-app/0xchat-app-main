import 'package:audioplayers/audioplayers.dart';
import 'package:chatcore/chat-core.dart';

class PromptToneManager {

  bool Function(MessageDB msg)? isCurrencyChatPage;

  static final PromptToneManager sharedInstance = PromptToneManager._internal();

  final AudioPlayer _player;

  PromptToneManager._internal() : _player = AudioPlayer();

  factory PromptToneManager() {
    return sharedInstance;
  }

  void play() async {
    if (_player.state != PlayerState.playing) {
      _player.play(AssetSource('sounds/message_notice_sound.mp3'));
    }
  }

  void playCalling() async {
    _player.stop();
    _player.setReleaseMode(ReleaseMode.loop);
    _player.play(AssetSource('sounds/sound_calling_3d.mp3'));
  }

  void stopPlay() async {
    if ( _player.state == PlayerState.playing) {
      _player.stop();
      _player.setReleaseMode(ReleaseMode.release);
    }
  }
}