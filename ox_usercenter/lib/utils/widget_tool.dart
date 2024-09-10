import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
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

Widget labelWidgetWrapWidget({
  String title = '',
  required Widget widget,
}) {
  Widget titleWidget(){
    if(title.isEmpty) return const SizedBox();
    return Text(
      title,
      style: TextStyle(
        color: ThemeColor.color0,
        fontWeight: FontWeight.w600,
        fontSize: 14.px,
      ),
    ).setPadding(EdgeInsets.symmetric(vertical: 12.px));
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      titleWidget(),
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: ThemeColor.color180,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: widget,
        ),
      ),
    ],
  );
}

Widget labelWidget({
  bool showArrow = true,
  String title = '',
  String subTitle = '',
  bool showDivider = false,
  Widget? rightWidget,
  Function? onTap,
}) {
  Widget _arrowWidget() {
    if(rightWidget != null) return rightWidget;
    if (!showArrow) return const SizedBox();
    return CommonImage(
      iconName: 'icon_arrow_more.png',
      width: 24.px,
      height: 24.px,
    );
  }

  Decoration? decoration;
  if(showDivider){
    decoration = BoxDecoration(
      border: Border(
        bottom: BorderSide(
          width: 0.5,
          color: ThemeColor.color160,
        ),
      ),
    );
  }

  return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onTap?.call(),
      child:  Container(
        height: 52.px,
        padding: EdgeInsets.symmetric(
          horizontal: 16.px,
        ),
        decoration: decoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: ThemeColor.color0,
                    fontSize: 16.px,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      subTitle,
                      style: TextStyle(
                        color: ThemeColor.color100,
                        fontSize: 14.px,
                      ),
                    ),
                    _arrowWidget(),
                  ],
                ),
              ],
            ),
          ],
        ),
      )
  );
}

extension OXUserCenterStr on String {
  String localized([Map<String, String>? replaceArg]) {
    String text = Localized.text('ox_usercenter.$this');
    if (replaceArg != null) {
      for (var key in replaceArg.keys) {
        text = text.replaceAll(key, replaceArg[key] ?? '');
      }
    }
    return text;
  }
}