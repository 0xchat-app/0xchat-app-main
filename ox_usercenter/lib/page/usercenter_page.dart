import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/business_interface/ox_wallet/interface.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/navigator/slide_bottom_to_top_route.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_chat_observer.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/took_kit.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/base_page_state.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_button.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:ox_theme/ox_theme.dart';
import 'package:ox_usercenter/page/badge/usercenter_badge_wall_page.dart';
import 'package:ox_usercenter/page/set_up/donate_page.dart';
import 'package:ox_usercenter/page/set_up/profile_set_up_page.dart';
import 'package:ox_usercenter/page/set_up/settings_page.dart';
import 'package:ox_usercenter/utils/widget_tool.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:cashu_dart/cashu_dart.dart';

class UserCenterPage extends StatefulWidget {
  const UserCenterPage({Key? key}) : super(key: key);

  @override
  State<UserCenterPage> createState() => _UserCenterPageState();
}

class _UserCenterPageState extends BasePageState<UserCenterPage>
    with
        TickerProviderStateMixin,
        OXUserInfoObserver,
        WidgetsBindingObserver,
        CommonStateViewMixin, OXChatObserver {
  late ScrollController _nestedScrollController;
  int selectedIndex = 0;

  final GlobalKey globalKey = GlobalKey();

  double get _topHeight {
    return kToolbarHeight + Adapt.px(52);
  }

  double _scrollY = 0.0;

  late String _version = '1.0.0';

  bool _isVerifiedDNS = false;
  bool _isShowZapBadge = false;

  @override
  void initState() {
    super.initState();
    imageCache.clear();
    imageCache.maximumSize = 10;
    OXUserInfoManager.sharedInstance.addObserver(this);
    OXChatBinding.sharedInstance.addObserver(this);
    Localized.addLocaleChangedCallback(onLocaleChange);
    WidgetsBinding.instance.addObserver(this);
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
    _getPackageInfo();
  }

  @override
  void didZapRecordsCallBack(ZapRecordsDB zapRecordsDB,{Function? onValue}) {
    super.didZapRecordsCallBack(zapRecordsDB);
    setState(() {
      _isShowZapBadge = _getZapBadge();
    });
  }

  @override
  void dispose() {
    OXUserInfoManager.sharedInstance.removeObserver(this);
    OXChatBinding.sharedInstance.removeObserver(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
    _isShowZapBadge = _getZapBadge();
    if (mounted) setState(() {});
  }

  bool _getZapBadge() {
    return OXChatBinding.sharedInstance.isZapBadge;
  }

  //get user selected Badge Info from DB
  Future<BadgeDB?> _getUserSelectedBadgeInfo() async {
    String badges =
        OXUserInfoManager.sharedInstance.currentUserInfo?.badges ?? '';
    BadgeDB? badgeDB;
    try {
      if (badges.isNotEmpty) {
        List<dynamic> badgeListDynamic = jsonDecode(badges);
        List<String> badgeList = badgeListDynamic.cast();
        List<BadgeDB?> badgeDBList =
            await BadgesHelper.getBadgeInfosFromDB(badgeList);
        if (badgeDBList.isNotEmpty) {
          badgeDB = badgeDBList.first;
          return badgeDB;
        }
      } else {
        List<BadgeDB?>? badgeDBList =
            await BadgesHelper.getAllProfileBadgesFromRelay(
                OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '');
        if (badgeDBList != null && badgeDBList.isNotEmpty) {
          badgeDB = badgeDBList.first;
          return badgeDB;
        }
      }
    } catch (error, stack) {
      LogUtil.e("user selected badge info fetch failed: $error\r\n$stack");
    }
    return null;
  }

  onLocaleChange() {
    if (mounted) setState(() {});
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
                  margin: EdgeInsets.only(right: Adapt.px(5)),
                  color: Colors.transparent,
                  child: OXButton(
                    highlightColor: Colors.transparent,
                    color: Colors.transparent,
                    minWidth: Adapt.px(44),
                    height: Adapt.px(44),
                    child: Text(
                      Localized.text('ox_common.edit'),
                      style: TextStyle(
                        fontSize: Adapt.px(16),
                        fontWeight: FontWeight.w600,
                        color: ThemeColor.color0,
                      ),
                    ),
                    onPressed: () {
                      OXNavigator.push(
                              context,
                              SlideBottomToTopRoute(
                                  page: const ProfileSetUpPage()))
                          .then((value) {
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

  Future<void> claimEcash() async {
    final token = await NpubCash.claim();
    if(token != null){
      OXCommonHintDialog.show(
        context,
        title: Localized.text('ox_usercenter.str_claim_ecash_hint_title'),
        content: Localized.text('ox_usercenter.str_claim_ecash_hint'),
        actionList: [
          OXCommonHintAction.sure(
            text: Localized.text('ox_usercenter.str_claim_ecash_confirm'),
            onTap: () async {
              OXNavigator.pop(context);
              OXLoading.show();
              final response = await Cashu.redeemEcash(
                ecashString: token,
                redeemPrivateKey: [Account.sharedInstance.currentPrivkey],
                signFunction: (key, message) async {
                  return Account.getSignatureWithSecret(message, key);
                },
              );
              OXLoading.dismiss();
              CommonToast.instance.show(
                context,
                Localized.text(response.isSuccess ? 'ox_usercenter.str_claim_ecash_success' : 'ox_usercenter.str_claim_ecash_fail'),
              );
            },
          ),
        ],
        isRowAction: true,
      );
    }
  }

  Widget _body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          color: ThemeColor.color200,
          child: Column(
            children: <Widget>[
              buildHeadImage(),
              SizedBox(
                height: Adapt.px(16),
              ),
              buildHeadName(),
              buildHeadDesc(),
              buildHeadPubKey(),
            ],
          ),
        ),
        buildOption(
          title: 'ox_usercenter.wallet',
          iconName: 'icon_settings_wallet.png',
          onTap: () async {
            claimEcash();
            OXWalletInterface.openWalletHomePage();
          },
        ),
        SizedBox(
          height: Adapt.px(24),
        ),
        Container(
          width: double.infinity,
          // height: Adapt.px(208 + 1.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Adapt.px(16)),
            color: ThemeColor.color180,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _topItemBuild(
                iconName: 'icon_moment.png',
                title: Localized.text('ox_discovery.moment'),
                isShowDivider: true,
                onTap: () {
                  OXModuleService.pushPage(
                    context,
                    'ox_discovery',
                    'PersonMomentsPage',
                    {
                      'userDB': OXUserInfoManager.sharedInstance.currentUserInfo,
                    },
                  );
                },
              ),
              FutureBuilder<BadgeDB?>(
                builder: (context, snapshot) {
                  return _topItemBuild(
                      iconName: 'icon_settings_badges.png',
                      title: Localized.text('ox_usercenter.badges'),
                      badgeImgUrl: snapshot.data?.thumb,
                      isShowDivider: true,
                      onTap: () {
                        OXNavigator.pushPage(
                          context,
                          (context) => UsercenterBadgeWallPage(userDB: OXUserInfoManager.sharedInstance.currentUserInfo),
                        ).then((value) {
                          setState(() {});
                        });
                      });
                },
                future: _getUserSelectedBadgeInfo(),
              ),
              _topItemBuild(
                iconName: 'icon_settings_qrcode.png',
                title: Localized.text('ox_common.qr_code'),
                isShowDivider: true,
                onTap: () {
                  OXModuleService.invoke('ox_chat', 'showMyIdCardDialog', [context]);
                },
              ),
              _topItemBuild(
                title: 'donate'.localized(),
                iconName: 'icon_settings_donate.png',
                isShowDivider: true,
                onTap: () => OXNavigator.pushPage(context, (context) => const DonatePage()),
              ),
              buildOption(
                title: 'ox_usercenter.version',
                iconName: 'icon_settings_version.png',
                rightContent: _version,
                showArrow: false,
                decoration: const BoxDecoration(),
                onTap: (){},
              ),
            ],
          ),
        ),
        SizedBox(height: Adapt.px(24)),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Adapt.px(16)),
            color: ThemeColor.color180,
          ),
          child: _topItemBuild(
            title: 'str_settings'.localized(),
            iconName: 'icon_settings.png',
            onTap: () async {
              OXNavigator.pushPage(context, (context) => const SettingsPage());
    }
          ),
        ),
        SizedBox(height: Adapt.px(24),),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            _logout();
          },
          child: Container(
            width: double.infinity,
            height: Adapt.px(48),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: ThemeColor.color180,
            ),
            alignment: Alignment.center,
            child: Text(
              Localized.text('ox_usercenter.sign_out'),
              style: TextStyle(
                color: ThemeColor.color0,
                fontSize: Adapt.px(15),
              ),
            ),
          ),
        ),
        SizedBox(
          height: Adapt.px(24),
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            _deleteAccountHandler();
          },
          child: Container(
            width: double.infinity,
            height: Adapt.px(48),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: ThemeColor.color180,
            ),
            alignment: Alignment.center,
            child: Text(
              Localized.text('ox_usercenter.delete_account'),
              style: TextStyle(
                color: ThemeColor.red1,
                fontSize: Adapt.px(15),
              ),
            ),
          ),
        ),
        SizedBox(
          height: Adapt.px(130),
        ),
      ],
    );
  }

  Widget _topItemBuild(
      {String? iconName, String? title, String? badgeImgUrl, bool isShowDivider = false, Function()? onTap}) {
    Widget placeholderImage = CommonImage(
      iconName: 'icon_badge_default.png',
      fit: BoxFit.cover,
      width: Adapt.px(48),
      height: Adapt.px(48),
      useTheme: true,
    );
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: Adapt.px(52),
            alignment: Alignment.center,
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: Adapt.px(16)),
              leading: CommonImage(
                iconName: iconName ?? '',
                width: Adapt.px(32),
                height: Adapt.px(32),
                package: 'ox_usercenter',
              ),
              title: Container(
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
                        ? (_isShowZapBadge && iconName == 'icon_settings.png' ? _buildZapBadgeWidget() : Container())
                        : OXCachedNetworkImage(
                      imageUrl: badgeImgUrl,
                      placeholder: (context, url) => placeholderImage,
                      errorWidget: (context, url, error) =>
                      placeholderImage,
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
      ),
    );
  }

  Widget buildHeadImage() {
    String headImgUrl =
        OXUserInfoManager.sharedInstance.currentUserInfo?.picture ?? "";
    LogUtil.e("headImgUrl: $headImgUrl");
    String localAvatarPath = 'assets/images/user_image.png';

    Image placeholderImage = Image.asset(
      localAvatarPath,
      fit: BoxFit.cover,
      width: Adapt.px(76),
      height: Adapt.px(76),
      package: 'ox_common',
    );
    return SizedBox(
      width: Adapt.px(120),
      height: Adapt.px(120),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Adapt.px(120)),
              child: OXCachedNetworkImage(
                imageUrl: headImgUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => placeholderImage,
                errorWidget: (context, url, error) => placeholderImage,
                width: Adapt.px(120),
                height: Adapt.px(120),
              ),
            ),
          ),
          SizedBox(
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
                    color: ThemeColor.color200,
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
            style:
                TextStyle(color: ThemeColor.color120, fontSize: Adapt.px(14)),
            // overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            width: Adapt.px(4),
          ),
          dns.isNotEmpty && _isVerifiedDNS
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

  Widget _buildZapBadgeWidget(){
    return Container(
      color: Colors.transparent,
      width: Adapt.px(6),
      height: Adapt.px(6),
      child: const Image(
        image: AssetImage("assets/images/unread_dot.png"),
      ),
    );
  }

  Widget buildHeadPubKey() {
    String encodedPubKey =
        OXUserInfoManager.sharedInstance.currentUserInfo?.encodedPubkey ?? '';

    String newPubKey = '';
    if (encodedPubKey.isNotEmpty) {
      final String start = encodedPubKey.substring(0, 16);
      final String end = encodedPubKey.substring(encodedPubKey.length - 16);

      newPubKey = '$start:$end';
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        await TookKit.copyKey(context, encodedPubKey);
      },
      child: Container(
        height: Adapt.px(33),
        margin: EdgeInsets.only(top: Adapt.px(8), bottom: Adapt.px(24)),
        padding: EdgeInsets.symmetric(
            horizontal: Adapt.px(12), vertical: Adapt.px(8)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Adapt.px(12)),
          color: ThemeColor.color180,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              newPubKey,
              style: TextStyle(
                  fontSize: Adapt.px(12),
                  fontWeight: FontWeight.w400,
                  color: ThemeColor.color0,
                  overflow: TextOverflow.ellipsis),
            ),
            SizedBox(width: Adapt.px(8)),
            encodedPubKey.isNotEmpty
                ? CommonImage(
                    iconName: "icon_copy.png",
                    width: Adapt.px(16),
                    height: Adapt.px(16),
                    useTheme: true,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  onThemeStyleChange() {
    if (mounted) setState(() {});
  }

  @override
  void didLoginSuccess(UserDB? userInfo) {
    if (mounted) {
      setState(() {
        updateStateView(CommonStateView.CommonStateView_None);
      });
    }
  }

  @override
  void didLogout() {
    LogUtil.e("useercenter.didLogout");
    if (mounted) {
      setState(() {
        updateStateView(CommonStateView.CommonStateView_NotLogin);
      });
    }
  }

  String getHostUrl(String url) {
    RegExp regExp = RegExp(r"^.*?://(.*?)/.*?$");
    RegExpMatch? match = regExp.firstMatch(url);
    if (match != null) {
      return match.group(1) ?? '';
    }
    return '';
  }

  void _verifiedDNS() async {
    UserDB? userDB = OXUserInfoManager.sharedInstance.currentUserInfo;
    if(userDB == null) return;
    var isVerifiedDNS = await OXUserInfoManager.sharedInstance.checkDNS(userDB: userDB);
    if (mounted) {
      setState(() {
      _isVerifiedDNS = isVerifiedDNS;
    });
    }
  }

  void _getPackageInfo() {
    PackageInfo.fromPlatform().then((value) {
      _version = value.version;

      setState(() {});
    });
  }

  void _deleteAccountHandler() {
    OXCommonHintDialog.show(context,
      title: Localized.text('ox_usercenter.warn_title'),
      content: Localized.text('ox_usercenter.delete_account_dialog_content'),
      actionList: [
        OXCommonHintAction.cancel(onTap: () {
          OXNavigator.pop(context);
        }),
        OXCommonHintAction.sure(
          text: Localized.text('ox_common.confirm'),
          onTap: () async {
            OXNavigator.pop(context);
            showDeleteAccountDialog();
          },
        ),
      ],
      isRowAction: true,
    );
  }

  void showDeleteAccountDialog() {
    String userInput = '';
    const matchWord = 'DELETE';
    OXCommonHintDialog.show(
      context,
      title: 'Permanently delete account',
      contentView: TextField(
        onChanged: (value) {
          userInput = value;
        },
        decoration: const InputDecoration(hintText: 'Type $matchWord to delete'),
      ),
      actionList: [
        OXCommonHintAction.cancel(onTap: () {
          OXNavigator.pop(context);
        }),
        OXCommonHintAction(
          text: () => 'Delete',
          style: OXHintActionStyle.red,
          onTap: () async {
            OXNavigator.pop(context);
            if (userInput == matchWord) {
              await OXLoading.show();
              await OXUserInfoManager.sharedInstance.logout();
              await OXLoading.dismiss();
            }
          },
        ),
      ],
      isRowAction: true,
    );
  }

  void _logout() async {
    OXCommonHintDialog.show(context,
        title: Localized.text('ox_usercenter.warn_title'),
        content: Localized.text('ox_usercenter.sign_out_dialog_content'),
        actionList: [
          OXCommonHintAction.cancel(onTap: () {
            OXNavigator.pop(context);
          }),
          OXCommonHintAction.sure(
              text: Localized.text('ox_common.confirm'),
              onTap: () async {
                OXNavigator.pop(context);
                await OXLoading.show();
                await OXUserInfoManager.sharedInstance.logout();
                await OXLoading.dismiss();
              }),
        ],
        isRowAction: true);
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
