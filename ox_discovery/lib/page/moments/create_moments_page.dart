import 'dart:ui';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/image_picker_utils.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:flutter/services.dart';
import 'package:ox_discovery/page/moments/visibility_selection_page.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';

import '../../enum/moment_enum.dart';
import '../../utils/moment_widgets.dart';
import '../widgets/Intelligent_input_box_widget.dart';
import '../widgets/horizontal_scroll_widget.dart';
import '../widgets/nine_palace_grid_picture_widget.dart';

class CreateMomentsPage extends StatefulWidget {
  final EMomentType type;

  CreateMomentsPage({Key? key, required this.type}) : super(key: key);

  @override
  State<CreateMomentsPage> createState() => _CreateMomentsPageState();
}

class _CreateMomentsPageState extends State<CreateMomentsPage> {
  File? _placeholderImage;

  bool _isInputFocused = false;

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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        decoration: BoxDecoration(
          color: ThemeColor.color190,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(Adapt.px(20)),
            topLeft: Radius.circular(Adapt.px(20)),
          ),
        ),
        child: SingleChildScrollView(
          reverse: _isInputFocused,
          child: Column(
            children: [
              _buildAppBar(),
              Container(
                padding: EdgeInsets.only(
                  left: 24.px,
                  right: 24.px,
                  bottom: 100.px,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _videoWidget(),

                    _pictureWidget(),
                    _quoteWidget(),
                    // Container(
                    //   child: _placeholderImage == null
                    //       ? SizedBox()
                    //       : Image.file(_placeholderImage!),
                    // ),
                    _captionWidget(),
                    _visibleContactsWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: Adapt.px(57),
      margin: EdgeInsets.only(bottom: Adapt.px(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: CommonImage(
              iconName: "icon_back_left_arrow.png",
              width: Adapt.px(24),
              height: Adapt.px(24),
              useTheme: true,
            ),
            onTap: () {
              OXNavigator.pop(context);
            },
          ),
          Text(
            'New Moments',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: Adapt.px(16),
                color: ThemeColor.color0),
          ),
          GestureDetector(
            onTap: _postMoment,
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
                  fontSize: Adapt.px(16),
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    ).setPadding(EdgeInsets.symmetric(
      horizontal: 24.px,
    ));
  }

  Widget _pictureWidget() {
    return widget.type != EMomentType.picture
        ? const SizedBox()
        : NinePalaceGridPictureWidget(isEdit:true);
  }

  Widget _videoWidget() {
    if (widget.type != EMomentType.video) return const SizedBox();
    return GestureDetector(
      onTap: () {
        _goToPhoto(context, 2);
      },
      child: MomentWidgets.videoMoment(),
    );
  }

  Widget _quoteWidget() {
    return widget.type != EMomentType.quote
        ? const SizedBox()
        : HorizontalScrollWidget();
  }

  Widget _captionWidget() {
    return Container(
      padding: EdgeInsets.only(
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
              'Caption',
              style: TextStyle(
                  fontSize: 14.px,
                  fontWeight: FontWeight.w600,
                  color: ThemeColor.color0),
            ),
          ),
          IntelligentInputBoxWidget(
              hintText: 'Add a caption...',
              isFocusedCallback: (bool isFocus) {
                setState(() {
                  _isInputFocused = isFocus;
                });
              }),
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
          GestureDetector(
            onTap: _visibleToUser,
            child: Container(
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

  void _visibleToUser() {
    OXNavigator.presentPage(
        context, (context) => const VisibilitySelectionPage());
  }

  void _postMoment() {
    OXNavigator.pop(context);
  }
}
