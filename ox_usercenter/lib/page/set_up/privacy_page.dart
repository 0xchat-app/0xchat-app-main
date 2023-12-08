import 'package:flutter/material.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_usercenter/model/secure_model.dart';
import 'package:ox_usercenter/page/set_up/passcode_page.dart';
import 'package:ox_usercenter/page/set_up/privacy_blocked_page.dart';
import 'package:ox_usercenter/utils/security_auth_utils.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  late List<SecureModel> _secureModelList = [];
  List<String> _blockList = [];

  List<UserDB> _blockBlockedUser = [];

  @override
  void initState() {
    super.initState();
    _initData();
    _getBlockedUserPubkeys();
    if (_blockList.isNotEmpty) {
      _getBlockUserProfile(_blockList);
    }
  }

  void _initData() async {
    _secureModelList = await SecureModel.getUIListData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: Localized.text('ox_usercenter.privacy'),
        centerTitle: true,
        useLargeTitle: false,
      ),
      backgroundColor: ThemeColor.color190,
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 0),
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: _itemBuild,
        itemCount: _secureModelList.length,
      ).setPadding(EdgeInsets.symmetric(horizontal: Adapt.px(24), vertical: Adapt.px(12))),
    );
  }

  Widget _itemBuild(BuildContext context, int index) {
    SecureModel model = _secureModelList[index];
    String rightContent = '';
    double topLeft = 0;
    double topRight = 0;
    double bottomLeft = 0;
    double bottomRight = 0;
    rightContent = model.switchValue ? 'on' : 'off';
    switch (model.settingItemType) {
      case SecureItemType.block:
        rightContent = _blockList.length.toString();
        topLeft = 16.px;
        topRight = 16.px;
        bottomLeft = 16.px;
        bottomRight = 16.px;
        break;
      case SecureItemType.secureWithPasscode:
        topLeft = 16.px;
        topRight = 16.px;
        bottomLeft = 0;
        bottomRight = 0;
        break;
      case SecureItemType.secureWithFaceID:
        break;
      case SecureItemType.secureWithFingerprint:
        topLeft = 0;
        topRight = 0;
        bottomLeft = 16.px;
        bottomRight = 16.px;
        break;
    }
    if (index == _secureModelList.length-1){
      bottomLeft = 16.px;
      bottomRight = 16.px;
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _itemOnTap(model);
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: Adapt.px(12), horizontal: Adapt.px(16)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(topLeft),
                  topRight: Radius.circular(topRight),
                  bottomLeft: Radius.circular(bottomLeft),
                  bottomRight: Radius.circular(bottomRight)),
              color: ThemeColor.color180,
            ),
            child: _buildItem(
              leading: CommonImage(
                iconName: model.iconName,
                width: Adapt.px(32),
                height: Adapt.px(32),
                package: 'ox_usercenter',
              ),
              content: Localized.text(model.title),
              actions: Row(
                children: [
                  Text(
                    rightContent,
                    style: TextStyle(fontSize: Adapt.px(16), fontWeight: FontWeight.w400, color: ThemeColor.color100),
                  ),
                  CommonImage(
                    iconName: 'icon_arrow_more.png',
                    width: Adapt.px(24),
                    height: Adapt.px(24),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: model.settingItemType == SecureItemType.block ? 24.px : 0),
          Visibility(
            visible: model.settingItemType != SecureItemType.block && index != _secureModelList.length-1,
            child: Container(
              width: double.infinity,
              height: 0.5.px,
              color: ThemeColor.color160,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({String? content, Widget? leading, Widget? actions, Color? contentColor}) {
    return Row(children: [
      leading ?? Container(),
      SizedBox(
        width: Adapt.px(12),
      ),
      Expanded(
        child: Text(
          content ?? '',
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: TextStyle(
            fontSize: Adapt.px(16),
            fontWeight: FontWeight.w400,
            color: contentColor ?? ThemeColor.color0,
            height: Adapt.px(22) / Adapt.px(16),
          ),
        ),
      ),
      actions ?? Container()
    ]);
  }

  void _getBlockedUserPubkeys() {
    List<String>? blockResult = Contacts.sharedInstance.blockList;
    if (blockResult != null) {
      setState(() {
        _blockList = blockResult;
      });
    }
  }

  Future<void> _getBlockUserProfile(List<String> pubKeys) async {
    Map<String, UserDB> result = await Account.sharedInstance.getUserInfos(pubKeys);
    _blockBlockedUser = result.values.toList();
  }

  void _itemOnTap(SecureModel model) async {
    switch (model.settingItemType) {
      case SecureItemType.block:
        OXNavigator.pushPage(
            context,
            (context) => PrivacyBlockedPage(
                  blockedUsers: _blockBlockedUser,
                )).then((value) {
          if (value != null) {
            _getBlockedUserPubkeys();
            _getBlockUserProfile(_blockList);
          }
        });
        break;
      case SecureItemType.secureWithPasscode:
        if (model.switchValue) {
          OXCommonHintDialog.show(
            context,
            title: 'Disabling Security',
            content: 'Switching off your passcode protection will leave your wallet unsecured and may expose your funds.',
            actionList: [
              OXCommonHintAction(
                  text: () => 'Remove Passcode',
                  onTap: () {
                    OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.KEY_PASSCODE, '');
                    model.switchValue = false;
                    for(SecureModel model in _secureModelList){
                      model.switchValue = false;
                    }
                    OXNavigator.pop(context);
                  }),
              OXCommonHintAction(
                  text: () => 'Cancel',
                  onTap: () {
                    OXNavigator.pop(context);
                  }),
            ],
          );
        } else {
          OXNavigator.pushPage(context, (context) => PasscodePage()).then((value) async {
            String tempPasscode = await OXCacheManager.defaultOXCacheManager.getForeverData(StorageKeyTool.KEY_PASSCODE, defaultValue: '');
            if (tempPasscode.isNotEmpty) {
              model.switchValue = true;
              _initData();
            }
          });
        }
        break;
      case SecureItemType.secureWithFaceID:
        if (model.switchValue){
          await OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.KEY_FACEID, false);
          model.switchValue = false;
          setState(() {});
        } else {
          bool canCheckBiometrics = await SecurityAuthUtils.checkBiometrics();
          LogUtil.e('--------canCheckBiometrics =${canCheckBiometrics}');
          if (canCheckBiometrics) {
            bool authResult = await SecurityAuthUtils.authenticateWithBiometrics('FaceID');
            if (!mounted) return;
            if (authResult) {
              CommonToast.instance.show(context, 'Authorized');
              await OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.KEY_FACEID, true);
              model.switchValue = false;
              setState(() {});
            } else {
              CommonToast.instance.show(context, 'Not Authorized, try again.');
            }
          } else {
            if (mounted) CommonToast.instance.show(context, "Please enable the phone's FaceID recognition system.");
          }
        }
        break;
      case SecureItemType.secureWithFingerprint:
        if (model.switchValue){
          await OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.KEY_FINGERPRINT, false);
          model.switchValue = false;
          setState(() {});
        } else {
          bool canCheckBiometrics = await SecurityAuthUtils.checkBiometrics();
          LogUtil.e('---secureWithFingerprint-----canCheckBiometrics =${canCheckBiometrics}');
          if (canCheckBiometrics) {
            bool authResult = await SecurityAuthUtils.authenticateWithBiometrics('Fingerprint');
            if (!mounted) return;
            if (authResult) {
              CommonToast.instance.show(context, 'Authorized');
              model.switchValue = true;
              await OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.KEY_FINGERPRINT, true);
              setState(() {});
            } else {
              CommonToast.instance.show(context, 'Not Authorized, try again.');
            }
          } else {
            if (mounted) CommonToast.instance.show(context, "Please enable the phone's fingerprint recognition system.");
          }
        }
        break;
    }
  }
}
