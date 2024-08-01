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
  final GlobalKey _contentContainerKey = GlobalKey();
  final GlobalKey _replyListContainerKey = GlobalKey();

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
    NoteDB? note = await Moment.sharedInstance
        .loadNoteWithNoteId(notedUIModel!.value.noteDB.noteId);
    if (note == null) return;
    int newReplyNum = note.replyEventIds?.length ?? 0;
    if (newReplyNum > replyList.length) {
      widget.notedUIModel.value = NotedUIModel(noteDB: note);
      _getReplyList();
    }
  }

  Future _getReplyList() async {
    ValueNotifier<NotedUIModel> noteModelDraft = widget.notedUIModel;
    notedUIModel = widget.notedUIModel;

    if (noteModelDraft.value.noteDB.isReply && widget.isShowReply) {
      replyList = [noteModelDraft];
      String? getReplyId = noteModelDraft.value.noteDB.getReplyId;
      if (getReplyId != null) {
        NoteDB? note =
            await Moment.sharedInstance.loadNoteWithNoteId(getReplyId);
        if (note == null) {
          notedUIModel = null;
          if (mounted) {
            setState(() {});
          }
          return;
        }
        notedUIModel = ValueNotifier(NotedUIModel(noteDB: note));
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration.zero);

      final RenderBox renderBox =
          _contentContainerKey.currentContext?.findRenderObject() as RenderBox;
      final size = renderBox.size;
      _scrollToPosition(size.height - 60);

      setState(() {});
    });

    if (mounted) {
      setState(() {});
    }

    ValueNotifier<NotedUIModel>? note = notedUIModel;
    if (note == null) return;
    _getReplyFromDB(note);
    _getReplyFromRelay(note);
  }

  void _getReplyFromRelay(ValueNotifier<NotedUIModel> notedUIModelDraft) async {
    await Moment.sharedInstance.loadNoteActions(
        notedUIModelDraft.value.noteDB.noteId, actionsCallBack: (result) async {
      NoteDB? note = await Moment.sharedInstance
          .loadNoteWithNoteId(notedUIModelDraft.value.noteDB.noteId);
      NoteDB? updateNote = await Moment.sharedInstance
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
      NoteDB? note = await Moment.sharedInstance.loadNoteWithNoteId(noteId);
      if (note != null) result.add(ValueNotifier(NotedUIModel(noteDB: note)));
    }
    List<ValueNotifier<NotedUIModel>> noteList =
        widget.notedUIModel.value.noteDB.isReply && widget.isShowReply
            ? [widget.notedUIModel]
            : [];
    replyList = [...noteList, ...result];

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
                      _showContentWidget(),
                      _showReplyList(),
                      _noDataWidget(),
                      _placeholderRollWidget(),
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

  Widget _placeholderRollWidget() {
    final renderBox = _contentContainerKey.currentContext?.findRenderObject();
    final replyListRenderBox =
        _replyListContainerKey.currentContext?.findRenderObject();
    final screenHeight = MediaQuery.of(context).size.height;

    if (renderBox == null || replyListRenderBox == null)
      return const SizedBox();

    final size = (renderBox as RenderBox).size;
    final replySize = (replyListRenderBox as RenderBox).size;
    double height = screenHeight - replySize.height - size.height;

    return SizedBox(
      height: height > 0 ? height : 0,
    );
  }

  Widget _showContentWidget() {
    ValueNotifier<NotedUIModel>? model = notedUIModel;
    if (model == null) {
      return MomentWidgetsUtils.emptyNoteMomentWidget(null, 100);
    }
    return Container(
      key: _contentContainerKey,
      child: MomentWidget(
        isShowAllContent: true,
        isShowInteractionData: true,
        isShowReply: widget.isShowReply,
        clickMomentCallback: (ValueNotifier<NotedUIModel> notedUIModel) async {
          if (notedUIModel.value.noteDB.isReply && widget.isShowReply) {
            await OXNavigator.pushPage(
                context, (context) => MomentsPage(notedUIModel: notedUIModel));
            setState(() {});
          }
        },
        notedUIModel: model,
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
      padding: EdgeInsets.only(
        top: 50.px,
      ),
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

  bool isShowReplies = false;

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
      NoteDB? note = await Moment.sharedInstance
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
      NoteDB? note = await Moment.sharedInstance.loadNoteWithNoteId(noteId);
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
        _getReplyList(secondReplyNoted!, 2);
      }
    }

    if (index == 2) {
      thirdReplyNoted = result.isNotEmpty ? result[0] : null;
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        MomentReplyWidget(
          notedUIModel: widget.notedUIModel,
          isShowLink: firstReplyNoted != null,
        ),
        _showRepliesWidget(),
        _firstReplyWidget(),
        _secondReplyWidget(),
        _thirdReplyWidget(),
      ],
    );
  }

  Widget _firstReplyWidget() {
    if (firstReplyNoted == null || !isShowReplies) return const SizedBox();
    return MomentReplyWidget(
      notedUIModel: firstReplyNoted!,
      isShowLink: secondReplyNoted != null,
    );
  }

  Widget _secondReplyWidget() {
    if (secondReplyNoted == null || !isShowReplies) return const SizedBox();
    return MomentReplyWidget(
      notedUIModel: secondReplyNoted!,
      isShowLink: thirdReplyNoted != null,
    );
  }

  Widget _thirdReplyWidget() {
    if (thirdReplyNoted == null || !isShowReplies) return const SizedBox();
    return MomentReplyWidget(notedUIModel: thirdReplyNoted!);
  }

  Widget _showRepliesWidget() {
    if (firstReplyNoted == null || isShowReplies) return const SizedBox();
    return GestureDetector(
      onTap: () {
        isShowReplies = true;
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
                    margin: EdgeInsets.all(8.px),
                    padding: EdgeInsets.only(
                      bottom: 16.px,
                    ),
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
