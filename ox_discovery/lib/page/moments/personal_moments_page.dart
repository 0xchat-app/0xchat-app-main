import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/upload/file_type.dart';
import 'package:ox_common/upload/upload_utils.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:extended_sliver/extended_sliver.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_common/widgets/common_pull_refresher.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_discovery/enum/moment_enum.dart';
import 'package:ox_discovery/model/moment_ui_model.dart';
import 'package:ox_discovery/page/moments/moments_page.dart';
import 'package:ox_discovery/page/moments/notifications_moments_page.dart';
import 'package:ox_discovery/page/widgets/contact_info_widget.dart';
import 'package:ox_discovery/page/widgets/moment_bottom_sheet_dialog.dart';
import 'package:ox_discovery/page/widgets/moment_follow_widget.dart';
import 'package:ox_discovery/page/widgets/moment_tips.dart';
import 'package:ox_discovery/page/widgets/moment_widget.dart';
import 'package:ox_discovery/page/widgets/style_date.dart';
import 'package:ox_discovery/utils/album_utils.dart';
import 'package:ox_discovery/utils/moment_widgets_utils.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:chatcore/chat-core.dart';

class PersonMomentsPage extends StatefulWidget {
  final UserDBISAR userDB;
  const PersonMomentsPage({super.key, required this.userDB});

  @override
  State<PersonMomentsPage> createState() => _PersonMomentsPageState();
}

class _PersonMomentsPageState extends State<PersonMomentsPage>
    with CommonStateViewMixin, AutomaticKeepAliveClientMixin {
  bool get isCurrentUser =>
      OXUserInfoManager.sharedInstance.isCurrentUser(widget.userDB.pubKey);
  final RefreshController _refreshController = RefreshController();
  final List<NoteDBISAR> _notes = [];
  final Map<DateTime, List<NoteDBISAR>> _groupedNotes = {};

  final int _limit = 50;
  int? _lastTimestamp;
  bool _isLoadNotesFromRelay = false;

  @override
  void initState() {
    super.initState();
    _loadNotesFromDB();
    Future.delayed(Duration(seconds: 1), () {
      _loadnewNotesFromRelay();
    });
  }

  @override
  stateViewCallBack(CommonStateView commonStateView) {
    switch (commonStateView) {
      case CommonStateView.CommonStateView_None:
        break;
      case CommonStateView.CommonStateView_NetworkError:
        break;
      case CommonStateView.CommonStateView_NoData:
        break;
      case CommonStateView.CommonStateView_NotLogin:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return OXSmartRefresher(
        controller: _refreshController,
        enablePullDown: false,
        enablePullUp: true,
        onLoading: () =>
            _isLoadNotesFromRelay ? _loadNotesFromRelay() : _loadNotesFromDB(),
        child: ListView.builder(
          physics: ClampingScrollPhysics(), // 禁用回弹效果
          primary: true,
          controller: null,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            List<DateTime> keys = _groupedNotes.keys.toList();
            DateTime dateTime = keys[index];
            List<NoteDBISAR> notes = _groupedNotes[dateTime] ?? [];
            return _buildGroupedMomentItem(notes);
          },
          itemCount: _groupedNotes.keys.length,
        ));
    return Scaffold(
        backgroundColor: ThemeColor.color190,
        body: OXSmartRefresher(
          controller: _refreshController,
          enablePullDown: false,
          enablePullUp: true,
          onLoading: () => _isLoadNotesFromRelay
              ? _loadNotesFromRelay()
              : _loadNotesFromDB(),
          child: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: <Widget>[
              _buildAppBar(),
              SliverToBoxAdapter(
                child: ContactInfoWidget(
                  userDB: widget.userDB,
                ).setPaddingOnly(bottom: 20.px),
              ),
              SliverToBoxAdapter(
                child: isCurrentUser ? _buildNotificationTips() : Container(),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 24.px),
                sliver: _groupedNotes.isNotEmpty
                    ? SliverToBoxAdapter(
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            List<DateTime> keys = _groupedNotes.keys.toList();
                            DateTime dateTime = keys[index];
                            List<NoteDBISAR> notes =
                                _groupedNotes[dateTime] ?? [];
                            return _buildGroupedMomentItem(notes);
                          },
                          itemCount: _groupedNotes.keys.length,
                        ),
                      )
                    : SliverToBoxAdapter(
                        child: commonStateViewWidget(
                          context,
                          Container(),
                        ),
                      ),
              ),
            ],
          ),
        ));
  }

  Widget _buildAppBar() {
    return ExtendedSliverAppbar(
      toolBarColor: ThemeColor.color190,
      leading: IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: CommonImage(
          iconName: "icon_back_left_arrow.png",
          width: 24.px,
          height: 24.px,
          useTheme: true,
        ),
        onPressed: () {
          OXNavigator.pop(context);
        },
      ),
      background: Container(
        color: ThemeColor.color190,
        height: 310.px,
        child: Stack(
          children: <Widget>[
            _buildCoverImage(),
            _buildContactOperation(),
          ],
        ),
      ),
      actions: GestureDetector(
        onTap: () {
          final items = [
            BottomItemModel(
                title: Localized.text('ox_discovery.notifications'),
                onTap: _jumpToNotificationsMomentsPage),
            BottomItemModel(
                title: Localized.text('ox_discovery.change_cover_option'),
                onTap: _selectAssetDialog),
          ];
          MomentBottomSheetDialog.showBottomSheet(context, items);
        },
        child: isCurrentUser
            ? CommonImage(
                iconName: 'icon_more.png',
                width: 24.px,
                height: 24.px,
                useTheme: true,
              ).setPaddingOnly(right: 24.px)
            : Container(),
      ),
    );
  }

  Widget _buildCoverImage() {
    final placeholder = _placeholderImage(iconName: 'icon_group_default.png');

    return SizedBox(
      height: 240.px,
      width: double.infinity,
      child: OXCachedNetworkImage(
        imageUrl: widget.userDB.banner ?? '',
        placeholder: (context, url) => placeholder,
        errorWidget: (context, url, error) => placeholder,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildContactOperation() {
    return Positioned(
      top: 210.px,
      right: 0,
      left: 0,
      height: 80.px,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.px),
        color: Colors.transparent,
        child: Stack(
          children: [
            _buildAvatar(),
            isCurrentUser
                ? Container()
                : Positioned(
                    right: 0,
                    bottom: 0,
                    child: MomentFollowWidget(
                      userDB: widget.userDB,
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final size = Size(80.px, 80.px);
    final placeholder = MomentWidgetsUtils.badgePlaceholderImage(size: 80);

    return MomentWidgetsUtils.clipImage(
      borderRadius: size.width,
      imageSize: size.width,
      child: OXCachedNetworkImage(
        imageUrl: widget.userDB.picture ?? '',
        fit: BoxFit.cover,
        placeholder: (context, url) => placeholder,
        errorWidget: (context, url, error) => placeholder,
        width: size.width,
        height: size.height,
      ),
    );
  }

  Widget _buildMomentItem(NoteDBISAR note) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 12.px,
      ),
      child: MomentWidget(
        isShowReplyWidget: true,
        notedUIModel: ValueNotifier(NotedUIModel(noteDB: note)),
        clickMomentCallback: (ValueNotifier<NotedUIModel?> notedUIModel) async {
          await OXNavigator.pushPage(
              context, (context) => MomentsPage(notedUIModel: notedUIModel));
        },
      ),
    );
  }

  Widget _buildGroupedMomentItem(List<NoteDBISAR> notes) {
    return Column(
      children: [
        _buildTitle(notes.first.createAt),
        ListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: notes.length,
            itemBuilder: (context, index) => _buildMomentItem(notes[index])),
      ],
    );
  }

  Widget _buildTitle(int timestamp) {
    return SizedBox(
      height: 34.px,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          StyledDate(
            timestamp: timestamp,
          ),
          // Positioned(
          //   right: 0,
          //   top: 0,
          //   child: CommonImage(
          //     iconName: 'more_moment_icon.png',
          //     size: 20.px,
          //     package: 'ox_discovery',
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildNotificationTips() {
    return UnconstrainedBox(
      child: MomentNotificationTips(
        onTap: (list) => _jumpToNotificationsMomentsPage(),
      ),
    );
  }

  Image _placeholderImage({required String iconName, Size? size}) {
    return Image.asset(
      'assets/images/$iconName',
      fit: BoxFit.cover,
      width: size?.width,
      height: size?.height,
      package: 'ox_common',
    );
  }

  void _jumpToNotificationsMomentsPage() {
    OXNavigator.pushPage(
        context, (context) => const NotificationsMomentsPage());
  }

  void _selectAssetDialog() {
    final items = [
      BottomItemModel(
        title: Localized.text('ox_usercenter.gallery'),
        onTap: () async {
          await AlbumUtils.openAlbum(context,
              selectCount: 1, callback: _changeCover);
        },
      ),
      BottomItemModel(
        title: Localized.text('ox_usercenter.camera'),
        onTap: () async {
          await AlbumUtils.openCamera(context, _changeCover);
        },
      ),
    ];
    MomentBottomSheetDialog.showBottomSheet(context, items);
  }

  Future<void> _changeCover(List<String> filePathList) async {
    UserDBISAR? currentUserInfo =
        OXUserInfoManager.sharedInstance.currentUserInfo;
    final pubkey = currentUserInfo?.pubKey ?? '';
    final currentTime = DateTime.now().microsecondsSinceEpoch.toString();
    final fileName = 'banner_${pubkey}_$currentTime.png';
    final filePath = filePathList.first;
    File imageFile = File(filePath);

    UploadResult result = await UploadUtils.uploadFile(
        showLoading: true,
        fileType: FileType.image,
        file: imageFile,
        filename: fileName);

    if (result.isSuccess && result.url.isNotEmpty) {
      currentUserInfo?.banner = result.url;
      try {
        await OXLoading.show();
        await Account.sharedInstance.updateProfile(currentUserInfo!);
        await OXLoading.dismiss();
        if(mounted){
          setState(() {});
        }
      } catch (e) {
        await OXLoading.dismiss();
      }
    } else {
      CommonToast.instance.show(context, result.errorMsg ?? 'Upload Failed');
    }
  }

  void _refreshData(List<NoteDBISAR> noteList) {
    List<NoteDBISAR> filteredNoteList = noteList
        .where((element) =>
            element.getNoteKind() != ENotificationsMomentType.like.kind)
        .toList();
    if (filteredNoteList.isEmpty) {
      updateStateView(CommonStateView.CommonStateView_NoData);
      _refreshController.footerStatus == LoadStatus.idle
          ? _refreshController.loadComplete()
          : _refreshController.loadNoData();
      if (mounted) setState(() {});
      return;
    }
    _notes.addAll(filteredNoteList);
    _groupedNotes.addAll(_groupedNotesFromDateTime(_notes));
    _lastTimestamp = noteList.last.createAt;
    if (noteList.length < _limit) {
      _isLoadNotesFromRelay = true;
    }
    _refreshController.loadComplete();
    if (mounted) setState(() {});
  }

  Future<void> _loadNotesFromDB() async {
    List<NoteDBISAR> noteList = await Moment.sharedInstance.loadUserNotesFromDB(
            [widget.userDB.pubKey],
            limit: _limit, until: _lastTimestamp, root: '') ??
        [];
    Future.delayed(
        const Duration(milliseconds: 400), () => _refreshData(noteList));
  }

  Future<void> _loadnewNotesFromRelay() async {
    await Moment.sharedInstance.loadNewNotesFromRelay(
            authors: [widget.userDB.pubKey], limit: _limit) ??
        [];
    List<NoteDBISAR> noteList = await Moment.sharedInstance
            .loadUserNotesFromDB([widget.userDB.pubKey], limit: _limit, root: '') ??
        [];
    List<NoteDBISAR> newNoteList =
        noteList.where((element) => element.noteId != element.noteId).toList();
    _refreshData(newNoteList);
  }

  Future<void> _loadNotesFromRelay() async {
    try {
      List<NoteDBISAR> noteList = await Moment.sharedInstance
              .loadNewNotesFromRelay(
                  authors: [widget.userDB.pubKey],
                  until: _lastTimestamp,
                  limit: _limit) ??
          [];
      if (noteList.isEmpty) {
        updateStateView(CommonStateView.CommonStateView_NoData);
        _refreshController.footerStatus == LoadStatus.idle
            ? _refreshController.loadComplete()
            : _refreshController.loadNoData();
        setState(() {});
        return;
      }

      List<NoteDBISAR> filteredNoteList = noteList
          .where((element) =>
              element.getNoteKind() != ENotificationsMomentType.like.kind)
          .toList();
      _notes.addAll(filteredNoteList);
      _groupedNotes.addAll(_groupedNotesFromDateTime(_notes));
      _lastTimestamp = noteList.last.createAt;

      noteList.length < _limit
          ? _refreshController.loadNoData()
          : _refreshController.loadComplete();
      setState(() {});
    } catch (e) {
      _refreshController.loadFailed();
    }
  }

  List<NoteDBISAR> _filterNotes(List<NoteDBISAR> noteList) {
    return noteList
        .where((element) =>
            element.getNoteKind() != ENotificationsMomentType.like.kind)
        .toList();
  }

  Map<DateTime, List<NoteDBISAR>> _groupedNotesFromDateTime(
      List<NoteDBISAR> notes) {
    Map<DateTime, List<NoteDBISAR>> groupedNotes = {};

    for (var note in notes) {
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(note.createAt * 1000);

      final dateKey = DateTime(dateTime.year, dateTime.month, dateTime.day);

      if (!groupedNotes.containsKey(dateKey)) {
        groupedNotes[dateKey] = [];
      }

      groupedNotes[dateKey]!.add(note);
    }

    return groupedNotes;
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
