import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_moment_manager.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_pull_refresher.dart';
import 'package:ox_discovery/model/moment_extension_model.dart';
import 'package:ox_localizable/ox_localizable.dart';
import '../../enum/moment_enum.dart';
import '../../model/moment_ui_model.dart';
import '../../utils/album_utils.dart';
import '../widgets/moment_widget.dart';
import 'create_moments_page.dart';
import 'moments_page.dart';

class GroupMomentsPage extends StatefulWidget {
  final String groupId;
  const GroupMomentsPage({Key? key, required this.groupId}) : super(key: key);

  @override
  State<GroupMomentsPage> createState() => GroupMomentsPageState();
}

class GroupMomentsPageState extends State<GroupMomentsPage>
    with OXMomentObserver, OXUserInfoObserver {
  final int _limit = 50;
  List<ValueNotifier<NotedUIModel>> notesList = [];
  int? _allNotesFromDBLastTimestamp;
  final RefreshController _refreshController = RefreshController();

  String _groupName = '';

  @override
  void initState() {
    super.initState();
    OXMomentManager.sharedInstance.addObserver(this);
    updateNotesList(true);
    _getGroupInfo();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    OXMomentManager.sharedInstance.removeObserver(this);
    super.dispose();
  }

  onThemeStyleChange() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color200,
      appBar: CommonAppBar(
        backgroundColor: ThemeColor.color200,
        title: _groupName,
        actions: [
          _createMomentsBtnWidget(),
          SizedBox(
            width: 24.px,
          )
        ],
      ),
      body: OXSmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: () => updateNotesList(true),
        onLoading: () => updateNotesList(false),
        child: _getMomentListWidget(),
      ),
    );
  }

  Widget _createMomentsBtnWidget() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: CommonImage(
        iconName: "moment_add_icon.png",
        width: Adapt.px(24),
        height: Adapt.px(24),
        color: ThemeColor.white,
        package: 'ox_discovery',
      ),
      onLongPress: ()async {
       await OXNavigator.presentPage(
            context,
            (context) => CreateMomentsPage(
                type: EMomentType.content,
                groupId: widget.groupId,
                sendMomentsType: EOptionMomentsType.group,
            ));
       updateNotesList(true);
      },
      onTap: () async{
        CreateMomentDraft? createMomentMediaDraft =
            OXMomentCacheManager.sharedInstance.createMomentMediaDraft;
        if (createMomentMediaDraft != null) {
          final type = createMomentMediaDraft.type;
          final imageList = type == EMomentType.picture ? createMomentMediaDraft.imageList : null;
          final videoPath = type == EMomentType.video ? createMomentMediaDraft.videoPath : null;
          final videoImagePath = type == EMomentType.video ? createMomentMediaDraft.videoImagePath : null;
         await OXNavigator.presentPage(
            context,
            (context) => CreateMomentsPage(
              type: type,
              imageList: imageList,
              videoPath: videoPath,
              videoImagePath: videoImagePath,
              groupId: widget.groupId,
              sendMomentsType: EOptionMomentsType.group,
            ),
          );
          updateNotesList(true);
          return;
        }
       await OXNavigator.presentPage(context, (context) => CreateMomentsPage(
          type: null,
          groupId: widget.groupId,
          sendMomentsType: EOptionMomentsType.group,
        ));
        updateNotesList(true);
      },
    );
  }

  Widget _getMomentListWidget() {
    if(notesList.isEmpty) return _noDataWidget();
    return ListView.builder(
      primary: false,
      controller: null,
      shrinkWrap: false,
      itemCount: notesList.length,
      itemBuilder: (context, index) {
        ValueNotifier<NotedUIModel> notedUIModel = notesList[index];

        return MomentWidget(
          isShowReplyWidget: true,
          notedUIModel: notedUIModel,
          clickMomentCallback: (ValueNotifier<NotedUIModel> notedUIModel) async {
            await OXNavigator.pushPage(
                context, (context) => MomentsPage(
                notedUIModel: notedUIModel,
            ));
          },
        ).setPadding(EdgeInsets.symmetric(horizontal: 24.px));
      },
    );
  }

  Widget _buildCreateMomentBottomDialog() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(12)),
        color: ThemeColor.color180,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildItem(
            Localized.text('ox_discovery.choose_camera_option'),
            index: -1,
            onTap: () {
              OXNavigator.pop(context);
              AlbumUtils.openCamera(context, (List<String> imageList)async {
               await OXNavigator.presentPage(
                  context,
                  (context) => CreateMomentsPage(
                    type: EMomentType.picture,
                    imageList: imageList,
                    groupId: widget.groupId,
                    sendMomentsType: EOptionMomentsType.group,
                  ),
                );
              });
            },
          ),
          Divider(
            color: ThemeColor.color170,
            height: Adapt.px(0.5),
          ),
          _buildItem(
            Localized.text('ox_discovery.choose_image_option'),
            index: -1,
            onTap: () {
              OXNavigator.pop(context);
              AlbumUtils.openAlbum(context, type: 1,
                  callback: (List<String> imageList) async{
               await OXNavigator.presentPage(
                  context,
                  (context) => CreateMomentsPage(
                    type: EMomentType.picture,
                    imageList: imageList,
                    groupId: widget.groupId,
                    sendMomentsType: EOptionMomentsType.group,
                  ),
                );
              });
            },
          ),
          Divider(
            color: ThemeColor.color170,
            height: Adapt.px(0.5),
          ),
          _buildItem(
            Localized.text('ox_discovery.choose_video_option'),
            index: -1,
            onTap: () {
              OXNavigator.pop(context);
              AlbumUtils.openAlbum(context, type: 2, selectCount: 1,
                  callback: (List<String> imageList) async{
               await OXNavigator.presentPage(
                  context,
                  (context) => CreateMomentsPage(
                    type: EMomentType.video,
                    videoPath: imageList[0],
                    videoImagePath: imageList[1],
                    groupId: widget.groupId,
                    sendMomentsType: EOptionMomentsType.group,
                  ),
                );
              });
            },
          ),
          Divider(
            color: ThemeColor.color170,
            height: Adapt.px(0.5),
          ),
          Container(
            height: Adapt.px(8),
            color: ThemeColor.color190,
          ),
          _buildItem(Localized.text('ox_common.cancel'), index: 3, onTap: () {
            OXNavigator.pop(context);
          }),
          SizedBox(
            height: Adapt.px(21),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String title,
      {required int index, GestureTapCallback? onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: Adapt.px(56),
        child: Text(
          title,
          style: TextStyle(
            color: ThemeColor.color0,
            fontSize: Adapt.px(16),
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      onTap: onTap,
    );
  }

  Future<void> updateNotesList(bool isInit) async {
    try {
      List<NoteDBISAR> list = await RelayGroup.sharedInstance.loadGroupNotesFromDB(
              widget.groupId,
              until: isInit ? null : _allNotesFromDBLastTimestamp,
              limit: _limit) ??
          [];
      if (list.isEmpty) {
        isInit
            ? _refreshController.refreshCompleted()
            : _refreshController.loadNoData();
        return;
      }

      List<NoteDBISAR> showList = _filterNotes(list);
      _updateUI(showList, isInit, list.length);

      if (list.length < _limit) {
        _refreshController.loadNoData();
      }
    } catch (e) {
      print('Error loading notes: $e');
      _refreshController.loadFailed();
    }
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
              'No Group Note',
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

  void _getGroupInfo() {
    RelayGroupDBISAR? groupDB = RelayGroup.sharedInstance.myGroups[widget.groupId];
    if(groupDB == null) return;
    _groupName = groupDB.name;
    if(mounted){
      setState(() {});
    }
  }

  List<NoteDBISAR> _filterNotes(List<NoteDBISAR> list) {
    return list
        .where(
            (NoteDBISAR note) => !note.isReaction && note.getReplyLevel(null) < 2)
        .toList();
  }

  void _updateUI(List<NoteDBISAR> showList, bool isInit, int fetchedCount) {
    List<ValueNotifier<NotedUIModel>> list = showList
        .map((note) => ValueNotifier(NotedUIModel(noteDB: note)))
        .toList();
    if (isInit) {
      notesList = list;
    } else {
      notesList.addAll(list);
    }

    _allNotesFromDBLastTimestamp = showList.last.createAt;

    if (isInit) {
      _refreshController.refreshCompleted();
    } else {
      fetchedCount < _limit
          ? _refreshController.loadNoData()
          : _refreshController.loadComplete();
    }
    setState(() {});
  }

  @override
  didNewNotesCallBackCallBack(List<NoteDBISAR> notes) {}

  @override
  didNewNotificationCallBack(List<NotificationDBISAR> notifications) {}

  @override
  didGroupsNoteCallBack(NoteDBISAR notes) {
    if(notes.groupId == widget.groupId){
      notesList = [...[ValueNotifier(NotedUIModel(noteDB: notes))],...notesList];
      setState(() {});
    }
  }

  @override
  void didLoginSuccess(UserDBISAR? userInfo) {}

  @override
  void didLogout() {}

  @override
  void didSwitchUser(UserDBISAR? userInfo) {}
}
