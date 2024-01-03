import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_wallet/widget/common_card.dart';

class CommonOptionItem extends StatelessWidget {
  final String? label;
  final TextStyle? labelStyle;
  final Widget? child;
  final double? padding;
  const CommonOptionItem({super.key, this.label, this.labelStyle, this.child, this.padding,});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label ?? '',style: labelStyle ?? TextStyle(fontSize: 14.px,fontWeight: FontWeight.w600,color: ThemeColor.color0),),
        SizedBox(height: padding ?? 12.px,),
        child ?? Container(),
      ],
    );
  }

  factory CommonOptionItem.textField({
    String? label,
    TextStyle? style,
    String? hintText,
    TextStyle? hintStyle,
    String? suffixText,
    TextStyle? suffixStyle,
    TextEditingController? controller,
    FocusNode? focusNode,
    TextInputType? keyboardType
  }) {
    return CommonOptionItem(
      label: label,
      child: CommonCard(
        radius: 12.px,
        verticalPadding: 12.px,
        horizontalPadding: 16.px,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          style: style,
          keyboardType: keyboardType,
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
              hintText: hintText,
              hintStyle: hintStyle ??
                  TextStyle(fontSize: 16.px, height: 22.px / 16.px),
              suffixText: suffixText,
              suffixStyle: suffixStyle ??
                  TextStyle(
                      fontSize: 16.px,
                      color: ThemeColor.color0,
                      height: 22.px / 16.px)),
        ),
      ),
    );
  }
}