import 'dart:io';

import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:local_auth/local_auth.dart';
import 'package:ox_common/utils/user_config_tool.dart';
import 'package:ox_usercenter/utils/security_auth_utils.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_localizable/ox_localizable.dart';

///Title: security_model
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/12/7 16:17
class SecureModel {
  final String iconName;
  final String title;
  final bool showArrow;
  bool switchValue;
  final bool isShowSwitch;
  final SecureItemType settingItemType;

  SecureModel({
    this.iconName = '',
    this.title = '',
    this.showArrow = true,
    this.switchValue = false,
    this.isShowSwitch = false,
    this.settingItemType = SecureItemType.secureWithPasscode,
  });

  static Future<List<SecureModel>> getUIListData() async {
    List<SecureModel> settingModelList = [];
    settingModelList.add(SecureModel(
      iconName: 'icon_privacy_block.png',
      title: 'ox_usercenter.blocked_users_title',
      showArrow: true,
      settingItemType: SecureItemType.block,
    ));
    String passcode = UserConfigTool.getSetting(StorageSettingKey.KEY_PASSCODE.name, defaultValue: '');
    bool passcodeSwitchValue = false;
    if (passcode.isNotEmpty) {
      passcodeSwitchValue = true;
    }
    settingModelList.add(SecureModel(
      iconName: 'icon_secure_passcode.png',
      title: 'ox_usercenter.str_secure_with_passcode',
      switchValue: passcodeSwitchValue,
      settingItemType: SecureItemType.secureWithPasscode,
    ));

    if (passcodeSwitchValue){
      List<BiometricType> availableBiometrics = await SecurityAuthUtils.getAvailableBiometrics();
      bool faceIDSwitchValue = UserConfigTool.getSetting(StorageSettingKey.KEY_FACEID.name, defaultValue: false);
      if (availableBiometrics.contains(BiometricType.face)) {
        if (Platform.isIOS) {
          settingModelList.add(SecureModel(
            iconName: 'icon_secure_face_id.png',
            title: 'ox_usercenter.str_secure_with_face_id',
            switchValue: faceIDSwitchValue,
            settingItemType: SecureItemType.secureWithFaceID,
          ));
        }
      }
      bool fingerprintSwitchValue = UserConfigTool.getSetting(StorageSettingKey.KEY_FINGERPRINT.name, defaultValue: false);
      if (Platform.isAndroid || availableBiometrics.contains(BiometricType.fingerprint)) {
        settingModelList.add(SecureModel(
          iconName: 'icon_secure_fingerprint.png',
          title: 'ox_usercenter.str_secure_with_fingerprint',
          switchValue: fingerprintSwitchValue,
          settingItemType: SecureItemType.secureWithFingerprint,
        ));
      }
    }

    ProxySettings proxyInfo = Config.sharedInstance.getProxy();
    
    // Add Tor Network switch first
    settingModelList.add(SecureModel(
      iconName: 'icon_privacy_tor.png',
      title: 'ox_usercenter.use_tor_network',
      isShowSwitch: true,
      switchValue: proxyInfo.turnOnTor,
      showArrow: false,
      settingItemType: SecureItemType.useTorNetwork,
    ));

    // Add SOCKS Proxy switch
    settingModelList.add(SecureModel(
      iconName: 'icon_privacy_socks.png',
      title: 'ox_usercenter.use_socks_proxy',
      isShowSwitch: true,
      switchValue: proxyInfo.turnOnProxy,
      showArrow: false,
      settingItemType: SecureItemType.useSocksProxy,
    ));

    // Show SOCKS proxy settings only when SOCKS is enabled and Tor is disabled
    if(proxyInfo.turnOnProxy && !proxyInfo.turnOnTor){
      settingModelList.add(SecureModel(
        iconName: 'icon_privacy_host.png',
        title:  'ox_usercenter.use_socks_proxy_host',
        showArrow: false,
        settingItemType: SecureItemType.useSocksProxyHost,
      ));
      settingModelList.add(SecureModel(
        iconName: 'icon_privacy_port.png',
        title:  'ox_usercenter.use_socks_proxy_port',
        showArrow: false,
        settingItemType: SecureItemType.useSocksProxyPort,
      ));
      settingModelList.add(SecureModel(
        iconName: 'icon_privacy_onion_host.png',
        title:  'ox_usercenter.use_socks_proxy_onion_host',
        showArrow: false,
        settingItemType: SecureItemType.useSocksProxyOnionHost,
      ));
    }

    return settingModelList;
  }
}

enum SecureItemType {
  block,
  useSocksProxy,
  useTorNetwork,
  useSocksProxyPort,
  useSocksProxyHost,
  useSocksProxyOnionHost,
  secureWithPasscode,
  secureWithFaceID,
  secureWithFingerprint,
}

extension EOnionHostOptionEx on EOnionHostOption{
  String get text {
    switch (this) {
      case EOnionHostOption.required:
        return Localized.text('ox_usercenter.str_required');
      case EOnionHostOption.no:
        return 'No';
      case EOnionHostOption.whenAvailable:
        return Localized.text('ox_usercenter.str_when_available');
    }
  }
}