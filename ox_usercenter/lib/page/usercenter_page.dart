import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/navigator/slide_bottom_to_top_route.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/took_kit.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/base_page_state.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_button.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:ox_theme/ox_theme.dart';
import 'package:ox_usercenter/page/badge/usercenter_badge_wall_page.dart';
import 'package:ox_usercenter/page/set_up/profile_set_up_page.dart';
import 'package:ox_usercenter/page/set_up/settings_page.dart';

class UserCenterPage extends StatefulWidget {
  const UserCenterPage({Key? key}) : super(key: key);

  @override
  State<UserCenterPage> createState() => _UserCenterPageState();
}

class _UserCenterPageState extends BasePageState<UserCenterPage>
    with TickerProviderStateMixin, OXUserInfoObserver, WidgetsBindingObserver, CommonStateViewMixin {
  late ScrollController _nestedScrollController;
  int selectedIndex = 0;

  final GlobalKey globalKey = GlobalKey();

  double get _topHeight {
    return kToolbarHeight + Adapt.px(52);
  }

  double _scrollY = 0.0;

  late String _addressStr;

  bool _isVerifiedDNS = false;

  @override
  void initState() {
    super.initState();
    imageCache.clear();
    imageCache.maximumSize = 10;
    OXUserInfoManager.sharedInstance.addObserver(this);
    WidgetsBinding.instance.addObserver(this);

    _addressStr = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '';
    ThemeManager.addOnThemeChangedCallback(onThemeStyleChange);
    CachedNetworkImage.logLevel = CacheManagerLogLevel.debug;
    _nestedScrollController = ScrollController()
      ..addListener(() {
        if (_nestedScrollController.offset > _topHeight) {
          _scrollY = _nestedScrollController.offset - _topHeight;
        } else {
          if (_scrollY > 0) {
            _scrollY = 0.0;
          }
        }
      });
    _initInterface();
    _verifiedDNS();
  }

  @override
  stateViewCallBack(CommonStateView commonStateView) {
    switch (commonStateView) {
      case CommonStateView.CommonStateView_None:
        break;
      case CommonStateView.CommonStateView_NetworkError:
      case CommonStateView.CommonStateView_NoData:
        break;
      case CommonStateView.CommonStateView_NotLogin:
        break;
    }
  }

  void _initInterface() async {
    if (mounted) setState(() {});
  }

  //get user selected Badge Info from DB
  Future<BadgeDB?> _getUserSelectedBadgeInfo() async {
    String badges = OXUserInfoManager.sharedInstance.currentUserInfo?.badges ?? '';
    BadgeDB? badgeDB;
    try{
      if(badges.isNotEmpty){
        List<dynamic> badgeListDynamic = jsonDecode(badges);
        List<String> badgeList = badgeListDynamic.cast();
        List<BadgeDB?> badgeDBList = await BadgesHelper.getBadgeInfosFromDB(badgeList);
        if(badgeDBList.isNotEmpty){
          badgeDB = badgeDBList.first;
          return badgeDB;
        }
      }else{
        List<BadgeDB?>? badgeDBList = await BadgesHelper.getProfileBadgesFromRelay(OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '');
        if (badgeDBList != null && badgeDBList.isNotEmpty) {
          badgeDB = badgeDBList.first;
          return badgeDB;
        }
      }
    }catch(error,stack){
      LogUtil.e("user selected badge info fetch failed: $error\r\n$stack");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    bool isLogin = OXUserInfoManager.sharedInstance.isLogin;
    return Scaffold(
      backgroundColor: ThemeColor.color200,
      appBar: CommonAppBar(
        backgroundColor: ThemeColor.color200,
        title: '',
        useLargeTitle: false,
        centerTitle: false,
        canBack: false,
        actions: <Widget>[
          isLogin
              ? Container(
                  margin: EdgeInsets.only(right: Adapt.px(5), top: Adapt.px(12)),
                  color: Colors.transparent,
                  child: OXButton(
                    highlightColor: Colors.transparent,
                    color: Colors.transparent,
                    minWidth: Adapt.px(44),
                    height: Adapt.px(44),
                    child: Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: Adapt.px(16),
                        color: ThemeColor.color0,
                      ),
                    ),
                    onPressed: () {
                      OXNavigator.push(context, SlideBottomToTopRoute(page: const ProfileSetUpPage())).then((value) {
                        setState(() {});
                      });
                    },
                  ),
                )
              : Container(),
        ],
      ),
      body: commonStateViewWidget(
        context,
        Container(
          margin: EdgeInsets.symmetric(horizontal: Adapt.px(24)),
          child: SingleChildScrollView(
            controller: _nestedScrollController,
            child: _body(),
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: Adapt.px(210),
          color: ThemeColor.color200,
          child: Column(
            children: <Widget>[
              buildHeadImage(),
              SizedBox(
                height: Adapt.px(16),
              ),
              buildHeadName(),
              buildHeadDesc(),
              // buildHeadStatistics(),
              // buildHeadAdditional(),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: Adapt.px(104 + 0.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Adapt.px(16)),
            color: ThemeColor.color180,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FutureBuilder<BadgeDB?>(
                builder: (context, snapshot) {
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      OXNavigator.pushPage(
                        context,
                        (context) => UsercenterBadgeWallPage(
                          userDB: OXUserInfoManager.sharedInstance.currentUserInfo,
                        ),
                      ).then((value) {
                        setState(() {});
                      });
                    },
                    child: _topItemBuild(iconName: 'icon_settings_badges.png', title: 'Badges', badgeImgUrl: snapshot.data?.thumb, isShowDivider: true),
                  );
                },
                future: _getUserSelectedBadgeInfo(),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  OXModuleService.invoke(
                    'ox_chat',
                    'showMyIdCardDialog',
                    [
                      context,
                    ],
                  );
                },
                child: _topItemBuild(iconName: 'icon_settings_qrcode.png', title: Localized.text('ox_usercenter.my_qr_code'), isShowDivider: false),
              ),
            ],
          ),
        ),
        SizedBox(
          height: Adapt.px(24),
        ),
        SettingsPage(),
        SizedBox(
          height: Adapt.px(130),
        ),
      ],
    );
  }

  Widget _topItemBuild({String? iconName, String? title, String? badgeImgUrl, bool isShowDivider = false}) {
    Image placeholderImage = Image.asset(
      'assets/images/icon_badge_default.png',
      fit: BoxFit.cover,
      width: Adapt.px(32),
      height: Adapt.px(32),
      package: 'ox_common',
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          height: Adapt.px(52),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: Adapt.px(16)),
            leading: CommonImage(
              iconName: iconName ?? '',
              width: Adapt.px(32),
              height: Adapt.px(32),
              package: 'ox_usercenter',
            ),
            title: Container(
              // margin: EdgeInsets.only(left: Adapt.px(12)),
              child: Text(
                title ?? '',
                style: TextStyle(
                  color: ThemeColor.color0,
                  fontSize: Adapt.px(16),
                ),
              ),
            ),
            trailing: SizedBox(
              width: Adapt.px(56),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  badgeImgUrl == null
                      ? Container()
                      : CachedNetworkImage(
                          imageUrl: badgeImgUrl!,
                          placeholder: (context, url) => placeholderImage,
                          errorWidget: (context, url, error) => placeholderImage,
                          width: Adapt.px(32),
                          height: Adapt.px(32),
                          fit: BoxFit.cover,
                        ),
                  CommonImage(
                    iconName: 'icon_arrow_more.png',
                    width: Adapt.px(24),
                    height: Adapt.px(24),
                  )
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: isShowDivider,
          child: Divider(
            height: Adapt.px(0.5),
            color: ThemeColor.color160,
          ),
        ),
      ],
    );
  }

  Widget buildHeadImage() {
    String headImgUrl = OXUserInfoManager.sharedInstance.currentUserInfo?.picture ?? "";
    LogUtil.e("headImgUrl: ${headImgUrl}");
    String localAvatarPath = 'assets/images/user_image.png';

    Image placeholderImage = Image.asset(
      localAvatarPath,
      fit: BoxFit.cover,
      width: Adapt.px(76),
      height: Adapt.px(76),
      package: 'ox_common',
    );
    return Container(
      width: Adapt.px(120),
      height: Adapt.px(120),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Adapt.px(120)),
              child: CachedNetworkImage(
                imageUrl: headImgUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => placeholderImage,
                errorWidget: (context, url, error) => placeholderImage,
                width: Adapt.px(120),
                height: Adapt.px(120),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Container(
                width: Adapt.px(111),
                height: Adapt.px(111),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(Adapt.px(111)),
                  border: Border.all(
                    width: Adapt.px(3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeadName() {
    String name = OXUserInfoManager.sharedInstance.currentUserInfo?.name ?? "";
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name,
          style: TextStyle(color: ThemeColor.titleColor, fontSize: 20),
        ),
      ],
    );
  }

  Widget buildHeadDesc() {
    String dns = OXUserInfoManager.sharedInstance.currentUserInfo?.dns ?? '';
    return Container(
      margin: EdgeInsets.only(top: Adapt.px(2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dns,
            maxLines: 1,
            style: TextStyle(color: ThemeColor.color120, fontSize: Adapt.px(14)),
            // overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            width: Adapt.px(4),
          ),
          _isVerifiedDNS
              ? CommonImage(
                  iconName: "icon_npi05_verified.png",
                  width: Adapt.px(16),
                  height: Adapt.px(16),
                  package: 'ox_common',
                )
              : Container(),
        ],
      ),
    );
  }

  onThemeStyleChange() {
    if (mounted) setState(() {});
  }

  @override
  void didLoginSuccess(UserDB? userInfo) {
    if (this.mounted) {
      setState(() {
        updateStateView(CommonStateView.CommonStateView_None);
      });
    }
  }

  @override
  void didLogout() {
    LogUtil.e("useercenter.didLogout");
    if (this.mounted) {
      setState(() {
        updateStateView(CommonStateView.CommonStateView_NotLogin);
      });
    }
  }

  String getHostUrl(String url) {
    RegExp regExp = new RegExp(r"^.*?://(.*?)/.*?$");
    RegExpMatch? match = regExp.firstMatch(url);
    if (match != null) {
      return match.group(1) ?? '';
    }
    return '';
  }

  void _verifiedDNS() async {
    var isVerifiedDNS = await OXUserInfoManager.sharedInstance.checkDNS();
    setState(() {
      _isVerifiedDNS = isVerifiedDNS;
    });
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
