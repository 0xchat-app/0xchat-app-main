import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ox_chat_ui/ox_chat_ui.dart' show InputFacePage;
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/upload/file_type.dart';
import 'package:ox_common/utils/uplod_aliyun_utils.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_discovery/page/widgets/reply_contact_widget.dart';
import 'package:ox_discovery/utils/discovery_utils.dart';
import 'package:ox_discovery/utils/moment_content_analyze_utils.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';

import '../../enum/moment_enum.dart';
import '../../model/moment_ui_model.dart';
import '../../utils/album_utils.dart';
import '../widgets/moment_rich_text_widget.dart';
import '../../utils/moment_widgets_utils.dart';
import '../widgets/Intelligent_input_box_widget.dart';
import 'package:chatcore/chat-core.dart';

import 'package:nostr_core_dart/nostr.dart';

class ReplyMomentsPage extends StatefulWidget {
  final ValueNotifier<NotedUIModel> notedUIModel;
  const ReplyMomentsPage({Key? key, required this.notedUIModel})
      : super(key: key);

  @override
  State<ReplyMomentsPage> createState() => _ReplyMomentsPageState();
}

class _ReplyMomentsPageState extends State<ReplyMomentsPage> {
  Map<String, UserDBISAR> draftCueUserMap = {};

  final TextEditingController _textController = TextEditingController();
  final List<String> _showImageList = [];


  List<String> get getImagePicList => widget.notedUIModel.value.getImageList;

  @override
  void initState() {
    super.initState();
    _getMomentUserInfo();
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  void _getMomentUserInfo()async {
    String pubKey = widget.notedUIModel.value.noteDB.author;
    await Account.sharedInstance.getUserInfo(pubKey);
    if(mounted){
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: ThemeColor.color200,
        appBar: CommonAppBar(
          isClose: true,
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
                    Localized.text('ox_discovery.post'),
                    style: TextStyle(
                      fontSize: 16.px,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
          title: Localized.text('ox_discovery.reply'),
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
                ReplyContactWidget(notedUIModel: widget.notedUIModel),
                IntelligentInputBoxWidget(
                  imageUrlList: _showImageList,
                  textController: _textController,
                  hintText: Localized.text('ox_discovery.post_reply'),
                  cueUserCallback: (List<UserDBISAR> userList){
                    if(userList.isEmpty) return;
                    for(UserDBISAR db in userList){
                      String? getName = db.name;
                      if(getName != null){
                        draftCueUserMap['@${getName}'] = db;
                        setState(() {});
                      }
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
    String pubKey = widget.notedUIModel.value.noteDB.author;
    return IntrinsicHeight(
      child: ValueListenableBuilder<UserDBISAR>(
        valueListenable: Account.sharedInstance.getUserNotifier(pubKey),
        builder: (context, value, child) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await OXModuleService.pushPage(
                          context, 'ox_chat', 'ContactUserInfoPage', {
                        'pubkey': pubKey,
                      });
                      setState(() {});
                    },
                    child: MomentWidgetsUtils.clipImage(
                      borderRadius: 40.px,
                      imageSize: 40.px,
                      child: OXCachedNetworkImage(
                        imageUrl: value.picture ?? '',
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            MomentWidgetsUtils.badgePlaceholderImage(),
                        errorWidget: (context, url, error) =>
                            MomentWidgetsUtils.badgePlaceholderImage(),
                        width: 40.px,
                        height: 40.px,
                      ),
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
              _momentUserInfoWidget(value),
            ],
          );
        },
      ),
    );
  }

  Widget _momentUserInfoWidget(UserDBISAR userDB) {
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
                    TextSpan(text: userDB.name ?? ''),
                    TextSpan(
                      text: ' ' +
                          DiscoveryUtils.getUserMomentInfo(
                              userDB, widget.notedUIModel.value.createAtStr)[0],
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
                text: widget.notedUIModel.value.noteDB.content,
                maxLines: null,
                textSize: 12.px,
              ),
            ],
          ),
        ),
        _showPicWidget(),
      ],
    ).setPaddingOnly(left: 8.px, bottom: 20.px);
  }

  Widget _showPicWidget() {
    if (getImagePicList.isEmpty) return const SizedBox();
    return MomentWidgetsUtils.clipImage(
      borderRadius: 8.px,
      imageSize: 60.px,
      child: OXCachedNetworkImage(
        imageUrl: getImagePicList[0],
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            MomentWidgetsUtils.badgePlaceholderImage(),
        errorWidget: (context, url, error) =>
            MomentWidgetsUtils.badgePlaceholderImage(),
        width: 60.px,
        height: 60.px,
      ),
    ).setPaddingOnly(left: 8.px);
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
                selectCount: 9,
                callback: (List<String> imageList) {
                  if(_showImageList.length + imageList.length > 9){
                    CommonToast.instance.show(context, Localized.text('ox_discovery.selected_image_tips'));
                    return;
                  }
                  _showImageList.addAll(imageList);
                  if (mounted) {
                    setState(() {});
                  }
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
          // GestureDetector(
          //   onTap: () {
          //     showModalBottomSheet(
          //       context: context,
          //       backgroundColor: Colors.transparent,
          //       builder: (context) => _buildEmojiDialog(),
          //     );
          //   },
          //   child: CommonImage(
          //     iconName: 'chat_emoti_icon.png',
          //     size: 24.px,
          //     package: 'ox_discovery',
          //   ),
          // ),
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
    if (_textController.text.isEmpty && _showImageList.isEmpty) {
      CommonToast.instance.show(context, Localized.text('ox_discovery.content_empty_tips'));
      return;
    }
    await OXLoading.show();
    final inputText = _textController.text;
    List<String>? getReplyUser = DiscoveryUtils.getMentionReplyUserList(draftCueUserMap, inputText);
    String getMediaStr = await _getUploadMediaContent();
    String content = '${DiscoveryUtils.changeAtUserToNpub(draftCueUserMap, inputText)} $getMediaStr';
    List<String> hashTags = MomentContentAnalyzeUtils(content).getMomentHashTagList;

    OKEvent event = await _sendNoteReply(content:content,hashTags:hashTags,getReplyUser:getReplyUser);

    await OXLoading.dismiss();

    if(event.status){
      OXNavigator.pop(context);
    }
  }

  Future<OKEvent> _sendNoteReply({
    required String content,
    required List<String> hashTags,
    List<String>? getReplyUser,
  })async{
    String groupId = widget.notedUIModel.value.noteDB.groupId;
    if(groupId.isEmpty){
      return await Moment.sharedInstance.sendReply(widget.notedUIModel.value.noteDB.noteId, content,hashTags:hashTags, mentions:getReplyUser);

    }else{
      List<String> previous = Nip29.getPrevious([[groupId]]);
      return await RelayGroup.sharedInstance.sendGroupNoteReply(widget.notedUIModel.value.noteDB.noteId, content,previous,hashTags:hashTags, mentions:getReplyUser);

    }
  }

  Future<String> _getUploadMediaContent() async {
    if (_showImageList.isNotEmpty) {
      List<String> imgUrlList = await AlbumUtils.uploadMultipleFiles(
        context,
        fileType: FileType.image,
        filePathList: _showImageList,
      );
      String getImageUrlToStr = imgUrlList.join(' ');
      return getImageUrlToStr;
    }

    return '';
  }
}
