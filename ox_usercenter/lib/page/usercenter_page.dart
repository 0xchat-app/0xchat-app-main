import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cashu_dart/cashu_dart.dart';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/business_interface/ox_chat/interface.dart';
import 'package:ox_common/business_interface/ox_wallet/interface.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:ox_common/model/msg_notification_model.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/navigator/slide_bottom_to_top_route.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_chat_observer.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/took_kit.dart';
import 'package:ox_common/utils/user_config_tool.dart';
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
import 'package:ox_usercenter/page/set_up/relays_page.dart';
import 'package:ox_usercenter/page/set_up/settings_page.dart';
import 'package:ox_usercenter/page/set_up/switch_account_page.dart';
import 'package:ox_usercenter/page/set_up/zaps_page.dart';
import 'package:ox_usercenter/utils/widget_tool.dart';
part 'usercenter_page_ui.dart';

class UserCenterPage extends StatefulWidget {
  const UserCenterPage({Key? key}) : super(key: key);

  @override
  State<UserCenterPage> createState() => UserCenterPageState();
}

class UserCenterPageState extends State<UserCenterPage>
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
  }

  @override
  void didZapRecordsCallBack(ZapRecordsDBISAR zapRecordsDB,{Function? onValue}) {
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

  void _initInterface() {
    _isShowZapBadge = _getZapBadge();
    if (mounted) setState(() {});
  }

  bool _getZapBadge() {
    return UserConfigTool.getSetting(StorageSettingKey.KEY_ZAP_BADGE.name, defaultValue: false);
  }

  //get user selected Badge Info from DB
  Future<BadgeDBISAR?> _getUserSelectedBadgeInfo() async {
    String badges =
        OXUserInfoManager.sharedInstance.currentUserInfo?.badges ?? '';
    BadgeDBISAR? badgeDB;
    try {
      if (badges.isNotEmpty) {
        List<dynamic> badgeListDynamic = jsonDecode(badges);
        List<String> badgeList = badgeListDynamic.cast();
        List<BadgeDBISAR?> badgeDBList =
            await BadgesHelper.getBadgeInfosFromDB(badgeList);
        if (badgeDBList.isNotEmpty) {
          badgeDB = badgeDBList.first;
          return badgeDB;
        }
      } else {
        List<BadgeDBISAR?>? badgeDBList =
            await BadgesHelper.getAllProfileBadgesFromRelay(
                OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '');
        if (badgeDBList != null && badgeDBList.isNotEmpty) {
          badgeDB = badgeDBList.firstOrNull;
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
        leading: OXButton(
          color: Colors.transparent,
          highlightColor: Colors.transparent,
          child: CommonImage(
            iconName: 'icon_qrcode.png',
            size: 24.px,
            package: 'ox_usercenter',
            color: ThemeManager.getCurrentThemeStyle().index == 0 ? ThemeColor.color200 : null,
          ),
          onPressed: () {
            OXModuleService.invoke('ox_chat', 'showMyIdCardDialog', [context]);
          },
        ),
        actions: <Widget>[
          if (isLogin)
            Container(
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
                  OXNavigator.presentPage(
                    context,
                    fullscreenDialog: true,
                        (_) => const ProfileSetUpPage(),
                  ).then((value) {
                    setState(() {});
                  });
                },
              ),
            ),
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

  onThemeStyleChange() {
    if (mounted) setState(() {});
  }

  @override
  void didLoginSuccess(UserDBISAR? userInfo) {
    if (mounted) {
      setState(() {
        updateStateView(CommonStateView.CommonStateView_None);
      });
    }
  }

  @override
  void didLogout() {
    if (mounted) {
      setState(() {
        updateStateView(CommonStateView.CommonStateView_NotLogin);
        LogUtil.e("usercenter.didLogout");
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
    UserDBISAR? userDB = OXUserInfoManager.sharedInstance.currentUserInfo;
    if(userDB == null) return;
    var isVerifiedDNS = await OXUserInfoManager.sharedInstance.checkDNS(userDB: userDB);
    if (mounted) {
      setState(() {
      _isVerifiedDNS = isVerifiedDNS;
    });
    }
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

  void _updateState() {
    if (mounted) {
      setState(() {
        _isShowZapBadge = _getZapBadge();
      });
    }
  }

  void _switchAccount() {
    OXNavigator.pushPage(context, (context) => const SwitchAccountPage());
  }

  @override
  void didSwitchUser(UserDBISAR? userInfo) {
    if (mounted) {
      if (OXUserInfoManager.sharedInstance.isLogin){
        setState(() {
          updateStateView(CommonStateView.CommonStateView_None);
        });
      }
      _verifiedDNS();
    }
  }

}
