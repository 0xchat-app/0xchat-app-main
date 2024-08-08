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

class MomentsPage extends StatefulWidget {
  final bool isShowReply;
  final ValueNotifier<NotedUIModel> notedUIModel;
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

  List<ValueNotifier<NotedUIModel>> replyList = [];

  ValueNotifier<NotedUIModel>? notedUIModel;
  @override
  void initState() {
    super.initState();
    _dataPre();
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

  void _dataPre() async {
    await _getReplyList();
  }

  @override
  Future<void> didPopNext() async {
    _updateNoted();
  }

  void _updateNoted() async {
    if (notedUIModel == null) return;
    NoteDBISAR? note = await Moment.sharedInstance
        .loadNoteWithNoteId(notedUIModel!.value.noteDB.noteId);
    if (note == null) return;
    int newReplyNum = note.replyEventIds?.length ?? 0;
    if (newReplyNum > replyList.length) {
      widget.notedUIModel.value = NotedUIModel(noteDB: note);
      _getReplyList();
    }
  }

  Future _getReplyList() async {
    notedUIModel = widget.notedUIModel;

    if (mounted) {
      setState(() {});
    }

    _getReplyFromDB(widget.notedUIModel);
    _getReplyFromRelay(widget.notedUIModel);
  }

  void _getReplyFromRelay(ValueNotifier<NotedUIModel> notedUIModelDraft) async {
    await Moment.sharedInstance.loadNoteActions(
        notedUIModelDraft.value.noteDB.noteId, actionsCallBack: (result) async {
      NoteDBISAR? note = await Moment.sharedInstance
          .loadNoteWithNoteId(notedUIModelDraft.value.noteDB.noteId);
      NoteDBISAR? updateNote = await Moment.sharedInstance
          .loadNoteWithNoteId(widget.notedUIModel.value.noteDB.noteId);
      if (note == null) return;
      ValueNotifier<NotedUIModel> newNotedUIModel =
          ValueNotifier(NotedUIModel(noteDB: note));
      notedUIModel = newNotedUIModel;
      if (updateNote != null) {
        widget.notedUIModel.value = NotedUIModel(noteDB: updateNote);
      }
      if (mounted) {
        setState(() {});
      }
      _getReplyFromDB(newNotedUIModel);
    });
  }

  void _getReplyFromDB(ValueNotifier<NotedUIModel> notedUIModelDraft) async {
    List<String>? replyEventIds = notedUIModelDraft.value.noteDB.replyEventIds;
    if (replyEventIds == null) return;

    List<ValueNotifier<NotedUIModel>> result = [];
    for (String noteId in replyEventIds) {
      NoteDBISAR? note = await Moment.sharedInstance.loadNoteWithNoteId(noteId);
      if (note != null) result.add(ValueNotifier(NotedUIModel(noteDB: note)));
    }

    replyList = result;

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
                              notedUIModel: notedUIModel,
                              isShowReply: widget.isShowReply,
                              callback: (double height, lastHeight) => {},
                            ),
                          ),
                        ),
                      ),

                      MomentWidget(
                        isShowAllContent: true,
                        isShowInteractionData: true,
                        isShowReply: false,
                        notedUIModel: notedUIModel ?? widget.notedUIModel,
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
    ValueNotifier<NotedUIModel>? model = notedUIModel;
    if (model == null) return const SizedBox();
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
    List<Widget> list =
        replyList.map((ValueNotifier<NotedUIModel> notedUIModelDraft) {
      int index = replyList.indexOf(notedUIModelDraft);
      if (notedUIModelDraft.value.noteDB.noteId ==
              widget.notedUIModel.value.noteDB.noteId &&
          index != 0) return const SizedBox();
      if (notedUIModel != null &&
          !notedUIModelDraft.value.noteDB
              .isFirstLevelReply(notedUIModel?.value.noteDB.noteId)) {
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
  final ValueNotifier<NotedUIModel>? notedUIModel;
  final bool isShowReply;
  final Function callback;
  const MomentRootNotedWidget({
    super.key,
    required this.notedUIModel,
    required this.isShowReply,
    required this.callback,
  });

  @override
  State<MomentRootNotedWidget> createState() => MomentRootNotedWidgetState();
}

class MomentRootNotedWidgetState extends State<MomentRootNotedWidget> {
  final GlobalKey _contentWrapContainerKey = GlobalKey();
  final GlobalKey _contentLastContainerKey = GlobalKey();

  List<ValueNotifier<NotedUIModel>>? notedReplyList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dealWithNoted();
  }

  void _dealWithNoted() async {
    if (widget.notedUIModel == null) return;
    notedReplyList = [];
    await _getReplyNoted(widget.notedUIModel!);
    setState(() {});
  }

  Future _getReplyNoted(ValueNotifier<NotedUIModel> model) async {
    String replyId = model.value.noteDB.getReplyId ?? '';
    String? rootId = model.value.noteDB.root;
    if (replyId.isNotEmpty) {
      NoteDBISAR? noted =
          await Moment.sharedInstance.loadNoteWithNoteId(replyId);
      if (noted != null) {
        final newNotedUIModel = ValueNotifier(NotedUIModel(noteDB: noted));
        notedReplyList = [
          ...[newNotedUIModel],
          ...notedReplyList!
        ];
        _getReplyNoted(newNotedUIModel);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _showContentWidget();
  }

  Widget _showContentWidget() {
    if (notedReplyList == null) {
      return MomentWidgetsUtils.emptyNoteMomentWidget(null, 100);
    }

    return Container(
      key: _contentWrapContainerKey,
      child: Column(
        children: notedReplyList!.map((model) {
          int findIndex = notedReplyList!.indexOf(model);
          bool isLastNoted = findIndex == notedReplyList!.length - 1;
          return Container(
            key: isLastNoted ? _contentLastContainerKey : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MomentWidget(
                  isShowAllContent: true,
                  isShowInteractionData: true,
                  isShowReply: false,
                  clickMomentCallback:
                      (ValueNotifier<NotedUIModel> notedUIModel) async {
                    if (isLastNoted) return;
                    if (notedUIModel.value.noteDB.isReply &&
                        widget.isShowReply) {
                      await OXNavigator.pushPage(context,
                          (context) => MomentsPage(notedUIModel: notedUIModel));
                      setState(() {});
                    }
                  },
                  notedUIModel: model,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.px),
                  width: 1.px,
                  height: 20.px,
                  color: ThemeColor.color80,
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class MomentReplyWrapWidget extends StatefulWidget {
  final ValueNotifier<NotedUIModel> notedUIModel;
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
  ValueNotifier<NotedUIModel>? firstReplyNoted;
  ValueNotifier<NotedUIModel>? secondReplyNoted;
  ValueNotifier<NotedUIModel>? thirdReplyNoted;

  bool isShowRepliesWidget = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getReplyList(widget.notedUIModel, 0);
  }

  void _getReplyList(
      ValueNotifier<NotedUIModel> noteModelDraft, int index) async {
    _getReplyFromDB(noteModelDraft, index);
    _getReplyFromRelay(noteModelDraft, index);
  }

  void _getReplyFromRelay(
      ValueNotifier<NotedUIModel> notedUIModelDraft, int index) async {
    await Moment.sharedInstance.loadNoteActions(
        notedUIModelDraft.value.noteDB.noteId, actionsCallBack: (result) async {
      NoteDBISAR? note = await Moment.sharedInstance
          .loadNoteWithNoteId(notedUIModelDraft.value.noteDB.noteId);

      if (note == null) return;
      ValueNotifier<NotedUIModel> newNotedUIModel =
          ValueNotifier(NotedUIModel(noteDB: note));

      if (mounted) {
        setState(() {});
      }
      _getReplyFromDB(newNotedUIModel, index);
    });
  }

  void _getReplyFromDB(
      ValueNotifier<NotedUIModel> notedUIModelDraft, int index) async {
    List<String>? replyEventIds = notedUIModelDraft.value.noteDB.replyEventIds;
    if (replyEventIds == null) return;

    List<ValueNotifier<NotedUIModel>> result = [];
    for (String noteId in replyEventIds) {
      NoteDBISAR? note = await Moment.sharedInstance.loadNoteWithNoteId(noteId);
      if (note != null) result.add(ValueNotifier(NotedUIModel(noteDB: note)));
    }

    if (index == 0) {
      firstReplyNoted = result.isNotEmpty ? result[0] : null;
      if (firstReplyNoted != null) {
        _getReplyList(firstReplyNoted!, 1);
      }
    }

    if (index == 1) {
      secondReplyNoted = result.isNotEmpty ? result[0] : null;
      if (secondReplyNoted != null) {
        isShowRepliesWidget = true;
        setState(() {});
        _getReplyList(secondReplyNoted!, 2);
      }
    }

    if (index == 2) {
      thirdReplyNoted = result.isNotEmpty ? result[0] : null;
      if (thirdReplyNoted != null) {
        _getReplyList(thirdReplyNoted!, 3);
      }
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
    if (secondReplyNoted == null || isShowRepliesWidget)
      return const SizedBox();
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
  final ValueNotifier<NotedUIModel> notedUIModel;
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
    String pubKey = widget.notedUIModel.value.noteDB.author;
    await Account.sharedInstance.getUserInfo(pubKey);
    if (mounted) {
      setState(() {});
    }
  }

  Widget _momentItemWidget() {
    String pubKey = widget.notedUIModel.value.noteDB.author;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        OXNavigator.pushPage(
            context,
            (context) => MomentsPage(
                notedUIModel: widget.notedUIModel, isShowReply: false));
        setState(() {});
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
                              (ValueNotifier<NotedUIModel> notedUIModel) async {
                            await OXNavigator.pushPage(
                              context,
                              (context) => MomentsPage(
                                  notedUIModel: widget.notedUIModel,
                                  isShowReply: false),
                            );
                            setState(() {});
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

  Widget _momentUserInfoWidget(UserDBISAR userDB) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: userDB.name ?? '--',
            style: TextStyle(
              color: ThemeColor.color0,
              fontSize: 14.px,
              fontWeight: FontWeight.w500,
            ),
          ),
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
    );
  }
}
