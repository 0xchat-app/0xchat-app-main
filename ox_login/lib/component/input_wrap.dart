import 'package:flutter/material.dart';
// common
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/widget_tool.dart';

class InputWrap extends StatelessWidget {
  final Widget? contentWidget;
  final String title;

  InputWrap({this.contentWidget,required this.title});

  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          alignment: Alignment.topLeft,
          child: Text(
            title,
            style: TextStyle(
              fontSize: Adapt.px(16),
              color: ThemeColor.color0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ).setPadding(
          EdgeInsets.only(
            bottom: Adapt.px(12),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Adapt.px(16)),
            color: ThemeColor.color190,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: Adapt.px(16),
            vertical: Adapt.px(13),
          ),
          child: contentWidget,
        )
      ],
    ).setPadding(
      EdgeInsets.only(
        bottom: Adapt.px(12),
      ),
    );
  }
}
