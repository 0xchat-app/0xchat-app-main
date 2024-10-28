import 'dart:math';
import 'dart:ui';

import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/business_interface/ox_chat/interface.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_discovery/enum/group_type.dart';
import 'package:ox_discovery/page/moments/groups_page.dart';
import 'package:ox_discovery/page/widgets/group_selector_dialog.dart';
import 'package:ox_discovery/utils/discovery_utils.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';
import '../enum/moment_enum.dart';
import '../model/moment_extension_model.dart';
import 'moments/create_moments_page.dart';
import 'moments/public_moments_page.dart';
import 'package:ox_common/business_interface/ox_discovery/ox_discovery_model.dart';
import 'package:flutter/cupertino.dart';

enum EDiscoveryPageType { moment, group }

extension EDiscoveryPageTypeEx on EDiscoveryPageType {
  static EDiscoveryPageType changeIntToEnum(int typeInt) {
    switch (typeInt) {
      case 1:
        return EDiscoveryPageType.moment;
      case 2:
        return EDiscoveryPageType.group;
      default:
        return EDiscoveryPageType.moment;
    }
  }
}

class DiscoveryPage extends StatefulWidget {
  final int typeInt;
  const DiscoveryPage({Key? key, required this.typeInt}) : super(key: key);

  @override
  State<DiscoveryPage> createState() => DiscoveryPageState();
}

class DiscoveryPageState extends DiscoveryPageBaseState<DiscoveryPage>
    with
        AutomaticKeepAliveClientMixin,
        OXUserInfoObserver,
        WidgetsBindingObserver,
        CommonStateViewMixin {
  int _channelCurrentIndex = 0;

  GroupType _groupType = GroupType.openGroup;

  String saveMomentFilterKey = 'momentFilterKey';

  late EDiscoveryPageType pageType;

  GlobalKey<PublicMomentsPageState> publicMomentPageKey =
      GlobalKey<PublicMomentsPageState>();
  GlobalKey<GroupsPageState> groupsPageState = GlobalKey<GroupsPageState>();

  EPublicMomentsPageType publicMomentsPageType =
      EPublicMomentsPageType.contacts;

  bool _isLogin = false;

  @override
  void initState() {
    super.initState();
    OXUserInfoManager.sharedInstance.addObserver(this);
    _isLogin = OXUserInfoManager.sharedInstance.isLogin;
    getMomentPublicFilter();
    pageType = EDiscoveryPageTypeEx.changeIntToEnum(widget.typeInt);
    setState(() {});
  }

  void _momentPublic(bool isChangeToDiscovery) {
    if (publicMomentPageKey.currentState == null) return;
    bool hasNotesList = publicMomentPageKey.currentState!.notesList.isEmpty;
    if (isChangeToDiscovery && hasNotesList) {
      publicMomentPageKey.currentState!.refreshController.requestRefresh();
    }

    if (!isChangeToDiscovery) {
      publicMomentPageKey.currentState?.momentScrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    OXUserInfoManager.sharedInstance.removeObserver(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
    super.build(context);
    return Scaffold(
      backgroundColor: ThemeColor.color200,
      appBar: AppBar(
        backgroundColor: ThemeColor.color200,
        elevation: 0,
        titleSpacing: 0.0,
        actions: _actionWidget(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(
            //   width: Adapt.px(24),
            // ),
            if (pageType == EDiscoveryPageType.moment)
              GestureDetector(
                onTap: () {
                  setState(() {
                    pageType = EDiscoveryPageType.moment;
                  });
                },
                child: Container(
                  child: Text(
                    'Moments',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Adapt.px(20),
                      color: ThemeColor.titleColor,
                    ),
                  ),
                ),
              ),
            SizedBox(
              width: Adapt.px(24),
            ),
            if (pageType == EDiscoveryPageType.group)
              GestureDetector(
                onTap: () {
                  setState(() {
                    pageType = EDiscoveryPageType.group;
                  });
                },
                child: Container(
                  child: Text(
                    'Add Group',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Adapt.px(20),
                      color: ThemeColor.titleColor,
                    ),
                  ),
                ),
              ),
            SizedBox(
              width: Adapt.px(24),
            ),
          ],
        ),
      ),
      body: _body(),
    );
  }

  List<Widget> _actionWidget() {
    if (!_isLogin) return [];

    if (pageType == EDiscoveryPageType.moment) {
      return [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: CommonImage(
            iconName: "moment_option.png",
            width: Adapt.px(24),
            height: Adapt.px(24),
            color: ThemeColor.color100,
            package: 'ox_discovery',
          ),
          onTap: () {
            showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => _buildMomentBottomDialog());
          },
        ),
        SizedBox(
          width: Adapt.px(20),
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: CommonImage(
            iconName: "moment_add_icon.png",
            width: Adapt.px(24),
            height: Adapt.px(24),
            color: ThemeColor.color100,
            package: 'ox_discovery',
          ),
          onLongPress: () {
            OXNavigator.presentPage(
                context,
                (context) =>
                    const CreateMomentsPage(type: EMomentType.content));
          },
          onTap: () {
            CreateMomentDraft? createMomentMediaDraft =
                OXMomentCacheManager.sharedInstance.createMomentMediaDraft;
            if (createMomentMediaDraft != null) {
              final type = createMomentMediaDraft.type;
              final imageList = type == EMomentType.picture
                  ? createMomentMediaDraft.imageList
                  : null;
              final videoPath = type == EMomentType.video
                  ? createMomentMediaDraft.videoPath
                  : null;
              final videoImagePath = type == EMomentType.video
                  ? createMomentMediaDraft.videoImagePath
                  : null;

              OXNavigator.presentPage(
                context,
                (context) => CreateMomentsPage(
                  type: type,
                  imageList: imageList,
                  videoPath: videoPath,
                  videoImagePath: videoImagePath,
                ),
              );
              return;
            }
            OXNavigator.presentPage(
                context, (context) => const CreateMomentsPage(type: null));
          },
        ),
        SizedBox(
          width: Adapt.px(24),
        ),
      ];
    }

    return [
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: CommonImage(
          iconName: "menu_icon.png",
          width: Adapt.px(24),
          height: Adapt.px(24),
          color: ThemeColor.color0,
          package: 'ox_discovery',
        ),
        onTap: () async {
          // showModalBottomSheet(context: context, backgroundColor: Colors.transparent, builder: (context) => _buildChannelBottomDialog());
          await showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return GroupSelectorDialog(
                title: Localized.text('ox_discovery.group'),
                onChanged: (type) => _updateGroupType(type),
              );
            },
          );
        },
      ),
      // OXChatInterface.showRelayInfoWidget().setPaddingOnly(left: 20.px),
      SizedBox(
        width: Adapt.px(24),
      ),
    ];
  }

  Widget _body() {
    if (pageType == EDiscoveryPageType.moment)
      return PublicMomentsPage(
        key: publicMomentPageKey,
        publicMomentsPageType: publicMomentsPageType,
      );
    return GroupsPage(
      key: groupsPageState,
      groupType: _groupType,
    );
  }

  Widget headerViewForIndex(String leftTitle, int index) {
    return SizedBox(
      height: Adapt.px(45),
      child: Row(
        children: [
          SizedBox(
            width: Adapt.px(24),
          ),
          Text(
            leftTitle,
            style: TextStyle(
                color: ThemeColor.titleColor,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          // CommonImage(
          //   iconName: "more_icon_z.png",
          //   width: Adapt.px(39),
          //   height: Adapt.px(8),
          // ),
          SizedBox(
            width: Adapt.px(16),
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
            fontWeight: index == _channelCurrentIndex
                ? FontWeight.w600
                : FontWeight.w400,
          ),
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildMomentBottomDialog() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(12)),
        color: ThemeColor.color180,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMomentItem(
            isSelect: publicMomentsPageType == EPublicMomentsPageType.contacts,
            EPublicMomentsPageType.contacts.text,
            index: 1,
            onTap: () => setMomentPublicFilter(EPublicMomentsPageType.contacts),
          ),
          Divider(
            color: ThemeColor.color170,
            height: Adapt.px(0.5),
          ),
          _buildMomentItem(
            isSelect: publicMomentsPageType == EPublicMomentsPageType.reacted,
            EPublicMomentsPageType.reacted.text,
            index: 1,
            onTap: () => setMomentPublicFilter(EPublicMomentsPageType.reacted),
          ),
          Divider(
            color: ThemeColor.color170,
            height: Adapt.px(0.5),
          ),
          _buildMomentItem(
            isSelect: publicMomentsPageType == EPublicMomentsPageType.private,
            EPublicMomentsPageType.private.text,
            index: 1,
            onTap: () => setMomentPublicFilter(EPublicMomentsPageType.private),
          ),
          Divider(
            color: ThemeColor.color170,
            height: Adapt.px(0.5),
          ),
          Container(
            height: Adapt.px(8),
            color: ThemeColor.color190,
          ),
          _buildMomentItem(Localized.text('ox_common.cancel'), index: 3,
              onTap: () {
            OXNavigator.pop(context);
          }),
          SizedBox(
            height: Adapt.px(21),
          ),
        ],
      ),
    );
  }

  void setMomentPublicFilter(EPublicMomentsPageType type) async {
    OXNavigator.pop(context);
    await OXCacheManager.defaultOXCacheManager
        .saveForeverData(saveMomentFilterKey, type.changeInt);
    if (mounted) {
      publicMomentsPageType = type;
    }
  }

  void getMomentPublicFilter() async {
    final result = await OXCacheManager.defaultOXCacheManager
        .getForeverData(saveMomentFilterKey);
    if (result != null) {
      publicMomentsPageType = EPublicMomentsPageTypeEx.getEnumType(result);
      setState(() {});
    }
  }

  Widget _buildMomentItem(String title,
      {required int index, GestureTapCallback? onTap, bool isSelect = false}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: Adapt.px(56),
        child: Text(
          title,
          style: TextStyle(
            color: isSelect ? ThemeColor.purple1 : ThemeColor.color0,
            fontSize: Adapt.px(16),
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      onTap: onTap,
    );
  }

  void _updateGroupType(GroupType groupType) {
    setState(() {
      _groupType = groupType;
    });
  }

  @override
  void didLoginSuccess(UserDBISAR? userInfo) {
    // TODO: implement didLoginSuccess
    _isLogin = true;
    setState(() {});
  }

  @override
  void didLogout() {
    // TODO: implement didLogout
    LogUtil.e("find.didLogout()");
    _isLogin = false;
    setState(() {});
  }

  @override
  void didSwitchUser(UserDBISAR? userInfo) {
    // TODO: implement didSwitchUser
    _isLogin = OXUserInfoManager.sharedInstance.isLogin;
    setState(() {});
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void didRelayStatusChange(String relay, int status) {
    setState(() {});
  }

  onThemeStyleChange() {
    if (mounted) setState(() {});
  }

  onLocaleChange() {
    if (mounted) setState(() {});
  }

  @override
  void updateClickNum(int num, bool isChangeToDiscovery) {
    if (pageType == EDiscoveryPageType.group)
      return _groupPageClickAction(num, isChangeToDiscovery);
    if (num == 1) return _momentPublic(isChangeToDiscovery);
    publicMomentPageKey.currentState
        ?.updateNotesList(true, isWrapRefresh: true);
  }

  void _groupPageClickAction(int num, bool isChangeToDiscovery) {
    if (num == 1 && !isChangeToDiscovery) {
      groupsPageState.currentState?.scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else if (num == 2) {
      groupsPageState.currentState!.refreshController.requestRefresh();
    }
  }
}
