import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_wallet/widget/common_card.dart';

class CommonLabeledCard extends StatelessWidget {
  final String? label;
  final TextStyle? labelStyle;
  final Widget? child;
  final double? padding;
  const CommonLabeledCard({super.key, this.label, this.labelStyle, this.child, this.padding,});

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

  factory CommonLabeledCard.textField({
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
    return CommonLabeledCard(
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

class StepIndicatorItem extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final Widget? content;
  final Widget? badge;
  final double contentPadding;
  final GestureTapCallback? onTap;
  final double? height;
  const StepIndicatorItem({super.key, double? contentPadding, this.title, this.subTitle, this.content, this.onTap, this.height, this.badge}) : contentPadding = contentPadding ?? 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: content == null ? onTap : null,
      child: SizedBox(
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title ?? '',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16.px,color: ThemeColor.color0,height: 22.px / 16.px),),
                SizedBox(height: contentPadding,),
                if(subTitle != null) Text(subTitle!,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14.px,color: ThemeColor.color100,height: 20.px / 14.px),),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                badge ?? Container(),
                content ??
                    CommonImage(
                      iconName: 'icon_wallet_more_arrow.png',
                      size: 24.px,
                      package: 'ox_wallet',
                    )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class StepItemModel {
  final String? title;
  final String? subTitle;
  final String? content;
  String? badge;
  final void Function(StepItemModel value)? onTap;

  StepItemModel({required this.title, this.subTitle, this.content, this.badge, this.onTap});
}
