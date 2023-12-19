import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_usercenter/utils/security_auth_utils.dart';

///Title: verify_secure_keypad
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/12/8 14:28
class VerifySecureKeypad extends StatefulWidget {

  final ValueChanged<String> onChanged;
  final ValueChanged<bool> onAuthResult;

  const VerifySecureKeypad({super.key, required this.onChanged, required this.onAuthResult});

  @override
  State<VerifySecureKeypad> createState() => VerifySecureKeypadState();
}

class VerifySecureKeypadState extends State<VerifySecureKeypad> {
  final List<String> numericKey = const ['1','2','3','4','5','6','7','8','9','.','0','x'];
  final ValueNotifier _currentIndex = ValueNotifier(-1);
  final radius = Radius.circular(16.px);

  String value = '';
  bool faceIDSwitchValue = false;
  bool fingerprintSwitchValue = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    faceIDSwitchValue = await OXCacheManager.defaultOXCacheManager.getForeverData(StorageKeyTool.KEY_FACEID, defaultValue: false);
    fingerprintSwitchValue = await OXCacheManager.defaultOXCacheManager.getForeverData(StorageKeyTool.KEY_FINGERPRINT, defaultValue: false);
    setState(() {});
  }

  void resetCurrentIndex(){
    _currentIndex.value = -1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(radius),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 1.px,
            crossAxisSpacing: 1.px,
            childAspectRatio: 130 / 60
        ),
        itemCount: numericKey.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTapDown: (_){
              _onKeyTap(numericKey[index]);
              widget.onChanged(value);
              _currentIndex.value = index;
            },
            onTapUp: (_){
              _currentIndex.value = -1;
            },
            child: ValueListenableBuilder(
              valueListenable: _currentIndex,
              builder: (context,__,child) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.px),
                    color: _currentIndex.value == index ? Colors.black.withOpacity(0.2) : Colors.transparent,
                  ),
                  alignment: Alignment.center,
                  child: child,
                );
              },
              child: _buildKeyWidget(numericKey[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildKeyWidget(String key) {
    if (key == '.') {
      if (Platform.isAndroid && fingerprintSwitchValue) {
        return _frinerprintOrFaceIdWidget('icon_verify_fingerprint.png', () {_clickFingerprint();});
      } else if (Platform.isIOS){
        if (faceIDSwitchValue) {
          return _frinerprintOrFaceIdWidget('icon_verify_face_id.png', () {_clickFaceID();});
        } else if (fingerprintSwitchValue) {
          return _frinerprintOrFaceIdWidget('icon_verify_fingerprint.png', () {_clickFingerprint();});
        }
      }
      return const SizedBox();
    }
    if (key == 'x') {
      return CommonImage(
        iconName: 'icon_keyboard_backspace.png',
        width: 32.px,
        height: 32.px,
        package: 'ox_usercenter',
      );
    }
    return Text(
      key,
      style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 24.sp,
          color: ThemeColor.color0),
    );
  }

  Widget _frinerprintOrFaceIdWidget(String iconName, GestureTapCallback? onAuthTap){
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onAuthTap,
      child: CommonImage(
        iconName: iconName,
        width: 32.px,
        height: 32.px,
        package: 'ox_usercenter',
      ),
    );
  }

  void _onKeyTap(String key) {
    if (key == 'x') {
      if (value.isNotEmpty) {
        value = value.substring(0, value.length - 1);
      }
      value = 'x';
    } else if (key != '.') {
      if (value.length < 6){
        value = key;
      }
    }
  }

  void _clickFingerprint() async {
    bool canCheckBiometrics = await SecurityAuthUtils.checkBiometrics();
    if (canCheckBiometrics) {
      bool authResult = await SecurityAuthUtils.authenticateWithBiometrics('Fingerprint');
      if (!mounted) return;
      if (authResult) {
        CommonToast.instance.show(context, 'Authorized');
        widget.onAuthResult(true);
      } else {
        CommonToast.instance.show(context, 'Not Authorized, try again.');
      }
    } else {
      if (mounted) CommonToast.instance.show(context, "Please enable the phone's fingerprint recognition system.");
    }
  }

  Future<void> _clickFaceID() async {
    bool canCheckBiometrics = await SecurityAuthUtils.checkBiometrics();
    if (canCheckBiometrics) {
      bool authResult = await SecurityAuthUtils.authenticateWithBiometrics('FaceID');
      if (!mounted) return;
      if (authResult) {
        CommonToast.instance.show(context, 'Authorized');
        widget.onAuthResult(true);
      } else {
        CommonToast.instance.show(context, 'Not Authorized, try again.');
      }
    } else {
      if (mounted) CommonToast.instance.show(context, "Please enable the phone's FaceID recognition system.");
    }
  }
}