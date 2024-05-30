import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/date_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_discovery/page/widgets/contact_info_widget.dart';
import 'package:ox_localizable/ox_localizable.dart';

class StyledDate extends StatelessWidget {
  final int timestamp;
  final TextStyle? dayStyle;
  final TextStyle? monthStyle;
  final TextStyle? timeStyle;

  const StyledDate({
    Key? key,
    required this.timestamp,
    this.dayStyle,
    this.monthStyle,
    this.timeStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final monthAbbreviation = OXDateUtils.getLocalizedMonthAbbreviation(timestamp,locale: Localized.getCurrentLanguage().value());
    final time = OXDateUtils.formatTimestamp(timestamp * 1000,pattern: 'HH:mm:ss');
    final day = monthAbbreviation.split(' ').first;
    final month = monthAbbreviation.split(' ').last;

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
            style: const TextStyle().defaultTextStyle(color: ThemeColor.color0),
          ),
          // TextSpan(
          //   text: '  $time',
          //   style: const TextStyle().defaultTextStyle(color: ThemeColor.color100),
          // ),
        ],
      ),
    );
  }
}