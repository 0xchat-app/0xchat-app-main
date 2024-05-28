import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/mixin/common_ui_refresh_mixin.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerWidget extends StatefulWidget {
  final String videoUrl;

  const YoutubePlayerWidget({super.key, required this.videoUrl});

  @override
  _YoutubePlayerWidgetState createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  late YoutubePlayerController _youtubeController;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    String? videoId;
    videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
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
      child: _videoSurfaceDrawingWidget(),
    );
  }

  Widget _videoSurfaceDrawingWidget() {
    return YoutubePlayer(
      controller: _youtubeController,
      showVideoProgressIndicator: false,
      onReady: () {
        print('Player is ready.');
      },
    );
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }
}
