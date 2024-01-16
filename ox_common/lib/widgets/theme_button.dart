
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';

class ThemeButton extends StatelessWidget {

  const ThemeButton({
    Key? key,
    this.enable = true,
    this.text = '',
    this.textStyle,
    this.width,
    this.height,
    this.onTap,
    this.gradientBg,
  }): super(key: key);

  final bool enable;
  final String text;
  final TextStyle? textStyle;
  final double? width;
  final double? height;
  final GestureTapCallback? onTap;
  final Gradient? gradientBg;

  @override
  Widget build(BuildContext context) {
    final textStyle = this.textStyle ?? TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w400,
      color: ThemeColor.white,
    );
    return GestureDetector(
      onTap: () {
        if (!enable) return ;
        onTap?.call();
      },
      child: Opacity(
        opacity: enable ? 1.0 : 0.4,
        child: Container(
          decoration: BoxDecoration(
            gradient: gradientBg ?? LinearGradient(
              stops: const [0.45, 0.55],
              begin: const Alignment(-0.5, -20),
              end: const Alignment(0.5, 20),
              colors: [ThemeColor.gradientMainEnd, ThemeColor.gradientMainStart,],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          width: width,
          height: height,
          alignment: Alignment.center,
          child: Text(
            text,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}