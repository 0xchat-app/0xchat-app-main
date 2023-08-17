import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_localizable/ox_localizable.dart';

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

class _InputVoicePageState extends State<InputVoicePage> with SingleTickerProviderStateMixin{
  bool _isLongPressing = false;
  bool _showCancelText = false;
  double _longPressDuration = 0.0;
  double durationInSeconds = 0.0;
  bool _hasEnded = false;
  String _path = '';


  late AnimationController _progressController;
  late Animation<double> _progressAnimation;


  FlutterSoundRecorder recorderModule = FlutterSoundRecorder();
  FlutterSoundPlayer playerModule = FlutterSoundPlayer();

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 60),
    );

    _progressAnimation = Tween(begin: 0.0, end: 1.0).animate(_progressController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && _isLongPressing) {
          print('_onLongPressEnd3 :${_path}');
          widget.onPressed(_path, Duration(milliseconds: _longPressDuration.toInt()));
        }
      });
    initAudio();
  }

  void _onLongPressStart(LongPressStartDetails details) {
    setState(() {
      _isLongPressing = true;
    });
    _hasEnded = false; // Reset flag bit
    _progressController.reset();
    _progressController.forward();
    // Triggers the slide up event callback
    // widget.onSlideUpToCancel();
    print('===> About to start recording 1');
    _startTimer();
    print('===> About to start recording 2');
    _startRecorder();
    print('===> About to start recording 3');
  }

  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    // Retrieve the RenderBox object of the LongPressIconButton component
    final box = context.findRenderObject() as RenderBox;

    // Retrieve the center point coordinates of the component
    final center = box.size.center(box.localToGlobal(Offset.zero));

    // Calculate the distance from the touch point to the center point of the component
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
    if (_hasEnded) {
      return; // If the _onLongPressEnd method has already been called, it will not be executed again
    }


    print('_onLongPressEnd1  :${_path}');
    _hasEnded = true;
    _stopRecorder();
    _progressController.stop();
    setState(() {
      _isLongPressing = false;

    });

    print('_longPressDuration ${_longPressDuration}');
    if (_showCancelText) {
      // Swipe up to cancel.
      widget.onCancel();
      _longPressDuration = 0;
      _showCancelText = false;
      // Restore the progress to 0.
      _progressController.reset();
      return;
    }
    if (_longPressDuration >= 60000) {
      // Automatically conclude the event
      // widget.onPressed();
    }
    // else if (details.globalPosition.dy < MediaQuery.of(context).size.height * 0.8) {
    //   // Release to cancel.
    //   widget.onCancel();
    // }
    else if (_longPressDuration < 1000) {
      // The long-press duration is too short to send the prompt
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text('Press duration too short to send'),
          ),
          duration: Duration(seconds: 1),
        ),
      );
    }
    else {
      print('_onLongPressEnd2 :${_path}');
      // Action performed when the long-press is concluded
      widget.onPressed(_path, Duration(milliseconds: _longPressDuration.toInt()));
    }

    _longPressDuration = 0;
    _showCancelText = false;
    // Restore the progress to 0.
    _progressController.reset();
  }

  void _startTimer() {
    Future.delayed(Duration(milliseconds: 100)).then((_) {
      if (_isLongPressing) {
        setState(() {
          _longPressDuration += 100;
        });
        if (_longPressDuration >= 60000) {//Up to 60 seconds
          // Automatic event termination
          // widget.onPressed();
          return;
        }
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
      child: GestureDetector(
        onTap: (){},
        child: GestureDetector(
          onLongPressStart: _onLongPressStart,
          onLongPressMoveUpdate: _onLongPressMoveUpdate,
          onLongPressEnd: _onLongPressEnd,
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
              Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: Adapt.px(30)),
                    child: Text(
                      Localized.text('ox_chat_ui.record_hint').replaceAll(r'${durationInSeconds}', '${durationInSeconds}'),
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void initAudio() async {
    //Start recording
    await recorderModule.openRecorder();
    //Set up a subscription timer.
    await recorderModule
        .setSubscriptionDuration(const Duration(milliseconds: 10));

    //Configure the audio
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
      AVAudioSessionCategoryOptions.allowBluetooth |
      AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
      AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
    await playerModule.closePlayer();
    await playerModule.openPlayer();
    await playerModule
        .setSubscriptionDuration(const Duration(milliseconds: 10));
  }

  Future<bool> getPermissionStatus() async {
    final permission = Permission.microphone;
    //granted，denied，permanentlyDenied
    final status = await permission.status;
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      requestPermission(permission);
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    } else if (status.isRestricted) {
      requestPermission(permission);
    } else {}
    return false;
  }

  /// Request Permission
  void requestPermission(Permission permission) async {
    final status = await permission.request();
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  /// Start recording
  Future _startRecorder() async {
    print('===> About to start recording');
    await _stopRecorder();
    try {
      final status = await getPermissionStatus();
      if(status == false){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text('No recording permission, please apply in settings'),
            ),
            duration: Duration(seconds: 1),
          ),
        );
        return;
      }
      final tempDir = await getTemporaryDirectory();
      final time = DateTime.now().millisecondsSinceEpoch;
      final path = Platform.isAndroid ? '${tempDir.path}/$time.aac' : '${tempDir.path}/$time.wav';
      _path = path;
      print('===>  Preparing to start recording');
      await recorderModule.startRecorder(
          toFile: path,
          codec: Platform.isIOS ? Codec.pcm16WAV : Codec.aacADTS,
          bitRate: 1411200,
          sampleRate: 44100,
          audioSource: AudioSource.microphone);
      print('===>  Begin recording');

      /// Monitor the recording
      recorderModule.onProgress!.listen((e) {
        final date = new DateTime.fromMillisecondsSinceEpoch(
            e.duration.inMilliseconds,
            isUtc: true);

        if (date.second >= 60) {
          print('===>  Stop recording upon reaching the specified duration.');
          _stopRecorder();
        }
        // setState(() {
        //   print('time：${date.second}');
        //   print('Current amplitude：${e.decibels}');
        //   // num = date.second;
        //   setState(() {
        //     // if (e.decibels! > 0 && e.decibels! < 10) {
        //     //   voiceIco = 'Asset/message/icon_diyinliang.png';
        //     // } else if (e.decibels! > 20 && e.decibels! < 30) {
        //     //   voiceIco = 'Asset/message/icon_zhongyinliang.png';
        //     // } else if (e.decibels! > 30 && e.decibels! < 40) {
        //     //   voiceIco = 'Asset/message/icon_gaoyinliang.png';
        //     // } else if (e.decibels! > 40 && e.decibels! < 50) {
        //     //   voiceIco = 'Asset/message/icon_zhongyinliang.png';
        //     // } else if (e.decibels! > 50 && e.decibels! < 60) {
        //     //   voiceIco = 'Asset/message/icon_diyinliang.png';
        //     // } else if (e.decibels! > 70 && e.decibels! < 100) {
        //     //   voiceIco = 'Asset/message/icon_gaoyinliang.png';
        //     // } else {
        //     //   voiceIco = 'Asset/message/icon_diyinliang.png';
        //     // }
        //   });
        // });
      });

      this.setState(() {
        // _state = RecordPlayState.recording;

        print('path == $path');
      });
    } catch (err) {
      print('Preparing to start recording err.toString() : ${err.toString()}');
      setState(() {
        print(err.toString());
        _path = '';
        _stopRecorder();
        // _state = RecordPlayState.record;
      });
    }
  }

  /// End recording
  Future _stopRecorder() async {
    try {
      await recorderModule.stopRecorder();
      print('stopRecorder===> fliePath:$_path');
      // widget.stopRecord!(_path, num);
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }
  ///Start playback, and here a callback for the playback state is implemented
  void startPlayer(path, {Function(dynamic)? callBack}) async {
    try {
      if (path.contains('http')) {
        await playerModule.startPlayer(
            fromURI: path,
            codec: Codec.mp3,
            sampleRate: 44000,
            whenFinished: () {
              stopPlayer();
              callBack!(0);
            });
      } else {
        //Determine if the file exists
        if (await _fileExists(path)) {
          if (playerModule.isPlaying) {
            await playerModule.stopPlayer();
          }
          await playerModule.startPlayer(
              fromURI: path,
              codec: Codec.aacADTS,
              sampleRate: 44000,
              whenFinished: () {
                stopPlayer();
                callBack!(0);
              });
        } else {}
      }
      //Monitor playback progress
      playerModule.onProgress!.listen((e) {});
      callBack!(1);
    } catch (err) {
      callBack!(0);
    }
  }

  /// End playback
  void stopPlayer() async {
    try {
      await playerModule.stopPlayer();
    } catch (err) {}
  }

  /// Retrieve the playback status
  Future<PlayerState> getPlayState() async =>
      await playerModule.getPlayerState();

  /// Release the player
  void releaseFlauto() async {
    try {
      await playerModule.closePlayer();
    } catch (e) {
      print(e);
    }
  }

  /// Check if the file exists
  Future<bool> _fileExists(String path) async =>
      await File(path).exists();




  @override
  void dispose() {
    _progressController.dispose();
    recorderModule.closeRecorder();
    playerModule.closePlayer();
    super.dispose();
  }
}
