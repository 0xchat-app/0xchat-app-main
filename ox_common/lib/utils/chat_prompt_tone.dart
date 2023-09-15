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
    await _player.play(AssetSource('sounds/message_notice_sound.mp3'));
  }
}