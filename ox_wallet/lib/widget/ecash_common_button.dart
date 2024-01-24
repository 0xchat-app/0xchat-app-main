import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_button.dart';

class EcashCommonButton extends StatelessWidget {
  final String? text;
  final Function()? onTap;
  const EcashCommonButton({super.key, this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CommonButton(
      height: 48.px,
      fontSize: 16.px,
      fontWeight: FontWeight.w600,
      fontColor: ThemeColor.color0,
      backgroundColor: ThemeColor.color180,
      cornerRadius: 12.px,
      content: text ?? '',
      onPressed: onTap ?? () => {},
      width: double.infinity,
    );
  }
}
