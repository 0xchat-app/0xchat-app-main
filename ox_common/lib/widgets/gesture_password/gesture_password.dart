import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ox_common/widgets/gesture_password/circle_item_painter.dart';

class GesturePassword extends StatefulWidget {
  final ValueChanged<String>? successCallback;
  final ValueChanged<String>? selectedCallback;
  final VoidCallback? failCallback;
  final ItemAttribute attribute;
  final double height;
  final double? width;

  GesturePassword(
      {@required this.successCallback,
        this.failCallback,
        this.selectedCallback,
        this.attribute: ItemAttribute.normalAttribute,
        this.height: 300.0,
        this.width,
      });

  @override
  _GesturePasswordState createState() => new _GesturePasswordState();
}

class _GesturePasswordState extends State<GesturePassword> {
  Offset touchPoint = Offset.zero;
  List<Circle> circleList = [];
  List<Circle> lineList = [];

  @override
  void initState() {
    double hor = (widget.width??MediaQueryData.fromWindow(ui.window).size.width) / 6;
    double ver = widget.height / 6;
    //The center point of each circle
    for (int i = 0; i < 9; i++) {
      double tempX = (i % 3 + 1) * 2 * hor - hor;
      double tempY = (i ~/ 3 + 1) * 2 * ver - ver;
      circleList.add(new Circle(new Offset(tempY, tempX), i.toString()));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = new Size(
        widget.width??MediaQueryData.fromWindow(ui.window).size.width, widget.height);
    return new GestureDetector(
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          final box = context.findRenderObject() as RenderBox;
          touchPoint = box.globalToLocal(details.globalPosition);
          //Prevent painting from crossing the line
          if (touchPoint.dy < 0) {
            touchPoint = new Offset(touchPoint.dx, 0.0);
          }
          if (touchPoint.dy > widget.height) {
            touchPoint = new Offset(touchPoint.dx, widget.height);
          }
          Circle? circle = getOuterCircle(touchPoint);
          if (circle != null) {
            if (circle.isUnSelected()) {
              lineList.add(circle);
              circle.setState(Circle.CIRCLE_SELECTED);
              if (widget.selectedCallback != null) {
                widget.selectedCallback!(getPassword());
              }
            }
          }
          print(lineList.length);
        });
      },
      onPanEnd: (DragEndDetails details) {
        setState(() {
          if (circleList
              .where((Circle itemCircle) => itemCircle.isSelected())
              .length >=
              4) {
            if (widget.successCallback != null) {
              widget.successCallback!(getPassword());
            }
          } else {
            if (widget.failCallback != null) {
              widget.failCallback!();
            }
          }
          touchPoint = Offset.zero;
          lineList.clear();
          for (int i = 0; i < circleList.length; i++) {
            Circle circle = circleList[i];
            circle.setState(Circle.CIRCLE_NORMAL);
          }
        });
      },
      child: new CustomPaint(
          size: size,
          painter: new CircleItemPainter(
            widget.attribute,
            touchPoint,
            circleList,
            lineList,
          )),
    );
  }

  ///Determine if it's in the circle
  Circle? getOuterCircle(Offset offset) {
    for (int i = 0; i < 9; i++) {
      var cross = offset - circleList[i].offset;
      if (cross.dx.abs() < widget.attribute.focusDistance &&
          cross.dy.abs() < widget.attribute.focusDistance) {
        return circleList[i];
      }
    }
    return null;
  }

  String getPassword() {
    return lineList
        .map((selectedItem) => selectedItem.index.toString())
        .toList()
        .fold("", (s, str) {
      return s + str;
    });
  }
}

class Circle {
  static final CIRCLE_SELECTED = 1;
  static final CIRCLE_NORMAL = 0;
  Offset offset;
  String index;
  int state = CIRCLE_NORMAL;

  Circle(this.offset, this.index);

  int getState() {
    return state;
  }

  setState(int state) {
    this.state = state;
  }

  bool isSelected() {
    return state == CIRCLE_SELECTED;
  }

  bool isUnSelected() {
    return state == CIRCLE_NORMAL;
  }
}

class ItemAttribute {
  final Color selectedColor;
  final Color selectedBgColor;
  final Color normalColor;
  final double lineStrokeWidth;
  final double circleStrokeWidth;
  final double smallCircleR;
  final double bigCircleR;
  final double focusDistance;
  static const ItemAttribute normalAttribute = const ItemAttribute(
      normalColor: const Color(0xFFBBDEFB),
      selectedColor: const Color(0xFF1565C0),
      selectedBgColor: const Color(0xFF1565C0)
  );
  
  const ItemAttribute({
    required this.selectedBgColor,
    required this.normalColor,
    required this.selectedColor,
    this.lineStrokeWidth: 2.0,
    this.circleStrokeWidth: 2.0,
    this.smallCircleR: 10.0,
    this.bigCircleR: 30.0,
    this.focusDistance: 25.0,
  });
}
