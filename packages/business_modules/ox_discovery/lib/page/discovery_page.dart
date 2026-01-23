import 'dart:io';
import 'dart:ui';

import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/categoryView/common_category_title_view.dart';
import 'package:ox_common/widgets/categoryView/common_category_title_item.dart';
import 'package:ox_discovery/enum/group_type.dart';
import 'package:ox_discovery/page/moments/groups_page.dart';
import 'package:ox_discovery/page/widgets/group_selector_dialog.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'moments/notifications_moments_page.dart';
import 'moments/public_moments_page.dart';
import 'moments/moments_view_page.dart';
import 'moments/napp_page.dart';
import 'package:ox_common/business_interface/ox_discovery/ox_discovery_model.dart';
import 'package:flutter/cupertino.dart';

enum EDiscoveryPageType { moment, napp, group }

enum ENAppFilterType { all, favorite, recent }

extension ENAppFilterTypeEx on ENAppFilterType {
  String get text {
    switch (this) {
      case ENAppFilterType.all:
        return 'All';
      case ENAppFilterType.favorite:
        return Localized.text('ox_common.webview_more_bookmark');
      case ENAppFilterType.recent:
        return 'Recent';
    }
  }
}

extension EDiscoveryPageTypeEx on EDiscoveryPageType {
  static EDiscoveryPageType changeIntToEnum(int typeInt) {
    switch (typeInt) {
      case 1:
        return EDiscoveryPageType.moment;
      case 2:
        return EDiscoveryPageType.napp;
      case 3:
        return EDiscoveryPageType.group;
      default:
        return EDiscoveryPageType.moment;
    }
  }

  String get text {
    switch (this) {
      case EDiscoveryPageType.moment:
        return 'Posts';
      case EDiscoveryPageType.napp:
        return 'NApps';
      case EDiscoveryPageType.group:
        return 'Groups';
    }
  }
}

class DiscoveryPage extends StatefulWidget {
  final int typeInt;
  final bool isSecondPage;
  const DiscoveryPage({Key? key, required this.typeInt, this.isSecondPage = false}) : super(key: key);

  @override
  State<DiscoveryPage> createState() => DiscoveryPageState();
}

class DiscoveryPageState extends DiscoveryPageBaseState<DiscoveryPage>
    with
        AutomaticKeepAliveClientMixin,
        OXUserInfoObserver,
        WidgetsBindingObserver,
        CommonStateViewMixin,
        SingleTickerProviderStateMixin {
  GroupType _groupType = GroupType.openGroup;

  String saveMomentFilterKey = 'momentFilterKey';
  String saveNappFilterKey = 'nappFilterKey';

  late EDiscoveryPageType pageType;
  late TabController _tabController;
  late PageController _pageController;
  late List<CommonCategoryTitleItem> tabItems;
  
  ENAppFilterType _nappFilterType = ENAppFilterType.all;

  GlobalKey<PublicMomentsPageState> publicMomentPageKey =
      GlobalKey<PublicMomentsPageState>();
  GlobalKey<GroupsPageState> groupsPageState = GlobalKey<GroupsPageState>();

  EPublicMomentsPageType publicMomentsPageType =
      EPublicMomentsPageType.contacts;

  bool _isLogin = false;

  // Check if napp tab should be shown (hidden on Linux)
  bool get _showNappTab => !Platform.isLinux;

  @override
  void initState() {
    super.initState();
    OXUserInfoManager.sharedInstance.addObserver(this);
    _isLogin = OXUserInfoManager.sharedInstance.isLogin;
    // Load filters asynchronously, but don't await to avoid blocking initState
    getMomentPublicFilter();
    getNappFilter();
    pageType = EDiscoveryPageTypeEx.changeIntToEnum(widget.typeInt);
    // Calculate tab count and initial index based on platform
    int tabCount = _showNappTab ? 3 : 2;
    int initialIndex = 0; // Default to Moments
    if (_showNappTab) {
      if (widget.typeInt == 2) initialIndex = 1; // NApp
      else if (widget.typeInt == 3) initialIndex = 2; // Groups
    } else {
      // On Linux, napp is hidden, so adjust indices
      if (widget.typeInt == 2) initialIndex = 0; // NApp -> default to Moments
      else if (widget.typeInt == 3) initialIndex = 1; // Groups
    }
    _tabController = TabController(length: tabCount, vsync: this, initialIndex: initialIndex);
    _pageController = PageController(initialPage: initialIndex);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _updatePageType(_tabController.index);
      }
    });
    _loadData();
    setState(() {});
  }

  void _loadData() {
    tabItems = [
      CommonCategoryTitleItem(title: EDiscoveryPageType.moment.text),
      if (_showNappTab) CommonCategoryTitleItem(title: EDiscoveryPageType.napp.text),
      CommonCategoryTitleItem(title: EDiscoveryPageType.group.text),
    ];
  }

  void _updatePageType(int index) {
    setState(() {
      if (_showNappTab) {
        // With napp tab: 0=moment, 1=napp, 2=group
        switch (index) {
          case 0:
            pageType = EDiscoveryPageType.moment;
            break;
          case 1:
            pageType = EDiscoveryPageType.napp;
            break;
          case 2:
            pageType = EDiscoveryPageType.group;
            break;
        }
      } else {
        // Without napp tab (Linux): 0=moment, 1=group
        switch (index) {
          case 0:
            pageType = EDiscoveryPageType.moment;
            break;
          case 1:
            pageType = EDiscoveryPageType.group;
            break;
        }
      }
    });
  }


  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
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
      appBar: _commonAppBar(),
      body: PageView(
        physics: const BouncingScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          // PageView children array is automatically adjusted based on _showNappTab
          // So page index directly maps to tab index
          setState(() {
            _tabController.index = index;
          });
          _updatePageType(index);
          // Only load filter when switching to Moments tab
          // getMomentPublicFilter will update publicMomentsPageType if needed, which will trigger didUpdateWidget
          if (index == 0) {
            getMomentPublicFilter();
          }
        },
        children: [
          PublicMomentsPage(
            key: publicMomentPageKey,
            publicMomentsPageType: publicMomentsPageType,
            newMomentsBottom: widget.isSecondPage ? 60.px : 138.px,
          ),
          if (_showNappTab)
            NAppPage(
              filterType: _nappFilterType,
            ),
          GroupsPage(
            key: groupsPageState,
            groupType: _groupType,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _commonAppBar() {
    return AppBar(
      backgroundColor: ThemeColor.color200,
      elevation: 0,
      titleSpacing: 0.0,
      centerTitle: false,
      automaticallyImplyLeading: widget.isSecondPage,
      leadingWidth: widget.isSecondPage ? null : 0,
      leading: widget.isSecondPage ? null : SizedBox.shrink(),
      title: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.px),
          child: CommonCategoryTitleView(
            bgColor: Colors.transparent,
            selectedGradientColors: [
              ThemeColor.gradientMainStart,
              ThemeColor.gradientMainEnd
            ],
            unselectedGradientColors: [ThemeColor.color120, ThemeColor.color120],
            selectedFontSize: Adapt.sp(20),
            unSelectedFontSize: Adapt.sp(20),
            itemSpacing: 16.0,
            items: tabItems,
            onTap: (int value) {
              // Close subscriptions when switching away from Moments tab
              if (value != 0 && pageType == EDiscoveryPageType.moment) {
                Moment.sharedInstance.closeSubscriptions();
              }
              setState(() {
                _tabController.index = value;
              });
              _updatePageType(value);
              // PageView children are automatically adjusted based on _showNappTab
              // So tab index directly maps to page index
              _pageController.animateToPage(
                value,
                duration: const Duration(milliseconds: 2),
                curve: Curves.linear,
              );
            },
            selectedIndex: _tabController.index,
          ),
        ),
      ),
      actions: _actionWidget(),
    );
  }

  List<Widget> _actionWidget() {
    if (!_isLogin) return [];

    // Get current tab index
    int currentTabIndex = _tabController.index;
    
    if (currentTabIndex == 0) {
      // Moments tab actions
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
            final result = await OXNavigator.presentPage(
                context, (context) => const MomentsViewPage());
            if (result != null && result is Map && mounted) {
              final type = result['type'] as EPublicMomentsPageType;
              if (type == publicMomentsPageType &&
                  type == EPublicMomentsPageType.global) {
                // Same type: refresh global relays & data
                publicMomentPageKey.currentState?.refreshGlobalRelays();
              } else {
                publicMomentsPageType = type;
                setState(() {});
              }
            }
          },
        ),
        SizedBox(
          width: Adapt.px(20),
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: CommonImage(
            iconName: "icon_mute.png",
            width: Adapt.px(24),
            height: Adapt.px(24),
            color: ThemeColor.color0,
            package: 'ox_discovery',
          ),
          onTap: () {
            OXNavigator.pushPage(context,
                    (context) => const NotificationsMomentsPage());
          },
        ),
        SizedBox(
          width: Adapt.px(24),
        ),
      ];
    } else if (currentTabIndex == (_showNappTab ? 2 : 1)) {
      // Groups tab actions
      return [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: CommonImage(
            iconName: "menu_icon.png",
            width: Adapt.px(24),
            height: Adapt.px(24),
            color: ThemeColor.color0,
            package: 'ox_discovery',
          ).setPaddingOnly(left: 10.px),
          onTap: () async {
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
        SizedBox(
          width: Adapt.px(24),
        ),
      ];
    } else if (_showNappTab && currentTabIndex == 1) {
      // NApp tab actions
      return [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: CommonImage(
            iconName: "menu_icon.png",
            width: Adapt.px(24),
            height: Adapt.px(24),
            color: ThemeColor.color0,
            package: 'ox_discovery',
          ).setPaddingOnly(left: 10.px),
          onTap: () {
            showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => _buildNappBottomDialog());
          },
        ),
        SizedBox(
          width: Adapt.px(24),
        ),
      ];
    } else {
      // Other tabs - no actions for now
      return [
        SizedBox(
          width: Adapt.px(24),
        ),
      ];
    }
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


  Future<void> getMomentPublicFilter() async {
    final result = await OXCacheManager.defaultOXCacheManager
        .getForeverData(saveMomentFilterKey);
    if (result != null) {
      final newType = EPublicMomentsPageTypeEx.getEnumType(result);
      if (newType != publicMomentsPageType) {
        publicMomentsPageType = newType;
        setState(() {});
      }
    } else {
      // Ensure default value is set if no saved filter exists
      if (publicMomentsPageType != EPublicMomentsPageType.contacts) {
        publicMomentsPageType = EPublicMomentsPageType.contacts;
        setState(() {});
      }
    }
  }

  void getNappFilter() async {
    final result = await OXCacheManager.defaultOXCacheManager
        .getForeverData(saveNappFilterKey);
    if (result != null && result is int && result >= 0 && result < ENAppFilterType.values.length) {
      _nappFilterType = ENAppFilterType.values[result];
    } else {
      // Default to 'all' if no saved filter or invalid value
      _nappFilterType = ENAppFilterType.all;
    }
    setState(() {});
  }

  void setNappFilter(ENAppFilterType type) async {
    OXNavigator.pop(context);
    await OXCacheManager.defaultOXCacheManager
        .saveForeverData(saveNappFilterKey, type.index);
    if (mounted) {
      _nappFilterType = type;
      setState(() {});
    }
  }

  Widget _buildNappBottomDialog() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(12)),
        color: ThemeColor.color180,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMomentItem(
            isSelect: _nappFilterType == ENAppFilterType.all,
            ENAppFilterType.all.text,
            index: 1,
            onTap: () => setNappFilter(ENAppFilterType.all),
          ),
          Divider(
            color: ThemeColor.color170,
            height: Adapt.px(0.5),
          ),
          _buildMomentItem(
            isSelect: _nappFilterType == ENAppFilterType.favorite,
            ENAppFilterType.favorite.text,
            index: 1,
            onTap: () => setNappFilter(ENAppFilterType.favorite),
          ),
          Divider(
            color: ThemeColor.color170,
            height: Adapt.px(0.5),
          ),
          _buildMomentItem(
            isSelect: _nappFilterType == ENAppFilterType.recent,
            ENAppFilterType.recent.text,
            index: 1,
            onTap: () => setNappFilter(ENAppFilterType.recent),
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


  onThemeStyleChange() {
    if (mounted) setState(() {});
  }

  onLocaleChange() {
    if (mounted) setState(() {});
  }

}
