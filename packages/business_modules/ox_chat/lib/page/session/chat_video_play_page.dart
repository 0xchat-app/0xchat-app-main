
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/user_config_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:ox_common/widgets/common_toast.dart';

class ChatVideoPlayPage extends StatefulWidget {
  final String videoUrl;
  const ChatVideoPlayPage({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<ChatVideoPlayPage> createState() => _ChatVideoPlayPageState();
}

class _ChatVideoPlayPageState extends State<ChatVideoPlayPage> {

  ChewieController? _chewieController;
  late VideoPlayerController _videoPlayerController;
  int? bufferDelay;
  double _volume = 1.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
          isClose: true,
          useLargeTitle : false,
      ),
      body: Stack(
        children: [
          Container(
            child: _chewieController != null &&
                _chewieController!
                    .videoPlayerController.value.isInitialized
                ? Chewie(
              controller: _chewieController!,
            ) : Container(),
          ),
          if (_chewieController != null &&
              _chewieController!.videoPlayerController.value.isInitialized)
            Positioned.directional(
              start: 16,
              textDirection: Directionality.of(context),
              bottom: 56,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8.px, vertical: 4.px),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _volume <= 0 ? Icons.volume_off : Icons.volume_up,
                      color: Colors.white,
                      size: 24.px,
                    ),
                    SizedBox(
                      width: 160.px,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.white,
                          inactiveTrackColor: Colors.white38,
                          thumbColor: Colors.white,
                        ),
                        child: Slider(
                          value: _volume,
                          onChanged: (v) {
                            setState(() => _volume = v);
                            _videoPlayerController.setVolume(v);
                            UserConfigTool.saveSetting(
                                StorageSettingKey.KEY_VIDEO_PLAYBACK_VOLUME.name,
                                v);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Positioned.directional(
            end: 16,
            textDirection: Directionality.of(context),
            bottom: 56,
            child: IconButton(
              icon: Icon(Icons.save_alt, color: Colors.white),
              onPressed: () async {
                if (RegExp(r'https?:\/\/').hasMatch(widget.videoUrl)) {
                  var appDocDir = await getTemporaryDirectory();
                  String savePath = appDocDir.path + "/temp.mp4";
                  await Dio().download(widget.videoUrl, savePath);
                  final result = await ImageGallerySaverPlus.saveFile(savePath);
                  if (result['isSuccess'] == true) {
                    CommonToast.instance.show(context, 'Save successful');
                  }
                } else {
                  final result =
                      await ImageGallerySaverPlus.saveFile(widget.videoUrl);
                  if (result['isSuccess'] == true) {
                    CommonToast.instance.show(context, 'Save successful');
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> initializePlayer() async {

    try {
      if (RegExp(r'https?:\/\/').hasMatch(widget.videoUrl)) {
        // If a network file, play directly
        _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
      } else {
        // If a local file, need to add the path before "file://"
        // await _player.play(DeviceFileSource('file://$uri'));
        File videoFile = File(widget.videoUrl);
        _videoPlayerController = VideoPlayerController.file(videoFile);
      }
      await Future.wait([
        _videoPlayerController.initialize(),
      ]);
      final volume = (UserConfigTool.getSetting(StorageSettingKey.KEY_VIDEO_PLAYBACK_VOLUME.name, defaultValue: 1.0) as num?)?.toDouble() ?? 1.0;
      _volume = volume.clamp(0.0, 1.0);
      await _videoPlayerController.setVolume(_volume);
      _createChewieController();
      setState(() {});
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      progressIndicatorDelay:
      bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
      additionalOptions: (context) {
        return <OptionItem>[
          OptionItem(
            iconData: Icons.live_tv_sharp,
            title: 'Toggle Video Src',
            onTap: (BuildContext ctx) async {
              await _videoPlayerController.pause();
            },
          ),
        ];
      },
      hideControlsTimer: const Duration(seconds: 1),
    );
  }
}
