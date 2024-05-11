import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:extended_sliver/extended_sliver.dart';
import 'package:ox_common/utils/uplod_aliyun_utils.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_common/widgets/common_pull_refresher.dart';
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
  final UserDB userDB;
  const PersonMomentsPage({super.key, required this.userDB});

  @override
  State<PersonMomentsPage> createState() => _PersonMomentsPageState();
}

class _PersonMomentsPageState extends State<PersonMomentsPage>
    with CommonStateViewMixin {

  bool get isCurrentUser => OXUserInfoManager.sharedInstance.isCurrentUser(widget.userDB.pubKey);
  final RefreshController _refreshController = RefreshController();
  final List<NoteDB> _notes = [];

  final int _limit = 50;
  int? _lastTimestamp;

  @override
  void initState() {
    super.initState();
    _loadNotes();
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
    return Scaffold(
        backgroundColor: ThemeColor.color190,
        body: OXSmartRefresher(
          controller: _refreshController,
          enablePullDown: false,
          enablePullUp: true,
          onLoading: () => _loadNotes(),
          child: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: <Widget>[
              _buildAppBar(),
              SliverToBoxAdapter(
                child: ContactInfoWidget(userDB: widget.userDB,).setPaddingOnly(bottom: 20.px),
              ),
              SliverToBoxAdapter(
                child: isCurrentUser ? _buildNotificationTips() : Container(),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 24.px),
                sliver: _notes.isNotEmpty ? SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return _buildMomentItem(index,);
                    },
                    childCount: _notes.length,
                  ),
                ) : SliverToBoxAdapter(
                    child: commonStateViewWidget(context, Container(),),
                ),
              ),
            ],
          ),
        )
    );
  }

  Widget _buildAppBar(){
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
            BottomItemModel(title: 'Notifications', onTap: _jumpToNotificationsMomentsPage),
            BottomItemModel(title: 'Change Cover', onTap: _selectAssetDialog),
          ];
          MomentBottomSheetDialog.showBottomSheet(context, items);
        },
        child: isCurrentUser
            ? CommonImage(
                iconName: 'icon_more_operation.png',
                width: 24.px,
                height: 24.px,
                package: 'ox_discovery',
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

  Widget _buildContactOperation(){

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
            isCurrentUser ? Container() : Positioned(
              right: 0,
              bottom: 0,
              child: MomentFollowWidget(userDB: widget.userDB,),
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

  Widget _buildMomentItem(int index) {
    final isShowUserInfo = _notes[index].getNoteKind() == ENotificationsMomentType.repost.kind;
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 12.px,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(_notes[index].createAt),
          MomentWidget(
            notedUIModel: NotedUIModel(noteDB: _notes[index]),
            isShowUserInfo: isShowUserInfo,
            clickMomentCallback: (NotedUIModel notedUIModel) async {
              await OXNavigator.pushPage(
                  context, (context) => MomentsPage(notedUIModel: notedUIModel));
            },
          )
        ],
      ),
    );
  }

  Widget _buildTitle(int timestamp){
    return SizedBox(
      height: 34.px,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          StyledDate(timestamp: timestamp,),
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
        onTap: _jumpToNotificationsMomentsPage
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
    OXNavigator.pushPage(context, (context) => const NotificationsMomentsPage());
  }

  void _selectAssetDialog(){
    final items = [
      BottomItemModel(
        title: Localized.text('ox_usercenter.gallery'),
        onTap: () async {
          await AlbumUtils.openAlbum(context, selectCount: 1, callback: _changeCover);
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
    UserDB? currentUserInfo = OXUserInfoManager.sharedInstance.currentUserInfo;
    final pubkey = currentUserInfo?.pubKey ?? '';
    final currentTime = DateTime.now().microsecondsSinceEpoch.toString();
    final fileName = 'banner_${pubkey}_$currentTime.png';
    final filePath = filePathList.first;
    File imageFile = File(filePath);

    final String url = await UplodAliyun.uploadFileToAliyun(
      fileType: UplodAliyunType.imageType,
      file: imageFile,
      filename: fileName
    );

    if (url.isNotEmpty) {
      currentUserInfo?.banner = url;
      try {
        await OXLoading.show();
        await Account.sharedInstance.updateProfile(currentUserInfo!);
        await OXLoading.dismiss();
        setState(() {});
      } catch (e) {
        await OXLoading.dismiss();
      }
    }
  }

  Future<void> _loadNotes() async {
    List<NoteDB> noteList;
    try {
      if(isCurrentUser) {
        noteList = await Moment.sharedInstance.loadMyNotesFromDB(until: _lastTimestamp,limit: _limit) ?? [];
      } else {
        noteList = await Moment.sharedInstance.loadUserNotesFromDB(widget.userDB.pubKey,until: _lastTimestamp,limit: _limit) ?? [];
      }
    } catch (e) {
      noteList = [];
      LogUtil.e('Load Notes Failed: $e');
    }

    List<NoteDB> filteredNoteList = noteList.where((element) => element.getNoteKind() != ENotificationsMomentType.like.kind).toList();
    if (filteredNoteList.isEmpty) {
      updateStateView(CommonStateView.CommonStateView_NoData);
      _refreshController.loadComplete();
      setState(() {});
      return;
    }

    _notes.addAll(filteredNoteList);
    _lastTimestamp = noteList.last.createAt;
    noteList.length < _limit ? _refreshController.loadNoData() : _refreshController.loadComplete();
    setState(() {});
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

}
