import 'dart:ui';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:flutter/services.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_discovery/model/moment_extension_model.dart';
import '../../model/moment_ui_model.dart';
import '../../utils/discovery_utils.dart';
import '../../utils/moment_widgets_utils.dart';
import '../widgets/moment_widget.dart';
import '../widgets/simple_moment_reply_widget.dart';
import '../widgets/youtube_player_widget.dart';

class MomentsPage extends StatefulWidget {
  final bool isShowReply;
  final ValueNotifier<NotedUIModel> notedUIModel;
  const MomentsPage(
      {Key? key, required this.notedUIModel, this.isShowReply = true})
      : super(key: key);

  @override
  State<MomentsPage> createState() => _MomentsPageState();
}

class _MomentsPageState extends State<MomentsPage> {
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
    super.dispose();
  }

  void _dataPre() async {
    _getReplyList();
  }

  void _getReplyList() async {
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
          title: 'Moment',
        ),
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              child: SingleChildScrollView(
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
                      ..._showReplyList(),
                      _noDataWidget(),
                    ],
                  ),
                ),
              ),
            ),
            _isShowMaskWidget(),
            _showSimpleReplyWidget(),
          ],
        ),
      ),
    );
  }

  Widget _showContentWidget() {
    ValueNotifier<NotedUIModel>? model = notedUIModel;
    if (model == null)
      return MomentWidgetsUtils.emptyNoteMoment('Moment not found !', 300);
    return MomentWidget(
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
        isFocusedCallback: (focusStatus) {
          if (focusStatus == _isShowMask) return;
          setState(() {
            _isShowMask = focusStatus;
          });
        },
      ),
    );
  }

  List<Widget> _showReplyList() {
    return replyList.map((ValueNotifier<NotedUIModel> notedUIModelDraft) {
      int index = replyList.indexOf(notedUIModelDraft);
      if (notedUIModelDraft.value.noteDB.noteId ==
              widget.notedUIModel.value.noteDB.noteId &&
          index != 0) return const SizedBox();
      if (notedUIModel != null &&
          !notedUIModelDraft.value.noteDB
              .isFirstLevelReply(notedUIModel?.value.noteDB.noteId)) {
        return const SizedBox();
      }
      return MomentReplyWidget(
        index: index,
        notedUIModel: notedUIModelDraft,
      );
    }).toList();
  }

  Widget _isShowMaskWidget() {
    if (!_isShowMask) return const SizedBox();
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.transparent,
    );
  }

  Widget _showRepliesWidget() {
    return Container(
      padding: EdgeInsets.only(
        left: 12.px,
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
            'Show replies',
            style: TextStyle(
              color: ThemeColor.purple2,
              fontSize: 12.px,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
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
              'No Reply !',
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

class MomentReplyWidget extends StatefulWidget {
  final ValueNotifier<NotedUIModel> notedUIModel;
  final int index;

  const MomentReplyWidget({
    super.key,
    required this.notedUIModel,
    required this.index,
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
      setState(() {});
    }
  }

  void _getMomentUserInfo()async {
    String pubKey = widget.notedUIModel.value.noteDB.author;
    Account.sharedInstance.getUserInfo(pubKey);
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
        child: ValueListenableBuilder<UserDB>(
            valueListenable: Account.sharedInstance.userCache[pubKey] ?? ValueNotifier(UserDB(pubKey: pubKey ?? '')),
            builder: (context, value, child) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      MomentWidgetsUtils.clipImage(
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
                            clickMomentCallback: (ValueNotifier<NotedUIModel>
                                notedUIModel) async {
                              await OXNavigator.pushPage(
                                  context,
                                  (context) => MomentsPage(
                                      notedUIModel: widget.notedUIModel,
                                      isShowReply: false));
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  Widget _momentUserInfoWidget(UserDB userDB) {
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
