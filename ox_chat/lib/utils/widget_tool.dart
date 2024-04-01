import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';

Widget MyText(String content, double fontSize, Color txtColor, {TextAlign? textAlign, double? height, FontWeight fontWeight = FontWeight.w400, TextOverflow? overflow, double? letterSpacing, int? maxLines}) {
  return Text(
    content,
    textAlign: textAlign,
    style: TextStyle(fontSize: Adapt.px(fontSize), color: txtColor, fontWeight: fontWeight, height: height, letterSpacing: letterSpacing),
    overflow: overflow,
    maxLines: maxLines,
  );
}

Widget assetIcon(String iconName, double widthD, double heightD, {bool useTheme = false, BoxFit? fit}) {
  return CommonImage(
    useTheme: useTheme,
    iconName: iconName,
    width: Adapt.px(widthD),
    height: Adapt.px(heightD),
    fit: fit,
    package: 'ox_chat'
  );
}

extension OXChatStr on String {
  String localized([Map<String, String>? replaceArg]) {
    String text = Localized.text('ox_chat.$this');
    if (replaceArg != null) {
      replaceArg.keys.forEach((key) {
        text = text.replaceAll(key, replaceArg[key] ?? '');
      });
    }
    return text;
  }
}