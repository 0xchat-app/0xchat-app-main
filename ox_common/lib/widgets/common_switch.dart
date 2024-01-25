import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';

class CommonSwitcher extends StatelessWidget {
    bool value;
    ValueChanged<bool>? onChanged;
    Color offBkColor;
    Color offThumbColor;
    Color onBkColor;
    Color onThumbColor;
    String offText;
    String onText;
    double width;
    double height;
    double? onTextSize;
    double? offTextSize;
    double? textPadding;
    bool? isNeedChanged;
    Color? offTextColor;
    Color? onTextColor;
    CommonSwitcher({
        this.value = false,
        this.onChanged,
        this.offBkColor = const Color(0x19CCCCCC),
        this.offThumbColor = Colors.white,
        this.onBkColor = const Color(0xFFE91C41),
        this.onThumbColor = Colors.white,
        this.offText = ' ',
        this.onText = ' ',
        this.onTextSize,
        this.offTextSize,
        this.textPadding,
        this.isNeedChanged,
        this.offTextColor,
        this.onTextColor,
        required this.width,
        required this.height,
    });

    @override
    Widget build(BuildContext context) {
        // TODO: implement build
        print('value $value');
        return Container(
            width: width,
            height: height,
            child: LabeledToggle(
                transitionType: TextTransitionTypes.FADE,
                rounded: true,
                borderSize: 0.0,
                offBorderColor: const Color(0x33999999),
                onBorderColor: const Color(0x33999999),
                duration: Duration(milliseconds: 200),
                forceWidth: true,
                value: value,
                onChanged: valueOnChanged,
                isNeedChanged: isNeedChanged,
                offBkColor: offBkColor,
                offThumbColor: offThumbColor,
                offText: offText,
                onText: onText,
                onBkColor: onBkColor,
                onThumbColor: onThumbColor,
                thumbSize: 20,
                labelSize: 16,
                onTextSize: onTextSize,
                offTextSize: offTextSize,
                textPadding: textPadding,
                offTextColor: offTextColor,
                onTextColor: onTextColor,

            ),
        );
    }

    void valueOnChanged(bool value) {
        // Device physical vibration is triggered when switching
        // YLTools.impactFeedback();
        Function.apply(onChanged ?? (bool) {}, [value]);
    }
}


enum TextTransitionTypes { ROTATE, SCALE, FADE, SIZE }

class LabeledToggle extends StatefulWidget {
    final Widget? child;
    final String onText;
    final String offText;
    final Color? onTextColor;
    final double? onTextSize;
    final Color? offTextColor;
    final double? offTextSize;
    final double? textPadding;
    final Color? onThumbColor;
    final Color? offThumbColor;
    final Color? onBorderColor;
    final Color? offBorderColor;
    final Color? onBkColor;
    final Color? offBkColor;
    final bool value;
    final double thumbSize;
    final double labelSize;
    final double borderSize;
    final Duration duration;
    final Curve curve;
    final ValueChanged<bool>? onChanged;
    final bool forceWidth;
    final bool rounded;
    final TextTransitionTypes transitionType;
    final bool rotationAnimation;
    final bool? isNeedChanged;

    const LabeledToggle({
        Key? key,
        this.value = false,
        this.onText = "",
        this.offText = "",
        this.onThumbColor,
        this.offThumbColor,
        this.onBorderColor,
        this.offBorderColor,
        this.onBkColor,
        this.offBkColor,
        this.onChanged,
        required this.thumbSize,
        required this.labelSize,
        this.duration = const Duration(milliseconds: 400),
        this.curve = Curves.linear,
        this.forceWidth = false,
        this.onTextColor = Colors.black,
        this.offTextColor = Colors.black,
        this.onTextSize,
        this.offTextSize,
        this.textPadding,
        this.rounded = true,
        this.borderSize = 1.0,
        this.transitionType = TextTransitionTypes.SCALE,
        this.rotationAnimation = false,
        this.child, this.isNeedChanged,
    })  : super(key: key);

    const LabeledToggle.theme({
        Key? key,
        this.value = false,
        this.onText = "",
        this.offText = "",
        required onColor,
        required offColor,
        this.onChanged,
        required this.thumbSize,
        required this.labelSize,
        this.duration = const Duration(milliseconds: 400),
        this.curve = Curves.linear,
        this.forceWidth = false,
        this.rounded = true,
        this.borderSize = 1.0,
        this.transitionType = TextTransitionTypes.SCALE,
        this.rotationAnimation = false,
        this.child, this.onTextSize, this.offTextSize,
        this.textPadding, this.isNeedChanged
    })  : onThumbColor = offColor,
          onBorderColor = offColor,
          onBkColor = onColor,
          offThumbColor = onColor,
          offBorderColor = onColor,
          offBkColor = offColor,
          onTextColor = offColor,
          offTextColor = onColor,
          super(key: key);

    @override
    _LabeledToggleState createState() => _LabeledToggleState();
}

class _LabeledToggleState extends State<LabeledToggle>
  with SingleTickerProviderStateMixin {
    late bool _value;
    late AnimationController animationController;
    late Animation<double> animation;

    @override
    void initState() {
        super.initState();
        _value = widget.value;
        animationController =
          AnimationController(vsync: this, duration: widget.duration);
        CurvedAnimation curvedAnimation =
        CurvedAnimation(parent: animationController, curve: widget.curve);
        animation = Tween<double>(begin: 0.0, end: 180.0).animate(curvedAnimation)
            ..addListener(() {
                setState(() {});
            });
    }

    @override
    void dispose() {
        animationController.dispose();

        super.dispose();
    }

    @override
    void didUpdateWidget(LabeledToggle oldWidget) {
        super.didUpdateWidget(oldWidget);
        _value = widget.value;
    }

    @override
    Widget build(BuildContext context) {
        if(widget.isNeedChanged??true){
            return GestureDetector(
                onTap: () {
                    widget.onChanged == null ? print("") : widget.onChanged!(!_value);
                    if (widget.rotationAnimation) {
                        if (animationController.status == AnimationStatus.completed) {
                            animationController.reverse();
                        } else {
                            animationController.forward();
                        }
                    }
                },
                child: buildOpacity(),
            );
        }else{
            return buildOpacity();
        }
    }

    Widget buildOpacity(){
        return Opacity(
            opacity: widget.onChanged == null ? 0.3 : 1.0,
            child: AnimatedContainer(
                duration: widget.duration,
                height: Adapt.px(widget.labelSize),
                width: widget.forceWidth ? Adapt.px(widget.thumbSize * 2) : null,
                child: Stack(
                    children: <Widget>[
                        buildThumb(),
                        buildLabel(),
                    ],
                ),
                decoration: BoxDecoration(
                    border: widget.borderSize > 0 ? Border.all(
                        color: widget.onChanged == null
                            ? Color(0xFFD3D3D3)
                            : (_value
                            ? (widget.onBorderColor ?? (widget.onThumbColor ?? Colors.white))
                            : (widget.offBorderColor ?? (widget.offThumbColor ?? Colors.white))),
                        width: Adapt.px(widget.borderSize),
                    ): null,
                    color: _value ? widget.onBkColor : widget.offBkColor,
                    borderRadius:
                    BorderRadius.circular(Adapt.px(widget.rounded ? 100.0 : 0.0)),
                ),
            ),
        );
    }

    Widget buildLabel() {
        return Row(
            children: <Widget>[
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.all(widget.textPadding??Adapt.px(5.0)),
                        child: Container(
                            height: Adapt.px(widget.labelSize),
                            child: FittedBox(
                                child: Center(
                                    child: AnimatedSwitcher(
                                        duration: widget.duration,
                                        switchInCurve: widget.curve,
                                        switchOutCurve: widget.curve,
                                        transitionBuilder:
                                            (Widget child, Animation<double> animation) {
                                            switch (widget.transitionType) {
                                                case TextTransitionTypes.ROTATE:
                                                    {
                                                        return RotationTransition(
                                                            child: child,
                                                            turns: animation,
                                                        );
                                                    }
                                                    break;
                                                case TextTransitionTypes.FADE:
                                                    {
                                                        return FadeTransition(
                                                            child: child,
                                                            opacity: animation,
                                                        );
                                                    }
                                                    break;

                                                case TextTransitionTypes.SIZE:
                                                    {
                                                        return SizeTransition(
                                                            child: child,
                                                            sizeFactor: animation,
                                                            axisAlignment: widget.value ? -5.0 : 5.0,
                                                            axis: Axis.horizontal,
                                                        );
                                                    }
                                                    break;

                                                case TextTransitionTypes.SCALE:
                                                    {
                                                        return ScaleTransition(
                                                            child: child,
                                                            scale: animation,
                                                        );
                                                    }
                                                    break;
                                            }
                                        },
                                        child: Text(
                                            _value ? widget.onText : widget.offText,
                                            key: ValueKey<bool>(_value),
                                            style: TextStyle(
                                                fontSize: _value ? widget.onTextSize : widget.offTextSize,
                                                color: _value
                                                    ? widget.onTextColor
                                                    : widget.offTextColor),
                                        ),
                                    ),
                                ),
                            ),
                        ),
                    ),
                ),
            ],
        );
    }

    Widget buildThumb() {
        return AnimatedAlign(
            curve: widget.curve,
            alignment: _value ? Alignment.centerRight : Alignment.centerLeft,
            duration: widget.duration,
            child: RotationTransition(
                turns: AlwaysStoppedAnimation(animation.value / 360),
                child: AnimatedContainer(
                    duration: widget.duration,
                    width: Adapt.px(widget.thumbSize),
                    height: Adapt.px(widget.thumbSize),
                    child: widget.child ?? Container(),
                    decoration: BoxDecoration(
                        shape: widget.rounded ? BoxShape.circle : BoxShape.rectangle,
                        color: _value ? widget.onThumbColor : widget.offThumbColor,
                        border: Border.all(
                            width: Adapt.px(widget.borderSize / 2),
                            color: widget.offBorderColor ?? Colors.white,
                        ),
                    ),
                ),
            ),
        );
    }
}
