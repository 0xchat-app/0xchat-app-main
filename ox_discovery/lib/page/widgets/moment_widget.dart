import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_discovery/model/moment_extension_model.dart';
import 'package:ox_module_service/ox_module_service.dart';
import '../../model/moment_option_model.dart';
import '../../utils/moment_content_analyze_utils.dart';
import 'moment_rich_text_widget.dart';
import '../../utils/moment_widgets_utils.dart';
import 'horizontal_scroll_widget.dart';
import 'moment_option_widget.dart';
import 'moment_url_widget.dart';
import 'nine_palace_grid_picture_widget.dart';


class MomentWidget extends StatefulWidget {
  final bool isShowUserInfo;
  final List<MomentOption>? momentOptionList;
  final GestureTapCallback? clickMomentCallback;
  final NoteDB noteDB;
  const MomentWidget({
    super.key,
    required this.noteDB,
    this.momentOptionList,
    this.clickMomentCallback,
    this.isShowUserInfo = true,
  });

  @override
  _MomentWidgetState createState() => _MomentWidgetState();
}

class _MomentWidgetState extends State<MomentWidget> {

  UserDB? momentUser;

  late NoteDB noteDB;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return _momentItemWidget();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.noteDB != oldWidget.noteDB) {
      _init();
    }
  }

  Widget _momentItemWidget() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => widget.clickMomentCallback?.call(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 12.px,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MomentRepostedTips(noteDB: widget.noteDB,),
            _momentUserInfoWidget(),
            MomentRichTextWidget(
              clickBlankCallback: widget.clickMomentCallback,
              text: noteDB.content,
            ).setPadding(EdgeInsets.symmetric(vertical: 12.px)),
            _showMomentMediaWidget(),
            _momentQuoteWidget(),
            MomentOptionWidget(
                noteDB:noteDB
            ),
          ],
        ),
      ),
    );
  }

  Widget _showMomentMediaWidget(){
    MomentContentAnalyzeUtils mediaAnalyzer = MomentContentAnalyzeUtils(noteDB.content);
    if(mediaAnalyzer.getMediaList(1).isNotEmpty){
      double width = MediaQuery.of(context).size.width * 0.64;
      return NinePalaceGridPictureWidget(
        crossAxisCount: _calculateColumnsForPictures(mediaAnalyzer),
        width: width.px,
        axisSpacing: 4,
        imageList: mediaAnalyzer.getMediaList(1),
      ).setPadding(EdgeInsets.only(bottom: 12.px));
    }
    if(mediaAnalyzer.getMediaList(2).isNotEmpty){
      return MomentWidgetsUtils.videoMoment(context, mediaAnalyzer.getMediaList(2)[0], null);
    }
    if(mediaAnalyzer.getMomentExternalLink.isNotEmpty){
      return MomentUrlWidget(url: mediaAnalyzer.getMomentExternalLink[0]);
    }
    return const SizedBox();
  }

  int _calculateColumnsForPictures(MomentContentAnalyzeUtils mediaAnalyzer){
    int picNum = mediaAnalyzer.getMediaList(1).length;
    if(picNum == 1)  return 1;
    if(picNum > 1 && picNum < 5) return 2;
    return 3;
  }

  Widget _momentQuoteWidget(){
    List<String>? getQuoteUrlList = MomentContentAnalyzeUtils(noteDB.content).getQuoteUrlList;
    String? quoteRepostId = noteDB.quoteRepostId;
    bool hasQuoteRepostId = quoteRepostId != null && quoteRepostId.isNotEmpty;
    if(getQuoteUrlList.isEmpty && !hasQuoteRepostId) return const SizedBox();
    NoteDB? note = hasQuoteRepostId ? noteDB : null;
    return HorizontalScrollWidget(quoteList: getQuoteUrlList, noteDB: note);
  }


  Widget _momentUserInfoWidget() {
    if(!widget.isShowUserInfo) return const SizedBox();
    String showTimeContent = noteDB.createAtStr;
    String? dnsStr = momentUser?.dns;
    if(dnsStr != null && dnsStr.isNotEmpty){
      showTimeContent = '$dnsStr · $showTimeContent';
    }

    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    OXModuleService.pushPage(
                        context, 'ox_chat', 'ContactUserInfoPage', {
                      'pubkey': noteDB.author,
                    });
                  },
                  child: MomentWidgetsUtils.clipImage(
                    borderRadius: 40.px,
                    imageSize: 40.px,
                    child: OXCachedNetworkImage(
                      imageUrl: momentUser?.picture ?? '',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => MomentWidgetsUtils.badgePlaceholderImage(),
                      errorWidget: (context, url, error) => MomentWidgetsUtils.badgePlaceholderImage(),
                      width: 40.px,
                      height: 40.px,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 10.px,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        momentUser?.name ?? '--',
                        style: TextStyle(
                          color: ThemeColor.color0,
                          fontSize: 14.px,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        showTimeContent,
                        style: TextStyle(
                          color: ThemeColor.color120,
                          fontSize: 12.px,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // CommonImage(
          //   iconName: 'more_moment_icon.png',
          //   size: 20.px,
          //   package: 'ox_discovery',
          // ),
        ],
      ),
    );
  }

  void _init() async {
    noteDB = widget.noteDB;
    setState(() {});
    String? repostId = widget.noteDB.repostId;
    if(repostId != null && repostId.isNotEmpty) _getRepostId(repostId);
  }

  void _getRepostId(String repostId) async{
    NoteDB? note = await Moment.sharedInstance.loadNoteWithNoteId(repostId);
    noteDB = note ?? noteDB;
    _getMomentUser(noteDB);
    setState(() {});
  }



  void _getMomentUser(NoteDB noteDB) async {
    UserDB? user = await Account.sharedInstance.getUserInfo(noteDB.author);
    momentUser = user;
    setState(() {});
  }

}


class MomentRepostedTips extends StatefulWidget {
  final NoteDB noteDB;
  const MomentRepostedTips({
    super.key,
    required this.noteDB,
  });

  @override
  _MomentRepostedTipsState createState() => _MomentRepostedTipsState();
}

class _MomentRepostedTipsState extends State<MomentRepostedTips> {

  UserDB? momentUserDB;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMomentUser();
  }


  void _getMomentUser() async {
    UserDB? user = await Account.sharedInstance.getUserInfo(widget.noteDB.author);
    momentUserDB = user;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String? repostId = widget.noteDB.repostId;
    if(repostId == null || repostId.isEmpty) return const SizedBox();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CommonImage(
          iconName: 'repost_moment_icon.png',
          size: 16.px,
          package: 'ox_discovery',
          color: ThemeColor.color100,
        ).setPaddingOnly(
          right: 8.px,
        ),
        GestureDetector(
          onTap: (){
            OXModuleService.pushPage(context, 'ox_chat', 'ContactUserInfoPage', {
              'pubkey': momentUserDB?.pubKey,
            });
          },
          child: Text(
            '${momentUserDB?.name ?? ''} ',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12.px,
              color: ThemeColor.color100,
            ),
          ),
        ),
        Text(
          'Reposted',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12.px,
            color: ThemeColor.color100,
          ),
        )
      ],
    ).setPaddingOnly(bottom: 4.px);
  }
}

