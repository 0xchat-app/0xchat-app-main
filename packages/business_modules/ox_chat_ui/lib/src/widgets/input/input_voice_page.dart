import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class InputVoicePage extends StatefulWidget {
  final Function(String path, Duration duration) onPressed;
  final VoidCallback onCancel;

  InputVoicePage({
    required this.onPressed,
    required this.onCancel,
  });

  @override
  _InputVoicePageState createState() => _InputVoicePageState();
}

class _InputVoicePageState extends State<InputVoicePage> with SingleTickerProviderStateMixin {
  /// Max voice recording duration: 3 minutes (180 seconds).
  static const int _maxVoiceDurationSeconds = 180;
  static const int _maxVoiceDurationMs = _maxVoiceDurationSeconds * 1000;

  bool _isLongPressing = false;
  bool _showCancelText = false;
  double _longPressDuration = 0.0;
  double durationInSeconds = 0.0;
  bool _hasEnded = false;
  String _path = '';

  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  final Record _recorder = Record();
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _maxVoiceDurationSeconds),
    );

    _progressAnimation = Tween(begin: 0.0, end: 1.0).animate(_progressController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && _isLongPressing) {
          widget.onPressed(_path, Duration(milliseconds: _longPressDuration.toInt()));
        }
      });
  }

  void _onLongPressStart(LongPressStartDetails details) async {
    setState(() {
      _isLongPressing = true;
    });
    _hasEnded = false;
    _progressController.reset();
    await _startRecorder();
    unawaited(_progressController.forward());
    _startTimer();
  }

  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final center = box.size.center(box.localToGlobal(Offset.zero));
    final distance = center.dy - details.globalPosition.dy;

    setState(() {
      if (distance > 30) {
        _showCancelText = true;
      } else if (distance < 10) {
        _showCancelText = false;
      }
    });
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    if (_hasEnded) return;

    _hasEnded = true;
    _stopRecorder();
    _progressController.stop();
    setState(() {
      _isLongPressing = false;
    });

    if (_showCancelText) {
      widget.onCancel();
      _longPressDuration = 0;
      _showCancelText = false;
      _progressController.reset();
      return;
    }

    if (_longPressDuration >= _maxVoiceDurationMs) {
      // max duration auto-ended — already fired via animation status listener
    } else if (_longPressDuration < 1000) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(child: Text('Press duration too short to send')),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      widget.onPressed(_path, Duration(milliseconds: _longPressDuration.toInt()));
    }

    _longPressDuration = 0;
    _showCancelText = false;
    _progressController.reset();
  }

  void _startTimer() {
    Future.delayed(Duration(milliseconds: 100)).then((_) {
      if (_isLongPressing) {
        setState(() {
          _longPressDuration += 100;
        });
        if (_longPressDuration >= _maxVoiceDurationMs) return;
        _startTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    durationInSeconds = (_longPressDuration / 1000);
    return Container(
      decoration: BoxDecoration(
        color: ThemeColor.color190,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          if (_showCancelText) Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text('Release to Cancel'),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              color: Colors.transparent,
              child: SizedBox(
                width: Adapt.px(366),
                height: Adapt.px(236),
                child: Image.asset(
                  'assets/images/recorder_bg_color.png',
                  package: 'ox_chat_ui',
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: Adapt.px(101),
              height: Adapt.px(101),
              child: CircularProgressIndicator(
                value: _progressAnimation.value,
                strokeWidth: Adapt.px(4.0),
                backgroundColor: ThemeColor.gradientMainStart.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(ThemeColor.gradientMainStart),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onLongPressStart: _onLongPressStart,
              onLongPressMoveUpdate: _onLongPressMoveUpdate,
              onLongPressEnd: _onLongPressEnd,
              child: Container(
                color: Colors.transparent,
                child: SizedBox(
                  width: Adapt.px(90),
                  height: Adapt.px(90),
                  child: Image.asset(
                    'assets/images/recorder_btn_active.png',
                    package: 'ox_chat_ui',
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(
                  top: 150.px,
                  left: 15.px,
                  right: 15.px,
                ),
                child: Text(
                  Localized.text('ox_chat_ui.record_hint').replaceAll(r'${durationInSeconds}', '${durationInSeconds}'),
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Start recording using the cross-platform [record] package.
  Future<void> _startRecorder() async {
    await _stopRecorder();
    try {
      final hasPermission = await _recorder.hasPermission();
      if (!hasPermission) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(child: Text('No recording permission, please apply in settings')),
              duration: Duration(seconds: 1),
            ),
          );
        }
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final time = DateTime.now().millisecondsSinceEpoch;

      // Use compressed AAC on mobile/macOS; WAV on Linux/Windows/Web for broadest compatibility.
      final useAac = !kIsWeb && (Platform.isAndroid || Platform.isIOS || Platform.isMacOS);
      final path = useAac ? '${tempDir.path}/$time.m4a' : '${tempDir.path}/$time.wav';
      _path = path;

      await _recorder.start(
        path: path,
        encoder: useAac ? AudioEncoder.aacLc : AudioEncoder.wav,
        bitRate: 128000,
        samplingRate: 44100,
        numChannels: 1,
      );
    } catch (err) {
      print('Start recording error: $err');
      setState(() {
        _path = '';
      });
    }
  }

  Future<void> _stopRecorder() async {
    try {
      if (await _recorder.isRecording()) {
        await _recorder.stop();
      }
    } catch (err) {
      print('Stop recorder error: $err');
    }
  }

  /// Start playback of a local or remote audio file.
  void startPlayer(String path, {Function(dynamic)? callBack}) async {
    try {
      await _player.stop();
      if (path.contains('http')) {
        await _player.play(UrlSource(path));
      } else {
        if (await File(path).exists()) {
          await _player.play(DeviceFileSource('file://$path'));
        }
      }
      _player.onPlayerComplete.listen((_) => callBack?.call(0));
      callBack?.call(1);
    } catch (err) {
      callBack?.call(0);
    }
  }

  void stopPlayer() async {
    try {
      await _player.stop();
    } catch (err) {}
  }

  @override
  void dispose() {
    _progressController.dispose();
    _recorder.dispose();
    _player.dispose();
    super.dispose();
  }
}
