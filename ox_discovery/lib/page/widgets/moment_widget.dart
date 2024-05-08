import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_discovery/enum/moment_enum.dart';
import 'package:ox_discovery/page/widgets/reply_contact_widget.dart';
import 'package:ox_module_service/ox_module_service.dart';
import '../../model/moment_option_model.dart';
import '../../model/moment_ui_model.dart';
import '../../utils/discovery_utils.dart';
import 'moment_rich_text_widget.dart';
import '../../utils/moment_widgets_utils.dart';
import 'horizontal_scroll_widget.dart';
import 'moment_option_widget.dart';
import 'moment_url_widget.dart';
import 'nine_palace_grid_picture_widget.dart';

class MomentWidget extends StatefulWidget {
  final bool isShowUserInfo;
  final List<MomentOption>? momentOptionList;
  final Function(NotedUIModel notedUIModel)? clickMomentCallback;
  final NotedUIModel notedUIModel;
  const MomentWidget({
    super.key,
    required this.notedUIModel,
    this.momentOptionList,
    this.clickMomentCallback,
    this.isShowUserInfo = true,
  });

  @override
  _MomentWidgetState createState() => _MomentWidgetState();
}

class _MomentWidgetState extends State<MomentWidget> {
  UserDB? momentUser;

  NotedUIModel? notedUIModel;

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
    if (widget.notedUIModel != oldWidget.notedUIModel) {
      _init();
    }
  }

  Widget _momentItemWidget() {
    NotedUIModel? model = notedUIModel;
    if(model == null) return const SizedBox();
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => widget.clickMomentCallback?.call(model),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 12.px,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MomentRepostedTips(
              noteDB: widget.notedUIModel.noteDB,
            ),
            _momentUserInfoWidget(),
            _showReplyContactWidget(),
            _showMomentContent(),
            _showMomentMediaWidget(),
            _momentQuoteWidget(),
            MomentOptionWidget(notedUIModel: model),
          ],
        ),
      ),
    );
  }

  Widget _showMomentContent() {
    NotedUIModel? model = notedUIModel;
    if (model == null || model.getMomentShowContent.isEmpty) return const SizedBox();
    return MomentRichTextWidget(
      clickBlankCallback:() => widget.clickMomentCallback?.call(model),
      text: model.noteDB.content,
    ).setPadding(EdgeInsets.only(bottom: 12.px));
  }

  Widget _showMomentMediaWidget() {
    NotedUIModel? model = notedUIModel;
    if (model == null) return const SizedBox();

    List<String> getImageList = model.getImageList;
    if (getImageList.isNotEmpty) {
      double width = MediaQuery.of(context).size.width * 0.64;
      return NinePalaceGridPictureWidget(
        crossAxisCount: _calculateColumnsForPictures(getImageList.length),
        width: width.px,
        axisSpacing: 4,
        imageList: getImageList,
      ).setPadding(EdgeInsets.only(bottom: 12.px));
    }

    List<String> getVideoList = model.getVideoList;
    if (getVideoList.isNotEmpty) {
      return MomentWidgetsUtils.videoMoment(
          context, getVideoList[0], null);
    }

    List<String> getMomentExternalLink = model.getMomentExternalLink;
    if (getMomentExternalLink.isNotEmpty) {
      return MomentUrlWidget(url: getMomentExternalLink[0]);
    }
    return const SizedBox();
  }

  Widget _showReplyContactWidget() {
    return notedUIModel?.noteDB.getNoteKind() ==
        ENotificationsMomentType.reply.kind ? ReplyContactWidget(
        userDB: momentUser) : const SizedBox();
  }

  int _calculateColumnsForPictures(int picSize) {

    if (picSize == 1) return 1;
    if (picSize > 1 && picSize < 5) return 2;
    return 3;
  }

  Widget _momentQuoteWidget() {
    NotedUIModel? model = notedUIModel;
    if (model == null) return const SizedBox();

    String? quoteRepostId = model.noteDB.quoteRepostId;
    bool hasQuoteRepostId = quoteRepostId != null && quoteRepostId.isNotEmpty;
    if (model.getQuoteUrlList.isEmpty && !hasQuoteRepostId) return const SizedBox();
    NotedUIModel? note = hasQuoteRepostId ? NotedUIModel(noteDB: model.noteDB) : null;
    return HorizontalScrollWidget(quoteList: model.getQuoteUrlList, notedUIModel: note);
  }

  Widget _momentUserInfoWidget() {
    NotedUIModel? model = notedUIModel;
    if (model == null || !widget.isShowUserInfo) return const SizedBox();
    return Container(
      padding: EdgeInsets.only(bottom: 12.px),
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
                      'pubkey': model.noteDB.author,
                    });
                  },
                  child: MomentWidgetsUtils.clipImage(
                    borderRadius: 40.px,
                    imageSize: 40.px,
                    child: OXCachedNetworkImage(
                      imageUrl: momentUser?.picture ?? '',
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
                        DiscoveryUtils.getUserMomentInfo(
                            momentUser, model.createAtStr)[0],
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
    NotedUIModel model = widget.notedUIModel;
    String? repostId = model.noteDB.repostId;
    if (repostId != null && repostId.isNotEmpty) {
      _getRepostId(repostId);
    } else {
      notedUIModel = model;
      setState(() {});
      _getMomentUser(model);
    }
  }

  void _getRepostId(String repostId) async {
    NoteDB? note = await Moment.sharedInstance.loadNoteWithNoteId(repostId);
    if(note == null) return;
    final newNotedUIModel = NotedUIModel(noteDB: note);
    notedUIModel = newNotedUIModel;
    _getMomentUser(newNotedUIModel);
  }

  void _getMomentUser(NotedUIModel notedUIModel) async {
    UserDB? user = await Account.sharedInstance.getUserInfo(notedUIModel.noteDB.author);
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
    UserDB? user =
        await Account.sharedInstance.getUserInfo(widget.noteDB.author);
    momentUserDB = user;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String? repostId = widget.noteDB.repostId;
    if (repostId == null || repostId.isEmpty) return const SizedBox();
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
          onTap: () {
            OXModuleService.pushPage(
                context, 'ox_chat', 'ContactUserInfoPage', {
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
