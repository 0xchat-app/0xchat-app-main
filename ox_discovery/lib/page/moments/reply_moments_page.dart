import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ox_chat_ui/ox_chat_ui.dart' show InputFacePage;
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/uplod_aliyun_utils.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_discovery/model/moment_extension_model.dart';
import 'package:ox_discovery/utils/moment_content_analyze_utils.dart';
import 'package:ox_module_service/ox_module_service.dart';

import '../../utils/album_utils.dart';
import '../widgets/moment_rich_text_widget.dart';
import '../../utils/moment_widgets_utils.dart';
import '../widgets/Intelligent_input_box_widget.dart';
import 'package:chatcore/chat-core.dart';

import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';


class ReplyMomentsPage extends StatefulWidget {

  final NoteDB noteDB;
  const ReplyMomentsPage(
      {Key? key, required this.noteDB})
      : super(key: key);

  @override
  State<ReplyMomentsPage> createState() =>
      _ReplyMomentsPageState();
}

class _ReplyMomentsPageState extends State<ReplyMomentsPage> {
  Map<String,UserDB> draftCueUserMap = {};

  final TextEditingController _textController = TextEditingController();

  String? _showImage;

  UserDB? momentUserDB;

  List<String> get getImagePicList => MomentContentAnalyzeUtils(widget.noteDB.content).getMediaList(1);

  @override
  void initState() {
    super.initState();
    _getMomentUser();
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  void _getMomentUser() async {
    UserDB? user =
        await Account.sharedInstance.getUserInfo(widget.noteDB.author);
    momentUserDB = user;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: ThemeColor.color200,
        appBar: CommonAppBar(
          backgroundColor: ThemeColor.color200,
          actions: [
            GestureDetector(
              onTap: _postMoment,
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
            ),
          ],
          title: 'Reply',
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 24.px,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // _momentItemWidget(),
                _momentReplyWidget(),
                _replyToWhoWidget(),
                IntelligentInputBoxWidget(
                  imageUrl: _showImage,
                  textController: _textController,
                  hintText: 'Post your reply',
                  cueUserCallback: (UserDB user){
                    String? getName = user.name;
                    if(getName != null){
                      draftCueUserMap['@$getName'] = user;
                      setState(() {});
                    }
                  },
                ).setPaddingOnly(top: 12.px),
                _mediaWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _momentReplyWidget() {
    if (momentUserDB == null) return const SizedBox();
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              MomentWidgetsUtils.clipImage(
                borderRadius: 40.px,
                imageSize: 40.px,
                child: OXCachedNetworkImage(
                  imageUrl: momentUserDB?.picture ?? '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      MomentWidgetsUtils.badgePlaceholderImage(),
                  errorWidget: (context, url, error) =>
                      MomentWidgetsUtils.badgePlaceholderImage(),
                  width: 40.px,
                  height: 40.px,
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 4.px,
                  ),
                  width: 1.0,
                  color: ThemeColor.color160,
                ),
              ),
            ],
          ),
          _momentUserInfoWidget(),
        ],
      ),
    );
  }

  Widget _momentUserInfoWidget() {
    String showTimeContent = widget.noteDB.createAtStr;
    String? dnsStr = momentUserDB?.dns;
    if (dnsStr != null && dnsStr.isNotEmpty) {
      showTimeContent = '$dnsStr · $showTimeContent';
    }
    double width = MediaQuery.of(context).size.width - 106;
    width = width - (getImagePicList.isEmpty ? 0 : 60);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: width.px,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                text: TextSpan(
                  style: TextStyle(
                    color: ThemeColor.color0,
                    fontSize: 14.px,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(text: momentUserDB?.name ?? ''),
                    TextSpan(
                      text: ' ' + showTimeContent,
                      style: TextStyle(
                        color: ThemeColor.color120,
                        fontSize: 12.px,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              MomentRichTextWidget(
                text: MomentContentAnalyzeUtils(widget.noteDB.content)
                    .getMomentShowContent,
                maxLines: 100,
                textSize: 12.px,
              ),
            ],
          ),
        ),
        _showPicWidget(),
      ],
    ).setPaddingOnly(left: 8.px,bottom: 20.px);
  }

  Widget _showPicWidget() {
    if(getImagePicList.isEmpty) return const SizedBox();
    return MomentWidgetsUtils.clipImage(
      borderRadius: 8.px,
      imageSize: 60.px,
      child: OXCachedNetworkImage(
        imageUrl: getImagePicList[0],
        fit: BoxFit.cover,
        placeholder: (context, url) => MomentWidgetsUtils.badgePlaceholderImage(),
        errorWidget: (context, url, error) => MomentWidgetsUtils.badgePlaceholderImage(),
        width: 60.px,
        height: 60.px,
      ),
    ).setPaddingOnly(left: 8.px);
  }

  Widget _replyToWhoWidget(){
    return RichText(
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      text: TextSpan(
        style: TextStyle(
          color: ThemeColor.color0,
          fontSize: 14.px,
          fontWeight: FontWeight.w400,
        ),
        children: [
          const TextSpan(text: 'Reply to'),
          TextSpan(
            text: ' @${momentUserDB?.name}',
            style: TextStyle(
              color: ThemeColor.purple2,
              fontSize: 12.px,
              fontWeight: FontWeight.w400,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                OXModuleService.pushPage(context, 'ox_chat', 'ContactUserInfoPage', {
                  'pubkey': momentUserDB?.pubKey,
                });
              },
          ),
        ],
      ),
    );
  }

  Widget _mediaWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.px),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              AlbumUtils.openAlbum(
                context,
                type: 1,
                selectCount: 1,
                callback: (List<String> imageList) {
                  _showImage = imageList[0];
                  setState(() {});
                },
              );
            },
            child: CommonImage(
              iconName: 'chat_image_icon.png',
              size: 24.px,
              package: 'ox_discovery',
            ),
          ),
          SizedBox(
            width: 12.px,
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => _buildEmojiDialog(),
              );
            },
            child: CommonImage(
              iconName: 'chat_emoti_icon.png',
              size: 24.px,
              package: 'ox_discovery',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiDialog() {
    return Container(
      padding: EdgeInsets.all(6.px),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(12)),
        color: ThemeColor.color190,
      ),
      child: SafeArea(
        child: SizedBox(
          height: 250.px,
          child: InputFacePage(
            textController: _textController,
          ),
        ),
      ),
    );
  }

  void _postMoment() async {
    if (_textController.text.isEmpty && _showImage == null) {
      CommonToast.instance.show(context, 'The content cannot be empty !');
      return;
    }
    await OXLoading.show();
    String getMediaStr = await _getUploadMediaContent();
    String content = '${_changeCueUserToPubkey()} $getMediaStr';
    OKEvent event = await Moment.sharedInstance.sendReply(widget.noteDB.noteId, content);
    await OXLoading.dismiss();

    if(event.status){
      OXNavigator.pop(context);
    }
  }



  Future<String> _getUploadMediaContent() async {
    String? imagePath = _showImage;
    if(imagePath == null) return '';
    List<String> imageList = [imagePath];

    if (imageList.isNotEmpty){
      List<String> imgUrlList = await AlbumUtils.uploadMultipleFiles(
        context,
        fileType: UplodAliyunType.imageType,
        filePathList: imageList,
      );
      String getImageUrlToStr = imgUrlList.join(' ');
      return getImageUrlToStr;
    }

    return '';
  }

  String _changeCueUserToPubkey(){
    String content = _textController.text;
    draftCueUserMap.forEach((tag, replacement) {
      content = content.replaceAll(tag, replacement.encodedPubkey);
    });
    return content;
  }
}
