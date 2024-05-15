import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:video_player/video_player.dart';

class VideoMomentWidget extends StatefulWidget {
  final String videoUrl;

  const VideoMomentWidget({super.key, required this.videoUrl});

  @override
  _VideoMomentWidgetState createState() => _VideoMomentWidgetState();
}

class _VideoMomentWidgetState extends State<VideoMomentWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return videoMoment();
  }

  Widget videoMoment() {
    return Container(
      margin: EdgeInsets.only(
        bottom: 10.px,
      ),
      child: GestureDetector(
        onTap: () {
          OXModuleService.pushPage(context, 'ox_chat', 'ChatVideoPlayPage', {
            'videoUrl': widget.videoUrl,
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: ThemeColor.color100,
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    Adapt.px(12),
                  ),
                ),
              ),
              width: 210.px,
              // height: 154.px,
            ),
            _videoSurfaceDrawingWidget(),
            CommonImage(
              iconName: 'play_moment_icon.png',
              package: 'ox_discovery',
              size: 60.0.px,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }

  Widget _videoSurfaceDrawingWidget(){
    if(!_controller.value.isInitialized) return const SizedBox();
    return SizedBox(
      width: 210.px,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          15,
        ),
        child:  AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}