import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
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
import '../moments/moment_option_user_page.dart';
import '../moments/moments_page.dart';
import 'moment_reply_abbreviate_widget.dart';
import 'moment_reposted_tips_widget.dart';
import 'moment_rich_text_widget.dart';
import '../../utils/moment_widgets_utils.dart';
import 'horizontal_scroll_widget.dart';
import 'moment_option_widget.dart';
import 'moment_url_widget.dart';
import 'nine_palace_grid_picture_widget.dart';
import 'package:ox_discovery/model/moment_extension_model.dart';

class MomentWidget extends StatefulWidget {
  final bool isShowInteractionData;
  final bool isShowReply;
  final bool isShowUserInfo;
  final bool isShowReplyWidget;
  final bool isShowMomentOptionWidget;
  final Function(ValueNotifier<NotedUIModel> notedUIModel)? clickMomentCallback;
  final ValueNotifier<NotedUIModel> notedUIModel;
  const MomentWidget({
    super.key,
    required this.notedUIModel,
    this.clickMomentCallback,
    this.isShowReply = true,
    this.isShowUserInfo = true,
    this.isShowReplyWidget = false,
    this.isShowMomentOptionWidget = true,
    this.isShowInteractionData = false,
  });

  @override
  _MomentWidgetState createState() => _MomentWidgetState();
}

class _MomentWidgetState extends State<MomentWidget> {
  UserDB? momentUser;

  ValueNotifier<NotedUIModel>? notedUIModel;

  bool isLoadFailure = false;

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
    ValueNotifier<NotedUIModel>? model = notedUIModel;
    if(isLoadFailure) return _emptyNoteMoment();
    if (model == null) return const SizedBox();
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => widget.clickMomentCallback?.call(widget.notedUIModel),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 12.px,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MomentRepostedTips(
              noteDB: widget.notedUIModel.value.noteDB,
            ),
            _momentUserInfoWidget(),
            _showReplyContactWidget(),
            _showMomentContent(),
            _showMomentMediaWidget(),
            _momentQuoteWidget(),
            MomentReplyAbbreviateWidget(notedUIModel:widget.notedUIModel,isShowReplyWidget:widget.isShowReplyWidget),
            _momentInteractionDataWidget(),
            MomentOptionWidget(notedUIModel: widget.notedUIModel,isShowMomentOptionWidget:widget.isShowMomentOptionWidget),
          ],
        ),
      ),
    );
  }

  Widget _emptyNoteMoment(){
    return Container(
      margin: EdgeInsets.only(
        top: 10.px
      ),
      height: 300.px,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.px,
          color: ThemeColor.color160,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(
            11.5.px,
          ),
        ),
      ),
      child: Center(
        child: Text(
          'Moment not found !',
          style: TextStyle(
            color: ThemeColor.color100,
            fontSize: 16.px,
          ),
        ),
      ),
    );
  }


  Widget _showMomentContent() {
    ValueNotifier<NotedUIModel>? model = notedUIModel;
    if (model == null || model.value.getMomentShowContent.isEmpty) return const SizedBox();

    return MomentRichTextWidget(
      clickBlankCallback: () => widget.clickMomentCallback?.call(widget.notedUIModel),
      text: model.value.noteDB.content,
    ).setPadding(EdgeInsets.only(bottom: 12.px));
  }

  Widget _showMomentMediaWidget() {
    ValueNotifier<NotedUIModel>? model = notedUIModel;
    if (model == null) return const SizedBox();

    List<String> getImageList = model.value.getImageList;
    if (getImageList.isNotEmpty) {
      double width = MediaQuery.of(context).size.width * 0.64;
      return NinePalaceGridPictureWidget(
        crossAxisCount: _calculateColumnsForPictures(getImageList.length),
        width: width.px,
        axisSpacing: 4,
        imageList: getImageList,
      ).setPadding(EdgeInsets.only(bottom: 12.px));
    }

    List<String> getVideoList = model.value.getVideoList;
    if (getVideoList.isNotEmpty) {
      return MomentWidgetsUtils.videoMoment(context, getVideoList[0], null);
    }

    List<String> getMomentExternalLink = model.value.getMomentExternalLink;
    if (getMomentExternalLink.isNotEmpty) {
      return MomentUrlWidget(url: getMomentExternalLink[0]);
    }
    return const SizedBox();
  }

  Widget _showReplyContactWidget() {
    if (!widget.isShowReply) return const SizedBox();
    return ReplyContactWidget(notedUIModel: notedUIModel);
  }

  Widget _momentQuoteWidget() {
    ValueNotifier<NotedUIModel>? model = notedUIModel;
    if (model == null) return const SizedBox();

    String? quoteRepostId = model.value.noteDB.quoteRepostId;
    bool hasQuoteRepostId = quoteRepostId != null && quoteRepostId.isNotEmpty;
    if (model.value.getQuoteUrlList.isEmpty && !hasQuoteRepostId) return const SizedBox();
    ValueNotifier<NotedUIModel>? note =
        hasQuoteRepostId ? ValueNotifier(NotedUIModel(noteDB: model.value.noteDB)) : null;
    return HorizontalScrollWidget(
        quoteList: model.value.getQuoteUrlList, notedUIModel: note);
  }

  Widget _momentUserInfoWidget() {
    ValueNotifier<NotedUIModel>? model = notedUIModel;
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
                      'pubkey': model.value.noteDB.author,
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
                            momentUser, model.value.createAtStr)[0],
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

  Widget _momentInteractionDataWidget() {
    ValueNotifier<NotedUIModel> model = widget.notedUIModel;
    if (!widget.isShowInteractionData) return const SizedBox();

    List<String> repostEventIds = model.value.noteDB.repostEventIds ?? [];
    List<String> quoteRepostEventIds = model.value.noteDB.quoteRepostEventIds ?? [];
    List<String> reactionEventIds = model.value.noteDB.reactionEventIds ?? [];
    List<String> zapEventIds = model.value.noteDB.zapEventIds ?? [];

    Widget _itemWidget(ENotificationsMomentType type, int num) {
      return GestureDetector(
        onTap: () {
          OXNavigator.pushPage(context, (context) => MomentOptionUserPage(notedUIModel:model, type: type));
        },
        child: RichText(
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          text: TextSpan(
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12.px,
              color: ThemeColor.color0,
            ),
            children: [
              TextSpan(text: '$num '),
              TextSpan(
                text: type.text,
                style: TextStyle(
                  color: ThemeColor.color100,
                ),
              ),
            ],
          ),
        ),
      ).setPaddingOnly(right: 8.px);
    }

    return Container(
      padding: EdgeInsets.only(bottom: 12.px),
      child: Row(
        children: [
          _itemWidget(ENotificationsMomentType.repost, repostEventIds.length),
          _itemWidget(
              ENotificationsMomentType.quote, quoteRepostEventIds.length),
          _itemWidget(ENotificationsMomentType.like, reactionEventIds.length),
          _itemWidget(ENotificationsMomentType.zaps, zapEventIds.length),
        ],
      ),
    );
  }


  void _init() async {
    ValueNotifier<NotedUIModel> model = widget.notedUIModel;
    String? repostId = model.value.noteDB.repostId;
    if (model.value.noteDB.isRepost && repostId != null) {
      _getRepostId(repostId);
    } else {
      notedUIModel = model;
      setState(() {});
      _getMomentUser(model);
    }
  }

  int _calculateColumnsForPictures(int picSize) {
    if (picSize == 1) return 1;
    if (picSize > 1 && picSize < 5) return 2;
    return 3;
  }

  void _getRepostId(String repostId) async {
    NoteDB? note = await Moment.sharedInstance.loadNoteWithNoteId(repostId);
    if (note == null) {
      // Preventing a bug where the internal component fails to update in a timely manner when the outer ListView.builder array is updated with a non-reply note.
      isLoadFailure = true;
      notedUIModel = null;
      momentUser = null;
      setState(() {});
      return;
    }
    final newNotedUIModel = ValueNotifier(NotedUIModel(noteDB: note));
    notedUIModel = newNotedUIModel;
    _getMomentUser(newNotedUIModel);
  }

  void _getMomentUser(ValueNotifier<NotedUIModel> notedUIModel) async {
    UserDB? user =
        await Account.sharedInstance.getUserInfo(notedUIModel.value.noteDB.author);
    momentUser = user;
    setState(() {});
  }
}
