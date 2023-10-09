import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_theme/ox_theme.dart';

///Title: ox_common_loading
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author George
///CreateTime: 2021/4/27 3:20 PM
class OXLoading extends State<StatefulWidget> with TickerProviderStateMixin {

  static Completer initCompleter = Completer();
  static Future get initComplete => initCompleter.future;

  static TransitionBuilder init() {
    if (!initCompleter.isCompleted) {
      initCompleter.complete();
    }
    return EasyLoading.init();
  }

  static bool get isShow => EasyLoading.isShow;

  static Future<void> show({
    String? status,
    Widget? indicator,
    EasyLoadingMaskType? maskType,
    bool dismissOnTap = false,
  }) async {
    EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
    EasyLoading.instance.indicatorColor = ThemeColor.red1;
    EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.ring;
    EasyLoading.instance.indicatorSize = Adapt.px(20);
    EasyLoading.instance.contentPadding = EdgeInsets.only(left: Adapt.px(20), top: Adapt.px(16), right: Adapt.px(20), bottom: Adapt.px(16));
    EasyLoading.instance.textColor = ThemeColor.gray02;
    EasyLoading.instance.lineWidth = Adapt.px(2);
    EasyLoading.instance.backgroundColor = ThemeManager.getCurrentThemeStyle() == ThemeStyle.dark ? ThemeColor.gray5 : Color(0xFFEAECEF);
    await EasyLoading.show(status: status, indicator: null, maskType: maskType, dismissOnTap: dismissOnTap);
  }

  static void showProgress({
    double process = 0,
    String? status,
    EasyLoadingMaskType? maskType,
  }) {
    EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
    EasyLoading.instance.indicatorColor = ThemeColor.red;
    EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.ring;
    EasyLoading.instance.indicatorSize = Adapt.px(20);
    EasyLoading.instance.contentPadding = EdgeInsets.only(left: Adapt.px(20), top: Adapt.px(16), right: Adapt.px(20), bottom: Adapt.px(16));
    EasyLoading.instance.textColor = ThemeColor.gray02;
    EasyLoading.instance.lineWidth = Adapt.px(2);
    EasyLoading.instance.backgroundColor = ThemeManager.getCurrentThemeStyle() == ThemeStyle.dark ? Colors.black : Color(0xFFEAECEF);
    EasyLoading.instance.progressColor = ThemeColor.red;
    EasyLoading.showProgress(process, status: status, maskType: maskType);
  }

  static Future<void> dismiss({
    bool animation = true,
  }) async {
   await EasyLoading.dismiss(animation: animation);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
