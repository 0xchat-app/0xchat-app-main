import 'package:audioplayers/audioplayers.dart';

class PromptToneManager {
  static final PromptToneManager sharedInstance = PromptToneManager._internal();

  final AudioPlayer _player;

  PromptToneManager._internal() : _player = AudioPlayer();

  factory PromptToneManager() {
    return sharedInstance;
  }

  void play() async {
    String promptToneUrl = 'https://nostrfiles.dev/uploads/hXR21snKdEzeeF5SZK1t.mp3';
    await _player.play(UrlSource(promptToneUrl));
  }
}