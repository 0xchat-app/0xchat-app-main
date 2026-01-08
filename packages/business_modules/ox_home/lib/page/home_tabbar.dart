import 'dart:io';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/business_interface/ox_chat/contact_base_page_state.dart';
import 'package:ox_common/mixin/common_navigator_observer_mixin.dart';
import 'package:ox_common/model/msg_notification_model.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_chat_observer.dart';
import 'package:ox_common/utils/ox_moment_manager.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/platform_utils.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/widgets/base_page_state.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_home/model/home_tabbar_type.dart';
import 'package:ox_home/model/tab_view_info.dart';
import 'package:ox_home/widgets/translucent_navigation_bar.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';

class HomeTabBarPage extends StatefulWidget {
  const HomeTabBarPage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeTabBarPage> createState() => _HomeTabBarPageState();
}

class _HomeTabBarPageState extends State<HomeTabBarPage> with OXUserInfoObserver, OXChatObserver, OXMomentObserver, TickerProviderStateMixin, WidgetsBindingObserver, NavigatorObserverMixin {
  bool isLogin = false;
  late PageController _pageController;

  GlobalKey<BasePageState> homeGlobalKey = GlobalKey();
  GlobalKey<ContactBasePageState> contactGlobalKey = GlobalKey();

  GlobalKey<TranslucentNavigationBarState> tabBarGlobalKey = GlobalKey();
  double _previousScrollOffset = 0.0;
  double _bottomNavOffset = 0.0;
  final double _bottomNavHeight = 72.px;
  final double _bottomNavMargin = 24.0.px;
  double _tabbarSH = 0;
  late List<HomeTabBarType> _typeList;

  late List<TabViewInfo> tabViewInfo;

  @override
  void initState() {
    super.initState();
    isLogin = OXUserInfoManager.sharedInstance.isLogin;
    _tabbarSH = _bottomNavHeight + _bottomNavMargin;
    OXUserInfoManager.sharedInstance.addObserver(this);
    OXChatBinding.sharedInstance.addObserver(this);
    OXMomentManager.sharedInstance.addObserver(this);
    WidgetsBinding.instance.addObserver(this);

    // Default to move to tabbar mode: always show 4 tabs (home, contact, discover, me)
    _typeList = [HomeTabBarType.home, HomeTabBarType.contact, HomeTabBarType.discover, HomeTabBarType.me];
    _pageController = PageController(initialPage: 0);
    tabViewInfo = TabViewInfo.getTabViewData(_typeList);
    Localized.addLocaleChangedCallback(onLocaleChange);
    signerCheck();
  }

  @override
  void dispose() {
    OXUserInfoManager.sharedInstance.removeObserver(this);
    OXChatBinding.sharedInstance.removeObserver(this);
    OXMomentManager.sharedInstance.removeObserver(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // Get bottom safe area padding for Android navigation bar only
    // iOS Scaffold already handles bottom safe area (Home indicator)
    final bottomPadding = Platform.isAndroid ? MediaQuery.of(context).padding.bottom : 0.0;
    
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth:  PlatformUtils.listWidth),
            child: TranslucentNavigationBar(
              key: tabBarGlobalKey,
              onTap: (changeIndex, currentSelect) => _tabClick(changeIndex, currentSelect),
              handleDoubleTap: (changeIndex, currentSelect) => _handleDoubleTap(changeIndex, currentSelect),
              height: _bottomNavHeight,
            ),
          ),
        ),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: _containerView(context),
      ),
    );
  }

  List<Widget> _containerView(BuildContext context) {
    return tabViewInfo.map(
          (TabViewInfo tabModel) {
        return Container(
          constraints: const BoxConstraints.expand(
            width: double.infinity,
            height: double.infinity,
          ),
          child: _showPage(tabModel),
        );
      },
    ).toList();
  }

  Widget _showPage(TabViewInfo tabModel){
    Map<Symbol, GlobalKey>? params;

    if (tabModel.moduleName == 'ox_chat') {
      if (tabModel.modulePage == 'chatSessionListPageWidget') {
        params = {
          #homeGlobalKey: homeGlobalKey,
        };
      } else if (tabModel.modulePage == 'contractsPageWidget') {
        params = {
          #contactGlobalKey: contactGlobalKey,
        };
      }
    }

    Widget page = OXModuleService.invoke<Widget>(
        tabModel.moduleName,
        tabModel.modulePage,
        [context],
        params
    ) ?? const SizedBox();
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification.metrics.axis == Axis.vertical) {
          double currentOffset = scrollNotification.metrics.pixels;
          if (scrollNotification is ScrollUpdateNotification) {
            double delta = currentOffset - _previousScrollOffset;
            if (currentOffset >= scrollNotification.metrics.maxScrollExtent
            || (tabBarGlobalKey.currentState!= null && tabBarGlobalKey.currentState!.getAnimStatus())) {
              return false;
            }
            _previousScrollOffset = currentOffset;
            if (currentOffset <= 0) {
              tabBarGlobalKey.currentState?.updateOffset(0);
              return false;
            }
            if (delta >= 0) {
              _bottomNavOffset += delta;
              if (_bottomNavOffset >= _tabbarSH) {
                _bottomNavOffset = _tabbarSH;
                return false;
              }
              if (_bottomNavOffset > 15.px) {
                tabBarGlobalKey.currentState?.executeAnim(isReverse: false, fromValue: _bottomNavOffset* 0.01);
                _bottomNavOffset = _tabbarSH;
              } else {
                tabBarGlobalKey.currentState?.updateOffset(_bottomNavOffset * 0.01);
              }
            } else {
              _bottomNavOffset += delta;
              if (_bottomNavOffset < 0) {
                _bottomNavOffset = 0;
                return false;
              }
              if (_bottomNavOffset < _bottomNavHeight) {
                tabBarGlobalKey.currentState?.executeAnim(isReverse: true, fromValue: _bottomNavOffset* 0.01);
                _bottomNavOffset = 0.0;
              } else {
                tabBarGlobalKey.currentState?.updateOffset(_bottomNavOffset * 0.01);
              }
            }
          }
        }
        return false;
      },
      child: NotificationListener<MsgNotification>(
        onNotification: (msgNotification) {
          if (tabBarGlobalKey.currentState == null) return false;
          return tabBarGlobalKey.currentState!.updateNotificationListener(msgNotification);
        },
        child: page,
      ),
    );
  }

  @override
  Future<void> didPopNext() async {
    _bottomNavOffset = 0.0;
    tabBarGlobalKey.currentState?.updateOffset(_bottomNavOffset);
  }

  @override
  void didLoginSuccess(UserDBISAR? userInfo) {
    // TODO: implement didLoginSuccess
    setState(() {
      isLogin = true;
    });
  }

  @override
  void didLogout() {
    // TODO: implement didLogout
    setState(() {
      isLogin = false;
    });
  }

  @override
  void didSwitchUser(UserDBISAR? userInfo) {
    // TODO: implement didSwitchUser
  }

  void _applyTabbarMode({int targetIndex = 0}) {
    final List<HomeTabBarType> targetList = [HomeTabBarType.home, HomeTabBarType.contact, HomeTabBarType.discover, HomeTabBarType.me];
    setState(() {
      _typeList = targetList;
      tabViewInfo = TabViewInfo.getTabViewData(_typeList);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _toPage(targetIndex.clamp(0, _typeList.length - 1), animated: false);
    });
  }

  @override
  void didMoveToTabBarCallBack() {
    _applyTabbarMode(targetIndex: 0);
  }

  @override
  void didMoveToTopCallBack() {
    _applyTabbarMode(targetIndex: 0);
  }

  @override
  void didDeleteMomentsCallBack() {
    _applyTabbarMode(targetIndex: 0);
  }

  void _handleDoubleTap(value,int currentSelect){

  }

  Future<void> _tabClick(int changeIndex, int currentSelect) async {
    if(_typeList.elementAt(changeIndex) == HomeTabBarType.contact && _typeList.elementAt(currentSelect) == HomeTabBarType.contact) {
      contactGlobalKey.currentState?.updateContactTabClickAction(1, false);
    }
    if(_typeList.elementAt(changeIndex) == HomeTabBarType.home && _typeList.elementAt(currentSelect) == HomeTabBarType.home) {
      homeGlobalKey.currentState?.updateHomeTabClickAction(1, false);
    }
    if(_typeList.elementAt(changeIndex) == HomeTabBarType.discover) {
      // Load filterType from cache, default to 1 (contacts) if not found
      final filterType = await OXCacheManager.defaultOXCacheManager
          .getForeverData('momentFilterKey', defaultValue: 1);
      Moment.sharedInstance.updateSubscriptions(filterType: filterType);
    }else{
      Moment.sharedInstance.closeSubscriptions();
    }
    _toPage(changeIndex);
  }

  void _toPage(int index, {bool animated = true}){
    if (animated) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 1),
        curve: Curves.linear,
      );
    } else {
      _pageController.jumpToPage(index);
    }
  }

  void signerCheck() async {
    final String? pubKey = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey;
    if (pubKey == null) return;
    
    // Check for saved signer package name first (new approach)
    String? signerPackageName = await OXCacheManager.defaultOXCacheManager.getForeverData('${pubKey}${StorageKeyTool.KEY_SIGNER_PACKAGE_NAME}');
    
    // Fallback to old isAmber flag for backward compatibility
    if (signerPackageName == null) {
      final bool? localIsLoginAmber = await OXCacheManager.defaultOXCacheManager.getForeverData('${pubKey}${StorageKeyTool.KEY_IS_LOGIN_AMBER}');
      if (localIsLoginAmber == true) {
        signerPackageName = 'com.greenart7c3.nostrsigner'; // Amber
      }
    }
    
    if (signerPackageName != null) {
      bool isInstalled = await CoreMethodChannel.isAppInstalled(signerPackageName);
      if (mounted && (!isInstalled || OXUserInfoManager.sharedInstance.signatureVerifyFailed)){
        String showTitle = '';
        String showContent = '';
        if (!isInstalled) {
          showTitle = 'ox_common.open_singer_app_error_title';
          showContent = 'ox_common.open_singer_app_error_content';
        } else if (OXUserInfoManager.sharedInstance.signatureVerifyFailed){
          showTitle = 'ox_common.tips';
          showContent = 'ox_common.str_singer_app_verify_failed_hint';
        }
        OXUserInfoManager.sharedInstance.resetData();
        OXCommonHintDialog.show(
          context, title: Localized.text(showTitle), content: Localized.text(showContent),
          actionList: [
            OXCommonHintAction.sure(
                text: Localized.text('ox_common.confirm'),
                onTap: () {
                  OXNavigator.pop(context);
                }),
          ],
        );
      }
    }
  }

  onLocaleChange() {
    if (mounted) {
      setState(() {});
    }
  }
}
