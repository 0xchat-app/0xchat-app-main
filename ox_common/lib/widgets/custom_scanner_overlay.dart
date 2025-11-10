import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';

class CustomScannerOverlay extends StatelessWidget {
  const CustomScannerOverlay({
    super.key,
    required this.cutOutSize,
    this.verticalOffset = 0,
    this.borderColor = Colors.white,
    this.overlayColor = Colors.black45,
    this.cornerLength,
    this.borderWidth,
  });

  final double cutOutSize;
  final double verticalOffset;
  final Color borderColor;
  final Color overlayColor;
  final double? cornerLength;
  final double? borderWidth;

  @override
  Widget build(BuildContext context) {
    final double resolvedCornerLength = cornerLength ?? Adapt.px(24);
    final double resolvedBorderWidth = borderWidth ?? Adapt.px(4);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;
        final double overlaySize = math.min(
          cutOutSize,
          math.min(width, height),
        );
        double left = (width - overlaySize) / 2;
        double top = (height - overlaySize) / 2 - verticalOffset;
        left = left.clamp(0.0, math.max(0.0, width - overlaySize));
        top = top.clamp(0.0, math.max(0.0, height - overlaySize));

        return Stack(
          children: [
            CustomPaint(
              size: Size(width, height),
              painter: _ScannerOverlayBackgroundPainter(
                left: left,
                top: top,
                cutOutSize: overlaySize,
                overlayColor: overlayColor,
              ),
            ),
            _CornerBorder(
              top: top,
              left: left,
              size: resolvedCornerLength,
              border: Border(
                top: BorderSide(color: borderColor, width: resolvedBorderWidth),
                left: BorderSide(color: borderColor, width: resolvedBorderWidth),
              ),
            ),
            _CornerBorder(
              top: top,
              right: left,
              size: resolvedCornerLength,
              border: Border(
                top: BorderSide(color: borderColor, width: resolvedBorderWidth),
                right: BorderSide(color: borderColor, width: resolvedBorderWidth),
              ),
            ),
            _CornerBorder(
              top: top + overlaySize - resolvedCornerLength,
              left: left,
              size: resolvedCornerLength,
              border: Border(
                bottom: BorderSide(color: borderColor, width: resolvedBorderWidth),
                left: BorderSide(color: borderColor, width: resolvedBorderWidth),
              ),
            ),
            _CornerBorder(
              top: top + overlaySize - resolvedCornerLength,
              right: left,
              size: resolvedCornerLength,
              border: Border(
                bottom: BorderSide(color: borderColor, width: resolvedBorderWidth),
                right: BorderSide(color: borderColor, width: resolvedBorderWidth),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CornerBorder extends StatelessWidget {
  const _CornerBorder({
    required this.size,
    required this.border,
    this.left,
    this.top,
    this.right,
  });

  final double size;
  final double? left;
  final double? top;
  final double? right;
  final Border border;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      right: right,
      child: SizedBox(
        width: size,
        height: size,
        child: DecoratedBox(
          decoration: BoxDecoration(border: border),
        ),
      ),
    );
  }
}

class _ScannerOverlayBackgroundPainter extends CustomPainter {
  const _ScannerOverlayBackgroundPainter({
    required this.left,
    required this.top,
    required this.cutOutSize,
    required this.overlayColor,
  });

  final double left;
  final double top;
  final double cutOutSize;
  final Color overlayColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Path overlayPath = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRect(Rect.fromLTWH(left, top, cutOutSize, cutOutSize));

    final Paint backgroundPaint = Paint()..color = overlayColor;
    canvas.drawPath(overlayPath, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant _ScannerOverlayBackgroundPainter oldDelegate) {
    return left != oldDelegate.left ||
        top != oldDelegate.top ||
        cutOutSize != oldDelegate.cutOutSize ||
        overlayColor != oldDelegate.overlayColor;
  }
}