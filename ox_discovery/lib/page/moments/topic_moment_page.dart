import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_pull_refresher.dart';

import '../../enum/moment_enum.dart';
import '../../model/moment_ui_model.dart';
import '../widgets/moment_widget.dart';
import 'moments_page.dart';

class TopicMomentPage extends StatefulWidget {
  final String title;
  const TopicMomentPage({Key? key,required this.title}) : super(key: key);

  @override
  State<TopicMomentPage> createState() => _TopicMomentPageState();
}

class _TopicMomentPageState extends State<TopicMomentPage> {

  List<NotedUIModel>? notesList;

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
    List<NotedUIModel>? modelList = notesList;
    if(modelList == null) return const SizedBox();
    if(modelList.isEmpty) return _noDataWidget();
    return ListView.builder(
      primary: false,
      controller: null,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: modelList.length,
      itemBuilder: (context, index) {
        NotedUIModel notedUIModel = modelList[index];
        return MomentWidget(
          notedUIModel: notedUIModel,
          clickMomentCallback: (NotedUIModel notedUIModel) async {
            await OXNavigator.pushPage(
                context, (context) => MomentsPage(notedUIModel: notedUIModel));
          },
        );
      },
    );
  }

  Widget _noDataWidget() {
    return Padding(
      padding: EdgeInsets.only(
        top: 100.px,
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
              'No Topic !',
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

  Future<void> _updateNotesList(bool isInit)async {
    if(isInit) OXLoading.show();

    List<NoteDB> list = await Moment.sharedInstance.loadHashTagsFromRelay([widget.title.substring(1)], limit: _limit, until:_lastTimestamp) ?? [];
    if(isInit) OXLoading.dismiss();

    list = list.where((NoteDB note) => note.getNoteKind() != ENotificationsMomentType.like.kind).toList();

    (notesList ??= []).addAll(list.map((note) => NotedUIModel(noteDB: note)).toList());
    _lastTimestamp = list.isEmpty ? null : list.last.createAt;
    setState(() {});

    if(list.isEmpty) {
      return isInit ?  _refreshController.refreshCompleted() : _refreshController.loadNoData();
    }

    if(isInit) {
      _refreshController.refreshCompleted();
      return;
    }

    if(list.length < _limit){
      _refreshController.loadNoData();
      return;
    }
    _refreshController.loadComplete();
  }
}

