import 'package:flutter/material.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/platform_utils.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/user_config_tool.dart';
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
import 'package:chatcore/chat-core.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  late List<SecureModel> _secureModelList = [];
  List<String> _blockList = [];

  List<UserDBISAR> _blockBlockedUser = [];

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
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: PlatformUtils.listWidth
          ),
          child:ListView.builder(
            padding: const EdgeInsets.only(bottom: 0),
            physics: const BouncingScrollPhysics(),
            itemBuilder: _itemBuild,
            itemCount: _secureModelList.length,
          ).setPadding(EdgeInsets.symmetric(horizontal: Adapt.px(24), vertical: Adapt.px(12)))
        ),
      ),

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
    double intervalHeight = 0;
    bool isShowUnderline = false;
    ProxySettings proxyInfo = Config.sharedInstance.getProxy();

    switch (model.settingItemType) {
      case SecureItemType.block:
        rightContent = _blockList.length.toString();
        topLeft = 16.px;
        topRight = 16.px;
        bottomLeft = 16.px;
        bottomRight = 16.px;
        intervalHeight = 24.px;
        break;
      case SecureItemType.secureWithPasscode:
        topLeft = 16.px;
        topRight = 16.px;
        bottomLeft = model.switchValue ? 0 : 16.px;
        bottomRight = model.switchValue ? 0 : 16.px;
        isShowUnderline = model.switchValue;
        intervalHeight = model.switchValue ? 0 : 24.px;
        break;
      case SecureItemType.secureWithFaceID:
        isShowUnderline = true;
        break;
      case SecureItemType.secureWithFingerprint:
        topLeft = 0;
        topRight = 0;
        bottomLeft = 16.px;
        bottomRight = 16.px;
        isShowUnderline = true;
        break;
      case SecureItemType.useSocksProxy:
        topLeft = 16.px;
        topRight = 16.px;
        bottomLeft = model.switchValue ? 0 : 16.px;
        bottomRight = model.switchValue ? 0 : 16.px;
        intervalHeight = model.switchValue ? 0 : 24.px;
        isShowUnderline = model.switchValue;
        break;
      case SecureItemType.useSocksProxyHost:
        isShowUnderline = true;
        rightContent = proxyInfo.socksProxyHost;
        break;
      case SecureItemType.useSocksProxyOnionHost:
        rightContent = proxyInfo.onionHostOption.text;
        isShowUnderline = true;
        break;
      case SecureItemType.useSocksProxyPort:
        isShowUnderline = true;
        rightContent = proxyInfo.socksProxyPort.toString();
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
              actions: model.isShowSwitch ? Container(
                height: 20.px,
                child: Switch(
                  value: model.switchValue,
                  activeColor: Colors.white,
                  activeTrackColor: ThemeColor.gradientMainStart,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: ThemeColor.color160,
                  onChanged: (bool value) async {
                      ProxySettings proxyInfo = Config.sharedInstance.getProxy();
                      proxyInfo.turnOnProxy = !model.switchValue;
                      await Config.sharedInstance.setProxy(proxyInfo);
                      _initData();
                  },
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                ),
              ) : Row(
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
          SizedBox(height:intervalHeight),
          Visibility(
            visible: isShowUnderline && index != _secureModelList.length-1,
            child: Container(
              width: double.infinity,
              height: 0.5.px,
              color: ThemeColor.color160,
            ),
          ),
          _proxyTurnOnTipsWidget(model.settingItemType),
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

  Widget _proxyTurnOnTipsWidget(SecureItemType type){
    if(type != SecureItemType.useSocksProxyOnionHost) return const SizedBox();
    return SizedBox(
      width: double.infinity,
      child: RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
          style: TextStyle(
            color: ThemeColor.color100,
            fontSize: 12.px,
          ),
          children: const [
            TextSpan(
              text: 'No: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: 'Never use .onion hosts\n\n',
            ),
            TextSpan(
              text: 'When available(default): ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: 'Uses .onion hosts when available\n\n',
            ),
            TextSpan(
              text: 'Required: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: 'Always use .onion hosts',
            ),
          ],
        ),
      ),

    ).setPaddingOnly(top: 8.px);
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
    Map<String, UserDBISAR> result = await Account.sharedInstance.getUserInfos(pubKeys);
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
                    UserConfigTool.saveSetting(StorageSettingKey.KEY_PASSCODE.name, '');
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
            String tempPasscode = UserConfigTool.getSetting(StorageSettingKey.KEY_PASSCODE.name, defaultValue: '');
            if (tempPasscode.isNotEmpty) {
              model.switchValue = true;
              _initData();
            }
          });
        }
        break;
      case SecureItemType.secureWithFaceID:
        if (model.switchValue){
          UserConfigTool.saveSetting(StorageSettingKey.KEY_FACEID.name, false);
          model.switchValue = false;
          setState(() {});
        } else {
          bool canCheckBiometrics = await SecurityAuthUtils.checkBiometrics();
          LogUtil.e('--------canCheckBiometrics =$canCheckBiometrics');
          if (canCheckBiometrics) {
            bool authResult = await SecurityAuthUtils.authenticateWithBiometrics('FaceID');
            if (!mounted) return;
            if (authResult) {
              CommonToast.instance.show(context, 'Authorized');
              UserConfigTool.saveSetting(StorageSettingKey.KEY_FACEID.name, true);
              model.switchValue = true;
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
          UserConfigTool.saveSetting(StorageSettingKey.KEY_FINGERPRINT.name, false);
          model.switchValue = false;
          setState(() {});
        } else {
          bool canCheckBiometrics = await SecurityAuthUtils.checkBiometrics();
          LogUtil.e('---secureWithFingerprint-----canCheckBiometrics =$canCheckBiometrics');
          if (canCheckBiometrics) {
            bool authResult = await SecurityAuthUtils.authenticateWithBiometrics('Fingerprint');
            if (!mounted) return;
            if (authResult) {
              CommonToast.instance.show(context, 'Authorized');
              model.switchValue = true;
              UserConfigTool.saveSetting(StorageSettingKey.KEY_FINGERPRINT.name, true);
              setState(() {});
            } else {
              CommonToast.instance.show(context, 'Not Authorized, try again.');
            }
          } else {
            if (mounted) CommonToast.instance.show(context, "Please enable the phone's fingerprint recognition system.");
          }
        }
        break;
      case SecureItemType.useSocksProxyPort:
        ProxySettings proxyInfo = Config.sharedInstance.getProxy();
        final text = await OXCommonHintDialog.showInputDialog(
          context,
          title: 'Set port',
          maxLength: 6,
          keyboardType: TextInputType.number,
          defaultText: proxyInfo.socksProxyPort.toString(),
        );
        if(text != null && text.isNotEmpty){
          proxyInfo.socksProxyPort = int.parse(text);
          await Config.sharedInstance.setProxy(proxyInfo);
          _initData();
        }
        break;
      case SecureItemType.useSocksProxyHost:
        ProxySettings proxyInfo = Config.sharedInstance.getProxy();
        final text = await OXCommonHintDialog.showInputDialog(
          context,
          title: 'Set host',
          keyboardType: TextInputType.text,
          defaultText: proxyInfo.socksProxyHost.toString(),
        );
        if(text != null && text.isNotEmpty){
          proxyInfo.socksProxyHost = text;
          await Config.sharedInstance.setProxy(proxyInfo);
          _initData();
        }
        break;
      case SecureItemType.useSocksProxyOnionHost:
        showModalBottomSheet(context: context, backgroundColor: Colors.transparent, builder: (context) => _buildSetProxyBottomDialog());

        break;
    }
  }
  Widget _buildSetProxyBottomDialog() {
    ProxySettings proxyInfo = Config.sharedInstance.getProxy();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(12)),
        color: ThemeColor.color180,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 8.px,
            ),
            child: Text(
              'use .onion hosts',
              style: TextStyle(
                color: ThemeColor.color100,
                fontSize: 14.px,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Divider(
            color: ThemeColor.color170,
            height: Adapt.px(0.5),
          ),
          ...EOnionHostOption.values.map((EOnionHostOption type){
            return Column(
              children: [
                _buildProxyItem(
                  isSelect: type == proxyInfo.onionHostOption,
                  type.text,
                  onTap: () => _setProxyOnionHost(type),
                ),
                Divider(
                  color: ThemeColor.color170,
                  height: Adapt.px(0.5),
                ),
              ],
            );
          }),
          Container(
            height: Adapt.px(8),
            color: ThemeColor.color190,
          ),
          _buildProxyItem(Localized.text('ox_common.cancel'), onTap: () {
            OXNavigator.pop(context);
          }),
          SizedBox(
            height: Adapt.px(21),
          ),
        ],
      ),
    );
  }

  Widget _buildProxyItem(String title,
      {GestureTapCallback? onTap,bool isSelect = false}) {
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

  void _setProxyOnionHost(EOnionHostOption type) async {
    ProxySettings proxyInfo = Config.sharedInstance.getProxy();
    proxyInfo.onionHostOption = type;
    await Config.sharedInstance.setProxy(proxyInfo);
    _initData();
    OXNavigator.pop(context);
  }
}
