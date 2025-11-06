import 'package:flutter/material.dart';
import 'dart:async';
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
// import 'package:tor/tor.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  late List<SecureModel> _secureModelList = [];
  List<String> _blockList = [];
  Timer? _torStatusTimer;

  List<UserDBISAR> _blockBlockedUser = [];

  @override
  void initState() {
    super.initState();
    _initData();
    _getBlockedUserPubkeys();
    if (_blockList.isNotEmpty) {
      _getBlockUserProfile(_blockList);
    }
    
    // Start timer to refresh Tor status
    _torStatusTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (mounted) {
        _initData();
      }
    });
  }

  @override
  void dispose() {
    _torStatusTimer?.cancel();
    super.dispose();
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
      case SecureItemType.useSystemProxy:
        isShowUnderline = true;
        break;
      case SecureItemType.useSocksProxyHost:
        isShowUnderline = true;
        rightContent = proxyInfo.socksProxyHost;
        break;
      case SecureItemType.useSocksProxyPort:
        isShowUnderline = true;
        rightContent = proxyInfo.socksProxyPort.toString();
        break;
      case SecureItemType.useTorNetwork:
        topLeft = 16.px;
        topRight = 16.px;
        bottomLeft = 16.px;
        bottomRight = 16.px;
        intervalHeight = 24.px;
        break;
    }
    if (index == _secureModelList.length-1){
      bottomLeft = 16.px;
      bottomRight = 16.px;
    }
    
    // Check if item should be disabled (when system proxy is enabled and item is host/port)
    bool isDisabled = proxyInfo.useSystemProxy && 
                      (model.settingItemType == SecureItemType.useSocksProxyHost || 
                       model.settingItemType == SecureItemType.useSocksProxyPort);
    
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: isDisabled ? null : () {
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
              contentColor: isDisabled ? ThemeColor.color100 : null,
              actions: model.isShowSwitch ? _buildSwitchWithLoading(model) : Row(
                children: [
                  Text(
                    rightContent,
                    style: TextStyle(fontSize: Adapt.px(16), fontWeight: FontWeight.w400, color: isDisabled ? ThemeColor.color160 : ThemeColor.color100),
                  ),
                  CommonImage(
                    iconName: 'icon_arrow_more.png',
                    width: Adapt.px(24),
                    height: Adapt.px(24),
                    color: isDisabled ? ThemeColor.color160 : null,
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
        ],
      ),
    );
  }

  Widget _buildSwitchWithLoading(SecureModel model) {
    // Check if this is Tor Network switch and if it's connecting
    if (model.settingItemType == SecureItemType.useTorNetwork && model.switchValue) {
      final proxyInfo = Config.sharedInstance.getProxy();

      // Show loading animation if Tor is enabled but not yet connected
      if (proxyInfo.turnOnTor && !TorNetworkHelper.isTorEnabled) {
        return Container(
          height: 20.px,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: Adapt.px(16),
                height: Adapt.px(16),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(ThemeColor.gradientMainStart),
                ),
              ),
              SizedBox(width: Adapt.px(8)),
              Switch(
                value: model.switchValue,
                activeColor: Colors.white,
                activeTrackColor: ThemeColor.gradientMainStart,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: ThemeColor.color160,
                onChanged: (bool value) async {
                    _itemOnTap(model);
                },
                materialTapTargetSize: MaterialTapTargetSize.padded,
              ),
            ],
          ),
        );
      }
    }
    
    // Default switch
    return Container(
      height: 20.px,
      child: Switch(
        value: model.switchValue,
        activeColor: Colors.white,
        activeTrackColor: ThemeColor.gradientMainStart,
        inactiveThumbColor: Colors.white,
        inactiveTrackColor: ThemeColor.color160,
        onChanged: (bool value) async {
            _itemOnTap(model);
        },
        materialTapTargetSize: MaterialTapTargetSize.padded,
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
              CommonToast.instance.show(context, Localized.text('ox_usercenter.str_authorized'));
              UserConfigTool.saveSetting(StorageSettingKey.KEY_FACEID.name, true);
              model.switchValue = true;
              setState(() {});
            } else {
              CommonToast.instance.show(context, Localized.text('ox_usercenter.str_not_authorized_try_again'));
            }
          } else {
            if (mounted) CommonToast.instance.show(context, Localized.text('ox_usercenter.str_enable_faceid_system'));
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
              CommonToast.instance.show(context, Localized.text('ox_usercenter.str_authorized'));
              model.switchValue = true;
              UserConfigTool.saveSetting(StorageSettingKey.KEY_FINGERPRINT.name, true);
              setState(() {});
            } else {
              CommonToast.instance.show(context, Localized.text('ox_usercenter.str_not_authorized_try_again'));
            }
          } else {
            if (mounted) CommonToast.instance.show(context, Localized.text('ox_usercenter.str_enable_fingerprint_system'));
          }
        }
        break;
      case SecureItemType.useSystemProxy:
        // ProxySettings systemProxyInfo = Config.sharedInstance.getProxy();
        //
        // // If turning on system proxy, check if available
        // if (!model.switchValue) {
        //   // Show loading dialog
        //   OXCommonHintDialog.show(
        //     context,
        //     showCancelButton: false,
        //     isRowAction: false,
        //     content: Localized.text('ox_common.loading'),
        //   );
        //
        //   try {
        //     // Check system proxy
        //     await Tor.instance.checkSystemProxy();
        //
        //     // Get system proxy
        //     final systemProxy = Tor.instance.currentSystemProxy();
        //
        //     // Close loading dialog
        //     if (mounted) OXNavigator.pop(context);
        //
        //     if (systemProxy == null) {
        //       // No system proxy available
        //       if (mounted) {
        //         CommonToast.instance.show(
        //           context,
        //           Localized.text('ox_usercenter.system_proxy_not_available')
        //         );
        //       }
        //       return;
        //     }
        //
        //     // System proxy available, enable it
        //     systemProxyInfo.useSystemProxy = true;
        //     await Config.sharedInstance.setProxy(systemProxyInfo);
        //     _initData();
        //   } catch (e) {
        //     // Close loading dialog
        //     if (mounted) OXNavigator.pop(context);
        //
        //     // Show error
        //     if (mounted) {
        //       CommonToast.instance.show(
        //         context,
        //         Localized.text('ox_usercenter.system_proxy_check_failed')
        //       );
        //     }
        //     LogUtil.e('[SystemProxy] Check failed: $e');
        //   }
        // } else {
        //   // Turning off system proxy
        //   systemProxyInfo.useSystemProxy = false;
        //   await Config.sharedInstance.setProxy(systemProxyInfo);
        //   _initData();
        // }
        break;
      case SecureItemType.useSocksProxyPort:
        ProxySettings proxyInfo = Config.sharedInstance.getProxy();
        if (proxyInfo.useSystemProxy) return;
        final text = await OXCommonHintDialog.showInputDialog(
          context,
          title: Localized.text('ox_usercenter.str_set_port'),
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
        if (proxyInfo.useSystemProxy) return;
        final text = await OXCommonHintDialog.showInputDialog(
          context,
          title: Localized.text('ox_usercenter.str_set_host'),
          keyboardType: TextInputType.text,
          defaultText: proxyInfo.socksProxyHost.toString(),
        );
        if(text != null && text.isNotEmpty){
          proxyInfo.socksProxyHost = text;
          await Config.sharedInstance.setProxy(proxyInfo);
          _initData();
        }
        break;
      case SecureItemType.useSocksProxy:
        ProxySettings proxy = Config.sharedInstance.getProxy();
        final newValue = !model.switchValue;
        if (proxy.turnOnProxy == newValue) return;

        proxy.turnOnProxy = newValue;
        await Config.sharedInstance.setProxy(proxy);

        _initData();
        break;
      case SecureItemType.useTorNetwork:
        final proxy = Config.sharedInstance.getProxy();
        final isUseTor = proxy.turnOnTor;
        final newValue = !model.switchValue;
        if (newValue == isUseTor) return;

        if (newValue) {
          try {
            await TorNetworkHelper.start();
            proxy.turnOnTor = true;
            await Config.sharedInstance.setProxy(proxy);
          } catch (err) {
            CommonToast.instance.show(context, 'Failed to enable Tor: $err');
          }
        } else {
          proxy.turnOnTor = false;
          await Config.sharedInstance.setProxy(proxy);
        }

        _initData();
        break;
    }
  }
}
