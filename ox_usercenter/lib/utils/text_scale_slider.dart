import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/font_size_notifier.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/platform_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/took_kit.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class TextScaleSlider extends StatefulWidget {
  final ValueChanged<double>? onChanged;

  const TextScaleSlider({super.key, this.onChanged});

  @override
  State<TextScaleSlider> createState() => _TextScaleSliderState();
}

class _TextScaleSliderState extends State<TextScaleSlider> {

  double _currentValue = 0;
  final double min = 0.9;
  final double max = 1.6;
  final double step = 0.1;
  bool _hasVibrator = false;

  @override
  void initState() {
    super.initState();
    _isHasVibrator();
    _initCurrentValue();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92.px,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.px),
        color: ThemeColor.color180,
      ),
      child: Stack(
        children: [
          Positioned(
            child: _buildLabel(
              'Text Size',
              color: ThemeColor.color0,
            ),
            left: 24.px,
            top: 12.px,
          ),
          if (_currentValue == 1.0)
            Positioned(
              child: _buildLabel(
                'Default',
                color: ThemeColor.color0,
              ),
              right: 24.px,
              top: 12.px,
            ),
          Positioned(
            child: _buildLabel('A',scale: min),
            left: 24.px,
            bottom: 12.px,
          ),
          Positioned(
            child: _buildLabel('A', scale: max),
            right: 24.px,
            bottom: 4.px,
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              thumbShape: CustomThumbShape(),
              overlayColor: Colors.transparent,
            ),
            child: Slider(
              value: _currentValue,
              min: min,
              max: max,
              divisions: _getDivisions(),
              activeColor: ThemeColor.gradientMainStart,
              inactiveColor: ThemeColor.color0.withOpacity(0.5),
              onChanged: (value) {
                double newValue = double.parse(_roundToStep(value).toStringAsFixed(1));
                if(newValue == _currentValue) return;
                if (_hasVibrator && OXUserInfoManager.sharedInstance.canVibrate && newValue != _currentValue) {
                  TookKit.vibrateEffect();
                }
                setState(() {
                  _currentValue = newValue;
                  widget.onChanged?.call(value);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label, {Color? color, double scale = 1.0}) {
    return Text(
      label,
      textScaler: TextScaler.linear(scale),
      style: TextStyle(
        color: color ?? ThemeColor.color100,
        fontSize: 14.px,
      ),
    );
  }

  _initCurrentValue() {
    //Error prevention
    if (textScaleFactorNotifier.value < min) {
      _currentValue = min;
    } else if (textScaleFactorNotifier.value > max) {
      _currentValue = max;
    } else {
      _currentValue = textScaleFactorNotifier.value;
    }
  }

  int _getDivisions() {
    return ((max - min) / step).ceil() - 1;
  }

  double _roundToStep(double value) {
    return (value - min) / step > 0
        ? (step * ((value - min) / step).round()) + min
        : min;
  }

  _isHasVibrator() async {
    if(!PlatformUtils.isMobile) return;
    _hasVibrator = await Vibrate.canVibrate;
    setState(() {});
  }
}

class CustomThumbShape extends SliderComponentShape {
  final double _thumbSize = 16.px;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(_thumbSize, _thumbSize);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter? labelPainter,
        required RenderBox? parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {
    final Canvas canvas = context.canvas;

    // Draw the outer circle of the thumb
    final Paint outerCirclePaint = Paint()
      ..color = ThemeColor.gradientMainStart
      ..strokeWidth = 2.px
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, _thumbSize / 2, outerCirclePaint);

    // Draw the actual part of the thumb
    final Paint thumbPaint = Paint()
      ..color = ThemeColor.color0
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, _thumbSize / 3, thumbPaint);
  }
}
