import 'dart:ui';
import 'dart:io';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/uplod_aliyun_utils.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:flutter/services.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_discovery/enum/visible_type.dart';
import 'package:ox_discovery/page/moments/visibility_selection_page.dart';
import 'package:ox_localizable/ox_localizable.dart';

import '../../enum/moment_enum.dart';
import '../../utils/album_utils.dart';
import '../../utils/moment_content_analyze_utils.dart';
import '../../utils/moment_widgets_utils.dart';
import '../widgets/Intelligent_input_box_widget.dart';
import '../widgets/horizontal_scroll_widget.dart';
import '../widgets/nine_palace_grid_picture_widget.dart';

import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';

class CreateMomentsPage extends StatefulWidget {
  final EMomentType type;
  final List<String>? imageList;
  final String? videoPath;
  final String? videoImagePath;
  final NoteDB? noteDB;
  const CreateMomentsPage(
      {Key? key,
      required this.type,
      this.imageList,
      this.videoPath,
      this.videoImagePath,
      this.noteDB})
      : super(key: key);

  @override
  State<CreateMomentsPage> createState() => _CreateMomentsPageState();
}

class _CreateMomentsPageState extends State<CreateMomentsPage> {

  Map<String,UserDB> draftCueUserMap = {};

  List<String> addImageList = [];

  bool _isInputFocused = false;

  final TextEditingController _textController = TextEditingController();

  VisibleType _visibleType = VisibleType.everyone;
  List<UserDB>? _selectedContacts;

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
        FocusScope.of(context).requestFocus(FocusNode());
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
    return MomentWidgetsUtils.videoMoment(
        context, widget.videoPath ?? '', widget.videoImagePath ?? '');
  }

  Widget _quoteWidget() {
    NoteDB? noteDB = widget.noteDB;
    if (widget.type != EMomentType.quote || noteDB == null) return const SizedBox();
    return HorizontalScrollWidget(noteDB: noteDB);
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
              cueUserCallback: (UserDB user){
                String? getName = user.name;
                if(getName != null){
                  draftCueUserMap['@${getName}'] = user;
                  setState(() {});
                }
              },
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
    if(widget.type == EMomentType.quote) return const SizedBox();
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
                    _visibleType.name,
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
      context,
      (context) => VisibilitySelectionPage(
        visibleType: _visibleType,
        selectedContacts: _selectedContacts,
        onSubmitted: (type,items){
          setState(() {
            _visibleType = type;
            _selectedContacts = items;
          });
        },
      ),
    );
  }

  void _postMoment() async {
    await OXLoading.show();
    String getMediaStr = await _getUploadMediaContent();
    String content = '${_changeCueUserToPubkey()} $getMediaStr';
    OKEvent? event;

    NoteDB? noteDB = widget.noteDB;
    if(widget.type == EMomentType.quote && noteDB != null){
      event = await Moment.sharedInstance.sendQuoteRepost(noteDB.noteId,content);
    }else{
      switch (_visibleType) {
        case VisibleType.everyone:
          event = await Moment.sharedInstance.sendPublicNote(content);
          break;
        case VisibleType.allContact:
          event = await Moment.sharedInstance.sendNoteContacts(content);
          break;
        case VisibleType.private:
          event = await Moment.sharedInstance.sendNoteJustMe(content);
          break;
        case VisibleType.excludeContact:
          final pubkeys = _selectedContacts?.map((e) => e.pubKey).toList();
          event = await Moment.sharedInstance.sendNoteCloseFriends(pubkeys ?? [], content);
          break;
        default:
          break;
      }
    }

    await OXLoading.dismiss();
    if(event?.status ?? false){
      CommonToast.instance.show(context, Localized.text('ox_chat.sent_successfully'));
    }

    OXNavigator.pop(context);
  }

  String _changeCueUserToPubkey(){
    String content = _textController.text;
    draftCueUserMap.forEach((tag, replacement) {
      content = content.replaceAll(tag, replacement.encodedPubkey);
    });
    return content;
  }

  Future<String> _getUploadMediaContent() async {
    List<String> imageList = _getImageList();
    String? videoPath = widget.videoPath;
    if(imageList.isEmpty && videoPath == null) return '';

    if (imageList.isNotEmpty){
      List<String> imgUrlList = await AlbumUtils.uploadMultipleFiles(
        context,
        fileType: UplodAliyunType.imageType,
        filePathList: _getImageList(),
      );
      String getImageUrlToStr = imgUrlList.join(' ');
      return getImageUrlToStr;
    }

    if (videoPath != null){
      List<String> imgUrlList = await AlbumUtils.uploadMultipleFiles(
        context,
        fileType: UplodAliyunType.videoType,
        filePathList: [videoPath],
      );
      String getVideoUrlToStr = imgUrlList.join(' ');
      return getVideoUrlToStr;
    }

    return '';
  }

  List<String> _getImageList() {
    List<String> containsImageList = [
      ...widget.imageList ?? [],
      ...addImageList
    ];
    return containsImageList;
  }
}
