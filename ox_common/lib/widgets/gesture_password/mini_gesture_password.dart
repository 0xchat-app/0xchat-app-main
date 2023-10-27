import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ox_common/widgets/gesture_password/mini_circle_view.dart';

class MiniGesturePassword extends StatefulWidget {
  final MiniItemAttribute attribute;
  final double height;

  MiniGesturePassword(
      {Key? key,
        this.attribute = MiniItemAttribute.normalAttribute,
        this.height = 60.0})
      : super(key: key);

  @override
  MiniGesturePasswordState createState() => new MiniGesturePasswordState();
}

class MiniGesturePasswordState extends State<MiniGesturePassword> {
  Offset touchPoint = Offset.zero;
  List<Circle> circleList = [];
  String selectedStr = '';

  @override
  void initState() {
    double hor = widget.height / 6;
    double ver = widget.height / 6;
    //The center point of each circle
    for (int i = 0; i < 9; i++) {
      double tempX = (i % 3 + 1) * 2 * hor - hor;
      double tempY = (i ~/ 3 + 1) * 2 * ver - ver;
      circleList.add(new Circle(new Offset(tempY, tempX), i));
    }
    super.initState();
  }

  setSelected(String str) {
    setState(() {
      selectedStr = str;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = new Size(widget.height, widget.height);
    return new Container(
      child: new CustomPaint(
          size: size,
          painter:
          new MiniCircleView(widget.attribute, circleList, selectedStr)),
    );
  }
}

class Circle {
  static final CIRCLE_SELECTED = 1;
  static final CIRCLE_NORMAL = 0;
  Offset offset;
  int index;
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

class MiniItemAttribute {
  final Color selectedColor;
  final Color normalColor;
  final double smallCircleR;
  static const MiniItemAttribute normalAttribute = const MiniItemAttribute(
      normalColor: const Color(0xFFBBDEFB),
      selectedColor: const Color(0xFF1565C0));

  const MiniItemAttribute({
    required this.normalColor,
    required this.selectedColor,
    this.smallCircleR = 6.0,
  });
}
