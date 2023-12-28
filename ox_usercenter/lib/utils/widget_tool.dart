import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';

///Title: widget_tool
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author George
///CreateTime: 2023/1/9 9:26 PM
Widget abbrText(String content, double fontSize, Color txtColor, {TextAlign? textAlign, double? height, FontWeight fontWeight = FontWeight.w400}) {
  return Text(
    content,
    textAlign: textAlign,
    softWrap: true,
    style: TextStyle(fontSize: Adapt.px(fontSize), color: txtColor, fontWeight: fontWeight, height: height),
  );
}

Widget assetIcon(String iconName, double widthD, double heightD, {bool useTheme = false, BoxFit? fit}) {
  return CommonImage(
    useTheme: useTheme,
    iconName: iconName,
    width: Adapt.px(widthD),
    height: Adapt.px(heightD),
    fit: fit,
    package: 'ox_usercenter'
  );
}

extension OXUserCenterStr on String {
  String localized([Map<String, String>? replaceArg]) {
    String text = Localized.text('ox_usercenter.$this');
    if (replaceArg != null) {
      replaceArg.keys.forEach((key) {
        text = text.replaceAll(key, replaceArg[key] ?? '');
      });
    }
    return text;
  }
}