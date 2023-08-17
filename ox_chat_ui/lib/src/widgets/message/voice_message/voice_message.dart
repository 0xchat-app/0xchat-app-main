import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:just_audio/just_audio.dart' as jsAudio;
import 'package:ox_common/utils/adapt.dart';

import './noises.dart';
import 'contact_noises.dart';
import 'helpers/audio_player_singleton.dart';
import 'helpers/colors.dart';
import 'helpers/utils.dart';

/// This is the main widget.
// ignore: must_be_immutable
class VoiceMessage extends StatefulWidget {
  VoiceMessage({
    Key? key,
    required this.me,
    this.audioSrc,
    this.audioFile,
    this.duration,
    this.formatDuration,
    this.showDuration = false,
    this.waveForm,
    this.noiseCount = 27,
    this.meBgColor = AppColors.pink,
    this.contactBgColor = const Color(0xffffffff),
    this.contactFgColor = AppColors.pink,
    this.contactCircleColor = Colors.red,
    this.mePlayIconColor = Colors.black,
    this.contactPlayIconColor = Colors.black26,
    this.radius = 12,
    this.contactPlayIconBgColor = Colors.grey,
    this.meFgColor = const Color(0xffffffff),
    this.played = false,
    this.onPlay,
  }) : super(key: key);

  final String? audioSrc;
  Future<File>? audioFile;
  final Duration? duration;
  final bool showDuration;
  final List<double>? waveForm;
  final double radius;

  final int noiseCount;
  final Color meBgColor,
      meFgColor,
      contactBgColor,
      contactFgColor,
      contactCircleColor,
      mePlayIconColor,
      contactPlayIconColor,
      contactPlayIconBgColor;
  final bool played, me;
  Function()? onPlay;
  String Function(Duration duration)? formatDuration;

  @override
  // ignore: library_private_types_in_public_api
  _VoiceMessageState createState() => _VoiceMessageState();
}

class _VoiceMessageState extends State<VoiceMessage>
    with TickerProviderStateMixin {
  late StreamSubscription stream;

  String Function(Duration duration)? formatDuration;

  final AudioPlayerSingleton audioPlayerSingleton = AudioPlayerSingleton();
  late AudioPlayer _player = audioPlayerSingleton.audioPlayer;

  final double maxNoiseHeight = 6.w(), noiseWidth = 28.5.w();
  Duration? _audioDuration;
  bool _isPlaying = false, x2 = false, _audioConfigurationDone = false;
  String _remainingTime = '';
  AnimationController? _controller;
  String? _playUrl;

  @override
  void initState() {
    formatDuration = widget.formatDuration ?? (Duration? duration) => duration?.toString().substring(2, 7) ?? '00:00';
    _player = audioPlayerSingleton.audioPlayer;
    _remainingTime = formatDuration!(Duration());
    getPlayUri();
    super.initState();
    stream = _player.onPlayerStateChanged.listen((event) {
      switch (event) {
        case PlayerState.stopped:
          break;
        case PlayerState.playing:
          final currentPlayingUrl = audioPlayerSingleton.getCurrentPlayingUrl();
          if(currentPlayingUrl == _playUrl) {//Used to determine if the current item is being played
            _controller?.forward();
            if(mounted){
              setState(() => _isPlaying = true);
            }

          }else{
            _controller?.reset();
            if(mounted){
              setState(() => _isPlaying = false);
            }
          }
          break;
        case PlayerState.paused:
          if(mounted){
            setState(() => _isPlaying = false);
          }
          break;
        case PlayerState.completed:
          _player.seek(Duration.zero);
          if(mounted){
            setState(() {
              if(formatDuration != null) {
                _remainingTime = formatDuration!(_audioDuration!);
              }
            });
          }
          break;
        default:
          break;
      }
    });

    _player.onPositionChanged.listen((Duration p){
      if(_isPlaying){
        if(mounted){
          setState(() {
            _remainingTime = formatDuration!(p);
          });
        }

      }else{
        if(mounted){
          setState(() {
            _remainingTime = formatDuration!(_audioDuration!);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) => _sizerChild(context);

  Container _sizerChild(BuildContext context) =>
      Container(
        padding: EdgeInsets.symmetric(horizontal: Adapt.px(10), vertical: Adapt.px(12)),
        constraints: BoxConstraints(maxWidth: 100.w()),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: widget.me ?
            Radius.circular(widget.radius)
                : Radius.circular(0),
            bottomLeft: widget.me
                ? Radius.circular(widget.radius)
                : const Radius.circular(4),
            bottomRight: !widget.me
                ? Radius.circular(widget.radius)
                : const Radius.circular(4),
            topRight: Radius.circular(0),
          ),
          color: widget.me ? widget.meBgColor : widget.contactBgColor,
        ),
        child: _buildContentView(),
      );

  Widget _buildContentView() {
    if (_audioDuration == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35.0),
        child: CupertinoActivityIndicator(),
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _playButton(context),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Adapt.px(10)),
            child: _buildProgressView(),
          ),
          // _durationWithNoise(context),
          _buildTimeView(),
        ],
      );
    }
  }

  Widget _playButton(BuildContext context) => InkWell(
        child: Container(
          child: InkWell(
            onTap: () =>
                !_audioConfigurationDone ? null : _changePlayingStatus(),
            child: _isPlaying ? _buildPauseIcon() : _buildPlayIcon(),
          ),
        ),
      );

  Widget _buildPlayIcon() =>
      Image.asset(
        'assets/images/chat_voice_play_icon.png',
        width: Adapt.px(32),
        height: Adapt.px(32),
        package: 'ox_chat_ui',
      );

  Widget _buildPauseIcon() =>
      Image.asset(
        'assets/images/chat_voice_pause_icon.png',
        width: Adapt.px(32),
        height: Adapt.px(32),
        package: 'ox_chat_ui',
      );

  Widget _buildProgressView() {

    final duration = _audioDuration;
    if (duration == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: CupertinoActivityIndicator(),
      );
    }

    final audioDuration = duration.inSeconds;
    final dotCount = _calculateDotCount(audioDuration);
    return SizedBox(
      height: Adapt.px(32),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: dotCount,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) =>
            Padding(
              padding: const EdgeInsets.all(2.5),
              child: AnimatedBuilder(
                animation: CurvedAnimation(parent: _controller!, curve: Curves.ease),
                builder: (context, child) {
                  final itemProgress = (index + 1) / dotCount;
                  var dotColor = Colors.white;
                  if (_controller?.status == AnimationStatus.forward) {
                    dotColor = itemProgress <= _controller!.value ? Colors.white
                        : Colors.white.withOpacity(0.2);
                  }
                  return Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: dotColor,
                    ),
                  );
                },
              ),
            ),
      ),
    );
  }

  int _calculateDotCount(int input) {
    final minCount = 4;
    final maxCount = 13;
    if (input < 1) return minCount;
    if (input > 60) return maxCount;
    final dotCount = (minCount + (maxCount - minCount) * log(input) / log(60)).floor();
    return dotCount;
    return max(min(dotCount, maxCount), minCount);
  }

  Widget _buildTimeView() => SizedBox(
    width: Adapt.px(40),
    child: Text(
      _remainingTime,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
  );

  Future _startPlaying() async {
    final playUrl = _playUrl;
    if (playUrl == null || _audioDuration == null) return;
    await audioPlayerSingleton.play(playUrl, (url) {
      if (url == playUrl) {
        _stopPlayingHandler();
      }
    });
    setState(() {
      _isPlaying = true;
    });

    await _controller?.forward();
  }

  Future getPlayUri() async {
    var uri = '';
    final audioFile = widget.audioFile;
    final audioSrc = widget.audioSrc;
    if (audioFile != null) {
      final path = (await audioFile).path;
      uri = path;
    } else if (audioSrc != null) {
      uri = audioSrc;
    }

    _playUrl = uri;

    _setDuration();
  }

  Future _pausePlaying() async {
    await _player.pause();
    _controller?.stop();
    setState(() {
      _isPlaying = false;
    });
  }

  Future _stopPlayingHandler() async {
    _controller?.reset();
    setState(() {
      _isPlaying = false;
    });
  }

  void _setDuration() async {
    final playUrl = _playUrl;
    if (widget.duration != null) {
      _audioDuration = widget.duration;
    } else if (playUrl != null && playUrl.isNotEmpty) {
      final player =  AudioPlayer();
      await player.setSource(UrlSource(playUrl));
      _audioDuration = await player.getDuration();
    }

    if (!this.mounted) return ;
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 1,
      duration: _audioDuration,
    );

    ///
    _controller?.addListener(() {
      if (_controller!.isCompleted) {
        _controller?.reset();
        _isPlaying = false;
        x2 = false;
        setState(() {});
      }
    });
    _setAnimationConfiguration(_audioDuration!);
  }

  void _setAnimationConfiguration(Duration audioDuration) async {
    setState(() {
      _remainingTime = formatDuration!(audioDuration);
    });
    _completeAnimationConfiguration();
  }

  void _completeAnimationConfiguration() =>
      setState(() => _audioConfigurationDone = true);

  // void _toggle2x() {
  //   x2 = !x2;
  //   _controller?.duration = Duration(seconds: x2 ? duration ~/ 2 : duration);
  //   if (_controller?.isAnimating) _controller?.forward();
  //   _player.setPlaybackRate(x2 ? 2 : 1);
  //   setState(() {});
  // }

  // void _changePlayingStatus() async {
  //   if (widget.onPlay != null) widget.onPlay!();
  //   _isPlaying ? _pausePlaying() : _startPlaying();
  //   setState(() => _isPlaying = !_isPlaying);
  // }

  void _changePlayingStatus() async {
    if (widget.onPlay != null) widget.onPlay!();

    if (_isPlaying) {
      await _pausePlaying();
    } else {
      await _startPlaying();
    }
  }

  @override
  void dispose() {
    stream.cancel();
    _player.dispose();
    _controller?.dispose();
    super.dispose();
  }
}

///
class CustomTrackShape extends RoundedRectSliderTrackShape {
  ///
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    const trackHeight = 10.0;
    final trackLeft = offset.dx,
        trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
