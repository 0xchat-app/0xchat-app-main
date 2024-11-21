import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/font_size_notifier.dart';
import 'package:ox_common/utils/theme_color.dart';

class TextScaleSlider extends StatefulWidget {
  final ValueChanged<double>? onChanged;

  const TextScaleSlider({super.key, this.onChanged});

  @override
  State<TextScaleSlider> createState() => _TextScaleSliderState();
}

class _TextScaleSliderState extends State<TextScaleSlider> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92.px,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.px),
        color: ThemeColor.color180,
      ),
      child: Slider(
        value: textScaleFactorNotifier.value,
        min: 0.6,
        max: 2,
        divisions: 10,
        activeColor: ThemeColor.gradientMainStart,
        inactiveColor: ThemeColor.color0.withOpacity(0.5),
        onChanged: (value) {
          setState(() {
            widget.onChanged?.call(value);
          });
        },
      ),
    );
  }
}
