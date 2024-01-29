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
        if (label != null) ...[
          Text(
            label ?? '',
            style: labelStyle ?? TextStyle(fontSize: 14.px, fontWeight: FontWeight.w600, color: ThemeColor.color0),
          ),
          SizedBox(height: padding ?? 12.px,),
        ],
        child ?? Container(),
      ],
    );
  }

  factory CommonLabeledCard.textField({
    String? label,
    TextStyle? style,
    String? hintText,
    TextStyle? hintStyle,
    Widget? suffix,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: hintStyle ?? TextStyle(fontSize: 16.px,height: 22.px / 16.px),
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    controller: controller,
                    focusNode: focusNode,
                    keyboardType: keyboardType,
                    maxLines: 1,
                    showCursor: true,
                    style: style ?? TextStyle(fontSize: 16.px,height: 22.px / 16.px,color: ThemeColor.color0),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.px),
            suffix ?? Container()
          ],
        ),
      ),
    );
  }

  factory CommonLabeledCard.textFieldAndScan(
      {String? label,
      String? hintText,
      TextEditingController? controller,
      FocusNode? focusNode,
      VoidCallback? onTap}) {
    return CommonLabeledCard.textField(
      label: label,
      hintText: hintText,
      controller: controller,
      focusNode: focusNode,
      suffix: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: CommonImage(
          iconName: 'icon_send_qrcode.png',
          size: 24.px,
          package: 'ox_wallet',
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
                Text(title ?? '',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16.px,color: ThemeColor.color0,height: 22.px / 16.px,overflow: TextOverflow.ellipsis),),
                SizedBox(height: contentPadding,),
                if(subTitle != null) Text(subTitle!,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14.px,color: ThemeColor.color100,height: 20.px / 14.px),),
              ],
            ),
            SizedBox(width: 8.px,),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  badge ?? Container(),
                  content ??
                      CommonImage(
                        iconName: 'icon_wallet_more_arrow.png',
                        size: 24.px,
                        package: 'ox_wallet',
                      )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class StepItemModel {
  final String? key;
  String? title;
  String? subTitle;
  final String? content;
  Widget Function()? contentBuilder;
  String? badge;
  Widget Function()? badgeBuilder;
  final void Function(StepItemModel value)? onTap;

  StepItemModel({required this.title, this.subTitle, this.content, this.contentBuilder, this.badgeBuilder, this.badge, this.onTap, this.key});
}
