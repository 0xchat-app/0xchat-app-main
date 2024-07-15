import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/took_kit.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_discovery/enum/moment_enum.dart';
import 'package:ox_discovery/page/widgets/moment_article_widget.dart';
import 'package:ox_discovery/page/widgets/reply_contact_widget.dart';
import 'package:ox_discovery/page/widgets/video_moment_widget.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'moment_option_widget.dart';
import 'moment_payment_widget.dart';
import 'moment_url_widget.dart';
import 'moment_quote_widget.dart';
import 'moment_reply_abbreviate_widget.dart';
import 'moment_reposted_tips_widget.dart';
import 'moment_rich_text_widget.dart';
import 'nine_palace_grid_picture_widget.dart';
import 'package:ox_discovery/model/moment_extension_model.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import '../../utils/moment_widgets_utils.dart';
import '../../model/moment_ui_model.dart';
import '../../utils/discovery_utils.dart';
import '../moments/moment_option_user_page.dart';
import '../moments/moments_page.dart';

class MomentWidget extends StatefulWidget {
  final bool isShowInteractionData;
  final bool isShowReply;
  final bool isShowUserInfo;
  final bool isShowReplyWidget;
  final bool isShowMomentOptionWidget;
  final bool isShowAllContent;
  final Function(ValueNotifier<NotedUIModel> notedUIModel)? clickMomentCallback;
  final ValueNotifier<NotedUIModel> notedUIModel;
  const MomentWidget({
    super.key,
    required this.notedUIModel,
    this.clickMomentCallback,
    this.isShowAllContent = false,
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
  ValueNotifier<NotedUIModel>? notedUIModel;

  List<EMomentMoreOptionType> momentOptionMoreList = [
    EMomentMoreOptionType.copyNotedID,
    EMomentMoreOptionType.copyNotedText,
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dataInit();
  }

  @override
  Widget build(BuildContext context) {
    return _momentItemWidget();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.notedUIModel.value.noteDB.noteId !=
        oldWidget.notedUIModel.value.noteDB.noteId) {
      _dataInit();
    }

    if(widget.notedUIModel.value.noteDB.isRepost && notedUIModel == null){
      _dataInit();
    }
  }

  Widget _momentItemWidget() {
    ValueNotifier<NotedUIModel>? model = notedUIModel;
    if (model == null) return const SizedBox();
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
       await widget.clickMomentCallback?.call(model);
        setState(() {});
      },
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
            MomentReplyAbbreviateWidget(
                notedUIModel: model,
                isShowReplyWidget: widget.isShowReplyWidget,
            ),
            _momentInteractionDataWidget(),
            MomentOptionWidget(
                notedUIModel: model,
                isShowMomentOptionWidget: widget.isShowMomentOptionWidget,
            ),
          ],
        ),
      ),
    );
  }

  Widget _showMomentContent() {
    ValueNotifier<NotedUIModel>? model = notedUIModel;
    if(model == null) return const SizedBox();

    List<String> quoteUrlList = model.value.getQuoteUrlList;
    List<String> getNddrlList = model.value.getNddrlList;
    List<String> getLightningInvoiceList = model.value.getLightningInvoiceList;
    List<String> getEcashList = model.value.getEcashList;

    if (getEcashList.isEmpty && getLightningInvoiceList.isEmpty && getNddrlList.isEmpty && quoteUrlList.isEmpty && model.value.getMomentShowContent.isEmpty) {
      return const SizedBox();
    }

    List<String> contentList = DiscoveryUtils.momentContentSplit(model.value.noteDB.content);
    return Column(
      children: contentList.map((String content) {
        String? noteId;
        String? neventId;
        List<String>? relays;
        String? quoteRepostId = model.value.noteDB.quoteRepostId;
        if (quoteUrlList.contains(content)) {
          if(content.contains('nostr:nevent')){
            neventId = content;
          }else{
            final noteInfo = NoteDB.decodeNote(content);
            noteId = noteInfo?['channelId'];

          }
          bool isShowQuote =
          (noteId != null && noteId.toLowerCase() != quoteRepostId?.toLowerCase()) || neventId != null;
          return isShowQuote
              ? MomentQuoteWidget(notedId: noteId,relays: relays,neventId:neventId)
              : const SizedBox();
        } else if(getNddrlList.contains(content)){
          return MomentArticleWidget(naddr: content);
        } else if(getLightningInvoiceList.contains(content)){
          return MomentPaymentWidget(invoice:content,type: EPaymentType.lighting,);
        } else if(getEcashList.contains(content)){
          return MomentPaymentWidget(invoice:content,type: EPaymentType.ecash,);
        } else {
          return MomentRichTextWidget(
            isShowAllContent: widget.isShowAllContent,
            clickBlankCallback: () async{
             await widget.clickMomentCallback?.call(model);
              setState(() {});
            },
            showMoreCallback: () async {
             await OXNavigator.pushPage(
                  context, (context) => MomentsPage(notedUIModel: model,isShowReply: widget.isShowReply));
              setState(() {});
            },
            text: content,
          ).setPadding(EdgeInsets.only(bottom: 12.px));
        }
      }).toList(),
    );
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
      String videoUrl = getVideoList[0];
      bool isHasYoutube =
          videoUrl.contains('youtube.com') || videoUrl.contains('youtu.be');
      return isHasYoutube
          ? MomentWidgetsUtils.youtubeSurfaceMoment(context,videoUrl)
          : VideoMomentWidget(videoUrl: videoUrl);
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
    List<String> quoteUrlList = model.value.getQuoteUrlList;
    String? quoteRepostId = model.value.noteDB.quoteRepostId;
    bool hasQuoteRepostId = quoteRepostId != null && quoteRepostId.isNotEmpty;
    if (!hasQuoteRepostId) return const SizedBox();
    bool isRepeat = false;
    for(String content in quoteUrlList){
      if(content.contains('nostr:nevent')){
        Map result = Nip19.decodeShareableEntity(Nip21.decode(content)!);
        if(result['special']?.toLowerCase() == quoteRepostId.toLowerCase()){
          isRepeat = true;
          break;
        }
      }
    }

    return isRepeat ? const SizedBox() : MomentQuoteWidget(notedId: quoteRepostId);
  }

  Widget _momentUserInfoWidget() {
    ValueNotifier<NotedUIModel>? model = notedUIModel;
    if (model == null || !widget.isShowUserInfo) return const SizedBox();
    String pubKey = model.value.noteDB.author;
    return Container(
      padding: EdgeInsets.only(bottom: 12.px),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ValueListenableBuilder<UserDB>(
            valueListenable: Account.sharedInstance.getUserNotifier(pubKey),
            builder: (context, value, child) {
              return Row(
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
                  Container(
                    margin: EdgeInsets.only(
                      left: 10.px,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              value.name ?? '',
                              style: TextStyle(
                                color: ThemeColor.color0,
                                fontSize: 14.px,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            _checkIsPrivate(),
                          ],
                        ),
                        Text(
                          DiscoveryUtils.getUserMomentInfo(
                              value, model.value.createAtStr)[0],
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
              );
            },
          ),
          GestureDetector(
            onTapDown: (TapDownDetails details) => _showMomentOptionMore(context, details.globalPosition),
            child: Container(
              padding: EdgeInsets.only(
                top: 10.px,
                left: 10.px,
                bottom: 10.px,
              ),
              child: CommonImage(
                iconName: 'more_moment_icon.png',
                size: 20.px,
                package: 'ox_discovery',
              ),
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

  void _showMomentOptionMore(BuildContext context, Offset position) async{
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    List<EMomentMoreOptionType> optionList = momentOptionMoreList;
    String noteAuthor = notedUIModel?.value.noteDB.author.toUpperCase() ?? '';
    String btnContent = '';
    bool isInBlocklist = Contacts.sharedInstance.inBlockList(noteAuthor);
    String myPubkey = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '';
    if(myPubkey.toUpperCase() != noteAuthor){
      btnContent = isInBlocklist
          ? Localized.text('ox_chat.message_menu_un_block')
          : Localized.text('ox_chat.message_menu_block');
      optionList = [...momentOptionMoreList, ...[EMomentMoreOptionType.block]];
    }
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + 10,
        overlay.size.width - position.dx,
        overlay.size.height - position.dy + 10,
      ),
      color: ThemeColor.color180,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      items: <PopupMenuEntry<EMomentMoreOptionType>>[
        ...optionList.map((EMomentMoreOptionType type) {
          return PopupMenuItem<EMomentMoreOptionType>(
            value: type,
            child: Center(
              child: Text(
                type == EMomentMoreOptionType.block ? btnContent : type.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ThemeColor.white,
                ),
              ),
            ),
          );
        }).toList()
      ],
    ).then((value)async {
      NoteDB? noteDB = notedUIModel?.value.noteDB;
      if (noteDB == null) {
        CommonToast.instance.show(context, 'Option fail');
        return;
      }
      switch (value) {
        case EMomentMoreOptionType.copyNotedID:
          await TookKit.copyKey(context, noteDB.encodedNoteId);
          break;
        case EMomentMoreOptionType.copyNotedText:
          await TookKit.copyKey(context, noteDB.content);
          break;
        case EMomentMoreOptionType.block:
          _blockOptionFn(noteAuthor);
          break;
      }
    });
  }

  Widget _momentInteractionDataWidget() {
    ValueNotifier<NotedUIModel> model = widget.notedUIModel;
    if (!widget.isShowInteractionData) return const SizedBox();

    NoteDB noteDB = model.value.noteDB;

    List<String> repostEventIds = noteDB.repostEventIds ?? [];
    List<String> quoteRepostEventIds = noteDB.quoteRepostEventIds ?? [];
    List<String> reactionEventIds = noteDB.reactionEventIds ?? [];
    List<String> zapEventIds = noteDB.zapEventIds ?? [];

    Widget _itemWidget(ENotificationsMomentType type, int num) {
      return GestureDetector(
        onTap: () async {
          await OXNavigator.pushPage(
              context,
              (context) =>
                  MomentOptionUserPage(notedUIModel: model, type: type));
          setState(() {});
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

  Widget _checkIsPrivate() {
    NotedUIModel? model = notedUIModel?.value;
    if (model == null || !model.noteDB.private) return const SizedBox();
    double momentMm = boundingTextSize(
            Localized.text('ox_discovery.private'),
            TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Adapt.px(20),
                color: ThemeColor.titleColor))
        .width;

    return Container(
      margin: EdgeInsets.only(left: 4.px),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.px),
        gradient: LinearGradient(
          colors: [
            ThemeColor.gradientMainEnd.withOpacity(0.2),
            ThemeColor.gradientMainStart.withOpacity(0.2),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 2.px,
        horizontal: 4.px,
      ),
      child: Container(
        constraints: BoxConstraints(maxWidth: momentMm),
        child: GradientText(
          Localized.text('ox_discovery.private'),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Adapt.px(12),
              color: ThemeColor.titleColor),
          colors: [
            ThemeColor.gradientMainStart,
            ThemeColor.gradientMainEnd,
          ],
        ),
      ),
    );
  }

  void _dataInit() async {
    ValueNotifier<NotedUIModel> model = widget.notedUIModel;
    String? repostId = model.value.noteDB.repostId;
    final notedUIModelCache = OXMomentCacheManager.sharedInstance.notedUIModelCache;

    if (model.value.noteDB.isRepost && repostId != null) {
      if (notedUIModelCache[repostId] != null) {
        notedUIModel = ValueNotifier(notedUIModelCache[repostId]!);
        _getMomentUserInfo(notedUIModel!.value);
        setState(() {});
      } else {
        _getRepostId(repostId);
      }
    } else {
      notedUIModel = model;
      _getMomentUserInfo(model.value);
      setState(() {});
    }
  }


  void _blockOptionFn(String pubKey) async {
    // String pubKey = userDB.pubKey ?? '';
    bool isInBlock = Contacts.sharedInstance.inBlockList(pubKey ?? '');
    if (isInBlock) {
      OKEvent event = await Contacts.sharedInstance.removeBlockList([pubKey]);
      if (!event.status) {
        CommonToast.instance
            .show(context, Localized.text('ox_chat.un_block_fail'));
      }
    } else {
      OXCommonHintDialog.show(context,
          title: Localized.text('ox_chat.block_dialog_title'),
          content: Localized.text('ox_chat.block_dialog_content'),
          actionList: [
            OXCommonHintAction.cancel(onTap: () {
              OXNavigator.pop(context, false);
            }),
            OXCommonHintAction.sure(
                text: Localized.text('ox_common.confirm'),
                onTap: () async {
                  OKEvent event =  await Contacts.sharedInstance.addToBlockList(pubKey);
                  if(!event.status){
                    CommonToast.instance.show(context, Localized.text('ox_chat.block_fail'));
                  }
                  OXChatBinding.sharedInstance.deleteSession(pubKey);
                  OXNavigator.pop(context, true);
                }),
          ],
          isRowAction: true);
    }
    setState(() {});
  }


  void _getMomentUserInfo(NotedUIModel model) async {
    String pubKey = model.noteDB.author;
    await Account.sharedInstance.getUserInfo(pubKey);
    if (mounted) {
      setState(() {});
    }
  }

  int _calculateColumnsForPictures(int picSize) {
    if (picSize == 1) return 1;
    if (picSize > 1 && picSize < 5) return 2;
    return 3;
  }

  void _getRepostId(String repostId) async {
    NoteDB? note = await Moment.sharedInstance.loadNoteWithNoteId(repostId);
    final notedUIModelCache = OXMomentCacheManager.sharedInstance.notedUIModelCache;
    if (note == null) {
      notedUIModelCache[repostId] = null;
      // Preventing a bug where the internal component fails to update in a timely manner when the outer ListView.builder array is updated with a non-reply note.
      notedUIModel = null;
      if(mounted){
        setState(() {});

      }
      return;
    }
    final newNotedUIModel = ValueNotifier(NotedUIModel(noteDB: note));
    notedUIModelCache[repostId] = NotedUIModel(noteDB: note);
    notedUIModel = newNotedUIModel;
    _getMomentUserInfo(newNotedUIModel.value);
  }

  static Size boundingTextSize(String text, TextStyle style,
      {int maxLines = 2 ^ 31, double maxWidth = double.infinity}) {
    if (text.isEmpty) {
      return Size.zero;
    }
    final TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(text: text, style: style),
        maxLines: maxLines)
      ..layout(maxWidth: maxWidth);
    return textPainter.size;
  }
}
