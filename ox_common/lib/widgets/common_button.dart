import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/common_color.dart';
import 'package:ox_common/utils/theme_color.dart';



enum buttonSizeType {
  NORMAL,
  BIG,
  BIGGER,
  SMALL,
  SMALLER
}

/// Universal Button
class CommonButton extends StatefulWidget {
  final String content;
  final VoidCallback onPressed;
  final bool isDisabled;
  final double cornerRadius;
  final Color? borderSideColor; // Border color
  final num? fontSize;
  final Color? fontColor;
  final num? width;
  final num? height;
  final buttonSizeType? buttonSize; // button size
  final Color? backgroundColor; // button background color
  final EdgeInsetsGeometry? padding;
  CommonButton({
    Key? key,
    required this.content,
    required this.onPressed,
    this.width,
    this.height,
    this.fontSize,
    this.fontColor,
    this.borderSideColor,
    this.backgroundColor,
    this.isDisabled = false,
    this.cornerRadius = 4.0,
    this.buttonSize = buttonSizeType.NORMAL,
    this.padding,
  }) : super(key: key);

  @override
  _CommonButtonState createState() => _CommonButtonState();

  static Widget themeButton({String text = '', required VoidCallback onTap}) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          height: Adapt.px(48),
          decoration: BoxDecoration(
              color: ThemeColor.color180,
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  ThemeColor.gradientMainEnd,
                  ThemeColor.gradientMainStart,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )),
          child: Text(
            text,
            style: TextStyle(fontSize: Adapt.px(16), fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
      );
}

class _CommonButtonState extends State<CommonButton> {
  @override
  Widget build(BuildContext context) {
    Map<String, num> buttonMap = buttonSizeMap[widget.buttonSize]!;
    num btnW = widget.width ?? buttonMap['width']!;
    num btnH = widget.height ?? buttonMap['height']!;
    num btnFontSize = widget.fontSize ?? buttonMap['fontSize']!;
    Color btnBg = widget.backgroundColor ?? ThemeColor.main;
    Color borderSideC = widget.borderSideColor ?? Colors.transparent;

    Color defaultTextColor = widget.fontColor ?? CommonColor.white01;
    Color btnTextColor =
        widget.isDisabled ? CommonColor.gray02 : defaultTextColor;

    return OXButton(
      onPressed: widget.isDisabled ? null : widget.onPressed,
      minWidth: Adapt.px(btnW),
      height: Adapt.px(btnH),
      disabledColor: ThemeColor.dark05,
      color: btnBg,
      padding: widget.padding,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderSideC, width: Adapt.px(1)),
        borderRadius: BorderRadius.all(Radius.circular(widget.cornerRadius)),
      ),
      child: Text(
        widget.content,
        style: TextStyle(
          color: btnTextColor,
          fontSize: Adapt.px(btnFontSize),
        ),
      ),
    );
  }

  /// button size
  Map<buttonSizeType, dynamic> buttonSizeMap = {
    buttonSizeType.NORMAL: {
      'width': 167,
      'height': 40,
      'fontSize': 16,
    },
    buttonSizeType.BIG: {
      'width': 252,
      'height': 40,
      'fontSize': 16,
    },
    buttonSizeType.BIGGER: {
      'width': 327,
      'height': 48,
      'fontSize': 16,
    },
    buttonSizeType.SMALL: {
      'width': 110,
      'height': 32,
      'fontSize': 14,
    },
    buttonSizeType.SMALLER: {
      'width': 40,
      'height': 24,
      'fontSize': 12,
    }
  };
}

class OXButton extends MaterialButton {
  OXButton({
    Key? key,
    @required onPressed,
    onHighlightChanged,
    textTheme,
    textColor,
    disabledTextColor,
    color,
    disabledColor = Colors.transparent,
    highlightColor = Colors.transparent,
    splashColor,
    colorBrightness,
    elevation,
    focusElevation,
    hoverElevation,
    highlightElevation,
    disabledElevation,
    padding,
    shape,
    clipBehavior = Clip.none,
    focusNode,
    materialTapTargetSize,
    animationDuration,
    minWidth,
    height,
    double radius = 0.0,
    child,
  }) : super(
          key: key,
          padding: padding ?? EdgeInsets.only(),
          elevation: 0.0,
          highlightElevation: 0.0,
          onPressed: onPressed,
          onHighlightChanged: onHighlightChanged,
          textTheme: textTheme,
          textColor: textColor,
          disabledTextColor: disabledTextColor,
          color: color,
          disabledColor: disabledColor,
          highlightColor: highlightColor,
          splashColor: splashColor ?? Colors.transparent,
          colorBrightness: colorBrightness,
          shape: shape ??
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(radius)),
              ),
          clipBehavior: clipBehavior,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          animationDuration: animationDuration,
          minWidth: minWidth,
          height: height,
          child: child,
        );
}

class OXCupertinoButton extends StatelessWidget {
  OXCupertinoButton(
      {Key? key,
      required this.onPressed,
      required this.child,
      this.width,
      this.height,
      this.color = Colors.transparent,
      this.radius = 0.0,
      this.borderColor,
      this.borderWidth = 0.0,
      this.padding = EdgeInsets.zero})
      : super(
          key: key,
        );

  final VoidCallback? onPressed;
  final Widget child;
  final double? width;
  final double? height;
  final Color color;
  final double radius;
  final Color? borderColor;
  final double borderWidth;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final bgColor = onPressed == null ? ThemeColor.dark05 : color;
    return Theme(
        data: ThemeData(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints.tightFor(
            width: width,
            height: height,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              border:
                  Border.all(color: borderColor ?? bgColor, width: borderWidth),
            ),
            child: CupertinoButton(
              padding: padding,
              color: bgColor,
              onPressed: onPressed,
              borderRadius: BorderRadius.circular(radius),
              child: child,
            ),
          ),
        ));
  }
}
