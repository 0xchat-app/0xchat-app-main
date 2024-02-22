import 'dart:ui';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/image_picker_utils.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/model/channel_model.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_pull_refresher.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_compress/video_compress.dart';

class CreateMomentsPage extends StatefulWidget {
  const CreateMomentsPage({Key? key}) : super(key: key);

  @override
  State<CreateMomentsPage> createState() => _CreateMomentsPageState();
}

class _CreateMomentsPageState extends State<CreateMomentsPage> {
  final RefreshController _refreshController = RefreshController();
  File? _placeholderImage;

  List<ChannelModel?> _channelModelList = [];
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color200,
      appBar: CommonAppBar(
        backgroundColor: ThemeColor.color200,
        actions: [
          GestureDetector(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: Adapt.px(24)),
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: [
                      ThemeColor.gradientMainEnd,
                      ThemeColor.gradientMainStart,
                    ],
                  ).createShader(Offset.zero & bounds.size);
                },
                child: Text(
                  'Post',
                  style: TextStyle(
                    fontSize: 16.px,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            onTap: () {},
          ),
        ],
        title: 'New Moments',
      ),
      body: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 24.px,
          ),
          child: Column(
            children: [
              _videoWidget(),
              Container(
                child:_placeholderImage == null ? SizedBox() : Image.file(_placeholderImage!),
              ),
            ],
          ),
      ),
    );
  }

  Widget _videoWidget() {
    return GestureDetector(
      onTap: (){
        _goToPhoto(context,2);
      },
      child: Container(
        margin: EdgeInsets.only(
          top: 12.px,
        ),
        width: 210.px,
        height: 160.px,
        decoration: BoxDecoration(
          color: ThemeColor.red,
          borderRadius: BorderRadius.all(
            Radius.circular(
              Adapt.px(16),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _goToPhoto(BuildContext context, int type) async {
    // type: 1 - image, 2 - video
    final isVideo = type == 2;
    final messageSendHandler = this.sendVideoMessageSend;

    final res = await ImagePickerUtils.pickerPaths(
      galleryMode: isVideo ? GalleryMode.video : GalleryMode.image,
      selectCount: 1,
      showGif: false,
      compressSize: 1024,
    );

    List<File> fileList = [];
    await Future.forEach(res, (element) async {
      final entity = element;
      final file = File(entity.path ?? '');
      fileList.add(file);
    });

    messageSendHandler(context, fileList);
  }

  Future sendVideoMessageSend(BuildContext context, List<File> images) async {
    for (final result in images) {
      // OXLoading.show();
      final bytes = await result.readAsBytes();
      final uint8list = await VideoCompress.getByteThumbnail(result.path,
          quality: 50, // default(100)
          position: -1 // default(-1)
      );
      final image = await decodeImageFromList(uint8list!);
      Directory directory = await getTemporaryDirectory();
      String thumbnailDirPath = '${directory.path}/thumbnails';
      await Directory(thumbnailDirPath).create(recursive: true);

      // Save the thumbnail to a file
      String thumbnailPath = '$thumbnailDirPath/thumbnail.jpg';
      File thumbnailFile = File(thumbnailPath);
      await thumbnailFile.writeAsBytes(uint8list);

      String message_id = const Uuid().v4();
      String fileName = '${message_id}${Path.basename(result.path)}';
      int tempCreateTime = DateTime.now().millisecondsSinceEpoch;

      _placeholderImage = thumbnailFile;
      setState(() {

      });
      // uri: thumbnailPath,
    //
    //   height: image.height.toDouble(),
    // metadata: {
    // "videoUrl": result.path.toString(),
    // },
    // uri: thumbnailPath,
    // width: image.width.toDouble(),
      // ChatVideoPlayPage
      // FileImage(File(uri));
    }
  }
}
