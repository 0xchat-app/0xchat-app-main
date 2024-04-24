import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
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

import 'package:nostr_core_dart/nostr.dart';

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

  UserDB? momentRepostedUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMomentUser();
    _getMomentRepostedUser();
  }

  @override
  Widget build(BuildContext context) {
    return _momentItemWidget();
  }

  void _getMomentUser()async {
    UserDB? user = await Account.sharedInstance.getUserInfo(widget.noteDB.author);
    momentUser = user;
    setState(() {});
  }

  void _getMomentRepostedUser()async {
    String? repostId = widget.noteDB.repostId;
    if(repostId == null) return;
    UserDB? user = await Account.sharedInstance.getUserInfo(repostId);
    momentRepostedUser = user;
    setState(() {});
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
            _momentRepostedTips(),
            _momentUserInfoWidget(),
            MomentRichTextWidget(
              clickBlankCallback: widget.clickMomentCallback,
              text: widget.noteDB.content,
            ).setPadding(EdgeInsets.symmetric(vertical: 12.px)),
            _showMomentMediaWidget(),
            _momentQuoteWidget(),
            _momentRepostedWidget(),
            // _momentTypeWidget(widget.type),
            // _momentReviewWidget(),
            MomentOptionWidget(
                noteDB:widget.noteDB
            ),
          ],
        ),
      ),
    );
  }

  Widget _momentRepostedTips(){
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
        Text(
          'asdf Reposted',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12.px,
            color: ThemeColor.color100,

          ),
        )
      ],
    ).setPaddingOnly(bottom: 4.px);
  }

  Widget _showMomentMediaWidget(){
    print('===widget.noteDB.content==${widget.noteDB.content}');
    MomentContentAnalyzeUtils info = MomentContentAnalyzeUtils(widget.noteDB.content);
    if(info.getMediaList(1).isNotEmpty){
      return NinePalaceGridPictureWidget(
        width: 248.px,
        imageList: info.getMediaList(1),
      ).setPadding(EdgeInsets.only(bottom: 12.px));
    }
    if(info.getMediaList(2).isNotEmpty){
      return MomentWidgetsUtils.videoMoment(context, info.getMediaList(2)[0], null);
    }
    if(info.getMomentExternalLink.isNotEmpty){
      return MomentUrlWidget(url: info.getMomentExternalLink[0]);
    }
    return const SizedBox();
  }

  Widget _momentQuoteWidget(){
    List<String>? getQuoteUrlList = MomentContentAnalyzeUtils(widget.noteDB.content).getQuoteUrlList;
    if(getQuoteUrlList.isEmpty) return const SizedBox();

    return HorizontalScrollWidget(quoteList: getQuoteUrlList,);
  }

  Widget _momentRepostedWidget(){
    String? repostId = widget.noteDB.repostId;
    if(repostId == null || repostId.isEmpty) return const SizedBox();

    return HorizontalScrollWidget(quoteList: [repostId],);
  }


  Widget _momentReviewWidget() {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColor.color190,
        borderRadius: BorderRadius.all(Radius.circular(8.px)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 6.px,
              horizontal: 8.px,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: ThemeColor.color200,
                  width: 0.5.px,
                ),
              ),
            ),
            child: Row(
              children: [
                CommonImage(
                  iconName: 'like_moment_icon.png',
                  size: 16.px,
                  package: 'ox_discovery',
                ).setPaddingOnly(right: 4.px),
                Text(
                  'Satoshi, ',
                  style: TextStyle(
                    color: ThemeColor.gradientMainStart,
                    fontSize: 11.px,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
          ...[1,2,3].map((int int) => _momentReviewItemWidget()),
        ],
      ),
    );
  }

  Widget _momentReviewItemWidget(){
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 6.px,
        horizontal: 8.px,
      ),
      child: Row(
        children: [
          Text(
            'Satoshi: ',
            style: TextStyle(
              color: ThemeColor.gradientMainStart,
              fontSize: 11.px,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'Thanks',
            style: TextStyle(
              color: ThemeColor.color0,
              fontSize: 11.px,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _momentUserInfoWidget() {
    if(!widget.isShowUserInfo ) return const SizedBox();
    String showTimeContent = widget.noteDB.createAtStr;
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
                      'pubkey': widget.noteDB.author,
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
}
