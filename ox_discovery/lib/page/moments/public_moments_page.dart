import 'dart:ui';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_moment_manager.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:flutter/services.dart';
import 'package:ox_common/widgets/common_pull_refresher.dart';
import 'package:ox_discovery/page/widgets/moment_tips.dart';

import '../widgets/moment_widget.dart';
import 'moments_page.dart';
import 'notifications_moments_page.dart';
import 'package:ox_discovery/model/moment_extension_model.dart';

class PublicMomentsPage extends StatefulWidget {
  const PublicMomentsPage({Key? key}) : super(key: key);

  @override
  State<PublicMomentsPage> createState() => _PublicMomentsPageState();
}

class _PublicMomentsPageState extends State<PublicMomentsPage>
    with OXMomentObserver {
  List<NoteDB> notesList = [];

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
        NoteDB note = notesList[index];
        return MomentWidget(
          noteDB: note,
          clickMomentCallback: () async {
            await OXNavigator.pushPage(
                context, (context) => MomentsPage(noteDB: note));
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

              notesList = [...list,...notesList];
              setState(() {});
            },
          ),
          SizedBox(
            width: 20.px,
          ),
          MomentNotificationTips(
            onTap: () {
              OXNavigator.pushPage(
                  context, (context) => NotificationsMomentsPage());
            },
          ),
        ],
      ),
    );
  }

  Future<void> _updateNotesList(bool isInit)async {
    List<NoteDB> list = await Moment.sharedInstance.loadAllNotesFromDB(until:isInit ?  null : _allNotesFromDBLastTimestamp ,limit: _limit) ?? [];
    List<NoteDB> showList = list.where((NoteDB note) {
      return (note.root == null || (note.root?.isEmpty ?? true)) && (note.reactedId?.isEmpty ?? true);
    }).toList();

    if(list.isEmpty) {
      return  isInit ?  _refreshController.refreshCompleted() : _refreshController.loadNoData();
    }

    notesList.addAll(showList);
    _allNotesFromDBLastTimestamp = list.last.createAt;

    setState(() {});
    if(isInit) {
      _refreshController.refreshCompleted();
    }else{
      if(list.length < _limit){
        _refreshController.loadNoData();
        return;
      }
      _refreshController.loadComplete();
    }
  }


  @override
  didNewNotesCallBackCallBack(List<NoteDB> notes) {
  }

  @override
  didNewNotificationCallBack(List<NotificationDB> notifications) {
  }

}
