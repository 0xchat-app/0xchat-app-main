import 'package:flutter/material.dart';

class CustomTabIndicator extends Decoration {
  const CustomTabIndicator({
    this.borderRadius,
    this.borderSide = const BorderSide(width: 2.0, color: Colors.white),
    this.insets = EdgeInsets.zero,
    this.width = 10,
    this.gradient = const LinearGradient(colors: [Colors.red,Colors.blue]),
  }) : assert(borderSide != null),
        assert(insets != null);

  final BorderRadius? borderRadius;
  final BorderSide borderSide;
  final EdgeInsetsGeometry insets;
  final double width;
  final Gradient gradient;

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is CustomTabIndicator) {
      return CustomTabIndicator(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    if (b is CustomTabIndicator) {
      return CustomTabIndicator(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t)!,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  BoxPainter createBoxPainter([ VoidCallback? onChanged ]) => _UnderlinePainter(this, borderRadius, gradient,onChanged);

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    assert(rect != null);
    assert(textDirection != null);
    final indicator = insets.resolve(textDirection).deflateRect(rect);

    final cw = (indicator.left + indicator.right) / 2;
    return Rect.fromLTWH(
      cw - width / 2,
      indicator.bottom - borderSide.width,
      width,
      borderSide.width,
    );
  }

  @override
  Path getClipPath(Rect rect, TextDirection textDirection) {
    if (borderRadius != null) {
      return Path()..addRRect(
          borderRadius!.toRRect(_indicatorRectFor(rect, textDirection))
      );
    }
    return Path()..addRect(_indicatorRectFor(rect, textDirection));
  }
}

class _UnderlinePainter extends BoxPainter {
  _UnderlinePainter(
      this.decoration,
      this.borderRadius,
      this.gradient,
      super.onChanged,
      )
      : assert(decoration != null);

  final CustomTabIndicator decoration;
  final BorderRadius? borderRadius;
  final Gradient? gradient;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);
    final rect = offset & configuration.size!;
    final textDirection = configuration.textDirection!;
    final Paint paint;
    if (borderRadius != null) {
      paint = Paint()..color = decoration.borderSide.color;
      final indicator = decoration._indicatorRectFor(rect, textDirection)
          .inflate(decoration.borderSide.width / 4.0);
      final rrect = RRect.fromRectAndCorners(
        indicator,
        topLeft: borderRadius!.topLeft,
        topRight: borderRadius!.topRight,
        bottomRight: borderRadius!.bottomRight,
        bottomLeft: borderRadius!.bottomLeft,
      );
      canvas.drawRRect(rrect, paint);
    } else {
      paint = decoration.borderSide.toPaint()..strokeCap = StrokeCap.square;
      final indicator = decoration._indicatorRectFor(rect, textDirection)
          .deflate(decoration.borderSide.width / 2.0);

      paint.shader = gradient?.createShader(indicator);
      canvas.drawLine(indicator.bottomLeft, indicator.bottomRight, paint);
    }
  }
}