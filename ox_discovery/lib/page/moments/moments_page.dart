import 'dart:ui';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/ox_moment_manager.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:flutter/services.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_discovery/model/moment_extension_model.dart';

import '../../model/moment_ui_model.dart';
import '../../utils/discovery_utils.dart';
import '../widgets/moment_rich_text_widget.dart';
import '../../utils/moment_widgets_utils.dart';
import '../widgets/moment_widget.dart';
import '../widgets/simple_moment_reply_widget.dart';

class MomentsPage extends StatefulWidget {
  final bool isShowReply;
  final NotedUIModel notedUIModel;
  const MomentsPage(
      {Key? key, required this.notedUIModel, this.isShowReply = true})
      : super(key: key);

  @override
  State<MomentsPage> createState() => _MomentsPageState();
}

class _MomentsPageState extends State<MomentsPage> {
  bool _isShowMask = false;

  List<NotedUIModel> replyList = [];

  NotedUIModel? notedUIModel;

  @override
  void initState() {
    super.initState();
    _getReplyList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getReplyList()async {
    NotedUIModel notedUIModelDraft = widget.notedUIModel;
    notedUIModel = widget.notedUIModel;
    if (notedUIModelDraft.noteDB.isReply && widget.isShowReply) {
      String? getReplyId = notedUIModelDraft.noteDB.getReplyId;
      if (getReplyId != null) {
        NoteDB? note = await Moment.sharedInstance.loadNoteWithNoteId(getReplyId);
        if (note == null) return;
        replyList = [widget.notedUIModel];
        notedUIModel = NotedUIModel(noteDB: note);
      }
    }
    setState(() {});
    _getReplyFromDB(notedUIModel!);
    Map<String, List<dynamic>> map = await Moment.sharedInstance.loadNoteActions(notedUIModel!.noteDB.noteId);
    _getReplyFromRelay(notedUIModel!);
  }

  void _getReplyFromRelay(NotedUIModel notedUIModelDraft)async {
    NoteDB? note = await Moment.sharedInstance.loadNoteWithNoteId(notedUIModelDraft.noteDB.noteId);
    if(note == null) return;
    NotedUIModel newNotedUIModel = NotedUIModel(noteDB: note);
    notedUIModel = newNotedUIModel;
    setState(() {});
    _getReplyFromDB(newNotedUIModel);

  }

  void _getReplyFromDB(NotedUIModel notedUIModelDraft)async {
    List<String>? replyEventIds = notedUIModelDraft.noteDB.replyEventIds;
    if(replyEventIds == null) return;

    List<NotedUIModel> result = [];
    for (String noteId in replyEventIds) {
      NoteDB? note = await Moment.sharedInstance.loadNoteWithNoteId(noteId);
      if (note != null) result.add(NotedUIModel(noteDB: note));
    }
    List<NotedUIModel> noteList = widget.notedUIModel.noteDB.isReply ? [widget.notedUIModel] : [];
    replyList = [...noteList,...result];
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    NotedUIModel? model = notedUIModel;

    if (model == null) return const SizedBox();
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
                      MomentWidget(
                        isShowInteractionData: true,
                        isShowReply: widget.isShowReply,
                        clickMomentCallback: (NotedUIModel notedUIModel) async {
                          if (notedUIModel.noteDB.isReply &&
                              widget.isShowReply) {
                            await OXNavigator.pushPage(
                                context,
                                (context) =>
                                    MomentsPage(notedUIModel: notedUIModel));
                          }
                        },
                        notedUIModel: model,
                      ),
                      ..._showReplyList(),
                      _noDataWidget(),
                    ],
                  ),
                ),
              ),
            ),
            _isShowMaskWidget(),
            Positioned(
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
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _showReplyList() {
    if(notedUIModel == null) return [const SizedBox()];
    return replyList.map((NotedUIModel notedUIModelDraft) {
      int index = replyList.indexOf(notedUIModelDraft);
      if (notedUIModelDraft.noteDB.noteId == widget.notedUIModel.noteDB.noteId && index != 0) return const SizedBox();
      if (!notedUIModelDraft.noteDB.isFirstLevelReply) return const SizedBox();
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
  final NotedUIModel notedUIModel;
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
  UserDB? momentUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMomentUser();
  }

  void _getMomentUser() async {
    String pubKey = widget.notedUIModel.noteDB.author;
    UserDB? user = await Account.sharedInstance.getUserInfo(pubKey);
    momentUser = user;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _momentItemWidget();
  }

  Widget _momentItemWidget() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        OXNavigator.pushPage(
            context,
            (context) => MomentsPage(
                notedUIModel: widget.notedUIModel, isShowReply: false));
      },
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                MomentWidgetsUtils.clipImage(
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
                    _momentUserInfoWidget(),
                    MomentWidget(
                      isShowReply: false,
                      notedUIModel: widget.notedUIModel,
                      isShowUserInfo: false,
                      clickMomentCallback: (NotedUIModel notedUIModel) {
                        OXNavigator.pushPage(
                            context,
                            (context) => MomentsPage(
                                notedUIModel: notedUIModel,
                                isShowReply: false));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _momentUserInfoWidget() {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: momentUser?.name ?? '--',
            style: TextStyle(
              color: ThemeColor.color0,
              fontSize: 14.px,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: ' ' + DiscoveryUtils.getUserMomentInfo(
                momentUser, widget.notedUIModel.createAtStr)[0],
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
