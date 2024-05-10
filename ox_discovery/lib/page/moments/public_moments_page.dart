import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_moment_manager.dart';
import 'package:ox_common/widgets/common_pull_refresher.dart';
import 'package:ox_discovery/model/moment_extension_model.dart';
import 'package:ox_discovery/page/widgets/moment_tips.dart';

import '../../enum/moment_enum.dart';
import '../../model/moment_ui_model.dart';
import '../widgets/moment_widget.dart';
import 'moments_page.dart';
import 'notifications_moments_page.dart';

class PublicMomentsPage extends StatefulWidget {
  const PublicMomentsPage({Key? key}) : super(key: key);

  @override
  State<PublicMomentsPage> createState() => _PublicMomentsPageState();
}

class _PublicMomentsPageState extends State<PublicMomentsPage>
    with OXMomentObserver {
  List<NotedUIModel> notesList = [];

  final RefreshController _refreshController = RefreshController();

  int? _allNotesFromDBLastTimestamp;

  int? _allNotesFromDBFromRelayLastTimestamp;

  final int _limit = 50;

  @override
  void initState() {
    super.initState();
    _updateNotesList(true);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OXSmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      enablePullUp: true,
      onRefresh: () => _updateNotesList(true),
      onLoading: () => _updateNotesList(false),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 24.px,
          ),
          margin: EdgeInsets.only(
            bottom: 100.px,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _newMomentTipsWidget(),
              _getMomentListWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getMomentListWidget() {
    return ListView.builder(
      primary: false,
      controller: null,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: notesList.length,
      itemBuilder: (context, index) {
        NotedUIModel notedUIModel = notesList[index];
        return MomentWidget(
          isShowReplyWidget: true,
          notedUIModel: notedUIModel,
          clickMomentCallback: (NotedUIModel notedUIModel) async {
            await OXNavigator.pushPage(
                context, (context) => MomentsPage(notedUIModel: notedUIModel));
          },
        );
      },
    );
  }

  Widget _newMomentTipsWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.px),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MomentNewPostTips(
            onTap: (List<NoteDB> list)  {

              notesList = [...list.map((NoteDB note) => NotedUIModel(noteDB: note)).toList(),...notesList];
              setState(() {});
            },
          ),
          SizedBox(
            width: 20.px,
          ),
          MomentNotificationTips(
            onTap: () {
              OXNavigator.pushPage(
                  context, (context) => const NotificationsMomentsPage());
            },
          ),
        ],
      ),
    );
  }

  Future<void> _updateNotesList(bool isInit) async {
    try {
      List<NoteDB> list = await Moment.sharedInstance.loadAllNotesFromDB(until: isInit ? null : _allNotesFromDBLastTimestamp, limit: _limit) ?? [];

      if (list.isEmpty) {
        isInit ? _refreshController.refreshCompleted() : _refreshController.loadNoData();
        await _getNotesFromRelay();
        return;
      }

      List<NoteDB> showList = _filterNotes(list);
      _updateUI(showList, isInit, list.length);

      if (list.length < _limit) {
        await _getNotesFromRelay();
      }
    } catch (e) {
      print('Error loading notes: $e');
      _refreshController.loadFailed();
    }
  }

  Future<void> _getNotesFromRelay() async {
    try {
      List<NoteDB> list = await Moment.sharedInstance.loadNewNotesFromRelay(until: _allNotesFromDBFromRelayLastTimestamp, limit: _limit) ?? [];
      if (list.isEmpty) {
        _refreshController.loadNoData();
        return;
      }

      List<NoteDB> showList = _filterNotes(list);
      notesList.addAll(showList.map((note) => NotedUIModel(noteDB: note)).toList());
      _allNotesFromDBFromRelayLastTimestamp = list.last.createAt;

      setState(() {});
      _refreshController.loadComplete();
    } catch (e) {
      print('Error loading notes from relay: $e');
      _refreshController.loadFailed();
    }
  }

  List<NoteDB> _filterNotes(List<NoteDB> list) {
    return list.where((NoteDB note) => !note.isReaction && note.getReplyLevel() < 2).toList();
  }

  void _updateUI(List<NoteDB> showList, bool isInit, int fetchedCount) {
    notesList.addAll(showList.map((note) => NotedUIModel(noteDB: note)).toList());
    _allNotesFromDBLastTimestamp = showList.last.createAt;

    if(isInit){
      _refreshController.refreshCompleted();
    }else{
      fetchedCount < _limit ? _refreshController.loadNoData() : _refreshController.loadComplete();
    }

    setState(() {});
  }


  @override
  didNewNotesCallBackCallBack(List<NoteDB> notes) {
  }

  @override
  didNewNotificationCallBack(List<NotificationDB> notifications) {
  }

}
