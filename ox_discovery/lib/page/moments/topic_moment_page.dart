import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/ox_moment_manager.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_pull_refresher.dart';

import '../../model/moment_ui_model.dart';
import '../widgets/moment_widget.dart';

class TopicMomentPage extends StatefulWidget {
  final String title;
  const TopicMomentPage({Key? key,required this.title}) : super(key: key);

  @override
  State<TopicMomentPage> createState() => _TopicMomentPageState();
}

class _TopicMomentPageState extends State<TopicMomentPage> {

  List<NoteDB> notesList = [];

  final RefreshController _refreshController = RefreshController();

  int? _lastTimestamp;

  final int _limit = 50;

  @override
  void initState() {
    super.initState();
    _updateNotesList(true);

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color200,
      appBar: CommonAppBar(
        backgroundColor: ThemeColor.color200,
        title: widget.title,
      ),
      body: OXSmartRefresher(
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
                _getMomentListWidget(),
              ],
            ),
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
          notedUIModel: NotedUIModel(noteDB:note),
          clickMomentCallback: () async {
            // await OXNavigator.pushPage(
            //     context, (context) => MomentsPage(noteDB: note));
          },
        );
      },
    );
  }

  Future<void> _updateNotesList(bool isInit)async {
    List<NoteDB>? list = await Moment.sharedInstance.loadHashTagsFromRelay([widget.title.substring(1)]);
    print('===list===${list}');
    // List<NoteDB> list = await Moment.sharedInstance.loadAllNotesFromDB(until:isInit ?  null : _lastTimestamp ,limit: _limit) ?? [];
    if(list == null) return isInit ?  _refreshController.refreshCompleted() : _refreshController.loadNoData();
    list = list.where((NoteDB note) {
      return (note.root == null || (note.root?.isEmpty ?? true)) && (note.reactedId?.isEmpty ?? true);
    }).toList();

    if(list.isEmpty) {
      return  isInit ?  _refreshController.refreshCompleted() : _refreshController.loadNoData();
    }

    notesList.addAll(list);
    _lastTimestamp = list.last.createAt;

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
}

