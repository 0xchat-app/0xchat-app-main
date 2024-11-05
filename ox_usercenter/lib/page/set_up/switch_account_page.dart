import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/user_config_tool.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
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

class _SwitchAccountPageState extends State<SwitchAccountPage> with OXUserInfoObserver{
  ThemeStyle? themeStyle;
  int _selectedIndex = -1;
  Map<String, MultipleUserModel> _currentUserMap = {};
  List<MultipleUserModel> _userCacheList = [];

  @override
  void initState() {
    super.initState();
    OXUserInfoManager.sharedInstance.addObserver(this);
    ThemeManager.addOnThemeChangedCallback(onThemeStyleChange);
    _loadLocalInfo();
  }


  @override
  void dispose() {
    OXUserInfoManager.sharedInstance.removeObserver(this);
    super.dispose();
  }

  onThemeStyleChange() {
    if (mounted) setState(() {});
  }

  void _loadLocalInfo() async {
    UserDBISAR? _currentUser = OXUserInfoManager.sharedInstance.currentUserInfo;
    if (_currentUser != null) {
      //update user list
      await UserConfigTool.saveUser(_currentUser);
    }
    _currentUserMap = await UserConfigTool.getAllUser();
    _userCacheList = _currentUserMap.values.toList();
    // _selectedIndex = _userCacheList.indexWhere((user) => user.pubKey == (_currentUser?.pubKey ?? ''));
    _userCacheList.removeWhere((user) => user.pubKey == (_currentUser?.pubKey ?? ''));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColor.color180,
        borderRadius: BorderRadius.circular(16.px),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildAccountList(),
          Visibility(
            visible: _userCacheList.isNotEmpty,
            child: Divider(
              height: 0.5.px,
              color: ThemeColor.color160,
            ),
          ),
          _buildItem(-1, isAdd: true),
        ],
      ),
    );
  }

  Widget _buildAccountList() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 0),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return _buildItem(index);
      },
      separatorBuilder: (BuildContext context, int index) => Divider(
        height: 0.5.px,
        color: ThemeColor.color160,
      ),
      itemCount: _userCacheList.length,
    );
  }

  Widget _buildItem(int index, {bool isAdd = false}) {
    MultipleUserModel? multipleUserModel;
    if (_userCacheList.isNotEmpty && index > -1) {
      multipleUserModel = _userCacheList[index];
    }

    String showName = multipleUserModel?.name ?? '';
    String showPicture = multipleUserModel?.picture ?? '';
    String showDns = '';//multipleUserModel?.dns ?? '';
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
          await OXLoading.show();
          await OXUserInfoManager.sharedInstance.switchAccount(pubKey);
          await OXLoading.dismiss();
          // _selectedIndex = index;
          setState(() {});
        }
      },
      child: Container(
        height: 57.px,
        padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 10.px),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isAdd
                ? CommonImage(
                    iconName: 'add_circle_icon.png',
                    size: 32.px,
                    package: 'ox_common',
                    useTheme: true,
                  )
                : OXUserAvatar(imageUrl: showPicture, size: 32.px),
            SizedBox(width: 12.px),
            isAdd
                ? abbrText(
                    'Add Account',
                    16.px,
                    ThemeColor.color0,
                    fontWeight: FontWeight.w500,
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      abbrText(
                        showName,
                        16.px,
                        ThemeColor.color0,
                        fontWeight: FontWeight.w500,
                      ),
                      showDns.isNotEmpty
                          ? SizedBox(height: 4.px)
                          : const SizedBox(),
                      showDns.isNotEmpty
                          ? abbrText(
                              showDns,
                              12.px,
                              ThemeColor.color100,
                            )
                          : const SizedBox(),
                    ],
                  ),
            // const Spacer(),
            // Visibility(
            //   visible: _selectedIndex == index && !isAdd,
            //   child: CommonImage(
            //     iconName: 'icon_item_selected.png',
            //     size: 24.px,
            //     package: 'ox_usercenter',
            //   ),
            // ),
            // Visibility(
            //   visible: _isManage && _selectedIndex != index && !isAdd,
            //   child: GestureDetector(
            //     behavior: HitTestBehavior.translucent,
            //     onTap: () {
            //       _clearTap(multipleUserModel?.pubKey ?? '', showName);
            //     },
            //     child: Container(
            //       padding:
            //           EdgeInsets.symmetric(horizontal: 18.5.px, vertical: 5.px),
            //       decoration: BoxDecoration(
            //         color: ThemeColor.color100,
            //         borderRadius: BorderRadius.circular(8.px),
            //         gradient: _getLinearGradientBg(1),
            //       ),
            //       child: abbrText(
            //           'str_clear_account'.localized(), 14.px, ThemeColor.white),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  LinearGradient _getLinearGradientBg(double opacity) {
    return LinearGradient(
      colors: [
        ThemeColor.gradientMainEnd.withOpacity(opacity),
        ThemeColor.gradientMainStart.withOpacity(opacity),
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );
  }

  void _clearTap(String? pubkey, String showName) async {
    if (pubkey == null || pubkey.isEmpty) return;
    var result = await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ClearAccountSelectorDialog(name: showName);
      },
    );
    if (result != null && result is bool && result) {
      await UserConfigTool.deleteUser(_currentUserMap, pubkey);
      _userCacheList = _currentUserMap.values.toList();
      if (_userCacheList.isEmpty) {
        OXUserInfoManager.sharedInstance.logout();
      }
      if (mounted) setState(() {});
    }
  }

  @override
  void didLoginSuccess(UserDBISAR? userInfo) {
    _loadLocalInfo();
  }

  @override
  void didLogout() {

  }

  @override
  void didSwitchUser(UserDBISAR? userInfo) {
    _loadLocalInfo();
  }
}
