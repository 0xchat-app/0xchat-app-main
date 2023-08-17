
import 'package:flutter/material.dart';

import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/adapt.dart';

/// Linkage selection box
class OXCommonSpinner extends StatefulWidget {

  OXCommonSpinner({
    this.title = '',
    this.width,
    this.height,
    this.padding,
    this.backgoundColor = Colors.transparent,
    this.tintColor,
    this.showInfoView = false,
    this.showArrow = true,
    required this.onTap,
  });

  final String title;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final Color? tintColor;
  final Color backgoundColor;
  final bool showInfoView;
  final bool showArrow;
  final Future Function()? onTap;

  @override
  State<StatefulWidget> createState() => _OXCommonSpinnerState();
}

class _OXCommonSpinnerState extends State<OXCommonSpinner> {

  AnimationStatus arrowStatus = AnimationStatus.dismissed;
  bool? isHandlingTap;
  /// Animation time (milliseconds)
  final animateDuration = 200;

  @override
  Widget build(BuildContext context) {
    late AnimationStatus arrowStatus;
    switch (isHandlingTap) {
      case null: arrowStatus = AnimationStatus.dismissed; break;
      case true: arrowStatus = AnimationStatus.reverse; break;
      case false: arrowStatus = AnimationStatus.forward; break;
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.backgoundColor,
          borderRadius: BorderRadius.all(Radius.circular(3.0)),
        ),
        width: widget.width,
        height: widget.height,
        child: Row(
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: Adapt.px(14),
                fontWeight: FontWeight.w500,
                color: widget.tintColor ?? ThemeColor.gray02,
              ),
            ),
            // YLAnimationCategory(
            //   type: AnimationType.ROTATION,
            //   animConfig: YLAnimConfig(
            //     status: arrowStatus,
            //     curve: Curves.linear,
            //     duration: animateDuration,
            //   ),
            //   child: CommonImage(
            //     iconName: 'icon_arrow_bottom.png',
            //     color: widget.tintColor ?? ThemeColor.gray02,
            //     height: Adapt.px(16),
            //     width: Adapt.px(16),
            //   ),
            // )
          ],
        )
      ),
    );
  }

  onTap() async {
    isHandlingTap = true;
    setState(() { });
    Future tapHandle = Future.value();
    if (widget.onTap != null) tapHandle = widget.onTap!();
    // Make sure the callback is after the animation is finished
    await Future.wait([
      tapHandle,
      Future.delayed(Duration(milliseconds: animateDuration + 100)),
    ]);
    isHandlingTap = false;
    setState(() { });
  }
}