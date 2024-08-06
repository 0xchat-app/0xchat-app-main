import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/model/user_config_tool.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_button.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:ox_theme/ox_theme.dart';
import 'package:ox_usercenter/utils/widget_tool.dart';
import 'package:ox_usercenter/widget/clear_account_selector_dialog.dart';


///Title: switch_account_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/7/24 16:39
class SwitchAccountPage extends StatefulWidget {
  const SwitchAccountPage({super.key});

  @override
  State<SwitchAccountPage> createState() => _SwitchAccountPageState();
}

class _SwitchAccountPageState extends State<SwitchAccountPage> {
  ThemeStyle? themeStyle;
  int _selectedIndex = 0;
  UserDBISAR? _currentUser;
  Map<String, MultipleUserModel> _currentUserMap = {};
  List<MultipleUserModel> _userCacheList = [];
  bool _isManage = false;

  @override
  void initState() {
    super.initState();
    _loadLocalInfo();
  }

  void _loadLocalInfo() async {
    _currentUser = OXUserInfoManager.sharedInstance.currentUserInfo;
    _currentUserMap = await UserConfigTool.getAllUser();
    _userCacheList = _currentUserMap.values.toList();
    LogUtil.e('Michael:---_loadLocalInfo---_userCacheList =${_userCacheList}');
    _selectedIndex = _userCacheList.indexWhere((user) => user.pubKey == (_currentUser?.pubKey ?? ''));
    LogUtil.e('Michael:---_loadLocalInfo---_selectedIndex =${_selectedIndex}');
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color200,
      appBar: CommonAppBar(
        useLargeTitle: false,
        centerTitle: true,
        backgroundColor: ThemeColor.color200,
        actions: [
          Container(
            margin: EdgeInsets.only(
              right: Adapt.px(14),
            ),
            color: Colors.transparent,
            child: OXButton(
              highlightColor: Colors.transparent,
              color: Colors.transparent,
              minWidth: Adapt.px(44),
              height: Adapt.px(44),
              child: abbrText(
              _isManage ? Localized.text('ox_common.cancel') : 'str_account_manage'.localized(),
                16.px,
                ThemeColor.color0,
                fontWeight: FontWeight.w600,
              ),
              onPressed: () {
                _isManage = !_isManage;
                setState(() {});
              },
            ),
          )
        ],
      ),
      body: _buildBody().setPadding(EdgeInsets.symmetric(
          horizontal: Adapt.px(24), vertical: Adapt.px(12))),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: CommonImage(iconName: 'icon_badge_default.png', size: 48.px, useTheme: true),
          ),
          SizedBox(height: 16.px),
          Align(
            alignment: Alignment.center,
            child: abbrText(
              'str_account_manage_hint'.localized(),
              24.px,
              ThemeColor.color0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 24.px),
          _buildAccountList(),
          SizedBox(height: 16.px),
          _buildItem(-1, isAdd: true),
        ],
      ),
    );
  }

  Widget _buildAccountList() {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 0),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return _buildItem(index);
      },
      separatorBuilder: (BuildContext context, int index) => Divider(
        height: 16.px,
        color: ThemeColor.color200,
      ),
      itemCount: _userCacheList.length,
    );
  }

  Widget _buildItem(int index, {bool isAdd = false}) {
    MultipleUserModel? multipleUserModel;
    if (_userCacheList.isNotEmpty && index > -1){
      multipleUserModel = _userCacheList[index];
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        if (isAdd) {
          OXModuleService.pushPage(context, 'ox_login', 'LoginPage', {});
        } else {
          String pubKey = multipleUserModel?.pubKey ?? '';
          if (pubKey.isEmpty) {
            CommonToast.instance.show(context, 'PubKey is empty, try other.');
            return;
          }
          if (await _checkAccount(pubKey)) {
            await OXLoading.show();
            await OXUserInfoManager.sharedInstance.switchAccount(pubKey);
            await OXLoading.dismiss();
            _selectedIndex = index;
            setState(() {});
          }
        }
      },
      child: Container(
        height: 86.px,
        padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 8.px),
        decoration: BoxDecoration(
          color: ThemeColor.color180,
          borderRadius: BorderRadius.circular(16.px),
          gradient: _selectedIndex == index && !isAdd ? _getLinearGradientBg(0.24) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isAdd ? CommonImage(iconName: 'add_circle_icon.png', size: 54.px, package: 'ox_common', useTheme: true,)
            : OXUserAvatar(),
            SizedBox(width: 12.px),
            isAdd ? abbrText(
              'Add Account',
              16.px,
              ThemeColor.color0,
              fontWeight: FontWeight.w500,
            ) : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                abbrText(
                  multipleUserModel?.name ?? '',
                  16.px,
                  ThemeColor.color0,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 4.px),
                abbrText(
                  multipleUserModel?.dns ?? '',
                  12.px,
                  ThemeColor.color100,
                ),
              ],
            ),
            const Spacer(),
            Visibility(
              visible: _isManage && _selectedIndex != index && !isAdd,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _clearTap(multipleUserModel?.pubKey ?? '');
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 18.5.px, vertical: 5.px),
                  decoration: BoxDecoration(
                    color: ThemeColor.color100,
                    borderRadius: BorderRadius.circular(8.px),
                    gradient: _getLinearGradientBg(1),
                  ),
                  child: abbrText('str_clear_account'.localized(), 14.px, ThemeColor.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LinearGradient _getLinearGradientBg(double opacity){
    return LinearGradient(
      colors: [
        ThemeColor.gradientMainEnd.withOpacity(opacity),
        ThemeColor.gradientMainStart.withOpacity(opacity),
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );
  }

  void _clearTap(String? pubkey) async {
    if (pubkey == null || pubkey.isEmpty) return;
    var result = await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return const ClearAccountSelectorDialog();
      },
    );
    if (result != null && result is bool && result) {
      await UserConfigTool.deleteUser(_currentUserMap, pubkey);
      if (mounted) setState(() {});
    }
  }

  Future<bool> _checkAccount(String pubKey) async {
    final bool? localIsLoginAmber = await OXCacheManager.defaultOXCacheManager.getForeverData('${pubKey}${StorageKeyTool.KEY_IS_LOGIN_AMBER}');
    if (localIsLoginAmber != null && localIsLoginAmber) {
      bool isInstalled = await CoreMethodChannel.isInstalledAmber();
      bool signatureVerifyFailed = false;
      if (isInstalled) {
        String? signature = await ExternalSignerTool.getPubKey();
        if (signature != null) {
          String decodeSignature = UserDB.decodePubkey(signature) ?? '';
          if (decodeSignature == pubKey) {
            signatureVerifyFailed = false;
            return true;
          } else {
            signatureVerifyFailed = true;
          }
        }
      }
      if (mounted && (!isInstalled || signatureVerifyFailed)){
        String showTitle = '';
        String showContent = '';
        if (!isInstalled) {
          showTitle = 'ox_common.open_singer_app_error_title';
          showContent = 'ox_common.open_singer_app_error_content';
        } else if (signatureVerifyFailed){
          showTitle = 'ox_common.tips';
          showContent = 'ox_common.str_singer_app_verify_failed_hint';
        }
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
      //verify failed
      return false;
    }
    //nesc
    return true;
  }
}
