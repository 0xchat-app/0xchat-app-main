import 'package:flutter/services.dart';
import 'package:ox_common/log_util.dart';
import 'package:local_auth/local_auth.dart';

///Title: security_auth_utils
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/11/23 20:04
class SecurityAuthUtils{

  static Future<bool> checkBiometrics() async {
    final LocalAuthentication auth = LocalAuthentication();
    bool canCheckBiometrics = false;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    return canCheckBiometrics;
  }

  static Future<List<BiometricType>> getAvailableBiometrics() async {
    final LocalAuthentication auth = LocalAuthentication();
    List<BiometricType> availableBiometrics = [];
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    LogUtil.e('--------availableBiometrics =$availableBiometrics');
    return availableBiometrics;
  }

  static Future<bool> authenticateWithBiometrics(String hint) async {
    final LocalAuthentication auth = LocalAuthentication();
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your ' + hint + ' to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } on PlatformException catch (e) {
      print(e);
    }
    LogUtil.e('Michael: ===authenticated =$authenticated');

    return authenticated;
  }
}