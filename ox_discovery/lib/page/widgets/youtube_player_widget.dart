// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:ox_common/utils/adapt.dart';
// import 'package:ox_common/utils/theme_color.dart';
// import 'package:ox_common/widgets/common_image.dart';
// import 'package:ox_module_service/ox_module_service.dart';
// import 'package:video_player/video_player.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
//
// class YoutubePlayerWidget extends StatefulWidget {
//   final String videoUrl;
//
//   const YoutubePlayerWidget({super.key, required this.videoUrl});
//
//   @override
//   _YoutubePlayerWidgetState createState() => _YoutubePlayerWidgetState();
// }
//
// class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
//   late YoutubePlayerController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     init();
//   }
//
//   void init(){
//     String? videoId;
//     videoId = YoutubePlayer.convertUrlToId("https://www.youtube.com/watch?v=BBAyRBTfsOU");
//     print(videoId); // BBAyRBTfsOU
//     _controller = YoutubePlayerController(
//       initialVideoId: videoId!,
//       flags: const YoutubePlayerFlags(
//         autoPlay: false,
//         mute: false,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return videoMoment();
//   }
//
//   Widget videoMoment() {
//     return Container(
//       margin: EdgeInsets.only(
//         bottom: 10.px,
//       ),
//       child: GestureDetector(
//         onTap: () {
//           OXModuleService.pushPage(context, 'ox_chat', 'ChatVideoPlayPage', {
//             'videoUrl': 'https://youtu.be/V6MoN8_TTII?si=rWeTDFOsjKEKGt8R',
//           });
//         },
//         child: Stack(
//           alignment: Alignment.center,
//           children: <Widget>[
//             Container(
//               decoration: BoxDecoration(
//                 color: ThemeColor.color100,
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(
//                     Adapt.px(12),
//                   ),
//                 ),
//               ),
//               width: 210.px,
//               // height: 154.px,
//             ),
//             _videoSurfaceDrawingWidget(),
//             CommonImage(
//               iconName: 'play_moment_icon.png',
//               package: 'ox_discovery',
//               size: 60.0.px,
//               color: Colors.white,
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _videoSurfaceDrawingWidget(){
//     return YoutubePlayer(
//       controller: _controller,
//       showVideoProgressIndicator: true,
//       onReady: () {
//         print('Player is ready.');
//       },
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }