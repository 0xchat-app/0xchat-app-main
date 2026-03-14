import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';

import 'helpers/audio_player_singleton.dart';
import 'helpers/colors.dart';
import 'helpers/utils.dart';

/// This is the main widget.
// ignore: must_be_immutable
class VoiceMessage extends StatefulWidget {
  VoiceMessage({
    super.key,
    required this.me,
    this.audioFile,
    this.duration,
    String Function(Duration duration)? formatDuration,
    this.meBgColor = AppColors.pink,
    this.contactBgColor = const Color(0xffffffff),
    this.onPlay,
  }) : this.formatDuration = formatDuration ?? ((Duration? duration) => duration?.toString().substring(2, 7) ?? '00:00');

  final File? audioFile;
  final Duration? duration;

  final Color meBgColor, contactBgColor;
  final bool me;
  Function()? onPlay;
  String Function(Duration duration) formatDuration;

  @override
  // ignore: library_private_types_in_public_api
  _VoiceMessageState createState() => _VoiceMessageState();
}

class _VoiceMessageState extends State<VoiceMessage> {
  List<StreamSubscription> subscriptions = [];

  final AudioPlayerSingleton audioPlayerSingleton = AudioPlayerSingleton();
  late AudioPlayer _player = audioPlayerSingleton.audioPlayer;

  final double radius = 12;
  PlayerState state = PlayerState.completed;
  String _remainingTime = '';
  /// Progress 0.0..1.0 driven by playback position (works with speed and seek).
  double _progress = 0.0;
  /// Playback speed: 1.0, 1.5, or 2.0.
  double _playbackSpeed = 1.0;
  static const List<double> _speedOptions = [1.0, 1.5, 2.0];
  String? get _playUrl => widget.audioFile?.path;

  Color? themeColor;

  @override
  void initState() {
    themeColor = widget.me ? ThemeColor.white : ThemeColor.color0;
    _player = audioPlayerSingleton.audioPlayer;
    super.initState();

    setAudioInfo();
    setupStream();
  }

  @override
  void didUpdateWidget(covariant VoiceMessage oldWidget) {
    super.didUpdateWidget(oldWidget);
    setAudioInfo();
  }

  void setupStream() {
    final stateChangedSubscription = _player.onPlayerStateChanged.listen((event) {
      if (!mounted) return ;

      if (event == PlayerState.completed) {
        setState(() {
          state = event;
          _progress = 1.0;
        });
        setAudioUIToDefault(atEnd: true);
        return ;
      }

      final isCurrentPlayingUrl = audioPlayerSingleton.getCurrentPlayingUrl() == _playUrl;
      if (!isCurrentPlayingUrl) {
        if (state != PlayerState.completed) {
          setAudioUIToDefault(atEnd: false);
        }
        return ;
      }

      setState(() { state = event; });

      switch (event) {
        case PlayerState.playing:
          _startPlayingHandler();
          break;
        case PlayerState.paused:
          _pausePlayingHandler();
          break;
        default:
          break;
      }
    });

    final positionChangedSubscription = _player.onPositionChanged.listen((Duration p) {
      if (!mounted) return ;
      final duration = widget.duration;
      if (duration == null) return ;
      final isCurrent = audioPlayerSingleton.getCurrentPlayingUrl() == _playUrl;
      if (!isCurrent) return ;
      final progress = duration.inMilliseconds > 0
          ? (p.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0)
          : 0.0;
      setState(() {
        _progress = progress;
        _remainingTime = widget.formatDuration(p);
      });
    });

    subscriptions.add(stateChangedSubscription);
    subscriptions.add(positionChangedSubscription);
  }

  void setAudioUIToDefault({bool atEnd = false}) {
    if (mounted) {
      final duration = widget.duration;
      if (duration == null) return ;
      setState(() {
        state = PlayerState.completed;
        _progress = atEnd ? 1.0 : 0.0;
        _remainingTime = widget.formatDuration(duration);
      });
    }
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
            Radius.circular(radius)
                : Radius.circular(0),
            bottomLeft: widget.me
                ? Radius.circular(radius)
                : const Radius.circular(4),
            bottomRight: !widget.me
                ? Radius.circular(radius)
                : const Radius.circular(4),
            topRight: Radius.circular(0),
          ),
          color: widget.me ? widget.meBgColor : widget.contactBgColor,
        ),
        child: _buildContentView(),
      );

  Widget _buildContentView() {
    if (widget.duration == null) {
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
          _buildSpeedButton(),
          _buildTimeView(),
        ],
      );
    }
  }

  Widget _playButton(BuildContext context) => InkWell(
        child: Container(
          child: InkWell(
            onTap: _changePlayingStatus,
            child: state == PlayerState.playing ? _buildPauseIcon() : _buildPlayIcon(),
          ),
        ),
      );

  Widget _buildPlayIcon() =>
      CommonImage(
        size: Adapt.px(32),
        iconName: 'chat_voice_play_icon.png',
        package: 'ox_chat_ui',
        color: themeColor,
        useTheme: false,
      );

  Widget _buildPauseIcon() =>
      CommonImage(
        size: Adapt.px(32),
        iconName: 'chat_voice_pause_icon.png',
        package: 'ox_chat_ui',
        color: themeColor,
        useTheme: false,
      );

  Widget _buildProgressView() {
    final duration = widget.duration;
    if (duration == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: CupertinoActivityIndicator(),
      );
    }

    final audioDuration = duration.inSeconds;
    final dotCount = _calculateDotCount(audioDuration);
    final durationMs = duration.inMilliseconds;
    // Approximate width of the dot row for seek calculation (each dot 6 + padding 2.5*2).
    const double dotWidth = 6.0 + 2.5 * 2;
    final double trackWidth = dotCount * dotWidth;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) => _seekToPosition(details.localPosition.dx, trackWidth, durationMs),
      onHorizontalDragUpdate: (details) {
        if (trackWidth <= 0) return;
        final dx = details.localPosition.dx;
        setState(() => _progress = (dx / trackWidth).clamp(0.0, 1.0));
      },
      onHorizontalDragEnd: (details) {
        if (audioPlayerSingleton.getCurrentPlayingUrl() != _playUrl) return;
        final positionMs = (_progress * durationMs).round();
        _player.seek(Duration(milliseconds: positionMs));
      },
      child: SizedBox(
        height: Adapt.px(32),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: dotCount,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final itemProgress = (index + 1) / dotCount;
            final dotColor = itemProgress <= _progress
                ? (themeColor ?? Colors.white)
                : (themeColor ?? Colors.white).withOpacity(0.2);
            return Padding(
              padding: const EdgeInsets.all(2.5),
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dotColor,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _seekToPosition(double localDx, double width, int durationMs) {
    if (width <= 0 || durationMs <= 0) return;
    if (audioPlayerSingleton.getCurrentPlayingUrl() != _playUrl) return;
    final positionMs = (localDx / width).clamp(0.0, 1.0) * durationMs;
    _player.seek(Duration(milliseconds: positionMs.round()));
  }

  int _calculateDotCount(int input) {
    final minCount = 4;
    final maxCount = 13;
    if (input < 1) return minCount;
    if (input > 60) return maxCount;
    final dotCount = (minCount + (maxCount - minCount) * log(input) / log(60)).floor();
    return dotCount;
  }

  Widget _buildTimeView() => SizedBox(
    width: Adapt.px(40),
    child: Text(
      _remainingTime,
      style: TextStyle(
        color: themeColor,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
  );

  Widget _buildSpeedButton() {
    final label = _playbackSpeed == 1.0 ? '1x' : _playbackSpeed == 1.5 ? '1.5x' : '2x';
    return Padding(
      padding: EdgeInsets.only(right: Adapt.px(6)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _cyclePlaybackSpeed,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Text(
              label,
              style: TextStyle(
                color: themeColor,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _startPlaying() async {
    final playUrl = _playUrl;
    if (playUrl == null || widget.duration == null) return;
    if (audioPlayerSingleton.getCurrentPlayingUrl() == playUrl &&
        _player.state == PlayerState.paused) {
      await _player.resume();
      await _player.setPlaybackRate(_playbackSpeed);
      return;
    }
    final error = await audioPlayerSingleton.play(playUrl, (url) {
      if (url == playUrl) {
        _stopPlayingHandler();
      }
    });
    if (error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Audio playback failed: $error'),
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }
    if (audioPlayerSingleton.getCurrentPlayingUrl() == playUrl) {
      await _player.setPlaybackRate(_playbackSpeed);
    }
  }

  void _cyclePlaybackSpeed() {
    final idx = _speedOptions.indexOf(_playbackSpeed);
    final nextIdx = (idx + 1) % _speedOptions.length;
    setState(() => _playbackSpeed = _speedOptions[nextIdx]);
    if (audioPlayerSingleton.getCurrentPlayingUrl() == _playUrl) {
      _player.setPlaybackRate(_playbackSpeed);
    }
  }

  void setAudioInfo() {
    final duration = widget.duration;
    _remainingTime = widget.formatDuration(duration ?? Duration());
  }

  void _startPlayingHandler() {}

  void _pausePlayingHandler() {}

  void _stopPlayingHandler() {}

  void _changePlayingStatus() async {
    if (widget.onPlay != null) widget.onPlay!();

    if (state == PlayerState.playing) {
      await _player.pause();
    } else {
      await _startPlaying();
    }
  }

  @override
  void dispose() {
    subscriptions.forEach((e) { e.cancel(); });
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
