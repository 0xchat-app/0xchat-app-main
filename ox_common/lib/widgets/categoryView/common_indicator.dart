library round_indicator;

import 'package:flutter/material.dart';

class RoundTabIndicator extends Decoration {
    final BorderSide borderSide;
    final EdgeInsetsGeometry insets;
    final Gradient? gradient;
    bool isRound;
    double width;

    //default radius is width/2
    double radius = 0;

    RoundTabIndicator(
      {this.borderSide = const BorderSide(width: 2, color: Colors.white),
          this.insets = EdgeInsets.zero,
          this.gradient,
          this.isRound = true,
          this.radius = 0,
          this.width = 0,
      }) {
        if (isRound && this.radius <= 0) {
              this.radius = borderSide.width / 2;
                  }
    }

    @override
    BoxPainter createBoxPainter([VoidCallback? onChanged]) {
        return _RoundUnderLineTabIndicatorPainter(this, onChanged);
    }

    // @override
    // BoxPainter createBoxPainter([onChanged]) {
    //   return _RoundUnderLineTabIndicatorPainter(this, onChanged);
    // }

    @override
    Decoration? lerpFrom(Decoration? a, double t) {
        if (a is RoundTabIndicator) {
            return RoundTabIndicator(
                borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
                insets: EdgeInsetsGeometry.lerp(a.insets, insets, t)!,
            );
        }

        return super.lerpFrom(a, t);
    }
}

class _RoundUnderLineTabIndicatorPainter extends BoxPainter {
    final RoundTabIndicator decoration;

    BorderSide get borderSide => decoration.borderSide;

    EdgeInsetsGeometry get insets => decoration.insets;

    _RoundUnderLineTabIndicatorPainter(this.decoration, VoidCallback? onChanged)
      : super(onChanged);

    @override
    void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
        assert(configuration.size != null);
        final Rect rect = offset & configuration.size!;
        final TextDirection textDirection = configuration.textDirection!;
        final Rect indicator = _indicatorRectFor(rect, textDirection).deflate(borderSide.width / 2.0);
        final Paint paint = borderSide.toPaint()..strokeCap = StrokeCap.square;
        if (decoration.gradient == null) {
            if (decoration.isRound) {
                paint..strokeCap = StrokeCap.round;
            }
            canvas.drawLine(indicator.bottomLeft, indicator.bottomRight, paint);
        } else {
            paint..strokeWidth = 0;
            paint.style = PaintingStyle.fill;
            if (!decoration.isRound) {
                Rect underLineRect = Rect.fromLTRB(indicator.bottomLeft.dx,
                  indicator.bottom - borderSide.width, indicator.bottomRight.dx, indicator.bottom);
                canvas.drawRect(
                  underLineRect, paint..shader = decoration.gradient?.createShader(underLineRect));
            } else {
                Rect underLineRect = Rect.fromLTRB(
                  indicator.bottomLeft.dx + borderSide.width / 2,
                  indicator.bottom - borderSide.width,
                  indicator.bottomRight.dx - borderSide.width / 2,
                  indicator.bottom);
                RRect rRect = RRect.fromRectAndRadius(underLineRect, Radius.circular(decoration.radius));
                canvas.drawRRect(rRect, paint..shader = decoration.gradient?.createShader(underLineRect));
            }
        }
    }

    Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
        Rect indicator = insets.resolve(textDirection).deflateRect(rect);
        return Rect.fromLTWH(
            ((decoration.width == 0) == 0)
              ? indicator.left
              : indicator.center.dx - (( decoration.width > 0 ? decoration.width :  0) / 2),
            indicator.bottom - borderSide.width,
            decoration.width > 0 ? decoration.width : indicator.width,
            borderSide.width,
        );
    }

    // Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    //     assert(rect != null);
    //     assert(textDirection != null);
    //     final Rect indicator = insets.resolve(textDirection).deflateRect(rect);
    //     //Take intermediate coordinates
    //     double cw = (indicator.left + indicator.right) / 2;
    //
    //     // double cw = (indicator.left + indicator.right)/2 - decoration.width/2;
    //
    //     print('cw----${cw}');
    //
    //     // return Rect.fromLTWH(indicator.left,
    //     //   indicator.bottom - borderSide.width, decoration.width, borderSide.width);
    //     return Rect.fromLTWH(
    //         cw,
    //         indicator.bottom - cw,
    //         decoration.width > 0 ? decoration.width : cw,
    //         borderSide.width,
    //     );
    // }

    // Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    //     assert(rect != null);
    //     assert(textDirection != null);
    //     final Rect indicator = insets.resolve(textDirection).deflateRect(rect);
    //     return Rect.fromLTWH(
    //         indicator.left,
    //         indicator.bottom - borderSide.width,
    //         decoration.width > 0 ? decoration.width : indicator.width,
    //         borderSide.width,
    //     );
    //
    // }
}
