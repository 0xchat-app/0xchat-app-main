import 'dart:io';

import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:local_auth/local_auth.dart';
import 'package:ox_usercenter/utils/security_auth_utils.dart';

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
  final SecureItemType settingItemType;

  SecureModel({
    this.iconName = '',
    this.title = '',
    this.showArrow = true,
    this.switchValue = false,
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
    String passcode = await OXCacheManager.defaultOXCacheManager.getForeverData(StorageKeyTool.KEY_PASSCODE, defaultValue: '');
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
    if (!passcodeSwitchValue){
      return settingModelList;
    }
    List<BiometricType> availableBiometrics = await SecurityAuthUtils.getAvailableBiometrics();
    bool faceIDSwitchValue = await OXCacheManager.defaultOXCacheManager.getForeverData(StorageKeyTool.KEY_FACEID, defaultValue: false);
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
    bool fingerprintSwitchValue = await OXCacheManager.defaultOXCacheManager.getForeverData(StorageKeyTool.KEY_FACEID, defaultValue: false);
    if (Platform.isAndroid || availableBiometrics.contains(BiometricType.fingerprint)) {
      settingModelList.add(SecureModel(
        iconName: 'icon_secure_fingerprint.png',
        title: 'ox_usercenter.str_secure_with_fingerprint',
        switchValue: fingerprintSwitchValue,
        settingItemType: SecureItemType.secureWithFingerprint,
      ));
    }

    return settingModelList;
  }
}

enum SecureItemType {
  block,
  secureWithPasscode,
  secureWithFaceID,
  secureWithFingerprint,
}
