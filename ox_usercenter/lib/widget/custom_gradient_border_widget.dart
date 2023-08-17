import 'package:flutter/material.dart';

class CustomGradientBorderWidget extends StatelessWidget {

  final Widget child;
  final double border;
  final double borderRadius;
  final Gradient gradient;

  const CustomGradientBorderWidget({Key? key, required this.child,
    required this.border,
    required this.borderRadius,
    required this.gradient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GradientBorderPainter(
        radius:borderRadius,
        strokeWidth: border,
        gradient: gradient
      ),
      child: child,
    );
  }
}


class GradientBorderPainter extends CustomPainter{

  final double radius;
  final double strokeWidth;
  final Gradient gradient;

  GradientBorderPainter(
      {required this.radius,
      required this.strokeWidth,
      required this.gradient});

  @override
  void paint(Canvas canvas, Size size) {

    Paint paint = Paint();

    Rect rect = Offset.zero & size;
    RRect rRect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    paint.strokeWidth = strokeWidth;
    paint.style = PaintingStyle.stroke;
    paint.shader = gradient.createShader(rect);

    canvas.drawRRect(rRect, paint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}
