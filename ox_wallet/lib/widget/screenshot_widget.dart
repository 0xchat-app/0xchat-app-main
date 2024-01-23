import 'dart:io';
import 'dart:ui'as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ox_common/log_util.dart';
import 'package:path_provider/path_provider.dart';

class ScreenshotWidget extends StatefulWidget {
  final Widget child;
  const ScreenshotWidget({super.key,required this.child});

  @override
  State<ScreenshotWidget> createState() => ScreenshotWidgetState();
}

class ScreenshotWidgetState extends State<ScreenshotWidget> {
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _repaintBoundaryKey,
      child: widget.child,
    );
  }

  Future<Uint8List?> takeScreenshot() async {
    try {
      if(_repaintBoundaryKey.currentContext != null){
        RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage();
        ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        return byteData?.buffer.asUint8List();
      }
    } catch (e,s) {
      LogUtil.e('Screenshot failure: $e\r\n$s');
      return null;
    }
  }

  Future<String?> saveScreenshotToFile() async {
    try {
      Uint8List? screenshotData = await takeScreenshot();
      if (screenshotData == null) return null;
      final directory = await getApplicationCacheDirectory();
      final imagePath = '${directory.path}/screenshot_${DateTime.now().millisecondsSinceEpoch}.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(screenshotData);
      return imagePath;
    } catch (e,s) {
      LogUtil.e('Failed to save the screensaver: $e\r\n$s');
      return null;
    }
  }
}
