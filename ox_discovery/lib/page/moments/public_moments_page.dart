import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_moment_manager.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_pull_refresher.dart';
import 'package:ox_discovery/model/moment_extension_model.dart';
import 'package:ox_discovery/page/widgets/moment_tips.dart';
import 'package:ox_localizable/ox_localizable.dart';

import '../../model/moment_ui_model.dart';
import '../widgets/moment_widget.dart';
import 'moments_page.dart';
import 'notifications_moments_page.dart';

enum EPublicMomentsPageType { all, public, private }

extension EPublicMomentsPageTypeEx on EPublicMomentsPageType {
  bool? get getValue {
    switch (this) {
      case EPublicMomentsPageType.all:
        return null;
      case EPublicMomentsPageType.public:
        return false;
      case EPublicMomentsPageType.private:
        return true;
    }
  }

  String get text {
    switch (this) {
      case EPublicMomentsPageType.all:
        return Localized.text('ox_discovery.all');
      case EPublicMomentsPageType.public:
        return Localized.text('ox_discovery.public');
      case EPublicMomentsPageType.private:
        return Localized.text('ox_discovery.private');
    }
  }
}

class PublicMomentsPage extends StatefulWidget {
  final EPublicMomentsPageType publicMomentsPageType;
  const PublicMomentsPage(
      {Key? key, this.publicMomentsPageType = EPublicMomentsPageType.all})
      : super(key: key);

  @override
  State<PublicMomentsPage> createState() => PublicMomentsPageState();
}

class PublicMomentsPageState extends State<PublicMomentsPage>
    with OXMomentObserver {
  List<ValueNotifier<NotedUIModel>> notesList = [];

  final RefreshController _refreshController = RefreshController();

  int? _allNotesFromDBLastTimestamp;

  final int _limit = 50;

  final ScrollController momentScrollController = ScrollController();

  ValueNotifier<double> tipContainerHeight = ValueNotifier(0);

  ValueNotifier<bool> hasNotificationTips = ValueNotifier(true);
  ValueNotifier<bool> hasNewPostTips = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    OXMomentManager.sharedInstance.addObserver(this);
    updateNotesList(true);
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.publicMomentsPageType != oldWidget.publicMomentsPageType) {
      if (mounted) {
        notesList = [];
        _allNotesFromDBLastTimestamp = null;
      }
      updateNotesList(true);
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        OXSmartRefresher(
          scrollController: momentScrollController,
          controller: _refreshController,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: () => updateNotesList(true),
          onLoading: () => updateNotesList(false),
          child: _getMomentListWidget(),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Center(
            child: _newMomentTipsWidget(),
          ),
        ),
      ],
    );
  }

  Widget _getMomentListWidget() {
    return ListView.builder(
      primary: false,
      controller: null,
      shrinkWrap: false,
      itemCount: notesList.length,
      itemBuilder: (context, index) {
        ValueNotifier<NotedUIModel> notedUIModel = notesList[index];

        if(index == 0){
          return ValueListenableBuilder<double>(
            valueListenable: tipContainerHeight,
            builder: (context, value, child) {
              return  Container(
                padding: EdgeInsets.only(top: value),
                child: MomentWidget(
                  isShowReplyWidget: true,
                  notedUIModel: notedUIModel,
                  clickMomentCallback: (ValueNotifier<NotedUIModel> notedUIModel) async {
                    await OXNavigator.pushPage(
                        context, (context) => MomentsPage(notedUIModel: notedUIModel));
                  },
                ).setPadding(EdgeInsets.symmetric(horizontal: 24.px)),
              );
            },
          );
        }

        return MomentWidget(
          isShowReplyWidget: true,
          notedUIModel: notedUIModel,
          clickMomentCallback: (ValueNotifier<NotedUIModel> notedUIModel) async {
            await OXNavigator.pushPage(
                context, (context) => MomentsPage(notedUIModel: notedUIModel));
          },
        ).setPadding(EdgeInsets.symmetric(horizontal: 24.px));
      },
    );
  }

  Widget _newMomentTipsWidget() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MomentNewPostTips(
            onTap: (List<NoteDB> list,bool isHidden) {
              double getHeight;
              if(isHidden){
                updateNotesList(true);
                momentScrollController.animateTo(
                  0.0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
                getHeight = 0;
              }else{
                getHeight = list.isEmpty ? 0 : 52;
              }
              hasNewPostTips.value = getHeight > 0;
              tipContainerHeight.value = hasNotificationTips.value ? 52 : getHeight;
            },
          ),
          SizedBox(
            width: 20.px,
          ),
          MomentNotificationTips(
            onTap: ({List<NotificationDB>? notificationDBList,bool? isHidden}) {
              double getHeight;
              if(isHidden!){
                getHeight = 0;
                OXNavigator.pushPage(context, (context) => const NotificationsMomentsPage());
              }else{
                getHeight = notificationDBList!.isEmpty ? 0 : 52;
              }
              hasNotificationTips.value = getHeight > 0;
              tipContainerHeight.value = hasNewPostTips.value ? 52 : getHeight;
            },
          ),
        ],
      ),
    );
  }

  Future<void> updateNotesList(bool isInit, {bool isWrapRefresh = false}) async {
    bool isPrivateMoment = widget.publicMomentsPageType == EPublicMomentsPageType.private;
    if(isWrapRefresh){
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _refreshController.requestRefresh();
          }
        });
    }
    try {
      List<NoteDB> list = await Moment.sharedInstance.loadMomentNotesFromDB(private: widget.publicMomentsPageType.getValue,until: isInit ? null : _allNotesFromDBLastTimestamp, limit: _limit) ?? [];
      if (list.isEmpty) {
        isInit ? _refreshController.refreshCompleted() : _refreshController.loadNoData();
        if(!isPrivateMoment) await _getNotesFromRelay();
        return;
      }

      List<NoteDB> showList = _filterNotes(list);
      _updateUI(showList, isInit, list.length);

      if (list.length < _limit ) {
        !isPrivateMoment ? await _getNotesFromRelay() : _refreshController.loadNoData();
      }
    } catch (e) {
      print('Error loading notes: $e');
      _refreshController.loadFailed();
    }
  }

  Future<void> _getNotesFromRelay() async {
    try {
      List<NoteDB> list = await Moment.sharedInstance.loadPublicNewNotesFromRelay(until: _allNotesFromDBLastTimestamp,limit:_limit) ?? [];
      if (list.isEmpty) {
        _refreshController.loadNoData();
        return;
      }

      List<NoteDB> showList = _filterNotes(list);
      _updateUI(showList, false, list.length);
    } catch (e) {
      print('Error loading notes from relay: $e');
      _refreshController.loadFailed();
    }
  }

  List<NoteDB> _filterNotes(List<NoteDB> list) {
    return list.where((NoteDB note) => !note.isReaction && note.getReplyLevel(null) < 2).toList();
  }

  void _updateUI(List<NoteDB> showList, bool isInit, int fetchedCount) {
    List<ValueNotifier<NotedUIModel>> list = showList.map((note) => ValueNotifier(NotedUIModel(noteDB: note))).toList();
    if(isInit){
      notesList = list;
    }else{
      notesList.addAll(list);
    }

    _allNotesFromDBLastTimestamp = showList.last.createAt;

    if(isInit){
      _refreshController.refreshCompleted();
    }else{
      fetchedCount < _limit ? _refreshController.loadNoData() : _refreshController.loadComplete();
    }
    setState(() {});
  }
}
