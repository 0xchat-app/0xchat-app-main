import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/widgets/common_image.dart';

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