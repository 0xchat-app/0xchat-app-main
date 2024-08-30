import 'dart:ui';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/mixin/common_navigator_observer_mixin.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:flutter/services.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_discovery/model/moment_extension_model.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';
import '../../model/moment_ui_model.dart';
import '../../utils/discovery_utils.dart';
import '../../utils/moment_widgets_utils.dart';
import '../widgets/moment_widget.dart';
import '../widgets/simple_moment_reply_widget.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class MomentsPage extends StatefulWidget {
  final bool isShowReply;
  final ValueNotifier<NotedUIModel?> notedUIModel;
  const MomentsPage(
      {Key? key, required this.notedUIModel, this.isShowReply = true})
      : super(key: key);

  @override
  State<MomentsPage> createState() => _MomentsPageState();
}

class _MomentsPageState extends State<MomentsPage> with NavigatorObserverMixin {
  final GlobalKey _replyListContainerKey = GlobalKey();
  final GlobalKey _containerKey = GlobalKey();

  final ScrollController _scrollController = ScrollController();

  bool _isShowMask = false;

  List<ValueNotifier<NotedUIModel?>> replyList = [];

  @override
  void initState() {
    super.initState();
    _getReplyList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToPosition(double offset) {
    _scrollController.jumpTo(
      offset,
    );
  }

  @override
  Future<void> didPopNext() async {
    _updateNoted();
  }

  void _updateNoted() async {
    if(widget.notedUIModel.value == null) return;
    NotedUIModel notedUIModel = widget.notedUIModel.value!;
    String noteId = notedUIModel.noteDB.noteId;

    ValueNotifier<NotedUIModel?> noteNotifier = await OXMomentCacheManager.getValueNotifierNoted(
        noteId,
        isUpdateCache: true,
        notedUIModel: notedUIModel,
    );

    if (noteNotifier.value == null) return;
    int newReplyNum = noteNotifier.value!.noteDB.replyEventIds?.length ?? 0;
    if (newReplyNum > replyList.length) {
      _getReplyList();
    }
  }

  Future _getReplyList() async {
    _getReplyFromDB();
    _getReplyFromRelay();
  }

  void _getReplyFromRelay() async {
    if(widget.notedUIModel.value == null) return;
    String notedId = widget.notedUIModel.value!.noteDB.noteId;
    await Moment.sharedInstance.loadNoteActions(notedId, actionsCallBack: (result) async {
      ValueNotifier<NotedUIModel?> noteNotifier = await OXMomentCacheManager.getValueNotifierNoted(
          notedId,
          isUpdateCache: true,
          notedUIModel: widget.notedUIModel.value,
      );
      if(noteNotifier.value == null) return;
      _getReplyFromDB();
    });
  }

  void _getReplyFromDB() async {
    if(widget.notedUIModel.value == null) return;
    String noteId = widget.notedUIModel.value!.noteDB.noteId;

    ValueNotifier<NotedUIModel?> preNoteNotifier = OXMomentCacheManager.getValueNotifierNoteToCache(noteId);

    if(preNoteNotifier.value == null){
      preNoteNotifier = await OXMomentCacheManager.getValueNotifierNoted(
        noteId,
        isUpdateCache: true,
      );
      if(preNoteNotifier.value == null) return;
    }

    List<String>? replyEventIds = preNoteNotifier.value!.noteDB.replyEventIds;
    if (replyEventIds == null) return;

    List<ValueNotifier<NotedUIModel?>> resultList = [];
    for (String noteId in replyEventIds) {
      ValueNotifier<NotedUIModel?> noteNotifier = await OXMomentCacheManager.getValueNotifierNoted(
        noteId,
        isUpdateCache: true,
      );
      if (noteNotifier.value != null) resultList.add(noteNotifier);
    }

    replyList = resultList;

    if (mounted) {
      setState(() {});
    }
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
          title: Localized.text('ox_discovery.moment'),
        ),
        body: Container(
          height: double.infinity,
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                child: Container(
                  padding: EdgeInsets.only(
                    left: 24.px,
                    right: 24.px,
                    bottom: 100.px,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NotificationListener<SizeChangedLayoutNotification>(
                        onNotification: (notification) {
                          final RenderBox renderBox = _containerKey.currentContext?.findRenderObject() as RenderBox;
                          final size = renderBox.size;
                          _scrollToPosition(size.height - 10);
                          return true;
                        },
                        child: SizeChangedLayoutNotifier(
                          child: Container(
                            key: _containerKey,
                            child: MomentRootNotedWidget(
                              notedUIModel: widget.notedUIModel,
                              isShowReply: widget.isShowReply,
                            ),
                          ),
                        ),
                      ),
                      MomentWidget(
                        isShowAllContent: true,
                        isShowInteractionData: true,
                        isShowReply: false,
                        notedUIModel: widget.notedUIModel,
                      ),
                      // _showContentWidget(),
                      _showReplyList(),
                      _noDataWidget(),
                      SizedBox(
                        height: 500.px,
                      ),
                    ],
                  ),
                ),
              ),
              _isShowMaskWidget(),
              _showSimpleReplyWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showSimpleReplyWidget() {
    ValueNotifier<NotedUIModel?> model = widget.notedUIModel;
    if (model.value == null) return const SizedBox();
    return Positioned(
      left: 0,
      right: 0,
      bottom: 20,
      child: SimpleMomentReplyWidget(
        notedUIModel: model,
        postNotedCallback: _updateNoted,
        isFocusedCallback: (focusStatus) {
          if (focusStatus == _isShowMask) return;
          setState(() {
            _isShowMask = focusStatus;
          });
        },
      ),
    );
  }

  Widget _showReplyList() {
    List<Widget> list = replyList.map((ValueNotifier<NotedUIModel?> notedUIModelDraft) {
      if(notedUIModelDraft.value == null) {
        return const SizedBox();
      }
      int index = replyList.indexOf(notedUIModelDraft);
      NoteDBISAR? draftModel = notedUIModelDraft.value?.noteDB;
      NoteDBISAR? widgetModel = widget.notedUIModel.value?.noteDB;

      if (draftModel?.noteId == widgetModel?.noteId && index != 0) {
        return const SizedBox();
      }
      if (!draftModel?.isFirstLevelReply(widgetModel?.noteId)) {
        return const SizedBox();
      }
      return MomentReplyWrapWidget(
        index: index,
        notedUIModel: notedUIModelDraft,
      );
    }).toList();

    return Container(
      key: _replyListContainerKey,
      child: Column(
        children: list,
      ),
    );
  }

  Widget _isShowMaskWidget() {
    if (!_isShowMask) return const SizedBox();
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.transparent,
    );
  }

  Widget _noDataWidget() {
    if (replyList.isNotEmpty) return const SizedBox();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 50.px),
      child: Center(
        child: Column(
          children: [
            CommonImage(
              iconName: 'icon_no_data.png',
              width: Adapt.px(90),
              height: Adapt.px(90),
            ),
            Text(
              '${Localized.text('ox_discovery.no')} ${Localized.text('ox_discovery.reply')} !',
              style: TextStyle(
                fontSize: 16.px,
                fontWeight: FontWeight.w400,
                color: ThemeColor.color100,
              ),
            ).setPaddingOnly(
              top: 24.px,
            ),
          ],
        ),
      ),
    );
  }
}

class MomentRootNotedWidget extends StatefulWidget {
  final ValueNotifier<NotedUIModel?>? notedUIModel;
  final bool isShowReply;
  const MomentRootNotedWidget({
    super.key,
    required this.notedUIModel,
    required this.isShowReply,
  });

  @override
  State<MomentRootNotedWidget> createState() => MomentRootNotedWidgetState();
}

class MomentRootNotedWidgetState extends State<MomentRootNotedWidget> {
  List<ValueNotifier<NotedUIModel?>>? notedReplyList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dealWithNoted();
  }

  void _dealWithNoted() async {
    if (widget.notedUIModel == null || widget.notedUIModel?.value == null) return;
    await Future.delayed(Duration.zero);
    if(mounted){
      setState(() {});
    }

    notedReplyList = [];
    await _getReplyNoted(widget.notedUIModel!);

  }

  Future _getReplyNoted(ValueNotifier<NotedUIModel?> model) async {
    String replyId = model.value?.noteDB.getReplyId ?? '';
    if (replyId.isNotEmpty) {
      ValueNotifier<NotedUIModel?> replyNotifier = await OXMomentCacheManager.getValueNotifierNoted(
        replyId,
        isUpdateCache: true,
        notedUIModel: model.value,
      );
        notedReplyList = [
          ...[replyNotifier],
          ...notedReplyList!
        ];
        _getReplyNoted(replyNotifier);
    }else{
      _updateReply(notedReplyList ?? []);
      if(mounted){
        setState(() {});
      }
    }
  }

  void _updateReply(List<ValueNotifier<NotedUIModel?>> notedReplyList) async {
    if(notedReplyList.isEmpty) return;
    for(ValueNotifier<NotedUIModel?> noted in notedReplyList){
      if(noted.value == null) {
        continue;
      }
      String notedId = noted.value!.noteDB.noteId;
      await Moment.sharedInstance.loadNoteActions(notedId, actionsCallBack: (result) async {});
      ValueNotifier<NotedUIModel?> noteNotifier = await OXMomentCacheManager.getValueNotifierNoted(
        notedId,
        isUpdateCache: true,
        notedUIModel: noted.value,
      );

      if(noteNotifier.value == null ) return;
      noted.value = noteNotifier.value as NotedUIModel;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _showContentWidget();
  }

  Widget _showContentWidget() {
    if(widget.notedUIModel == null || widget.notedUIModel?.value == null || notedReplyList == null) return const SizedBox();
    String replyId = widget.notedUIModel?.value?.noteDB.getReplyId ?? '';
    if (notedReplyList!.isEmpty && replyId.isNotEmpty) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MomentWidgetsUtils.emptyNoteMomentWidget(null, 100),
            Container(
              margin: EdgeInsets.only(left: 20.px),
              width: 1.px,
              height: 20.px,
              color: ThemeColor.color160,
            )
          ],
        ),
      );
    }

    return Container(
      child: Column(
        children: notedReplyList!.map((model) {
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _showMomentWidget(model),
                Container(
                  margin: EdgeInsets.only(left: 20.px),
                  width: 1.px,
                  height: 20.px,
                  color: ThemeColor.color160,
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _showMomentWidget(ValueNotifier<NotedUIModel?> modelNotifier){
    if(modelNotifier.value == null) return  MomentWidgetsUtils.emptyNoteMomentWidget(null, 100);
    return MomentWidget(
      isShowAllContent: true,
      isShowInteractionData: true,
      isShowReply: false,
      clickMomentCallback:
          (ValueNotifier<NotedUIModel?> notedUIModel) async {
        await OXNavigator.pushPage(context,
                (context) => MomentsPage(notedUIModel: notedUIModel));
      },
      notedUIModel: modelNotifier,
    );

  }
}

class MomentReplyWrapWidget extends StatefulWidget {
  final ValueNotifier<NotedUIModel?> notedUIModel;
  final int index;

  const MomentReplyWrapWidget({
    super.key,
    required this.notedUIModel,
    required this.index,
  });

  @override
  State<MomentReplyWrapWidget> createState() => MomentReplyWrapWidgetState();
}

class MomentReplyWrapWidgetState extends State<MomentReplyWrapWidget> {
  ValueNotifier<NotedUIModel?>? firstReplyNoted;
  ValueNotifier<NotedUIModel?>? secondReplyNoted;
  ValueNotifier<NotedUIModel?>? thirdReplyNoted;

  bool isShowRepliesWidget = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getReplyList(widget.notedUIModel, 0);
  }
  
  void _getReplyList(ValueNotifier<NotedUIModel?> noteModelDraft, int index) async {
    _getReplyFromDB(noteModelDraft, index);
    _getReplyFromRelay(noteModelDraft, index);
  }

  void _getReplyFromRelay(ValueNotifier<NotedUIModel?> notedUIModelDraft, int index) async {
    String? noteId = notedUIModelDraft.value?.noteDB.noteId;
    if(noteId == null) return;
    await Moment.sharedInstance.loadNoteActions(noteId, actionsCallBack: (result) async {

      ValueNotifier<NotedUIModel?> noteNotifier = await OXMomentCacheManager.getValueNotifierNoted(
        noteId,
        isUpdateCache: true,
        notedUIModel: notedUIModelDraft.value,
      );


      if (noteNotifier.value == null) return;

      if (mounted) {
        setState(() {});
      }
      _getReplyFromDB(noteNotifier, index);
    });
  }

  void _getReplyFromDB(ValueNotifier<NotedUIModel?> notedUIModelDraft, int index) async {
    List<String>? replyEventIds = notedUIModelDraft.value?.noteDB.replyEventIds;
    if (replyEventIds == null || replyEventIds.isEmpty) return;


    String noteId = replyEventIds[0];

    ValueNotifier<NotedUIModel?> replyNotifier = OXMomentCacheManager.getValueNotifierNoteToCache(noteId);

    if(replyNotifier.value == null){
       replyNotifier = await OXMomentCacheManager.getValueNotifierNoted(
         noteId,
        isUpdateCache: true,
      );
    }

    if(replyNotifier.value == null) return;

    if (index == 0) {
      firstReplyNoted = replyNotifier;
      _getReplyList(firstReplyNoted!, 1);
    }

    if (index == 1) {
      secondReplyNoted = replyNotifier;
      isShowRepliesWidget = true;
      _getReplyList(secondReplyNoted!, 2);
    }

    if (index == 2) {
      thirdReplyNoted = replyNotifier;
      _getReplyList(thirdReplyNoted!, 3);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Column(
        children: [
          MomentReplyWidget(
            notedUIModel: widget.notedUIModel,
            isShowLink: firstReplyNoted != null,
          ),
          _firstReplyWidget(),
          _secondReplyWidget(),
          _thirdReplyWidget(),
          _showRepliesWidget(),
        ],
      ),
    );
  }

  Widget _firstReplyWidget() {
    if (firstReplyNoted == null) return const SizedBox();
    return MomentReplyWidget(
      notedUIModel: firstReplyNoted!,
      isShowLink: secondReplyNoted != null,
    );
  }

  Widget _secondReplyWidget() {
    if (secondReplyNoted == null || isShowRepliesWidget){
      return const SizedBox();
    }

    return MomentReplyWidget(
      notedUIModel: secondReplyNoted!,
      isShowLink: thirdReplyNoted != null,
    );
  }

  Widget _thirdReplyWidget() {
    if (thirdReplyNoted == null || isShowRepliesWidget) return const SizedBox();
    return MomentReplyWidget(notedUIModel: thirdReplyNoted!);
  }

  Widget _showRepliesWidget() {
    if (!isShowRepliesWidget) return const SizedBox();
    return GestureDetector(
      onTap: () {
        isShowRepliesWidget = false;
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.only(
          left: 12.px,
          bottom: 24.px,
        ),
        child: Row(
          children: [
            CommonImage(
              iconName: 'more_vertical_icon.png',
              size: 16.px,
              package: 'ox_discovery',
            ),
            SizedBox(
              width: 20.px,
            ),
            Text(
              Localized.text('ox_discovery.show_replies_text'),
              style: TextStyle(
                color: ThemeColor.purple2,
                fontSize: 12.px,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MomentReplyWidget extends StatefulWidget {
  final ValueNotifier<NotedUIModel?> notedUIModel;
  final bool isShowLink;

  const MomentReplyWidget({
    super.key,
    required this.notedUIModel,
    this.isShowLink = false,
  });

  @override
  State<MomentReplyWidget> createState() => _MomentReplyWidgetState();
}

class _MomentReplyWidgetState extends State<MomentReplyWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMomentUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return _momentItemWidget();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.notedUIModel != oldWidget.notedUIModel) {
      _getMomentUserInfo();
    }
  }

  void _getMomentUserInfo() async {
    if( widget.notedUIModel.value == null) return;
    String pubKey = widget.notedUIModel.value!.noteDB.author;
    await Account.sharedInstance.getUserInfo(pubKey);
  }

  Widget _momentItemWidget() {
    if(widget.notedUIModel.value == null) return const SizedBox();
    String pubKey = widget.notedUIModel.value!.noteDB.author;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        OXNavigator.pushPage(
            context,
            (context) => MomentsPage(
                notedUIModel: widget.notedUIModel, isShowReply: false));
      },
      child: IntrinsicHeight(
        child: ValueListenableBuilder<UserDBISAR>(
          valueListenable: Account.sharedInstance.getUserNotifier(pubKey),
          builder: (context, value, child) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    MomentWidgetsUtils.clipImage(
                      borderRadius: 40.px,
                      imageSize: 40.px,
                      child: GestureDetector(
                        onTap: () {
                          OXModuleService.pushPage(
                              context, 'ox_chat', 'ContactUserInfoPage', {
                            'pubkey': value.pubKey,
                          });
                        },
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
                    if (widget.isShowLink)
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
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(
                      bottom: 16.px,
                    ),
                    margin: EdgeInsets.all(8.px),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _momentUserInfoWidget(value),
                        MomentWidget(
                          isShowAllContent: false,
                          isShowReply: false,
                          notedUIModel: widget.notedUIModel,
                          isShowUserInfo: false,
                          clickMomentCallback:
                              (ValueNotifier<NotedUIModel?> notedUIModel) async {
                            await OXNavigator.pushPage(
                              context,
                              (context) => MomentsPage(
                                  notedUIModel: widget.notedUIModel,
                                  isShowReply: false),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _checkIsPrivate() {
    NotedUIModel? model = widget.notedUIModel.value;
    if (model == null || !model.noteDB.private) return const SizedBox();
    double momentMm = DiscoveryUtils.boundingTextSize(
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

  Widget _momentUserInfoWidget(UserDBISAR userDB) {
    if(widget.notedUIModel.value == null) return const SizedBox();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              userDB.name ?? '--',
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
          DiscoveryUtils.getUserMomentInfo(userDB, widget.notedUIModel.value!.createAtStr)[0],
          style: TextStyle(
            color: ThemeColor.color120,
            fontSize: 12.px,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

}
