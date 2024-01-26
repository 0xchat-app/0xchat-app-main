
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';

/// Title: CommonToast
/// Description: TODO()
/// Copyright: Copyright (c) 2018
/// CreateTime: 2021/4/6 4:21 PM
///
/// @author john
/// @CheckItem Fill in by oneself
class CommonToast {
  static CommonToast get instance => _getInstance();
  static CommonToast? _instance;

  static CommonToast _getInstance() {
    if (_instance == null) {
      _instance = new CommonToast._internal();
    }
    return _instance!;
  }

  CommonToast._internal();

  static OverlayEntry? _entry;

  /// Show Toast Message
  /// message: show word
  /// duration: existence time(milliseconds)

  Future<void> show(BuildContext? context, String message,
      {int duration = 2000, ToastType toastType = ToastType.normal}) async{
    EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
    EasyLoading.instance.successWidget = _getToastTypeIconName(toastType);
    EasyLoading.instance.backgroundColor = ThemeColor.color180;
    EasyLoading.instance.indicatorColor = Colors.transparent;
    EasyLoading.instance.textColor =  ThemeColor.color0;
    EasyLoading.instance.textStyle = TextStyle(
      fontSize: Adapt.px(12),
      fontWeight: FontWeight.w400,
    );
    if (toastType == ToastType.normal) {
     await EasyLoading.showToast(
        message,
        duration: Duration(milliseconds: duration),
      );
    } else {
     await EasyLoading.showSuccess(
        message,
        duration: Duration(milliseconds: duration),
      );
    }
  }

  Widget? _getToastTypeIconName(ToastType type) {
    String? iconName;
    switch (type) {
      case ToastType.normal:
        iconName = null;
        break;
      case ToastType.success:
        iconName = 'icon_toast_success.png';
        break;
      case ToastType.failed:
        iconName = 'icon_toast_failed.png';
        break;
    }
    if (iconName == null) {
      return null;
    } else {
      return CommonImage(
        iconName: iconName,
        width: Adapt.px(16),
        height: Adapt.px(16),
      );
    }
  }
}

enum ToastType { normal, success, failed }
