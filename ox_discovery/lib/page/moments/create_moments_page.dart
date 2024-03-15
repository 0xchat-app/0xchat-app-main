import 'dart:ui';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/image_picker_utils.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/model/channel_model.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_pull_refresher.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_compress/video_compress.dart';

import '../../utils/moment_widgets.dart';


class CreateMomentsPage extends StatefulWidget {
  const CreateMomentsPage({Key? key}) : super(key: key);

  @override
  State<CreateMomentsPage> createState() => _CreateMomentsPageState();
}

class _CreateMomentsPageState extends State<CreateMomentsPage> {
  File? _placeholderImage;


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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 24.px,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ninePalaceGridPictureWidget(),
              _videoWidget(),
              Container(
                child: _placeholderImage == null
                    ? SizedBox()
                    : Image.file(_placeholderImage!),
              ),
              _captionWidget(),
              _visibleContactsWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ninePalaceGridPictureWidget(){
    return  Container(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 9,
        itemBuilder: (context, index) {
          if(index == 8){
            return Container(
              width: 104.px,
              height: 104.px,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    Adapt.px(8.px),
                  ),
                ),
              ),
              child: CommonImage(
                iconName: "add_moment.png",
                size: 104.px,
                package: 'ox_discovery',
              ),
            );
          }
          return MomentWidgets.clipImage(
            imageName: 'moment_avatar.png',
            borderRadius: 8.px,
            imageSize: 104.px,
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 每行四项
          crossAxisSpacing: 10.px, // 水平间距
          mainAxisSpacing: 10.px, // 垂直间距
          childAspectRatio: 1, // 网格项的宽高比
        ),
      ),
    );
  }

  Widget _videoWidget() {
    return GestureDetector(
      onTap: () {
        _goToPhoto(context, 2);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 12.px,
        ),
        width: 210.px,
        height: 160.px,
        decoration: BoxDecoration(
          color: ThemeColor.color180,
          borderRadius: BorderRadius.all(
            Radius.circular(
              Adapt.px(16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _captionWidget() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
              bottom: 12.px,
            ),
            child: Text(
              'Caption',
              style: TextStyle(
                  fontSize: 14.px,
                  fontWeight: FontWeight.w600,
                  color: ThemeColor.color0),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.px,
            ),
            height: 134.px,
            decoration: BoxDecoration(
              color: ThemeColor.color180,
              borderRadius: BorderRadius.all(
                Radius.circular(
                  Adapt.px(12),
                ),
              ),
            ),
            child: const TextField(
              decoration: InputDecoration(
                border: InputBorder.none, // 去除下划线
                focusedBorder: InputBorder.none, // 获得焦点时的边框样式
                hintText: 'Add a caption...',
              ),
              keyboardType: TextInputType.multiline, // 设置键盘类型为多行文本
              maxLines: null, // 设置为null使文本框自动扩展行数以适应文本
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 12.px,
            ),
            decoration: BoxDecoration(
              color: ThemeColor.color180,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.px),
                topRight: Radius.circular(16.px),
              ),
            ),
            child: _captionToTopicListWidget(),
            // _captionToUserListWidget(),
          ),
        ],
      ),
    );
  }

  Widget _captionToUserListWidget() {
    return Column(
      children: [
        _captionToUserWidget(),
        _captionToUserWidget(),
        _captionToUserWidget(),
        _captionToUserWidget(),
        _captionToUserWidget(),
      ],
    );
  }

  Widget _captionToUserWidget() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ThemeColor.color160,
            width: 1.px,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 10.px,
        horizontal: 12.px,
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(
              right: 12.px,
            ),
            color: Colors.black,
            width: 24.px,
            height: 24.px,
          ),
          Container(
            child: Row(
              children: [
                Text(
                  '昵称',
                  style: TextStyle(
                    color: ThemeColor.color0,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.px,
                  ),
                ).setPaddingOnly(
                  right: 8.px,
                ),
                Text(
                  '0xchat@satosh.com',
                  style: TextStyle(
                    color: ThemeColor.color100,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.px,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _captionToTopicListWidget(){
    return Column(
      children: [
        _captionToTopicWidget(),
        _captionToTopicWidget(),
        _captionToTopicWidget(),
        _captionToTopicWidget(),
        _captionToTopicWidget(),
      ],
    );
  }


  Widget _captionToTopicWidget() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ThemeColor.color160,
            width: 1.px,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 10.px,
        horizontal: 16.px,
      ),
      child: Row(
        children: [
          Text(
            '#1232424',
            style: TextStyle(
              fontSize: 14.px,
              color: ThemeColor.color0,
              fontWeight: FontWeight.w600,
            ),
          ).setPaddingOnly(
            right: 8.px,
          ),
          Text(
            'Treding',
            style: TextStyle(
              fontSize: 14.px,
              color: ThemeColor.color100,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _visibleContactsWidget() {
    return Container(
      margin: EdgeInsets.only(
        top: 12.px,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
              bottom: 12.px,
            ),
            child: Text(
              'Visible to',
              style: TextStyle(
                  fontSize: 14.px,
                  fontWeight: FontWeight.w600,
                  color: ThemeColor.color0),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.px,
            ),
            height: 48.px,
            decoration: BoxDecoration(
              color: ThemeColor.color180,
              borderRadius: BorderRadius.all(
                Radius.circular(
                  Adapt.px(12),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'My Contacts',
                  style: TextStyle(
                    fontSize: 16.px,
                    color: ThemeColor.color0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                CommonImage(
                  iconName: 'moment_more_icon.png',
                  size: 24.px,
                  package: 'ox_discovery',
                ),
              ],
            ),
          ),
        ],
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
      setState(() {});
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
