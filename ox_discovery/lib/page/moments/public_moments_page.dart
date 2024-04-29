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

  int? _lastTimestamp;

  final int _limit = 50;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }


  void _getDataList() async {
    String? pukbey = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey;
    // List<NoteDB>? noteLst = await Moment.sharedInstance.loadFriendNotes(pukbey ?? '7adb520c3ac7cb6dc8253508df0ce1d975da49fefda9b5c956744a049d230ace');
    List<NoteDB>? noteLst = await Moment.sharedInstance.loadAllNotesFromDB();
    Map<String, NoteDB> list = OXMomentManager.sharedInstance.privateNotesMap;
    if (noteLst != null) {
      notesList = NoteDBEx.getNoteToMomentList(noteLst);
    }
    setState(() {});
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
      enablePullDown: false,
      enablePullUp: true,
      onLoading: () => _loadNotes(),
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
            onTap: () async {
              _getDataList();
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

  @override
  didNewNotesCallBackCallBack(List<NoteDB> notes) {
    _getDataList();
  }

  @override
  didNewNotificationCallBack(List<NotificationDB> notifications) {
    _getDataList();
  }

  Future<void> _loadNotes() async {
    List<NoteDB> list = await Moment.sharedInstance.loadAllNotesFromDB(until: _lastTimestamp,limit: _limit) ?? [];
    list = list.where((NoteDB note) => note.root == null || note.root!.isEmpty).toList();
    if(list.isEmpty)  return _refreshController.loadNoData();
    notesList.addAll(list);
    _lastTimestamp = list.last.createAt;
    setState(() {});
    if(list.length < _limit){
      _refreshController.loadNoData();
      return;
    }
    _refreshController.loadComplete();
  }
}
