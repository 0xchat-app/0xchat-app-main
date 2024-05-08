import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/date_utils.dart';
import 'package:ox_common/utils/ox_moment_manager.dart';
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
import 'package:ox_discovery/page/widgets/moment_tips.dart';
import 'package:ox_discovery/page/widgets/moment_widget.dart';
import 'package:ox_discovery/page/widgets/style_date.dart';
import 'package:ox_discovery/utils/album_utils.dart';
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
                child: _buildContactInfo(),
              ),
              SliverToBoxAdapter(
                child: isCurrentUser ? _buildNewMomentTips() : Container(),
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
            _buildAvatar(
              imageUrl: widget.userDB.picture ?? '',
              size: Size(80.px, 80.px),
              placeholderIconName: 'icon_user_default.png',
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: _buildButton(title: 'Remove'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo() {

    String _getUserName(UserDB userDB){
      return userDB.name ?? userDB.nickName ?? '';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.px),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _getUserName(widget.userDB),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.px,
                  color: ThemeColor.color0,
                  height: 28.px / 20.px,
                ),
              ),
              SizedBox(width: 2.px,),
              DNSAuthenticationWidget(userDB: widget.userDB,)
            ],
          ),
          Text(
            widget.userDB.dns ?? '',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12.px,
              color: ThemeColor.color120,
              height: 17.px / 12.px,
            ),
          ),
          EncodedPubkeyWidget(encodedPubKey: widget.userDB.encodedPubkey,),
          BioWidget(bio: widget.userDB.about ?? '',),
        ],
      ),
    ).setPaddingOnly(bottom: 20.px);
  }

  Widget _buildButton({required String title}) {
    return Container(
      width: 96.px,
      height: 24.px,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.px),
        border: Border.all(
          width: 0.5.px,
          color: ThemeColor.color100
        )
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12.px,
          color: ThemeColor.color0
        ),
      ),
    );
  }

  Widget _buildAvatar({
    required String imageUrl,
    required Size size,
    required String placeholderIconName,
  }) {
    final placeholder = _placeholderImage(iconName: placeholderIconName);

    return ClipOval(
      child: SizedBox(
        height: size.height,
        width: size.width,
        child: OXCachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (context, url) => placeholder,
          errorWidget: (context, url, error) => placeholder,
          fit: BoxFit.cover,
        ),
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
    final datetime = OXDateUtils.getLocalizedMonthAbbreviation(timestamp,locale: Localized.getCurrentLanguage().value());
    final day = datetime.split(' ').first;
    final month = datetime.split(' ').last;

    return SizedBox(
      height: 34.px,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          StyledDate(day: day, month: month),
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

  Widget _buildNewMomentTips() {
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
    List<NoteDB> noteLst;
    if(isCurrentUser) {
      noteLst = await Moment.sharedInstance.loadMyNotesFromDB(until: _lastTimestamp,limit: _limit) ?? [];
    } else {
      noteLst = await Moment.sharedInstance.loadUserNotesFromDB(widget.userDB.pubKey,until: _lastTimestamp,limit: _limit) ?? [];
    }
    List<NoteDB> filteredNoteList = noteLst.where((element) => element.getNoteKind() != ENotificationsMomentType.like.kind).toList();
    setState(() {
      if(noteLst.isEmpty){
        updateStateView(CommonStateView.CommonStateView_NoData);
        _refreshController.loadNoData();
        return;
      }
      _notes.addAll(filteredNoteList);
      _lastTimestamp = noteLst.last.createAt;
    });
    if(noteLst.length < _limit){
      _refreshController.loadNoData();
      return;
    }
    _refreshController.loadComplete();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

}
