import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';

class StyledDate extends StatelessWidget {
  final String day;
  final String month;
  final TextStyle? dayStyle;
  final TextStyle? monthStyle;

  const StyledDate({
    Key? key,
    required this.day,
    required this.month,
    this.dayStyle,
    this.monthStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: '$day ',
            style: dayStyle ??
                TextStyle(
                  color: ThemeColor.color0,
                  fontWeight: FontWeight.w500,
                  fontSize: 24.px,
                  height: 34.px / 24.px,
                ),
          ),
          TextSpan(
            text: month,
            style: TextStyle(
                color: ThemeColor.color0,
                fontWeight: FontWeight.w400,
                fontSize: 12.px,
                height: 17.px / 12.px),
          ),
        ],
      ),
    );
  }
}
