import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:flutter/services.dart';
import 'package:ox_discovery/page/moments/visibility_selection_page.dart';

import '../../enum/moment_enum.dart';
import '../../utils/moment_widgets_utils.dart';
import '../widgets/Intelligent_input_box_widget.dart';
import '../widgets/horizontal_scroll_widget.dart';
import '../widgets/nine_palace_grid_picture_widget.dart';

class CreateMomentsPage extends StatefulWidget {
  final EMomentType type;
  final List<String>? imageList;
  final String? videoPath;
  final String? videoImagePath;
  const CreateMomentsPage({Key? key, required this.type, this.imageList,this.videoPath,this.videoImagePath})
      : super(key: key);

  @override
  State<CreateMomentsPage> createState() => _CreateMomentsPageState();
}

class _CreateMomentsPageState extends State<CreateMomentsPage> {
  File? _placeholderImage;

  List<String> addImageList = [];

  bool _isInputFocused = false;

  final TextEditingController _textController = TextEditingController();

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
    if (widget.type != EMomentType.picture) return const SizedBox();
    return NinePalaceGridPictureWidget(
      isEdit: true,
      imageList: _getImageList(),
      addImageCallback: (List<String> newImageList) {
        addImageList = [...addImageList, ...newImageList];
        setState(() {});
      },
    );
  }

  Widget _videoWidget() {
    if (widget.type != EMomentType.video) return const SizedBox();
    return MomentWidgetsUtils.videoMoment(context,widget.videoPath ?? '',widget.videoImagePath ?? '');
  }

  Widget _quoteWidget() {
    if (widget.type != EMomentType.quote) return const SizedBox();
    return HorizontalScrollWidget(content: '',);
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
              textController: _textController,
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

  void _visibleToUser() {
    OXNavigator.presentPage(
        context, (context) => const VisibilitySelectionPage());
  }

  void _postMoment() {
    OXNavigator.pop(context);
  }

  List<String> _getImageList() {
    List<String> containsImageList = [
      ...widget.imageList ?? [],
      ...addImageList
    ];
    return containsImageList;
  }
}
