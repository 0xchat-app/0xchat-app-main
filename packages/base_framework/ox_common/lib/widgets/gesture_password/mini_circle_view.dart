import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ox_common/widgets/gesture_password/mini_gesture_password.dart';

class MiniCircleView extends CustomPainter {
  MiniCircleView(this.itemAttribute, this.circleList, this.selectedStr);

  final List<Circle> circleList;
  final MiniItemAttribute itemAttribute;
  final String selectedStr;

  @override
  void paint(Canvas canvas, Size size) {
    //unSelected small circle
    final normalCirclePaint = new Paint()
      ..color = itemAttribute.normalColor
      ..style = PaintingStyle.stroke;

    //Selected small circle
    final selectedCirclePaint = new Paint()
      ..color = itemAttribute.selectedColor
      ..style = PaintingStyle.fill;

    List<String> split = selectedStr.split('');
    for (int i = 0; i < circleList.length; i++) {
      Circle circle = circleList[i];
      canvas.drawCircle(
          circle.offset, itemAttribute.smallCircleR, normalCirclePaint);
      if (split.contains(i.toString())) {
        canvas.drawCircle(
            circle.offset, itemAttribute.smallCircleR, selectedCirclePaint);
      }
    }
  }

  @override
  bool shouldRepaint(MiniCircleView old) => true;
}
